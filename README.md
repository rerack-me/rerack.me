rerack.me
=========

people
------
+ Santhosh Narayan
+ Victor Pontis
+ David Sessoms
+ Sashko Stubailo


overview
--------

`rerack.me` allows pong players to create an account and track their pong history. The website allows players to log games using other players unique usernames and track their automatically generated ranking. The ranking system is a modified version of the ELO algorithm which bases the number of points a player earns from each game on the relative points of those playing (vs a player with more points, earn more points). Players also have the ability to create and be added to groups. These groups allow for players to quickly view the ranking of select friends within that subset. 

###Access site in production: 

1. Go to rerack.me  
2. Sign-in/up for the website  
3. Let your Pong legacy live on forever

###How to run locally
1. Clone repository  
2. bundle install  
3. rake db:create
4. rake db:seed
3. rake db:migrate  
>>>>>>> master


contact us
----------
You can send us a line at [team@rerack.me](mailto:team@rerack.me) if you have any questions or comments.
