//
//  MTFormatEditorController.m
//  cTiVo
//
//  Created by Scott Buchanan on 1/12/13.
//  Copyright (c) 2013 Scott Buchanan. All rights reserved.
//

#import "MTFormatEditorController.h"
#import "MTTiVoManager.h"
#import "MTFormatPopUpButton.h"

@interface MTFormatEditorController ()

@property (nonatomic, strong) NSDictionary *alertResponseInfo;

@end

@implementation MTFormatEditorController


//- (id)initWithWindow:(NSWindow *)window
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
		myPopover = nil;
		self.validExecutableColor = [NSColor blackColor];
		self.validExecutable = [NSNumber numberWithBool:YES];
		self.validExecutableString = @"No valid executable found.";
    }
    
    return self;
}

-(void)awakeFromNib
{
	popoverDetachWindow.contentView = popoverDetachController.view;
	[self refreshFormatList];
//	self.formatList = [NSMutableArray arrayWithArray:tiVoManager.formatList];
//	self.currentFormat = [tiVoManager.selectedFormat copy];
	formatPopUpButton.showHidden = YES;
	formatPopUpButton.formatList =  self.formatList;
 	[self refreshFormatPopUp:nil];
	self.shouldSave = [NSNumber numberWithBool:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForFormatChange) name:kMTNotificationFormatChanged object:nil];
   
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
	[self updateForFormatChange];
}

-(void)refreshFormatList
{
	//Deepcopy array so we have new object
	self.formatList = [NSMutableArray array];
	formatPopUpButton.formatList = self.formatList;
	
	for (MTFormat *f in tiVoManager.formatList) {
		MTFormat *newFormat = [f copy];
		[_formatList addObject:newFormat];
		newFormat.formerName = f.name;
		if ([tiVoManager.selectedFormat.name compare:newFormat.name] == NSOrderedSame) {
			self.currentFormat = newFormat;
		}
	}

}

