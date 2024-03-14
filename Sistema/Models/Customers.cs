namespace Sistema.Models
{
    public class Customers
    {
        public int CustomersId { get; set; }
        public string name { get; set; }
        public string? data { get; set; }
        public virtual ICollection<Users> Users { get; set; }
    }
}
