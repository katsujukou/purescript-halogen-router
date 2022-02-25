module Example.Components.App where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Example.Components.HeaderMenu (headerMenu)
import Example.Data.Route (Route(..))
import Example.Views.About (aboutView)
import Example.Views.Home (homeView)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.Router.Class (class MonadRouter)
import Halogen.Router.PushState.UseRouter (useRouter)
import Type.Proxy (Proxy(..))

app
  :: forall q i o m
   . MonadRouter Route m
  => H.Component q i o m
app = Hooks.component \_ _ -> Hooks.do
  current /\_ <- useRouter

  Hooks.pure do
    HH.div [ HP.id "app" ]
      [ HH.slot_ (Proxy :: Proxy "headerMenu") unit headerMenu {}
      , routerView current
      ]

  where
    routerView :: Maybe Route -> HH.HTML _ _
    routerView = case _ of
      Nothing -> HH.text "Sorry, that page does not exist"
      Just route -> case route of
        Home -> HH.slot_ (Proxy :: Proxy "home") unit homeView {}
        About -> HH.slot_ (Proxy :: Proxy "about") unit aboutView {}
