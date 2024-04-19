using Microsoft.EntityFrameworkCore;

namespace Sistema.DataBase
{
    public class BDContext : DbContext
    {
        public BDContext(DbContextOptions<BDContext> options) : base(options)
        {
        }

        public DbSet<Models.Customers> Customers { get; set; }
        public DbSet<Models.Users> Users { get; set; }
        public DbSet<Models.Medicamento> Medicamento { get; set; }
        public DbSet<Models.Paciente> Paciente { get; set; }
    }
}
