<cf_wrk_grid search_header = "#getLang('settings',876)#" table_name="SETUP_ASSETP_GROUP" sort_column="GROUP_NAME" u_id="GROUP_ID" datasource="#dsn#" search_areas = "GROUP_NAME,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="GROUP_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="GROUP_NAME" header="#getLang('settings',880)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" width="300" header="#getLang('main',217)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="ASSETP_RESERVE" type="boolean" width="100" header="#getLang('settings',326)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IT_ASSET" type="boolean" width="100" header="#getLang('settings',327)#" select="yes" display="yes"/> 
    <cf_wrk_grid_column name="MOTORIZED_VEHICLE" type="boolean" width="100" header="#getLang('settings',328)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>
