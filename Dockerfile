# Usar la imagen base de Ubuntu 20.04
FROM ubuntu:20.04

# Evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar Apache, Perl, cpanminus (cpanm), locales y otras dependencias necesarias
RUN apt-get update && \
    apt-get install -y apache2 perl libcgi-pm-perl dos2unix wget curl build-essential locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configurar UTF-8 en el sistema
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Instalar cpanminus (cpanm) para instalar módulos de Perl de manera más sencilla
RUN curl -L https://cpanmin.us | perl - App::cpanminus

# Instalar Text::Markdown utilizando cpanminus
RUN cpanm Text::Markdown

# Deshabilitar cgid y habilitar cgi, asegurar mpm_prefork
RUN a2dismod mpm_event mpm_worker cgid && \
    a2enmod mpm_prefork cgi

# Crear directorios necesarios
RUN mkdir -p /var/www/html/pages && \
    chmod -R 755 /var/www/html/pages && \
    chown -R www-data:www-data /var/www/html/pages

# Crear directorio para los scripts CGI si no existe
RUN mkdir -p /usr/lib/cgi-bin/

# Copiar archivos HTML y otros recursos al contenedor Docker
COPY css/ /var/www/html/css/
COPY *.html /var/www/html/
COPY images/ /var/www/html/images/
# Copiar scripts CGI al directorio correcto del contenedor Docker y configurar permisos
COPY cgi-bin/*.pl /usr/lib/cgi-bin/
# Asegurarte de que Apache tenga acceso a la carpeta de imágenes
RUN chmod -R 755 /var/www/html/images && \
    chown -R www-data:www-data /var/www/html/images
RUN chmod 755 /usr/lib/cgi-bin/*.pl && \
    chown -R www-data:www-data /usr/lib/cgi-bin/ && \
    dos2unix /usr/lib/cgi-bin/*.pl

# Configurar Apache para permitir CGI
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN echo "\
<Directory \"/usr/lib/cgi-bin\">\n\
    AllowOverride None\n\
    Options +ExecCGI\n\
    AddHandler cgi-script .cgi .pl\n\
    Require all granted\n\
</Directory>\n" >> /etc/apache2/apache2.conf

# Configurar logs para depuración
RUN echo "LogLevel debug" >> /etc/apache2/apache2.conf

# Ajustes de Prefork MPM
RUN echo "\
<IfModule mpm_prefork_module>\n\
    StartServers             5\n\
    MinSpareServers          5\n\
    MaxSpareServers         10\n\
    MaxRequestWorkers      150\n\
    MaxConnectionsPerChild   0\n\
</IfModule>\n" >> /etc/apache2/mods-enabled/mpm_prefork.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]
