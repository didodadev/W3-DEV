<cf_wrk_grid search_header = "#getLang('settings',154)#" table_name="SETUP_DRIVERLICENCE" sort_column="LICENCECAT" u_id="LICENCECAT_ID" datasource="#dsn#" search_areas = "LICENCECAT,USAGE_YEAR" dictionary_count="2">
    <cf_wrk_grid_column name="LICENCECAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="LICENCECAT" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="USAGE_YEAR" header="#getLang(dictionary_id:42724)#" width="300" type="numeric" select="yes" display="yes"/>
	<cf_wrk_grid_column name="IS_LAST_YEAR_CONTROL" header="#getLang(dictionary_id:61345)#" width="150" type="boolean" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
	<cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','Güncelleme Tarihi',32449)#" width="130" type="date" select="no" display="yes" mask="date"/>
</cf_wrk_grid>	
		
