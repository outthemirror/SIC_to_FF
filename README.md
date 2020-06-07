# Converting SIC codes into FF industries
The helper function `all_FF_numbers()` prints all valid industry classfifications (5, 10, 12, 17, 30, 38, 48, 49).


The main function `SIC_to_FF(FF_number)` generates a dataframe mapping sic codes to Fama-French industries. For example, `SIC_to_FF(48)` produces a dataframe like this:

| ind_number  | ind_short | ind_desp | SIC_start | SIC_end| SIC_desp|
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| 1  | Agric| Agriculture | 100 | 199| Agric production - crops|
| 1  | Agric| Agriculture | 200 | 299| Agric production - livestock|
