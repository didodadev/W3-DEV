<cf_wrk_grid search_header = "#getLang('training_management',432)#" table_name="SETUP_QUIZ_STAGE" left_menu="1" sort_column="STAGE_NAME" u_id="STAGE_ID" datasource="#dsn#" search_areas = "STAGE_NAME">
    <cf_wrk_grid_column name="STAGE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="STAGE_NAME" header="#getLang('main',70)#" select="yes" display="yes"/>
<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('training_management',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
