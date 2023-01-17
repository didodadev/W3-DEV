<!-- Description :  SSK_OFFICE,BRANCH_FULLNAME alanları karakter sayısı arttırıldı.
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main-->
<querytag>
    ALTER TABLE BRANCH 
    ALTER COLUMN BRANCH_FULLNAME nvarchar(250) NULL;
    
    ALTER TABLE BRANCH_HISTORY 
    ALTER COLUMN BRANCH_FULLNAME nvarchar(250) NULL;
    
    ALTER TABLE BRANCH
    ALTER COLUMN SSK_OFFICE nvarchar(250) NULL;
    
    ALTER TABLE BRANCH_HISTORY 
    ALTER COLUMN SSK_OFFICE nvarchar(250) NULL;
    
    ALTER TABLE EMPLOYEES_PUANTAJ 
    ALTER COLUMN SSK_OFFICE nvarchar(250) NULL;
    
    ALTER TABLE EMPLOYEES_SSK_EXPORTS 
    ALTER COLUMN SSK_OFFICE nvarchar(250) NULL;
        
</querytag>