<!-- Description : page_warnings tablosunda aboneler için eski link yapısının düzeltilmesi.
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
WITH CTE1 AS
(
SELECT
    LEFT(URL_LINK,27) + 'list_subscription_contract&event=upd&'+SUBSTRING(URL_LINK,54,30) AS NEW_,
    URL_LINK AS EX,
    W_ID
FROM 
    PAGE_WARNINGS
WHERE    
    IS_PARENT=1 
    AND OUR_COMPANY_ID = 1 
    AND URL_LINK LIKE '%index.cfm?fuseaction=sales.upd_subscription_contract%'
)
UPDATE 
    PAGE_WARNINGS 
SET 
    URL_LINK = CTE1.NEW_
FROM
    PAGE_WARNINGS AS P
    LEFT JOIN CTE1 ON P.W_ID = CTE1.W_ID
WHERE
    P.W_ID = CTE1.W_ID
</querytag>