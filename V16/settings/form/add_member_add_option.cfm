<cf_wrk_grid search_header = "#getLang('settings',575)#" table_name="SETUP_MEMBER_ADD_OPTIONS" sort_column="MEMBER_ADD_OPTION_NAME" u_id="MEMBER_ADD_OPTION_ID" datasource="#dsn#" search_areas = "MEMBER_ADD_OPTION_NAME,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="MEMBER_ADD_OPTION_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="MEMBER_ADD_OPTION_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="400" select="yes" display="yes"/>
	<cf_wrk_grid_column name="IS_INTERNET" header="#getLang('main',667)# Görünsün" type="boolean" width="150" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
		
		
		

