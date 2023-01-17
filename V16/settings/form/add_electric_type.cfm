<cf_wrk_grid search_header = "Elektrik Tipi" table_name="SETUP_ELECTRIC_TYPE" sort_column="ELECTRIC_TYPE_NAME" u_id="ELECTRIC_TYPE_ID" datasource="#dsn#" search_areas = "ELECTRIC_TYPE_NAME,ELECTRIC_TYPE_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="ELECTRIC_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="ELECTRIC_TYPE_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="ELECTRIC_TYPE_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
