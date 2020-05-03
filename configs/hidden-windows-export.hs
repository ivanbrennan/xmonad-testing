import XMonad
import XMonad.Layout.Hidden (HiddenWindows, hiddenWindows)
import XMonad.Layout.LayoutModifier

myLayout :: ModifiedLayout
            HiddenWindows
            (Choose Tall (Choose (Mirror Tall) Full))
            Window
myLayout = hiddenWindows $ layoutHook def

main :: IO ()
main = xmonad def { layoutHook = myLayout }
