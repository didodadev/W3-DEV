<cf_wrk_grid search_header = "#getLang('stock',192)#" table_name="WAREHOUSE_TASK_TYPES" sort_column="WAREHOUSE_TASK_TYPE" u_id="WAREHOUSE_TASK_TYPE_ID" datasource="#dsn#" search_areas = "WAREHOUSE_TASK_TYPE">
    <cf_wrk_grid_column name="WAREHOUSE_TASK_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="WAREHOUSE_TASK_TYPE" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="WAREHOUSE_TASK_TYPE_ORDER" header="Order No" display="yes" select="yes"/>
	<cf_wrk_grid_column name="WAREHOUSE_TASK_TYPE_DETAIL" header="Info" select="yes" display="yes"/>
	<cf_wrk_grid_column name="IS_SHIPMENT" header="Shipment" select="yes" display="yes" type="boolean"/>
	<cf_wrk_grid_column name="IS_RECEIVING" header="Receiving" select="yes" display="yes" type="boolean"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>