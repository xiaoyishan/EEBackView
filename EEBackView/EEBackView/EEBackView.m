//
//  EEBackView.m
//  EEBackView
//
//  Created by aosue on 2020/11/10.
//  Copyright © 2020 lzy. All rights reserved.
//

#import "EEBackView.h"

const static CGFloat EEBacklength = 100; // 触发返回事件的区间


@interface EEBackView (){
    CGFloat pointYY;
    CGFloat pointXX;
}
@property (nonatomic,strong) CAShapeLayer *popLayer;
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) CADisplayLink *displayLink;
@end

@implementation EEBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
-(void)setUp {
    self.backgroundColor = [UIColor clearColor];
    
    _popLayer = [CAShapeLayer new];
    _popLayer.fillColor = [UIColor blackColor].CGColor;
    _popLayer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.layer addSublayer:_popLayer];
    [self addSubview:self.backImageView];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(backAnimation)];
    self.displayLink.paused = YES;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

-(void)updatePath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 0.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:CGPointMake(-1, pointYY)]; 
    [path addQuadCurveToPoint:CGPointMake(60*pointXX, pointYY+60) controlPoint:CGPointMake(-1, pointYY+40)];
    [path addQuadCurveToPoint:CGPointMake(60*pointXX, pointYY+100) controlPoint:CGPointMake(120*pointXX, pointYY+80)];
    [path addQuadCurveToPoint:CGPointMake(-1, pointYY+160) controlPoint:CGPointMake(-1, pointYY+120)];
    [path stroke];
    _popLayer.path = path.CGPath;
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
    if (point.x < EEBacklength) {
        pointXX = point.x/EEBacklength/4.0;
        self.backImageView.alpha = (pointXX-0.18)*16;
        [self updatePath];
    }else{
        self.backImageView.alpha = 1;
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
    if (point.x > EEBacklength) {
        // printf("\n返回上一页\n");
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleHeavy];
        [generator prepare];
        [generator impactOccurred];
        self.goBackBlock();
        if ([self.delegate respondsToSelector:@selector(goBack)]) {
            [self.delegate goBack];
        }
    }
    self.displayLink.paused = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
    pointYY = point.y-160/2;
    self.backgroundColor = [UIColor clearColor];
    _backImageView.frame = CGRectMake(0, pointYY+70, 16, 16);
}

-(UIImageView*)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ee_web_goback"]];
        _backImageView.alpha = 0;
    }
    return _backImageView;
}

-(void)backAnimation{
    if (pointXX >= 0) {
        pointXX = pointXX- 0.02;
        [self updatePath];
        self.backImageView.alpha = (pointXX-0.18)*16;
    }else{
        self.displayLink.paused = YES;
        self.backImageView.alpha = 0;
    }
}

- (void)stopAnimation{
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}
-(void)dealloc {
    [self stopAnimation];
}
@end
