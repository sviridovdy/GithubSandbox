namespace Imax.Shared
{
    public class City
    {
        public City(string id, string cid, string name)
        {
            Id = id;
            Cid = cid;
            Name = name;
        }

        public string Id { get; private set; }

        public string Cid { get; private set; }

        public string Name { get; private set; }
    }
}
