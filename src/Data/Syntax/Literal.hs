{-# LANGUAGE DataKinds, DeriveAnyClass, DeriveGeneric, MultiParamTypeClasses, ViewPatterns, ScopedTypeVariables #-}
module Data.Syntax.Literal where

import           Data.Abstract.Evaluatable
<<<<<<< HEAD
import           Data.JSON.Fields
import           Data.Scientific.Exts
import           Data.Text (unpack)
import qualified Data.Text as T
import           Diffing.Algorithm
import           Prelude hiding (Float, null)
import           Prologue hiding (Set, hash, null)
=======
import           Data.ByteString.Char8 (readInteger, unpack)
import qualified Data.ByteString.Char8 as B
import           Data.JSON.Fields
import           Data.Scientific.Exts
import           Diffing.Algorithm
import           Prelude hiding (Float, null)
import           Prologue hiding (Set, hash, null)
import           Proto3.Suite.Class
>>>>>>> origin/master
import           Text.Read (readMaybe)

-- Boolean

newtype Boolean a = Boolean { booleanContent :: Bool }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1, Named1, Message1)

true :: Boolean a
true = Boolean True

false :: Boolean a
false = Boolean False

instance Eq1 Boolean where liftEq = genericLiftEq
instance Ord1 Boolean where liftCompare = genericLiftCompare
instance Show1 Boolean where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Boolean where
  eval (Boolean x) = pure (Rval (boolean x))

-- Numeric

-- | A literal integer of unspecified width. No particular base is implied.
<<<<<<< HEAD
newtype Integer a = Integer { integerContent :: Text }
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1)
=======
newtype Integer a = Integer { integerContent :: ByteString }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)
>>>>>>> origin/master

instance Eq1 Data.Syntax.Literal.Integer where liftEq = genericLiftEq
instance Ord1 Data.Syntax.Literal.Integer where liftCompare = genericLiftCompare
instance Show1 Data.Syntax.Literal.Integer where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Data.Syntax.Literal.Integer where
  -- TODO: We should use something more robust than shelling out to readMaybe.
  eval (Data.Syntax.Literal.Integer x) =
    Rval . integer <$> maybeM (throwEvalError (IntegerFormatError x)) (readMaybe (T.unpack x))

<<<<<<< HEAD
instance ToJSONFields1 Data.Syntax.Literal.Integer where
  toJSONFields1 (Integer i) = noChildren ["asString" .= i]


=======
>>>>>>> origin/master
-- TODO: Should IntegerLiteral hold an Integer instead of a ByteString?
-- TODO: Consider a Numeric datatype with FloatingPoint/Integral/etc constructors.

-- | A literal float of unspecified width.
<<<<<<< HEAD
newtype Float a = Float { floatContent  :: Text }
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1)
=======
newtype Float a = Float { floatContent  :: ByteString }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1, Named1, Message1)
>>>>>>> origin/master

instance Eq1 Data.Syntax.Literal.Float where liftEq = genericLiftEq
instance Ord1 Data.Syntax.Literal.Float where liftCompare = genericLiftCompare
instance Show1 Data.Syntax.Literal.Float where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Data.Syntax.Literal.Float where
  eval (Float s) =
    Rval . float <$> either (const (throwEvalError (FloatFormatError s))) pure (parseScientific s)

<<<<<<< HEAD
instance ToJSONFields1 Float where
  toJSONFields1 (Float f) = noChildren ["asString" .= f]

-- Rational literals e.g. `2/3r`
newtype Rational a = Rational Text
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1)
=======
-- Rational literals e.g. `2/3r`
newtype Rational a = Rational ByteString
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)
>>>>>>> origin/master

instance Eq1 Data.Syntax.Literal.Rational where liftEq = genericLiftEq
instance Ord1 Data.Syntax.Literal.Rational where liftCompare = genericLiftCompare
instance Show1 Data.Syntax.Literal.Rational where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Data.Syntax.Literal.Rational where
  eval (Rational r) =
    let
      trimmed = T.takeWhile (/= 'r') r
      parsed = readMaybe @Prelude.Integer (unpack trimmed)
    in Rval . rational <$> maybe (throwEvalError (RationalFormatError r)) (pure . toRational) parsed

