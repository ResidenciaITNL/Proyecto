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
    [Authorize("SuperAdmin,Admin")]
    public class UsersController : ControllerBase
    {
        private readonly BDContext _context;
        public int CustomerId { get; private set; }
        public UsersController(BDContext context)
        {
            _context = context;
            CustomerId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "CustomerId").Value);
        }
        // GET: api/<UsersController>
        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            List<Users> users = await _context.Users.Where(x => x.CustomersId == CustomerId && x.active).ToListAsync();
            return Ok(users);
        }

        // GET api/<UsersController>/5
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            Users? user = await _context.Users.FirstOrDefaultAsync(x => x.UserId == id && x.CustomersId == CustomerId && x.active);
            if (user == null)
            {
                return NotFound(new { message = "Usuario no encontrado" });
            }
            return Ok(user);
        }

        // POST api/<UsersController>
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Users value)
        {
            //Crear usuario
            value.CustomersId = CustomerId;
            value.HashPassword();
            await _context.Users.AddAsync(value);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Usuario creado" });
        }

        // PUT api/<UsersController>/5
        [HttpPut("{id}")]
        public async Task<IActionResult> Put(int id, [FromBody] Users value)
        {
            Users? user = await _context.Users.FirstOrDefaultAsync(x => x.UserId == id && x.CustomersId == CustomerId && x.active);
            if (user == null)
            {
                return NotFound(new { message = "Usuario no encontrado" });
            }
            user.name = value.name;
            user.email = value.email;
            user.role = value.role;
            if (!string.IsNullOrEmpty(value.password))
            {
                user.password = value.password;
                user.HashPassword();
            }
            await _context.SaveChangesAsync();
            return Ok(new { message = "Se ha actualizado el usuario" });
        }

        // DELETE api/<UsersController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            Users? user = await _context.Users.FirstOrDefaultAsync(x => x.UserId == id && x.CustomersId == CustomerId && x.active);
            if (user != null)
            {
                user.active = false;
                _context.SaveChanges();
                return Ok(new { message = "Usuario eliminado" });
            }
            return NotFound(new { message = "Usuario no encontrado" });
        }
    }
}
