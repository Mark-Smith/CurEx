//
//  UIView+ToastExtras.m
//  MovieOnUp
//
//  Created by Mark Smith on 16/08/2016.
//  Copyright © 2016 ___MARK_SMITH___. All rights reserved.
//

#import "UIView+ToastExtras.h"
#import "UIView+Toast.h"

@implementation UIView (ToastExtras)

- (void)makeToast:(NSString *)message {
    
    // create a new style
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    
    // this is just one of many style options
    style.backgroundColor = [UIColor orangeColor];
    
    [self makeToast:message duration:2. position:CSToastPositionCenter style:style];
}

@end
