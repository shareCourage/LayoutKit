// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 Provides APIs to recycle views by tag.
 
 Initialize ViewRecycler with a root view whose subviews are eligible for recycling.
 Call `makeView(tag:)` to recycle or create a view of the desired type and tag.
 Call `purgeViews()` to remove all unrecycled views from the view hierarchy.
 */
public class ViewRecycler {

    private var viewsByTag = [Int: UIView]()
    private var untaggedViews = Set<UIView>()

    /// Retains all subviews of rootView for recycling.
    public init(rootView: UIView?) {
        rootView?.walkSubviews { (view) in
            if view.tag != 0 {
                self.viewsByTag[view.tag] = view
            } else {
                self.untaggedViews.insert(view)
            }
        }
    }

    /// Marks a view as recycled so that `purgeViews()` doesn't remove it from the view hierarchy.
    /// It is only necessary to call this if a view is reused without calling `makeView(tag:)`.
    public func markViewAsRecycled(view: UIView) {
        if view.tag == 0 {
            untaggedViews.remove(view)
        } else {
            viewsByTag[view.tag] = nil
        }
    }

    /// Creates or recycles a view of the desired type and tag.
    public func makeView<T: UIView>(tag tag: Int) -> T {
        guard let view = viewsByTag[tag] as? T else {
            let t = T()
            t.tag = tag
            return t
        }
        viewsByTag[tag] = nil
        return view
    }

    /// Removes all unrecycled views from the view hierarchy.
    public func purgeViews() {
        for (_, view) in viewsByTag {
            view.removeFromSuperview()
        }
        viewsByTag.removeAll()

        for view in untaggedViews {
            view.removeFromSuperview()
        }
        untaggedViews.removeAll()
    }
}

extension UIView {

    /// Calls visitor for each transitive subview.
    func walkSubviews(@noescape visitor visitor: (UIView) -> Void) {
        for subview in subviews {
            visitor(subview)
            subview.walkSubviews(visitor: visitor)
        }
    }
}
