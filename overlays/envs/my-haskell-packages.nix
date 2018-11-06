pkgs: version:  haskellPackages:

with haskellPackages; [
  Boolean
  HTTP
  HUnit
  IfElse
  MemoTrie
  QuickCheck
  adjunctions
  aeson
  async
  async-pool
  attoparsec
  attoparsec-conduit
  base
  base16-bytestring
  base64-bytestring
  basic-prelude
  bench
  bifunctors
  blaze-builder
  blaze-builder-conduit
  blaze-builder-enumerator
  blaze-html
  blaze-markup
  blaze-textual
  bool-extras
  brittany
  byteable
  byteorder
  bytes
  bytestring
  bytestring-show
  # cabal-helper
  case-insensitive
  cassava
  categories
  cereal
  cereal-conduit
  charset
  checkers
  cmdargs
  # codex
  commodities
  comonad
  comonad-transformers
  composition
  compressed
  conduit
  conduit-combinators
  conduit-extra
  configurator
  connection
  consistent
  constraints
  containers
  contravariant
  convertible
  cpphs
  criterion
  cryptohash
  curl
  deepseq
  diagrams
  # diagrams-builder
  diagrams-core
  diagrams-lib
  diagrams-svg
  directory
  distributive
  dlist
  dlist-instances
  dns
  doctest
  doctest-prop
  either
  enclosed-exceptions
  errors
  exceptions
  extensible-exceptions
  fast-logger
  fgl
  file-embed
  filepath
  fingertree
  fmlist
  foldl
  free
  freer-simple
  fsnotify
  generic-lens
  ghc-core
  # ghc-mod
  ghc-paths
  gitlib
  # gitlib-test
  groups
  hakyll
  hashable
  hashtables
  # haskdogs
  # hasktags
  hdevtools
  hedgehog
  hedgehog-checkers
  hierarchy
  hindent
  hlibgit2
  hlint
  hnix
  hpack
  hscolour
  hslogger
  html
  http-client
  http-date
  http-media
  http-types
  interpolate
  io-memoize
  io-storage
  io-streams
  json
  json-stream
  jwt
  katip
  keys
  lambdabot
  language-c
  lattices
  lens
  lens-action
  lens-aeson
  lens-datetime
  lens-family
  lens-family-core
  lifted-async
  lifted-base
  linear
  list-extras
  list-t
  logging
  machines
  megaparsec
  mime-mail
  mime-types
  mmorph
  monad-control
  monad-coroutine
  monad-extras
  monad-logger
  monad-loops
  monad-par
  monad-par-extras
  monad-stm
  monoid-extras
  mtl
  multimap
  network
  network-simple
  newtype
  numbers
  operational
  optparse-applicative
  parallel
  parallel-io
  parsec
  parsers
  pcre-heavy
  pipes
  pipes-async
  pipes-attoparsec
  pipes-binary
  pipes-bytestring
  pipes-concurrency
  pipes-extras
  # pipes-files
  pipes-group
  pipes-http
  pipes-network
  pipes-safe
  pipes-text
  pipes-zlib
  pointed
  pointfree
  posix-paths
  postgresql-simple
  pretty-show
  primitive
  process
  process-extras
  profunctors
  quickcheck-instances
  random
  recursors
  reducers
  reflection
  regex-applicative
  regex-base
  regex-compat
  regex-posix
  retry
  safe
  scalpel
  scientific
  semigroupoids
  semigroups
  semiring-simple
  servant
  servant-blaze
  servant-client
  servant-docs
  servant-foreign
  servant-js
  servant-server
  silently
  simple-reflect
  speculation
  split
  stm
  stm-chans
  stm-stats
  streaming
  streaming-bytestring
  strict
  stringsearch
  strptime
  stylish-haskell
  system-fileio
  system-filepath
  tagged
  tar
  tardis
  tasty
  tasty-expected-failure
  tasty-hedgehog
  tasty-hunit
  tasty-quickcheck
  temporary
  text
  text-format
  text-show
  these
  thyme
  time
  time-recurrence
  # timeparsers
  timeplot
  tls
  total
  transformers
  transformers-base
  transformers-bifunctors
  trifecta
  turtle
  uniplate
  unix
  unix-compat
  unordered-containers
  uuid
  vector
  vector-sized
  void
  wai
  warp
  x509
  yaml
  zippers
] ++

(pkgs.stdenv.lib.optionals (version < 8.3)
[
])

