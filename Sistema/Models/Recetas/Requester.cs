namespace Sistema.Models.Recetas
{
    public enum gender
    {
        male,
        female,
        other,
        unknown
    }
    public class Requester
    {
        public string? identifier { get; set; }
        public string? title { get; set; }
        public string name { get; set; }
        public string? certSerial { get; set; } // URL de consulta del El del certificado público del médico(archivo.cer). Éste puede provenir del SAT o de alguna entidad diferente, como la AHM o secretaría de economía
        public string telephone { get; set; } // Número telefónico del médico(en formato internacional, +525844392754)
        public string? email { get; set; } // Dirección de correo electrónico del médico
        public Qualification qualification { get; set; }
        public gender gender { get; set; } // El género del méd
        public DateOnly birthDate { get; set; }
        public string? rfc { get; set; }
        public string? curp { get; set; }
        public Address address { get; set; }

    }
}
