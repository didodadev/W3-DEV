<cf_wrk_grid search_header = "#getLang('settings',3114)#" table_name="SETUP_CARD_CHANGE_TYPES" sort_column="CHANGE_TYPE_NAME" u_id="CHANGE_TYPE_ID" datasource="#dsn#" search_areas = "CHANGE_TYPE_NAME">
    <cf_wrk_grid_column name="CHANGE_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="CHANGE_TYPE_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
