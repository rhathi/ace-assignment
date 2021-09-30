## This program parses the input JSON file and
## and prints the output data in the tabular format
## after performing a join on collections
## and printing every records associated with the collection

## Tabulate module is used to format the output
## in a simple table form. Pandas module is used
## to perform read, parse and output the JSON data

from tabulate import tabulate
import pandas
import json

input_file = "sample.json"
output_file = "output.txt"

## Open and read the JSON data from the input file
f = open(input_file)
data = json.load(f)
f.close();

## Extract the actual data
data = [ {'Id': item['id'], 'Type': item['type'], 'Name': item['name'], 'Batter': item['batters']['batter'], 'Topping': item['topping'] } for item in data['items']['item'] ]

## Flatten the data using normalize function
## You have to invoke normalize function for every collection
## As the data has two collections viz. Batters and Toppings
## we will have flattend data stored in two separate data frame objects

df1 = pandas.json_normalize(data, "Batter", ["Id", "Type", "Name"] )
df2 = pandas.json_normalize(data, "Topping", ["Id"] )

## Merge the above two data frames on the ID column
## This is like performing join on two datasets
df = df1.merge(df2, on=['Id'])

## Arrange the columns
df = df[ ['Id', 'Type', 'Name', 'type_x', 'type_y'] ]

## Rename the columns to give it a custom name
df = df.rename(columns={'type_x': 'Batter', 'type_y': 'Topping'})

## Write the output in the table form
## in a file (output.txt)
f = open(output_file, 'w')
f.write(df.to_markdown(index=False))
f.close

## Also write the output on the console
print(df.to_markdown(index=False))
