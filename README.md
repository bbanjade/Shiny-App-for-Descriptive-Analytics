# Shiny-App-for-Descriptive-Analytics
Collection of Shiny Apps 

This folder got two analysis one for the traffic collision data from Los Angeles,CA and another for the Billboard hot 100 songs: 
1) Traffic Collision:
	- The data got area name, time of collision, and lattitude-longitude of the collision site.
	- 

2) Billboard Year-End Hot 100 Songs:
	- The data is from 1965 to 2015, with top 100 songs each year.
	- Data is about the ranking of each songs, song name, artist name, year, lyrics of the song, and source.
	- Libraries used are: shiny, ggplot2, dplyr, forcats, tm, wordcloud, & SnowballC.
	- The produced App created three tabs for these topics: 
	 	- Number of hit per rank
	 		- We can select rank from 1 to 100, and get the number of hits of the song per rank by bar chart.
		- lyrics-songs title chart
			- This tab got two histograms of top 70 most frequent words in 1) lyrics & 2) song titles according to changes in year.
			- We can see the change in pattern by changing year.
		- wordclouds of song title and lyrics
			- This tab got two wordclouds of top 500 words in 1) song titles  & 2) lyrics during 1965 to 2015.

