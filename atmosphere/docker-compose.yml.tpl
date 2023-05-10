version: "3"
services:
  db:
    image: postgres:10-alpine
    volumes:
      - ./pg_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: ${database_password}
      POSTGRES_DB: ohmyform
    restart: unless-stopped
  nginx:
    image: nginx:alpine
    volumes:
      - "./default.conf:/etc/nginx/conf.d/default.conf"
    ports:
      - "8080:8080"
    depends_on:
      - ui
      - api
    restart: unless-stopped
  ui:
    image: ohmyform/ui
    environment:
      SERVER_ENDPOINT: http://api:5000/graphql
      PORT: 5000
    restart: unless-stopped
  api:
    image: ohmyform/api
    environment:
      CREATE_ADMIN: "true"
      ADMIN_EMAIL: ${webmaster_email}
      ADMIN_USERNAME: admin
      ADMIN_PASSWORD: ${admin_password}
      DATABASE_DRIVER: postgres
      DATABASE_URL: postgresql://root:${database_password}@db:5432/ohmyform
      MAILER_URI: smtp://local.host
      REDIS_URL: redis://redis
      PORT: 5000
    links:
      - db
    depends_on:
      - db
    restart: unless-stopped