<cf_wrk_grid search_header = "#getLang('settings',3094)#" table_name="SETUP_IT_WORKGROUP_TYPE" sort_column="WORKGROUP_TYPE_NAME" u_id="WORKGROUP_TYPE_ID" datasource="#dsn#" search_areas = "WORKGROUP_TYPE_NAME">
    <cf_wrk_grid_column name="WORKGROUP_TYPE_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="WORKGROUP_TYPE_NAME" header="#getLang('main',219)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="INTERNAL_GROUP" width="100" type="boolean" header="#getLang('settings',3097)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="EXTERNAL_GROUP" type="boolean" width="100" header="#getLang('settings',3098)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>

