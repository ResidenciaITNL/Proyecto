﻿namespace Sistema.Models.Lab
{
    public class Antidoping5
    {
        public int PacienteId { get; set; }
        public string? NombrePaciente { get; set; }
        public string Fecha { get; set; } = DateTime.Now.ToShortDateString();
        public string? edad { get; set; }
        //timestamp
        public string Folio { get; set; } = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();
        public string VN_M { get; set; }
        public string VN_C { get; set; }
        public string VN_A { get; set; }
        public string VN_ME { get; set; }
        public string VN_O { get; set; }
        public string V_M { get; set; }
        public string V_C { get; set; }
        public string V_A { get; set; }
        public string V_ME { get; set; }
        public string V_O { get; set; }
    }
}
