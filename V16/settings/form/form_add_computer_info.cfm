<cf_wrk_grid search_header = "#getLang('settings',1731)#" dictionary_count="2" table_name="SETUP_COMPUTER_INFO" sort_column="COMPUTER_INFO_STATUS" u_id="COMPUTER_INFO_ID" datasource="#dsn#" search_areas = "COMPUTER_INFO_NAME,COMPUTER_INFO_DESCRIPTION">
    <cf_wrk_grid_column name="COMPUTER_INFO_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="COMPUTER_INFO_STATUS" type="boolean" width="100" header="#getLang('main',344)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="COMPUTER_INFO_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="COMPUTER_INFO_DESCRIPTION" header="#getLang('main',217)#" width="300" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>





