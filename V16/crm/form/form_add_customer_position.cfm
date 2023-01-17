<cf_wrk_grid search_header = "#getLang('','Müşteri Genel Konumu',42853)#" table_name="SETUP_CUSTOMER_POSITION" sort_column="POSITION_NAME" u_id="POSITION_ID" datasource="#dsn#" search_areas = "POSITION_NAME" left_menu="1">
    <cf_wrk_grid_column name="POSITION_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="POSITION_NAME" header="#getLang('','Konu',57480)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('','Açıklama',57629)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('','Kayıt Tarihi',57627)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
   

