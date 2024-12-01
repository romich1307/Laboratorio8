#!/usr/bin/perl
use strict;
use warnings;
use URI::Escape;

print "Content-type: text/html; charset=UTF-8\n\n";

# Aquí agregamos el enlace al archivo CSS
print "<!DOCTYPE html>";
print "<html lang='es'>";
print "<head>";
print "<meta charset='UTF-8'>";
print "<meta name='viewport' content='width=device-width, initial-scale=1.0'>";
print "<title>Páginas Wiki</title>";
# Asegúrate de que la ruta sea correcta según la ubicación de tu archivo CSS
print "<link rel='stylesheet' href='/css/style.css'>";
print "</head>";
print "<body>";

# Título de la página
print "<div class='wiki-title'>Nuestras páginas de wiki</div>";


# Contenedor principal para las páginas
print "<div class='pages-container'>";

# Verificar si el directorio 'pages' existe
my $dir_path = "pages";
unless (-d $dir_path) {
    print "<p>Error: El directorio 'pages' no existe.</p>";
    exit;
}

# Intentar abrir el directorio
opendir(my $dir, $dir_path) or die "No se puede abrir el directorio: $!";

# Contenedor para la lista de páginas
print "<ul class='pages-list'>";

# Leer los archivos en el directorio y mostrarlos como enlaces
while (my $file = readdir($dir)) {
    next if ($file =~ m/^\./); # Saltar archivos ocultos (p. ej., . y ..)
    my $name = $file;
    $name =~ s/\.md$//;  # Eliminar la extensión '.md'
    
    # Escapar el nombre del archivo para que sea seguro en la URL
    my $escaped_name = uri_escape($name);

    # Contenedor de cada página (con enlaces y botones)
    print "<li class='page-item'>";
    print "<a href='view.pl?fn=$escaped_name' class='page-link'>$name</a>";

    # Contenedor de los botones (Editar y Eliminar)
    print "<div class='page-buttons'>";
    
    # Botón de Editar (E)
    print " <a href='edit.pl?fn=$escaped_name' class='edit-button'>[E]</a>";

    # Botón de Eliminar (X)
    print " <a href='delete.pl?fn=$escaped_name' class='delete-button' onclick='return confirm(\"¿Estás seguro de que quieres eliminar esta página?\");'>[X]</a>";

    print "</div>";  # Cierre del contenedor de botones
    print "</li>";  # Cierre del ítem de la lista
}

closedir($dir);

print "</ul>";  # Cierre de la lista de páginas

# Enlace para crear una nueva página
print "<p><a href='new.pl' class='new-page-link'>Nueva Página</a></p>";

print "</div>";  # Cierre del contenedor principal

print "</body>";
print "</html>";
