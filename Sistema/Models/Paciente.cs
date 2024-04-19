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
        public string Peso { get; set; }
        public string Alergias { get; set; }
        public bool Estudio_medico { get; set; }
        public bool Consulta { get; set; }
        public int UserId { get; set; }
        public virtual Users User { get; set; }

    }
}
