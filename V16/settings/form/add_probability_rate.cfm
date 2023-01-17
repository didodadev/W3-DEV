<cf_wrk_grid search_header = "#getLang('settings',438)#" table_name="SETUP_PROBABILITY_RATE" sort_column="PROBABILITY_NAME" u_id="PROBABILITY_RATE_ID" datasource="#dsn3#" search_areas = "PROBABILITY_NAME,PROBABILITY_RATE" dictionary_count="2">
    <cf_wrk_grid_column name="PROBABILITY_RATE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PROBABILITY_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="PROBABILITY_RATE" header="#getLang('settings',435)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
