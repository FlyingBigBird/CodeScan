//
//  KBMainButton.m
//  FotileCSS
//
//  Created by ojbk on 2018/6/14.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import "KBMainButton.h"

/**
 *define:iOS 8.0的版本判断
 */
#define iOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)

@interface KBMainButton ()

{
    KBMainButtonStyle           _buttonStyle;
    CGRect                      _imgFrame;
}

@end

@implementation KBMainButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    
    KBMainButton *button = [super buttonWithType:buttonType];
    return button;
}

- (void)setButonStyle:(KBMainButtonStyle)buttonStyle imgFrame:(CGRect)imgFrame {
    
    _buttonStyle = buttonStyle;
    _imgFrame = imgFrame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat width   = 0;
    CGFloat height  = 0;
    CGRect rec = CGRectZero;
    
    switch (_buttonStyle) {
        case ImageLeftTitleRight:
        {
            originX = _imgFrame.origin.x + _imgFrame.size.width;
            originY = 0;
            width   = contentRect.size.width - originX;
            height  = contentRect.size.height;
            rec     = CGRectMake(originX, originY, width, height);
        }
            break;
        case ImageRightTitleLeft:
        {
            originX = 0;
            originY = 0;
            width   = contentRect.size.width - _imgFrame.size.width;
            height  = contentRect.size.height;
            rec     = CGRectMake(originX, originY, width, height);
        }
            break;
        case ImageTopTitleDown:
        {
            originX = 0;
            originY =  _imgFrame.origin.y + _imgFrame.size.height;
            width   = contentRect.size.width;
            height  = contentRect.size.height - originY;
            rec     = CGRectMake(originX, originY, width, height);
        }
            break;
        case ImageDownTitleTop:
        {
            originX = 0;
            originY = 0;
            width   = contentRect.size.width;
            height  = contentRect.size.height - _imgFrame.size.height;
            rec     = CGRectMake(originX, originY, width, height);
        }
            break;
        default:
            break;
    }
    return rec;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    return _imgFrame;
}

//iOS8，去掉button的下划线
- (void)setUnderlineNone:(BOOL)flag forTitle:(NSString *)title forState:(UIControlState)state {
    
    if (flag) {
        
        if (!title) {
            
            title = @"";
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
        
        if (iOS8_OR_LATER) {
            
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleNone] range:NSMakeRange(0, title.length)];
        }
        [self setAttributedTitle:str forState:state];
    }
}

- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state {
    
    if (iOS8_OR_LATER) {
        
        [self setUnderlineNone:YES forTitle:title forState:state];
    } else {
        
        [self setTitle:title forState:state];
    }
}

@end
