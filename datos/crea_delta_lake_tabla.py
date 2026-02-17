import polars as pl

pl.read_parquet(
	"hs92_country_country_product_year_6_2020_2024.parquet"
    ).write_delta("atlas")

