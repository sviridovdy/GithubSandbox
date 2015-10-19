namespace Imax.Console
{
    internal class ConsoleCredentialsProvider
    {
        private string login;

        private string password;

        public string Login => login ?? (login = System.Console.ReadLine());

        public string Password => password ?? (password = System.Console.ReadLine());
    }
}