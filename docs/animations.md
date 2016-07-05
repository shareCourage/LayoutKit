# Animations

LayoutKit supports animating between two layouts.

## Requirements

1. Use the `tag` parameter to identify layouts involved in the animation.
2. Call `prepareAnimation()` on a `LayoutArrangement` to setup the existing view hierarchy for the animation.
3. Call `apply()` on the animation object returned by `prepareAnimation()` inside of the UIKit animation block.

## Example playground

Here is a complete example that works in a playground:

```swift
import UIKit
import XCPlayground
import LayoutKit
import LayoutKitExampleLayouts

let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
XCPlaygroundPage.currentPage.liveView = rootView

// Setup the initial layout in the root view.
let red = { (view: UIView) in view.backgroundColor = UIColor.redColor() }
let beforeLayout = SizeLayout<UIView>(width: 10, height: 10, alignment: .center, tag: 1, config: red)
beforeLayout.arrangement(width: 100, height: 100).makeViews(inView: rootView)

// Setup the final layout and prepare the animation.
let afterLayout = SizeLayout<UIView>(width: 50, height: 50, alignment: .center, tag: 1, config: red)
let afterArrangement = afterLayout.arrangement(width: 100, height: 100)
let animation = afterArrangement.prepareAnimation(for: rootView)

// Run the animation.
UIView.animateWithDuration(5.0, animations: {
    animation.apply()
}, completion: { _ in
    XCPlaygroundPage.currentPage.finishExecution()
})
```
