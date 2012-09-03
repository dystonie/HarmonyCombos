//
//  TableViewDataSourceTonal.h
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/5/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Headers.h"

@interface TableViewDataSourceTonal : NSObject {
@public NSString *tonicaTableObj;
@public NSString *terzaTableObj;
@public NSString *quintaTableObj;
@public NSString *labelTableObj;
}
-(id) initWithChord: (Chord *)chord;
-(id) initEmptyRow;
-(void) dealloc;

@property (assign, readwrite) NSString *tonicaTableObj;
@property (assign, readwrite) NSString *terzaTableObj;
@property (assign, readwrite) NSString *quintaTableObj;
@property (assign, readwrite) NSString *labelTableObj;

@end
