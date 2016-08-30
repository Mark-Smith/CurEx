//
//  UIView+ToastExtras.h
//  MovieOnUp
//
//  Created by Mark Smith on 16/08/2016.
//  Copyright © 2016 ___MARK_SMITH___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ToastExtras)

// see https://github.com/scalessec/Toast/issues/36
- (void)makeToast:(NSString*)message;

@end
