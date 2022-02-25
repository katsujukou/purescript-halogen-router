# Basic Halogen-Router Example

This directory contains very simple Halogen app using `halogen-router`

## Running app
Follow the instructions below.
Note: You need the Docker installed.
```
cd example
spago bundle-app -m Example.Main -t example/dist/app.js
docker image build -t halogen_router_example/latest .
docker container run  -d -p 38080:80 halogen_router_example/lates
```

## Application structure
```
 src/
  |_ Components/
  |   |_ App.purs          -- The app root component.
  |   |_ HeaderMenu.purs   -- Header menu which works as app router part.
  |
  |_ Views/
  |   |_ Home.purs         -- View for root page (/)
  |   |_ About.purs        -- View for about page (/about).
  |
  |_ Data/
  |   |_ Route.purs        -- Define app's routes.
  |
  |_ Main.purs             -- app entry point.
```