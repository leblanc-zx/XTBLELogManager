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

@interface XTBLELogListViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

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

#pragma -mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *dayText = self.dataList[indexPath.row];
    XTBLELogDetailViewController *detailVC = [[XTBLELogDetailViewController alloc] init];
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
