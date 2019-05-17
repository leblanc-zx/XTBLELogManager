//
//  XTBLELogListViewController.m
//  SuntrontBlueTooth
//
//  Created by apple on 2019/4/29.
//  Copyright © 2019 apple. All rights reserved.
//

#import "XTBLELogListViewController.h"
#import "XTBLEManager+Log.h"
#import "XTBLELogDetailViewController.h"

typedef void(^XTAlertTouchBlock)(NSInteger buttonIndex);

@interface XTAlertBlock : UIAlertView

@property (nonatomic, copy) XTAlertTouchBlock block;
- (void)showWithBlock:(XTAlertTouchBlock)block;

@end

@implementation XTAlertBlock

- (void)showWithBlock:(XTAlertTouchBlock)block {
    self.delegate = self;
    self.block = block;
    [super show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.block) {
        self.block(buttonIndex);
    }
}

@end

@interface XTBLELogListViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *calendarTF;   //日历TF
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation XTBLELogListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [currentBundle pathForResource:@"XTBLELogManager" ofType:@"bundle"];
    NSBundle *nibBundle = [NSBundle bundleWithPath:path];
    return [super initWithNibName:NSStringFromClass([self class]) bundle:nibBundle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"蓝牙日志列表";
    
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
    NSString *imagePath = [currentBundle pathForResource:@"xt_back_white@2x.png" ofType:nil inDirectory:@"XTBLELogManager.bundle"];
    [self.leftNavigationButton setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    
    [self.rightNavigationButton setTitle:@"清空" forState:UIControlStateNormal];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    
    NSDate *date = [NSDate date];
    [self.datePicker setDate:date];
    self.calendarTF.inputView = self.datePicker;
    self.calendarTF.text = [self timeStrWithDate:date];
    
    //获取日志列表
    [self getLogListWithDate:date];
    
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

    XTAlertBlock *alert = [[XTAlertBlock alloc] initWithTitle:@"提示" message:@"是否清空所有蓝牙日志?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    [alert showWithBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            
            if (self.password.length > 0) {
                NSError *error;
                [[XTBLEManager sharedManager] deleteAllBLELogWithPassword:self.password error:&error];
                if (!error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"清空成功" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作出错" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alert show];
                }
                //更新数据
                [self getLogListWithDate:self.datePicker.date];
            } else {
                
                XTAlertBlock *pswAlert = [[XTAlertBlock alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                pswAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                [pswAlert showWithBlock:^(NSInteger pswAlertButtonIndex) {
                    if (pswAlertButtonIndex == 1) {
                        UITextField *tf = [pswAlert textFieldAtIndex:0];
                        NSError *error;
                        [[XTBLEManager sharedManager] deleteAllBLELogWithPassword:tf.text error:&error];
                        if (!error) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"清空成功" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                            [alert show];
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作出错" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                            [alert show];
                        }
                        //更新数据
                        [self getLogListWithDate:self.datePicker.date];
                    }
                }];
                
            }
            
        }
    }];
    
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

#pragma -mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSDate *date = self.datePicker.date;
    textField.text = [self timeStrWithDate:date];
    //获取日志列表
    [self getLogListWithDate:date];
}

#pragma -mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogCell"];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除某一天的数据
        NSString *dayText = self.dataList[indexPath.row];
        NSString *day = [dayText stringByReplacingOccurrencesOfString:@".txt" withString:@""];
        
        XTAlertBlock *alert = [[XTAlertBlock alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否删除%@", dayText] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert showWithBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                if (self.password.length > 0) {
                    NSError *error;
                    [[XTBLEManager sharedManager] deleteBLELogWithDay:day password:self.password error:&error];
                    if (!error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作出错" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                        [alert show];
                    }
                    //更新数据
                    [self getLogListWithDate:self.datePicker.date];
                } else {
                    
                    XTAlertBlock *pswAlert = [[XTAlertBlock alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    pswAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                    [pswAlert showWithBlock:^(NSInteger pswAlertButtonIndex) {
                        if (pswAlertButtonIndex == 1) {
                            UITextField *tf = [pswAlert textFieldAtIndex:0];
                            NSError *error;
                            [[XTBLEManager sharedManager] deleteBLELogWithDay:day password:tf.text error:&error];
                            if (!error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                                [alert show];
                            } else {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作出错" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                                [alert show];
                            }
                            //更新数据
                            [self getLogListWithDate:self.datePicker.date];
                        }
                    }];
                    
                }
                
            }
        }];
        
        
    }
}

#pragma -mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *dayText = self.dataList[indexPath.row];
    XTBLELogDetailViewController *detailVC = [[XTBLELogDetailViewController alloc] init];
    detailVC.password = self.password;
    detailVC.day = [dayText stringByReplacingOccurrencesOfString:@".txt" withString:@""];
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1];;
    } else if (self.navigationBarBackgroundColor) {
        
        [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:self.navigationBarBackgroundColor] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                          NSForegroundColorAttributeName : self.navigationBarTitleColor,
                                                                          NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:18]
                                                                          
                                                                          }];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1];;
    }

}

#pragma -mark private
- (void)buildNavigationBar {
    
    //右按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame: CGRectMake(0, 0, 54, 44)];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [rightButton setExclusiveTouch:YES];
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

- (NSString *)timeStrWithDate:(NSDate *)date {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM"];
    NSString *timeStr = [dateformatter stringFromDate:date];
    return timeStr;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

#pragma -mark 获取日志列表
- (void)getLogListWithDate:(NSDate *)date {
    
    NSString *timeStr = [self timeStrWithDate:date];
   
    NSArray *array = [[XTBLEManager sharedManager] getFileListWithMonths:@[timeStr]];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:array];
    [self.tableView reloadData];
}

@end
