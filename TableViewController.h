//
//  TableViewController.h
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/6/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "TableViewDataSourceHeader.h"

@interface TableViewController : NSObject {
	NSArrayController *currentTableArray;
	NSMutableArray *counter;
}
@end

@interface TableViewController (Inizializzatori)
-(id) initWithArrayController: (NSArrayController *)arrayObj;
@end

@interface TableViewController (QuattroColonneObj)
-(void) addMtrxObj: (MtrxNVoices *)mtrx;
-(void) addChord: (Chord *)chord;	
-(void) addChordArray: (NSMutableArray *)chordArray;
@end

@interface TableViewController (OttoColonneObj)
-(void) addCadenza: (Cadenza *)cadenza;
-(void) addCadenzaArray: (NSMutableArray *)cadenzaArray;
-(TableViewDataSourceCadenze *) returnFromArray;
@end

@interface TableViewController (DueColonneObj)
-(void) addSistemaTemperato: (InsiemeNote *)insieme;
@end

@interface TableViewController (TonalitaObj)
-(void) addChordsTonalita:(NSMutableArray *)chordArray;
@end

@interface TableViewController (Utilities)
-(void) addEmptyRowToTableViewDataSourceTonal;
-(void) addEmptyRowToTableViewDataSource;
-(void) addEmptyRowToTableViewDataSourceCadenze;
@end

@interface TableViewController (Destructors)
-(void) clearTable;
-(void) clearItemAtRow: (int)row;
-(void) dealloc;
@end