- (BOOL)windowShouldClose:(id)sender
{
	[[NSApp keyWindow] makeFirstResponder:[NSApp keyWindow]]; //save any text edits in process
	if ([self.shouldSave boolValue]) {
		saveOrCancelAlert = [NSAlert alertWithMessageText:@"You have edited the formats.  Leaving the window will discard your changes.  Do you want to save your changes?" defaultButton:@"Save" alternateButton:@"Leave Window" otherButton:@"Continue Editing" informativeTextWithFormat:@""];
		[saveOrCancelAlert beginSheetModalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
		self.alertResponseInfo = (NSDictionary *)sender;
		return NO;
	} else {
		[self close];
		return YES;

	}
}

- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	if (alert == deleteAlert) {
		if (returnCode == 1) {
			[self.formatList removeObject:_currentFormat];
			self.currentFormat = _formatList[0];
			[self refreshFormatPopUp:nil];
			[self updateForFormatChange];
		}
	}
	if (alert == saveOrCancelAlert) {
		switch (returnCode) {
			case 1:
				//Save changes here
				[self saveFormats:nil];
				//				[self.window close];
				[self close];
				[self alertResponse:_alertResponseInfo];
				break;
			case 0:
				//Cancel Changes here and dismiss
				//				[self.window close];
				[self close];
				[self alertResponse:_alertResponseInfo];
				break;
			case -1:
				//Don't Close the window
				break;
			default:
				break;
		}
	}
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(void)alertResponse:(NSDictionary *)info
{
	id target = (id)info[@"Target"];
	SEL selector = NSSelectorFromString(info[@"Selector"]);
	id argument = (id)info[@"Argument"];
	[target performSelector:selector withObject:argument];
}
#pragma clang diagnostic pop


-(void)close
{
//	[NSApp endSheet:self.window];
//	[self.window orderOut:nil];
	[self refreshFormatList]; //throw away all changes
 	[self refreshFormatPopUp:nil];
	[self updateForFormatChange];

}


//-(void)showWindow:(id)sender
//{
//	//Deepcopy array so we have new object
//    if (formatPopUpButton) {  //Clumsy way of refreshing popup selection after dismissal and re-show of window.  Need better connection
//		[self refreshFormatPopUp:nil];
//		self.currentFormat= [formatPopUpButton selectFormatNamed:tiVoManager.selectedFormat.name];
//		self.currentFormat = formatPopUpButton.selectedItem.representedObject;
//  
//         self.shouldSave = [NSNumber numberWithBool:NO];
//    }
//	[super showWindow:sender];
//    [self updateForFormatChange];
//}
//
#pragma mark - Utility Methods

-(void)updateForFormatChange
{
	self.currentFormat.name = [self checkFormatName:self.currentFormat.name];
	[self checkShouldSave];
	[self checkValidExecutable];
	[self refreshFormatPopUp:nil];
}

-(void)checkValidExecutable
{
	NSString *validPath = [_currentFormat pathForExecutable];
	BOOL isValid = NO;
	self.validExecutableString = @"No valid executable found.";
	NSColor *isValidColor = [NSColor redColor];
	if (validPath) {
		isValidColor = [NSColor blackColor];
		isValid = YES;
		self.validExecutableString = [NSString stringWithFormat:@"Found at %@",validPath];
	}
	self.validExecutableColor = isValidColor;
	self.validExecutable = [NSNumber numberWithBool:isValid];
}

-(void)checkShouldSave
{
	BOOL result = NO;
	if (_formatList.count != tiVoManager.formatList.count) {
		result =  YES;
	} else {
		for (MTFormat *f in _formatList) {
			MTFormat *foundFormat = [tiVoManager findFormat:f.name];
			if ( ! [f.name isEqualToString:foundFormat.name]) { //We have a new format so we should be able to save/cancel
				result = YES;
				break;
			} else if (![foundFormat isSame:f]) { //We found a format that exisit but is different.
				result = YES;
				break;
			}
		}
	}
	self.shouldSave = [NSNumber numberWithBool:result];
}

-(NSString *)checkFormatName:(NSString *)name
{
	if (!name) return nil;
	//Make sure the title isn't the same and if it is add a -1 modifier
    for (MTFormat *f in _formatList) {
		if (f == self.currentFormat) break;  //checking our own name
		if ([name caseInsensitiveCompare:f.name] == NSOrderedSame) {
            NSRegularExpression *ending = [NSRegularExpression regularExpressionWithPattern:@"(.*)-([0-9]+)$" options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult *result = [ending firstMatchInString:name options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, name.length)];
            if (result) {
                int n = [[f.name substringWithRange:[result rangeAtIndex:2]] intValue];
                name = [[name substringWithRange:[result rangeAtIndex:1]] stringByAppendingFormat:@"-%d",n+1];
            } else {
                name = [name stringByAppendingString:@"-1"];
            }
           return [self checkFormatName:name];
        }
    }
	return name;
} 
- (BOOL)validateValue:(id *)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError **)outError {
	if ([inKeyPath isEqualToString:@"currentFormat.name"]) {
		NSString *proposedName = (NSString *)*ioValue;
		if (proposedName == nil) return NO;
		*ioValue = [self checkFormatName:proposedName];
	}
	return YES;
}

#pragma mark - UI Actions

-(IBAction)cancelFormatEdit:(id)sender
{
	[self windowShouldClose:nil];
}

-(IBAction)selectFormat:(id)sender
{
	MTFormatPopUpButton *thisButton = (MTFormatPopUpButton *)sender;
	self.currentFormat = [[thisButton selectedItem] representedObject];
	[self updateForFormatChange];
	
}


