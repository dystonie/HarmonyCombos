//
//  TableViewDataSource.h
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/3/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Headers.h"

@interface TableViewDataSource : NSObject {
@public NSString *bassoTableObj;
@public NSString *tenoreTableObj;
@public NSString *altoTableObj;
@public NSString *sopranoTableObj;
}
-(id) initWithChord: (Chord *)chord;
-(id) initEmptyRow;
-(void) dealloc;

@property (assign, readwrite) NSString *bassoTableObj;
@property (assign, readwrite) NSString *tenoreTableObj;
@property (assign, readwrite) NSString *altoTableObj;
@property (assign, readwrite) NSString *sopranoTableObj;

@end