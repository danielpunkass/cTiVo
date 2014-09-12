//
//  MTConstants.h
//  myTivo
//
//  Created by Scott Buchanan on 12/6/12.
//  Copyright (c) 2012 Scott Buchanan. All rights reserved.
//

//Queue change notifications
#define kMTNotificationTiVoShowsUpdated @"MTNotificationTiVoShowsUpdated"
#define kMTNotificationDownloadQueueUpdated @"MTNotificationDownloadQueueUpdated"  //optional object: Tivo that cause it
#define kMTNotificationSubscriptionsUpdated @"MTNotificationSubscriptionsUpdated"

//Download Progress Notifications
#define kMTNotificationDownloadDidFinish @"MTNotificationDownloadDidFinish"    //object = MTTiVo that just finished a transfer
#define kMTNotificationDecryptDidFinish @"MTNotificationDecryptDidFinish"
//#define kMTNotificationEncodeDidFinish @"MTNotificationEncodeDidFinish"
//#define kMTNotificationEncodeWasCanceled @"MTNotificationEncodeWasCanceled"
//#define kMTNotificationCommercialDidFinish @"MTNotificationCommercialDidFinish"
//#define kMTNotificationCommercialWasCanceled @"MTNotificationCommercialWasCanceled"
//#define kMTNotificationCaptionDidFinish @"MTNotificationCaptionDidFinish"
//#define kMTNotificationCaptionWasCanceled @"MTNotificationCaptionWasCanceled"
#define kMTNotificationDownloadStatusChanged @"MTNotificationDownloadStatusChanged"
#define kMTNotificationShowDownloadDidFinish @"MTNotificationShowDownloadDidFinish"     //object = MTDownload that just finished its entire process
#define kMTNotificationShowDownloadWasCanceled @"MTNotificationShowDownloadWasCanceled"

//UI Change Notifications

#define kMTNotificationTiVoListUpdated @"MTNotificationTiVoListUpdated"  //optional object: which Tivo changed/added; not used
#define kMTNotificationFormatListUpdated @"MTNotificationFormatListUpdated"
#define kMTNotificationProgressUpdated @"MTNotificationProgressUpdated"  //optional object: which MTDownload; not used, 
#define kMTNotificationNetworkChanged @"MTNotificationNetworkChanged"
#define kMTNotificationDetailsLoaded @"MTNotificationDetailsLoaded"  //object: which MTTiVoShow was loaded
#define kMTNotificationDownloadRowChanged @"NotificationDownloadRowChanged"  //object: which MTDownload was changed
#define kMTNotificationSubscriptionChanged @"NotificationSubscriptionChanged"  //object: which MTSubscription was changed
//#define kMTNotificationReloadEpisode @"MTNotificationReloadEpisode"
#define kMTNotificationMediaKeyNeeded @"MTNotificationMediaKeyNeeded"  //object: which MTTiVo needs a key
#define kMTNotificationFormatChanged @"MTNotificationFormatChanged"     //object: which MTFormat changed
#define kMTNotificationFoundMultipleTiVos @"MTNotificationFoundMultipleTiVo"

//Tivo busy indicator
#define kMTNotificationShowListUpdating @"MTNotificationShowListUpdating"  //object: which MTTivo is updating
#define kMTNotificationShowListUpdated @"MTNotificationShowListUpdated" //object: which MTTivo is updated

#define deleteXML 1   //placeholder to store deleted code in case we decide to restore XML export; need to add to downloadTable, subTable, menu and pref NIBx also

//Download Status
#define kMTStatusNew 0
#define kMTStatusDownloading 1
#define kMTStatusDownloaded 2
#define kMTStatusDecrypting 3
#define kMTStatusDecrypted 4
#define kMTStatusCommercialing 5
#define kMTStatusCommercialed 6
#define kMTStatusEncoding 7
#define kMTStatusDoneOld 8		//don't reuse
#define kMTStatusCaptioning 9
#define kMTStatusCaptioned 10
#define kMTStatusMetaDataProcessing 11
#define kMTStatusEncoded 12
#define kMTStatusAddingToItunes 13
#define kMTStatusDone 14
#define kMTStatusDeleted 15
#define kMTStatusFailed 16

