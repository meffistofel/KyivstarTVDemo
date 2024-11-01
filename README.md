# KyivstarTV Demo
# Hello! 

This test briefly touches on key aspects of working in our iOS team, so try your best 😉 

You need to do this layout:

<img src="https://i.imgur.com/tdXjea6.png" width="750" height="430">
https://www.figma.com/file/6yVcKC9OJLeE4CUojqlQWe/Untitled?type=design&mode=design&t=9JbZpIuEDmbW3Oho-1

It contains content groups with assets and asset page with some simple logic. 

#### Required:
1. Home screen
2. Transition from UIKit home screen to SUI asset details screen
3. Simple Asset Details screen with image, buttons and title

#### Optional:
1. Asset details screen according to figma design, marked as optional


You can do only required section, or required and optional sections.


#### You must use:

0. UIKit + SwiftUI
1. MVVM+C
2. Combine for binding
3. Diffable Data Source and Compositional Layout in UIKit page
4. Lowest iOS version have to be 14.0

Any other technics and mechanics - on your choice.
Would be a plus if you will use modern concurency methods.

### API Details
Network setup is attached inside postman collection. Feel free to import it.

Bearer Token: `b3kgsqs1kqytlpact6fhh6pd8grvdj7kqm0nkvd1`

All necessary requests and headers with tokens are stored there. 

When loading list of content groups please pay attention on content group type. We need to show only this ones: 

`
MOVIE, SERIES, LIVECHANNEL, EPG
`

And depending on type - we need to build different layout (more details in figma)

Basic required flow:

1. User opens application.
2. Network calls start to load information. [Optional]: You can create skeletons if you want - it's not required.
3. When some of the data is loaded - user starts to see it on screen.
4. User can see progress bar under asset image, if progress > 0
5. User can tap Del button - which will remove content group from screen if canBeDeleted flag of contentGroup is set to true
6. User can tap on any asset and open SwiftUI asset details page with title, image and back button. 

Additional flow, not required, but will be a plus - Asset Details Page:
1. Make network call to load asset details
2. Populate data from network call into UI
3. Pay attention on UI in figma, how it have to work

No storyboards, xib files and localizations. 
Use system default fonts, just take care of bold/regular weight. 


You have to create a fork from this repository and then create pull request here.
The best solution will be pushed into main repository - so everyone can know something new.

GL HF.

p.s. If you have any questions(maybe some endpoints stoped working, dead tokens, flow is not clear), feel free to create issues inside this repository, we'll try to react quickly.
