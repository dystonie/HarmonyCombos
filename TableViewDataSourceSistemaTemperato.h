//
//  TableViewDataSourceSistemaTemperato.h
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/6/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Headers.h"

@interface TableViewDataSourceSistemaTemperato : NSObject {
@public NSString *noteNameObj;
@public NSNumber *midiNumberObj;
}
-(id) initWithNote: (Note *)note;
-(void) dealloc;

@property (assign, readwrite) NSString *noteNameObj;
@property (assign, readwrite) NSNumber *midiNumberObj;

@end