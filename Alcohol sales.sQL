SELECT * FROM`bigquery-public-data.iowa_liquor_sales.sales` limit 5;
# Nuber of vendor name store number, store name_cities & cities

SELECT   Count(distinct vendor_name) as Unique_vendor,
         Count(distinct store_name) as Unique_store,
        Count(distinct city) as Unique_cities
        FROM`bigquery-public-data.iowa_liquor_sales.sales`;
        
## Volumeof liquor sold stats!!!
SELECT  min(volume_sold_liters) as MInimum_Litres_Sold,
        max(volume_sold_liters) as Maximum_Litres_Sold,
        avg(volume_sold_liters) as mean_Litres_Sold,
        sum(volume_sold_liters) as Total_Litres_Sold,

        min(volume_sold_gallons) as MInimum_gallons_Sold,
        max(volume_sold_gallons) as Maximum_gallons_Sold,
        avg(volume_sold_gallons) as mean_gallons_Sold,
        sum(volume_sold_gallons) as Total_gallons_Sold
        FROM`bigquery-public-data.iowa_liquor_sales.sales`

# Sales of Alcohol Categories and year wise 
SELECT 
      category_name as categories,
      sum(sale_dollars) as total_sales,
      extract (YEAR from date) as year,
      FROM`bigquery-public-data.iowa_liquor_sales.sales`
      where sale_dollars in (SELECT sum(sale_dollars)
      FROM`bigquery-public-data.iowa_liquor_sales.sales`
      group by category_name)
      group by categories,year
      order by year asc;
      
# Creating a new column of profit which is not present and finding if profit change overtime!!
SELECT 
      city as Cities,
      safe_divide(safe_multiply(state_bottle_cost,bottles_sold),safe_multiply(bottles_sold,bottle_volume_ml)) as cost_per_ML,
      Safe_divide(safe_multiply(state_bottle_retail,bottles_sold),safe_multiply(bottles_sold,bottle_volume_ml)) as Retail_Selling_ML,
      Safe_divide(safe_multiply(state_bottle_retail,bottles_sold),safe_multiply(bottles_sold,bottle_volume_ml))-safe_divide(safe_multiply(state_bottle_cost,bottles_sold),safe_multiply(bottles_sold,bottle_volume_ml)) as Profit_ml,  
      extract (YEAR from date) as year,
      FROM`bigquery-public-data.iowa_liquor_sales.sales`
      where Safe_divide(safe_multiply(state_bottle_retail,bottles_sold),safe_multiply(bottles_sold,bottle_volume_ml))-safe_divide(safe_multiply(state_bottle_cost,bottles_sold),safe_multiply(bottles_sold,bottle_volume_ml)) in (SELECT sum(Safe_divide(safe_multiply(state_bottle_retail,bottles_sold),safe_multiply(bottles_sold,bottle_volume_ml))-safe_divide(safe_multiply(state_bottle_cost,bottles_sold),safe_multiply(bottles_sold,bottle_volume_ml)))
      FROM`bigquery-public-data.iowa_liquor_sales.sales`
      group by city)
      group by Cities,cost_per_ML,Retail_Selling_ML,Profit_ml,year
      order by Cities desc, year asc ;
      
      
