namespace Sistema.Models.Lab
{
    public class Antidoping3
    {
        public string NombrePaciente { get; set; }
        public string Fecha { get; set; } = DateTime.Now.ToShortDateString();
        public string Edad { get; set; }
        //timestamp
        public string Folio { get; set; } = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();
        public string RV_M { get; set; }
        public string RV_C { get; set; }
        public string RV_A { get; set; }
        public string R_M { get; set; }
        public string R_C { get; set; }
        public string R_A { get; set; }
    }
}
