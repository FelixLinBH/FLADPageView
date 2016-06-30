# FLADPageView

[![CI Status](http://img.shields.io/travis/Felix/FLADPageView.svg?style=flat)](https://travis-ci.org/Felix/FLADPageView)
[![Version](https://img.shields.io/cocoapods/v/FLADPageView.svg?style=flat)](http://cocoapods.org/pods/FLADPageView)
[![License](https://img.shields.io/cocoapods/l/FLADPageView.svg?style=flat)](http://cocoapods.org/pods/FLADPageView)
[![Platform](https://img.shields.io/cocoapods/p/FLADPageView.svg?style=flat)](http://cocoapods.org/pods/FLADPageView)

This library provides a carousel scrollview.

It provides:

 * **Fetch image from Net**.
 * **Auto run carousel**.
 * Customization **dot image**.
 * Customization **progress color**.
 * Support **Autolayout**.
 * Support **jpg**/**png**/**gif**.

## How To Use

###Properties###

```
//Dot property
@property (nonatomic) UIImage *dotImage;
@property (nonatomic) UIImage *currentDotImage;
@property (nonatomic) CGFloat dotHeight;

//Carousel setting
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic) CGFloat autoScrollTimeInterval;

//Carousel image data source
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *circleColor;

```

###How to set data source?
```
adView.dataSource = @[@"https://..../a.jpg",@"https://.../b.jpg",@"http://.../c.gif"];
```
###How to set progerss color foreach imageView?
**It must be set up before dataSource.**
```
 adView.circleColor = @[[UIColor blueColor],[UIColor redColor],[UIColor greenColor]];
```

###It provide delegate:

```
@protocol FLADPageViewDelegate <NSObject>
@optional
-(void)didTapPageViewAtIndex: (NSInteger)index;
@end

```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation with CocoaPods

FLADPageView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile.

###Podfile
```
platform :ios, '8.0'

target 'TargetName' do
pod 'FLADPageView'
end
```

Then, run the following command:

```
pod install
```

##Requirements

Minimum iOS Target `8.0`

##
##Dependency

* [**Masonry**](https://github.com/SnapKit/Masonry)
* [**DFImageManager**](https://github.com/kean/DFImageManager)
* [**TAPageControl**](https://github.com/TanguyAladenise/TAPageControl)

##Animation Inspire

* [**Animation**](https://www.raywenderlich.com/94302/implement-circular-image-loader-animation-cashapelayer)

##License

FLADPageView is available under the MIT license. See the LICENSE file for more info.
