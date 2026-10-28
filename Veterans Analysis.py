#import libraries and inital csv

import pandas as pd

df = pd.read_csv("/Users/hershoza/Downloads/veterans_with_veteran_population.csv")

#brief analysis of initial csv 

print(df.shape)
print(df.info())
print(df.describe())
print(df.isnull().sum())
print(df.duplicated().sum())

df["Total: Disability Compensation Recipients"] = (
     pd.to_numeric(df["Total: Disability Compensation Recipients"], errors="coerce")
)

state_analysis = (
    df.groupby("State")["Total: Disability Compensation Recipients"]
    .mean()
    .round()
    .astype("Int64")
)
print(state_analysis)

#changing the inital csv

df = df.drop(columns=["State Veteran Population", "Male", "Female"])

df = df.rename(columns={"State": "States/Territories", "County Name": "County", "Total: Disability Compensation Recipients": "Disability Compensation Recipients by County",
                        "SCD rating: 0% to 20%": "0-20% SCD rating", "SCD rating: 30% to 40%": "30-40% SCD rating",
                        "SCD rating: 50% to 60%": "50-60% SCD rating", "SCD rating: 70% to 90%": "70-90% SCD rating",
                        "SCD rating: 100%": "100% SCD rating", "Age: 17-44": "Ages 17-44", "Age: 45-64": "Ages 45-64", "Age: 65 or older": "Ages 65+"}
)

#exporting changes as a new csv

df.to_csv("/Users/hershoza/Downloads/Veterans_Analysis.csv")