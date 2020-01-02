FROM node:13 as build

WORKDIR /app

COPY package.json /app/package.json
RUN npm install

COPY . .

RUN npm run-script build

FROM nginx:1.16.0-alpine

COPY --from=build /app/dist /usr/share/nginx/html/dist
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY AWS_logo_RGB.png /usr/share/nginx/html/

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/

# expose port 
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]