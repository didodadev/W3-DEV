<cf_wrk_grid search_header = "#getLang('settings',515)#" table_name="SETUP_INTERACTION_CAT" sort_column="INTERACTIONCAT" u_id="INTERACTIONCAT_ID" datasource="#dsn#" search_areas = "INTERACTIONCAT,INTERACTIONCAT_DESC" dictionary_count="2">
    <cf_wrk_grid_column name="INTERACTIONCAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="INTERACTIONCAT" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="INTERACTIONCAT_DESC" header="#getLang('main',217)#" width="400" select="yes" display="yes"/>
	<cf_wrk_grid_column name="IS_SERVICE_HELP" header="Destek" width="100" type="boolean" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
