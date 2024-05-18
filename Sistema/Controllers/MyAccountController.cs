using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sistema.DataBase;
using Sistema.Models;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using System.Text.RegularExpressions;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Sistema.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class MyAccountController : ControllerBase
    {
        private readonly BDContext _context;
        public MyAccountController(BDContext context)
        {
            _context = context;
        }

        // PUT api/<MyAccountController>/5
        [HttpPut("change-password")]
        public async Task<IActionResult> Put([FromBody] UsersUpdate value)
        {
            int UserId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);
            Users? user = await _context.Users.FirstOrDefaultAsync(x => x.UserId == UserId);
            if (user == null)
            {
                return NotFound(new { message = "Usuario no encontrado" });
            }
            if (value.password != null)
            {
                if (value.password.Length < 8)
                {
                    return BadRequest(new { message = "La contraseña debe tener al menos 8 caracteres" });
                }
                if (!user.CheckPassword(value.oldPassword))
                {
                    return BadRequest(new { message = "Contraseña incorrecta" });
                }
                user.password = value.password;
                user.firstLogin = false;
                user.HashPassword();
            }
            _context.Entry(user).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return Ok(new { message = "La contraseña se actualizo con exito" });
        }


        // PUT api/<MyAccountController>/change-email
        [HttpPut("change-email")]
        public async Task<IActionResult> ChangeEmail([FromBody] UsersUpdate value)
        {
            int UserId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);
            Users? user = await _context.Users.FirstOrDefaultAsync(x => x.UserId == UserId);

            if (user == null)
            {
                return NotFound(new { message = "Usuario no encontrado" });
            }

            // Expresión regular para validar el formato del correo electrónico
            string emailPattern = @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$";

            if (value.email != null)
            {
                // Validar el correo electrónico usando la expresión regular
                if (!Regex.IsMatch(value.email, emailPattern))
                {
                    return BadRequest(new { message = "El formato del correo electrónico no es válido" });
                }

                if (!user.CheckEmail(value.oldEmail))
                {
                    return BadRequest(new { message = "Email no coincide" });
                }

                user.email = value.email;
            }


            _context.Entry(user).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return Ok(new { message = "El email se actualizó con éxito" });
        }



    }
}
