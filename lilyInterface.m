//
//  lilyInterface.m
//  Harmony Combos
//
//  Created by Guido Ronchetti on 4/7/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "lilyInterface.h"
//Stampa testo parti
//#define TESTO_PARTI

@implementation lilyInterface

@synthesize arrayVoicingLabels;

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exportNotes:) name:@"Export_Notes" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTonalita:) name:@"Set_Tonalita" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setVoicingLabel:) name:@"Set_Voicing_Labels" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(generateLilyPondFile:) name:@"Generate_LilyPond_File" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearLilyPondBuffer:) name:@"Clear_LilyPond_Buffer" object:nil];
        bassoLabels = [[NSMutableArray alloc] initWithObjects:nil];
        tenoreLabels = [[NSMutableArray alloc] initWithObjects:nil];
        altoLabels = [[NSMutableArray alloc] initWithObjects:nil];
        sopranoLabels = [[NSMutableArray alloc] initWithObjects:nil];
        arrayVoicingLabels = [[NSMutableArray alloc] initWithObjects:nil];
        tonalita = 3;
        printableString = [NSMutableString stringWithString:@""];
    }
    return self;
}
@end

@implementation lilyInterface (Translators)
-(NSString *)translate: (NSString *)str {
    NSString *note, *alterations, *octaves;
    NSArray *alterationsLabels = [[NSArray alloc] initWithObjects:@"es",@"",@"is",nil];
    NSArray *octaveLabels = [[NSArray alloc] initWithObjects:@",,,",@",,",@",",@"",@"'",@"''",@"'''",@"''''",nil];
    note = [[str substringToIndex:1] lowercaseString];
    if ([str length] == 2) {
        alterations = [alterationsLabels objectAtIndex:1];
        int octNum = [[str substringFromIndex:1] intValue];
        octaves = [octaveLabels objectAtIndex:octNum];
        return [NSString stringWithFormat:@"%@%@%@", note, alterations, octaves];
    }
    if ([str length] == 6) {
        NSRange altRange = {1,1};
        if ([[str substringWithRange:altRange] compare:@"b"] == NSOrderedSame)
            alterations = [alterationsLabels objectAtIndex:0];
        if ([[str substringWithRange:altRange] compare:@"#"] == NSOrderedSame)
            alterations = [alterationsLabels objectAtIndex:2];
        int octNum = [[str substringFromIndex:5] intValue];
        octaves = [octaveLabels objectAtIndex:octNum];
        return [NSString stringWithFormat:@"%@%@%@", note, alterations, octaves];
    }
    else
        return [NSString stringWithFormat:@"c"];
    [alterationsLabels release];
    [octaveLabels release];
}
@end

@implementation lilyInterface (MessageResponders)
-(void) exportNotes: (NSNotification *)notification {
    //***********************************************
    //STRUTTURA PACCHETTO USERINFO
    //Deve contenere un NSDictionary contenente una nota per voce come nei chords più un NSNumber contenente
    //la tonalità con etichetta "Tonalita_Num"
    chordNotes = [notification userInfo];
    [bassoLabels addObject:[[chordNotes objectForKey:[NSString stringWithUTF8String:BASSO]] getNoteName]];
    [tenoreLabels addObject:[[chordNotes objectForKey:[NSString stringWithUTF8String:TENORE]] getNoteName]];
    [altoLabels addObject:[[chordNotes objectForKey:[NSString stringWithUTF8String:ALTO]] getNoteName]];
    [sopranoLabels addObject:[[chordNotes objectForKey:[NSString stringWithUTF8String:SOPRANO]] getNoteName]];
}

-(void) setTonalita: (NSNotification *)notification {
    tonalita = [[[notification userInfo] objectForKey:@"Tonalita_Num"] intValue];      
}

-(void) setVoicingLabel: (NSNotification *)notification {
    id currentMsg = [[notification userInfo] objectForKey:@"Current_Label"];
    if ([currentMsg isKindOfClass:[NSString class]] == YES) {
        [arrayVoicingLabels addObject:[currentMsg copy]];
    }
    //Releasing
    [currentMsg release];
    currentMsg = nil;
    [notification release];
    notification = nil;
}

