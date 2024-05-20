namespace Sistema.Models.Recetas
{
    public class Subject
    {
        public string name { get; set; }
        public string? identifier { get; set; }
        public string? rfc { get; set; }
        public string? curp { get; set; }
        public string? telephone { get; set; }
        public string? email { get; set; }
        public gender? gender { get; set; }
        public float? weight { get; set; }
        public float? height { get; set; }
        public DateOnly? birthDate { get; set; }
        public float temperature { get; set; }
        public Address? address { get; set; }

    }
}