//Contants

#define kMTUpdateIntervalMinDefault 15 //Default Update interval for re-checking current TiVo
#define kMTMaxDownloadRetries 3		// Only allow 3 retries to download a show; default, overriden by userPref
#define kMTMaxDownloadStartupRetries 20		// Only allow 20 retries due to a download startup failuer
//#define kMTProgressCheckDelay (2 * 60.0)	//Check progress every 60 seconds to make sure its not stalled
#define kMTProgressFailDelayAt100Percent (7 * 60.0) //Added to account for encoders (Handbrake) have have a lot of post-processing after 100%
//#define kMTRetryNetworkInterval 15	//Re-Check for network connectivity every X seconds
#define kMTTiVoAccessDelay 7		//Seconds to wait after TiVo is found on network
#define kMTTiVoAccessDelayServerFailure 60		//Seconds to wait after TiVo reports Download server problem
#define kMTTheTVDBAPIKey @"DB85D57BFFC7DD85"  //API Key for theTVDB

//Subscribed Show userDefaults
#define kMTSubscribedSeries @"MTSubscribedSeries"
#define kMTCreatedDate	@"MTSubscribedSeriesDate"   //used to be kMTSubscribedDate"
#define kMTSubscribedFormat @"MTSubscribedSeriesFormat"
#define kMTSubscribediTunes @"addToiTunes"
#define kMTSubscribedSimulEncode @"simultaneousEncode"
#define kMTSubscribedSkipCommercials @"skipCommercials"
#define kMTSubscribedMarkCommercials @"markCommercials"
#define kMTSubscribedIncludeSuggestions @"includeSuggestions"
#define kMTSubscribedGenTextMetaData     @"GenTextMetadata"
#ifndef deleteXML
#define kMTSubscribedGenXMLMetaData	    @"GenXMLMetadata"
#endif
#define kMTSubscribedIncludeAPMMetaData  @"IncludeAPMMetaData"
#define kMTSubscribedExportSubtitles  @"ExportSubtitles"
#define kMTSubscribedPreferredTiVo  @"PreferredTiVo"
#define kMTSubscribedHDOnly  @"HDOnly"
#define kMTSubscribedSDOnly  @"SDOnly"
#define kMTSubscribedPrevRecorded @"PrevRecorded"
#define kMTSubscribedRegExPattern @"RegExPattern"

//Download queue userDefaults
#define kMTQueue      @"Queue"
#define kMTQueueID    @"QueueID"
#define kMTQueueTitle @"QueueTitle"
#define kMTQueueTivo  @"QueueTivo"
#define kMTQueueFormat  @"QueueFormat"
#define kMTQueueStatus  @"QueueStatus"
#define kMTQueueShowStatus @"QueueShowStatus"
#define kMTQueueDirectory @"QueueDirectory"
#define kMTQueueDownloadFile @"QueueDownloadFile"
#define kMTQueueBufferFile @"QueueBufferFile"
#define kMTQueueFinalFile @"QueueFileName"
#define kMTQueueGenTextMetaData     @"QueueGenTextMetadata"
#ifndef deleteXML
#define kMTQueueGenXMLMetaData	    @"QueueGenXMLMetadata"
#endif
#define kMTQueueIncludeAPMMetaData  @"QueueIncludeAPMMetaData"
#define kMTQueueExportSubtitles  @"QueueExportSubtitles"
#define kMTGetEpisodeArt @"GetEpisodeArt"


//Column editing userDefaults
#define kMTProgramTableColumns @"ProgramTableColumns"
#define kMTDownloadTableColumns @"DownloadTableColumns"
#define kMTSubscriptionTableColumns @"kMTSubscriptionTableColumns"
#define kMTHasMultipleTivos @"HasMultipleTivos"

//Misc

