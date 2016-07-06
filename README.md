LMGaugeView
==============
LMGaugeView is a simple and customizable gauge control for iOS inspired by [Flavor](https://dribbble.com/flavor) sketch on [Dribbble](https://dribbble.com/shots/1217274-Speedometer-Day-Night-Mode).

<img src="https://raw.github.com/lminhtm/LMGaugeView/master/Screenshots/screenshot1.png"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://raw.github.com/lminhtm/LMGaugeView/master/Screenshots/screenshot3.gif"/>

## Features
* Display a gauge, such as a speedometer or a loading indicator.
* Using Core Graphics and Core Animation.
* Allow for a large amount of customization.
* Support Interface Builder Designable.

## Requirements
* iOS 7.0 or higher 
* ARC

## Installation
#### From CocoaPods
```ruby
pod 'LMGaugeView'
```
#### Manually
* Drag the `LMGaugeView` folder into your project.
* Add `#import "LMGaugeView.h"` to the top of classes that will use it.

## Usage
You can easily integrate the LMGaugeView with a few lines of code. For an example usage look at the code below.
```ObjC
LMGaugeView *gaugeView = [[LMGaugeView alloc] initWithFrame:frame];
gaugeView.value = 40;
[self.view addSubview:gaugeView];
```

## Customization
You can customize the following properties of LMGaugeView:
```ObjC
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat limitValue;
@property (nonatomic, assign) NSUInteger numOfDivisions;
@property (nonatomic, assign) NSUInteger numOfSubDivisions;
@property (nonatomic, assign) CGFloat ringThickness;
@property (nonatomic, strong) UIColor *ringBackgroundColor;
@property (nonatomic, assign) CGFloat divisionsRadius;
@property (nonatomic, strong) UIColor *divisionsColor;
@property (nonatomic, assign) CGFloat divisionsPadding;
@property (nonatomic, assign) CGFloat subDivisionsRadius;
@property (nonatomic, strong) UIColor *subDivisionsColor;
@property (nonatomic, assign) BOOL showLimitDot;
@property (nonatomic, assign) CGFloat limitDotRadius;
@property (nonatomic, strong) UIColor *limitDotColor;
@property (nonatomic, strong) UIFont *valueFont;
@property (nonatomic, strong) UIColor *valueTextColor;
@property (nonatomic, assign) BOOL showUnitOfMeasurement;
@property (nonatomic, copy)   NSString *unitOfMeasurement;
@property (nonatomic, strong) UIFont *unitOfMeasurementFont;
@property (nonatomic, strong) UIColor *unitOfMeasurementTextColor;
```
(See sample Xcode project in /LMGaugeViewDemo)

## License
LMGaugeView is licensed under the terms of the MIT License.

## Contact
Minh Luong Nguyen
* https://github.com/lminhtm
* lminhtm@gmail.com

## Projects using LMGaugeView
Feel free to add your project [here](https://github.com/lminhtm/LMGaugeView/wiki/Projects-using-LMGaugeView)

## Donations
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=J3WZJT2AD28NW&lc=VN&item_name=LMGaugeView&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)
