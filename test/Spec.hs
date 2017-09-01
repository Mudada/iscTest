import Test.Hspec
import Test.QuickCheck
import Test.QuickCheck.Modifiers
import Test.QuickCheck.Gen
import Types
import Parser
import Text.ParserCombinators.Parsec (parse)
import Data.Typeable

instance Arbitrary Telephone where
    arbitrary = do
        i <- arbitrary
        n <- arbitrary
        return $ Telephone i n

instance Arbitrary Cell where
    arbitrary = do
        t <- arbitrary
        sf <- arbitrary
        oneof [return Empty, return $ T t, return $ SF sf]

main = hspec $ do
    describe "IscTest.Types" $ do
        it "telephone: extract all the Telephone from a Line" $ do
           telephone [T $ Telephone [] [], Empty] `shouldBe` [Telephone [] []] 
        it "telephone: if the argument is [] it return []" $ do
           telephone [] `shouldBe` [] 
        it "gTelephones: count the number of `good` Telephone (checked with igTelephone)" $ do
            gTelephones [Telephone [3,3] [6,9,5,5,9,8,8,9,5], Telephone [] []] `shouldBe` 1
    describe "IscTest.Parser" $ do
        it "ws: parse white space" $ do
            parse ws "error" " " `shouldBe` Right " "
        it "ws: parse white space and nothing else" $ do
            parse ws "error" "asdadd" `shouldBe` Right ""
        it "perfectTel: parse `perfect` Telephone (a `+` and some numbers)" $ do
            parse perfectTel "error" "+336" `shouldBe` Right (Telephone [3,3] [6])
        it "perfectTel: error if no `+`" $ do
            let (Left e) = parse perfectTel "error" "336"
            show (typeOf e) `shouldBe` "ParseError"
        it "perfectTel: error if indicatif's length is less than 2" $ do
            let (Left e) = parse perfectTel "error" "+3"
            show (typeOf e) `shouldBe` "ParseError"
        it "clunkyTel: parse `clunky` Telephone (numbers, ., -) and return an `indicatif` if the length is 11" $ do
            parse clunkyTel "error" "33695598895" `shouldBe` Right (Telephone [3,3] [6,9,5,5,9,8,8,9,5])
        it "clunkyTel: return an `indicatif` equals to -1 if the length is not 11" $ do
            parse clunkyTel "error" "8895" `shouldBe` Right (Telephone [-1] [8,8,9,5])
        it "clunkyTel: ParseError if not a number" $ do
            let (Left e) = parse clunkyTel "error" "asdasda"
            show (typeOf e) `shouldBe` "ParseError"
        it "parseSF: parse string not null" $ do
            parse parseSF "error" "asda" `shouldBe` Right "asda"
        it "parseSF: parse an empty string" $ do
            let (Left e) = parse parseSF "error" ""
            show (typeOf e) `shouldBe` "ParseError"
        it "sep: parse a coma" $ do
            parse sep "error" "," `shouldBe` Right ','
        it "sep: error if not a coma" $ do
            let (Left e) = parse sep "error" ""
            show (typeOf e) `shouldBe` "ParseError"
        it "empty: parse an `empty` cell" $ do
            parse empty "error" "" `shouldBe` Right Empty
        it "empty: error if not empty" $ do
            let (Left e) = parse empty "error" "asda"
            show (typeOf e) `shouldBe` "ParseError"
        it "parseLine: parse a line with 6 cells" $ do
            parse parseLine "error" "a,a,a,a,a,a" `shouldBe` Right [SF "a", SF "a", SF "a", SF "a", SF "a", SF "a"]
        it "parseLine: error if less than 6 cells" $ do
            let (Left e) = parse parseLine "error" "a,a,a,a,a"
            show (typeOf e) `shouldBe` "ParseError"
        it "parseLine: error if more than 6 cells" $ do
            let (Left e) = parse parseLine "error" "a,a,a,a,a,a,a"
            show (typeOf e) `shouldBe` "ParseError"
