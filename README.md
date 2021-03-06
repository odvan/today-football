# today-football
Swift 3.0, Xcode 8.xx || all iPhones

Homeproject app for showing football results using football-data.org API. Perhaps it would grow into something bigger and useful.

Results and fixtures are from top-5 football national leagues: English Premiere League, Spanish La Liga, Italian Serie A, German Bundesliga, French Ligue 1 and European Champions League.

I didn't use some popular frameworks like AFNetworking or Alamo because wanted to understood how it can be done with native iOS tools and also API uses .svg format for teams logo, so I'm using SVGKit which likely wouldn't work with mentioned frameworks anyway.

Technologies:
- MVVM pattern;
- work with framework SVGKit for parsing .svg files into UIImages (not perfect and consume lot of recources, but working);
- fetch and parse JSON data from api.football-data.org;
- create some smart methods to lower number of requests (w/o registration only 50 request per day, but that should be enough for demo purpose);
- use quite elaborate technique for fetching teams logo and smoothly put it in the table;
- caching data;
- deep work with iOS UITableView, using sections, prefetching, customizing cells, etc.
- GCD and NSOperations usage.

PS Since European seasons 2017-2018 started app uses new endpoints.

![footballdemo-02-2](https://cloud.githubusercontent.com/assets/23110283/26798273/86aa0ff4-4a38-11e7-8444-eb7e637a3422.gif)

*****
Live results look:

![22 may](https://cloud.githubusercontent.com/assets/23110283/26800293/740abed0-4a41-11e7-9898-40c30fe73e27.png)

Added settings: competitions to follow
![ft_newbutton](https://user-images.githubusercontent.com/23110283/27452771-873b0cf4-579c-11e7-9f6b-a049107fb4fd.png)

![ft_settings](https://user-images.githubusercontent.com/23110283/27452773-88910f40-579c-11e7-9c9b-90f6c39c9416.png)

Leagues table look:
![ft_table](https://user-images.githubusercontent.com/23110283/27887226-48aeccf4-61e8-11e7-9f39-9ce90ac5f6e9.png)

Match details look (stats and info only demo, API doesn't provide detailed stats yet):
![ft_matchdetails8](https://user-images.githubusercontent.com/23110283/27887251-76498e6a-61e8-11e7-9766-113cf7e7f891.png)

Added UISplitController, now it splitting screen on iPhones Plus:
![ft_splitvciphone](https://user-images.githubusercontent.com/23110283/27887229-4bd06b0e-61e8-11e7-8e5d-a98942c61fdc.png)

