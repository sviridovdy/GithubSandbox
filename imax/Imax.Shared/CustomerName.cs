namespace Imax.Shared
{
    public class CustomerName
    {
        public CustomerName(string firstName, string middleName, string lastName)
        {
            FirstName = firstName;
            MiddleName = middleName;
            LastName = lastName;
            FullName = LastName + " " + FirstName + (string.IsNullOrEmpty(MiddleName) ? string.Empty : " " + MiddleName);
        }

        public string FirstName { get; }

        public string MiddleName { get; }

        public string LastName { get; }

        public string FullName { get; }
    }
}
