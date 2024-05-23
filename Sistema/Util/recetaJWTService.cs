using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using Sistema.Models.Recetas;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace Sistema.Util
{
    public class recetaJWTService
    {
        private string keyJwt;
        public recetaJWTService()
        {
            keyJwt = "KrjX7XgKVyvIDESc0vp5KFguzGO5EGwG";
        }

        public string signReceta(payloadJWT payload)
        {
            SymmetricSecurityKey key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(keyJwt));
            SigningCredentials creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            string jsonPayload = JsonConvert.SerializeObject(payload);
            Claim[] claims = new Claim[9];
            if (payload.jti != null)
            {
                claims[0] = new Claim(JwtRegisteredClaimNames.Jti, payload.jti.ToString());
            }
            if (payload.iss != null)
            {
                claims[1] = new Claim(JwtRegisteredClaimNames.Iss, payload.iss);
            }
            if (payload.exp != null)
            {
                claims[2] = new Claim(JwtRegisteredClaimNames.Exp, payload.exp.ToString());
            }
            if (payload.dtc != null)
            {
                claims[3] = new Claim("dtc", payload.dtc.ToString());
            }
            if (payload.environment != null)
            {
                claims[4] = new Claim("environment", payload.environment);
            }
            if (payload.certificateURL != null)
            {
                claims[5] = new Claim("certificateURL", payload.certificateURL);
            }
            if (jsonPayload != null)
            {
                claims[6] = new Claim("all", jsonPayload);
            }

            JwtSecurityToken token = new JwtSecurityToken(
                               issuer: null,
                               audience: null,
                               claims: claims,
                               expires: DateTime.Now.AddHours(1),
                               signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);



        }


        public static string hash256(string text)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(text));
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }

        public static string hash256(FileInfo fileInfo)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                using (FileStream fileStream = fileInfo.OpenRead())
                {
                    byte[] hashBytes = sha256Hash.ComputeHash(fileStream);
                    StringBuilder builder = new StringBuilder();
                    for (int i = 0; i < hashBytes.Length; i++)
                    {
                        builder.Append(hashBytes[i].ToString("x2"));
                    }
                    return builder.ToString();
                }
            }
        }

    }
}
