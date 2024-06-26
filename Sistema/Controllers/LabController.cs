﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sistema.DataBase;
using Sistema.Models;
using Sistema.Models.Lab;
using Sistema.Util;
using System.Security.Claims;

namespace Sistema.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class LabController : ControllerBase
    {
        private readonly BDContext _context;
        private RecetaService _recetaService;

        public LabController(BDContext context)
        {
            _context = context;
        }

        [HttpPost("Antidoping-3")]
        public async Task<IActionResult> PostAntidoping3([FromBody] Antidoping3 data)
        {
            int UserId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);

            Laboratorio lab = new Laboratorio();
            lab.objetoData = Newtonsoft.Json.JsonConvert.SerializeObject(data);
            lab.objetoName = nameof(Antidoping3);
            lab.UserId = UserId;
            lab.tipo = "Antidoping 3";
            lab.PacienteId = data.PacienteId;
            _context.Laboratorio.Add(lab);
            await _context.SaveChangesAsync();

            var timestamp = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();
            var pathWord = Path.Combine(Directory.GetCurrentDirectory(), "Util", $"{timestamp}.docx");
            var path = Path.Combine(Directory.GetCurrentDirectory(), "Util", "template_antidoping3.docx");

            var paciente = await _context.Paciente.FirstOrDefaultAsync(x => x.PacienteId == data.PacienteId);
            data.NombrePaciente = paciente.Nombre + " " + paciente.Apellido;
            data.edad = paciente.Edad.ToString();
            paciente.Estudio_medico = false;
            _context.Entry(paciente).State = EntityState.Modified;

            _recetaService = new RecetaService(path, pathWord, data);
            _recetaService.GenerateDocumentForLab();
            var file = System.IO.File.ReadAllBytes(pathWord);
            _recetaService.CleanUp();
            return File(file, "application/octet-stream", $"{data.Folio}.docx");
        }

        [HttpPost("Antidoping-5")]
        public async Task<IActionResult> PostAntidoping5([FromBody] Antidoping5 data)
        {
            int UserId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);
            Laboratorio lab = new Laboratorio();
            lab.objetoData = Newtonsoft.Json.JsonConvert.SerializeObject(data);
            lab.objetoName = nameof(Antidoping5);
            lab.UserId = UserId;
            lab.PacienteId = data.PacienteId;
            lab.tipo = "Antidoping 5";
            _context.Laboratorio.Add(lab);
            await _context.SaveChangesAsync();

            var timestamp = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();
            var pathWord = Path.Combine(Directory.GetCurrentDirectory(), "Util", $"{timestamp}.docx");
            var path = Path.Combine(Directory.GetCurrentDirectory(), "Util", "template_antidoping5.docx");

            var paciente = await _context.Paciente.FirstOrDefaultAsync(x => x.PacienteId == data.PacienteId);
            data.NombrePaciente = paciente.Nombre + " " + paciente.Apellido;
            data.edad = paciente.Edad.ToString();
            paciente.Estudio_medico = false;
            _context.Entry(paciente).State = EntityState.Modified;

            _recetaService = new RecetaService(path, pathWord, data);
            _recetaService.GenerateDocumentForLab();
            var file = System.IO.File.ReadAllBytes(pathWord);
            _recetaService.CleanUp();
            return File(file, "application/octet-stream", $"{data.Folio}.docx");
        }

        [HttpPost("pruebaEmbarazo")]
        public async Task<IActionResult> pruebaEmbarazo([FromBody] PruebaDeEmbarazo data)
        {
            int UserId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier).Value);
            Laboratorio lab = new Laboratorio();
            lab.objetoData = Newtonsoft.Json.JsonConvert.SerializeObject(data);
            lab.objetoName = nameof(PruebaDeEmbarazo);
            lab.UserId = UserId;
            lab.tipo = "Prueba de Embarazo";
            lab.PacienteId = data.PacienteId;
            _context.Laboratorio.Add(lab);
            await _context.SaveChangesAsync();

            var timestamp = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();
            var pathWord = Path.Combine(Directory.GetCurrentDirectory(), "Util", $"{timestamp}.docx");
            var path = Path.Combine(Directory.GetCurrentDirectory(), "Util", "template_embarazo.docx");

            var paciente = await _context.Paciente.FirstOrDefaultAsync(x => x.PacienteId == data.PacienteId);
            data.NombrePaciente = paciente.Nombre + " " + paciente.Apellido;
            data.edad = paciente.Edad.ToString();
            paciente.Estudio_medico = false;
            _context.Entry(paciente).State = EntityState.Modified;

            _recetaService = new RecetaService(path, pathWord, data);
            _recetaService.GenerateDocumentForLab();
            var file = System.IO.File.ReadAllBytes(pathWord);
            _recetaService.CleanUp();
            return File(file, "application/octet-stream", $"{data.Folio}.docx");

        }
    }
}
