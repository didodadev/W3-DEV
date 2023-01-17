<!-- Description :  PUANTAJ_BRANCH_FULL_NAME alanı karakter sayısı arttırıldı.
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main-->
<querytag>
    ALTER TABLE EMPLOYEES_PUANTAJ 
    ALTER COLUMN PUANTAJ_BRANCH_FULL_NAME nvarchar(250) NULL;
</querytag>