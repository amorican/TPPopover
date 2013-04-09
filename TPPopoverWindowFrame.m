//
//  TPPopoverWindow.m
//  TPPopover
//
//  Created by Frank LeGrand on 4/9/13.
//  Copyright (c) 2013 TestPlant. All rights reserved.
//

//#define LogRect(RECT) NSLog(@"%s: (%0.0f, %0.0f) %0.0f x %0.0f",#RECT, RECT.origin.x, RECT.origin.y, RECT.size.width, RECT.size.height)

#import "TPPopoverWindowFrame.h"

@interface TPPopoverWindowFrame (Private)
- (NSBezierPath *) popoverFramePathForContentRect:(NSRect)rect;
- (void) appendArrowToPath:(NSBezierPath *)path;
@end

@implementation TPPopoverWindowFrame

- (id) initWithFrame:(NSRect)frame
{
	if((self = [super initWithFrame:frame])) {
		// Set the default appearance
		_popoverPosition = SFBPopoverPositionBottom;

		_distance = 0;

        [self setBorderColor:[NSColor whiteColor]];
		_borderWidth = 2;
		_cornerRadius = 8;

		_drawsArrow = YES;
		_arrowWidth = 20;
		_arrowHeight = 16;
		_drawRoundCornerBesideArrow = YES;

		_viewMargin = 2;
        [self setBackgroundColor:[NSColor colorWithCalibratedWhite:(CGFloat)0.1 alpha:(CGFloat)0.9]];
		_movable = NO;
		_resizable = NO;
	}

	return self;
}

- (void) dealloc
{
    [_borderColor release];
    [_backgroundColor release];
    [super dealloc];
}

- (NSRect) frameRectForContentRect:(NSRect)contentRect
{
	NSRect frameRect = NSInsetRect(contentRect, -_viewMargin, -_viewMargin);

	CGFloat offset = _arrowHeight + _distance;
	switch(_popoverPosition) {
		case SFBPopoverPositionLeft:
		case SFBPopoverPositionLeftTop:
		case SFBPopoverPositionLeftBottom:
			frameRect.size.width += offset;
			break;

		case SFBPopoverPositionRight:
		case SFBPopoverPositionRightTop:
		case SFBPopoverPositionRightBottom:
			frameRect.size.width += offset;
			frameRect.origin.x -= offset;
			break;
			
		case SFBPopoverPositionTop:
		case SFBPopoverPositionTopLeft:
		case SFBPopoverPositionTopRight:
			frameRect.size.height += offset;
			frameRect.origin.y += offset;
			break;

		case SFBPopoverPositionBottom:
		case SFBPopoverPositionBottomLeft:
		case SFBPopoverPositionBottomRight:
			frameRect.size.height += offset;
			break;
	}

	NSRect resultRect = NSInsetRect(frameRect, -_borderWidth, -_borderWidth);
	return resultRect;
}

- (NSRect) contentRectForFrameRect:(NSRect)windowFrame
{
	NSRect contentRect = NSInsetRect(windowFrame, _borderWidth, _borderWidth);

	CGFloat offset = _arrowHeight + _distance;
	switch(_popoverPosition) {
		case SFBPopoverPositionLeft:
		case SFBPopoverPositionLeftTop:
		case SFBPopoverPositionLeftBottom:
			contentRect.size.width -= offset;
			break;

		case SFBPopoverPositionRight:
		case SFBPopoverPositionRightTop:
		case SFBPopoverPositionRightBottom:
			contentRect.size.width -= offset;
			contentRect.origin.x += offset;
			break;
			
		case SFBPopoverPositionTop:
		case SFBPopoverPositionTopLeft:
		case SFBPopoverPositionTopRight:
			contentRect.size.height -= offset;
			contentRect.origin.y += offset;
			break;

		case SFBPopoverPositionBottom:
		case SFBPopoverPositionBottomLeft:
		case SFBPopoverPositionBottomRight:
			contentRect.size.height -= offset;
			break;
	}

	NSRect resultRect = NSInsetRect(contentRect, _viewMargin, _viewMargin);
	return resultRect;
}

