//
//  TPPopoverTestHarnessAppDelegate.h
//  TPPopover
//
//  Created by Frank LeGrand on 4/9/13.
//  Copyright (c) 2013 TestPlant. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TPPopover.h"

@interface TPPopoverTestHarnessAppDelegate : NSObject
{
    IBOutlet NSPopUpButton *positionPopup;
    IBOutlet NSColorWell *borderColorWell;
    IBOutlet NSColorWell *backgroundColorWell;
    IBOutlet NSSlider *viewMarginSlider;
    IBOutlet NSSlider *borderWidthSlider;
    IBOutlet NSSlider *cornerRadiusSlider;
    IBOutlet NSButton *hasArrowCheckbox;
    IBOutlet NSButton *drawRoundCornerBesideArrowCheckbox;
    IBOutlet NSButton *movableCheckbox;
    IBOutlet NSSlider *arrowWidthSlider;
    IBOutlet NSSlider *arrowHeightSlider;
    IBOutlet NSSlider *distanceSlider;
    IBOutlet NSButton *toggleButton;
    
    IBOutlet NSView *popoverView;
    IBOutlet NSWindow *parametersWindow;
    
    TPPopover * _popover;
}

- (IBAction) changePosition:(id)sender;
- (IBAction) changeBorderColor:(id)sender;
- (IBAction) changeBackgroundColor:(id)sender;
- (IBAction) changeViewMargin:(id)sender;
- (IBAction) changeBorderWidth:(id)sender;
- (IBAction) changeCornerRadius:(id)sender;
- (IBAction) changeHasArrow:(id)sender;
- (IBAction) changeDrawRoundCornerBesideArrow:(id)sender;
- (IBAction) changeMovable:(id)sender;
//- (IBAction) changeResizable:(id)sender;
- (IBAction) changeArrowWidth:(id)sender;
- (IBAction) changeArrowHeight:(id)sender;
- (IBAction) changeDistance:(id)sender;

- (IBAction) togglePopover:(id)sender;

@end
