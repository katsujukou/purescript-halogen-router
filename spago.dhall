{ name = "halogen-router"
, license = "MIT"
, repository = "https://github.com/katsujukou/purescript-halogen-router"
, dependencies =
  [ "aff"
  , "effect"
  , "either"
  , "foreign"
  , "halogen"
  , "halogen-hooks"
  , "halogen-store"
  , "halogen-subscriptions"
  , "maybe"
  , "prelude"
  , "routing"
  , "routing-duplex"
  , "safe-coerce"
  , "transformers"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
