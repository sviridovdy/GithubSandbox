using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Serialization;

namespace Imax.Console
{
    public class NativeStorageProvider
    {
        private const string AuthTokenKey = "AuthToken";

        private readonly Dictionary<string, string> dictionary;

        private readonly string filePath;

        public NativeStorageProvider()
        {
            filePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory), "imax.settings");

            try
            {
                using (var stream = new FileStream(filePath, FileMode.Open))
                {
                    dictionary = ((Setting[]) new XmlSerializer(typeof (Setting[])).Deserialize(stream)).ToDictionary(s => s.Key, s => s.Value);
                }
            }
            catch (Exception)
            {
                dictionary = new Dictionary<string, string>();
            }
        }

        public string AuthToken
        {
            get { return dictionary[AuthTokenKey]; }
            set
            {
                dictionary[AuthTokenKey] = value;
                SaveSettings();
            }
        }

        private void SaveSettings()
        {
            using (var stream = new FileStream(filePath, FileMode.OpenOrCreate))
            {
                new XmlSerializer(typeof (Setting[])).Serialize(stream, dictionary.Select(kv => new Setting(kv)).ToArray());
            }
        }

        public class Setting
        {
            public Setting()
            {
                
            }

            public Setting(KeyValuePair<string, string> keyValuePair)
            {
                Key = keyValuePair.Key;
                Value = keyValuePair.Value;
            }

            public string Key { get; set; }

            public string Value { get; set; }
        }
    }
}