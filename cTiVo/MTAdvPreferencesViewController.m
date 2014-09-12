//
//  MTAdvPreferencesViewController.m
//  cTiVo
//
//  Created by Hugh Mackworth on 2/7/13.
//  Copyright (c) 2013 Scott Buchanan. All rights reserved.
//

#import "MTAdvPreferencesViewController.h"
#import "MTTiVoManager.h"

#define tiVoManager [MTTiVoManager sharedTiVoManager]

@interface MTAdvPreferencesViewController ()
@property (nonatomic, strong) NSArray * debugClasses;   //all classes registered with DDLog (including autogenerated)
@property (nonatomic, strong) NSMutableArray * classNames; //all class names that are actually displayed
@property (nonatomic, strong) NSMutableArray * popups;
@end

@implementation MTAdvPreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
	
    return self;
}

-(IBAction)selectTmpDir:(id)sender
{
	NSOpenPanel *myOpenPanel = [[NSOpenPanel alloc] init];
	myOpenPanel.canChooseFiles = NO;
	myOpenPanel.canChooseDirectories = YES;
	myOpenPanel.canCreateDirectories = YES;
	myOpenPanel.prompt = @"Choose";
	myOpenPanel.directoryURL = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:kMTTmpFilesDirectory]];
	[myOpenPanel setTitle:@"Select Temp Directory for Files"];
	[myOpenPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger ret){
		if (ret == NSFileHandlingPanelOKButton) {
			NSString *directoryName = myOpenPanel.URL.path;
			[[NSUserDefaults standardUserDefaults] setObject:directoryName forKey:kMTTmpFilesDirectory];
		}
		[myOpenPanel close];
	}];
	
}


-(NSTextField *) newTextField: (NSRect) frame {
	NSTextField *textField;
	
    textField = [[NSTextField alloc] initWithFrame:frame];
    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
	[textField setAlignment: NSRightTextAlignment ];
	[textField setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]]];
	[textField setAutoresizingMask: NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin | NSViewMinYMargin | NSViewHeightSizable | NSViewMaxYMargin];
	return textField;
}

-(void) addDebugMenuTo:(NSPopUpButton*) cell withCurrentLevel: (NSInteger) currentLevel{
	NSArray * debugNames = @[@"None",@"Normal" ,@"Major" ,@"Detail" , @"Verbose"];
	int debugLevels[] = {LOG_LEVEL_OFF, LOG_LEVEL_REPORT, LOG_LEVEL_MAJOR, LOG_LEVEL_DETAIL, LOG_LEVEL_VERBOSE};
	
	[cell addItemsWithTitles: debugNames];
	for (int index = 0; index < cell.numberOfItems; index++) {
		//	for (NSMenuItem * item in [cell itemArray]) {
		NSMenuItem * menu = [cell itemAtIndex:index];
		menu.tag = debugLevels[index];
		if (menu.tag == currentLevel) {
			[cell selectItem:menu];
		}
	}
}
-(void) addKeywordMenuTo:(NSPopUpButton*) cell{
	NSArray * keyWords = @[
						   @"Title",  //these values must be same as those in keyword processing
						   @"MainTitle",
						   @"EpisodeTitle",
						   @"ChannelNum",
						   @"Channel",
						   @"Min",
						   @"Hour",
						   @"Wday",
						   @"Mday",
						   @"Month",
						   @"MonthNum",
						   @"Year",
						   @"OriginalAirDate",
						   @"Season",
						   @"Episode",
						   @"EpisodeNumber",
						   @"SeriesEpNumber",
						   @"StartTime",
						   @"MovieYear",
						   @"TiVoName",
						   @"TVDBseriesID",
						   @"• Plex Default",  //• means replace whole field;
						   @"• Plex Folders",
						   @"• Complex Example",//these must match below
						   @"• cTiVo Default"
						   ];
	[cell addItemsWithTitles: keyWords];
	for (NSMenuItem * item in cell.itemArray) {
		item.representedObject = item.title;
	}
	//and fixup the ones that are special
	NSMenuItem * plex = [cell itemWithTitle:@"• Plex Default"];
	plex.representedObject = @"[MainTitle] - [SeriesEpNumber] - [EpisodeTitle]";
	
	NSMenuItem * plex2 = [cell itemWithTitle:@"• Plex Folders"];
	plex2.representedObject = 	@"[MainTitle / \"Season \" Season / MainTitle \" - \" SeriesEpNumber \" - \" EpisodeTitle][\"Movies\"  / MainTitle \" (\" MovieYear \")\"]";
	
	NSMenuItem * complex = [cell itemWithTitle:@"• Complex Example"];
	complex.representedObject =
	@"[MainTitle / SeriesEpNumber \" - \" EpisodeTitle][\"Movies\"  / MainTitle \" (\" MovieYear \")\"]";

	NSMenuItem * example = [cell itemWithTitle:@"• cTiVo Default"];
	example.representedObject = @"";
}


