# pull official base image
FROM node:13.12.0-alpine

RUN mkdir -p /app/frontend
# set working directory
WORKDIR /app/frontend

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY yarn.lock ./
RUN yarn install
RUN yarn add react-scripts@3.4.1 -g

# add app
COPY . ./

# start app
CMD ["yarn", "start"]