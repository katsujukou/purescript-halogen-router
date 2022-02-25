# Halogen Router
[![CI](https://github.com/katsujukou/purescript-halogen-router/actions/workflows/ci.yml/badge.svg)](https://github.com/katsujukou/purescript-halogen-router/actions/workflows/ci.yml)

Routing management for Halogen.

### TODO
  - Support Hash-based router.
  - Add tests.

## Installation
install `halogen-router` with Spago:
```
spago install halogen-router
```

## Quick Start
This library is the one-stop-shop for parsing, printing, navigating and subscribing to changes of the web application routes.

This library is merely a wrapper layer to following great libraries:
  - `purescript-routing`
  - `purescript-routing-duplex`

### Defining the routes as purescript type.
First of all, we should define the routes of our cool web app as standard PureScript type.
We also create the codec for our routes using the combinator from `purescript-routing-duplex`.
If you aren't familiar with that library, please refer to the [document](https://github.com/natefaubion/purescript-routing-duplex).

```purs
data MyRoute
  = Home
  | About

derive instance Eq MyRoute
derive instance Generic MyRoute _

routeCodec :: RouteDuplex' MyRoute
routeCodec = root $ sum
  { "Home": noArgs
  , "About": "about" / noArgs
  }
```
### Using the router
Next, we add the `MonadRouter r m` constraint on the underlying monad of the Halogen component, with its first type parameter specified to our `MyRoute` type:
```purs
import App.Route (MyRoute)
import Halogen.Router.Class (class MonadRouter)

component
  :: forall q i o m
   . MonadRouter MyRoute m
  => H.Component q i o m
```
Now we are ready to use the router functionality witin this component!
To do this, we can utilize those methods provided by the `MonadRoute` typeclass, but more simple and recommended way is to call the `useRouter` hook.
The `usRouter` hook returns the `Maybe MyRoute` value paired with the `RouterFn` utilities:
```purs
import Halogen.Hooks as Hooks
import Halogen.Router.PushState.UseRouter (useRouter)

component
  :: forall q i o m
   . MonadRouter MyRoute m
  => H.Component q i o m
component = Hooks.component \_ _ -> Hooks.do
  current /\ routerFn <- useRouter
```
With this, if current browser location' path matches with one of the defined routes, then `current` is the encoded `MyRoute` value wrapped in the `Just` constructor, and if matches none of the routes, then `Nothing` is returned. When browser location changed, `current` value also changes reactively.

The `routerFn` is the record containing two router functinality:
```purs
type RouterFn =
  { navigate :: MyRoute -> HookM m Unit -- update the browser location to the specified route
  , print :: MyRoute -> HookM m String -- print the `MyRoute` value as the path string.
  }
```

### Running the application
When we run the application, we'll transform the underlying monad, which satisfies the `MonadRouter` constraint, to the `Aff` monad.

To achieve this, we can define our application-specific monad using the `RouterT` transformer:
```purs
newtype AppM a = AppM (RouterT Aff a) 
```
This monad can be easily transformed to the `Aff` using `runRouterT`.
Of course, you can add as many transformer layers to the stack as you need.

The `runRouterT` require the router instance.
We can create the router instance by providing the `RouteDuplex` route codec to the `mkRouter` function. Here is the example:
```purs
import Halogen as H
import Halogen.Router.PushState.Trans (mkRouter, runRouter)
import Example.Component.App (app) -- our application's root component 

main :: Effect Unit
main = runHalogenAff do
  body <- awaitBody
  router <- mkRouter routeCodec
  let rootComponent = H.hoist (runRouterT router) app
  runUI rootComponent {} body
```