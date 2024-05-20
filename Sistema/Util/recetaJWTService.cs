using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using Sistema.Models.Recetas;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Sistema.Util
{
    public class recetaJWTService
    {
        private readonly IConfiguration _configuration;
        private string keyJwt;
        public recetaJWTService(IConfiguration configuration)
        {
            _configuration = configuration;
            _configuration["KeyJwt"].ToString();
        }

        public string signReceta(payloadJWT payload)
        {
            SymmetricSecurityKey key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(keyJwt));
            SigningCredentials creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            string jsonPayload = JsonConvert.SerializeObject(payload);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Jti, payload.jti.ToString()),
                new Claim(JwtRegisteredClaimNames.Iss, payload.iss),
                new Claim(JwtRegisteredClaimNames.Exp, payload.exp.ToString()),
                new Claim("dtc", payload.dtc.ToString()),
                new Claim("environment", payload.dtc.ToString()),
                new Claim("certificateURL", payload.dtc.ToString()),
                new Claim("all", jsonPayload)
            };

            JwtSecurityToken token = new JwtSecurityToken(
                               issuer: null,
                               audience: null,
                               claims: claims,
                               expires: DateTime.Now.AddHours(1),
                               signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);



        }

    }
}
