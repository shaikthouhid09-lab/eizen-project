FROM nginx:alpine

# Remove default nginx config
RUN rm -f /etc/nginx/nginx.conf

# Copy nginx configs from project root
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Create log directory
RUN mkdir -p /var/log/nginx && chown -R nginx:nginx /var/log/nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

