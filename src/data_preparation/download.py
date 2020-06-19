import pandas as pd
import os
import kaggle
kaggle.api.authenticate()

# downloads data from kaggle
# unzip and store three data files in data
print("Downloading datasets")
kaggle.api.dataset_download_files(
    'airbnb/boston', path='data', unzip=True)

print("Exporting datasets to Excel")
# import of CSV files into STATA may be buggy; transfer via Excel is safer
for fn in ['listings', 'reviews']:
    print('   ' + fn + '...')
    dat = pd.read_csv('data/' + fn + '.csv')
    dat.to_excel('data/' + fn + '.xlsx')
    os.remove('data/' + fn + '.csv')
