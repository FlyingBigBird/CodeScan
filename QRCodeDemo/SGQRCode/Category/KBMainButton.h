//
//  KBMainButton.h
//  FotileCSS
//
//  Created by ojbk on 2018/6/14.
//  Copyright © 2018年 康振超. All rights reserved.
//

//自定义button，可以调整image、title的位置

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KBMainButtonStyle) {
    
    ImageLeftTitleRight = 0,    //图片左title右
    ImageRightTitleLeft,        //图片右title左
    ImageTopTitleDown,          //图片上title下
    ImageDownTitleTop           //图片下title上
};

@interface KBMainButton : UIButton

- (void)setButonStyle:(KBMainButtonStyle)buttonStyle imgFrame:(CGRect)imgFrame;

@end
