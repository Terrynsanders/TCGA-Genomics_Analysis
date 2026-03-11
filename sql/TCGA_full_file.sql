-- Update OS_Stattus fields to "alive, dead, or unknown"

UPDATE Patient_Data
SET OS_STATUS  =  'Alive'
Where OS_STATUS like '0:%';

UPDATE Patient_Data
SET OS_STATUS  =  'Deceased'
Where OS_STATUS like '1:%';

UPDATE Patient_Data
SET OS_STATUS  =  'Unknown'
Where OS_STATUS is NULL;

--Order genes based on total count of mutations--

SELECT Hugo_Symbol,
count(*) as total_mutations
FROM Mutation_Data
GROUP by Hugo_Symbol
ORDER by total_mutations DESC;

--Calculate the mutation frequency of the genes--

select Hugo_Symbol,
count(distinct tumor_sample_barcode) as mutation_sample,
round( 100.0 * count(distinct tumor_sample_barcode)/(SELECT count(distinct tumor_sample_barcode) from Mutation_Data), 0) as mutation_frequency_percent
FROM Mutation_Data
GROUP by Hugo_Symbol
ORDER by mutation_sample DESC
LIMIT 10;

--Organize variant class based on total number of counted variants--

Select Variant_Classification,
count(*) as total_variants
from Mutation_Data
GROUP by Variant_Classification
ORDER by total_variants DESC;

--avg age of deceased OS_STATUS for male and female patients--

SELECT SEX,  
round(avg(AGE)) as avg_age_of_deceased
FROM Patient_Data
Where OS_STATUS = 'Deceased'
GROUP by SEX;

--connect sample ID to patient clinical outcomes--

SELECT 
c.sample_id,
p.sex,
p.age,
p.os_status,
p.os_months
FROM Clinical_Data c
JOIN Patient_Data p
ON c.patient_id = p.patient_id;

-- determine the total counts of each variant type --

SELECT Variant_Type,
count(*) as variant_type_count
FROM Mutation_Data
GROUP by Variant_Type
order by variant_type_count DESC;

--Determine the survival rate--

SELECT 
ROUND(
100.0 * COUNT(CASE WHEN OS_STATUS = 'Alive' THEN 1 END)
/ COUNT(*),
1
) AS survival_rate
FROM Patient_Data;

