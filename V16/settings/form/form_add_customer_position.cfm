 <cf_wrk_grid search_header = "#getLang('settings',870)#" table_name="SETUP_CUSTOMER_POSITION" sort_column="POSITION_NAME" u_id="POSITION_ID" datasource="#dsn#" search_areas = "POSITION_NAME">
    <cf_wrk_grid_column name="POSITION_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="POSITION_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
   

