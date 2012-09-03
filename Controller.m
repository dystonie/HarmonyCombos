//
//  Controller.m
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/3/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Controller.h"

@implementation Controller
-(id) init {
    [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFileDirectly:) name:@"File_Name" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLilyPondData:) name:@"Return_LilyPound_Data" object:nil];
        lilyData = nil;
        tonalitaNum = TON_C;
    }
    return self;
}

-(void) openFileDirectly:(NSNotification *)notification {
    //Riceve il messaggio di apertura file dall'App Delegate
    NSString *fileName = [[notification userInfo] objectForKey:@"File_Name"];
    
    //LOAD DA FILE
	NSMutableData *dataArea;
	NSKeyedUnarchiver *unarchiver;
    [self clear:self];
    dataArea = [NSData dataWithContentsOfFile:fileName]; //Lettura file
    unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData: dataArea];
    //decodifica oggetti da salvare
    sistemaTemperato = [unarchiver decodeObjectForKey:@"Sistema_Temperato"];
    harmonyT = [unarchiver decodeObjectForKey:@"Accordo_Tonica"];
    harmonyD = [unarchiver decodeObjectForKey:@"Accordo_Dominante"];
    mtrxT = [unarchiver decodeObjectForKey:@"Array_Tonica"];
    mtrxD = [unarchiver decodeObjectForKey:@"Array_Dominante"];
    mtrxV = [unarchiver decodeObjectForKey:@"Array_Limits"];
    mtrxLimits = [unarchiver decodeObjectForKey:@"Limiti_Voci"];
    mtrxVoxT = [unarchiver decodeObjectForKey:@"Tonice_Voci"];
    mtrxVoxD = [unarchiver decodeObjectForKey:@"Dominante_Voci"];
    result = [unarchiver decodeObjectForKey:@"Combinazioni"];
    lilyData = [unarchiver decodeObjectForKey:@"LilyData"];
    [unarchiver finishDecoding];
    [unarchiver release];
    
    //INIZIALIZZAZIONE GRAFICA
    //Apre la finestra progresso e mostra l'avanzamento
    [processingPanel setIsVisible:TRUE];	
    [comboProgressIndicator setIndeterminate:TRUE];
    [comboProgressIndicator setUsesThreadedAnimation:TRUE];
    [comboProgressIndicator startAnimation:self];
    //Counter dei controller creati
    if ([controllerCounter count]>0) {
        controllerCounter = [[NSMutableArray alloc] initWithArray:controllerCounter];
    }
    else {
        controllerCounter = [[NSMutableArray alloc] initWithObjects:nil];
    }
    //Table sistema temperato
    //Creo tramite il Controller una Data Source e gestisco l'aspetto grafico
    controllerSistemaTemperato = [[TableViewController alloc] initWithArrayController:sistemaTemperatoTableArray];
    [controllerCounter addObject:controllerSistemaTemperato];
    [controllerSistemaTemperato addSistemaTemperato: sistemaTemperato];
    //Table lista tonalita
    controllerTonalitaList = [[TableViewController alloc] initWithArrayController:chordTonalitaTableArray];
    [tonalitaLabelTextField setDrawsBackground:TRUE];
    [tonicaLabelTextField setDrawsBackground:TRUE];
    [terzaLabelTextField setDrawsBackground:TRUE];
    [quintaLabelTextField setDrawsBackground:TRUE];
    [tonalitaLabelTextField setBackgroundColor:[NSColor gridColor]];
    [tonicaLabelTextField setBackgroundColor:[NSColor blackColor]];
    [terzaLabelTextField setBackgroundColor:[NSColor blueColor]];	
    [quintaLabelTextField setBackgroundColor:[NSColor purpleColor]];	
    [controllerCounter addObject:controllerTonalitaList];
    [controllerTonalitaList addChordsTonalita:[[NSMutableArray alloc] initWithObjects:harmonyT, harmonyD, nil]];
    [controllerTonalitaList addEmptyRowToTableViewDataSourceTonal];
    //Table limiti voci	
    controllerLimitiVoci = [[TableViewController alloc] initWithArrayController:limitiTableArray];
    [controllerCounter addObject:controllerLimitiVoci];
    [controllerLimitiVoci addMtrxObj:mtrxLimits];
    [controllerLimitiVoci addEmptyRowToTableViewDataSource];
    //Table accordi tonica e dominate
    controllerAccordoTonica = [[TableViewController alloc] initWithArrayController:tonalitaTableArray];
    [controllerCounter addObject:controllerAccordoTonica];
    [controllerAccordoTonica addMtrxObj:mtrxVoxT];
    [controllerAccordoTonica addEmptyRowToTableViewDataSource];
    controllerAccordoDominante = [[TableViewController alloc] initWithArrayController:tonalitaTableArrayDominante];
    [controllerCounter addObject:controllerAccordoDominante];
    [controllerAccordoDominante addMtrxObj:mtrxVoxD];
    [controllerAccordoDominante addEmptyRowToTableViewDataSource];
    //Settaggio delle informazioni della finestra INFO
    NSString *str01 = NSLocalizedStringFromTable (@"str.01", @"InfoPlist", @"");
    [numNoteBassoT setStringValue:[NSString stringWithFormat:@"%@ %@", str01, [NSNumber numberWithInt:[[mtrxT objectAtIndex:0] entries]]]];
    NSString *str02 = NSLocalizedStringFromTable (@"str.02", @"InfoPlist", @"");
    [numNoteTenoreT setStringValue:[NSString stringWithFormat:@"%@ %@", str02, [NSNumber numberWithInt:[[mtrxT objectAtIndex:1] entries]]]];
    NSString *str03 = NSLocalizedStringFromTable (@"str.03", @"InfoPlist", @"");
    [numNoteAltoT setStringValue:[NSString stringWithFormat:@"%@ %@", str03, [NSNumber numberWithInt:[[mtrxT objectAtIndex:2] entries]]]];
    NSString *str04 = NSLocalizedStringFromTable (@"str.04", @"InfoPlist", @"");
    [numNoteSopranoT setStringValue:[NSString stringWithFormat:@"%@ %@", str04, [NSNumber numberWithInt:[[mtrxT objectAtIndex:3] entries]]]];
    NSString *str05 = NSLocalizedStringFromTable (@"str.05", @"InfoPlist", @"");
    [numNoteBassoD setStringValue:[NSString stringWithFormat:@"%@ %@", str05, [NSNumber numberWithInt:[[mtrxD objectAtIndex:0] entries]]]];
    NSString *str06 = NSLocalizedStringFromTable (@"str.06", @"InfoPlist", @"");
    [numNoteTenoreD setStringValue:[NSString stringWithFormat:@"%@ %@", str06, [NSNumber numberWithInt:[[mtrxD objectAtIndex:1] entries]]]];
    NSString *str07 = NSLocalizedStringFromTable (@"str.07", @"InfoPlist", @"");
    [numNoteAltoD setStringValue:[NSString stringWithFormat:@"%@ %@", str07, [NSNumber numberWithInt:[[mtrxD objectAtIndex:2] entries]]]];
    NSString *str08 = NSLocalizedStringFromTable (@"str.08", @"InfoPlist", @"");
    [numNoteSopranoD setStringValue:[NSString stringWithFormat:@"%@ %@", str08, [NSNumber numberWithInt:[[mtrxD objectAtIndex:3] entries]]]];
    //Interfaccia Grafica delle Combinazioni
    controllerCadenze = [[TableViewController alloc] initWithArrayController:cadenzaTableArray];
    [controllerCounter addObject:controllerCadenze];
    //Ciclo for per l'aggiunta a Table View e gestione barra di progresso
    for (int i=0; i<[result count]; i++) {
        [controllerCadenze addCadenza:[result objectAtIndex:i]];
        numCombinazioniTot++;
    }	
    [controllerCadenze addEmptyRowToTableViewDataSourceCadenze];
    NSString *str09 = NSLocalizedStringFromTable (@"str.09", @"InfoPlist", @"");
    [numCombos setStringValue:[NSString stringWithFormat:@"%@ %@", str09, [NSNumber numberWithInt:numCombinazioniTot]]];
    [comboProgressIndicator stopAnimation:self];
    NSBeep();
    [str01 release];
    [str02 release];
    [str03 release];
    [str04 release];
    [str05 release];
    [str06 release];
    [str07 release];
    [str08 release];
    [str09 release];
    [processingPanel setIsVisible:FALSE];
}

