//
//  ChooseCoverVC.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 196//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedCoverDelegate <NSObject>
- (void)showSelectedCover:(NSURL*)coverURL;
@end

@interface ChooseCoverVC : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_coverTableView;
}

@property (nonatomic,retain) IBOutlet UITableView *coverTableView;
@property (nonatomic, retain) id<SelectedCoverDelegate>delegate;
@end
