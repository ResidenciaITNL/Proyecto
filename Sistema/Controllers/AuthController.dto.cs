using System.ComponentModel.DataAnnotations;

namespace Sistema.Controllers
{
    public class PostAuth
    {
        [Required(ErrorMessage = "El campo 'email' es obligatorio.")]
        [EmailAddress(ErrorMessage = "El campo 'email' debe ser una dirección de correo electrónico válida.")]
        public string email { get; set; }
        [Required(ErrorMessage = "El campo 'password' es obligatorio.")]
        public string password { get; set; }
    }
}