-(void) setLilyPondData: (NSNotification *)notification {
    //Arriva un messaggio contenente i dati dalla classe LilyPoundInterface
    lilyData = [[notification userInfo] objectForKey:@"LilyPound_Data"];
}
@end

@implementation Controller (TonalitaButtons)
-(IBAction) press_A_Button: (id)sender {
	tonalitaNum = TON_A;
}

-(IBAction) press_Ad_Button: (id)sender {
	tonalitaNum = TON_Ad;
}

-(IBAction) press_B_Button: (id)sender {
	tonalitaNum = TON_B;
}

-(IBAction) press_C_Button: (id)sender {
	tonalitaNum = TON_C;
}

-(IBAction) press_Cd_Button: (id)sender {
	tonalitaNum = TON_Cd;
}

-(IBAction) press_D_Button: (id)sender {
	tonalitaNum = TON_D;
}

-(IBAction) press_Dd_Button: (id)sender {
	tonalitaNum = TON_Dd;
}

-(IBAction) press_E_Button: (id)sender {
	tonalitaNum = TON_E;
}

-(IBAction) press_F_Button: (id)sender {
	tonalitaNum = TON_F;
}

-(IBAction) press_Fd_Button: (id)sender {
	tonalitaNum = TON_Fd;
}

-(IBAction) press_G_Button: (id)sender {
	tonalitaNum = TON_G;
}

-(IBAction) press_Gd_Button: (id)sender {
	tonalitaNum = TON_Gd;
}
@end

@implementation Controller (ToolbarButtons)
-(IBAction) press_Save_Button: (id)sender {

	NSMutableData *dataArea;
	NSKeyedArchiver *archiver;
	
	dataArea = [NSMutableData data];
	archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArea];
	//Archiviazione degli oggetti da salvare
	[archiver encodeObject:sistemaTemperato forKey:@"Sistema_Temperato"];
	[archiver encodeObject:harmonyT forKey:@"Accordo_Tonica"];
	[archiver encodeObject:harmonyD forKey:@"Accordo_Dominante"];
	[archiver encodeObject:mtrxT forKey:@"Array_Tonica"];
	[archiver encodeObject:mtrxD forKey:@"Array_Dominante"];
	[archiver encodeObject:mtrxV forKey:@"Array_Limits"];
	[archiver encodeObject:mtrxLimits forKey:@"Limiti_Voci"];
	[archiver encodeObject:mtrxVoxT forKey:@"Tonice_Voci"];
	[archiver encodeObject:mtrxVoxD forKey:@"Dominante_Voci"];
	[archiver encodeObject:result forKey:@"Combinazioni"];
    [archiver encodeObject:lilyData forKey:@"LilyData"];
	[archiver finishEncoding];
	NSSavePanel *savePanel = [[NSSavePanel alloc] init];
	//[savePanel setRequiredFileType:@"hcfd"];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"hcfd", nil]];
	[savePanel setCanSelectHiddenExtension:TRUE];
	[savePanel setExtensionHidden:TRUE];
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
    [savePanel setNameFieldStringValue:@""];
	 
	/* display the NSSavePanel */
	 int runResult = [savePanel runModal];
	 
	if (runResult == NSFileHandlingPanelOKButton) {		
		if ([dataArea writeToURL:[savePanel URL] atomically:YES] == NO) { //Scrittura e gestione errori
			NSAlert *alert = [[NSAlert alloc] init];
			[alert addButtonWithTitle:@"OK"];
            NSString *str12 = NSLocalizedStringFromTable(@"str.12", @"InfoPlist", @"");
			[alert setMessageText:str12];
            NSString *str13 = NSLocalizedStringFromTable(@"str.13", @"InfoPlist", @"");
			[alert setInformativeText:str13];
			[alert setAlertStyle:NSCriticalAlertStyle];
            [alert runModal];
			[alert release];
            [str12 release];
            [str13 release];
		}
	}
	[savePanel release];
	[archiver release];
	[dataArea release];
}

