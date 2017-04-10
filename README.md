# today-football
Swift 3.0, Xcode 8.xx

My homeproject app for showing football results using some free demo API. Neither API, neither app are perfect, but I'm still working on it. Perhaps it would grow into something bigger and useful.

I didn't use some popular frameworks like AFNetworking or Alamo because wanted to understood how it can be done with native iOS tools and also API uses .svg format for teams logo, so I'm using SVGKit which likely wouldn't work with mentioned frameworks anyway.

Technologies:
- work with framework SVGKit for parsing .svg files into UIImages (not perfect and consume lot of recources, but working);
- fetch and parse JSON data using api.football-data.org;
- create some smart requests to lower number of requests (w/o registration only 50 request per day, but that should be enough for demo purpose);
- use quite elaborate technique for fetching teams logo and smoothly put it in the table;
- caching data;
- quite deep work with iOS UITableView, using sections, prefetching, customizing cells, etc.
- use GCD and NSOperations.

![ft3-7](https://cloud.githubusercontent.com/assets/23110283/24841992/f50f4210-1d98-11e7-927c-76390a500531.png)
![ft3-8](https://cloud.githubusercontent.com/assets/23110283/24841978/c60de6ce-1d98-11e7-9cf0-a8f021381cef.png)
![ft3-9](https://cloud.githubusercontent.com/assets/23110283/24841981/d01ee546-1d98-11e7-945b-c2942f382b4b.png)