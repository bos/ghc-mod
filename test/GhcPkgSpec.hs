module GhcPkgSpec where

import Language.Haskell.GhcMod.Types
import Language.Haskell.GhcMod.GhcPkg

import Control.Applicative
import System.Directory
import System.FilePath ((</>))
import Test.Hspec

import Dir

spec :: Spec
spec = do
    describe "getSandboxDb" $ do
        it "parses a config file and extracts sandbox package db" $ do
            cwd <- getCurrentDirectory
            pkgDb <- getSandboxDb "test/data/"
            pkgDb `shouldBe` (cwd </> "test/data/.cabal-sandbox/i386-osx-ghc-7.6.3-packages.conf.d")

        it "throws an error if a config file is broken" $ do
            getSandboxDb "test/data/broken-sandbox" `shouldThrow` anyException

    describe "getPackageDbPackages" $ do
        it "find a config file and extracts packages" $ do
            sdb <- getSandboxDb "test/data/check-packageid"
            pkgs <- ghcPkgListEx [PackageDb sdb]
            pkgs `shouldBe` [("template-haskell","2.8.0.0","32d4f24abdbb6bf41272b183b2e23e9c")]
