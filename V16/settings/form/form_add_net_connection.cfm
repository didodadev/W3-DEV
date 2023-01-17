<cf_wrk_grid search_header = "#getLang('settings',1139)#" table_name="SETUP_NET_CONNECTION" sort_column="CONNECTION_NAME" u_id="CONNECTION_ID" datasource="#dsn#" search_areas = "CONNECTION_NAME,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="CONNECTION_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="CONNECTION_NAME" required="true" header="#getLang('settings',1671)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
