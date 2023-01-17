<cf_wrk_grid search_header = "#getLang('settings',962)#" table_name="SETUP_HIGH_SCHOOL_PART" sort_column="HIGH_PART_NAME" u_id="HIGH_PART_ID" datasource="#dsn#" search_areas = "HIGH_PART_NAME,HIGH_DETAIL" dictionary_count="2">
	<cf_wrk_grid_column name="HIGH_PART_ID" header="ID" display="no" select="yes"/>
	<cf_wrk_grid_column name="HIGH_PART_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="HIGH_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
