//
//  TPPopoverWindow.h
//  TPPopover
//
//  Created by Frank LeGrand on 4/9/13.
//  Copyright (c) 2013 TestPlant. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TPPopover.h"

@class TPPopoverWindowFrame;

// ========================================
// NSWindow subclass implementing a popover window
// ========================================
@interface TPPopoverWindow : NSWindow
{
	NSView * _popoverContentView;
}

// ========================================
// Popover window properties
- (NSView *) popoverContentView;
- (void) setPopoverContentView: (NSView *)popoverContentView;

- (SFBPopoverPosition) popoverPosition;
- (void) setPopoverPosition:(SFBPopoverPosition)popoverPosition;

- (CGFloat) distance;
- (void) setDistance:(CGFloat)distance;

- (NSColor *) borderColor;
- (void) setBorderColor:(NSColor *)borderColor;
- (CGFloat) borderWidth;
- (void) setBorderWidth:(CGFloat)borderWidth;
- (CGFloat) cornerRadius;
- (void) setCornerRadius:(CGFloat)cornerRadius;

- (BOOL) drawsArrow;
- (void) setDrawsArrow:(BOOL)drawsArrow;
- (CGFloat) arrowWidth;
- (void) setArrowWidth:(CGFloat)arrowWidth;
- (CGFloat) arrowHeight;
- (void) setArrowHeight:(CGFloat)arrowHeight;
- (BOOL) drawRoundCornerBesideArrow;
- (void) setDrawRoundCornerBesideArrow:(BOOL)drawRoundCornerBesideArrow;

- (CGFloat) viewMargin;
- (void) setViewMargin:(CGFloat)viewMargin;
- (NSColor *) popoverBackgroundColor;
- (void) setPopoverBackgroundColor:(NSColor *)backgroundColor;

- (BOOL) isMovable;
- (void) setMovable:(BOOL)movable;

- (BOOL) isResizable;
- (void) setResizable:(BOOL)resizable;



- (TPPopoverWindowFrame *) popoverWindowFrame;

@end
