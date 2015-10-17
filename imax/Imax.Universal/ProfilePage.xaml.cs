using Windows.Storage;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Navigation;
using Imax.Shared;

namespace Imax.Universal
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
                var profileRequest = new ProfileRequest(authToken);
                var profileResponse = await ImaxApi.Profile(profileRequest);
                CustomerNameBlock.Text = profileResponse.CustomerName.FullName;
                CustomerIdBlock.Text = profileResponse.UserId;
                CardNumberBlock.Text = Ean13Generator.GenerateBarCode(profileResponse.CustomerCard);
                BonusesBlock.Text = profileResponse.Bonuses;
            }
        }

        private void SignOutButton_OnClick(object sender, RoutedEventArgs e)
        {
            ApplicationData.Current.LocalSettings.Values.Clear();
            Application.Current.Exit();
        }
    }
}