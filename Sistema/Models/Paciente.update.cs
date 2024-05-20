﻿namespace Sistema.Models
{
    public class PacienteUpdate
    {
        public string? Nombre { get; set; }
        public string? Apellido { get; set; }
        public int? Edad { get; set; }
        public string? Sexo { get; set; }
        public decimal? Estatura { get; set; }
        public decimal? Peso { get; set; }
        public string? Alergias { get; set; }
        public bool? Estudio_medico { get; set; }
        public bool? Consulta { get; set; }
    }
}
