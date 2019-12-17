import pandas as pd
import os
import kaggle
kaggle.api.authenticate()

# downloads data from kaggle
# unzip and store three data files in input
print("Downloading datasets")
kaggle.api.dataset_download_files(
    'airbnb/boston', path='../input', unzip=True)

print("Exporting datasets to Excel")

for fn in ['listings', 'reviews']:
    print('   ' + fn + '...')
    dat = pd.read_csv('../input/'+ fn + '.csv')
    dat.to_excel('../input/'+ fn + '.xlsx')
    os.remove('../input/'+ fn + '.csv')
