CREATE DATABASE Electronic_Retailer;
USE Electronic_Retailer;

SHOW GLOBAL VARIABLES LIKE 'LOCAL_INFILE';

-- Import Customers Table
CREATE TABLE IF NOT EXISTS `customers` (
    `customerkey` INT NULL,
    `gender` VARCHAR(50) NULL,
    `name` VARCHAR(50) NULL,
    `city` VARCHAR(150) NULL,
    `state_code` VARCHAR(50) NULL,
    `state` VARCHAR(150) NULL,
    `zip_code` INT NULL,
    `country` VARCHAR(100) NULL,
    `continent` VARCHAR(50) NULL,
    `birthday` DATE NULL
);

LOAD DATA LOCAL INFILE 'D:/Mission/Global+Electronics+Retailer/Dataset/Customers.csv'
INTO TABLE customers
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    @v_customerkey,
    @v_gender,
    @v_name,
    @v_city,
    @v_state_code,
    @v_state,
    @v_zip_code,
    @v_country,
    @v_continent,
    @v_birthday
)
SET
    customerkey = NULLIF(TRIM(@v_customerkey), ''),
    gender = NULLIF(TRIM(@v_gender), ''),
    name = NULLIF(TRIM(@v_name), ''),
    city = NULLIF(TRIM(@v_city), ''),
    state_code = NULLIF(TRIM(@v_state_code), ''),
    state = NULLIF(TRIM(@v_state), ''),
    zip_code = NULLIF(TRIM(@v_zip_code), ''),
    country = NULLIF(TRIM(@v_country), ''),
    continent = NULLIF(TRIM(@v_continent), ''),
    birthday = STR_TO_DATE(
        NULLIF(TRIM(@v_birthday), ''),
        '%m/%d/%Y'
    );

SELECT * FROM customers;

-- Import exchange_rates Table
CREATE TABLE IF NOT EXISTS `exchange_rates` (
    `date` DATE NULL,
    `currency` VARCHAR(50) NULL,
    `exchange` DECIMAL(15,2) NULL
);

LOAD DATA LOCAL INFILE 'D:/Mission/Global+Electronics+Retailer/Dataset/Exchange_Rates.csv'
INTO TABLE `exchange_rates`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    @v_date,
    @v_currency,
    @v_exchange
)
SET
    `date` = STR_TO_DATE(NULLIF(TRIM(@v_date), ''), '%m/%d/%Y'),
    `currency` = NULLIF(TRIM(@v_currency), ''),
    `exchange` = NULLIF(TRIM(@v_exchange), '');

SELECT * FROM exchange_rates;

-- Import products Table
CREATE TABLE IF NOT EXISTS `products` (
    `productkey` INT NULL,
    `product_name` VARCHAR(200) NULL,
    `brand` VARCHAR(50) NULL,
    `color` VARCHAR(50) NULL,
    `unit_cost_usd` VARCHAR(50) NULL,
    `unit_price_usd` VARCHAR(50) NULL,
    `subcategorykey` INT NULL,
    `subcategory` VARCHAR(50) NULL,
    `categorykey` INT NULL,
    `category` VARCHAR(50) NULL
);

LOAD DATA LOCAL INFILE 'D:/Mission/Global+Electronics+Retailer/Dataset/Products.csv'
INTO TABLE `products`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    @v_productkey,
    @v_product_name,
    @v_brand,
    @v_color,
    @v_unit_cost_usd,
    @v_unit_price_usd,
    @v_subcategorykey,
    @v_subcategory,
    @v_categorykey,
    @v_category
)
SET
    `productkey` = NULLIF(TRIM(@v_productkey), ''),
    `product_name` = NULLIF(TRIM(@v_product_name), ''),
    `brand` = NULLIF(TRIM(@v_brand), ''),
    `color` = NULLIF(TRIM(@v_color), ''),
    `unit_cost_usd` = NULLIF(TRIM(@v_unit_cost_usd), ''),
    `unit_price_usd` = NULLIF(TRIM(@v_unit_price_usd), ''),
    `subcategorykey` = NULLIF(TRIM(@v_subcategorykey), ''),
    `subcategory` = NULLIF(TRIM(@v_subcategory), ''),
    `categorykey` = NULLIF(TRIM(@v_categorykey), ''),
    `category` = NULLIF(TRIM(@v_category), '');

SELECT * FROM products;

UPDATE products
SET unit_price_usd = replace(unit_price_usd, '$', '');

UPDATE products
SET unit_price_usd = replace(unit_price_usd, ',', '');

ALTER TABLE products
MODIFY COLUMN unit_price_usd DECIMAL(10, 2) NULL;

-- Import sales TABLE
CREATE TABLE IF NOT EXISTS `sales` (
    `order_number` INT NULL,
    `line_item` INT NULL,
    `order_date` DATE NULL,
    `delivery_date` DATE NULL,
    `customerkey` INT NULL,
    `storekey` INT NULL,
    `productkey` INT NULL,
    `quantity` INT NULL,
    `currency_code` VARCHAR(50) NULL
);

LOAD DATA LOCAL INFILE 'D:/Mission/Global+Electronics+Retailer/Dataset/Sales.csv'
INTO TABLE `sales`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    @v_order_number,
    @v_line_item,
    @v_order_date,
    @v_delivery_date,
    @v_customerkey,
    @v_storekey,
    @v_productkey,
    @v_quantity,
    @v_currency_code
)
SET
    `order_number` = NULLIF(TRIM(@v_order_number), ''),
    `line_item` = NULLIF(TRIM(@v_line_item), ''),
    `order_date` = STR_TO_DATE(NULLIF(TRIM(@v_order_date), ''), '%m/%d/%Y'),
    `delivery_date` = STR_TO_DATE(NULLIF(TRIM(@v_delivery_date), ''), '%m/%d/%Y'),
    `customerkey` = NULLIF(TRIM(@v_customerkey), ''),
    `storekey` = NULLIF(TRIM(@v_storekey), ''),
    `productkey` = NULLIF(TRIM(@v_productkey), ''),
    `quantity` = NULLIF(TRIM(@v_quantity), ''),
    `currency_code` = NULLIF(TRIM(@v_currency_code), '');
    
-- Import stores TABLE
CREATE TABLE IF NOT EXISTS `stores` (
    `storekey` INT NULL,
    `country` VARCHAR(100) NULL,
    `state` VARCHAR(200) NULL,
    `square_meters` INT NULL,
    `open_date` DATE NULL
);

LOAD DATA LOCAL INFILE 'D:/Mission/Global+Electronics+Retailer/Dataset/Stores.csv'
INTO TABLE `stores`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    @v_storekey,
    @v_country,
    @v_state,
    @v_square_meters,
    @v_open_date
)
SET
    `storekey` = NULLIF(TRIM(@v_storekey), ''),
    `country` = NULLIF(TRIM(@v_country), ''),
    `state` = NULLIF(TRIM(@v_state), ''),
    `square_meters` = NULLIF(TRIM(@v_square_meters), ''),
    `open_date` = STR_TO_DATE(NULLIF(TRIM(@v_open_date), ''), '%m/%d/%Y');


