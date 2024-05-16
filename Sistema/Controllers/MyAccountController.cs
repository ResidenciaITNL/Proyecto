using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sistema.DataBase;
using Sistema.Models;
using System.Security.Claims;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Sistema.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class MyAccountController : ControllerBase
    {
        private readonly BDContext _context;
        public int CustomerId { get; private set; }
        public MyAccountController(BDContext context)
        {
            _context = context;
            CustomerId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "CustomerId").Value);
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
                user.HashPassword();
            }
            _context.Entry(user).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return Ok(new { message = "La contraseña se actualizo con exito" });
        }
    }
}