<<<<<<< HEAD
instance ToJSONFields1 Data.Syntax.Literal.Rational where
  toJSONFields1 (Rational r) = noChildren ["asString" .= r]

-- Complex literals e.g. `3 + 2i`
newtype Complex a = Complex Text
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1)
=======
-- Complex literals e.g. `3 + 2i`
newtype Complex a = Complex ByteString
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1, ToJSONFields1)
>>>>>>> origin/master

instance Eq1 Data.Syntax.Literal.Complex where liftEq = genericLiftEq
instance Ord1 Data.Syntax.Literal.Complex where liftCompare = genericLiftCompare
instance Show1 Data.Syntax.Literal.Complex where liftShowsPrec = genericLiftShowsPrec

-- TODO: Implement Eval instance for Complex
instance Evaluatable Complex

<<<<<<< HEAD
instance ToJSONFields1 Complex where
  toJSONFields1 (Complex c) = noChildren ["asString" .= c]

=======
>>>>>>> origin/master
-- Strings, symbols

newtype String a = String { stringElements :: [a] }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)

instance Eq1 Data.Syntax.Literal.String where liftEq = genericLiftEq
instance Ord1 Data.Syntax.Literal.String where liftCompare = genericLiftCompare
instance Show1 Data.Syntax.Literal.String where liftShowsPrec = genericLiftShowsPrec

-- TODO: Should string literal bodies include escapes too?

-- TODO: Implement Eval instance for String
instance Evaluatable Data.Syntax.Literal.String

newtype Character a = Character { characterContent :: ByteString }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)

instance Eq1 Data.Syntax.Literal.Character where liftEq = genericLiftEq
instance Ord1 Data.Syntax.Literal.Character where liftCompare = genericLiftCompare
instance Show1 Data.Syntax.Literal.Character where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Data.Syntax.Literal.Character

-- | An interpolation element within a string literal.
newtype InterpolationElement a = InterpolationElement { interpolationBody :: a }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)

instance Eq1 InterpolationElement where liftEq = genericLiftEq
instance Ord1 InterpolationElement where liftCompare = genericLiftCompare
instance Show1 InterpolationElement where liftShowsPrec = genericLiftShowsPrec

-- TODO: Implement Eval instance for InterpolationElement
instance Evaluatable InterpolationElement

-- | A sequence of textual contents within a string literal.
<<<<<<< HEAD
newtype TextElement a = TextElement { textElementContent :: Text }
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1)
=======
newtype TextElement a = TextElement { textElementContent :: ByteString }
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1, ToJSONFields1, Named1, Message1)
>>>>>>> origin/master

instance Eq1 TextElement where liftEq = genericLiftEq
instance Ord1 TextElement where liftCompare = genericLiftCompare
instance Show1 TextElement where liftShowsPrec = genericLiftShowsPrec

<<<<<<< HEAD
instance ToJSONFields1 TextElement where
  toJSONFields1 (TextElement c) = noChildren ["asString" .= c]

=======
>>>>>>> origin/master
instance Evaluatable TextElement where
  eval (TextElement x) = pure (Rval (string x))

data Null a = Null
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1, Named1, Message1)

instance Eq1 Null where liftEq = genericLiftEq
instance Ord1 Null where liftCompare = genericLiftCompare
instance Show1 Null where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Null where eval _ = pure (Rval null)

<<<<<<< HEAD
instance ToJSONFields1 Null

newtype Symbol a = Symbol { symbolContent :: Text }
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1)
=======
newtype Symbol a = Symbol { symbolContent :: ByteString }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)
>>>>>>> origin/master

instance Eq1 Symbol where liftEq = genericLiftEq
instance Ord1 Symbol where liftCompare = genericLiftCompare
instance Show1 Symbol where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Symbol where
  eval (Symbol s) = pure (Rval (symbol s))

