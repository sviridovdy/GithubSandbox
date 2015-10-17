namespace Imax.Shared
{
    public class RegisterRequest
    {
        public RegisterRequest(string login, string password)
        {
            Login = login;
            Password = password;
        }

        public string Login { get; }

        public string Password { get; }
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