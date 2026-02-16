#!/bin/bash
wget -O hs92_country_country_product_year_6_2020_2024.csv https://dataverse.harvard.edu/api/access/datafile/13438139
duckdb -c "COPY (SELECT * FROM read_csv_auto('hs92_country_country_product_year_6_2020_2024.csv')) TO 'hs92_country_country_product_year_6_2020_2024.parquet' (FORMAT PARQUET);"
