![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)
![Language](https://img.shields.io/badge/Language-Swift4.0-yellowgreen.svg)

# CustomFlowLayout

<sub>Dynamic height for UICollectionView</sub>
-
* Simple solution for Dynamically adjust Cell.
* Dynamically adjust height of collection view Cell.
* Dynamically set ```minimumLineSpacingForSection, minimumInteritemSpacingForSection, insetForSection```

<sub>Custom CollectionView Flow Layout</sub>
-
| Dynamic height with Custom Layout - iPhone 8 | Dynamic height with Custom Layout - iPad Air|
| ------------- |:-------------:|
|![ScreenShot](https://github.com/bhadresh12/CustomFlowLayout/blob/master/ScreenShots/iPhone8.png)|![ScreenShot](https://github.com/bhadresh12/CustomFlowLayout/blob/master/ScreenShots/iPadAir.png)|



<sub>How to get Custom CollectionView Layout for your UICollectionView</sub>
-

First set custom layout class name to your Storyboard/Nib file.

|![ScreenShot](https://github.com/bhadresh12/CustomFlowLayout/blob/master/ScreenShots/Layout.png)|

<sub>Add Following File to your project</sub>
-
 - ```CollectionFLowLayout.swift```


<sub>Write Simple Code in your viewDidLoad Method</sub>
-
```javascript

    if let layout = collectionView.collectionViewLayout as? CollectionFLowLayout {
        layout.delegate = self
        layout.numberOfColumns = 2 // No columns you required
    }
```

<sub>Import customLayout in your controller where to use</sub>
-
```javascript 
<CollectionViewLayoutDelegate>
``` 
to your viewController.

Implement below Delegate Method for dynamic height of Label to your viewController file.
```javascript

// MARK:- CollectionViewLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, widthForItem width: CGFloat, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let constraint = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        var size = CGSize.zero

        let context = NSStringDrawingContext()
        let font = UIFont(name: "Helvetica Neue", size: 17) // Font name and size of UILabel in Cell
        let boundingBox: CGSize = arrayString[indexPath.item].boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font!], context: context).size

        size = CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
        return size.height
    }
```
