server {
    listen 80;

    location / {
      proxy_pass         http://ui:5000;
      proxy_redirect     off;
      proxy_set_header   Host $host;
    }

    location  /graphql {
      proxy_pass         http://api:5000;
      proxy_redirect     off;
      proxy_set_header   Host $host;
    }
}