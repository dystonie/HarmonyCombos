//
//  Midi_Interface.m
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/27/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Midi_Interface.h"

@implementation Midi_Interface
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMidiNote:) name:@"Midi_Note" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMidiNotes:) name:@"Midi_Note_Off" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMidiChord:) name:@"Midi_Chord" object:nil];
        [self initAUGraph];
    }
    
    return self;
}
@end

@implementation Midi_Interface (AUGraph)
- (void)initAUGraph {
    //************************************************
    //Definizione variabili
    OSErr err = noErr; //variabile di gestione errori
    //Nodi Utilizzati
    AUNode synthNode;
    AUNode limitNode;
    AUNode outNode;
    AudioComponentDescription cd;
    //Creo un AUGraph verificando eventuali errori
    err = NewAUGraph(&myGraph);
    NSAssert(err == noErr, @"NewAUGraph failed.");
    
    //CREO I COMPONENTI DA UTILIZZARE
    //Specifico il tipo di Audio Unit dello stadio di output
    cd.componentType = kAudioUnitType_Output;
    cd.componentSubType = kAudioUnitSubType_DefaultOutput;
    //Uso Apple come component manufacture
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0; 
    //Aggiungo il nodo dello stadio di output
    err = AUGraphAddNode(myGraph, &cd, &outNode);
    NSAssert(err == noErr, @"AUGraphNewNode for output failed.");
    //Nodo sintetizzatore
    cd.componentType = kAudioUnitType_MusicDevice;
    cd.componentSubType = kAudioUnitSubType_DLSSynth;
    //Aggiungo il nodo 
    err = AUGraphAddNode(myGraph, &cd, &synthNode);
    NSAssert(err == noErr, @"AUGraphNewNode for synth failed.");
    //Nodo Limiter
    cd.componentType = kAudioUnitType_Effect;
    cd.componentSubType = kAudioUnitSubType_PeakLimiter;
    //Aggiungo il nodo
    err = AUGraphAddNode(myGraph, &cd, &limitNode);
    NSAssert(err == noErr, @"AUGraphNewNode for limiter failed.");
    
    //REALIZZO LE CONNESSIONI TRA I NODI
    //Connetto il synth al limiter
    err = AUGraphConnectNodeInput(myGraph, synthNode, 0, limitNode, 0);
    NSAssert(err == noErr, @"AUGraphConnectNode synth -> limit failed.");
    //Connetto il limiter all'output
    err = AUGraphConnectNodeInput(myGraph, limitNode, 0, outNode, 0);
    NSAssert(err == noErr, @"AUGraphConnectNode limit -> out failed.");
    //Apro il Graph
    err = AUGraphOpen(myGraph);
    NSAssert(err == noErr, @"AUGraphOpen failed.");
    
    //FINALIZZO
    //Genero un riferimento ai nodi appena creati
    err = AUGraphNodeInfo(myGraph, synthNode, 0, &synthUnit);
    NSAssert(err == noErr, @"AUGraphGetNodeInfo for outUnit failed.");
    //************************************************
}

- (void)playMidiNotes: (int) notes {
    //************************************************
    //Definisco variabili
    OSErr err = noErr; //variabile di gestione errori
    //Canale midi in uso
    UInt8 midiChannelInUse = 0;
    //La bank midi usata
    char* bankPath = 0;
    //Creazione dei riferimenti
    if (bankPath) {
		FSRef fsRef;
		err = FSPathMakeRef ((const UInt8*)bankPath, &fsRef, 0);
        NSAssert(err == noErr, @"FSPathMakeRef failed.");
		err = AudioUnitSetProperty (synthUnit, kMusicDeviceProperty_SoundBankFSRef,kAudioUnitScope_Global, 0, &fsRef, sizeof(fsRef));
        NSAssert(err == noErr, @"AudioUnitSetProperty failed.");        
	}
    
    //INIZIALIZZO IL GRAPH
	err = AUGraphInitialize (myGraph);
    //MIDI message per settare la mia bancata
	err = MusicDeviceMIDIEvent(synthUnit, kMidiMessage_ControlChange << 4 | midiChannelInUse, kMidiMessage_BankMSBControl, 0, 0);
    NSAssert(err == noErr, @"Error setting bank.");
    //MIDI message per settare il canale in uso
	err = MusicDeviceMIDIEvent(synthUnit, kMidiMessage_ProgramChange << 4 | midiChannelInUse, 0, 0,0);
    NSAssert(err == noErr, @"Error setting channel in use.");
    
    //START
	err = AUGraphStart (myGraph);
    NSAssert(err == noErr, @"Error starting Graph.");
    
    //************************************************
	// SUONO UNA NOTA
	UInt32 noteNum = notes;
    UInt32 onVelocity = 127;
	UInt32 noteOnCommand = 	kMidiMessage_NoteOn << 4 | midiChannelInUse;
    err = MusicDeviceMIDIEvent(synthUnit, noteOnCommand, noteNum, onVelocity, 0);
    NSAssert(err == noErr, @"Error playing notes.");
    //************************************************
}
@end

@implementation Midi_Interface (MessageResponders)
-(void) playMidiNote: (NSNotification *)notification {
    //Riceve il messaggio
    midiNotes = [notification userInfo];
    NSNumber *midiNoteMsg = [midiNotes objectForKey:@"Note_Number"];
    [self playMidiNotes:[midiNoteMsg intValue]];
}

-(void) stopMidiNotes: (NSNotification *)notification {
    if (myGraph) {
        AUGraphStop(myGraph);
        AUGraphUninitialize(myGraph);
    }
}

-(void) playMidiChord: (NSNotification *)notification {
    //Riceve il messaggio
    midiNotes = [notification userInfo];
    NSMutableArray *midiChord = [midiNotes objectForKey:@"Note_Chord"];
    for (int i=0; i<[midiChord count]; i++) {
        [self playMidiNotes:[[midiChord objectAtIndex:i] intValue]];
    }
}
@end

@implementation Midi_Interface (destructors)
- (void)dealloc
{
    /* ---- No error-checking here since there's nothing we can do about it anyway; app is closing. */
    AUGraphStop(myGraph);
    AUGraphUninitialize(myGraph);
    AUGraphClose(myGraph); 
    [midiNotes release];
    [super dealloc];
}
@end