- (BOOL)isOpaque
{
    return NO;
}

- (NSPoint) attachmentPoint
{
	return [self attachmentPointForRect:[self bounds]];
}

- (NSPoint) attachmentPointForRect:(NSRect)rect;
{
	NSPoint arrowheadPosition = NSZeroPoint;

	CGFloat minX = NSMinX(rect);
	CGFloat midX = NSMidX(rect);
	CGFloat maxX = NSMaxX(rect);

	CGFloat minY = NSMinY(rect);
	CGFloat midY = NSMidY(rect);
	CGFloat maxY = NSMaxY(rect);

	CGFloat arrowDistance = (_arrowHeight / 2) + (2 * _borderWidth);
	if(_drawRoundCornerBesideArrow)
		arrowDistance += _cornerRadius;

	switch(_popoverPosition) {
		case SFBPopoverPositionLeft:
			arrowheadPosition = NSMakePoint(maxX, midY);
			break;

		case SFBPopoverPositionLeftTop:
			arrowheadPosition = NSMakePoint(maxX, minY + arrowDistance);
			break;

		case SFBPopoverPositionLeftBottom:
			arrowheadPosition = NSMakePoint(maxX, maxY - arrowDistance);
			break;

		case SFBPopoverPositionRight:
			arrowheadPosition = NSMakePoint(minX, midY);
			break;

		case SFBPopoverPositionRightTop:
			arrowheadPosition = NSMakePoint(minX, minY + arrowDistance);
			break;

		case SFBPopoverPositionRightBottom:
			arrowheadPosition = NSMakePoint(minX, maxY - arrowDistance);
			break;
			
		case SFBPopoverPositionTop:
			arrowheadPosition = NSMakePoint(midX, minY);
			break;

		case SFBPopoverPositionTopLeft:
			arrowheadPosition = NSMakePoint(maxX - arrowDistance, minY);
			break;

		case SFBPopoverPositionTopRight:
			arrowheadPosition = NSMakePoint(minX + arrowDistance, minY);
			break;

		case SFBPopoverPositionBottom:
			arrowheadPosition = NSMakePoint(midX, maxY);
			break;

		case SFBPopoverPositionBottomLeft:
			arrowheadPosition = NSMakePoint(maxX - arrowDistance, maxY);
			break;

		case SFBPopoverPositionBottomRight:
			arrowheadPosition = NSMakePoint(minX + arrowDistance, maxY);
			break;
	}
	
	return arrowheadPosition;
}

- (void) drawRect:(NSRect)dirtyRect
{
	[NSBezierPath clipRect:dirtyRect];

	NSRect contentRect = [self contentRectForFrameRect:[self bounds]];

	// GNUstep workaround, I can't figure out why the view bounds haven't been reset.
	NSRect windowRect = [self contentRectForFrameRect:[[self window] frame]];
    
	contentRect.size.width = windowRect.size.width;
	contentRect.size.height = windowRect.size.height;

    NSBezierPath *path = [self popoverFramePathForContentRect:contentRect];

    [_backgroundColor set];
    [path fill];
    
	[path setLineWidth:_borderWidth];
    [_borderColor set];
    [path stroke];
}

