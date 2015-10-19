using System;
using System.Collections.Generic;
using System.Net.Http;

namespace Imax.Shared
{
    public class RegisterRequest
    {
        private readonly CustomerName name;

        private readonly Gender gender;

        private DateTime birthdate;

        private readonly PhoneNumber number;

        private readonly string email;

        private readonly string password;

        public RegisterRequest(CustomerName name, Gender gender, DateTime birthdate, PhoneNumber number, string email, string password)
        {
            this.name = name;
            this.gender = gender;
            this.birthdate = birthdate;
            this.number = number;
            this.email = email;
            this.password = password;
        }

        public string GetEncodedBody()
        {
            var parameters = new[]
            {
                new KeyValuePair<string, string>("name", name.LastName),
                new KeyValuePair<string, string>("firstname", name.FirstName),
                new KeyValuePair<string, string>("gender", gender == Gender.Male ? "male" : "female"),
                new KeyValuePair<string, string>("dob", birthdate.ToString("yyyy-MM-dd")),
                new KeyValuePair<string, string>("phone", number.ToString()),
                new KeyValuePair<string, string>("email", email),
                new KeyValuePair<string, string>("password", password),
            };
            var form = new FormUrlEncodedContent(parameters);
            return form.ReadAsStringAsync().Result;
        }
    }

    public class LoginRequest
    {
        private readonly string login;

        private readonly string password;

        public LoginRequest(string login, string password)
        {
            this.login = login;
            this.password = password;
        }

        public string GetEncodedBody()
        {
            var parameters = new[]
            {
                new KeyValuePair<string, string>("login", login),
                new KeyValuePair<string, string>("password", password),
                new KeyValuePair<string, string>("deviceId", "1")
            };
            var form = new FormUrlEncodedContent(parameters);
            return form.ReadAsStringAsync().Result;
        }
    }

    public class ProfileRequest
    {
        public ProfileRequest(string authToken)
        {
            AuthToken = authToken;
        }

        public string AuthToken { get; }
    }
}