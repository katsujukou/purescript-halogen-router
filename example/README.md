# Basic Halogen-Router Example

This directory contains very simple Halogen app using `halogen-router`

## Running app
Follow the instructions below.
Note: You need the Docker installed.
```
npm run example
cd example
docker image build -t halogen_router_example/latest .
docker container run  -d -p 38080:80 halogen_router_example/latest
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