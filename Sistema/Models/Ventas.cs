﻿using System.ComponentModel.DataAnnotations;

namespace Sistema.Models
{
    public class Ventas
    {
        [Key]
        public int? VentaId { get; set; }
        public string Fecha { get; set; } = DateTime.Now.ToShortDateString();
        public string Folio { get; set; } = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();
        public decimal Total { get; set; }
        public string Contenido { get; set; }
        public int? PacienteId { get; set; }
        public virtual Paciente? Paciente { get; set; }
        public int? UserId { get; set; }
        public virtual Users? User { get; set; }

    }
}
