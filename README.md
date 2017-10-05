# Module One Final Project Guidelines

## CityYelp
CityYelp is a command line interface application that searches Yelp for cities within a distance and population range for a specific term. CityYelp will output the cities with the highest rating average for your search term.

For example, you could search for the best small cities within 100 miles of NYC for tacos. CityYelp will go through all of the taco places for each of the small cities around NYC and find an average rating. It'll sort the cities by best average rating for tacos and return them in order. After that, it'll return the top 5 best matches for the city that had the highest overall average.

Every time you make a search query with CityYelp, it will save the results for each city. You'll be able to lookup the average ratings for all of the search terms for that city. For example, you could search the Texas area for the city with the best tacos, ice cream, and museums. It will save the results and you could later lookup Dallas in the ratings table to find its ratings for tacos, ice cream, and museums.

### Installation

1. Clone the repository
2. Navigate to the directory
3. Run the following command

```bash
$ bundle install
```
4. Run the bin/run.rb file

```bash
$ ruby bin/run.rb
```

### Usage
When you start CityYelp, you enter a world where your desires and dreams come true and anything you want is at your fingertips #anythingispossible #cityyelpandyoullneednohelp

Below is an example interaction. The user will have two choices when they start the application. They can either:

```bash
1. New Search
2. Lookup Existing City
```

Search is the primary use of CityYelp. With it you can search for the city with the highest average for a search term.

When you select the New Search option, CityYelp will ask you for a city/town to set as your origin location.

```bash
Set your city:
New York NY
```

CityYelp will lookup all of the cities around that point. The city must be formatted with state at the end of it so it looks like the above query.

Next, you need to enter a search term. This can be any venue type that you ordinarily search on Yelp.

```bash
Give a term to search:
tacos
```

The search term could be food like "tacos" or "pizza" or services like "car repair."

After this, CityYelp will give you options for the population size of the city/town you're looking up.

```bash
Set a population range:
1. Small Town (< 1,000)
2. Town: (1,000 to 50,000)
3. Small City: (50,000 to 250,000)
4. City: (250,000 to 1,000,000)
5. Large City: (1,000,000+)
```
Select the number of the size parameter you'd like.

Next, enter your search radius. This is the number of miles to search around your origin city.

```bash
Set a distance radius:
500
```

After that, CityYelp will return a prompt indicating how many cities are currently within your parameters. If you find this to be too many or too few, you may write "N" to reselect your search parameters. Otherwise, write "Y"

```bash
There are 9 cities that are within 5000 miles of New York NY that are between 1000000 and 20000000 people.
Would you like to proceed with the search? Type 'Y' or 'N'.
```

CityYelp will make an API request to Yelp and process all of the data. After its retrieved the averages, it will print the number of cities and reviews it has looked through.

```bash
We searched through 9 cities and 455712 reviews.
```

After this, CityYelp prints the city that had the highest average rating for your search term within the parameters you specified.

```bash
Los Angeles CA is the best city for tacos in 5000 miles with a population between 1000000 and 20000000.
````

CityYelp will print an ordered list by rating of your search criteria.

````bash
1. Los Angeles CA has an average rating of 4.2885 out of 89416 reviews.

2. Phoenix AZ has an average rating of 4.2472 out of 34608 reviews.

3. San Diego CA has an average rating of 4.2252 out of 130624 reviews.
````

Lastly, CityYelp will return what Yelp has deemed the best matches within the highest rated city of your query. Below is an example for tacos within Los Angeles CA.


````bash
#1:
Name: Ave 26 Taco Stand
Rating: 5.0
Review Count: 523
Price: $

#2:
Name: Taqueria La Plebe and More
Rating: 4.5
Review Count: 52
Price: $
````

CityYelp then saves the results for average ratings in each city. If you want to find out the ratings a city has for terms already searched, choose the Lookup Existing City option at the first prompt.

````bash
1. New Search
2. Lookup Existing City
````

Just type in the city you would like to search, and CityYelp will return all of the previously searched terms for that city along with their average ratings and number of reviews.

````bash
Which city would you like to lookup existing ratings for?
Dallas TX
````

CityYelp will then return its search terms sorted by highest average rating. In the below example you can see that the highest average rating for Dallas is for the search term Car Repair.

````bash
Dallas TX

1. Car Repair
Average Rating: 4.4731
Sum of Reviews: 372


2. Arcades
Average Rating: 4.3639
Sum of Reviews: 588


3. Ice Cream
Average Rating: 4.1963
Sum of Reviews: 23920
````
