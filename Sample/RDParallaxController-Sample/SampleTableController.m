//
//  SampleTableController.m
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 03.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "SampleTableController.h"

@interface SampleTableController () <UITableViewDataSource>
@end

@implementation SampleTableController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = indexPath.section == 0 ? @"mapCell" : @"galleryCell";
    return [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Section";
}

@end
