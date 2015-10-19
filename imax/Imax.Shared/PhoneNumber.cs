namespace Imax.Shared
{
    public class PhoneNumber
    {
        private string number;

        public static PhoneNumber Parse(string numberString)
        {
            return new PhoneNumber {number = numberString};
        }

        public override string ToString()
        {
            return number;
        }
    }
}