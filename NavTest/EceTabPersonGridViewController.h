//
//  EceTabPersonGridViewController.h
//  NavTest
//
//  Created by Mathias Sunardi on 2/22/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewController.h"
#import "GridViewCell.h"
#import "sqlite3.h"
#import "Faculty.h"
#import "FacultyDetailViewController.h"


@interface EceTabPersonGridViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate, UISearchBarDelegate> {
    
    NSArray *orderedImageNames;
    NSArray *imageNames;
    //AQGridView *gridView;
    NSUInteger *cellType;
    
}

//@property (nonatomic, retain) IBOutlet AQGridView *gridView;
@property (weak, nonatomic) IBOutlet AQGridView *myGridView;
@property (nonatomic, assign) CGFloat leftContentInset;
@property (nonatomic, assign) CGFloat rightContentInset;
@property (nonatomic, strong) Faculty *someFaculty;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (strong, nonatomic) NSMutableArray *facultyArray;
@property (strong, nonatomic) NSMutableArray *filteredFacultyArray;
@end
