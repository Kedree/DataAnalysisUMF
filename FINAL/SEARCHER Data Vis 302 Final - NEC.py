# KEDREE PROFFITT FINAL DOCUMENTATION 8/1/2022 FOR CSC 302-W1 DATA VIS.
# Imports
import pandas as pd # For data frames
import requests # For accessing the NASA API
import json # For processing the NASA data received
from pathlib import Path # For saving to a csv on my computer
import time # Used for waiting for NEO query limit to be refreshed, now no longer needed for SBDB

sbdb = pd.read_csv("sbdb_query_results_NEC.csv", low_memory=False) # Take in SBDB website data

# Create counters for later and the primary DataFrame
counter = 0 # For printing how many asteroids have been searched
success = 0 # For printing how many asteroid searches were successful
skipNum = 0 # For printing how many asteroids were skipped primarily due to no CA data
missing = 0 # For printing how many asteroids could not be found in the SBDB, was used mostly for NEO testing
progressCheck = 0 # Keeps track of how many progress saves were made, used for file naming
completeData = pd.DataFrame() # The storage place for all collected data

for asteroid in sbdb['spkid']: # For every asteroid in our query
    counter += 1 # Add one to number of asteroids searched
#    if counter == 11:
#        break
    print("{} Attempted".format(counter)) # Print how many asteroids have been searched
    
    if asteroid != asteroid: # If the asteroid is null
        missing += 1 # Add one to missing
        print("Missing # ", missing) # Note the missing asteroid
        continue # Restart with the next asteroid
    # The next line is big, use request library to access NASA API, give it the asteroid to search, and set the optional data to true, more can be found on official website
    response = requests.get("https://ssd-api.jpl.nasa.gov/sbdb.api?spk="+str(int(asteroid))+"&anc-data=TRUE&ca-data=TRUE&ca-body=Earth")
    print(response.status_code) # Get the status code ie. 404 or 200 which is successful
    while response.status_code == 429: # If a 429 was received the query limit has been reached, while at that limit (Not needed for SBDB, used just in case):
        print("waiting...") # Notify of limit reached
        time.sleep(300) # Wait for 5 minutes, refreshes happen consistently, not all at once
        print("done waiting!") # Notify that 5 minutes is up and retry again below, if the result is still 429 stay in the while
        response = requests.get("https://ssd-api.jpl.nasa.gov/sbdb.api?spk="+str(int(asteroid))+"&anc-data=TRUE&ca-data=TRUE&ca-body=Earth")

    if response.status_code != 200: # If we did not get a 200 nor a 429 error code then:
        skipNum += 1 # Add one to skipped
        print("Skip #{} DUE TO ERROR CODE: {}".format(skipNum, response.status_code)) # Notify why it was skipped, insurance, was never used, just good practice
        continue # Then go on to the next asteroid
    else: # If it was a 200 then:
        todos = json.loads(response.text) # Store the NASA data as a json object
        approachData = pd.DataFrame(pd.json_normalize(todos['ca_data'])) # Take that json object and store it into a DataFrame after normalizing it

        if approachData.empty == True: # If there is no approach data, important note, search is given optional that restricts CA data to Earth only, no need to get rid of all other bodies, they are not passed
            skipNum += 1 # Add one to skip
            print("Skipping due to lack of CA data") # Notify of lack of CA data, was used about 200 times
            continue # Move on to next asteroid
        
        success += 1 # Add one to success counter
        
        approachData['spkid'] = int(asteroid) # Save the spkid to a column of the asteroid's close approach DataFrame, will be used to join SBDB website and SBDB SEARCHER data
        approachData = (approachData.sort_values(by=['dist'])).head(1) # Sort the CAs by their distance to Earth and take the lowest one
        approachData['key'] = 1 # Add a key to join to other parts of the JSON data, arbitrary
        
        objData = pd.DataFrame(pd.json_normalize(todos['object'])) # Save asteroid's object data to a dataframe after normalizing
        objData = objData[['kind']] # Take only the column named kind (AMO, ATE, etc.)
        objData['key'] = 1 # Add a key to be joined with approachData
        
        combinedDF = approachData.merge(objData,on='key') # Join the two dataFrames on the key
        combinedDF = combinedDF.drop('key', axis=1) # Delete the key column (axis = 1 = column)
      
        completeData = pd.concat([completeData, combinedDF]) # Add the asteroid dataframe to the list of dataframes up until now

    print("{} Succesful".format(success)) # Print a success message

#Once all asteroids in the list have been searched: Print success and give stats
print("OMG ITS DONE WITH:\n{}\tTOTAL SEARCHES\n{}\tSUCCESSES\n{}\tMISSING\n{}\tTOTAL SKIPS\nHOPEFULLY THESE EQUAL EACH OTHER: {} = {}".format(counter, success, missing, skipNum, counter, success+skipNum+missing))
print("Saving to file...") # Notify of saving data

filepath = Path('C:/Users/Kedree Proffitt/Downloads/NASA API JIG/finishedNEC.csv') # The file will be saved to this filepath
filepath.parent.mkdir(parents=True, exist_ok=True)  # ``

completeData.to_csv(filepath, index=False) # Save the complete list of data

print("Done Saving! Congrats!!") # Print the file closer message
