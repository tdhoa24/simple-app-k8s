FROM node:18
WORKDIR /app
COPY . .
RUN npm install express pg cors
EXPOSE 5001
CMD ["node", "index.js"]
