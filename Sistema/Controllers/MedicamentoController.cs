using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sistema.DataBase;
using Sistema.Models;

namespace Sistema.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MedicamentoController : ControllerBase
    {
        private readonly BDContext _context;

        public MedicamentoController(BDContext context)
        {
            _context = context;
        }

        // GET: api/Medicamento
        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<Medicamento>>> GetMedicamento()
        //{
        //  if (_context.Medicamento == null)
        //  {
        //      return NotFound();
        //  }
        //    return await _context.Medicamento.ToListAsync();
        //}



        // GET: api/Medicamento
        [HttpGet]
        public async Task<IActionResult> GetMedicamento()
        {
            var medicamentos = await _context.Medicamento.Select(x => new
            {
                MedicamentoId = x.MedicamentoId,
                Nombre = x.Nombre,
                Descripcion = x.Descripcion,
                Imagen = x.Imagen,
                FechaVencimiento = x.FechaVencimiento.ToString("MM-yyyy"),
                Stock = x.Stock,
                Precio = x.Precio,
                Contenido = x.Contenido,
                unidad = x.unidad,
            }).ToListAsync();

            return Ok(medicamentos);
        }





        // GET: api/Medicamento/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Medicamento>> GetMedicamento(int id)
        {
          if (_context.Medicamento == null)
          {
              return NotFound();
          }
            var medicamento = await _context.Medicamento.FindAsync(id);

            if (medicamento == null)
            {
                return NotFound();
            }

            return medicamento;
        }

        // PUT: api/Medicamento/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMedicamento(int id, Medicamento medicamento)
        {
            if (id != medicamento.MedicamentoId)
            {
                return BadRequest();
            }

            _context.Entry(medicamento).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MedicamentoExists(id))
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

        // POST: api/Medicamento
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Medicamento>> PostMedicamento(Medicamento medicamento)
        {
          if (_context.Medicamento == null)
          {
              return Problem("Entity set 'BDContext.Medicamento'  is null.");
          }
            _context.Medicamento.Add(medicamento);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetMedicamento", new { id = medicamento.MedicamentoId }, medicamento);
        }

        // DELETE: api/Medicamento/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMedicamento(int id)
        {
            if (_context.Medicamento == null)
            {
                return NotFound();
            }
            var medicamento = await _context.Medicamento.FindAsync(id);
            if (medicamento == null)
            {
                return NotFound();
            }

            _context.Medicamento.Remove(medicamento);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool MedicamentoExists(int id)
        {
            return (_context.Medicamento?.Any(e => e.MedicamentoId == id)).GetValueOrDefault();
        }
    }
}
