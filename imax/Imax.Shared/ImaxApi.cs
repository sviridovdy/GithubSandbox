using System;
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

        private const string LoginCommand = "/login";

        private const string ProfileCommand = "/profile";

        public static async Task<CitiesResponse> GetCities()
        {
            try
            {
                var uri = new Uri(string.Concat(ApiUrl, CitiesCommand));
                var request = WebRequest.CreateHttp(uri);
                using (var response = await request.GetResponseAsync())
                using (var responseStream = response.GetResponseStream())
                {
                    var bodyData = new byte[response.ContentLength];
                    responseStream.Read(bodyData, 0, bodyData.Length);
                    var bodyPayload = Encoding.UTF8.GetString(bodyData, 0, bodyData.Length);
                    var xdoc = XDocument.Parse(bodyPayload);
                    var responseElement = xdoc.Element("response");
                    var code = responseElement.Attribute("code").Value;
                    var citiesElement = responseElement.Element("cities");
                    var cities = citiesElement.Elements("city").Select(e =>
                    {
                        var id = e.Attribute("id").Value;
                        var cid = e.Attribute("cid").Value;
                        var name = e.Value;
                        return new City(id, cid, name);
                    }).ToArray();
                    return new CitiesResponse(code == "1", cities);
                }
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
                var uri = new Uri(string.Concat(ApiUrl, LoginCommand));
                var request = WebRequest.CreateHttp(uri);
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.Headers["cityId"] = registerRequest.CityId;
                request.Headers["Accept-Language"] = "uk-ua";
                request.Headers["Image-Scale"] = "2.0";
                request.Headers["Cookie"] = "__cfduid=de7fd4ad6b6dffdd54501233";
                request.Headers["Cookie2"] = "$Version=1";
                using (var requestStream = await request.GetRequestStreamAsync())
                {
                    var bodyPayload = $"login={registerRequest.Login}&password={registerRequest.Password}&deviceId=1";
                    var bodyData = Encoding.UTF8.GetBytes(bodyPayload);
                    requestStream.Write(bodyData, 0, bodyData.Length);
                }
                using (var response = await request.GetResponseAsync())
                using (var responseStream = response.GetResponseStream())
                {
                    var bodyData = new byte[response.ContentLength];
                    responseStream.Read(bodyData, 0, bodyData.Length);
                    var bodyPayload = Encoding.UTF8.GetString(bodyData, 0, bodyData.Length);
                    var xdoc = XDocument.Parse(bodyPayload);
                    var responseElement = xdoc.Element("response");
                    var code = responseElement.Attribute("code").Value;
                    var token = responseElement.Element("authToken").Value;
                    return new RegisterResponse(code == "1", token);
                }
            }
            catch (Exception)
            {
                return new RegisterResponse(false);
            }
        }

        public static async Task<ProfileResponse> Profile(ProfileRequest profileRequest)
        {
            try
            {
                var uri = new Uri(string.Concat(ApiUrl, ProfileCommand));
                var request = WebRequest.CreateHttp(uri);
                request.Method = "GET";
                request.Headers["cityId"] = profileRequest.CityId;
                request.Headers["Auth-Token"] = profileRequest.AuthToken;
                request.Headers["Image-Scale"] = "2.0";
                using (var response = await request.GetResponseAsync())
                using (var responseStream = response.GetResponseStream())
                {
                    var bodyData = new byte[response.ContentLength];
                    responseStream.Read(bodyData, 0, bodyData.Length);
                    var bodyPayload = Encoding.UTF8.GetString(bodyData, 0, bodyData.Length);
                    var xdoc = XDocument.Parse(bodyPayload);
                    var responseElement = xdoc.Element("response");
                    var code = responseElement.Attribute("code").Value;
                    var profileElement = responseElement.Element("profile");
                    var userId = profileElement.Element("userId").Value;
                    var firstName = profileElement.Element("firstName").Value;
                    var middleName = profileElement.Element("middleName").Value;
                    var lastName = profileElement.Element("lastName").Value;
                    var customerCard = profileElement.Element("customerCard").Value;
                    var bonuses = profileElement.Element("bonuses").Value;
                    var customerName = new CustomerName(firstName, middleName, lastName);
                    return new ProfileResponse(code == "0", userId, customerName, customerCard, bonuses);
                }
            }
            catch (Exception)
            {
                return new ProfileResponse(false);
            }
        }
    }
}