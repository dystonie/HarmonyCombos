//
//  TableViewController.m
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/6/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "TableViewController.h"

@implementation TableViewController
@end

@implementation TableViewController (Inizializzatori)
-(id) initWithArrayController: (NSArrayController *)arrayObj {
	[super init];
	if (self) {
		counter = [[NSMutableArray alloc] initWithObjects:nil];
		currentTableArray = arrayObj;
	}
	return self;
}
@end

@implementation TableViewController (QuattroColonneObj)
-(void) addMtrxObj: (MtrxNVoices *)mtrx {
	
	NSMutableArray *chordArray = [mtrx mtrxToChordArrayConvert];
	
	[self addChordArray:chordArray];
}

-(void) addChord: (Chord *)chord {
	TableViewDataSource *obj = [[TableViewDataSource alloc] initWithChord:chord]; 
	[currentTableArray addObject:obj];
	[counter addObject:obj];
}

-(void) addChordArray: (NSMutableArray *)chordArray {
	if ([chordArray count]!=0) {
		for (int i=0; i<[chordArray count]; i++) {
			[self addChord:[chordArray objectAtIndex:i]];
		}
	}
}
@end

@implementation TableViewController (OttoColonneObj)
-(void) addCadenza: (Cadenza *)cadenza {
	TableViewDataSourceCadenze *obj = [[TableViewDataSourceCadenze alloc] initWithCadenza:cadenza];
	[currentTableArray addObject:obj];
	[counter addObject:obj];
}

-(void) addCadenzaArray: (NSMutableArray *)cadenzaArray {
	if ([cadenzaArray count]!=0) {
		for (int i=0; i<[cadenzaArray count]; i++) {
			[self addCadenza: [cadenzaArray objectAtIndex:i]];
		}
	}
}

-(TableViewDataSourceCadenze *) returnFromArray {
    if ([currentTableArray selectedObjects]) {
        return [[currentTableArray selectedObjects] objectAtIndex:0];
    }
    else {
        return nil;
    }
}
@end

@implementation TableViewController (DueColonneObj)
-(void) addSistemaTemperato: (InsiemeNote *)insieme {
	for (int i=0; i<[insieme entries]; i++) {
		TableViewDataSourceSistemaTemperato *obj = [[TableViewDataSourceSistemaTemperato alloc] initWithNote:[insieme lookForNote:i]];
		[currentTableArray addObject:obj];
		[counter addObject:obj];
		
	}
}
@end

@implementation TableViewController (TonalitaObj)
-(void) addChordsTonalita:(NSMutableArray *)chordArray {
	for (int i=0; i<[chordArray count]; i++) {
		TableViewDataSourceTonal *obj = [[TableViewDataSourceTonal alloc] initWithChord:[chordArray objectAtIndex:i]];
		[currentTableArray addObject:obj];
		[counter addObject:obj];
	}
}
@end

@implementation TableViewController (Utilities)
-(void) addEmptyRowToTableViewDataSource {
	TableViewDataSource *obj = [[TableViewDataSource alloc] initEmptyRow];
	[currentTableArray addObject:obj];
	[counter addObject:obj];
}

-(void) addEmptyRowToTableViewDataSourceTonal {
	TableViewDataSourceTonal *obj = [[TableViewDataSourceTonal alloc] initEmptyRow];
	[currentTableArray addObject:obj];
	[counter addObject:obj];
}

-(void) addEmptyRowToTableViewDataSourceCadenze {
	TableViewDataSourceCadenze *obj = [[TableViewDataSourceCadenze alloc] initEmptyRow];
	[currentTableArray addObject:obj];
	[counter addObject:obj];
}
@end

@implementation TableViewController (Destructors)
-(void) clearTable{
	[currentTableArray removeObjects:counter];
}

-(void) clearItemAtRow: (int)row {
	[currentTableArray removeObjectAtArrangedObjectIndex:row];
}

-(void) dealloc {
	[currentTableArray release];
	[counter release];
	[super dealloc];
}
@end
