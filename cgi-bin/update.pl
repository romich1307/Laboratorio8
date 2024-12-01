#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

print "Content-type: text/html; charset=UTF-8\n\n";

# Aquí agregamos el enlace al archivo CSS
print "<!DOCTYPE html>";
print "<html lang='es'>";
print "<head>";
print "<meta charset='UTF-8'>";
print "<meta name='viewport' content='width=device-width, initial-scale=1.0'>";
print "<title>Actualizar Página</title>";
# Asegúrate de que la ruta sea correcta según la ubicación de tu archivo CSS
print "<link rel='stylesheet' href='/css/style.css'>";
print "</head>";
print "<body>";

# Obtener los parámetros del formulario
my $filename = param('filename');  # Nombre del archivo
my $content = param('content');    # Nuevo contenido

# Sanitizar el nombre del archivo para evitar problemas con rutas
$filename =~ s/[^a-zA-Z0-9_-]//g;
my $file = "pages/$filename.md";  # Ruta del archivo a actualizar

# Verificar si el archivo existe
if (-e $file) {
    # Intentar abrir el archivo para escribir
    open(my $fh, '>', $file) or die "No se puede abrir el archivo: $!";
    
    # Escribir el nuevo contenido en el archivo
    print $fh $content;
    
    # Cerrar el archivo
    close($fh);
    
    print "<div class='message success'>";
    print "<h1>Página actualizada con éxito</h1>";
    print "<p><a href='view.pl?fn=$filename' class='link'>Ver la página actualizada</a></p>";
    print "<p><a href='list.pl' class='link'>Volver al listado de páginas</a></p>";
    print "</div>";
} else {
    print "<div class='message error'>";
    print "<h1>Error: Página no encontrada</h1>";
    print "<p><a href='list.pl' class='link'>Volver al listado de páginas</a></p>";
    print "</div>";
}

print "</body>";
print "</html>";
