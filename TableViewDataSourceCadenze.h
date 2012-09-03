//
//  TableViewDataSourceCadenze.h
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/7/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Headers.h"

@interface TableViewDataSourceCadenze : NSObject {
    Note *bassoDomNote;
    Note *tenoreDomNote;
    Note *altoDomNote;
    Note *sopranoDomNote;
    Note *bassoTonNote;
    Note *tenoreTonNote;
    Note *altoTonNote;
    Note *sopranoTonNote;
@public NSString *bassoTonicaTableObj;
@public NSString *tenoreTonicaTableObj;
@public NSString *altoTonicaTableObj;
@public NSString *sopranoTonicaTableObj;

@public NSString *bassoDominanteTableObj;
@public NSString *tenoreDominanteTableObj;
@public NSString *altoDominanteTableObj;
@public NSString *sopranoDominanteTableObj;
}
-(id) initWithCadenza: (Cadenza *)cadenza;
-(id) initEmptyRow;
-(NSMutableArray *) returnNotesTonica;
-(NSMutableArray *) returnNotesDominante;
-(void) dealloc;

@property (assign, readwrite) NSString *bassoTonicaTableObj;
@property (assign, readwrite) NSString *tenoreTonicaTableObj;
@property (assign, readwrite) NSString *altoTonicaTableObj;
@property (assign, readwrite) NSString *sopranoTonicaTableObj;

@property (assign, readwrite) NSString *bassoDominanteTableObj;
@property (assign, readwrite) NSString *tenoreDominanteTableObj;
@property (assign, readwrite) NSString *altoDominanteTableObj;
@property (assign, readwrite) NSString *sopranoDominanteTableObj;

@end