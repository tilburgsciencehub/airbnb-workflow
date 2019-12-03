# %%
import pandas as pd
import kaggle
kaggle.api.authenticate()

# %%
# downloads data from kaggle
# unzip and store three data files in input
kaggle.api.dataset_download_files(
    'airbnb/boston', unzip=True)

# %%
# calendar = pd.read_csv('preclean/input/calendar.csv')
# calendar.to_excel('preclean/input/calendar.xlsx')


# %%
listings = pd.read_csv('listings.csv')
listings.to_excel('listings.xlsx')


# %%
reviews = pd.read_csv('reviews.csv')
reviews.to_excel('reviews.xlsx')

# %%
