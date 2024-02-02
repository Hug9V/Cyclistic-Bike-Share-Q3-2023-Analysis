/*
Cleaning Data in SQL Queries
*/

Select *
From PortfolioProject.dbo.NashHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate
From PortfolioProject.dbo.NashHousing

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashHousing

Update NashHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashHousing
Add SaleDateConverted Date

Update NashHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashHousing
-- Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashHousing a
JOIN PortfolioProject.dbo.NashHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashHousing a
JOIN PortfolioProject.dbo.NashHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , 
LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashHousing

ALTER TABLE NashHousing
Add PropertySplitAddress Nvarchar(255);

Update NashHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,
CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashHousing
Add PropertySplitCity Nvarchar(255);

Update NashHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, 
CHARINDEX(',', PropertyAddress) + 1 , 
LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashHousing

Select OwnerAddress
From PortfolioProject.dbo.NashHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.NashHousing

ALTER TABLE NashHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashHousing
Add OwnerSplitCity Nvarchar(255);

Update NashHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashHousing
Add OwnerSplitState Nvarchar(255);

Update NashHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From PortfolioProject.dbo.NashHousing

--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant)
From PortfolioProject.dbo.NashHousing

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashHousing

Update NashHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

--find the duplicate record
select *
from PortfolioProject.dbo.NashHousing

select [owner name], count(*) 
from PortfolioProject.dbo.NashHousing
group by [owner name] having count(*) > 1

--then remove the duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashHousing
--order by ParcelID
)
select*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From PortfolioProject.dbo.NashHousing

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

ALTER TABLE PortfolioProject.dbo.NashHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From PortfolioProject.dbo.NashHousing









