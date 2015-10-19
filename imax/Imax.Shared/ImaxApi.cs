using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Imax.Shared
{
    public class ImaxApi
    {
        private const string ApiUrl = "https://cabinet.planetakino.ua/mapi/2";

        private const string CitiesCommand = "/cities";

        private const string RegisterCommand = "/register";

        private const string LoginCommand = "/login";

        private const string ProfileCommand = "/profile";

        public static async Task<CitiesResponse> GetCities()
        {
            try
            {
                var responsePayload = await SendGetRequest(CitiesCommand, new WebHeaderCollection());
                var xdoc = XDocument.Parse(responsePayload);
                var responseElement = xdoc.Element("response");
                // ReSharper disable PossibleNullReferenceException
                var code = responseElement.Attribute("code").Value;
                var citiesElement = responseElement.Element("cities");
                var cities = citiesElement.Elements("city").Select(e =>
                {
                    var id = e.Attribute("id").Value;
                    var cid = e.Attribute("cid").Value;
                    var name = e.Value;
                    return new City(id, cid, name);
                }).ToArray();
                // ReSharper restore PossibleNullReferenceException
                return new CitiesResponse(code == "1", cities);
            }
            catch (Exception)
            {
                return new CitiesResponse(false);
            }
        }

        public static async Task<RegisterResponse> Register(RegisterRequest registerRequest)
        {
            try
            {
                var responsePayload = await SendPostRequest(RegisterCommand, registerRequest.GetEncodedBody());
                var xdoc = XDocument.Parse(responsePayload);
                var responseElement = xdoc.Element("response");
                // ReSharper disable PossibleNullReferenceException
                var code = responseElement.Attribute("code").Value;
                // ReSharper restore PossibleNullReferenceException
                var message = responseElement.Attribute("message").Value;
                return new RegisterResponse(code == "1", message);
            }
            catch (Exception)
            {
                return new RegisterResponse(false);
            }
        }

        public static async Task<LoginResponse> Login(LoginRequest loginRequest)
        {
            try
            {
                var responsePayload = await SendPostRequest(LoginCommand, loginRequest.GetEncodedBody());
                var xdoc = XDocument.Parse(responsePayload);
                var responseElement = xdoc.Element("response");
                // ReSharper disable PossibleNullReferenceException
                var code = responseElement.Attribute("code").Value;
                var token = responseElement.Element("authToken").Value;
                // ReSharper restore PossibleNullReferenceException
                return new LoginResponse(code == "1", token);
            }
            catch (Exception)
            {
                return new LoginResponse(false);
            }
        }

        public static async Task<ProfileResponse> Profile(ProfileRequest profileRequest)
        {
            try
            {
                var headers = new WebHeaderCollection
                {
                    ["Auth-Token"] = profileRequest.AuthToken,
                    ["Image-Scale"] = "2.0"
                };
                var responsePayload = await SendGetRequest(ProfileCommand, headers);
                var xdoc = XDocument.Parse(responsePayload);
                var responseElement = xdoc.Element("response");
                // ReSharper disable PossibleNullReferenceException
                var code = responseElement.Attribute("code").Value;
                var profileElement = responseElement.Element("profile");
                var userId = profileElement.Element("userId").Value;
                var firstName = profileElement.Element("firstName").Value;
                var middleName = profileElement.Element("middleName").Value;
                var lastName = profileElement.Element("lastName").Value;
                var customerCard = profileElement.Element("customerCard").Value;
                var bonuses = profileElement.Element("bonuses").Value;
                // ReSharper restore PossibleNullReferenceException
                var customerName = new CustomerName(firstName, middleName, lastName);
                return new ProfileResponse(code == "0", userId, customerName, customerCard, bonuses);
            }
            catch (Exception)
            {
                return new ProfileResponse(false);
            }
        }

        private static async Task<string> SendGetRequest(string command, WebHeaderCollection headers)
        {
            var uri = new Uri(string.Concat(ApiUrl, command));
            var request = WebRequest.CreateHttp(uri);
            request.Method = "GET";
            foreach (var key in headers.AllKeys)
            {
                request.Headers[key] = headers[key];
            }
            using (var response = await request.GetResponseAsync())
            using (var responseStream = response.GetResponseStream())
            {
                var bodyData = new byte[response.ContentLength];
                await ReadFromStream(responseStream, bodyData);
                var bodyPayload = Encoding.UTF8.GetString(bodyData, 0, bodyData.Length);
                return bodyPayload;
            }
        }

        private static async Task<string> SendPostRequest(string command, string encodedBody)
        {
            var uri = new Uri(string.Concat(ApiUrl, command));
            var request = WebRequest.CreateHttp(uri);
            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";
            request.Headers["Accept-Language"] = "uk-ua";
            request.Headers["Image-Scale"] = "2.0";
            using (var requestStream = await request.GetRequestStreamAsync())
            {
                var bodyData = Encoding.UTF8.GetBytes(encodedBody);
                requestStream.Write(bodyData, 0, bodyData.Length);
            }
            using (var response = await request.GetResponseAsync())
            using (var responseStream = response.GetResponseStream())
            {
                var bodyData = new byte[response.ContentLength];
                await ReadFromStream(responseStream, bodyData);
                var bodyPayload = Encoding.UTF8.GetString(bodyData, 0, bodyData.Length);
                return bodyPayload;
            }
        }

        private static async Task ReadFromStream(Stream stream, byte[] data)
        {
            var totalReaded = 0;
            while ((totalReaded += await stream.ReadAsync(data, totalReaded, data.Length - totalReaded)) < data.Length)
            {
            }
        }
    }
}