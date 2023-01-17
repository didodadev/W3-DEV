<cf_wrk_grid search_header = "#getLang(dictionary_id:61120)#" table_name="SETUP_LANGUAGES_DOCUMENTS" sort_column="DOCUMENT_NAME" u_id="DOCUMENT_ID" datasource="#dsn#" search_areas = "DOCUMENT_NAME,DOCUMENT_SHORT_NAME" dictionary_count="2">
    <cf_wrk_grid_column name="DOCUMENT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="DOCUMENT_NAME" header="#getLang(dictionary_id : 35947)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DOCUMENT_PERIOD_VALID" header="#getLang(dictionary_id : 30966)#" width="500" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DOCUMENT_PERIOD_VALID_TYPE" header="#getLang(dictionary_id : 61121)#" width="400" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#getLang(dictionary_id : 58515)#" type="boolean" width="100" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>