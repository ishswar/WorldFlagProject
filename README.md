# WorldFlagProject
World Flag Game

Sofar we ahve 


Flag practice part of Game  ( World Countries )  
============

* List of World Countries ( Alphabetically sorted ) ( List comes from disk - we read all the files and put their names in NSArray )
* Alphabetical index provided 
* Table view - Cell select go into Film strip mode ( left & right swipe quester supported )
* In film strip mode ( Horizontal scrolling view ) we show Flag of Country and Name of country - also info button - on tap of info button or country name label we push to next view ( Detail view ) 
* On click on “i” discolouser button we jump ( Push ) to next view - Detail view 
* on detail view we show - World Map - ( Current country ) shown on Map with Annotation ( Name + i discolouser )  
* Below map is UIWebview that loads data from Wiki about country ( UI Webview has “Close” & “Open in safari” top button - if user does browse to other links from loaded HTML Page we show “<“ and “>” buttons for browsing direction )
* UIWebview ( info view ) gets closed if user press “Close” button or taps outside of view .
* on map view if user taps ( 2+ seconds ) we find a coordinates and find that country and show info about that country 
