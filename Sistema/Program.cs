using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Sistema.DataBase;
using Sistema.Models;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<BDContext>(options =>
    options
    .UseLazyLoadingProxies()
    .UseMySQL(builder.Configuration.GetConnectionString("DefaultConnection")));

var configuration = builder.Configuration;
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["KeyJwt"].ToString())),
        ValidateIssuer = false,
        ValidateAudience = false
    };
});
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

await Task.Delay(5000);
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<BDContext>();

        if (!context.Database.CanConnect())
        {
            context.Database.EnsureCreated();
            Customers customers = new Customers
            {
                name = "Test"
            };
            context.Customers.Add(customers);
            context.SaveChanges();

            Users users = new Users
            {
                name = "Test SueprAdmin",
                email = "test_sp@email.com",
                role = Role.SuperAdmin,
                password = "123456789",
                CustomersId = 1
            };

            Users user2 = new Users
            {
                name = "Test SueprAdmin",
                email = "test_s@email.com",
                role = Role.Admin,
                password = "123456789",
                CustomersId = 1
            };

            users.HashPassword();
            user2.HashPassword();
            context.Users.Add(users);
            context.Users.Add(user2);
            context.SaveChanges();

        }
        else
        {
            if (context.Database.GetPendingMigrations().Any())
            {
                context.Database.Migrate();
            }
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"An error occurred while migrating the database: {ex.Message}");
        Console.WriteLine(builder.Configuration.GetConnectionString("DefaultConnection"));
    }
}

//app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
