using System.ComponentModel.DataAnnotations;


namespace Sistema.Models
{
    public enum Role
    {
        SuperAdmin,
        Admin,
        User,
        Doctor,
        Recepcionista,
        Especialista
    }
    public class Users
    {
        [Key]
        public int UserId { get; set; }
        public string name { get; set; }
        public string email { get; set; }
        public string password { get; set; }
        public string? codeRecovery { get; set; }
        public string? tokenRefresh { get; set; }
        public string? titulo { get; set; }
        public string? cedula { get; set; }
        public string? institucion { get; set; }
        public int? year { get; set; }
        public bool? firstLogin { get; set; } = true;
        public Role role { get; set; }
        public int? CustomersId { get; set; }
        public bool active { get; set; } = true;
        public virtual Customers? Customers { get; set; }

        public void HashPassword()
        {
            this.password = BCrypt.Net.BCrypt.EnhancedHashPassword(this.password, 8);
        }
        public bool CheckPassword(string password)
        {
            return BCrypt.Net.BCrypt.EnhancedVerify(password, this.password);
        }

        public bool CheckEmail(string email)
        {
            // Supongamos que this.email es el correo electrónico almacenado en tu sistema
            return string.Equals(email, this.email, StringComparison.OrdinalIgnoreCase);
        }
    }
}
