FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build


FROM nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf.template
#COPY ./entrypoint.sh /usr/share/nginx/
#RUN chmod +x /usr/share/nginx/entrypoint.sh
COPY --from=builder /app/build /usr/share/nginx/html
#CMD ["/bin/sh", "/usr/share/nginx/entrypoint.sh"]
CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'