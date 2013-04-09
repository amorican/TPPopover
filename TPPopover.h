//
//  TPPopover.h
//  TPPopover
//
//  Created by Frank LeGrand on 4/9/13.
//  Copyright (c) 2013 TestPlant. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TPPopoverWindow;


enum platformType{
	MacOSX = 1,
	LINUX = 2,
	Linux = 2,
	Windows = 3
};

#ifdef __MINGW32__
#define ApplicationPlatform ((enum platformType) Windows)
#elif GNUSTEP
#define ApplicationPlatform ((enum platformType) LINUX)
#else
#define ApplicationPlatform ((enum platformType) MacOSX)
#endif


// ========================================
// Positioning constants
// ========================================
enum SFBPopoverPosition {
	SFBPopoverPositionLeft          = NSMinXEdge,
	SFBPopoverPositionRight         = NSMaxXEdge,
	SFBPopoverPositionTop           = NSMaxYEdge,
	SFBPopoverPositionBottom        = NSMinYEdge,
	SFBPopoverPositionLeftTop       = 4,
	SFBPopoverPositionLeftBottom    = 5,
	SFBPopoverPositionRightTop      = 6,
	SFBPopoverPositionRightBottom   = 7,
	SFBPopoverPositionTopLeft       = 8,
	SFBPopoverPositionTopRight      = 9,
	SFBPopoverPositionBottomLeft    = 10,
	SFBPopoverPositionBottomRight   = 11
};
typedef enum SFBPopoverPosition SFBPopoverPosition;

// ========================================
// A class that controls display of a popover
// ========================================
@interface TPPopover : NSResponder
{
    BOOL _animates;
    BOOL _closesWhenPopoverResignsKey;
    BOOL _closesWhenApplicationBecomesInactive;

	NSViewController * _contentViewController;
	TPPopoverWindow * _popoverWindow;
}


// ========================================
// Creation
- (id) initWithContentView:(NSView *)contentView;
- (id) initWithContentViewController:(NSViewController *)contentViewController;

// ========================================
// Geometry determination
- (SFBPopoverPosition) bestPositionInWindow:(NSWindow *)window atPoint:(NSPoint)point;

// ========================================
// Show the popover- prefer these to showWindow:
- (void) displayPopoverInWindow:(NSWindow *)window atPoint:(NSPoint)point;
- (void) displayPopoverInWindow:(NSWindow *)window atPoint:(NSPoint)point chooseBestLocation:(BOOL)chooseBestLocation;

// ========================================
// Move the popover to a new attachment point (should be currently displayed)
- (void) movePopoverToPoint:(NSPoint)point;

// ========================================
// Close the popover
- (IBAction) closePopover:(id)sender;

// ========================================
// Returns the popover window
- (NSWindow *) popoverWindow;

// ========================================
// Returns YES if the popover is visible
- (BOOL) isVisible;

// ========================================
// Popover window properties

- (NSViewController *) contentViewController;
- (void) setContentViewController:(NSViewController *)contentViewController;

// The popover's position relative to its attachment point
- (SFBPopoverPosition) position;
- (void) setPosition:(SFBPopoverPosition)position;

// The distance between the attachment point and the popover window
- (CGFloat) distance;
- (void) setDistance:(CGFloat)distance;

// The popover's border color
- (NSColor *) borderColor;
- (void) setBorderColor:(NSColor *)borderColor;

// The width of the popover window's border
- (CGFloat) borderWidth;
- (void) setBorderWidth:(CGFloat)borderWidth;

// The radius of the popover window's border
- (CGFloat) cornerRadius;
- (void) setCornerRadius:(CGFloat)cornerRadius;

// Specifies if the popover window has an arrow pointing toward the attachment point
- (BOOL) drawsArrow;
- (void) setDrawsArrow:(BOOL)drawsArrow;

// The width of the arrow, if applicable
- (CGFloat) arrowWidth;
- (void) setArrowWidth:(CGFloat)arrowWidth;

// The height of the arrow, if applicable
- (CGFloat) arrowHeight;
- (void) setArrowHeight:(CGFloat)arrowHeight;

// If the arrow is drawn by a corner of the window, specifies whether that corner should be rounded
- (BOOL) drawRoundCornerBesideArrow;
- (void) setDrawRoundCornerBesideArrow:(BOOL)drawRoundCornerBesideArrow;

// The spacing between the edge of the popover's content view and its border
- (CGFloat) viewMargin;
- (void) setViewMargin:(CGFloat)viewMargin;

// The popover's background color
- (NSColor *) backgroundColor;
- (void) setBackgroundColor:(NSColor *)backgroundColor;

// Specifies whether the popover may be moved by dragging
- (BOOL) isMovable;
- (void) setMovable:(BOOL)movable;

// Specifies whether the popover may be resized
- (BOOL) isResizable;
- (void) setResizable:(BOOL)resizable;

@end
