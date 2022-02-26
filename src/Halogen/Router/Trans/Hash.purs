module Halogen.Router.Trans.Hash
  ( RouterInstance
  , RouterT(..)
  , mkRouter
  , runRouterT
  )
  where

import Prelude

import Control.Monad.Error.Class (class MonadError, class MonadThrow)
import Control.Monad.Reader (class MonadAsk, class MonadTrans, ReaderT, ask, asks, lift, runReaderT)
import Data.Either (hush)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Halogen.Router.Class (class MonadNavigate, class MonadRouter, current)
import Halogen.Store.Monad (class MonadStore, emitSelected, getStore, updateStore)
import Halogen.Subscription (Emitter, Listener)
import Halogen.Subscription as HS
import Routing.Duplex (RouteDuplex')
import Routing.Duplex as RouteDuplex
import Routing.Hash (getHash, matchesWith, setHash)
import Safe.Coerce (coerce)

type RouterInstance r =
  { codec :: RouteDuplex' r
  , emitter :: Emitter r
  , listener :: Listener r
  }

newtype RouterT :: Type -> (Type -> Type) -> Type -> Type
newtype RouterT r m a = RouterT (ReaderT (RouterInstance r) m a)

derive newtype instance Functor m => Functor (RouterT r m)
derive newtype instance Apply m => Apply (RouterT r m)
derive newtype instance Applicative m => Applicative (RouterT r m)
derive newtype instance Bind m => Bind (RouterT r m)
derive newtype instance Monad m => Monad (RouterT r m)
derive newtype instance MonadTrans (RouterT r)
derive newtype instance MonadEffect m => MonadEffect (RouterT r m)
derive newtype instance MonadAff m => MonadAff (RouterT r m)
derive newtype instance MonadThrow e m => MonadThrow e (RouterT r m)
derive newtype instance MonadError e m => MonadError e (RouterT r m)

instance MonadEffect m => MonadAsk (Maybe r) (RouterT r m) where
  ask = current 

instance MonadStore a s m => MonadStore a s (RouterT r m) where
  getStore = lift getStore
  updateStore = lift <<< updateStore
  emitSelected = lift <<< emitSelected

instance MonadEffect m => MonadNavigate r (RouterT r m) where
  navigate to = RouterT $ do
    { codec } <- ask
    liftEffect $ setHash (RouteDuplex.print codec to)

  current = RouterT do
    { codec } <- ask
    hash <- liftEffect getHash
    pure $ hush $ RouteDuplex.parse codec hash

instance MonadEffect m => MonadRouter r (RouterT r m) where
  print route = RouterT $ do
    { codec } <- ask
    pure $ RouteDuplex.print codec route
  
  emitMatched = RouterT $ asks _.emitter

mkRouter :: forall r. Eq r => RouteDuplex' r -> Effect (RouterInstance r)
mkRouter codec = do
  { emitter, listener } <- HS.create
  void $ matchesWith (RouteDuplex.parse codec) \from to -> do
    when (from /= Just to) do
      HS.notify listener to

  pure { codec, emitter, listener }

runRouterT :: forall r m. RouterInstance r -> RouterT r m ~> m
runRouterT router = coerce >>> flip runReaderT router