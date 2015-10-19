using System;
using System.Net.NetworkInformation;
using Windows.Storage;
using Windows.System;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Navigation;
using Imax.Shared;

namespace Imax.Universal.Pages
{
    public sealed partial class LoginPage
    {
        public LoginPage()
        {
            InitializeComponent();
            NavigationCacheMode = NavigationCacheMode.Required;
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            if (e.NavigationMode == NavigationMode.New)
            {
            }
        }

        private void ValidateInput()
        {
            LoginButton.IsEnabled = !(string.IsNullOrEmpty(LoginBox.Text) || string.IsNullOrEmpty(PasswordBox.Password));
        }

        private async void Login()
        {
            LoginButton.IsEnabled = false;

            var registerRequest = new LoginRequest(LoginBox.Text, PasswordBox.Password);
            var response = await ImaxApi.Login(registerRequest);
            if (response.Succeeded)
            {
                ApplicationData.Current.LocalSettings.Values.Add("AuthToken", response.Token);
                Frame.Navigate(typeof(ProfilePage));
            }
            else
            {
                await new MessageDialog("Sorry, an error occured.").ShowAsync();
                LoginButton.IsEnabled = true;
            }
        }

        private void LoginBox_OnTextChanged(object sender, TextChangedEventArgs e)
        {
            ValidateInput();
        }

        private void LoginBox_OnKeyUp(object sender, KeyRoutedEventArgs e)
        {
            if (e.Key == VirtualKey.Enter)
            {
                PasswordBox.Focus(FocusState.Programmatic);
            }
        }

        private void PasswordBox_OnPasswordChanged(object sender, RoutedEventArgs e)
        {
            ValidateInput();
        }

        private void PasswordBox_OnKeyUp(object sender, KeyRoutedEventArgs e)
        {
            if (e.Key == VirtualKey.Enter)
            {
                Login();
            }
        }

        private void LoginButton_OnClick(object sender, RoutedEventArgs e)
        {
            Login();
        }
    }
}