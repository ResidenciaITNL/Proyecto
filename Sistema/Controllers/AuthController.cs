using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sistema.DataBase;
using Sistema.Models;
using Sistema.Util;
using System.Security.Claims;

namespace Sistema.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly BDContext _context;
        private readonly IConfiguration _configuration;
        private readonly JwtService _jwtService;

        public AuthController(BDContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
            _jwtService = new JwtService(_configuration);
        }
        [HttpPost]
        [ProducesResponseType(200)]
        public async Task<IActionResult> Login([FromBody] PostAuth postAuth)
        {
            Users user = await _context.Users.FirstOrDefaultAsync(x => x.email == postAuth.email);
            if (user == null)
            {
                return NotFound(new { message = "Usuario o contraseña incorrecta" });
            }
            if (!user.CheckPassword(postAuth.password))
            {
                return NotFound(new { message = "Usuario o contraseña incorrecta" });
            }
            List<Claim> claims = new List<Claim>
            {
                new Claim(ClaimTypes.Email, user.email),
                new Claim(ClaimTypes.Role, user.role.ToString()),
                new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
                new Claim("CustomerId", user.CustomersId.ToString())
            };
            string token = _jwtService.GenerateToken(claims, 2);
            return Ok(new { token, refreshToken = "No disponible aun", user.firstLogin });
        }

        [HttpPost("refresh")]
        public IActionResult Refresh()
        {
            return Ok();
        }
    }
}