-(void) generateLilyPondFile: (NSNotification *)notification {
    //Creazione di una stringa contenente tutte le informazioni
    NSArray *tonalitaLabels = [[NSArray alloc] initWithObjects:@"a",@"ais",@"b",@"c",@"cis",@"d",@"dis",@"e",@"f",@"fis",@"g",@"gis",nil];
    NSString *tonalitaLabel;
    for (int i=0; i<12; i++) {
        if (tonalita == i)
            tonalitaLabel = [tonalitaLabels objectAtIndex:i];
    }
    //HEADER
    NSString *title = [NSString stringWithString:NSLocalizedStringFromTable(@"str.14", @"InfoPlist", @"")];
    NSString *subtitle = [NSString stringWithString:NSLocalizedStringFromTable(@"str.15", @"InfoPlist", @"")];    
    NSString *header = [NSString stringWithFormat:NSLocalizedStringFromTable(@"header", @"LilypondStrings", @""), title, subtitle];
    //Aggiungo a file
    [printableString appendString:header];
    //VERSION
    NSString *version = [NSString stringWithFormat:NSLocalizedStringFromTable(@"version", @"LilypondStrings", @"")];
    //Aggiungo a file
    [printableString appendString:version];
    //GLOBAL
    NSString *global = [NSString stringWithFormat:NSLocalizedStringFromTable (@"global", @"LilypondStrings", @""), tonalitaLabel]; 
    //Aggiungo a file
    [printableString appendString:global];
    //VOICEMUSIC
    //***********************************************
    //soprano
    NSMutableString *sopranoLily = [[NSMutableString alloc] initWithString:@""];
    int barCounterS = 0;
    for (int i=0; i<[sopranoLabels count]; i++) {
        //Steam Off
        [sopranoLily appendString:NSLocalizedStringFromTable(@"steamOff", @"LilypondStrings", @"")];
        //
        [sopranoLily appendString:[self translate:[sopranoLabels objectAtIndex:i]]];
        [sopranoLily appendString:NSLocalizedStringFromTable(@"durata", @"LilypondStrings", @"")];
        [sopranoLily appendString:@" "];
        barCounterS ++;
        if (barCounterS == 2)
            [sopranoLily appendString:NSLocalizedStringFromTable(@"doubleBar", @"LilypondStrings", @"")];
        if (barCounterS > 2)
            barCounterS = 1;
    }
    NSString *voiceMusicSoprano = [NSString stringWithFormat:NSLocalizedStringFromTable(@"voiceMusic", @"LilypondStrings", @""), 
                                  [NSString stringWithUTF8String:SOPRANO], sopranoLily];
    //Aggiungo a file
    [printableString appendString:voiceMusicSoprano];
    //***********************************************
    //Alto
    NSMutableString *altoLily = [[NSMutableString alloc] initWithString:@""];
    int barCounterA = 0;
    for (int i=0; i<[altoLabels count]; i++) {
        //Steam Off
        [altoLily appendString:NSLocalizedStringFromTable(@"steamOff", @"LilypondStrings", @"")];
        //
        [altoLily appendString:[self translate:[altoLabels objectAtIndex:i]]];
        [altoLily appendString:NSLocalizedStringFromTable(@"durata", @"LilypondStrings", @"")];
        [altoLily appendString:@" "];
        barCounterA ++;
        if (barCounterA == 2)
            [altoLily appendString:NSLocalizedStringFromTable(@"doubleBar", @"LilypondStrings", @"")];
        if (barCounterA > 2)
            barCounterA = 1;
    }
    NSString *voiceMusicAlto = [NSString stringWithFormat:NSLocalizedStringFromTable(@"voiceMusic", @"LilypondStrings", @""), 
                                 [NSString stringWithUTF8String:ALTO], altoLily];
    //Aggiungo a file
    [printableString appendString:voiceMusicAlto];
    //***********************************************
    //tenore
    NSMutableString *tenoreLily = [[NSMutableString alloc] initWithString:@""];
    int barCounterT = 0;
    for (int i=0; i<[tenoreLabels count]; i++) {
        //Steam Off
        [tenoreLily appendString:NSLocalizedStringFromTable(@"steamOff", @"LilypondStrings", @"")];
        //
        [tenoreLily appendString:[self translate:[tenoreLabels objectAtIndex:i]]];
        [tenoreLily appendString:NSLocalizedStringFromTable(@"durata", @"LilypondStrings", @"")];
        [tenoreLily appendString:@" "];
        barCounterT ++;
        if (barCounterT == 2)
            [tenoreLily appendString:NSLocalizedStringFromTable(@"doubleBar", @"LilypondStrings", @"")];
        if (barCounterT > 2)
            barCounterT = 1;
    }
    NSString *voiceMusicTenore = [NSString stringWithFormat:NSLocalizedStringFromTable(@"voiceMusic", @"LilypondStrings", @""), 
                                 [NSString stringWithUTF8String:TENORE], tenoreLily];
    //Aggiungo a file
    [printableString appendString:voiceMusicTenore];
    //***********************************************
    //Basso
    NSMutableString *bassoLily = [[NSMutableString alloc] initWithString:@""];
    int barCounterB = 0;
    for (int i=0; i<[bassoLabels count]; i++) {
        //Steam Off
        [bassoLily appendString:NSLocalizedStringFromTable(@"steamOff", @"LilypondStrings", @"")];
        //
        [bassoLily appendString:[self translate:[bassoLabels objectAtIndex:i]]];
        [bassoLily appendString:NSLocalizedStringFromTable(@"durata", @"LilypondStrings", @"")];
        [bassoLily appendString:@" "];
        barCounterB ++;
        if (barCounterB == 2)
            [bassoLily appendString:NSLocalizedStringFromTable(@"doubleBar", @"LilypondStrings", @"")];
        if (barCounterB > 2)
            barCounterB = 1;
    }
    NSString *voiceMusicBasso = [NSString stringWithFormat:NSLocalizedStringFromTable(@"voiceMusic", @"LilypondStrings", @""), 
                                 [NSString stringWithUTF8String:BASSO], bassoLily];
    //Aggiungo a file
    [printableString appendString:voiceMusicBasso];
    //**********************************************
    //Testo da inserire
#ifdef TESTO_PARTI
    NSMutableString *lyrics = [NSMutableString string];
    int barCounterLirics = 0;
    for (int i=0; i<[arrayVoicingLabels count]; i++) {
        [lyrics appendFormat:@"\"%@\"", [arrayVoicingLabels objectAtIndex:i]];
        [lyrics appendString:NSLocalizedStringFromTable(@"durata", @"LilypondStrings", @"")];
        [lyrics appendString:@" "];
        barCounterLirics++;
        if (barCounterLirics == 2)
            [lyrics appendString:NSLocalizedStringFromTable(@"lyricsString", @"LilypondStrings", @"")];
        if (barCounterLirics > 2)
            barCounterLirics = 1;
    }
    NSString *lyricsTestoField = [NSString stringWithFormat:NSLocalizedStringFromTable(@"testoField", @"LilypondStrings", @""),
                                  lyrics];
    //Aggiungo a file
    [printableString appendString:lyricsTestoField];
#endif
    //***********************************************
    //NEWVOICE
    NSString *newVoiceSoprano = [NSString stringWithFormat:NSLocalizedStringFromTable(@"newVoice", @"LilypondStrings", @""),
                                 [NSString stringWithUTF8String:SOPRANO], @"voiceOne", [NSString stringWithUTF8String:SOPRANO]];
    NSString *newVoiceAlto = [NSString stringWithFormat:NSLocalizedStringFromTable(@"newVoice", @"LilypondStrings", @""),
                                 [NSString stringWithUTF8String:ALTO], @"voiceTwo",[NSString stringWithUTF8String:ALTO]];
    NSString *newVoiceTenore = [NSString stringWithFormat:NSLocalizedStringFromTable(@"newVoice", @"LilypondStrings", @""),
                                 [NSString stringWithUTF8String:TENORE], @"voiceOne", [NSString stringWithUTF8String:TENORE]];
    NSString *newVoiceBasso = [NSString stringWithFormat:NSLocalizedStringFromTable(@"newVoice", @"LilypondStrings", @""),
                                 [NSString stringWithUTF8String:BASSO], @"voiceTwo", [NSString stringWithUTF8String:BASSO]];
    //***********************************************
    //SCORE
    NSString *womenStr = [NSString stringWithFormat:@"%@%@", newVoiceSoprano, newVoiceAlto];
    NSString *menStr = [NSString stringWithFormat:@"%@%@", newVoiceTenore, newVoiceBasso];
    //Aggiungo a file
#ifdef TESTO_PARTI
    [printableString appendFormat:NSLocalizedStringFromTable(@"scoreWithText", @"LilypondStrings", @""), womenStr, menStr];
#endif
#ifndef TESTO_PARTI
    [printableString appendFormat:NSLocalizedStringFromTable(@"score", @"LilypondStrings", @""), womenStr, menStr];
#endif
    NSDictionary *lilyData = [NSDictionary dictionaryWithObject:printableString forKey:@"LilyPound_Data"];
    NSNotificationCenter *selCenter = [NSNotificationCenter defaultCenter];
    NSNotification *returnLily = [NSNotification notificationWithName:@"Return_LilyPound_Data" object:self userInfo:lilyData];
    [selCenter postNotification:returnLily];
    //Release
    [lilyData release];
    [returnLily release];
    [selCenter release];
    [womenStr release];
    [menStr release];
    [voiceMusicAlto release];
    [voiceMusicBasso release];
    [voiceMusicSoprano release];
    [voiceMusicTenore release];
#ifdef TESTO_PARTI
    [lyrics release];
    [lyricsTestoField release];
#endif
    [global release];
    [title release];
    [subtitle release];
    [header release];
    [version release];
}

-(void) clearLilyPondBuffer: (NSNotification *)notification {
    [bassoLabels removeAllObjects];
    [tenoreLabels removeAllObjects];
    [altoLabels removeAllObjects];
    [sopranoLabels removeAllObjects];
    [printableString release];
    printableString = [NSMutableString stringWithString:@""];
}
@end

@implementation lilyInterface (Destructors)
- (void)dealloc
{
    [bassoLabels release];
    [tenoreLabels release];
    [sopranoLabels release];
    [altoLabels release];
    [printableString release];
    [super dealloc];
}
@end
