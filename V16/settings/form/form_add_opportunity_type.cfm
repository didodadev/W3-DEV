<cf_wrk_grid search_header = "#getLang('settings',936)#" table_name="SETUP_OPPORTUNITY_TYPE" sort_column="OPPORTUNITY_TYPE" u_id="OPPORTUNITY_TYPE_ID" datasource="#dsn3#" search_areas = "OPPORTUNITY_TYPE,OPPORTUNITY_TYPE_DETAIL">
    <cf_wrk_grid_column name="OPPORTUNITY_TYPE_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="OPPORTUNITY_TYPE" width="200" header="#getLang('settings',20)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="OPPORTUNITY_TYPE_DETAIL" width="200" header="#getLang('main',217)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_INTERNET" type="boolean" width="100" header="#getLang('settings',1495)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_SALES" type="boolean" width="100" header="#getLang('main',36)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_PURCHASE" type="boolean" width="100" header="#getLang('main',37)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>
