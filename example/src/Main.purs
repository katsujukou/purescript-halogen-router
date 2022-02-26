module Example.Main where

import Prelude

import Effect (Effect)
import Effect.Class (liftEffect)
import Example.Components.App (app)
import Example.Data.Route (routeCodec)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.Router.Trans.Hash (mkRouter, runRouterT)
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = runHalogenAff do
  body <- awaitBody
  router <- liftEffect $ mkRouter routeCodec
  let rootComponent = H.hoist (runRouterT router) app
  runUI rootComponent {} body
