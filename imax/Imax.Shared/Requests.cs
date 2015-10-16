namespace Imax.Shared
{
    public class RegisterRequest
    {
        public RegisterRequest(string login, string password, string cityId)
        {
            Login = login;
            Password = password;
            CityId = cityId;
        }

        public string Login { get; }

        public string Password { get; }

        public string CityId { get; }
    }

    public class ProfileRequest
    {
        public ProfileRequest(string cityId, string authToken)
        {
            CityId = cityId;
            AuthToken = authToken;
        }

        public string CityId { get; }

        public string AuthToken { get; }
    }
}