-(IBAction) press_Load_Button: (id)sender {
	//LOAD DA FILE
	NSMutableData *dataArea;
	NSKeyedUnarchiver *unarchiver;
    NSArray *filetypes = [NSArray arrayWithObject:@"hcfd"];
	
	NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:filetypes];
	if ([openPanel runModal] == NSFileHandlingPanelOKButton) {
		[self clear:self];
		dataArea = [NSData dataWithContentsOfURL:[openPanel URL]]; //Lettura file
		unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData: dataArea];
		//decodifica oggetti da salvare
		sistemaTemperato = [unarchiver decodeObjectForKey:@"Sistema_Temperato"];
		harmonyT = [unarchiver decodeObjectForKey:@"Accordo_Tonica"];
		harmonyD = [unarchiver decodeObjectForKey:@"Accordo_Dominante"];
		mtrxT = [unarchiver decodeObjectForKey:@"Array_Tonica"];
		mtrxD = [unarchiver decodeObjectForKey:@"Array_Dominante"];
		mtrxV = [unarchiver decodeObjectForKey:@"Array_Limits"];
		mtrxLimits = [unarchiver decodeObjectForKey:@"Limiti_Voci"];
		mtrxVoxT = [unarchiver decodeObjectForKey:@"Tonice_Voci"];
		mtrxVoxD = [unarchiver decodeObjectForKey:@"Dominante_Voci"];
		result = [unarchiver decodeObjectForKey:@"Combinazioni"];
        lilyData = [unarchiver decodeObjectForKey:@"LilyData"];
		[unarchiver finishDecoding];
		[unarchiver release];
		
		//INIZIALIZZAZIONE GRAFICA
		//Apre la finestra progresso e mostra l'avanzamento
		[processingPanel setIsVisible:TRUE];	
		[comboProgressIndicator setIndeterminate:TRUE];
		[comboProgressIndicator setUsesThreadedAnimation:TRUE];
		[comboProgressIndicator startAnimation:self];
		//Counter dei controller creati
		if ([controllerCounter count]>0) {
			controllerCounter = [[NSMutableArray alloc] initWithArray:controllerCounter];
		}
		else {
			controllerCounter = [[NSMutableArray alloc] initWithObjects:nil];
		}
		//Table sistema temperato
		//Creo tramite il Controller una Data Source e gestisco l'aspetto grafico
		controllerSistemaTemperato = [[TableViewController alloc] initWithArrayController:sistemaTemperatoTableArray];
		[controllerCounter addObject:controllerSistemaTemperato];
		[controllerSistemaTemperato addSistemaTemperato: sistemaTemperato];
		//Table lista tonalita
		controllerTonalitaList = [[TableViewController alloc] initWithArrayController:chordTonalitaTableArray];
		[tonalitaLabelTextField setDrawsBackground:TRUE];
		[tonicaLabelTextField setDrawsBackground:TRUE];
		[terzaLabelTextField setDrawsBackground:TRUE];
		[quintaLabelTextField setDrawsBackground:TRUE];
		[tonalitaLabelTextField setBackgroundColor:[NSColor gridColor]];
		[tonicaLabelTextField setBackgroundColor:[NSColor blackColor]];
		[terzaLabelTextField setBackgroundColor:[NSColor blueColor]];	
		[quintaLabelTextField setBackgroundColor:[NSColor purpleColor]];	
		[controllerCounter addObject:controllerTonalitaList];
		[controllerTonalitaList addChordsTonalita:[[NSMutableArray alloc] initWithObjects:harmonyT, harmonyD, nil]];
		[controllerTonalitaList addEmptyRowToTableViewDataSourceTonal];
		//Table limiti voci	
		controllerLimitiVoci = [[TableViewController alloc] initWithArrayController:limitiTableArray];
		[controllerCounter addObject:controllerLimitiVoci];
		[controllerLimitiVoci addMtrxObj:mtrxLimits];
		[controllerLimitiVoci addEmptyRowToTableViewDataSource];
		//Table accordi tonica e dominate
		controllerAccordoTonica = [[TableViewController alloc] initWithArrayController:tonalitaTableArray];
		[controllerCounter addObject:controllerAccordoTonica];
		[controllerAccordoTonica addMtrxObj:mtrxVoxT];
		[controllerAccordoTonica addEmptyRowToTableViewDataSource];
		controllerAccordoDominante = [[TableViewController alloc] initWithArrayController:tonalitaTableArrayDominante];
		[controllerCounter addObject:controllerAccordoDominante];
		[controllerAccordoDominante addMtrxObj:mtrxVoxD];
		[controllerAccordoDominante addEmptyRowToTableViewDataSource];
		//Settaggio delle informazioni della finestra INFO
         NSString *str01 = NSLocalizedStringFromTable (@"str.01", @"InfoPlist", @"");
		[numNoteBassoT setStringValue:[NSString stringWithFormat:@"%@ %@", str01, [NSNumber numberWithInt:[[mtrxT objectAtIndex:0] entries]]]];
         NSString *str02 = NSLocalizedStringFromTable (@"str.02", @"InfoPlist", @"");
		[numNoteTenoreT setStringValue:[NSString stringWithFormat:@"%@ %@", str02, [NSNumber numberWithInt:[[mtrxT objectAtIndex:1] entries]]]];
         NSString *str03 = NSLocalizedStringFromTable (@"str.03", @"InfoPlist", @"");
		[numNoteAltoT setStringValue:[NSString stringWithFormat:@"%@ %@", str03, [NSNumber numberWithInt:[[mtrxT objectAtIndex:2] entries]]]];
         NSString *str04 = NSLocalizedStringFromTable (@"str.04", @"InfoPlist", @"");
		[numNoteSopranoT setStringValue:[NSString stringWithFormat:@"%@ %@", str04, [NSNumber numberWithInt:[[mtrxT objectAtIndex:3] entries]]]];
         NSString *str05 = NSLocalizedStringFromTable (@"str.05", @"InfoPlist", @"");
		[numNoteBassoD setStringValue:[NSString stringWithFormat:@"%@ %@", str05, [NSNumber numberWithInt:[[mtrxD objectAtIndex:0] entries]]]];
         NSString *str06 = NSLocalizedStringFromTable (@"str.06", @"InfoPlist", @"");
		[numNoteTenoreD setStringValue:[NSString stringWithFormat:@"%@ %@", str06, [NSNumber numberWithInt:[[mtrxD objectAtIndex:1] entries]]]];
         NSString *str07 = NSLocalizedStringFromTable (@"str.07", @"InfoPlist", @"");
		[numNoteAltoD setStringValue:[NSString stringWithFormat:@"%@ %@", str07, [NSNumber numberWithInt:[[mtrxD objectAtIndex:2] entries]]]];
         NSString *str08 = NSLocalizedStringFromTable (@"str.08", @"InfoPlist", @"");
		[numNoteSopranoD setStringValue:[NSString stringWithFormat:@"%@ %@", str08, [NSNumber numberWithInt:[[mtrxD objectAtIndex:3] entries]]]];
		//Interfaccia Grafica delle Combinazioni
		controllerCadenze = [[TableViewController alloc] initWithArrayController:cadenzaTableArray];
		[controllerCounter addObject:controllerCadenze];
		//Ciclo for per l'aggiunta a Table View e gestione barra di progresso
        for (int i=0; i<[result count]; i++) {
			[controllerCadenze addCadenza:[result objectAtIndex:i]];
            numCombinazioniTot++;
		}	
		[controllerCadenze addEmptyRowToTableViewDataSourceCadenze];
         NSString *str09 = NSLocalizedStringFromTable (@"str.09", @"InfoPlist", @"");
		[numCombos setStringValue:[NSString stringWithFormat:@"%@ %@", str09, [NSNumber numberWithInt:numCombinazioniTot]]];
		[comboProgressIndicator stopAnimation:self];
		NSBeep();
        [str01 release];
        [str02 release];
        [str03 release];
        [str04 release];
        [str05 release];
        [str06 release];
        [str07 release];
        [str08 release];
        [str09 release];
		[processingPanel setIsVisible:FALSE];		
	}
}

