using System.ComponentModel.DataAnnotations;

namespace Sistema.Models
{
    public class RecetasTB
    {
        [Key]
        public int? RecetaId { get; set; }
        public Guid? Guid { get; set; } = System.Guid.NewGuid();
        public string contenido { get; set; }
        public DateTime fecha { get; set; }
        public string? hash { get; set; }
        public int? UserId { get; set; }
        public virtual Users? User { get; set; }

    }
}
