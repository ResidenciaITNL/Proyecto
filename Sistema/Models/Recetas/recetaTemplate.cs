namespace Sistema.Models.Recetas
{
    public class recetaTemplate
    {
        public string Nombre { get; set; }
        public string DateNow { get; set; } = DateTime.Now.ToShortDateString();
        public string Titulo { get; set; }
        public string token { get; set; }
        public string Cedula { get; set; }
        public string Col { get; set; }
        public string calle { get; set; }
        public string CP { get; set; }
        public string Municipio { get; set; }
        public string Estado { get; set; }
        public string Nombre_Paciente { get; set; }
        public string Contenido { get; set; }
        public string Edad { get; set; }
        public string Peso { get; set; }
        public string Altura { get; set; }
    }
}
