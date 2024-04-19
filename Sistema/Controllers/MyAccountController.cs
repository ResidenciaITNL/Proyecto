using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sistema.DataBase;
using Sistema.Models;

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
        [HttpPut]
        public async Task<IActionResult> Put([FromBody] Users value)
        {
            Users? user = await _context.Users.FirstOrDefaultAsync(x => x.UserId == CustomerId);
            if (user == null)
            {
                return NotFound(new { message = "Usuario no encontrado" });
            }
            if (value.password != null)
            {
                user.password = value.password;
                user.HashPassword();
            }
            await _context.SaveChangesAsync();
            return Ok(new { message = "Usuario actualizado" });
        }
    }
}
