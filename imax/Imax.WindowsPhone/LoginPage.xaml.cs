using System;
using Windows.Storage;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Navigation;
using Imax.Shared;

namespace Imax.WindowsPhone
{
    public sealed partial class LoginPage
    {
        public LoginPage()
        {
            InitializeComponent();
            NavigationCacheMode = NavigationCacheMode.Required;
        }

        protected override async void OnNavigatedTo(NavigationEventArgs e)
        {
            if (e.NavigationMode == NavigationMode.New)
            {
                var cities = await ImaxApi.GetCities();
                CitiesBox.ItemsSource = cities.Cities;
            }
        }

        private void ValidateInput()
        {
            LoginButton.IsEnabled = !(string.IsNullOrEmpty(LoginBox.Text) || string.IsNullOrEmpty(PasswordBox.Password) || CitiesBox.SelectedIndex == -1);
        }

        private void TextBox_OnTextChanged(object sender, TextChangedEventArgs e)
        {
            ValidateInput();
        }

        private void PasswordBox_OnPasswordChanged(object sender, RoutedEventArgs e)
        {
            ValidateInput();
        }

        private void Selector_OnSelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ValidateInput();
        }

        private async void LoginButton_OnClick(object sender, RoutedEventArgs e)
        {
            LoginButton.IsEnabled = false;

            var city = (City) CitiesBox.SelectedItem;
            var registerRequest = new RegisterRequest(LoginBox.Text, PasswordBox.Password, city.Id);
            var response = await ImaxApi.Register(registerRequest);
            if (response.Succeeded)
            {
                ApplicationData.Current.LocalSettings.Values.Add("AuthToken", response.Token);
                ApplicationData.Current.LocalSettings.Values.Add("CityId", city.Id);
                Frame.Navigate(typeof (ProfilePage));
            }
            else
            {
                await new MessageDialog("Sorry, an error occured.").ShowAsync();
                LoginButton.IsEnabled = true;
            }
        }
    }
}