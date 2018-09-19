module Data.Reprinting.Token
  ( Token (..)
  , isChunk
  , isControl
  , Element (..)
  , Control (..)
  ) where

import Data.Text (Text)
import Data.Source (Source)
import Data.Reprinting.Scope

-- | 'Token' encapsulates 'Element' and 'Control' tokens, as well as sliced
-- portions of the original 'Source' for a given AST.
data Token
  = Chunk Source     -- ^ Verbatim 'Source' from AST, unmodified.
  | Element Element  -- ^ Content token to be rendered.
  | Control Control  -- ^ AST's context.
    deriving (Show, Eq)

isChunk :: Token -> Bool
isChunk (Chunk _) = True
isChunk _ = False

isControl :: Token -> Bool
isControl (Control _) = True
isControl _ = False

-- | 'Element' tokens describe atomic pieces of source code to be
-- output to a rendered document. These tokens are language-agnostic
-- and are interpreted into language-specific representations at a
-- later point in the reprinting pipeline.
data Element
  = Run Text   -- ^ A literal chunk of text.
  | Truth Bool -- ^ A boolean value.
  | Nullity    -- ^ @null@ or @nil@ or some other zero value.
  | Sep        -- ^ Some sort of delimiter, interpreted in some 'Context'.
  | Sym        -- ^ Some sort of symbol, interpreted in some 'Context'.
  | Then
  | Else
  | Open       -- ^ The beginning of some 'Context', such as an @[@ or @{@.
  | Close      -- ^ The opposite of 'TOpen'.
    deriving (Eq, Show)

-- | 'Control' tokens describe information about some AST's context.
-- Though these are ultimately rendered as whitespace (or nothing) on
-- the page, they are needed to provide information as to how deeply
-- subsequent entries in the pipeline should indent.
data Control
  = Enter Scope
  | Exit Scope
  | Log String
    deriving (Eq, Show)