- (void) mouseDown:(NSEvent *)event
{
	NSPoint pointInView = [self convertPoint:[event locationInWindow] fromView:nil];
	NSRect contentRect = [self contentRectForFrameRect:[self bounds]];
    NSBezierPath *path = [self popoverFramePathForContentRect:contentRect];

	BOOL resize = [path containsPoint:pointInView] && !NSPointInRect(pointInView, contentRect);
	if((resize && !_resizable) || (!resize && !_movable))
		return;

	NSWindow *window = [self window];
	NSPoint originalMouseLocation = [window convertBaseToScreen:[event locationInWindow]];
	NSRect originalFrame = [window frame];
	
    for(;;) {
        NSEvent *newEvent = [window nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		
        if(NSLeftMouseUp == [newEvent type])
			break;
		
		NSPoint newMouseLocation = [window convertBaseToScreen:[newEvent locationInWindow]];
		NSPoint delta = NSMakePoint(newMouseLocation.x - originalMouseLocation.x, newMouseLocation.y - originalMouseLocation.y);
		
		NSRect newFrame = originalFrame;		
		if(!resize) {
			newFrame.origin.x += delta.x;
			newFrame.origin.y += delta.y;
		}
		else {
			newFrame.size.width += delta.x;
			newFrame.size.height -= delta.y;
			newFrame.origin.y += delta.y;
			
			NSRect newContentRect = [window contentRectForFrameRect:newFrame];

			NSSize maxSize = [window maxSize];
			NSSize minSize = [window minSize];

			if(newContentRect.size.width > maxSize.width)
				newFrame.size.width -= newContentRect.size.width - maxSize.width;
			else if(newContentRect.size.width < minSize.width)
				newFrame.size.width += minSize.width - newContentRect.size.width;

			if(newContentRect.size.height > maxSize.height) {
				newFrame.size.height -= newContentRect.size.height - maxSize.height;
				newFrame.origin.y += newContentRect.size.height - maxSize.height;
			}
			else if(newContentRect.size.height < minSize.height) {
				newFrame.size.height += minSize.height - newContentRect.size.height;
				newFrame.origin.y -= minSize.height - newContentRect.size.height;
			}
		}
		
		[window setFrame:newFrame display:YES animate:NO];
	}
}

- (SFBPopoverPosition)popoverPosition {
    return _popoverPosition;
}

- (void)setPopoverPosition:(SFBPopoverPosition)newValue {
    _popoverPosition = newValue;
}

- (CGFloat)distance {
    return _distance;
}

- (void)setDistance:(CGFloat)newValue {
    _distance = newValue;
}

- (NSColor *)borderColor {
    return _borderColor;
}

- (void)setBorderColor:(NSColor *)newValue {
    if (_borderColor != newValue)
    {
        [_borderColor release];
        _borderColor = nil;
        _borderColor = [newValue retain];
    }
}

- (CGFloat)borderWidth {
    return _borderWidth;
}

- (void)setBorderWidth:(CGFloat)newValue {
    _borderWidth = newValue;
}

- (CGFloat)cornerRadius {
    return _cornerRadius;
}

- (void)setCornerRadius:(CGFloat)newValue {
    _cornerRadius = newValue;
}

- (BOOL)drawsArrow {
    return _drawsArrow;
}

- (void)setDrawsArrow:(BOOL)newValue {
    _drawsArrow = newValue;
}

- (CGFloat)arrowWidth {
    return _arrowWidth;
}

- (void)setArrowWidth:(CGFloat)newValue {
    _arrowWidth = newValue;
}

- (CGFloat)arrowHeight {
    return _arrowHeight;
}

- (void)setArrowHeight:(CGFloat)newValue {
    _arrowHeight = newValue;
}

- (BOOL)drawRoundCornerBesideArrow {
    return _drawRoundCornerBesideArrow;
}

- (void)setDrawRoundCornerBesideArrow:(BOOL)newValue {
    _drawRoundCornerBesideArrow = newValue;
}

- (CGFloat)viewMargin {
    return _viewMargin;
}

- (void)setViewMargin:(CGFloat)newValue {
    _viewMargin = newValue;
}

- (NSColor *)backgroundColor {
    return _backgroundColor;
}

- (void)setBackgroundColor:(NSColor *)newValue {
    if (_backgroundColor != newValue)
    {
        [_backgroundColor release];
        _backgroundColor = [newValue retain];
    }
}

- (BOOL)isMovable {
    return _movable;
}

- (void)setMovable:(BOOL)newValue {
    _movable = newValue;
}

- (BOOL)isResizable {
    return _resizable;
}

- (void)setResizable:(BOOL)newValue {
    _resizable = newValue;
}

- (BOOL)isFlipped
{
	return NO;
}

@end

@implementation TPPopoverWindowFrame (Private)

- (NSBezierPath *) popoverFramePathForContentRect:(NSRect)contentRect
{
	contentRect = NSInsetRect(contentRect, -_viewMargin, -_viewMargin);
	contentRect = NSInsetRect(contentRect, -_borderWidth / 2, -_borderWidth / 2);

	CGFloat minX = NSMinX(contentRect);
	CGFloat midX = NSMidX(contentRect);
	CGFloat maxX = NSMaxX(contentRect);

	CGFloat minY = NSMinY(contentRect);
	CGFloat midY = NSMidY(contentRect);
	CGFloat maxY = NSMaxY(contentRect);

	NSBezierPath *path = [NSBezierPath bezierPath];
	[path setLineJoinStyle:NSRoundLineJoinStyle];

	NSPoint currentPoint = NSMakePoint(minX, maxY);
	if(0 < _cornerRadius && (_drawRoundCornerBesideArrow || (SFBPopoverPositionBottomRight != _popoverPosition && SFBPopoverPositionRightBottom != _popoverPosition)))
		currentPoint.x += _cornerRadius;

	NSPoint endOfLine = NSMakePoint(maxX, maxY);
	BOOL shouldDrawNextCorner = NO;
	if(0 < _cornerRadius && (_drawRoundCornerBesideArrow || (SFBPopoverPositionBottomLeft != _popoverPosition && SFBPopoverPositionLeftBottom != _popoverPosition))) {
		endOfLine.x -= _cornerRadius;
		shouldDrawNextCorner = YES;
	}

	[path moveToPoint:currentPoint];

	// If arrow should be drawn at top-left point, draw it.
	if(SFBPopoverPositionBottomRight == _popoverPosition)
		[self appendArrowToPath:path];
	else if(SFBPopoverPositionBottom == _popoverPosition) {
		[path lineToPoint:NSMakePoint(midX - (_arrowWidth / 2), maxY)];
		[self appendArrowToPath:path];
	}
	else if(SFBPopoverPositionBottomLeft == _popoverPosition) {
		[path lineToPoint:NSMakePoint(endOfLine.x - _arrowWidth, maxY)];
		[self appendArrowToPath:path];
	}

	// Line to end of this side.
	[path lineToPoint:endOfLine];

	// Rounded corner on top-right.
	if(shouldDrawNextCorner)
		[path appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY) 
									   toPoint:NSMakePoint(maxX, maxY - _cornerRadius)
										radius:_cornerRadius];

	// Draw the right side, beginning at the top-right.
	endOfLine = NSMakePoint(maxX, minY);
	shouldDrawNextCorner = NO;
	if(0 < _cornerRadius && (_drawRoundCornerBesideArrow || (SFBPopoverPositionTopLeft != _popoverPosition && SFBPopoverPositionLeftTop != _popoverPosition))) {
		endOfLine.y += _cornerRadius;
		shouldDrawNextCorner = YES;
	}

	// If arrow should be drawn at right-top point, draw it.
	if(SFBPopoverPositionLeftBottom == _popoverPosition)
		[self appendArrowToPath:path];
	else if(SFBPopoverPositionLeft == _popoverPosition) {
		[path lineToPoint:NSMakePoint(maxX, midY + (_arrowWidth / 2))];
		[self appendArrowToPath:path];
	}
	else if(SFBPopoverPositionLeftTop == _popoverPosition) {
		[path lineToPoint:NSMakePoint(maxX, endOfLine.y + _arrowWidth)];
		[self appendArrowToPath:path];
	}

	// Line to end of this side.
	[path lineToPoint:endOfLine];

	// Rounded corner on bottom-right.
	if(shouldDrawNextCorner)
		[path appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY) 
									   toPoint:NSMakePoint(maxX - _cornerRadius, minY)
										radius:_cornerRadius];

	// Draw the bottom side, beginning at the bottom-right.
	endOfLine = NSMakePoint(minX, minY);
	shouldDrawNextCorner = NO;
	if(0 < _cornerRadius && (_drawRoundCornerBesideArrow || (SFBPopoverPositionTopRight != _popoverPosition && SFBPopoverPositionRightTop != _popoverPosition))) {
		endOfLine.x += _cornerRadius;
		shouldDrawNextCorner = YES;
	}

	// If arrow should be drawn at bottom-right point, draw it.
	if(SFBPopoverPositionTopLeft == _popoverPosition)
		[self appendArrowToPath:path];
	else if(SFBPopoverPositionTop == _popoverPosition) {
		[path lineToPoint:NSMakePoint(midX + (_arrowWidth / 2), minY)];
		[self appendArrowToPath:path];
	}
	else if(SFBPopoverPositionTopRight == _popoverPosition) {
		[path lineToPoint:NSMakePoint(endOfLine.x + _arrowWidth, minY)];
		[self appendArrowToPath:path];
	}

	// Line to end of this side.
	[path lineToPoint:endOfLine];

	// Rounded corner on bottom-left.
	if(shouldDrawNextCorner)
		[path appendBezierPathWithArcFromPoint:NSMakePoint(minX, minY) 
									   toPoint:NSMakePoint(minX, minY + _cornerRadius)
										radius:_cornerRadius];

	// Draw the left side, beginning at the bottom-left.
	endOfLine = NSMakePoint(minX, maxY);
	shouldDrawNextCorner = NO;
	if(0 < _cornerRadius && (_drawRoundCornerBesideArrow || (SFBPopoverPositionRightBottom != _popoverPosition && SFBPopoverPositionBottomRight != _popoverPosition))) {
		endOfLine.y -= _cornerRadius;
		shouldDrawNextCorner = YES;
	}

	// If arrow should be drawn at left-bottom point, draw it.
	if(SFBPopoverPositionRightTop == _popoverPosition)
		[self appendArrowToPath:path];
	else if(SFBPopoverPositionRight == _popoverPosition) {
		[path lineToPoint:NSMakePoint(minX, midY - (_arrowWidth / 2))];
		[self appendArrowToPath:path];
	}
	else if(SFBPopoverPositionRightBottom == _popoverPosition) {
		[path lineToPoint:NSMakePoint(minX, endOfLine.y - _arrowWidth)];
		[self appendArrowToPath:path];
	}

	// Line to end of this side.
	[path lineToPoint:endOfLine];

	// Rounded corner on top-left.
	if(shouldDrawNextCorner)
		[path appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
									   toPoint:NSMakePoint(minX + _cornerRadius, maxY)
										radius:_cornerRadius];

	[path closePath];
	return path;
}


