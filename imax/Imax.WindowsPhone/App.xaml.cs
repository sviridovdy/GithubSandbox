using Windows.ApplicationModel.Activation;
using Windows.Globalization;
using Windows.Storage;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Media.Animation;
using Windows.UI.Xaml.Navigation;

namespace Imax.WindowsPhone
{
    public sealed partial class App
    {
        private TransitionCollection transitions;

        public App()
        {
            InitializeComponent();
        }

        protected override void OnLaunched(LaunchActivatedEventArgs e)
        {
            var rootFrame = Window.Current.Content as Frame;
            if (rootFrame == null)
            {
                rootFrame = new Frame
                {
                    CacheSize = 1,
                    Language = ApplicationLanguages.Languages[0]
                };
                Window.Current.Content = rootFrame;
            }

            if (rootFrame.Content == null)
            {
                if (rootFrame.ContentTransitions != null)
                {
                    transitions = new TransitionCollection();
                    foreach (var c in rootFrame.ContentTransitions)
                    {
                        transitions.Add(c);
                    }
                }

                rootFrame.ContentTransitions = null;
                rootFrame.Navigated += RootFrame_FirstNavigated;
                ContinueStart(rootFrame);
            }

            Window.Current.Activate();
        }

        private void ContinueStart(Frame rootFrame)
        {
            if (ApplicationData.Current.LocalSettings.Values.ContainsKey("AuthToken"))
            {
                rootFrame.Navigate(typeof (ProfilePage));
            }
            else
            {
                rootFrame.Navigate(typeof (LoginPage));
            }
        }

        private void RootFrame_FirstNavigated(object sender, NavigationEventArgs e)
        {
            var rootFrame = (Frame)sender;
            rootFrame.ContentTransitions = transitions ?? new TransitionCollection { new NavigationThemeTransition() };
            rootFrame.Navigated -= RootFrame_FirstNavigated;
        }
    }
}