<cf_wrk_grid search_header = "#getLang('settings',40)#" table_name="SERVICE_ACCESSORY" sort_column="ACCESSORY" u_id="ACCESSORY_ID" datasource="#dsn3#" search_areas = "ACCESSORY">
    <cf_wrk_grid_column name="ACCESSORY_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="ACCESSORY" header="#getLang('settings',40)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>
