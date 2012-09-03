//
//  Controller.h
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/3/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "TableViewController.h"
#import "Harmony_CombosAppDelegate.h"
#import "TableViewDataSourceHeader.h"

@interface Controller : NSObject {
    IBOutlet NSWindow *mainWindow;
	//VARIABILI OGGETTI LOGICI
	Compositore *bach;
	InsiemeNote *sistemaTemperato;
	Note *tonicaT, *terzaT, *quintaT, *tonicaD, *terzaD, *quintaD;
	Chord *harmonyT, *harmonyD;
	//Creazioni delle voci che intendo utilizzare
	InsiemeNote *bassoObj; 
	InsiemeNote *tenoreObj;
	InsiemeNote *altoObj;
	InsiemeNote *sopranoObj;
	//Creazione variabili voci nell'ambito degli accordi considerati
	//Tonica T
	InsiemeNote *bassoTonalT;
	InsiemeNote *tenoreTonalT;
	InsiemeNote *altoTonalT;
	InsiemeNote *sopranoTonalT;
	//Dominante D
	InsiemeNote *bassoTonalD;
	InsiemeNote *tenoreTonalD;
	InsiemeNote *altoTonalD;
	InsiemeNote *sopranoTonalD;
	//Matrici
	NSMutableArray *mtrxV;
	MtrxNVoices *mtrxLimits; //Limiti
	MtrxNVoices *mtrxVoxT; //Tonica
	MtrxNVoices *mtrxVoxD; //Dominante
	//Variabili per la cobinazione
	NSMutableArray *mtrxT, *mtrxD, *result;
	//VARIABILI INTERFACCIA
	int tonalitaNum;
	int numCombinazioniTot;
	IBOutlet NSArrayController *tonalitaTableArray, *tonalitaTableArrayDominante, *limitiTableArray, *sistemaTemperatoTableArray, *chordTonalitaTableArray, *cadenzaTableArray;
	IBOutlet NSTextFieldCell *sistemaTemperatoNomeTextField, *sistemaTemperatoNumTextField;
	IBOutlet NSTextFieldCell *tonalitaLabelTextField, *tonicaLabelTextField, *terzaLabelTextField, *quintaLabelTextField;
	IBOutlet NSTextFieldCell *bassoLimitiTextField, *tenoreLimitiTextField, *altoLimitiTextField, *sopranoLimitiTextField;
	IBOutlet NSTextFieldCell *bassoTonicaTextField, *tenoreTonicaTextField, *altoTonicaTextField, *sopranoTonicaTextField;
	IBOutlet NSTextFieldCell *bassoDominaTextField, *tenoreDominaTextField, *altoDominaTextField, *sopranoDominaTextField;
	IBOutlet NSTextFieldCell *bassoCadTonTextField, *tenoreCadTonTextField, *altoCadTonTextField, *sopranoCadTonTextField;
	IBOutlet NSTextFieldCell *bassoCadDomTextField, *tenoreCadDomTextField, *altoCadDomTextField, *sopranoCadDomTextField;
	IBOutlet NSTextField *numNoteBassoD, *numNoteTenoreD, *numNoteAltoD, *numNoteSopranoD, *numNoteBassoT, *numNoteTenoreT, *numNoteAltoT, *numNoteSopranoT, *numCombos;
	IBOutlet NSButton *bassoHaFondamentaleButton, *terzaEQuintaButton, *partiStretteOLateButton, *nonSonoAmmessiIncrociButton, *noQuinteEOttaveParalleleButton, *noMovimentiEccessivi, *clausolaCantizans, *noClausolaFuggitaInBS;
    IBOutlet NSButton *playButton;
	IBOutlet NSProgressIndicator *comboProgressIndicator;
	IBOutlet NSTextField *progressTextField;
	IBOutlet NSPanel *processingPanel, *infoPanel, *opzioniPanel;
    IBOutlet NSMenuItem *playMenu;
	//Table View Controllers
	TableViewController *controllerSistemaTemperato;
	TableViewController *controllerTonalitaList;
	TableViewController *controllerLimitiVoci;
	TableViewController *controllerAccordoTonica;
	TableViewController *controllerAccordoDominante;
	TableViewController *controllerCadenze;
	
	NSMutableArray *controllerCounter;
	BOOL colorItemsABSwitch;
    //Array e variabili per il metodo Play
    NSMutableArray *dominantePlayArray, *tonicaPlayArray;
    BOOL playFlag;
    //String data LilyPond
    NSString *lilyData;
}
-(id) init;
-(void) openFileDirectly: (NSNotification *)notification;
-(void) setLilyPondData: (NSNotification *)notification;
@end

@interface Controller (TonalitaButtons)
-(IBAction) press_A_Button: (id)sender;
-(IBAction) press_Ad_Button: (id)sender;
-(IBAction) press_B_Button: (id)sender;
-(IBAction) press_C_Button: (id)sender;
-(IBAction) press_Cd_Button: (id)sender;
-(IBAction) press_D_Button: (id)sender;
-(IBAction) press_Dd_Button: (id)sender;
-(IBAction) press_E_Button: (id)sender;
-(IBAction) press_F_Button: (id)sender;
-(IBAction) press_Fd_Button: (id)sender;
-(IBAction) press_G_Button: (id)sender;
-(IBAction) press_Gd_Button: (id)sender;
@end

@interface Controller (ToolbarButtons)
-(IBAction) press_Save_Button: (id)sender;
-(IBAction) press_Info_Buttom: (id)sender;
-(IBAction) press_Opzioni_Button: (id)sender;
-(IBAction) press_Load_Button: (id) sender;
@end

@interface Controller (GenerateClearButtons)
-(IBAction) generate: (id)sender;
-(IBAction) clear: (id)sender;
@end

@interface Controller (PlayButton)
-(IBAction) play: (id)sender;
-(IBAction) playMenu: (id) sender;
-(IBAction) selTable: (id) sender;
@end

@interface Controller (LilyPondExport)
-(IBAction) export_LilyPond_Files: (id)sender;
@end

@interface Controller (Destructors)
-(void) dealloc;
@end