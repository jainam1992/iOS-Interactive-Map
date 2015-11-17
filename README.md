# iOS-Interactive-Map
 An iOS application where user can search and find distance and time estimation to reach destination.
 
Features implemented are:

1)  Used Static SJSU Campus Map image. (Not Google or Apple maps available in the market). 

2.) Zoom in/out: User will be able to pinch to zoom in/out on our map. The zoom level will remain persistent; i.e., after you restart our app, the user sees the same zoom level where he had left it.

3.) Building detail: A screen with the selected building detail is presented when user taps on a specific building on our map. User will see page with following details:
   ->  Building name
   ->  Address
   -> Walking distance and time from users current location to the building
We have used Google API to retrieve the distance & time estimation from current location to destination building.

4.) Search: Allows user to search by building name and the found building is highlighted and centered on the map at zoom level 100%. 
