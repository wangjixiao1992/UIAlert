//
//  UIAlertView+Util.m
//  WJX
//
//  Created by 王吉笑 on 2019/6/10.
//  Copyright © 2019 王吉笑. All rights reserved.
//

#import "UIAlertView+Util.h"
#import <objc/runtime.h>

@implementation UIAlertView (Util)


#pragma mark - 添加属性
- (void)setIsRejectDismiss:(BOOL)isRejectDismiss {
    objc_setAssociatedObject(self, @selector(isRejectDismiss), @(isRejectDismiss), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isRejectDismiss {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - runTime
+ (void)load {
    //获取系统方法
    SEL system_dismissAnimatedSelector = NSSelectorFromString(@"dismissWithClickedButtonIndex:animated:");
    Method system_dismissAnimatedMethod = class_getInstanceMethod(self,system_dismissAnimatedSelector);
    
    //重新制定新的方法
    SEL my_dismissAnimatedSelector = NSSelectorFromString(@"my_dismissWithClickedButtonIndex:animated:");
    Method my_dismissAnimatedMethod = class_getInstanceMethod(self, my_dismissAnimatedSelector);
    
    //交换
    method_exchangeImplementations(system_dismissAnimatedMethod, my_dismissAnimatedMethod);
}

- (void)my_dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (self.isRejectDismiss == NO) {
        [self my_dismissWithClickedButtonIndex:buttonIndex animated:animated];
    } else {
        //不消失
        NSLog(@"按钮不消失");
    }
}



@end
