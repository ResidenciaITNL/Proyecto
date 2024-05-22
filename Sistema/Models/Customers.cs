using System.ComponentModel.DataAnnotations;

namespace Sistema.Models
{
    public class Customers
    {
        [Key]
        public int CustomersId { get; set; }
        public string name { get; set; }
        public string? Colonia { get; set; }
        public string? calle { get; set; }
        public string? CP { get; set; }
        public string? Municipio { get; set; }
        public string? Estado { get; set; }
        public string? RFC { get; set; }
        public string? data { get; set; }
        public virtual ICollection<Users> Users { get; set; }
    }
}