-(void) resetAllPopups: (int) newVal {
}

-(void) awakeFromNib {
	
	[self addDebugMenuTo:self.masterDebugLevel withCurrentLevel:[[NSUserDefaults standardUserDefaults] integerForKey:kMTDebugLevel]];
	[self addKeywordMenuTo:self.keywordPopup];
	
	self.debugClasses = [DDLog registeredClasses] ;
	self.popups= [NSMutableArray arrayWithCapacity:self.debugClasses.count ];
	self.classNames = [NSMutableArray arrayWithCapacity:self.debugClasses.count];
	for (Class class in self.debugClasses) {
		NSString * className =  NSStringFromClass(class);
		if ([className hasPrefix:@"NSKVONotifying"]) continue;
		[self.classNames addObject:className];
	}
	[self.classNames sortUsingSelector:  @selector(localizedCaseInsensitiveCompare:)];
	
	int numItems = (int)[self.classNames count];
	int itemNum = 0;
	for (NSString * className in self.classNames) {
		Class class =  NSClassFromString(className);
		const CGFloat vertBase = self.debugLevelView.frame.size.height-40;
		const CGFloat horizBase = self.debugLevelView.frame.size.width;
		const int labelWidth = 160;
		const int popupHeight = 25;
		const int popupWidth = 80;
		const int vertMargin = 5;
		const int horizMargin = 10;
		const CGFloat columnWidth = horizBase/2;
		int columNum = (itemNum < numItems/2)? 0:1;
		int rowNum = (itemNum < numItems/2) ? itemNum: itemNum-numItems/2;
		
		NSRect labelFrame = NSMakeRect(columNum*columnWidth,vertBase-rowNum*(popupHeight+vertMargin)-4,labelWidth,popupHeight);
		NSTextField * label = [self newTextField:labelFrame];
		NSString * displayName = [NSString stringWithFormat:@"%@:",className];
		if ([displayName hasPrefix:@"MT"]) {
			displayName = [displayName substringFromIndex:2]; //delete "MT"
		}
		[label setStringValue:displayName];
		
		NSRect frame = NSMakeRect(columNum*columnWidth+labelWidth+horizMargin,vertBase-rowNum*(popupHeight+vertMargin),popupWidth,popupHeight);
		NSPopUpButton * cell = [[NSPopUpButton alloc] initWithFrame:frame pullsDown:NO];
		
		cell.title = className;
		cell.font= 	[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]];

		[self addDebugMenuTo:cell withCurrentLevel: [DDLog logLevelForClass:class]];
		cell.target = self;
		cell.action = @selector(newValue:);
		
		[self.debugLevelView addSubview:label];
		[self.debugLevelView addSubview:cell];
		[self.popups addObject: cell];
		itemNum++;
	}
	
