//
//  ViewController.m
//  DBK
//
//  Created by mac on 16/5/5.
//  Copyright © 2016年 dubo. All rights reserved.
//

#import "ViewController.h"
#import "HomeHeaderView.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,FFScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HomeHeaderView *homeHeaderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    
    
   self.homeHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:self options:nil] firstObject];
    self.tableView.tableHeaderView = self.homeHeaderView;
    self.homeHeaderView .picScrollView.pageViewDelegate = self;
    
    /**
     旁边又白是图片大小的事
     */
    [_homeHeaderView.picScrollView initWithImgs:@[@"s2.png",@"s3.png",@"s4.png",@"s5.png"]];

}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text = @"fdfd";
    return cell;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
