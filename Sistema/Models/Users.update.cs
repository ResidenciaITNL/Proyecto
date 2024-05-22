using System.ComponentModel.DataAnnotations;

namespace Sistema.Models
{
    public class UsersUpdate
    {
        public string? name { get; set; }
        [EmailAddress(ErrorMessage = "El email no es valido")]
        public string? oldEmail { get; set; }
        public string? email { get; set; }
        public string? oldPassword { get; set; }
        public string? telefono { get; set; }
        public string? password { get; set; }
        public string? titulo { get; set; }
        public string? cedula { get; set; }
        public string? institucion { get; set; }
        public int? year { get; set; }
        public Role? role { get; set; }
        public bool? active { get; set; }
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
