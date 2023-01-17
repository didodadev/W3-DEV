<cf_wrk_grid search_header = "#getLang(dictionary_id:61470)#" table_name="CARGO_DOCUMENT_TYPE" sort_column="DOCUMENT_TYPE" u_id="TYPE_ID" datasource="#dsn#" search_areas = "DOCUMENT_TYPE" >
    <cf_wrk_grid_column name="TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="DOCUMENT_TYPE" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>