-(IBAction) press_Info_Buttom: (id)sender {
	[infoPanel setIsVisible:TRUE];
}

-(IBAction) press_Opzioni_Button: (id)sender {
	[opzioniPanel setIsVisible:TRUE];
}
@end

@implementation Controller (GenerateClearButtons)
-(IBAction) generate: (id)sender {
    [self clear:self];
	/***************************************************/
	//INIZIALIZZAZIONE
	//Apre la finestra progresso e mostra l'avanzamento
	//[processingPanel setIsVisible:TRUE];
    [NSApp beginSheet:processingPanel modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	[comboProgressIndicator setIndeterminate:TRUE];
	[comboProgressIndicator setUsesThreadedAnimation:TRUE];
	[comboProgressIndicator startAnimation:self];
	//Counter dei controller creati
	if ([controllerCounter count]>0) {
		controllerCounter = [[NSMutableArray alloc] initWithArray:controllerCounter];
	}
	else {
		controllerCounter = [[NSMutableArray alloc] initWithObjects:nil];
	}
		
	/***************************************************/
	//DEFINIZIONE DELLE VARIABILI:
	bach = [[Compositore alloc]initWithNVoices:4];
	sistemaTemperato = [[InsiemeNote alloc] initWithName:@"Sistema Temperato"];
    //Definizione accordo tonica
	tonicaT = [[Note alloc] initWithNoteNumber:(MIN_MIDI_NOTE + tonalitaNum)];
	terzaT = [[Note alloc] initWithNoteNumber:(MIN_MIDI_NOTE + tonalitaNum + INT_TERZA_M)];
	quintaT = [[Note alloc] initWithNoteNumber:(MIN_MIDI_NOTE + tonalitaNum + INT_QUINTA_G)];
	//Definizione accordo dominante
	tonicaD = [[Note alloc] initWithNoteNumber:(MIN_MIDI_NOTE + (tonalitaNum + INT_QUINTA_G))];
	terzaD = [[Note alloc] initWithNoteNumber:(MIN_MIDI_NOTE + (tonalitaNum + INT_QUINTA_G) + INT_TERZA_M)];
	quintaD = [[Note alloc] initWithNoteNumber:(MIN_MIDI_NOTE + (tonalitaNum + INT_QUINTA_G) + INT_QUINTA_G)];
	//Verifico le limitazioni scelte:
	if ([bassoHaFondamentaleButton state] == NSOnState)
		[bach setFlagBassoFondamentale:TRUE];
	else
		[bach setFlagBassoFondamentale:FALSE];
	if ([terzaEQuintaButton state] == NSOnState)
		[bach setFlagTerzaEQuinta:TRUE];
	else
		[bach setFlagTerzaEQuinta:FALSE];
	if ([partiStretteOLateButton state] == NSOnState)
		[bach setFlagPartiStretteLate:TRUE];
	else
		[bach setFlagPartiStretteLate:FALSE];
	if ([nonSonoAmmessiIncrociButton state] == NSOnState)
		[bach setFlagIncrociParti:TRUE];
	else
		[bach setFlagIncrociParti:FALSE];
	if ([noQuinteEOttaveParalleleButton state] == NSOnState) {
		[bach setFlagQuinteOttaveParallele:TRUE];
        [bach setFlagNoIncrociInterniAccordo:TRUE];
    }
    else
		[bach setFlagQuinteOttaveParallele:FALSE];
    if ([noMovimentiEccessivi state] == NSOnState)
        [bach setFlagNoMovimentiEccessivi:TRUE];
    else
        [bach setFlagNoMovimentiEccessivi:FALSE];
    if ([noClausolaFuggitaInBS state] == NSOnState)
        [bach setFlagNoClausolaFuggitaInBS:TRUE];
    else 
        [bach setFlagNoClausolaFuggitaInBS:FALSE];
    if ([clausolaCantizans state] == NSOnState)
        [bach setFlagClausolaCantizans:TRUE];
    else 
        [bach setFlagClausolaCantizans:FALSE];
	
	//CREAZIONE DEI CHORD CONTENENTI I GRADI DELLA TONICA
	/************************************************************/
	//Nell utilizzo dei Chords è importante ricordare:
	// a) il Chord tonale (che definisce la tonalità) contiene 
	//    i gradi fondamentali dell'accordo di tonica nella
	//    ottava più bassa con etichetta TONICA, TERZA e
	//    QUINTA.
	// b) i Chord utilizzati per organizzare le voci devono
	//    contenere le etichette che identificano le voci:
	//    BASSO, TENORE, ALTO, SOPRANO.
	/************************************************************/
	NSString *str10 = NSLocalizedStringFromTable (@"str.10", @"InfoPlist", @"");
    harmonyT = [[Chord alloc] initEmptyWithName:str10];
	[harmonyT addNote:tonicaT asGrade:[NSString stringWithUTF8String:TONICA]];
	[harmonyT addNote:terzaT asGrade:[NSString stringWithUTF8String:TERZA]];
	[harmonyT addNote:quintaT asGrade:[NSString stringWithUTF8String:QUINTA]];
	//Creazione Chord contenente i gradi selezionati sulla dominante
    NSString *str11 = NSLocalizedStringFromTable (@"str.11", @"InfoPlist", @"");
	harmonyD = [[Chord alloc] initEmptyWithName:str11];
	[harmonyD addNote:tonicaD asGrade:[NSString stringWithUTF8String:TONICA]];
	[harmonyD addNote:terzaD asGrade:[NSString stringWithUTF8String:TERZA]];
	[harmonyD addNote:quintaD asGrade:[NSString stringWithUTF8String:QUINTA]];
	//Assegno al compositore la tonalità
	[bach setTonalChord:harmonyT];
	/***************************************************/
	//INIZIALIZZAZIONE SISTEMA TEMPERATO
	//inizializza barra progresso
	[comboProgressIndicator stopAnimation:self];
	[comboProgressIndicator setIndeterminate:FALSE];
	[comboProgressIndicator setMaxValue:140.00];
	[comboProgressIndicator setDoubleValue:0.00];
	[comboProgressIndicator displayIfNeeded];
	//Inizializzazione Compositore con insieme note	
	[bach fillWithSistemaTemperato: sistemaTemperato];
	//Gestione barra progresso
	[comboProgressIndicator incrementBy:10.00];
	[comboProgressIndicator displayIfNeeded];
	
	/***************************************************/
	//DEFINIZIONE DEI LIMITI DELLE VOCI
	bassoObj = [bach applyVoicesLimitsTo:sistemaTemperato minValue:BASS_MIN andMaxValue:BASS_MAX andLabel:[NSString stringWithUTF8String:BASSO]];
	tenoreObj = [bach applyVoicesLimitsTo:sistemaTemperato minValue:TENO_MIN andMaxValue:TENO_MAX andLabel:[NSString stringWithUTF8String:TENORE]];
	altoObj = [bach applyVoicesLimitsTo:sistemaTemperato minValue:ALTO_MIN andMaxValue:ALTO_MAX andLabel:[NSString stringWithUTF8String:ALTO]];	
	sopranoObj = [bach applyVoicesLimitsTo:sistemaTemperato minValue:SOPR_MIN andMaxValue:SOPR_MAX andLabel:[NSString stringWithUTF8String:SOPRANO]];	
	//Gestione progresso
	[comboProgressIndicator incrementBy:10.00];
	[comboProgressIndicator displayIfNeeded];
	
	/***************************************************/
	//DEFINIZIONE DEI LIMITI TONALI DELLE VOCI
	//Tonica
	bassoTonalT = [bach applyTonalLimitsTo:bassoObj withGrades:harmonyT andLabel:[NSString stringWithUTF8String:BASSO]];
	tenoreTonalT = [bach applyTonalLimitsTo:tenoreObj withGrades:harmonyT andLabel:[NSString stringWithUTF8String:TENORE]];
	altoTonalT = [bach applyTonalLimitsTo:altoObj withGrades:harmonyT andLabel:[NSString stringWithUTF8String:ALTO]];
	sopranoTonalT = [bach applyTonalLimitsTo:sopranoObj withGrades:harmonyT andLabel:[NSString stringWithUTF8String:SOPRANO]];
	//Dominante
	bassoTonalD = [bach applyTonalLimitsTo:bassoObj withGrades:harmonyD andLabel:[NSString stringWithUTF8String:BASSO]];
	tenoreTonalD = [bach applyTonalLimitsTo:tenoreObj withGrades:harmonyD andLabel:[NSString stringWithUTF8String:TENORE]];
	altoTonalD = [bach applyTonalLimitsTo:altoObj withGrades:harmonyD andLabel:[NSString stringWithUTF8String:ALTO]];
	sopranoTonalD = [bach applyTonalLimitsTo:sopranoObj withGrades:harmonyD andLabel:[NSString stringWithUTF8String:SOPRANO]];
	//Gestione progresso
	[comboProgressIndicator incrementBy:10.00];
	[comboProgressIndicator displayIfNeeded];
	
	/***************************************************/
	//GENERAZIONE DI TUTTE LE POSSIBILI COMBINAZIONI
	mtrxT = [[NSMutableArray alloc] initWithObjects:bassoTonalT, tenoreTonalT, altoTonalT, sopranoTonalT, nil];
	mtrxD = [[NSMutableArray alloc] initWithObjects:bassoTonalD, tenoreTonalD, altoTonalD, sopranoTonalD, nil];
	//Parte da un array di InsiemeNote e ritorna un insieme di Cadenze
	result = [bach combineArraysIntoCadenze:mtrxD andArray:mtrxT];
    
	/***************************************************/
	//INTERFACCIA GRAFICA DEGLI OGGETTI
	mtrxV = [[NSMutableArray alloc] initWithObjects:bassoObj, tenoreObj, altoObj, sopranoObj, nil];
	//Matrice limiti delle voci
	mtrxLimits = [[MtrxNVoices alloc] initWithName:@"Mtrx Limiti" andArray:mtrxV];
	//Matrici degli accordi selezionati
	mtrxVoxT = [[MtrxNVoices alloc] initWithName:@"Mtrx Tonica" andArray:mtrxT];
	mtrxVoxD = [[MtrxNVoices alloc] initWithName:@"Mtrx Dominante" andArray:mtrxD];
	
	/***************************************************/
	//GESTIONE TABLE VIEW
	//Table sistema temperato
	//Creo tramite il Controller una Data Source e gestisco l'aspetto grafico
	controllerSistemaTemperato = [[TableViewController alloc] initWithArrayController:sistemaTemperatoTableArray];
	[controllerCounter addObject:controllerSistemaTemperato];
	[controllerSistemaTemperato addSistemaTemperato: sistemaTemperato];
	//Table lista tonalita
	controllerTonalitaList = [[TableViewController alloc] initWithArrayController:chordTonalitaTableArray];
	[tonalitaLabelTextField setDrawsBackground:TRUE];
	[tonicaLabelTextField setDrawsBackground:TRUE];
	[terzaLabelTextField setDrawsBackground:TRUE];
	[quintaLabelTextField setDrawsBackground:TRUE];
	[tonalitaLabelTextField setBackgroundColor:[NSColor gridColor]];
	[tonicaLabelTextField setBackgroundColor:[NSColor blackColor]];
	[terzaLabelTextField setBackgroundColor:[NSColor blueColor]];	
	[quintaLabelTextField setBackgroundColor:[NSColor purpleColor]];	
	[controllerCounter addObject:controllerTonalitaList];
	[controllerTonalitaList addChordsTonalita:[[NSMutableArray alloc] initWithObjects:harmonyT, harmonyD, nil]];
	[controllerTonalitaList addEmptyRowToTableViewDataSourceTonal];
	//Table limiti voci	
	controllerLimitiVoci = [[TableViewController alloc] initWithArrayController:limitiTableArray];
	[controllerCounter addObject:controllerLimitiVoci];
	[controllerLimitiVoci addMtrxObj:mtrxLimits];
	[controllerLimitiVoci addEmptyRowToTableViewDataSource];
	//Table accordi tonica e dominate
	controllerAccordoTonica = [[TableViewController alloc] initWithArrayController:tonalitaTableArray];
	[controllerCounter addObject:controllerAccordoTonica];
	[controllerAccordoTonica addMtrxObj:mtrxVoxT];
	[controllerAccordoTonica addEmptyRowToTableViewDataSource];
	controllerAccordoDominante = [[TableViewController alloc] initWithArrayController:tonalitaTableArrayDominante];
	[controllerCounter addObject:controllerAccordoDominante];
	[controllerAccordoDominante addMtrxObj:mtrxVoxD];
	[controllerAccordoDominante addEmptyRowToTableViewDataSource];
	//Settaggio delle informazioni della finestra INFO localizzate
    NSString *str01 = NSLocalizedStringFromTable (@"str.01", @"InfoPlist", @"");    
    [numNoteBassoT setStringValue:[NSString stringWithFormat:@"%@ %@", str01, [NSNumber numberWithInt:[bassoTonalT entries]]]];
    NSString *str02 = NSLocalizedStringFromTable(@"str.02", @"InfoPlist", @"");
	[numNoteTenoreT setStringValue:[NSString stringWithFormat:@"%@ %@", str02, [NSNumber numberWithInt:[tenoreTonalT entries]]]];
    NSString *str03 = NSLocalizedStringFromTable(@"str.03", @"InfoPlist", @"");
	[numNoteAltoT setStringValue:[NSString stringWithFormat:@"%@ %@", str03, [NSNumber numberWithInt:[altoTonalT entries]]]];
    NSString *str04 = NSLocalizedStringFromTable(@"str.04", @"InfoPlist", @"");
	[numNoteSopranoT setStringValue:[NSString stringWithFormat:@"%@ %@", str04, [NSNumber numberWithInt:[sopranoTonalT entries]]]];
    NSString *str05 = NSLocalizedStringFromTable(@"str.05", @"InfoPlist", @"");
	[numNoteBassoD setStringValue:[NSString stringWithFormat:@"%@ %@", str05, [NSNumber numberWithInt:[bassoTonalD entries]]]];
    NSString *str06 = NSLocalizedStringFromTable(@"str.06", @"InfoPlist", @"");
	[numNoteTenoreD setStringValue:[NSString stringWithFormat:@"%@ %@", str06, [NSNumber numberWithInt:[tenoreTonalD entries]]]];
    NSString *str07 = NSLocalizedStringFromTable(@"str.07", @"InfoPlist", @"");
	[numNoteAltoD setStringValue:[NSString stringWithFormat:@"%@ %@", str07, [NSNumber numberWithInt:[altoTonalD entries]]]];
    NSString *str08 = NSLocalizedStringFromTable(@"str.08", @"InfoPlist", @"");
	[numNoteSopranoD setStringValue:[NSString stringWithFormat:@"%@ %@", str08, [NSNumber numberWithInt:[sopranoTonalD entries]]]];
	//Incrementa indicatore di progresso
	[comboProgressIndicator incrementBy:10.00];
	[comboProgressIndicator displayIfNeeded];
	//Interfaccia Grafica delle Combinazioni
	controllerCadenze = [[TableViewController alloc] initWithArrayController:cadenzaTableArray];
	[controllerCounter addObject:controllerCadenze];
	//Ciclo for per l'aggiunta a Table View e gestione barra di progresso
    NSNotificationCenter *selCenter = [NSNotificationCenter defaultCenter];
    NSNotification *selTonalita = [NSNotification notificationWithName:@"Set_Tonalita" object:self 
                                                              userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:tonalitaNum] forKey:@"Tonalita_Num"]];
    [selCenter postNotification:selTonalita];
	for (int i=0; i<[result count]; i++) {
		[controllerCadenze addCadenza:[result objectAtIndex:i]];
        //Notifica per Lilypond translator
        NSNotification *passFromChord = [NSNotification notificationWithName:@"Export_Notes" object:self 
                                                                userInfo:[[[result objectAtIndex:i] getFromChord] getDictionary]];
        NSNotification *passToChord = [NSNotification notificationWithName:@"Export_Notes" object:self 
                                                                  userInfo:[[[result objectAtIndex:i] getToChord] getDictionary]];
        //
        NSNotification *passVoicingDominanteLabel = [NSNotification notificationWithName:@"Set_Voicing_Labels" object:self
                                                                                userInfo:[NSDictionary dictionaryWithObject:[[result objectAtIndex:i] typeOfPartiDominante] forKey:@"Current_Label"]];
        NSNotification *passVoicingTonicaLabel =[NSNotification notificationWithName:@"Set_Voicing_Labels" object:self
                                                                            userInfo:[NSDictionary dictionaryWithObject:[[result objectAtIndex:i] typeOfPartiTonica] forKey:@"Current_Label"]];        
        [selCenter postNotification:passFromChord];
        [selCenter postNotification:passToChord];
        [selCenter postNotification:passVoicingDominanteLabel];
        [selCenter postNotification:passVoicingTonicaLabel];
		numCombinazioniTot++;
		//Gestione barra progresso
		if	(i == ((int)([result count] /4)))
			[comboProgressIndicator incrementBy:25.00];
		if (i == ((int)([result count] /3)))
			[comboProgressIndicator incrementBy:25.00];
		if (i == ((int)([result count] /2)))
			[comboProgressIndicator incrementBy:25.00];
		if (i == ((int) (([result count]) - ([result count] / 4))))
			[comboProgressIndicator incrementBy:15.00];
		if (i == ((int)([result count] -1)))
			[comboProgressIndicator incrementBy:10.00];
		[comboProgressIndicator displayIfNeeded];
	}	
	[controllerCadenze addEmptyRowToTableViewDataSourceCadenze];
    NSString *str09 = NSLocalizedStringFromTable(@"str.09", @"InfoPlist", @"");
	[numCombos setStringValue:[NSString stringWithFormat:@"%@ %@",str09, [NSNumber numberWithInt:numCombinazioniTot]]];
    NSNotification *convertLilypond = [NSNotification notificationWithName:@"Generate_LilyPond_File" object:self userInfo:nil];
    [selCenter postNotification:convertLilypond];
	NSBeep();
	[str01 release];
    [str02 release];
    [str03 release];
    [str04 release];
    [str05 release];
    [str06 release];
    [str07 release];
    [str08 release];
    [str09 release];
    [str10 release];
    [str11 release];
    //[processingPanel setIsVisible:FALSE];
    [processingPanel orderOut:nil];
    [NSApp endSheet:processingPanel];
	/***************************************************/
}