-(IBAction)deleteFormat:(id)sender
{
	deleteAlert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Do you want to delete the format %@ entirely?",_currentFormat.name] defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:@""];
	[deleteAlert beginSheetModalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
	
}

-(IBAction)saveFormats:(id)sender
{
	[tiVoManager.formatList removeAllObjects];
	for (MTFormat *f in _formatList) {
		MTFormat *newFormat = [f copy];
		[tiVoManager.formatList addObject:newFormat];
	}
    //Now update the tiVoManger selectedFormat object and user preference
    tiVoManager.selectedFormat = [tiVoManager findFormat:tiVoManager.selectedFormat.name];
	[[NSUserDefaults standardUserDefaults] setObject:tiVoManager.userFormatDictionaries forKey:kMTFormats];
    [[NSUserDefaults standardUserDefaults] setObject:tiVoManager.hiddenBuiltinFormatNames forKey:kMTHiddenFormats];
	[[NSNotificationCenter defaultCenter] postNotificationName:kMTNotificationFormatListUpdated object:nil];
	[self updateForFormatChange];
}

-(IBAction)newFormat:(id)sender
{
	
	MTFormat *newFormat = [MTFormat new];
    newFormat.name = @"New Format";
    [newFormat checkAndUpdateFormatName:_formatList];
	[self.formatList addObject:newFormat];
	self.currentFormat = newFormat;
	[self refreshFormatPopUp:nil];
	[formatPopUpButton selectItemWithTitle:newFormat.name];
	self.currentFormat = [[formatPopUpButton selectedItem] representedObject];
	[self updateForFormatChange];
	
}

-(IBAction)duplicateFormat:(id)sender
{
	MTFormat *newFormat = [_currentFormat copy];
    [newFormat checkAndUpdateFormatName:_formatList];
	newFormat.isFactoryFormat = [NSNumber numberWithBool:NO];
	[self.formatList addObject:newFormat];
	self.currentFormat = newFormat;
	[self refreshFormatPopUp:nil];
	[formatPopUpButton selectItemWithTitle:newFormat.name];
	self.currentFormat = [[formatPopUpButton selectedItem] representedObject];
	[self updateForFormatChange];
}

-(void)refreshFormatPopUp:(NSNotification *)notification
{
	[formatPopUpButton refreshMenu];
	self.currentFormat = [formatPopUpButton selectFormatNamed:_currentFormat.name];
}

-(IBAction)help:(id)sender
{
	//Get help text for encoder
	NSString *helpFilePath = nil;;
	if (sender == encodeHelpButton) {
		helpFilePath = [[NSBundle mainBundle] pathForResource:@"EncoderHelpText" ofType:@"rtf"];
	} else if (sender == comSkipHelpButton) {
		helpFilePath = [[NSBundle mainBundle] pathForResource:@"ComSkipHelpText" ofType:@"rtf"];
	}
	NSAttributedString *attrHelpText = [[NSAttributedString alloc] initWithRTF:[NSData dataWithContentsOfFile:helpFilePath] documentAttributes:NULL];
	//	NSString *helpText = [NSString stringWithContentsOfFile:helpFilePath encoding:NSUTF8StringEncoding error:nil];
	NSButton *thisButton = (NSButton *)sender;
	if (!myPopover) {
		myPopover = [[NSPopover alloc] init];
		myPopover.delegate = self;
		myPopover.behavior = NSPopoverBehaviorTransient;
		myPopover.contentViewController = helpContoller;
		[helpContoller loadView];
		[helpContoller.displayMessage.textStorage setAttributedString:attrHelpText];
	}
	//	[self.helpController.displayMessage insertText:helpText];
	[popoverDetachController.displayMessage.textStorage setAttributedString:attrHelpText];
	[myPopover showRelativeToRect:thisButton.bounds ofView:thisButton preferredEdge:NSMaxXEdge];
}


#pragma mark - Popover Delegate Methods

-(NSWindow *)detachableWindowForPopover:(NSPopover *)popover
{
	return popoverDetachWindow;
}

-(void)popoverDidClose:(NSNotification *)notification
{
	myPopover = nil;
}


#pragma mark - Memory Management

-(void) dealloc {
    myPopover.delegate = nil;
}

@end
