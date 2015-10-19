using Windows.ApplicationModel.Activation;
using Windows.Storage;
using Windows.System.Profile;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Imax.Universal.Pages;

namespace Imax.Universal
{
    sealed partial class App
    {
        public static DeviceType DeviceType { get; private set; }

        public App()
        {
            InitializeComponent();
            switch (AnalyticsInfo.VersionInfo.DeviceFamily)
            {
                case "Windows.Desktop":
                    DeviceType = DeviceType.Desktop;
                    break;
                case "Windows.Mobile":
                    DeviceType = DeviceType.Mobile;
                    break;
                default:
                    DeviceType = DeviceType.Unknown;
                    break;
            }
        }

        protected override void OnLaunched(LaunchActivatedEventArgs e)
        {
            Frame rootFrame = Window.Current.Content as Frame;
            if (rootFrame == null)
            {
                rootFrame = new Frame();
                Window.Current.Content = rootFrame;
            }

            if (rootFrame.Content == null)
            {
                ContinueStart(rootFrame);
            }
            Window.Current.Activate();
        }

        private void ContinueStart(Frame rootFrame)
        {
            if (DeviceType == DeviceType.Unknown)
            {
                rootFrame.Navigate(typeof (UnknownDeviceTypePage));
            }
            else
            {
                if (ApplicationData.Current.LocalSettings.Values.ContainsKey("AuthToken"))
                {
                    rootFrame.Navigate(typeof (ProfilePage));
                }
                else
                {
                    rootFrame.Navigate(typeof (RegisterPage));
                }
            }
        }
    }
}