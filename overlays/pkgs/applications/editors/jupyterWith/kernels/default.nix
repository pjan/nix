{ callPackage }:

{
  iPythonWith = callPackage ./ipython;
  iHaskellWith = callPackage ./iHaskell;
}