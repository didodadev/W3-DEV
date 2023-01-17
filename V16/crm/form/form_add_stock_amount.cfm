<cf_wrk_grid search_header = "#getLang('','Kategori Listesi',63736)#" table_name="SETUP_STOCK_AMOUNT" sort_column="STOCK_NAME" u_id="STOCK_ID" datasource="#dsn#" search_areas = "STOCK_NAME,DETAIL" dictionary_count="2" left_menu="1">
    <cf_wrk_grid_column name="STOCK_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="STOCK_NAME" header="#getLang('','Konu',57480)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('','Açıklama',36199)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('','Kayıt Tarihi',57627)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','Güncelleme Tarihi',55055)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
		
 

