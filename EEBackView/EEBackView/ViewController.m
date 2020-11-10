//
//  ViewController.m
//  EEBackView
//
//  Created by aosue on 2020/11/10.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (int k=0; k<3; k++) {
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(50, 200+60*k, 100, 40);
        button.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        [button setTitle:@[@"push",@"present",@"web"][k] forState:UIControlStateNormal];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(goForward:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)goForward:(UIButton*)button{
    ViewController *vc = [ViewController new];
    if ([button.currentTitle isEqual:@"present"]) {
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        if ([button.currentTitle isEqual:@"web"]) vc.webUrl = @"https://www.baidu.com";
        if (!self.navigationController) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}
//-(void)goBack{
////    [super goBack];
//    printf("\nself 返回\n");
//}


@end
