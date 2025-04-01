FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install --legacy-peer-deps
EXPOSE 8800
CMD ["npm", "start"]
