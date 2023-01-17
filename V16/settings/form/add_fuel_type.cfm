<cf_wrk_grid search_header = "#getLang('','Yakıt Tipleri',42907)#" table_name="SETUP_FUEL_TYPE" sort_column="FUEL_NAME" u_id="FUEL_ID" datasource="#dsn#" search_areas = "FUEL_NAME,FUEL_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="FUEL_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="FUEL_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="FUEL_DETAIL" header="#getLang('main',217)#" width="400" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