-(IBAction) clear: (id)sender {
	/***************************************************/
	//RIPULISCE LE TABELLE
	//Apre la finestra progresso e mostra l'avanzamento
	[comboProgressIndicator setIndeterminate:TRUE];
	[comboProgressIndicator setUsesThreadedAnimation:TRUE];
	[comboProgressIndicator startAnimation:self];
	[processingPanel setIsVisible:TRUE];	
	for (int i=0; i<[controllerCounter count]; i++) {
		[[controllerCounter objectAtIndex:i] clearTable];
		[[controllerCounter objectAtIndex:i] release];
	}
	numCombinazioniTot = 0;
	//Reset del pannello info
	[numNoteBassoT setStringValue:@""];
	[numNoteTenoreT setStringValue:@""];
	[numNoteAltoT setStringValue:@""];
	[numNoteSopranoT setStringValue:@""];
	[numNoteBassoD setStringValue:@""];
	[numNoteTenoreD setStringValue:@""];
	[numNoteAltoD setStringValue:@""];
	[numNoteSopranoD setStringValue:@""];
    [numNoteSopranoD setStringValue:@""];
	[numCombos setStringValue:@""];
	[comboProgressIndicator stopAnimation:self];
    NSNotificationCenter *selCenter = [NSNotificationCenter defaultCenter];
    NSNotification *clearLily = [NSNotification notificationWithName:@"Clear_LilyPond_Buffer" object:self userInfo:nil];
    [selCenter postNotification:clearLily];
	NSBeep();
	[processingPanel setIsVisible:FALSE];
	/***************************************************/
	if (dominantePlayArray)
        [dominantePlayArray release];
    if (tonicaPlayArray)
        [tonicaPlayArray release];
    if (result)
		[result release];
	if (mtrxD)
		[mtrxD release];
	if (mtrxT)
		[mtrxT release];
	if (sopranoTonalD)
		[sopranoTonalD release];
	if (altoTonalD)
		[altoTonalD release];
	if (tenoreTonalD)
		[tenoreTonalD release];
	if (bassoTonalD)
		[bassoTonalD release];
	if (sopranoTonalT)
		[sopranoTonalT release];
	if (altoTonalT)
		[altoTonalT release];
	if (tenoreTonalT)
		[tenoreTonalT release];
	if (bassoTonalT)
		[bassoTonalT release];
	if (sopranoObj)
		[sopranoObj release];
	if (altoObj)
		[altoObj release];
	if (tenoreObj)
		[tenoreObj release];
	if (bassoObj)
		[bassoObj release];
	if (harmonyT)
		[harmonyT release];
	if (harmonyD)
		[harmonyD release];
	if (tonicaT)
		[tonicaT release];
	if (terzaT)
		[terzaT release];
	if (quintaT)
		[quintaT release];
	if (tonicaD)
		[tonicaD release];
	if (terzaD)
		[terzaD release];
	if (quintaD)
		[quintaD release];
	if (sistemaTemperato)
		[sistemaTemperato release];
	if (bach)
		[bach release];	
}
@end

