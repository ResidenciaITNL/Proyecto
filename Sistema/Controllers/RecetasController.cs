using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sistema.DataBase;
using Sistema.Models;
using Sistema.Models.Recetas;
using Sistema.Util;
using System.Security.Claims;

namespace Sistema.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class RecetasController : ControllerBase
    {
        private readonly BDContext _context;
        public RecetasController(BDContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult GetReceta([FromQuery] string iure, [FromQuery] string sd)
        {
            return Ok();
        }

        [HttpPost]
        public IActionResult PostReceta([FromBody] RecetasTB receta)
        {

            int UserId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);
            receta.UserId = UserId;
            receta.User = _context.Users.FirstOrDefault(x => x.UserId == UserId); // Medico que lo esta conultadno
            string timestamp = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();
            var pathWord = Path.Combine(Directory.GetCurrentDirectory(), "Util", $"{timestamp}.docx");
            receta.Paciente = _context.Paciente.FirstOrDefault(x => x.PacienteId == receta.PacienteId);


            //Construrir el obejto para sustirutir en el word
            #region recetaTemplate
            recetaTemplate _recetaTemplate = new recetaTemplate(); // para el word
            _recetaTemplate.Contenido = receta.contenido;
            _recetaTemplate.Nombre = receta.Paciente.Nombre;
            _recetaTemplate.DateNow = DateTime.Now.ToShortDateString();
            _recetaTemplate.Titulo = receta.User.titulo;
            _recetaTemplate.Cedula = receta.User.cedula;
            _recetaTemplate.Col = receta.User.Customers.Colonia;
            _recetaTemplate.calle = receta.User.Customers.calle;
            _recetaTemplate.CP = receta.User.Customers.CP;
            _recetaTemplate.Municipio = receta.User.Customers.Municipio;
            _recetaTemplate.Estado = receta.User.Customers.Estado;
            _recetaTemplate.Nombre_Paciente = receta.Paciente.Nombre;
            _recetaTemplate.Edad = receta.Paciente.Edad.ToString();
            _recetaTemplate.Peso = receta.Paciente.Peso.ToString();
            _recetaTemplate.Altura = receta.Paciente.Estatura.ToString();
            #endregion

            #region payloadJWT
            payloadJWT _payloadJWT = new payloadJWT();
            _payloadJWT.version = "2.0";
            _payloadJWT.jti = (Guid)receta.Guid;
            _payloadJWT.iss = receta.User.Customers.RFC;
            _payloadJWT.environment = "dev";
            _payloadJWT.requester = new();
            _payloadJWT.requester.name = receta.User.name;
            _payloadJWT.requester.email = receta.User.email;
            _payloadJWT.requester.title = receta.User.titulo;
            _payloadJWT.requester.qualification = new Qualification();
            _payloadJWT.requester.qualification.cedula = receta.User.cedula;
            _payloadJWT.requester.qualification.institucion = receta.User.institucion;
            _payloadJWT.requester.qualification.year = (int)receta.User.year;
            _payloadJWT.requester.qualification.titulo = receta.User.titulo;
            _payloadJWT.subject = new Subject();
            _payloadJWT.subject.name = receta.Paciente.Nombre;
            _payloadJWT.subject.identifier = receta.Paciente.PacienteId.ToString();
            _payloadJWT.subject.telephone = receta.Paciente.telefono.ToString();
            _payloadJWT.subject.weight = float.Parse(receta.Paciente.Peso.ToString());
            _payloadJWT.subject.height = float.Parse(receta.Paciente.Estatura.ToString());
            _payloadJWT.diagnositoco = receta.contenido;

            #endregion

            recetaJWTService _recetaJWTService = new recetaJWTService();
            _recetaTemplate.token = _recetaJWTService.signReceta(_payloadJWT);
            var path = Path.Combine(Directory.GetCurrentDirectory(), "Util", "receta_template.docx");
            RecetaService _recetaService = new RecetaService(path, pathWord, $"http://127.0.0.1/receta?iure={receta.Guid}&sd={recetaJWTService.hash256(_recetaTemplate.token)}");
            _recetaService._recetaTemplate = _recetaTemplate;
            _recetaService.GenerateDocument();
            var file = System.IO.File.ReadAllBytes(pathWord);
            FileInfo fileHash = new FileInfo(pathWord);
            receta.hash = recetaJWTService.hash256(fileHash);
            _context.RecetasTB.Add(receta);
            _context.SaveChanges();

            _recetaService.CleanUp();
            return File(file, "application/octet-stream", $"{_recetaTemplate.Titulo}.docx");
        }

    }
}
