using Windows.Storage;
using Windows.UI.Xaml.Navigation;
using Imax.Shared;

namespace Imax.WindowsPhone
{
    public sealed partial class ProfilePage
    {
        public ProfilePage()
        {
            InitializeComponent();
        }

        protected override async void OnNavigatedTo(NavigationEventArgs e)
        {
            if (e.NavigationMode == NavigationMode.New)
            {
                var authToken = (string) ApplicationData.Current.LocalSettings.Values["AuthToken"];
                var cityId = (string) ApplicationData.Current.LocalSettings.Values["CityId"];
                var profileRequest = new ProfileRequest(cityId, authToken);
                var profileResponse = await ImaxApi.Profile(profileRequest);
                CustomerNameBlock.Text = profileResponse.CustomerName.FullName;
                CustomerIdBlock.Text = profileResponse.UserId;
                CardNumberBlock.Text = profileResponse.CustomerCard;
                BonusesBlock.Text = profileResponse.Bonuses;
            }
        }
    }
}