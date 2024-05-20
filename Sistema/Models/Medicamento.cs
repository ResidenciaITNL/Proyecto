using System.ComponentModel.DataAnnotations;

namespace Sistema.Models
{
    public class Medicamento
    {
        [Key]
        public int? MedicamentoId { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public string? Imagen { get; set; }
        public DateTime FechaVencimiento { get; set; }

        public int Stock { get; set; }
        public decimal Precio { get; set; }
        public string Contenido { get; set; }
        public string unidad { get; set; }
        public bool? active { get; set; } = true;
        public int? UserId { get; set; }
        public virtual Users? User { get; set; }

    }
}