//	for (row = 0; row < numRows; row++) {
//		for ( col = 0; col < kNumColumns; col++) {
//			NSInteger itemNum = row*kNumColumns +col;
//			NSCell * cell = [self.debugLevelForm cellAtRow:row column:col];
//			if (itemNum < numItems) {
//				cell.title = NSStringFromClass([self.debugClasses objectAtIndex:itemNum]);
//			}
//		}
//	}

}
-(IBAction)TVDBStatistics:(id)sender {
	NSAttributedString *attrHelpText = [[NSAttributedString alloc] initWithString:[tiVoManager.theTVDBStatistics description]];
	//	NSString *helpText = [NSString stringWithContentsOfFile:helpFilePath encoding:NSUTF8StringEncoding error:nil];
	NSButton *thisButton = (NSButton *)sender;
	[myTextView setAutomaticLinkDetectionEnabled:YES];
	[myTextView setString:[tiVoManager.theTVDBStatistics description]];
	[myTextView checkTextInDocument:nil];
	//	[self.helpController.displayMessage insertText:helpText];
	[popoverDetachController.displayMessage.textStorage setAttributedString:attrHelpText];
	[myPopover showRelativeToRect:thisButton.bounds ofView:thisButton preferredEdge:NSMaxXEdge];
}

-(IBAction) keywordSelected:(id)sender {
	NSPopUpButton * cell =  (NSPopUpButton *) sender;
	NSString * keyword = [cell.selectedItem representedObject];
	NSText * editor = [self.fileNameField currentEditor];
	NSString * current = self.fileNameField.stringValue;
	if (!editor) {
		//not selected, so select, at end of text
		[self.view.window makeFirstResponder:self.fileNameField];
		editor = [self.fileNameField currentEditor];
		[editor setSelectedRange:NSMakeRange(current.length,0)];
	}
	if ([cell.selectedItem.title hasPrefix:@"•"]) {
		//whole template, so replace whole string
		[editor setSelectedRange:NSMakeRange(0,current.length)];
	} else {
		//normally we add brackets around individual keywords, but not if we're inside one already
		NSUInteger cursorLoc = editor.selectedRange.location;
		NSRange beforeCursor = NSMakeRange(0,cursorLoc);
		NSInteger lastLeft = [current rangeOfString:@"[" options:NSBackwardsSearch range:beforeCursor].location;
		NSInteger lastRight = [current rangeOfString:@"]" options:NSBackwardsSearch range:beforeCursor].location;
		if (lastLeft == NSNotFound ||  //might be inside a [, but only if
			(lastRight != NSNotFound && lastRight > lastLeft)) { //we don't have a ] after it
			keyword = [NSString stringWithFormat:@"[%@]",keyword];
		} else {
			//inside a bracket, so we may want a space-delimited keywords
			unichar priorCh = [current characterAtIndex:cursorLoc-1];
			if (priorCh != '[' && priorCh != ' ') {
				keyword =[NSString stringWithFormat:@" %@ ",keyword];
			}
		}
	}
	[editor insertText:keyword];

}

-(IBAction) newMasterValue:(id) sender {
	NSPopUpButton * cell =  (NSPopUpButton *) sender;
	
	int newVal = (int) cell.selectedItem.tag;
	for (Class class in [DDLog registeredClasses]) {
		[class ddSetLogLevel:newVal];
	}
	for (NSPopUpButton * myCell in self.popups) {
		[myCell selectItemWithTag:newVal];
	}
	[DDLog writeAllClassesLogLevelToUserDefaults];
}

-(IBAction) newValue:(id) sender {
	NSPopUpButton * cell =  (NSPopUpButton *) sender;
	NSInteger whichPopup = [self.popups indexOfObject:sender];
	NSString * className = self.classNames[whichPopup];
	
	int newVal = (int) cell.selectedItem.tag;
	
	[DDLog setLogLevel:newVal forClassWithName :className];
	[DDLog writeAllClassesLogLevelToUserDefaults];
}

-(IBAction)emptyCaches:(id)sender
{
    NSAlert *cacheAlert = [NSAlert alertWithMessageText:@"Emptying the caches will then reload all information from the TiVos and from TheTVDB.\nDo you want to continue?" defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:@""];
    NSInteger returnButton = [cacheAlert runModal];
    if (returnButton != 1) {
        return;
    }
    [tiVoManager resetAllDetails];
}

- (BOOL)windowShouldClose:(id)sender {
	//notified by PreferenceWindowController that we're going to close, so save the currently edited textField
	NSResponder * responder = [self.view.window firstResponder];
	if ([responder class] == [NSTextView class] ) {
		[self.view.window makeFirstResponder:nil ];
	}
	return YES;
}


@end
