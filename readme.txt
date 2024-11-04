Min iOS: 15
Arch: MVVM + Coordinator(Binding input/output with Async/Await) + Factory
UI: UIKit + SwiftUI
Request: URLRequest + Async/Await
Other tech: Combine
Collection: Compositional layout + DiffableDataSource

// Note
- MOVIE key does not exist in JSON, but if necessary, everything follows the same logic
- There is no name on the detailed screen, so I used the default one
- Used a skeleton while the content is loading in detail screen to create a nicer wait,
this could also be done on UIkit, but it would take more time
- I used Async/Await for more structured code and better handling of threads

