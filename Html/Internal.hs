module Html.Internal where

-- * Types

-- TODO use Text instead of String

newtype Html
  = Html String

newtype Structure
  = Structure String

type Title
  = String

-- * EDSL

html_ :: Title -> Structure -> Html
html_ title content =
  Html
    ( el "html"
      ( el "head" (el "title" (escape title))
        <> el "body" (getStructureString content)
      )
    )

-- TODO can't put structures inside P
p_ :: String -> Structure
p_ = Structure . el "p" . escape

h1_ :: String -> Structure
h1_ = Structure . el "h1" . escape

-- TODO unify ul and ol
ul_ :: [Structure] -> Structure
ul_ =
  Structure . el "ul" . concat . map (el "li" . getStructureString)

ol_ :: [Structure] -> Structure
ol_ =
  Structure . el "ol" . concat . map (el "li" . getStructureString)

-- pre to render as-is, code to signify codeblock
code_ :: String -> Structure
code_ = Structure . el "pre" . el "code" . escape

-- * Utilities

el :: String -> String -> String
el tag content =
  "<" <> tag <> ">" <> content <> "</" <> tag <> ">"

append_ :: Structure -> Structure -> Structure
append_ c1 c2 =
  Structure (getStructureString c1 <> getStructureString c2)

getStructureString :: Structure -> String
getStructureString (Structure str) = str

render :: Html -> String
render (Html str) = str

escape :: String -> String
escape =
  let
    escapeChar c =
      case c of
        '<' -> "&lt;"
        '>' -> "&gt;"
        '&' -> "&amp;"
        '"' -> "&quot;"
        '\'' -> "&#39;"
        _ -> [c]
  in
    concat . map escapeChar
