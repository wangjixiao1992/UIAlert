//
//  UIAlertController+Util.m
//  WJX
//
//  Created by 王吉笑 on 2019/6/10.
//  Copyright © 2019 王吉笑. All rights reserved.
//

#import "UIAlertController+Util.h"
#import <objc/runtime.h>

@implementation UIAlertController (Util)

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
    SEL system_dismissAnimatedSelector = NSSelectorFromString(@"_dismissAnimated:triggeringAction:triggeredByPopoverDimmingView:dismissCompletion:");
    Method system_dismissAnimatedMethod = class_getInstanceMethod(self,system_dismissAnimatedSelector);
    
    //重新制定新的方法
    SEL my_dismissAnimatedSelector = NSSelectorFromString(@"my_dismissAnimated:triggeringAction:triggeredByPopoverDimmingView:dismissCompletion:");
    Method my_dismissAnimatedMethod = class_getInstanceMethod(self, my_dismissAnimatedSelector);
    
    //交换
    method_exchangeImplementations(system_dismissAnimatedMethod, my_dismissAnimatedMethod);
}

- (void)my_dismissAnimated:(BOOL)animation triggeringAction:(UIAlertAction *)action triggeredByPopoverDimmingView:(id)view dismissCompletion:(id)handler{
    if (self.isRejectDismiss == NO) {
        [self my_dismissAnimated:animation triggeringAction:action triggeredByPopoverDimmingView:view dismissCompletion:handler];
    } else {
        //获取_invokeHandlersForAction方法执行
        SEL invokeHandler = NSSelectorFromString(@"_invokeHandlersForAction:");
        IMP imp = [self methodForSelector:invokeHandler];
        void (*func)(id, SEL, UIAlertAction *) = (void *)imp;
        func(self, invokeHandler, action);
    }
}


@end
