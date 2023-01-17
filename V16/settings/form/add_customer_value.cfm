<cf_wrk_grid search_header = "#getLang('main',1140)#" table_name="SETUP_CUSTOMER_VALUE" sort_column="CUSTOMER_VALUE" u_id="CUSTOMER_VALUE_ID" datasource="#dsn#" search_areas = "CUSTOMER_VALUE,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="CUSTOMER_VALUE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="CUSTOMER_VALUE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="300" select="yes" display="yes"/>
	 <cf_wrk_grid_column name="CUSTOMER_SALE_START" header="#getLang('settings',1770)#" width="150" select="yes" display="yes"/>
	 <cf_wrk_grid_column name="CUSTOMER_SALE_FINISH" header="#getLang('settings',1770)#" width="150" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
