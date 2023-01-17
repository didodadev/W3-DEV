<cf_wrk_grid search_header = "#getLang('settings',59)#" table_name="SETUP_CREDITCARD" sort_column="CARDCAT" u_id="CARDCAT_ID" datasource="#dsn#" search_areas = "CARDCAT">
    <cf_wrk_grid_column name="CARDCAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="CARDCAT" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
