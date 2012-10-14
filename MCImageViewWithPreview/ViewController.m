//
//  ViewController.m
//  MCImageViewWithPreview
//
//  Created by Baglan on 10/14/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "ViewController.h"
#import "MCImageViewWithPreview.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    MCImageViewWithPreview * imageView = [[MCImageViewWithPreview alloc] initWithFrame:self.view.bounds];
    imageView.previewImage = [UIImage imageNamed:@"preview-image"];
    imageView.image = [UIImage imageNamed:@"high-resolution-image"];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
