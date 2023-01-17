<cf_wrk_grid search_header = "#getLang('settings',165)#" dictionary_count="1" table_name="SETUP_TITLE" sort_column="TITLE" u_id="TITLE_ID" datasource="#dsn#" search_areas = "TITLE,TITLE_DETAIL">
    <cf_wrk_grid_column name="TITLE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="TITLE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="TITLE_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="HIERARCHY" header="#getLang('main',349)#" width="200" select="yes" display="no"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#getLang('main',81)#" type="boolean" width="100" select="yes" display="yes"/>
</cf_wrk_grid>

