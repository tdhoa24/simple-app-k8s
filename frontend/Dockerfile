# Stage 1: Build (optional if you're using build tools)

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy custom static site content
COPY ./index.html /usr/share/nginx/html/index.html

# Optional: If you have script.js, style.css, images, etc.
# COPY ./static /usr/share/nginx/html/static

# Copy custom nginx config (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
