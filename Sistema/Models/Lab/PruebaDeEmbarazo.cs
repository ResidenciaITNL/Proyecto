namespace Sistema.Models.Lab
{
    public class PruebaDeEmbarazo
    {
        public int PacienteId { get; set; }
        public string? NombrePaciente { get; set; }
        public string Fecha { get; set; } = DateTime.Now.ToShortDateString();
        public string? edad { get; set; }
        public string Folio { get; set; } = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();
        public string Resultado { get; set; }
    }
}
