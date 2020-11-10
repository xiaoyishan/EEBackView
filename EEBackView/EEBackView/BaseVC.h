//
//  BaseVC.h
//  EEBackView
//
//  Created by aosue on 2020/11/10.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseVC : UIViewController
@property (nonatomic,copy) NSString *webUrl;
-(void)goBack;
@end

NS_ASSUME_NONNULL_END
