-- Cleaning Nashville Housing data within SQL Queries  

Use Nashville_Housing_Project
Select*
from Nashville_Housing

-- Standardize date format-----------------------

Select SaleDate, CONVERT(Date, SaleDate)
from Nashville_Housing

Update Nashville_Housing
Set	SaleDate = CONVERT(Date, SaleDate)
-- Update function won't work. I used Alter Table Function as Alternative

Select SaleDate
from Nashville_Housing

Alter Table Nashville_Housing
Add SaleDateConverted Date; 


Update Nashville_Housing
Set SaleDateConverted = CONVERT(date, SaleDate)

Select SaleDateConverted
from Nashville_Housing	

-- Populate Property Address-------------------- 

Select PropertyAddress
from Nashville_Housing


Select PropertyAddress
from Nashville_Housing
Where PropertyAddress is null

Select *
from Nashville_Housing
order by ParcelID

-- Every ParcelID is linked to a single Property Address

select a.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress
From Nashville_Housing A
Join Nashville_Housing B
	on A.ParcelID = B.ParcelID
	and A.[UniqueID ] <> B.[UniqueID ]
Where A. PropertyAddress is Null

select a.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
From Nashville_Housing A
Join Nashville_Housing B
	on A.ParcelID = B.ParcelID
	and A.[UniqueID ] <> B.[UniqueID ]
Where A. PropertyAddress is Null

--Update to Table A to have correct column

Update A
Set PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
From Nashville_Housing A
Join Nashville_Housing B
	on A.ParcelID = B.ParcelID
	and A.[UniqueID ] <> B.[UniqueID ]
	Where A. PropertyAddress is Null

	-- Seperate Address information into seperate columns------------

Select PropertyAddress
from Nashville_Housing

select 
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)- 1) as Address
, substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+ 1, LEN(PropertyAddress))as Address
from Nashville_Housing

Alter Table Nashville_Housing
Add PropertySplitAddress Nvarchar(255); 


Update Nashville_Housing
Set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)- 1)

Alter Table Nashville_Housing
Add PropertySplitCity Nvarchar(255); 


Update Nashville_Housing
Set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+ 1, LEN(PropertyAddress))



Select OwnerAddress
From Nashville_Housing

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From Nashville_Housing


Alter Table Nashville_Housing
Add OwnerSplitAddress Nvarchar(255); 


Update Nashville_Housing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter Table Nashville_Housing
Add OwnerSplitCity Nvarchar(255); 


Update Nashville_Housing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Alter Table Nashville_Housing
Add OwnerSplitState Nvarchar(255); 


Update Nashville_Housing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

-- Change Y and N to "Yes" and "No" in Sold as Vacant Column---------

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Nashville_Housing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No' 
	   Else SoldAsVacant
	   End
From Nashville_Housing

Update Nashville_Housing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No' 
	   Else SoldAsVacant
	   End

	  
-- Remove Duplicates within Data--------


With RowNumCTE as(
Select *,
      Row_number() over(
	  Partition by ParcelID,
					PropertyAddress,
					SalePrice,
					LegalReference
					Order by 
					UniqueID
					) Row_Num
From Nashville_Housing
)
Delete
From RowNumCTE
Where Row_Num > 1


--Delete any unused Columns-------

Select *
From Nashville_Housing

Alter Table Nashville_Housing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Alter Table Nashville_Housing
Drop Column SaleDateCinverted