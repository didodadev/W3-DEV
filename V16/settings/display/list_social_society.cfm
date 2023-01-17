<cf_wrk_grid search_header = "#getLang('','main',32562)#" table_name="SETUP_SOCIAL_SOCIETY" sort_column="SOCIETY" u_id="SOCIETY_ID" datasource="#dsn#" search_areas = "SOCIETY,SOCIETY_DETAIL">
    <cf_wrk_grid_column name="SOCIETY_ID" header="#getLang('','main',58527)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="SOCIETY" width="300" header="#getLang('','settings',43106)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="SOCIETY_DETAIL" header="#getLang('','main',57771)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_EMP" header="#getLang('settings',1138)#" type="int"   select="no" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('','main',57627)#" type="date" mask="date"  select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','settings',43163)#" type="date" mask="date"  select="no" display="yes"/>
</cf_wrk_grid>
