using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sistema.DataBase;
using Sistema.Models;
using System.Diagnostics;
using System.Security.Claims;

namespace Sistema.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class MedicamentoController : ControllerBase
    {
        private readonly BDContext _context;

        public MedicamentoController(BDContext context)
        {
            _context = context;
        }

        // GET: api/Medicamento
        [HttpGet]
        public async Task<IActionResult> GetMedicamento()
        {
            var medicamentos = await _context.Medicamento.Where(x => (bool)x.active).Select(x => new
            {
                MedicamentoId = x.MedicamentoId,
                Nombre = x.Nombre,
                Descripcion = x.Descripcion,
                Imagen = x.Imagen,
                FechaVencimiento = x.FechaVencimiento,
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
        public async Task<IActionResult> PutMedicamento(int id, MedicamentoUpdate medicamentoUpdate)
        {
            var CustomerId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "CustomerId").Value);
            var medicamento = await _context.Medicamento.FirstOrDefaultAsync(x => x.MedicamentoId == id && x.User.CustomersId == CustomerId);
            if (medicamento == null)
            {
                return NotFound();
            }
            medicamento.Nombre = medicamentoUpdate.Nombre ?? medicamento.Nombre;
            medicamento.Descripcion = medicamentoUpdate.Descripcion ?? medicamento.Descripcion;
            medicamento.Imagen = medicamentoUpdate.Imagen ?? medicamento.Imagen;
            medicamento.FechaVencimiento = medicamentoUpdate.FechaVencimiento ?? medicamento.FechaVencimiento;
            if (medicamentoUpdate.Stock >= 0)
            {
                medicamento.Stock = medicamentoUpdate.Stock ?? medicamento.Stock;
            }
            if (medicamentoUpdate.Precio >= 0)
            {
                medicamento.Precio = medicamentoUpdate.Precio ?? medicamento.Precio;
            }
            medicamento.Contenido = medicamentoUpdate.Contenido ?? medicamento.Contenido;
            medicamento.unidad = medicamentoUpdate.unidad ?? medicamento.unidad;
            _context.Entry(medicamento).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return Ok();
        }

        // POST: api/Medicamento
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Medicamento>> PostMedicamento(Medicamento medicamento)
        {
            var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);
            if (medicamento.Stock < 0 || medicamento.Precio < 0)
            {
                return BadRequest(new { message = "Stock y Precio deben ser mayores a 0" });
            }
            medicamento.UserId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);
            _context.Medicamento.Add(medicamento);
            await _context.SaveChangesAsync();
            return Ok();
        }
        [HttpPost("carrito")]
        public async Task<IActionResult> PostCarrito(MedicamentoCarrito medicamento)
        {
            var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);

            if (medicamento.Items == null || medicamento.Items.Length == 0)
            {
                return BadRequest(new { message = "No hay items en el carrito" });
            }
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var venta = new Ventas
                    {
                        Total = 0,
                        UserId = userId,
                    };
                    if (venta.VentaMedicamentos == null)
                    {
                        venta.VentaMedicamentos = new List<VentaMedicamento>();
                    }

                    foreach (var item in medicamento.Items)
                    {
                        var medicamentoDB = await _context.Medicamento.FirstOrDefaultAsync(x => x.MedicamentoId == int.Parse(item.Id) && (bool)x.active);
                        if (medicamentoDB == null)
                        {
                            throw new Exception(message: $"No se encontró el medicamento con el id {item.Id}");
                        }
                        if (medicamentoDB.Stock == 0)
                        {
                            throw new Exception(message: $"No hay stock de {medicamentoDB.Nombre} {medicamentoDB.Descripcion}");
                        }
                        if (medicamentoDB.Stock < item.cantidad)
                        {
                            throw new Exception(message: $"No hay suficiente stock de {medicamentoDB.Nombre} {medicamentoDB.Descripcion}");
                        }
                        var ventaMedicamento = new VentaMedicamento
                        {
                            Venta = venta,
                            MedicamentoId = int.Parse(item.Id),
                        };
                        medicamentoDB.Stock -= item.cantidad;
                        venta.Total += medicamentoDB.Precio * item.cantidad;
                        _context.Entry(medicamentoDB).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        venta.VentaMedicamentos.Add(ventaMedicamento);

                    }
                    Debug.WriteLine(venta.Total);
                    _context.Ventas.Add(venta);
                    await _context.SaveChangesAsync();
                    transaction.Commit();
                    return Ok();

                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    return BadRequest(new { message = ex.Message });
                }
            }



        }

        // DELETE: api/Medicamento/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMedicamento(int id)
        {
            var CustomerId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);
            var medicamento = await _context.Medicamento.FirstOrDefaultAsync(x => x.MedicamentoId == id && x.UserId == CustomerId);
            if (medicamento == null)
            {
                return NotFound();
            }
            medicamento.active = false;
            _context.Entry(medicamento).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return Ok();
        }
    }
}
