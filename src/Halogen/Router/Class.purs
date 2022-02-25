module Halogen.Router.Class where

import Prelude

import Data.Maybe (Maybe)
import Effect.Class (class MonadEffect)
import Halogen (HalogenM, lift)
import Halogen.Hooks (HookM)
import Halogen.Subscription (Emitter)

class MonadEffect m <= MonadNavigate route m | m -> route where
  navigate :: route -> m Unit
  current :: m (Maybe route)

instance monadNavigateHalogenM :: MonadNavigate route m => MonadNavigate route (HalogenM st act sl out m) where
  navigate = lift <<<  navigate
  current = lift current

instance monadNavigateHookM :: MonadNavigate route m => MonadNavigate route (HookM m) where
  navigate = lift <<<  navigate
  current = lift current
  
class MonadNavigate route m <= MonadRouter route m where
  print :: route -> m String
  emitMatched :: m (Emitter route)

instance monadRouterHalogenM :: MonadRouter route m => MonadRouter route (HalogenM st act sl out m) where
  print = lift <<< print
  emitMatched = lift emitMatched

instance monadRouterHookM :: MonadRouter route m => MonadRouter route (HookM m) where
  print = lift <<< print
  emitMatched = lift emitMatched
