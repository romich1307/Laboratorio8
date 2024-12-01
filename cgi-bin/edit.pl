#!/usr/bin/perl
use strict;
use warnings;
use URI::Escape;
use CGI qw(:standard);
use Text::Markdown qw(markdown);

print "Content-type: text/html; charset=UTF-8\n\n";

# Aquí agregamos el enlace al archivo CSS
print "<!DOCTYPE html>";
print "<html lang='es'>";
print "<head>";
print "<meta charset='UTF-8'>";
print "<meta name='viewport' content='width=device-width, initial-scale=1.0'>";
print "<title>Editar Página</title>";
# Asegúrate de que la ruta sea correcta según la ubicación de tu archivo CSS
print "<link rel='stylesheet' href='/css/style.css'>";
print "</head>";
print "<body>";

# Obtener el nombre de la página desde la URL (QUERY_STRING)
my $query = param('fn');
$query =~ s/[^a-zA-Z0-9_-]//g;  # Sanitizar el nombre del archivo
my $file = "pages/$query.md";

if (-e $file) {
    # Leer el contenido del archivo
    open(my $fh, '<', $file) or die "No se puede abrir el archivo: $!";
    my $content = do { local $/; <$fh> };
    close($fh);

    # Formulario para editar
    print "<div class='edit-container'>";
    print "<h1 class='editar-pagina'>Editar Página: $query</h1>";
    print "<form action='update.pl' method='POST' class='edit-form'>";
    print "<input type='hidden' name='filename' value='$query'>";
    print "<textarea name='content' rows='10' cols='50' class='content-textarea'>$content</textarea><br>";
    print "<input type='submit' value='Guardar Cambios' class='submit-button'>";
    print "</form>";
    print "</div>";
} else {
    print "<p class='pagina-no-encontrada'>Página no encontrada.</p>";

}

print "</body>";
print "</html>";
