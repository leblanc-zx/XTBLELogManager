//
//  XTBLELogDetailViewController.m
//  SuntrontBlueTooth
//
//  Created by apple on 2019/4/29.
//  Copyright © 2019 apple. All rights reserved.
//

#import "XTBLELogDetailViewController.h"
#import "XTBLEManager+Log.h"

@interface XTBLELogDetailViewController ()<UIAlertViewDelegate, UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@end

@implementation XTBLELogDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [currentBundle pathForResource:@"XTBLELogManager" ofType:@"bundle"];
    NSBundle *nibBundle = [NSBundle bundleWithPath:path];
    return [super initWithNibName:NSStringFromClass([self class]) bundle:nibBundle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"蓝牙日志";
    
    if (self.navigationBarBackgroundImage == nil && self.navigationBarBackgroundColor == nil) {
        self.navigationBarBackgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    }
    if (self.navigationBarTitleColor == nil) {
        self.navigationBarTitleColor = [UIColor whiteColor];
    }
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self SetTopBarBgImage];
    
    [self buildNavigationBar];
    
    
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *backImagePath = [currentBundle pathForResource:@"xt_back_white@2x.png" ofType:nil inDirectory:@"XTBLELogManager.bundle"];
    NSString *shareImagePath = [currentBundle pathForResource:@"xt_share@2x.png" ofType:nil inDirectory:@"XTBLELogManager.bundle"];
    [self.leftNavigationButton setImage:[UIImage imageWithContentsOfFile:backImagePath] forState:UIControlStateNormal];
    [self.rightNavigationButton setImage:[UIImage imageWithContentsOfFile:shareImagePath] forState:UIControlStateNormal];
    
    if (self.password.length > 0) {
        [self getLog:self.password];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alert show];
    }
}

#pragma -mark clicks
/**
 导航栏左侧按钮点击
 */
- (void)leftNavigationButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 导航栏右侧按钮点击
 */
- (void)rightNavigationButtonClick:(id)sender {
    
    NSString *fileName = [NSString stringWithFormat:@"XTBLEDataLog%@.txt", self.day];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        return;
    }
    if (self.documentController == nil) {
        
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    }
    self.documentController.delegate = self;
    self.documentController.UTI = fileName;
    [self.documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

#pragma -mark methods
/**
 屏幕宽
 */
- (CGFloat)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

/**
 屏幕高
 */
- (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}
/**
 导航栏左侧按钮
 */
- (UIButton *)leftNavigationButton {
    return (UIButton *)self.navigationItem.leftBarButtonItems[0].customView;
}

/**
 导航栏右侧按钮
 */
- (UIButton *)rightNavigationButton {
    return (UIButton *)self.navigationItem.rightBarButtonItems[0].customView;
}

#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        //获取日志
        [self getLog:tf.text];
    }
}

#pragma -mark 导航栏背景
-(void)SetTopBarBgImage
{
    
    if (self.navigationBarShadowColor == nil) {
        [self.navigationController.navigationBar setShadowImage:nil];
    } else {
        [self.navigationController.navigationBar setShadowImage:[self createImageWithColor:self.navigationBarShadowColor]];
    }
    
    if (self.navigationBarBackgroundImage) {
        
        [self.navigationController.navigationBar setBackgroundImage:self.navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
        //
        [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                          NSForegroundColorAttributeName : self.navigationBarTitleColor,
                                                                          NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:18]
                                                                          }];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1];
    } else if (self.navigationBarBackgroundColor) {
        
        [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:self.navigationBarBackgroundColor] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                          NSForegroundColorAttributeName : self.navigationBarTitleColor,
                                                                          NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:18]
                                                                          
                                                                          }];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1]; 
    }
    
}

#pragma -mark private
- (void)buildNavigationBar {
    
    //右按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame: CGRectMake(0, 0, 54, 44)];
    rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [rightButton setExclusiveTouch:YES];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightButton addTarget:self action:@selector(rightNavigationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //左按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame: CGRectMake(0, 0, 54, 44)];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton setExclusiveTouch:YES];
    [leftButton addTarget:self action:@selector(leftNavigationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma -mark 日志
- (void)getLog:(NSString *)password {
    if (self.day.length > 0) {
        self.textView.text = [[XTBLEManager sharedManager] getFileWithDay:self.day password:password];
    }
}

@end
