namespace Imax.Shared
{
    public class BaseResponse
    {
        protected BaseResponse(bool succeeded)
        {
            Succeeded = succeeded;
        }

        public bool Succeeded { get; }
    }

    public class CitiesResponse : BaseResponse
    {
        public CitiesResponse(bool succeeded, City[] cities = null) : base(succeeded)
        {
            Cities = cities;
        }

        public City[] Cities { get; }
    }

    public class RegisterResponse : BaseResponse
    {
        public RegisterResponse(bool succeeded, string token = null) : base(succeeded)
        {
            Token = token;
        }

        public string Token { get; }
    }

    public class ProfileResponse : BaseResponse
    {
        public ProfileResponse(bool succeeded, string userId = null, CustomerName customerName = null, string customerCard = null, string bonuses = null) : base(succeeded)
        {
            UserId = userId;
            CustomerName = customerName;
            CustomerCard = customerCard;
            Bonuses = bonuses;
        }

        public string UserId { get; }

        public CustomerName CustomerName { get; }

        public string CustomerCard { get; }

        public string Bonuses { get; }
    }
}