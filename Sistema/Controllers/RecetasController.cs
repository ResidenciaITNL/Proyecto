using Microsoft.AspNetCore.Mvc;
using Sistema.DataBase;

namespace Sistema.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RecetasController : ControllerBase
    {
        private readonly BDContext _context;
        public RecetasController(BDContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult GetReceta([FromQuery] string id, [FromQuery] string hash)
        {
            return Ok();
        }

    }
}
