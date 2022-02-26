module Example.Components.HeaderMenu where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Example.Data.Route (Route(..))
import Halogen (ClassName(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.Router.Class (class MonadRouter)
import Halogen.Router.UseRouter (useRouter)

headerMenu
  :: forall q i o m
   . MonadRouter Route m
  => H.Component q i o m
headerMenu = Hooks.component \_ _ -> Hooks.do
  current /\ { navigate } <- useRouter

  let
    routerLink :: Route -> HH.HTML _ _
    routerLink route =
      let
        classes = ClassName $ "router-link px-5 py-2 mx-2"
          <> (if current == Just route then " is-active" else "")

        label = case _ of
          Home -> "HOME"
          About -> "ABOUT"
      in
        HH.li
          [ HP.class_ classes ]
          [ HH.a
            [ HE.onClick \_ -> navigate route
            , HP.href "javascript:"
            ]
            [ HH.text $ label route ]
          ]

  Hooks.pure do
    HH.div [ HP.class_ $ ClassName "header-menu"]
      [ HH.ul [HP.class_ $ ClassName "is-flex is-flex-direction-row is-justify-content-center"]
        (routerLink <$> [Home, About])
      ]