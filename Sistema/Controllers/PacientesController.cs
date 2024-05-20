using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sistema.DataBase;
using Sistema.Models;
using System.Security.Claims;

namespace Sistema.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PacientesController : ControllerBase
    {
        private readonly BDContext _context;

        public PacientesController(BDContext context)
        {
            _context = context;
        }

        // GET: api/Pacientes
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetPaciente()
        {
            int CustomerId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "CustomerId").Value);
            var pacientes = await _context.Paciente.Where(x => !x.isDeleted && x.User.CustomersId == CustomerId).Select(x => new
            {
                PacienteId = x.PacienteId,
                Nombre = x.Nombre,
                Apellido = x.Apellido,
                Edad = x.Edad,
                Sexo = x.Sexo,
                Estatura = x.Estatura,
                Peso = x.Peso,
                Alergias = x.Alergias,
                Estudio_medico = x.Estudio_medico ? "Si" : "No",
                Consulta = x.Consulta ? "Si" : "No",
            }).ToListAsync();
            return Ok(pacientes);
        }

        [HttpGet("EstudioMedico")]
        [Authorize(Roles = "Especialista")]
        public async Task<IActionResult> GetPacienteEstudioMedico()
        {
            int CustomerId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "CustomerId").Value);
            var pacientes = await _context.Paciente.Where(x => x.Estudio_medico && !x.isDeleted && x.User.CustomersId == CustomerId).Select(x => new
            {
                PacienteId = x.PacienteId,
                Nombre = x.Nombre,
                Apellido = x.Apellido,
                Edad = x.Edad,
                Sexo = x.Sexo,
                Estatura = x.Estatura,
                Peso = x.Peso,
                Alergias = x.Alergias
            }).ToListAsync();
            return Ok(pacientes);
        }

        [HttpGet("Doctor")]
        [Authorize(Roles = "Doctor")]
        public async Task<IActionResult> GetPacienteDoctor()
        {
            int CustomerId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "CustomerId").Value);
            var pacientes = await _context.Paciente.Where(x => x.Consulta && !x.isDeleted && x.User.CustomersId == CustomerId).Select(x => new
            {
                PacienteId = x.PacienteId,
                Nombre = x.Nombre,
                Apellido = x.Apellido,
                Edad = x.Edad,
                Sexo = x.Sexo,
                Estatura = x.Estatura,
                Peso = x.Peso,
                Alergias = x.Alergias
            }).ToListAsync();
            return Ok(pacientes);
        }


        // GET: api/Pacientes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Paciente>> GetPaciente(int id)
        {
            if (_context.Paciente == null)
            {
                return NotFound();
            }
            var paciente = await _context.Paciente.FindAsync(id);

            if (paciente == null)
            {
                return NotFound();
            }

            return paciente;
        }

        // PUT: api/Pacientes/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPaciente(int id, Paciente paciente)
        {
            if (id != paciente.PacienteId)
            {
                return BadRequest();
            }

            _context.Entry(paciente).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PacienteExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Pacientes
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Paciente>> PostPaciente(Paciente paciente)
        {
            var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);
            if (_context.Paciente == null)
            {
                return Problem();
            }
            paciente.UserId = userId;
            _context.Paciente.Add(paciente);
            await _context.SaveChangesAsync();
            return Ok();
        }

        // DELETE: api/Pacientes/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePaciente(int id)
        {
            if (_context.Paciente == null)
            {
                return NotFound();
            }
            var paciente = await _context.Paciente.FindAsync(id);
            if (paciente == null)
            {
                return NotFound();
            }

            paciente.isDeleted = true;
            _context.Entry(paciente).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        private bool PacienteExists(int id)
        {
            return (_context.Paciente?.Any(e => e.PacienteId == id)).GetValueOrDefault();
        }
    }
}
