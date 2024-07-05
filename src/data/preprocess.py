
def assign_quartile(value, quartiles):
    'Function to categorize values into quartiles'
    if value <= quartiles[0]:
        return 1
    elif value <= quartiles[1]:
        return 2
    elif value <= quartiles[2]:
        return 3
    else:
        return 4