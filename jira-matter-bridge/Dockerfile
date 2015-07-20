FROM node:6
RUN apt-get update && apt-get install -y unzip

ADD https://github.com/vrenjith/jira-matter-bridge/archive/master.zip /
RUN unzip master.zip

WORKDIR /jira-matter-bridge-master
EXPOSE 3000

RUN npm install
CMD ["npm", "start"]

