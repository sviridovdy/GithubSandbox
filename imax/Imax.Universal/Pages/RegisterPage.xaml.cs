using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Windows.System;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Navigation;
using Imax.Shared;

namespace Imax.Universal.Pages
{
    public sealed partial class RegisterPage
    {
        public RegisterPage()
        {
            InitializeComponent();
            NavigationCacheMode = NavigationCacheMode.Required;
            BirthdatePicker.MaxYear = new DateTimeOffset(DateTime.Today);
        }
        
        private async Task TryToSetUserNameOrFocusInput()
        {
            var users = await User.FindAllAsync();
            if (users.Count == 1)
            {
                var list = new List<string>
                {
                    KnownUserProperties.FirstName,
                    KnownUserProperties.LastName
                };
                var propertySet = await users[0].GetPropertiesAsync(list);
                NameBox.Text = (string) propertySet[KnownUserProperties.FirstName];
                SurnameBox.Text = (string) propertySet[KnownUserProperties.LastName];
            }

            if (string.IsNullOrEmpty(NameBox.Text))
            {
                NameBox.Focus(FocusState.Programmatic);
            }
            else if (string.IsNullOrEmpty(SurnameBox.Text))
            {
                SurnameBox.Focus(FocusState.Programmatic);
            }
        }

        private bool ValidateInput()
        {
            if (string.IsNullOrEmpty(NameBox.Text) || string.IsNullOrEmpty(SurnameBox.Text))
            {
                return false;
            }

            if (!(MaleGenderBox.IsChecked.GetValueOrDefault() ^ FemaleGenderBox.IsChecked.GetValueOrDefault()))
            {
                return false;
            }

            if (PhoneNumberBox.Text.Length != 10 || !PhoneNumberBox.Text.All(char.IsDigit))
            {
                return false;
            }

            if (string.IsNullOrEmpty(EmailBox.Text))
            {
                return false;
            }

            if (PasswordBox.Password != PasswordRepeatBox.Password || string.IsNullOrEmpty(PasswordBox.Password))
            {
                return false;
            }

            return true;
        }

        private async void Register()
        {
            RegisterButton.IsEnabled = false;

            var name = new CustomerName(NameBox.Text, SurnameBox.Text);
            var gender = MaleGenderBox.IsChecked.GetValueOrDefault() ? Gender.Male : Gender.Female;
            var countryCode = CountryCodeBox.SelectedIndex == 0 ? "+38" : "+375";
            var phoneNumber = PhoneNumber.Parse($"{countryCode}{PhoneNumberBox.Text}");
            var registerRequest = new RegisterRequest(name, gender, BirthdatePicker.Date.Date, phoneNumber, EmailBox.Text, PasswordBox.Password);
            var response = await ImaxApi.Register(registerRequest);
            if (response.Succeeded)
            {
                await new MessageDialog("Done").ShowAsync();
            }
            else
            {
                await new MessageDialog("Failed").ShowAsync();
            }

            RegisterButton.IsEnabled = true;
        }

        private void GenderButton_OnChecked(object sender, RoutedEventArgs e)
        {
            RegisterButton.IsEnabled = ValidateInput();
        }

        private void InputBox_OnTextChanged(object sender, TextChangedEventArgs e)
        {
            RegisterButton.IsEnabled = ValidateInput();
        }

        private void PasswordBox_OnPasswordChanged(object sender, RoutedEventArgs e)
        {
            RegisterButton.IsEnabled = ValidateInput();
        }

        private void InputBox_OnKeyUp(object sender, KeyRoutedEventArgs e)
        {
            if (sender == PhoneNumberBox)
            {
                if (PhoneNumberBox.Text.Length == 10)
                {
                    EmailBox.Focus(FocusState.Programmatic);
                    return;
                }
            }

            if (e.Key == VirtualKey.Enter)
            {
                if (sender == NameBox)
                {
                    SurnameBox.Focus(FocusState.Programmatic);
                }
                if (sender == SurnameBox)
                {
                    CommandBar.Focus(FocusState.Programmatic);
                }
                else if (sender == EmailBox)
                {
                    PasswordBox.Focus(FocusState.Programmatic);
                }
                else if (sender == PasswordBox)
                {
                    PasswordRepeatBox.Focus(FocusState.Programmatic);
                }
                else if (sender == PasswordRepeatBox)
                {
                    CommandBar.Focus(FocusState.Programmatic);
                }
            }
        }

        private void RegisterButton_OnClick(object sender, RoutedEventArgs e)
        {
            Register();
        }

        private async void RegisterPage_OnLoaded(object sender, RoutedEventArgs e)
        {
            await TryToSetUserNameOrFocusInput();
        }
    }
}