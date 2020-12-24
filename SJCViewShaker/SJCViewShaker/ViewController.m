//
//  ViewController.m
//  SJCViewShaker
//
//  Created by Yehwang on 2020/12/24.
//

#import "ViewController.h"
#import "UIView+SJCShaker.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UISwitch *slide;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)shake:(id)sender {
    [self.lab sjc_shake];
}
- (IBAction)shakes:(id)sender {
    [@[_lab, _field, _slide] sjc_shake];
}

@end
