module Example.Views.Home where

import Prelude

import Halogen (ClassName(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks

homeView
  :: forall q i o m
   . H.Component q i o m
homeView = Hooks.component \_ _ -> Hooks.do
  Hooks.pure do
    HH.div [HP.class_ $ ClassName "home-view"]
      [ HH.h1_
        [ HH.text "Halogen Router Example" ]
      , HH.div_
        [ HH.p_
          [ HH.text
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, \
              \sed do eiusmod tempor incididunt ut labore et dolore magna \
              \aliqua. Ut enim ad minim veniam, quis nostrud exercitation \
              \ullamco laboris nisi ut aliquip ex ea commodo consequat. \
              \Duis aute irure dolor in reprehenderit in voluptate velit \
              \esse cillum dolore eu fugiat nulla pariatur. \
              \Excepteur sint occaecat cupidatat non proident, \
              \sunt in culpa qui officia deserunt mollit anim id est laborum."
          ]
        ] 
      ]