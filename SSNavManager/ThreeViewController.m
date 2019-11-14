//
//  ThreeViewController.m
//  SSNavManage
//
//  Created by HYS on 2019/11/13.
//  Copyright © 2019 HYS. All rights reserved.
//

#import "ThreeViewController.h"
#import "UINavigationController+SSNavigationManager.h"

@interface ThreeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ss_prefersnavigationBarColor = [UIColor blueColor];
    self.ss_prefersNavigationBarAlpha = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行", (long)indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = offset / maxAlphaOffset;
    [self ss_setNavigationTempAlpha:alpha];
}
@end
