<!-- Description :Content sayfasında öncelik selectbox'ı textbox'a çevirildiği için tipi integer dan VARCHAR'a dönüştürüldü.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    ALTER TABLE CONTENT_HISTORY ALTER COLUMN PRIORITY nvarchar(50)
</querytag>