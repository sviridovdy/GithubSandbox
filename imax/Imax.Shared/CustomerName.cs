namespace Imax.Shared
{
    public class CustomerName
    {
        public CustomerName(string firstName, string lastName) : this(firstName, null, lastName)
        {
            FullName = $"{firstName} {lastName}";
        }

        public CustomerName(string firstName, string middleName, string lastName)
        {
            FirstName = firstName;
            MiddleName = middleName;
            LastName = lastName;
            FullName = $"{lastName} {firstName} {middleName}";
        }

        public string FirstName { get; }

        public string MiddleName { get; }

        public string LastName { get; }

        public string FullName { get; }
    }
}
