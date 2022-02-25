module Example.Views.About where

import Prelude

import Halogen (ClassName(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks

aboutView
  :: forall q i o m
   . H.Component q i o m
aboutView = Hooks.component \_ _ -> Hooks.do
  Hooks.pure do
    HH.div [HP.class_ $ ClassName "about-view"]
      [ HH.h1_
        [ HH.text "This is About page." ]
      ]