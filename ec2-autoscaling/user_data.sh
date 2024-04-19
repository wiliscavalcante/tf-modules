#!/bin/bash
# Atualiza os pacotes
yum update -y

# Instala o Docker
yum install docker -y

# Inicia o serviço Docker
service docker start

# Garante que o Docker será iniciado após reinicializações
chkconfig docker on

# Roda um container Docker com Nginx
docker run --name nginx -p 80:80 -d nginx

# Substitui a página padrão do Nginx pelo nome do projeto
echo "<html><head><title>Projeto</title></head><body><h1>Projeto: ${project_name}</h1></body></html>" > /usr/share/nginx/html/index.html

# Reinicia o container para aplicar as mudanças
docker exec nginx nginx -s reload
