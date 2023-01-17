<cf_wrk_grid search_header = "#getLang('','settings',53080)#" table_name="SETUP_CAUTION_TYPE" sort_column="CAUTION_TYPE" u_id="CAUTION_TYPE_ID" datasource="#dsn#" search_areas = "CAUTION_TYPE,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="CAUTION_TYPE" header="#getLang('','main',57630)#"  select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('','main',57629)#"  select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#getLang('','main',57493)#" type="boolean" select="no" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('','main',57627)#" type="date" mask="date"  select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','settings',43163)#" type="date" mask="date"  select="no" display="yes"/>
</cf_wrk_grid>