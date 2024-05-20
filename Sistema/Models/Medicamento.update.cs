namespace Sistema.Models
{
    public class MedicamentoUpdate
    {
        public string? Nombre { get; set; }
        public string? Descripcion { get; set; }
        public string? Imagen { get; set; }
        public DateTime? FechaVencimiento { get; set; }
        public int? Stock { get; set; }
        public decimal? Precio { get; set; }
        public string? Contenido { get; set; }
        public string? unidad { get; set; }

    }
}