- (void) appendArrowToPath:(NSBezierPath *)path
{
	if(!_drawsArrow)
		return;

	NSPoint currentPoint = [path currentPoint];
	NSPoint tipPoint = currentPoint;
	NSPoint endPoint = currentPoint;

	switch(_popoverPosition) {
		case SFBPopoverPositionLeft:
		case SFBPopoverPositionLeftTop:
		case SFBPopoverPositionLeftBottom:
			// Arrow points towards right. We're starting from the top.
			tipPoint.x += _arrowHeight;
			tipPoint.y -= _arrowWidth / 2;
			endPoint.y -= _arrowWidth;
			break;

		case SFBPopoverPositionRight:
		case SFBPopoverPositionRightTop:
		case SFBPopoverPositionRightBottom:
			// Arrow points towards left. We're starting from the bottom.
			tipPoint.x -= _arrowHeight;
			tipPoint.y += _arrowWidth / 2;
			endPoint.y += _arrowWidth;
			break;

		case SFBPopoverPositionTop:
		case SFBPopoverPositionTopLeft:
		case SFBPopoverPositionTopRight:
			// Arrow points towards bottom. We're starting from the right.
			tipPoint.y -= _arrowHeight;
			tipPoint.x -= _arrowWidth / 2;
			endPoint.x -= _arrowWidth;
			break;

		case SFBPopoverPositionBottom:
		case SFBPopoverPositionBottomLeft:
		case SFBPopoverPositionBottomRight:
			// Arrow points towards top. We're starting from the left.
			tipPoint.y += _arrowHeight;
			tipPoint.x += _arrowWidth / 2;
			endPoint.x += _arrowWidth;
			break;
	}

	[path lineToPoint:tipPoint];
	[path lineToPoint:endPoint];
}

@end
