//
//  TPPopoverTestHarnessAppDelegate.m
//  TPPopover
//
//  Created by Frank LeGrand on 4/9/13.
//  Copyright (c) 2013 TestPlant. All rights reserved.
//

#import "TPPopoverTestHarnessAppDelegate.h"

@implementation TPPopoverTestHarnessAppDelegate

- (void) awakeFromNib
{
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	[parametersWindow center];

	_popover = [[TPPopover alloc] initWithContentView:popoverView];

	// Set up the popover window the match the UI
//	[self changePosition:positionPopup];
//	[self changeBorderColor:borderColorWell];
//	[self changeBackgroundColor:backgroundColorWell];
//	[self changeViewMargin:viewMarginSlider];
//	[self changeBorderWidth:borderWidthSlider];
//	[self changeCornerRadius:cornerRadiusSlider];
//	[self changeHasArrow:hasArrowCheckbox];
//	[self changeDrawRoundCornerBesideArrow:drawRoundCornerBesideArrowCheckbox];
//	[self changeMovable:movableCheckbox];
////	[self changeResizable:resizableCheckbox];
//	[self changeArrowWidth:arrowWidthSlider];
//	[self changeArrowHeight:arrowHeightSlider];
//	[self changeDistance:distanceSlider];

//    [_popover setBorderColor:[NSColor blueColor]];
//    [_popover setBackgroundColor:[NSColor orangeColor]];
}

- (IBAction) changePosition:(id)sender
{
	NSInteger position = [sender indexOfSelectedItem];
	if(12 == position) {
		NSPoint where = [toggleButton frame].origin;
		where.x += [toggleButton frame].size.width / 2;
		where.y += [toggleButton frame].size.height / 2;
		position = [_popover bestPositionInWindow:[toggleButton window] atPoint:where];
	}

	[_popover setPosition:(SFBPopoverPosition)position];
}

- (IBAction) changeBorderColor:(id)sender
{
	[_popover setBorderColor:[sender color]];
}

- (IBAction) changeBackgroundColor:(id)sender
{
	[_popover setBackgroundColor:[sender color]];
}

- (IBAction) changeViewMargin:(id)sender
{
	[_popover setViewMargin:floorf([sender floatValue])];
}

- (IBAction) changeBorderWidth:(id)sender
{
	[_popover setBorderWidth:floorf([sender floatValue])];
}

- (IBAction) changeCornerRadius:(id)sender
{
	[_popover setCornerRadius:floorf([sender floatValue])];
}

- (IBAction) changeHasArrow:(id)sender
{
	[_popover setDrawsArrow:(NSOnState == [sender state])];
}

- (IBAction) changeDrawRoundCornerBesideArrow:(id)sender
{
	[_popover setDrawRoundCornerBesideArrow:(NSOnState == [sender state])];
}

- (IBAction) changeMovable:(id)sender
{
	[_popover setMovable:(NSOnState == [sender state])];
}

//- (IBAction) changeResizable:(id)sender
//{
//	[_popover setResizable:(NSOnState == [sender state])];
//}

- (IBAction) changeArrowWidth:(id)sender
{
	[_popover setArrowWidth:floorf([sender floatValue])];
}

- (IBAction) changeArrowHeight:(id)sender
{
	[_popover setArrowHeight:floorf([sender floatValue])];
}

- (IBAction) changeDistance:(id)sender
{
	[_popover setDistance:floorf([sender floatValue])];
}

- (IBAction) togglePopover:(id)sender
{
	if([_popover isVisible])
		[_popover closePopover:sender];
	else {
		NSPoint where = [toggleButton frame].origin;
		where.x += [toggleButton frame].size.width / 2;
		where.y += [toggleButton frame].size.height / 2;

		[_popover displayPopoverInWindow:[toggleButton window] atPoint:where];
	}
}

- (void) windowDidResize:(NSNotification *)notification
{
	if([_popover isVisible]) {
		NSPoint where = [toggleButton frame].origin;
		where.x += [toggleButton frame].size.width / 2;
		where.y += [toggleButton frame].size.height / 2;

		[_popover movePopoverToPoint:where];
    }
}

@end
