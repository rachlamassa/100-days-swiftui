# Day 19: Challenge Day

*Using what I've learned from 'WeSplit' I was tasked with creating a new app on my own, converting any units of my choosing. The app is called 'TempConversion'* 

The user inputs a temperature through a TextField using a .decimalPad and chooses the specific unit from a Picker with a .segmented layout, which is then converted to another unit the user chooses with a separate Picker. For readability I decided to create a TempUnit enum and create a string variable called label that would be used for the View. The convert function takes the user's input, converts the input unit to Celsius, and then converts that to the output unit. The input and output are separated by Sections with navigation titles to guide the user. I also used the .toolbar modifier from 'WeSplit' to dismiss the decimal pad.
