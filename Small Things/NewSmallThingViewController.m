//
//  NewSmallThingViewController.m
//  Small Things
//
//  Created by Leonardo S Rangel on 7/16/15.
//  Copyright © 2015 Leonardo S Rangel. All rights reserved.
//

#import "SmallThing+CoreDataProperties.h"
#import "Person+CoreDataProperties.h"
#import "NewSmallThingViewController.h"
#import "NSTTextViewController.h"
#import "FPPopoverController.h"
#import "FPTouchView.h"
#import "ARCMacros.h"
#import <AVFoundation/AVFoundation.h>

@interface NewSmallThingViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong,nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UITextField *titleEditText;
@property (weak, nonatomic) IBOutlet UITextField *personEditText;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) NSURL *audioOutput;

@end

@implementation NewSmallThingViewController
@synthesize recorder;
@synthesize player;
@synthesize recordButton;
@synthesize textButton;
@synthesize stopButton;
@synthesize playButton;
@synthesize audioOutput;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    audioOutput = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:audioOutput settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)textThing:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    NSTTextViewController *nst = [storyboard instantiateViewControllerWithIdentifier:@"NSTTextView"];
    nst.title = nil;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:nst];
    
    popover.contentSize = CGSizeMake(350, 450);
    popover.border = NO;
    popover.border = FPPopoverWhiteTint;
    popover.arrowDirection = FPPopoverArrowDirectionDown;
    popover.tint = FPPopoverWhiteTint;
    [popover presentPopoverFromView:sender];
}

- (IBAction)recordThing:(UIButton *)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        
        stopButton.alpha = 0;
        stopButton.hidden = NO;
        [UIView animateWithDuration:1 animations:^{
            stopButton.alpha = 1;
        }];
        
        playButton.alpha = 0;
        playButton.hidden = NO;
        [UIView animateWithDuration:1 animations:^{
            playButton.alpha = 1;
        }];
        
        //[recordButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [recorder pause];
        //[recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}

- (IBAction)stopTapped:(UIButton *)sender {
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped:(UIButton *)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    //[recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
}

//Não é responsabilidade do ViewController salvar objetos no banco de dados. Faça isso em uma classe separada.
- (IBAction)saveST:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //Create a new managed object
    //O ideal é usar a classe persistente em vez de NSManagedObject
    NSManagedObject *newSmallThing = [NSEntityDescription insertNewObjectForEntityForName:@"SmallThing" inManagedObjectContext:context];
    [newSmallThing setValue:self.titleEditText.text forKey:@"title"];
    
    //Precisei fazer esse ajuste para compatibilizar com o iOS 8
    [newSmallThing setValue:[NSData dataWithContentsOfURL:self.audioOutput] forKey:@"smallaudio"];
    
    //O ideal é usar a classe persistente em vez de NSManagedObject
    NSManagedObject *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    [newPerson setValue:self.personEditText.text forKey:@"name"];
    [newPerson setValue:newSmallThing forKey:@"smallthing"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else {
        /** Seu botão 'Save' estava com duas ações. Isso não funciona.
         Só a primeira ação vai ser capturada - que no caso era um unwindSegue.
         Retirei a ação do unwind para que este mecanismo de salvar funcionasse.
         A segue de volta só é feita em caso de sucesso, na linha abaixo.
         Precisei mapeá-la no Storyboard com o identificador abaixo.
         **/
        [self performSegueWithIdentifier:@"unwindToSTVC-Segue" sender:nil];
    }
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
