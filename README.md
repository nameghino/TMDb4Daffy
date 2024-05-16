# MyIMDB
(I realized too late that I was using TMDB, the name stuck)

## Build instructions
- Set team in Xcode
- Add the API key to the correspoding Info.plist key
- Key should be securely distributed, but here it is for now: "64d6f9d58986479ed820fc6a6bdd547b"
- Xcode should resolve the TMDb dependency
- Build & Run

## Usage
App will start to an empty collection view
Type a search query and select a scope, then tap the Search button (or press Enter)
Results will appear in the collection view. Tapping on a result will lead to a detail view.

## Room for improvement and known issues
- Testing! 
- Currently the app fetches the first page of results only. Paging could be implemented using a prefetching data source.
- I'm using a plain old data source and not the modern diffable one.
- Fetching poster images for the search results view.
- Not using any form of caching. CoreData or SwiftData could be used to store data locally and avoid repeated network fetches.
- Last but not least, as you'll see, graphic design is my passion. UI design is lacking.