#define kMTFirstName @"MTFirstName"
#define kMTLastName @"MTLastName"
#define kMTAllTiVos @"All TiVos"
#define kMTDefaultDownloadDir  @"Movies/TiVoShows/"
#define kMTMaxBuffSize 50000000
#define kMTMaxReadPoints 500000
#define kMTMaxPointsBeforeWrite 500000
#define kMTTimeToHelpIfNoTiVoFound 15

#define kMTTivoShowPasteBoardType @"com.cTiVo.TivoShow"
#define kMTDownloadPasteBoardType @"com.cTiVo.Download"
#define kMTInputLocationToken @"<<<INPUT>>>"
#define kMTTmpDir @"/tmp/ctivo/"
#define kMTTmpDetailsDir @"/tmp/ctivo_details"

//XATTRs

#define kMTXATTRTiVoName @"TiVoName"
#define kMTXATTRTiVoID @"TiVoID"
#define kMTXATTRSpotlight @"com.apple.metadata:kMDItemFinderComment"
#define kMTXATTRFileComplete @"com.ctivo.filecomplete"
#define kMTSpotlightKeyword @"cTiVoDownload"

//Task Flow Types

#define kMTTaskFlowNonSimu 0
#define kMTTaskFlowNonSimuSubtitles 1
#define kMTTaskFlowSimu 2
#define kMTTaskFlowSimuSubtitles 3
#define kMTTaskFlowNonSimuSkipcom 4
#define kMTTaskFlowNonSimuSkipcomSubtitles 5
#define kMTTaskFlowSimuSkipcom 6
#define kMTTaskFlowSimuSkipcomSubtitles 7
#define kMTTaskFlowNonSimuMarkcom 8
#define kMTTaskFlowNonSimuMarkcomSubtitles 9
#define kMTTaskFlowSimuMarkcom 10
#define kMTTaskFlowSimuMarkcomSubtitles 11

//USER DEFAULTS

#define kMTTheTVDBCache @"TVDBLocalCache"   //Local cache for TVDB information
#define kMTTrustTVDB @"TrustTVDB"          //Should we override TiVo with TVDB season/episode
#define	kMTQueuePaused @"QueuePaused"			//State of pause for the download queue
#define kMTTiVos @"TiVos"           //List of defined tiVos both discovered and manually defined.
#define kMTPreventSleep @"PreventSleep"			//If true this will prevent sleep when possible
#define kMTQuitWhileProcessing @"QuitWhileProcessing" //Don't warn user when quitting if active job
#define kMTFormats @"Formats"                        //User defined Formats
#define kMTHiddenFormats @"HiddenFormats"        //User defined list of built-in formats to be hidden in the UI
#define kMTSelectedTiVo @"SelectedTiVo"             //Name of currently selected TiVo
#define kMTSelectedFormat @"SelectedFormat"         //Name of currently selected format for conversion
#define kMTDownloadDirectory  @"DownloadDirectory"  //Pathname for directory for dowloaded files
#define kMTThumbnailsDirectory  @"ThumbnailsDirectory"  //Pathname for directory for dowloaded files (no GUI)
#define kMTSubscriptionList @"SubscriptionList"     //Array of subscription dictionaries
#define kMTTiVoLastLoadTimes @"TiVoLastLoadTImes"   //Array of Date each tivo last processed
#define kMTiTunesSubmit @"iTunesSubmit"             //Whether to submit to iTunes after encoding
#define kMTiTunesSync @"iTunesSync"                 // Whether to sync iDevices after iTunes submital
#define kMTiTunesDelete @"iTunesDelete"				//Whether to delete original file after submitting to iTunes
#define kMTiTunesContentIDExperiment @"iTunesContentID"  //Whether to add episodeID as contentID for iTunes; doesn't seem to work
#define kMTSimultaneousEncode @"SimultaneousEncode" //Whether to encode while downloading
#define kMTDisableDragSelect @"DisableDragSelect"   //Whether to disable drag-select in downloadshow list (vs drag/drop
//Future? #define kMTAllowDups @"AllowDups"			//Whether to allow duplicate entries in downloads/subscriptions (e.g. for different formats)
#define kMTMakeSubDirs @"MakeSubDirs"               // Whether to make separate subdirectories for each series (in download dir)
#define kMTShowCopyProtected @"ShowCopyProtected"   // Whether to display uncopyable shows (greyed out)
#define kMTShowSuggestions @"ShowSuggestions"		// Whether to display Tivo Suggestions (and to subscribe thereto)
#define kMTSaveTmpFiles @"SaveTmpFiles"				// Turn off AutoDelete of intermediate files (to make debugging encoders easier)
#define kMTUseMemoryBufferForDownload @"UseMemoryBufferForDownload" //Default is YES.  Turn off to make sure downloaded file is complete. Principally for debugging use and checkpointing.
#define kMTFileNameFormat @"FileNameFormat"			//keyword pattern for filenames
#define kMTTmpFilesDirectory @"TmpFilesDirectory"   //Where are temporary files saved

