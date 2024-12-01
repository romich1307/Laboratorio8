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
print "<title>Eliminar Página</title>";
# Asegúrate de que la ruta sea correcta según la ubicación de tu archivo CSS
print "<link rel='stylesheet' href='/css/style.css'>";
print "</head>";
print "<body>";

# Obtener el nombre de la página desde la URL
my $query = param('fn');
$query =~ s/[^a-zA-Z0-9_-]//g;  # Sanitizar el nombre del archivo
my $file = "pages/$query.md";

if (-e $file) {
    # Eliminar el archivo
    unlink($file) or die "No se pudo eliminar el archivo: $!";

    print "<div class='message success'>";
    print "<h1>Página eliminada</h1>";
    print "<p1>La página '$query' ha sido eliminada exitosamente.</p1>";
    print "<p><a href='list.pl' class='link'>Volver al Listado</a></p>";
    print "</div>";
} else {
    print "<div class='message error'>";
    print "<h1>Error</h1>";
    print "<p>La página no existe.</p>";
    print "<p><a href='list.pl' class='link'>Volver al Listado</a></p>";
    print "</div>";
}

print "</body>";
print "</html>";
