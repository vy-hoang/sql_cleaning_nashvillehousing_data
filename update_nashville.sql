SELECT * FROM nashville_housing.nashville_housing_data;

/* UPDATE all emty value to null */

UPDATE nashville_housing.nashville_housing_data
SET uniqueid = IF(uniqueid = '', NULL, uniqueid),
	parcelid = IF(parcelid = '', NULL, parcelid),
    landuse = IF(landuse = '', NULL, landuse),
    propertyaddress = IF(propertyaddress = '', NULL, propertyaddress),
    saledate = IF(saledate = '', NULL, saledate),
    saleprice = IF(saleprice = '', NULL, saleprice),
    legalreference = IF(legalreference = '', NULL, legalreference),
    soldasvacant = IF(soldasvacant = '', NULL, soldasvacant),
    ownername = IF(ownername = '', NULL, ownername),
    owneraddress = IF(owneraddress = '', NULL, owneraddress),
    acreage = IF(acreage = '', NULL, acreage),
    taxdistrict = IF(taxdistrict = '', NULL, taxdistrict),
    landvalue = IF(landvalue = '', NULL, landvalue),
    buildingvalue = IF(buildingvalue = '', NULL, buildingvalue),
    totalvalue = IF(totalvalue = '', NULL, totalvalue),
    yearbuilt = IF(yearbuilt = '', NULL, yearbuilt),
    bedrooms = IF(bedrooms = '', NULL, bedrooms),
    fullbath = IF(fullbath = '', NULL, fullbath),
    halfbath = IF(halfbath = '', NULL, halfbath);
    
    
    /*testing if missing propertyaddress is matched with any parcelid */
    
    SELECT a.parcelid, a.propertyaddress, b.parcelid test1, b.propertyaddress test2 FROM nashville_housing.nashville_housing_data a
JOIN nashville_housing.nashville_housing_data b
ON a.parcelid = b.parcelid
WHERE  a.propertyaddress IS NULL;


/* update the matches */

UPDATE nashville_housing.nashville_housing_data a
JOIN nashville_housing.nashville_housing_data b
ON a.parcelid = b.parcelid
SET a.propertyaddress = IFNULL(NULL, b.propertyaddress)
WHERE  a.propertyaddress IS NULL;

/* update date format */

UPDATE nashville_housing.nashville_housing_data
SET saledate = str_to_date(saledate, '%M %d, %Y');

/* update format of soldasvacant */

UPDATE nashville_housing.nashville_housing_data
SET
	soldasvacant = CASE  
WHEN soldasvacant = 'N' THEN 'No'
WHEN soldasvacant = 'Y' THEN 'Yes'
ELSE soldasvacant END;

/*Add columns for seperated property_address, anf owner_address*/

ALTER TABLE nashville_housing.nashville_housing_data
ADD column( property_address VARCHAR(255),
			property_city VARCHAR(255),
            owner_address VARCHAR(255),
            owner_address_city VARCHAR(255),
            owner_address_state VARCHAR(255)
            );
            
/* update and seperate property_address and owner_address for more details */
            
UPDATE nashville_housing.nashville_housing_data
SET property_address = substring_index(propertyaddress, ',', 1),
	property_city = substring_index(propertyaddress, ',', -1),
    owner_address = substring_index(owneraddress, ',', 1),
    owner_address_city = substring_index(substring_index(owneraddress, ',', 2), ',', -1),
    owner_address_state = substring_index(owneraddress, ',', -1)
    ;
