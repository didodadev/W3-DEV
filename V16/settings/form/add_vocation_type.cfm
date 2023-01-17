<cf_wrk_grid search_header = "#getLang(dictionary_id : 60724)#" table_name="SETUP_VOCATION_TYPE" sort_column="VOCATION_TYPE" u_id="VOCATION_TYPE_ID" datasource="#dsn#" search_areas = "VOCATION_TYPE,DETAIL" dictionary_count="3">
	<cf_wrk_grid_column name="VOCATION_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="VOCATION_TYPE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="FORWARD_SALE_LIMIT" header="#getLang('settings',1668)#" width="300" select="yes" display="yes"/>
	<cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="300" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>    
       

