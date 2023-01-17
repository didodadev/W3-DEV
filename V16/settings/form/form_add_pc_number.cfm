<cf_wrk_grid search_header = "#getLang('settings',915)#" table_name="SETUP_PC_NUMBER" sort_column="UNIT_NAME" u_id="UNIT_ID" datasource="#dsn#" search_areas = "UNIT_NAME,UNIT_DESC" dictionary_count="2">
    <cf_wrk_grid_column name="UNIT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="UNIT_NAME" header="#getLang('settings',915)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="UNIT_DESC" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
