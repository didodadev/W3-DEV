<!-- Description :Content sayfasında öncelik selectbox'ı textbox'a çevirilmesi gerektiğinden dolayı tipi integer dan VARCHAR'a dönüştürüldü.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    ALTER TABLE CONTENT ALTER COLUMN PRIORITY nvarchar(50)
</querytag>