#!/bin/bash
# Atualiza o sistema e instala o Docker
yum update -y
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Cria diretórios para os certificados SSL e a configuração do Nginx
mkdir -p /etc/nginx/ssl
cd /etc/nginx/ssl

# Gera um certificado autoassinado para testes
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout nginx.key -out nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=www.example.com"

# Cria um arquivo de configuração do Nginx para HTTPS
cat > /etc/nginx/nginx.conf <<EOF
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    log_format main '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                    '\$status \$body_bytes_sent "\$http_referer" '
                    '"\$http_user_agent" "\$http_x_forwarded_for"';
    access_log /var/log/nginx/access.log main;
    sendfile on;
    keepalive_timeout 65;

    server {
        listen 443 ssl;
        server_name localhost;

        ssl_certificate /etc/nginx/ssl/nginx.crt;
        ssl_certificate_key /etc/nginx/ssl/nginx.key;

        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout 5m;

        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;

        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
        }
    }
}
EOF

# Executa o container Nginx com a configuração personalizada
docker run --name nginx -p 443:443 -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -v /etc/nginx/ssl:/etc/nginx/ssl:ro -d nginx
