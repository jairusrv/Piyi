using Microsoft.AspNetCore.Mvc;

namespace Piyi.API.Controllers;

[ApiController]
public sealed class PrivacyController : ControllerBase
{
    [HttpGet("/privacy")]
    public IActionResult Privacy()
    {
        const string html = """
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Política de Privacidad - Piyí</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body{font-family:Arial,sans-serif;max-width:860px;margin:40px auto;padding:0 20px;line-height:1.6;color:#1F2D44}
    h1,h2{color:#31A997}
  </style>
</head>
<body>
<h1>Política de Privacidad de Piyí</h1>
<p>Última actualización: 06 de julio de 2026</p>
<p>Piyí ayuda a los usuarios a registrar información de sus mascotas, consultar servicios relacionados y reportar mascotas perdidas.</p>
<h2>Información que recopilamos</h2>
<p>Podemos recopilar nombre, correo electrónico, teléfono, información de mascotas, ubicación aproximada cuando el usuario la autoriza y datos necesarios para el funcionamiento de la app.</p>
<h2>Uso de la información</h2>
<p>Usamos la información para permitir el registro, inicio de sesión, gestión de mascotas, reportes de mascotas perdidas, contacto con servicios y mejoras de seguridad.</p>
<h2>Ubicación</h2>
<p>La ubicación se usa solo cuando el usuario concede permiso, por ejemplo para reportar una mascota perdida o mostrar información cercana.</p>
<h2>Compartir información</h2>
<p>No vendemos información personal. Algunos datos de contacto pueden mostrarse cuando el usuario publica un reporte o perfil que requiere contacto.</p>
<h2>Contacto</h2>
<p>Para consultas escribe a jairoriveravazquez@gmail.com.</p>
</body>
</html>
""";

        return Content(html, "text/html; charset=utf-8");
    }
}
