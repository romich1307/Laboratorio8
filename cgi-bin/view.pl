#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use Text::Markdown qw(markdown);
use URI::Escape;

# Imprimir encabezado HTML con CSS
print "Content-type: text/html; charset=UTF-8\n\n";
print "<!DOCTYPE html>";
print "<html lang='es'>";
print "<head>";
print "<meta charset='UTF-8'>";
print "<meta name='viewport' content='width=device-width, initial-scale=1.0'>";
print "<title>Pagina</title>";

# Verifica la ruta del CSS
print "<link rel='stylesheet' href='/css/style.css'>";  # Cambia la ruta si es necesario
print "</head>";
print "<body>";

# Obtener el nombre de la página desde la URL (QUERY_STRING)
my $query = $ENV{'QUERY_STRING'};

# Extraer el nombre del archivo a partir de QUERY_STRING
$query =~ s/fn=//;
$query = uri_unescape($query);  # Descodificar la URL para manejar los espacios y caracteres especiales

# Sanitizar el nombre del archivo (permitir solo letras, números, guiones y guiones bajos)
$query =~ s/[^a-zA-Z0-9_-]//g;

# Construir la ruta completa al archivo
my $file = "pages/$query.md";

# Verificar si el archivo existe
if (-e $file) {
    # Intentar abrir el archivo
    open(my $fh, '<', $file) or do {
        print "<h1>Error</h1>";
        print "<p>No se puede abrir el archivo: $!</p>";
        exit;
    };

    # Leer el contenido del archivo
    my $content = do { local $/; <$fh> };
    close($fh);

    # Reemplazar los '+' por espacios en el contenido leído
    $content =~ tr/+/ /;  # Reemplaza '+' por espacios

    # Convertir el contenido Markdown a HTML
    my $html = markdown($content);

    # Mostrar el título y el contenido HTML
    print "<div class='content-container'>";
    print "<div class='custom-header'>$query</div>";
    print "<div class='page-content'>$html</div>";
    print "</div>";

    # Enlace para volver al listado
    print "<p><a href='list.pl'>Volver al Listado</a></p>";
} else {
    # Si el archivo no existe, mostrar un mensaje de error
    print "<div class='message error'>";
    print "<h1>Error</h1>";
    print "<p>Página no encontrada: $query.md</p>";
    print "<p><a href='list.pl' class='botn'>Volver al Listado</a></p>";
    print "</div>";
}

# Cerrar el cuerpo y el HTML
print "</body>";
print "</html>";
