import os
import pandas as pd
import matplotlib.pyplot as plt

# Set working directory explicitly
os.chdir("/Users/barbiejindal/Desktop/EV_Adoption_Project")

# Load data exported from SAS
ev_by_year = pd.read_csv("ev_by_year.csv")

print(ev_by_year.head())

/usr/local/bin/python3 /Users/barbiejindal/Desktop/EV_Adoption_Project/ev_adoption_python_analysis.py
