# UFO Hotspots 2.0

## Introduction

Thank you for your interest in Verisys. We have a great group of engineers that love solving problems and coming up with cool solutions to helping protect our families.

The purpose of the challenge is to help us evaluate you as an engineer. We aren’t looking for the prettiest UI or the most verbose code. We value engineers that:

- Write clean and maintainable code
- Write code that works and is tested
- Have good architectural skills
- Are quick and continuous learners
- Follow best practices
- Have fun

As this is a personal challenge we encourage you to use the internet to its fullest to help you solve this problem - with just a few limitations that wouldn’t be present in the real world:

- Don’t ask your friends or neighbors for help
- Don’t reuse someone else’s solution

This is **_YOUR_** chance to shine. Be honest and do your best.

We don’t want you to spend more than 3-4 hours on this project (you do have a life outside of coding?). It isn’t anticipated that you will finish the whole thing. Get as far as you can, time box yourself and provide guidance on what you would do next.

## Submission

You can either put your solution up on GitHub / BitBucket in your own repository or you can zip it all up and send it to us via email. You will need to include:

- Source code
- Completed Docker Compose file
- JSON Output from the sighting file and hotspot data you ingest
- Dockerfile (unless you put your image out on dockerhub)
- Readme - that includes:
  - Instructions on how to build and run your solution (command-line and API)
  - Overview of the process you followed and the technologies you used
  - Description of your database schema
  - Any challenges you faced
  - Assumptions you made
  - Next steps to finish the challenge
  - Feedback on the challenge itself
  - Any Questions you may have

## Challenge Background

The US has identified 5 UFO sensitive hotspots. They are located at:

- The White House (38.897663, -77.036575)
- World’s Tallest Thermometer (35.26644, -116.07275)
- Area 51 (37.233333, -115.808333)
- Disney World’s Magic Kingdom (28.404010, -81.576900)
- Pop's Soda Bottle (35.658340, -97.335490)

Your mission is to determine all UFO sightings that come within 750 miles of these geographic locations and report them out as JSON data.

Sighting data is received either by CSV file with the following headers (see the sample provided):

- Sighting date/time ( ex. 10/10/1949 8:30:00 PM)
- Shape
- Duration (seconds)
- Duration (hours)
- Comments
- Site Location Lat/Lng

Sighting data can also be posted to our web application. The POST command needs to receive `application/x-www-form-urlencoded` data fields. Here is an example curl command to send the data:

```
curl -d 'sighting_date=1972-12-01 03:16:56 +0000' -d 'shape=Circle' -d 'duration=10' -d 'comments=foo' -d 'city=Salt Lake' -d 'state=Utah' -d 'latitude=39.23333' -d 'longitude=-98.334309' http://localhost:5000/sighting
```

The post form elements contains the following fields:

- sighting_date (ex. 2019-12-12 03:16:56 +0000)
- shape (Chevron, Circle, Rectangle, etc)
- duration (integer number of minutes)
- comments (text)
- city (text)
- state (text)
- latitude
- longitude

## Challenge Steps

1. Create an appropriate database schema
1. Provide a command-line way to load the CSV file into the database
1. Provide a command-line way to produce a JSON file with all of the hotspots and any sightings within 750 miles of the hotspot. (For this exercise, you do not need to take into account the curvature of the earth as you are calculating distances. Just the simple distance formula that you learned in high school will be sufficient.)
1. Provide an API to load individual sightings from POST requests
1. Provide an API to request the JSON of sightings within 750 miles of the hotspots.
1. Create a web app page to manage the hotspots (Add, Update, Remove)
1. Create a “live sightings” dashboard page that shows the sightings as they are loaded in real-time.
1. Create a map of the sightings ... (the list could go on and on)

You only have 3-4 hours to complete the assignment. We realize that you **_will likely not_** be able to complete all of the above steps. Accomplish what you can and be prepared to talk about the next steps to make the application complete.

When you reach the 4 hour mark, please stop whatever you are working on, and comment out / rollback any code that would prevent your application from executing. Then, finish up your documentation and submit your code. Good Luck!

## Docker

We want to know that you understand Docker (or can learn about it). We expect you to fill out a docker compose file that will allow us to run your application from localhost. We provide (attached) a sample docker-compose.yml file that will get a MySQL database up and running to help point you in the right direction. You can use the schemadump.sql file to create your schemas and load the hotspot information, but your sightings data should be cleansed and loaded via your application.

The docker-compose-live.yml file is a sample that uses an image from dockerhub (doldroyd/ufo-sighting) to randomly post UFO sightings to your application. All you need to do is to change the ENDPOINT environment variable to point to your application’s endpoint and it will start making posts to your API. You don’t need to use that image - it is just there to help you.

Any time that you need to pick up docker doesn’t count towards your 3-4 hours for the assignment.

### Instructions for docker compose:

- Make sure docker is installed

  - For Mac: https://www.docker.com/docker-mac
  - For Windows: https://www.docker.com/docker-windows
  - For Ubuntu: https://www.docker.com/docker-ubuntu

- run `docker-compose up -d`

  - This will create a container called mysqldb
  - To verify it was created you can run `docker ps`
    - it should show up in the list of containers

- To tear down your environment you can run docker-compose down so that you can spin it from scratch as you make changes

- We have also included a schemadump.sql file which is where you should put the DDL for creating your schema. The database name is test which is consistent with what is specified in the docker-compose.yml file

- The schemadump.sql script should automatically run when the pod spins up

  - If you get an error like `ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)` then just wait a minute or two for mysql to fully initialize and then try again

- To bash into your mysql container you can run `docker exec -it mysqldb bash` and you can either login to MySQL with user:root pass:root or user:test pass:test

- Refer to https://docs.docker.com/compose/gettingstarted/ for the official Docker Compose tutorial
