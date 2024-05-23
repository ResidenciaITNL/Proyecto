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
    [Authorize]
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
                Presion = x.presion,
                Temperatura = x.temperatura,
                Estudio_detalle = x.Estudio_medico_detalle,
                Telefono = x.telefono,
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
                Presion = x.presion,
                Temperatura = x.temperatura,
                Estudio_detalle = x.Estudio_medico_detalle,
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
                Presion = x.presion,
                Temperatura = x.temperatura,
                Peso = x.Peso,
                Alergias = x.Alergias
            }).ToListAsync();
            return Ok(pacientes);
        }


        // GET: api/Pacientes/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetPaciente(int id)
        {
            //Obtener el customerId del token
            var CustomerId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "CustomerId").Value);
            var paciente = await _context.RecetasTB.Where(RecetasTB => RecetasTB.PacienteId == id && RecetasTB.User.CustomersId == CustomerId).Select(receta => new
            {
                Id = "R-" + receta.RecetaId.ToString(),
                Titulo = "Consulta",
                Doctor = receta.User.name + " " + receta.User.email,
                Fecha = receta.fecha.ToString("dd-MM-yyyy hh:mm tt")
            }).Union(_context.Laboratorio.Where(Laboratorio => Laboratorio.PacienteId == id && Laboratorio.User.CustomersId == CustomerId).Select(laboratorio => new
            {
                Id = "L-" + laboratorio.LaboratorioId.ToString,
                Titulo = "Estudio - " + laboratorio.tipo,
                Doctor = laboratorio.User.name + " " + laboratorio.User.email,
                Fecha = laboratorio.fecha.ToString("dd-MM-yyyy hh:mm tt")
            })).OrderByDescending(x => x.Fecha).ToListAsync();

            if (paciente == null)
            {
                return NotFound();
            }
            return Ok(paciente);
        }

        // PUT: api/Pacientes/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPaciente(int id, PacienteUpdate pacienteUpdate)
        {
            var CustomerId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "CustomerId").Value);
            var paciente = await _context.Paciente.FirstOrDefaultAsync(x => x.PacienteId == id && x.User.CustomersId == CustomerId);
            if (paciente == null)
            {
                return NotFound();
            }
            paciente.Nombre = pacienteUpdate.Nombre ?? paciente.Nombre;
            paciente.Apellido = pacienteUpdate.Apellido ?? paciente.Apellido;
            if (pacienteUpdate.Edad >= 0)
            {
                paciente.Edad = pacienteUpdate.Edad ?? paciente.Edad;
            }
            paciente.Estatura = pacienteUpdate.Estatura ?? paciente.Estatura;
            paciente.Peso = pacienteUpdate.Peso ?? paciente.Peso;
            paciente.Alergias = pacienteUpdate.Alergias ?? paciente.Alergias;
            paciente.Estudio_medico = pacienteUpdate.Estudio_medico ?? paciente.Estudio_medico;
            paciente.Consulta = pacienteUpdate.Consulta ?? paciente.Consulta;
            paciente.Estudio_medico_detalle = pacienteUpdate.Estudio_medico_detalle ?? paciente.Estudio_medico_detalle;
            paciente.presion = pacienteUpdate.presion ?? paciente.presion;
            paciente.temperatura = pacienteUpdate.temperatura ?? paciente.temperatura;
            _context.Entry(paciente).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return Ok();
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
