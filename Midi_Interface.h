//
//  Midi_Interface.h
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/27/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Midi_Interface : NSObject {
@private
    //Dizionario passato 
    NSDictionary *midiNotes;
    //Audio Units Graph metodi
    AUGraph myGraph;
    AudioUnit synthUnit;
    // Alcune costanti MIDI
    enum {
        kMidiMessage_ControlChange 		= 0xB,
        kMidiMessage_ProgramChange 		= 0xC,
        kMidiMessage_BankMSBControl 	= 0,
        kMidiMessage_BankLSBControl		= 32,
        kMidiMessage_NoteOn 			= 0x9
    };
}
-(id) init;
@end

@interface Midi_Interface (AUGraph)
-(void)initAUGraph;
-(void)playMidiNotes: (int) notes;
@end

@interface Midi_Interface (MessageResponders)
-(void) playMidiNote: (NSNotification *)notification;
-(void) stopMidiNotes: (NSNotification *)notification;
-(void) playMidiChord: (NSNotification *)notification;
@end

@interface Midi_Interface (Destructors)
-(void) dealloc;
@end