@implementation Controller (PlayButton)
-(IBAction) play:(id)sender {
    //Impostazione opzione Play
    if ([playButton state] == NSOnState ) {
        playFlag = TRUE;
        [playMenu setState:NSOnState];
    }
    if ([playButton state] == NSOffState) {
        playFlag = FALSE;
        NSNotification *playNote = [NSNotification notificationWithName:@"Midi_Note_Off" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:playNote];
        [playMenu setState:NSOffState];
        [playNote release];
    }
}

-(IBAction) playMenu: (id) sender {
    if ([playMenu state] == NSOnState) {
        playFlag = FALSE;
        NSNotification *playNote = [NSNotification notificationWithName:@"Midi_Note_Off" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:playNote];
        [playMenu setState:NSOffState];
        [playButton setState:NSOffState];
        [playNote release];
    }
    else {
        playFlag = TRUE;
        [playMenu setState:NSOnState];
        [playButton setState:NSOnState];
    }
}

-(IBAction) selTable: (id) sender{
    TableViewDataSourceCadenze *tmp;
    NSMutableArray *domTmp, *tonTmp;
    if (controllerCadenze) {
        tmp = [controllerCadenze returnFromArray];
        dominantePlayArray = [[NSMutableArray alloc] initWithObjects: nil];
        tonicaPlayArray = [[NSMutableArray alloc] initWithObjects: nil];
        tonTmp = [tmp returnNotesTonica];
        domTmp = [tmp returnNotesDominante];
        for (int i=0; i<[domTmp count]; i++) {
            [dominantePlayArray addObject:[[domTmp objectAtIndex:i] getMidiNumber]];
        }
        for (int i=0; i<[tonTmp count]; i++) {
            [tonicaPlayArray addObject:[[tonTmp objectAtIndex:i] getMidiNumber]];
        }
    }
    //AZIONI PRESS PLAY
    //Verifico se PlayFlag è TRUE o FALSE
    if (playFlag == TRUE) {
        //Creo un centro messaggi
        NSNotificationCenter *selCenter = [NSNotificationCenter defaultCenter];
        NSNotification *playNote = [NSNotification notificationWithName:@"Midi_Note_Off" object:self userInfo:nil];
        [selCenter postNotification:playNote];
        //Crea un messaggio per tutte le classi in ascolto che avvisa del play della nota
        NSDictionary *playChordD = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:dominantePlayArray, nil] forKeys:[[NSArray alloc] initWithObjects:@"Note_Chord", nil]];
        NSDictionary *playChordT = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:tonicaPlayArray, nil] forKeys:[[NSArray alloc] initWithObjects:@"Note_Chord", nil]];
        //NSNotification *playNote = [NSNotification notificationWithName:@"Midi_Note" object:self userInfo:playData];
        NSNotification *playNotesD = [NSNotification notificationWithName:@"Midi_Chord" object:self userInfo:playChordD];
        NSNotification *playNotesT = [NSNotification notificationWithName:@"Midi_Chord" object:self userInfo:playChordT];
        //Faccio suonare la dominante
        [selCenter postNotification:playNotesD];
        //Lascio suonare la dominante per 1 sec
        usleep(1 * 1000 * 1000);
        //Fermo il suono
        [selCenter postNotification:playNote];
        //Suono la Tonica
        [selCenter postNotification:playNotesT];
        //Release
        [playNote release];
        [playNotesT release];
        [playChordT release];
        [playNotesD release];
        [playChordD release];
    }
}
@end

