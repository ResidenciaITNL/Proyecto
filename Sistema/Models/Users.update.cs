using System.ComponentModel.DataAnnotations;

namespace Sistema.Models
{
    public class UsersUpdate
    {
        public string? name { get; set; }
        [EmailAddress(ErrorMessage = "El email no es valido")]
        public string? email { get; set; }
        public string? password { get; set; }
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
    }
}
