SELECT TOP (1000) [UniqueID]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio Project].[dbo].[NashvilleHousing]

 --running all data
 SELECT*
 from [Portfolio Project]..NashvilleHousing

/*

Cleaning Data in SQL Queries

*/

 SELECT*
 from [Portfolio Project]..NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

 SELECT saledate, CONVERT(Date, saledate)
 from [Portfolio Project]..NashvilleHousing

 UPDATE NashvilleHousing
 SET SleDate = CONVERT (date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT (date, SaleDate)

-- If it doesn't Update properly





 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
SELECT * 
 from [Portfolio Project]..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress) 
 from [Portfolio Project]..NashvilleHousing a
 JOIN [Portfolio Project]..NashvilleHousing b
	On a.parcelID = b.parcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.propertyaddress is NULL

Update a
SET Propertyaddress =  ISNULL(a.propertyaddress, b.PropertyAddress) 
 from [Portfolio Project]..NashvilleHousing a
 JOIN [Portfolio Project]..NashvilleHousing b
	On a.parcelID = b.parcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
 from [Portfolio Project]..NashvilleHousing
--Where PropertyAddress is null

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as adddress
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) as adddress
 from [Portfolio Project]..NashvilleHousing

 ALTER TABLE NashvilleHousing
 Add PropertySplitAddress nvarchar(255);

 Update NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

 ALTER TABLE NashvilleHousing
 Add PropertySplitCity nvarchar(255);

 Update NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))

 

  Select*
  from [Portfolio Project]..NashvilleHousing


 Select owneraddress
 from [Portfolio Project]..NashvilleHousing

 Select
 PARSENAME (replace(owneraddress, ',', '.') , 3),
  PARSENAME (replace(owneraddress, ',', '.') , 2),
   PARSENAME (replace(owneraddress, ',', '.') , 1)
  from [Portfolio Project].dbo.NashvilleHousing

 ALTER TABLE NashvilleHousing
 Add OwnerSplitAddress nvarchar(255);

 Update NashvilleHousing
 SET OwnerSplitAddress = PARSENAME (replace(owneraddress, ',', '.') , 3)

 ALTER TABLE NashvilleHousing
 Add OwnerSplitCity nvarchar(255);

 Update NashvilleHousing
 SET OwnerSplitCity = PARSENAME (replace(owneraddress, ',', '.') , 2)

 ALTER TABLE NashvilleHousing
 Add OwnerSplitState nvarchar(255);

 Update NashvilleHousing
 SET OwnerSplitState = PARSENAME (replace(owneraddress, ',', '.') , 1)

Select *
 from [Portfolio Project]..NashvilleHousing


-------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select  Distinct(soldasvacant), count(soldasvacant)
from [Portfolio Project].dbo.NashvilleHousing
Group by soldasvacant
order by 2

Select soldasvacant, 
case when soldasvacant = 'Y' Then 'Yes'
when soldasvacant = 'N' Then 'No'
else Soldasvacant
End
from [Portfolio Project].dbo.NashvilleHousing

Update NashvilleHousing
Set SoldasVacant = case when soldasvacant = 'Y' Then 'Yes'
when soldasvacant = 'N' Then 'No'
else Soldasvacant
End
from [Portfolio Project].dbo.NashvilleHousing


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS (
SELECT*, 
	Row_Number () Over (
	PARTITION BY ParcelID, 
				PropertyAddress, 
				SalePrice, 
				SaleDate, 
				LegalReference
				ORDER BY ParcelID
				) AS row_num
FROM [Portfolio Project].dbo.NashvilleHousing
)
SELECT*
FROM RowNumCTE
WHERE Row_Num > 1



SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing

--order by ParcelID






---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT*
FROM [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COlUMN PropertyAddress, OwnerAddress, TaxDistrict



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO



