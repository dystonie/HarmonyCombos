/*
 *  GlobalVariables.h
 *  NoteGrid
 *
 *  Created by Guido Ronchetti on 2/1/11.
 *  Copyright 2011 Dysto Productions. All rights reserved.
 *
 */

//Definizione funzionamento
#define NUM_VOICES 4

//Limiti delle note musicali in numeri MIDI
#define MAX_MIDI_NOTE 108
#define MIN_MIDI_NOTE 21
#define NUM_NOTES 87
#define OCTAVE_GAP 12

//Limiti di estensione delle varie voci
#define BASS_MIN  40
#define BASS_MAX  60

#define TENO_MIN  48
#define TENO_MAX  69

#define ALTO_MIN  55
#define ALTO_MAX  74

#define SOPR_MIN  60
#define SOPR_MAX  81

//Numero Voci
#define VOX_B 0
#define VOX_T 1
#define VOX_A 2
#define VOX_S 3

//Numero delle tonalita
#define TON_A  0
#define TON_Ad 1
#define TON_Bb 1
#define TON_B  2
#define TON_C  3
#define TON_Cd 4
#define TON_Db 4
#define TON_D  5
#define TON_Dd 6
#define TON_Eb 6
#define TON_E  7
#define TON_F  8
#define TON_Fd 9
#define TON_Gb 9
#define TON_G  10
#define TON_Gd 11
#define TON_Ab 11

//Definizioni intervalli nell'accordo della triade:

#define INT_SECONDA_m 1
#define INT_SECONDA_M 2
#define INT_TERZA_m 3
#define INT_TERZA_M  4
#define INT_QUARTA_G 5
#define INT_QUARTA_A 6
#define INT_QUINTA_G 7
#define INT_SESTA_m 8
#define INT_SESTA_M 9
#define INT_SETTIMA_m 10
#define INT_SETTIMA_M 11
#define INT_OTTAVA 12

//Definizione numero di terze e quinte accettate:

#define N_MAX_TERZE_ACC_T 1
#define N_MAX_TERZE_ACC_D 1
#define N_MAX_QUINTE_ACC_T 1
#define N_MAX_QUINTE_ACC_D 1

//Definizione confizioni di incrocio delle parti
//due parti possono finire sulla stessa nota 01 TRUE, 00 FALSE

#define CAN_BE_THE_SAME 1

//Definizione string nome voci e gradi

#define BASSO "basso"
#define TENORE  "tenore"
#define ALTO "alto"
#define SOPRANO "soprano"

#define TONICA "tonica"
#define TERZA "terza"
#define QUINTA "quinta"

//Definizion distanza massima possibile tra due note successive nella stessa voce
#define SALTO_MAX INT_SESTA_m //Accetto al massimo la sesta minore

//Definizione intervalli parti larghe o strette
#define PARTI_MIN INT_QUINTA_G
#define PARTI_MAX INT_OTTAVA//INT_SESTA_m

//Definizione distanza Clausola Cantizans Soprano
#define DISTANZA_CANTIZANS -1

//Macro di accesso a stringhe localizzate
#define GET_STR(x) NSLocalizedStringFromTable(x, @"AppStrings", @"")

//Entrambe devono essere dello stesso tipo:
#define HAS_TO_BE_BOTH_PARTS_OPEN_OR_CLOSED
