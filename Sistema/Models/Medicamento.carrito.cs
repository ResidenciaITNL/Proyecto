using System.ComponentModel.DataAnnotations;

namespace Sistema.Models
{
    public class MedicamentoCarrito
    {
        public ItemCarro[]? Items { get; set; }
    }
    public class ItemCarro
    {
        [Required]
        public string Id { get; set; }
        [Required]
        [Range(1, 10, ErrorMessage = "La cantidad dee ser entre 1 y 10")]
        public int cantidad { get; set; }
    }
}
