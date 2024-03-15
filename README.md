# winch

This shell script was made for the 3PS winch moitoring system on Atlantis. It could be edited to match the LCi90's data outputs as well. It will create a single txt file where each line is a row of raw data for all values above an argument in a certain row. For the formatting aboard atlantis the row of tension data is 4, you can change it to whatever makes the most sense for your own raw data files. The shell script only looks at data in hour long intervals as the raw data is recorded. 

I've been running this script at the end of each cruise. It takes about 2 hours to parse through a whole cruises data.
