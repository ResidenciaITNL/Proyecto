using System.ComponentModel.DataAnnotations;

namespace Sistema.Models
{
    public class Paciente
    {
        [Key]
        public int PacienteId { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public int Edad { get; set; }
        public string Sexo { get; set; }
        public decimal Estatura { get; set; }
        public decimal Peso { get; set; }
        public string Alergias { get; set; }
        public decimal? temperatura { get; set; }
        public decimal? presion { get; set; }
        public string telefono { get; set; }
        public bool Estudio_medico { get; set; }
        public string? Estudio_medico_detalle { get; set; }
        public bool Consulta { get; set; }
        public bool isDeleted { get; set; } = false;
        public int? UserId { get; set; }
        public virtual Users? User { get; set; }
        public virtual ICollection<RecetasTB> RecetasTB { get; set; }

    }
}
