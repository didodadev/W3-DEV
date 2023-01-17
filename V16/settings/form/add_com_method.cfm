<cf_wrk_grid search_header = "#getLang('main',678)#" table_name="SETUP_COMMETHOD" sort_column="COMMETHOD" u_id="COMMETHOD_ID" datasource="#dsn#" search_areas = "COMMETHOD">
    <cf_wrk_grid_column name="COMMETHOD_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="COMMETHOD" header="#getLang('main',74)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_DEFAULT" width="200" type="boolean" header="#getLang('settings',1132)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>
