using System.ComponentModel.DataAnnotations;


namespace Sistema.Models
{
    public enum Role
    {
        SuperAdmin,
        Admin,
        User
    }
    public class Users
    {
        [Key]
        public int UserId { get; set; }
        [Required]
        public string name { get; set; }
        [Required]
        public string email { get; set; }
        [Required]
        public string password { get; set; }
        public string? codeRecovery { get; set; }
        public string? tokenRefresh { get; set; }
        public Role role { get; set; }
        public int CustomersId { get; set; }
        public virtual Customers Customers { get; set; }

        public void HashPassword()
        {
            this.password = BCrypt.Net.BCrypt.EnhancedHashPassword(this.password, 8);
        }
        public bool CheckPassword(string password)
        {
            return BCrypt.Net.BCrypt.EnhancedVerify(password, this.password);
        }
    }
}
