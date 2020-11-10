//
//  EEBackView.h
//  EEBackView
//
//  Created by aosue on 2020/11/10.
//  Copyright © 2020 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EEBackView : UIView
@property (nonatomic,copy) void(^goBackBlock)(void);
@end

NS_ASSUME_NONNULL_END