@implementation Controller (LilyPondExport)
-(IBAction) export_LilyPond_Files:(id)sender {
    NSError *err;
    NSSavePanel *savePanel = [[NSSavePanel alloc] init];
    //[savePanel setRequiredFileType:@"ly"];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"ly", nil]];
    [savePanel setCanSelectHiddenExtension:TRUE];
    [savePanel setExtensionHidden:TRUE];
    //Mostra il pannello
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
    [savePanel setNameFieldStringValue:@""];
    NSInteger runResult = [savePanel runModal];
    if (runResult == NSFileHandlingPanelOKButton) {
        BOOL saveOp = [lilyData writeToFile:[[savePanel URL] path] atomically:NO encoding:NSMacOSRomanStringEncoding error:&err];
        if ( saveOp == NO) {//Alt. NSUnicodeStringEncoding
            NSAlert *alert = [NSAlert alertWithError:err];
            [alert runModal];
        }
        else {
            if ([[NSWorkspace sharedWorkspace] launchApplication:@"LilyPond"] == YES) 
                [[NSWorkspace sharedWorkspace] openFile:[[savePanel URL] path]];
            else {
                NSString *str16 = NSLocalizedStringFromTable(@"str.16", @"InfoPlist", @"");
                NSString *str17 = NSLocalizedStringFromTable(@"str.17",  @"InfoPlist", @"");
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:str16];
                [alert setInformativeText:str17];
                [alert setAlertStyle:NSCriticalAlertStyle];
                [alert runModal];
                [alert release];
                [str16 release];
            }
             
        }
    }
}
@end

