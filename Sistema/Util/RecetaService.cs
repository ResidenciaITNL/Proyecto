using PdfSharp.Drawing;
using PdfSharp.Drawing.Layout;
using PdfSharp.Pdf;
using QRCoder;
using Sistema.Models.Recetas;
using Xceed.Words.NET;

namespace Sistema.Util
{
    public class RecetaService
    {
        public string TemplatePath { get; set; }
        public string OutputPdfPath { get; set; }
        public string QrText { get; set; }
        private string _tempDocxPath;
        private string _qrImagePath;
        private object _dataTemplate { get; set; } = null;

        public recetaTemplate _recetaTemplate { get; set; } = null;

        public RecetaService(string templatePath, string outputPdfPath, string qrText)
        {
            TemplatePath = templatePath;
            OutputPdfPath = outputPdfPath;
            QrText = qrText;
            _tempDocxPath = outputPdfPath;
            _qrImagePath = Path.GetTempFileName() + ".png";
        }
        public RecetaService(string templatePath, string outputPdfPath, object dataTemplate)
        {
            TemplatePath = templatePath;
            OutputPdfPath = outputPdfPath;
            _tempDocxPath = outputPdfPath;
            _dataTemplate = dataTemplate;
        }

        public void GenerateDocument()
        {
            GenerateQRCode(QrText, _qrImagePath);
            CreateWordDocument();
        }
        public void GenerateDocumentForLab()
        {
            CreateWordDocumentForLab();
        }

        private void GenerateQRCode(string text, string filePath)
        {
            using (QRCodeGenerator qrGenerator = new QRCodeGenerator())
            {
                QRCodeData qrCodeData = qrGenerator.CreateQrCode(text, QRCodeGenerator.ECCLevel.Q);
                PngByteQRCode qrCode = new PngByteQRCode(qrCodeData);
                byte[] qrCodeImage = qrCode.GetGraphic(20);
                File.WriteAllBytes(filePath, qrCodeImage);
            }
        }

        private void CreateWordDocument()
        {
            using (var document = DocX.Load(TemplatePath))
            {
                var image = document.AddImage(_qrImagePath);
                var picture = image.CreatePicture();
                picture.Width = 100;
                picture.Height = 100;
                document.InsertParagraph().AppendPicture(picture);
                var properties = _recetaTemplate.GetType().GetProperties();
                foreach (var property in properties)
                {
                    var value = property.GetValue(_recetaTemplate);
                    document.ReplaceText($"{{{{{property.Name}}}}}", value.ToString());
                }

                document.SaveAs(_tempDocxPath);
            }
        }
        private void CreateWordDocumentForLab()
        {
            using (var document = DocX.Load(TemplatePath))
            {
                var properties = _dataTemplate.GetType().GetProperties();
                foreach (var property in properties)
                {
                    var value = property.GetValue(_recetaTemplate);
                    document.ReplaceText($"{{{{{property.Name}}}}}", value.ToString());
                }

                document.SaveAs(_tempDocxPath);
            }
        }

        private void ConvertDocxToPdf(string docxPath, string pdfPath)
        {
            PdfDocument pdf = new PdfDocument();
            pdf.Info.Title = "Converted PDF Document";

            PdfPage pdfPage = pdf.AddPage();
            XGraphics gfx = XGraphics.FromPdfPage(pdfPage);
            XTextFormatter tf = new XTextFormatter(gfx);

            XFont font = new XFont("Arial", 12, XFontStyleEx.Regular);

            using (var document = DocX.Load(docxPath))
            {
                string text = document.Text;
                tf.DrawString(text, font, XBrushes.Black,
                    new XRect(40, 40, pdfPage.Width - 80, pdfPage.Height - 80));

                XImage xImage = XImage.FromFile(_qrImagePath);
                gfx.DrawImage(xImage, pdfPage.Width - 120, pdfPage.Height - 160, 100, 100);
            }

            pdf.Save(pdfPath);
        }

        public void CleanUp()
        {
            if (File.Exists(_tempDocxPath))
            {
                File.Delete(_tempDocxPath);
            }
            if (_qrImagePath != null)
            {
                if (File.Exists(_qrImagePath))
                {
                    File.Delete(_qrImagePath);
                }
            }
        }
    }
}
