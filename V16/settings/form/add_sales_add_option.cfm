<cf_wrk_grid search_header = "#getLang('settings',1093)#" table_name="SETUP_SALES_ADD_OPTIONS" sort_column="SALES_ADD_OPTION_NAME" u_id="SALES_ADD_OPTION_ID" datasource="#dsn3#" search_areas = "SALES_ADD_OPTION_NAME,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="SALES_ADD_OPTION_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="SALES_ADD_OPTION_NAME" header="#getLang('settings',1094)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" width="400" header="#getLang('main',217)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_INTERNET" type="boolean" width="100" header="#getLang('settings',1356)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>