@implementation Controller (Destructors)
-(void) dealloc {
	if (dominantePlayArray)
        [dominantePlayArray release];
    if (tonicaPlayArray)
        [tonicaPlayArray release];
    if (result)
		[result release];
	if (mtrxD)
		[mtrxD release];
	if (mtrxT)
		[mtrxT release];
	if (sopranoTonalD)
		[sopranoTonalD release];
	if (altoTonalD)
		[altoTonalD release];
	if (tenoreTonalD)
		[tenoreTonalD release];
	if (bassoTonalD)
		[bassoTonalD release];
	if (sopranoTonalT)
		[sopranoTonalT release];
	if (altoTonalT)
		[altoTonalT release];
	if (tenoreTonalT)
		[tenoreTonalT release];
	if (bassoTonalT)
		[bassoTonalT release];
	if (sopranoObj)
		[sopranoObj release];
	if (altoObj)
		[altoObj release];
	if (tenoreObj)
		[tenoreObj release];
	if (bassoObj)
		[bassoObj release];
	if (harmonyT)
		[harmonyT release];
	if (harmonyD)
		[harmonyD release];
	if (tonicaT)
		[tonicaT release];
	if (terzaT)
		[terzaT release];
	if (quintaT)
		[quintaT release];
	if (tonicaD)
		[tonicaD release];
	if (terzaD)
		[terzaD release];
	if (quintaD)
		[quintaD release];
	if (sistemaTemperato)
		[sistemaTemperato release];
	if (bach)
		[bach release];	
	[super dealloc];
}
@end