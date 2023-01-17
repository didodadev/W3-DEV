<!-- Description : Satış kotaları sayfasına belgeler alanı konuldu ilgili kategori kaydi aciliyor
Developer: Fatih Ayık
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT ASSETCAT_ID FROM ASSET_CAT WHERE ASSETCAT_ID = -26)
    BEGIN
		INSERT INTO ASSET_CAT (ASSETCAT_ID,ASSETCAT,ASSETCAT_PATH,ASSETCAT_DETAIL) VALUES (-26,'Satış Kotaları','sales/sales_quota','Satış Kota belgeleri')
    END;
</querytag>