using Windows.UI.Xaml;
using Windows.UI.Xaml.Input;

namespace Imax.Universal
{
    public sealed partial class UnknownDeviceTypePage
    {
        public UnknownDeviceTypePage()
        {
            InitializeComponent();
        }

        private void UIElement_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            Application.Current.Exit();
        }
    }
}