module Halogen.Router.UseRouter where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested (type (/\), (/\))
import Halogen.Hooks (class HookNewtype, type (<>), Hook, HookM, HookType, UseEffect, UseState, useLifecycleEffect, useState)
import Halogen.Hooks as Hooks
import Halogen.Router.Class (class MonadRouter, current, emitMatched, navigate, print)

foreign import data UseRouter :: Type -> HookType

type UseRouter' :: Type -> HookType
type UseRouter' route = UseState (Maybe route) <> UseEffect <> Hooks.Pure

instance HookNewtype (UseRouter route) (UseRouter' route)

type RouterFn route m =
  { navigate :: route -> HookM m Unit
  , print :: route -> HookM m String
  }

useRouter
  :: forall m route
   . Eq route
  => MonadRouter route m
  => Hook m (UseRouter route) ((Maybe route) /\ (RouterFn route m))
useRouter = Hooks.wrap hook
  where
    hook :: Hook m (UseRouter' route) ((Maybe route) /\ (RouterFn route m))
    hook = Hooks.do
      matchedRoute /\ matchedRouteId <- useState Nothing

      useLifecycleEffect do
        emitter <- emitMatched
        subscriptionId <- Hooks.subscribe $ map (Just >>> Hooks.put matchedRouteId) emitter
        current >>= Hooks.put matchedRouteId 
        pure $ Just $ Hooks.unsubscribe subscriptionId

      Hooks.pure $ matchedRoute /\ { navigate, print }