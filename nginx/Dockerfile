FROM nginx

COPY index.html /etc/nginx/html/index.html
COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD echo "REVERSE_PROXY_DOMAIN_NAME=$REVERSE_PROXY_DOMAIN_NAME" && \
    sed -e "s,REVERSE_PROXY_DOMAIN_NAME,$REVERSE_PROXY_DOMAIN_NAME,g" -i /etc/nginx/html/index.html && \
    sed -e "s,REVERSE_PROXY_DOMAIN_NAME,$REVERSE_PROXY_DOMAIN_NAME,g" -i /etc/nginx/conf.d/default.conf && \
    nginx -g 'daemon off;'
