namespace Sistema.Models.Lab
{
    public class PruebaDeEmbarazo
    {
        public string NombrePaciente { get; set; }
        public string Fecha { get; set; } = DateTime.Now.ToShortDateString();
        public string Edad { get; set; }
        public string Folio { get; set; } = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();
        public string Resultado { get; set; }
    }
}
