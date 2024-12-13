FROM node:12.18.1
 
WORKDIR /app
 
#COPY package.json package.json
#COPY package-lock.json package-lock.json
 
#RUN npm install
 
COPY . .
 
CMD [ "node", "server.js" ]

#FROM node:6.14.2
#EXPOSE 8080
#COPY server.js .
#CMD node server.js
