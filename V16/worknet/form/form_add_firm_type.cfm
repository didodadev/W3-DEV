<cf_wrk_grid search_header = "Firma Tipleri" table_name="SETUP_FIRM_TYPE" sort_column="FIRM_TYPE" u_id="FIRM_TYPE_ID" datasource="#dsn#" search_areas = "FIRM_TYPE,FIRM_TYPE_DETAIL">
    <cf_wrk_grid_column name="FIRM_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="FIRM_TYPE" width="300" header="#getLang('main',68)#" select="yes" display="yes"/>
<cf_wrk_grid_column name="FIRM_TYPE_DETAIL" header="#getLang('main',217)#" width="600" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme Tarihi" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