<<<<<<< HEAD
newtype Regex a = Regex { regexContent :: Text }
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1)
=======
newtype Regex a = Regex { regexContent :: ByteString }
  deriving (Diffable, Eq, Foldable, Functor, Generic1, Hashable1, Mergeable, Ord, Show, Traversable, FreeVariables1, Declarations1, ToJSONFields1)
>>>>>>> origin/master

instance Eq1 Regex where liftEq = genericLiftEq
instance Ord1 Regex where liftCompare = genericLiftCompare
instance Show1 Regex where liftShowsPrec = genericLiftShowsPrec

-- TODO: Heredoc-style string literals?
<<<<<<< HEAD
-- TODO: Character literals.

instance ToJSONFields1 Regex where
  toJSONFields1 (Regex r) = noChildren ["asString" .= r]

=======
>>>>>>> origin/master

-- TODO: Implement Eval instance for Regex
instance Evaluatable Regex


-- Collections

newtype Array a = Array { arrayElements :: [a] }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1, Named1, Message1)

instance Eq1 Array where liftEq = genericLiftEq
instance Ord1 Array where liftCompare = genericLiftCompare
instance Show1 Array where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Array where
  eval (Array a) = Rval <$> (array =<< traverse subtermValue a)

newtype Hash a = Hash { hashElements :: [a] }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1, Named1, Message1)

instance Eq1 Hash where liftEq = genericLiftEq
instance Ord1 Hash where liftCompare = genericLiftCompare
instance Show1 Hash where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Hash where
  eval t = Rval . hash <$> traverse (subtermValue >=> asPair) (hashElements t)

data KeyValue a = KeyValue { key :: !a, value :: !a }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1, Named1, Message1)

instance Eq1 KeyValue where liftEq = genericLiftEq
instance Ord1 KeyValue where liftCompare = genericLiftCompare
instance Show1 KeyValue where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable KeyValue where
  eval (fmap subtermValue -> KeyValue{..}) =
    Rval <$> (kvPair <$> key <*> value)

newtype Tuple a = Tuple { tupleContents :: [a] }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)

instance Eq1 Tuple where liftEq = genericLiftEq
instance Ord1 Tuple where liftCompare = genericLiftCompare
instance Show1 Tuple where liftShowsPrec = genericLiftShowsPrec

instance Evaluatable Tuple where
  eval (Tuple cs) = Rval . multiple <$> traverse subtermValue cs

newtype Set a = Set { setElements :: [a] }
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)

instance Eq1 Set where liftEq = genericLiftEq
instance Ord1 Set where liftCompare = genericLiftCompare
instance Show1 Set where liftShowsPrec = genericLiftShowsPrec

-- TODO: Implement Eval instance for Set
instance Evaluatable Set


-- Pointers

-- | A declared pointer (e.g. var pointer *int in Go)
newtype Pointer a = Pointer a
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)

instance Eq1 Pointer where liftEq = genericLiftEq
instance Ord1 Pointer where liftCompare = genericLiftCompare
instance Show1 Pointer where liftShowsPrec = genericLiftShowsPrec

-- TODO: Implement Eval instance for Pointer
instance Evaluatable Pointer


-- | A reference to a pointer's address (e.g. &pointer in Go)
newtype Reference a = Reference a
  deriving (Eq, Ord, Show, Foldable, Traversable, Functor, Generic1, Hashable1, Diffable, Mergeable, FreeVariables1, Declarations1, ToJSONFields1)

instance Eq1 Reference where liftEq = genericLiftEq
instance Ord1 Reference where liftCompare = genericLiftCompare
instance Show1 Reference where liftShowsPrec = genericLiftShowsPrec

-- TODO: Implement Eval instance for Reference
instance Evaluatable Reference

-- TODO: Object literals as distinct from hash literals? Or coalesce object/hash literals into “key-value literals”?
-- TODO: Function literals (lambdas, procs, anonymous functions, what have you).
