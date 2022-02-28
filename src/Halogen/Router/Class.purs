module Halogen.Router.Class where

import Prelude

import Data.Maybe (Maybe)
import Effect.Class (class MonadEffect)
import Halogen (HalogenM, lift)
import Halogen.Hooks (HookM)
import Halogen.Subscription (Emitter)

-- | The `MonadNavigate` type class represents those monads which provide capabilities
-- | to get and set the browser location via the `current` and `navigate` function.
-- |
-- | An implementation is provided for two `RouterT`, one is for hash-based routing and 
-- | the other is for PushState-based routing. 
-- | `StoreT` from `purescript-halogen-store` are also supported.
class MonadEffect m <= MonadNavigate route m | m -> route where
  navigate :: route -> m Unit
  current :: m (Maybe route)

instance monadNavigateHalogenM :: MonadNavigate route m => MonadNavigate route (HalogenM st act sl out m) where
  navigate = lift <<<  navigate
  current = lift current

instance monadNavigateHookM :: MonadNavigate route m => MonadNavigate route (HookM m) where
  navigate = lift <<<  navigate
  current = lift current

-- | An extension of the `MonadNavigate` class that introduces two functions: `print` and `emitMatched`.
-- | `print` allows the route value to be printed as `String`, and `emitMatched` returns `Emitter` which emits 
-- | route values every time the browser location changed.
-- |
-- | An implementation is provided for two `RouterT`, one is for hash-based routing and 
-- | the other is for PushState-based routing. 
-- | `StoreT` from `purescript-halogen-store` are also supported.
class MonadNavigate route m <= MonadRouter route m where
  print :: route -> m String
  emitMatched :: m (Emitter route)

instance monadRouterHalogenM :: MonadRouter route m => MonadRouter route (HalogenM st act sl out m) where
  print = lift <<< print
  emitMatched = lift emitMatched

instance monadRouterHookM :: MonadRouter route m => MonadRouter route (HookM m) where
  print = lift <<< print
  emitMatched = lift emitMatched