#define kMTNumDownloadRetries @"NumDownloadRetries" // How many retries due to download failures
#define kMTUpdateIntervalMinutes @"UpdateIntervalMinutes" //How many minutes to wait between tivo refreshes (No GUI)
#define kMTMaxNumDownloaders @"MaxNumberDownloaders"	//Limit number of encoders to limit cpu usage (No GUI) //
#define kMTMaxProgressDelay @"MaxProgressDelay"      //Maximum time of no encoder progress before giving up (No GUI)  //

#define kMTRunComSkip @"RunComSkip"                 // Whether to run comSkip program after conversion
#define kMTMarkCommercials @"MarkCommercials"        // Whether insert chapters for commercials when possible
#define kMTExportSubtitles @"ExportSubtitles"       // Whether to export subtitles with ts2ami
#define kMTExportTextMetaData @"ExportTextMetaData" // Whether to export text metadata for PyTivo

#ifndef deleteXML
#define kMTExportTivoMetaData @"ExportTivoMetaData" // Whether to export XML metadata
#define kMTExportMetaData @"ExportMetaData" // Whether to export metadata with Atomic Parsley
#endif

#define kMTScheduledOperations @"ScheduledOperations"// Whether to run queue at a scheduled time;
#define kMTScheduledStartTime  @"ScheduledStartTime" // NSDate when to start queue
#define kMTScheduledEndTime    @"ScheduledEndTime"   // NSDate when to end queue
#define kMTScheduledSleep      @"ScheduledSleep"     // Whether to start queue to sleep after scheduled downloads

#define kMTDebugLevel       @"DebugLevel"
#define kMTDebugLevelDetail @"DebugLevelDetail"

//Obsolete keys, but kept for upgrade path
#define kMTManualTiVos @"ManualTiVos"           //Array of manually defined tiVo address. -replaced by MTTiVos
#define kMTMediaKeys @"MediaKeys"                   //MAK dictionary, indexed by TiVo Name  --replaced by MTTiVos

//List of keys in TiVo Preference Dictionary
#define kMTTiVoEnabled @"enabled"
#define kMTTiVoMediaKey @"mediaKey"
#define kMTTiVoUserName @"userName"
   //Manual Tivo's Only
#define kMTTiVoID @"id"
#define kMTTiVoIPAddress @"IPAddress"
#define kMTTiVoUserPort @"userPort"
#define kMTTiVoUserPortSSL @"userPortSSL"
#define kMTTiVoManualTiVo @"manualTiVo"
#define kMTTiVoNullKey @"00000000"


//Growl notification constants (see growlRegDict file)
#define kMTGrowlBeginDownload @"Begin Download"
#define kMTGrowlEndDownload   @"End Download"
#define kMTGrowlCantDownload  @"Can't Download"
#define kMTGrowlPossibleProblem  @"Possible Problem"
#define kMTGrowlCommercialDetFailed @"Commercial Detection Failed"
#define kMTGrowlTivodecodeFailed @"Tivodecode Failed"

//NOT IMPLEMENTED
#define kMTiTunesIcon @"iTunesIcon"                 // Whether to use video frame (versus cTivo logo) for iTUnes icon
#define kMTPostDownloadCommand @"PostDownloadCommand" // Example: "# mv \"$file\" ~/.Trash ;";

