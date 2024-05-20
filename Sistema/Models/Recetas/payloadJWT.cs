namespace Sistema.Models.Recetas
{
    public class payloadJWT
    {
        public string version { get; set; }
        public Guid jti { get; set; }
        public string? iss { get; set; }
        public int? exp { get; set; }
        public int? nbf { get; set; }
        public int? dtc { get; set; } //unixtime
        public string? generalInstructions { get; set; }
        public string environment { get; set; }
        public string? certificateURL { get; set; } // Firmadas por servidor y no por médico
        public Requester requester { get; set; }
        public Subject subject { get; set; }
        public string medicamento { get; set; }
        public string diagnositoco { get; set; }

    }
}
