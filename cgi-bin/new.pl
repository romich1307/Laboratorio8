#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use URI::Escape;

# Imprimir el encabezado HTML
print "Content-type: text/html; charset=UTF-8\n\n";

# Mostrar el formulario cuando se accede a la página mediante GET
if ($ENV{'REQUEST_METHOD'} eq "GET") {
    print <<EOF;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Nueva Página</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <div class="new-page-container">
        <h1>Crear Nueva Página</h1>
        <form action="new.pl" method="POST">
            <label for="title">Título:</label>
            <input type="text" id="title" name="title" required><br><br>

            <label for="content">Contenido (Markdown):</label><br>
            <textarea id="content" name="content" rows="10" cols="50" required></textarea><br><br>

            <input type="submit" value="Crear Página">
            <button type="button" class="cancel-button" onclick="window.location.href='/index.html'">Cancelar</button>
        </form>
    </div>
</body>
</html>
EOF
}

# Procesar los datos del formulario cuando se accede mediante POST
if ($ENV{'REQUEST_METHOD'} eq "POST") {
    # Leer los datos del formulario
    read(STDIN, my $post_data, $ENV{'CONTENT_LENGTH'});

    # Decodificar los datos
    my ($title, $content) = $post_data =~ /title=([^&]*)&content=(.*)/;

    # Decodificar caracteres especiales
    $title = uri_unescape($title);
    $content = uri_unescape($content);

    # Sanitizar el título para evitar caracteres problemáticos
    $title =~ s/[^a-zA-Z0-9_-]/_/g;  # Reemplaza caracteres no permitidos por '_'

    # Crear el directorio 'pages' si no existe
    mkdir 'pages' unless -d 'pages';

    # Crear el archivo con el título como nombre
    open(my $fh, '>', "pages/$title.md") or die "No puedo guardar la página: $!\n";

    # Guardar el contenido en el archivo
    print $fh $content;
    close($fh);

    # Mostrar mensaje de éxito con tabla y botón
    print <<EOF;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página Guardada con Éxito</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <div class="container">
        print "<div class='success-message'>Página Guardada con Éxito</div>";
        <table>
            <tr>
                <td>
                    <p>Página guardada correctamente.</p>
                </td>
                <td>
                    <a href="list.pl">
                        <button type="button" class="btn">Ver Lista de Páginas</button>
                    </a>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
EOF
}
