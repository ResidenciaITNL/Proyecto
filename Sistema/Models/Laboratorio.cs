using System.ComponentModel.DataAnnotations;

namespace Sistema.Models
{
    public class Laboratorio
    {
        [Key]
        public int? LaboratorioId { get; set; }
        public string tipo { get; set; }
        public Guid guid { get; set; } = System.Guid.NewGuid();
        public DateTime fecha { get; set; } = DateTime.Now;
        public string? objetoName { get; set; }
        public string? objetoData { get; set; }
        public int PacienteId { get; set; }
        public virtual Paciente? Paciente { get; set; }
        public int? UserId { get; set; }
        public virtual Users? User { get; set; }
    }
}
