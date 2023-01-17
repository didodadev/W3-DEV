<cf_wrk_grid search_header = "#getLang('settings',1462)#" table_name="SETUP_EMPLOYEE_FIRE_REASONS" sort_column="REASON" u_id="REASON_ID" datasource="#dsn#" search_areas = "REASON,REASON_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="REASON_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#getLang('main',81)#" width="100" type="boolean" display="yes" select="yes"/>
    <cf_wrk_grid_column name="IS_POSITION" header="#getLang('main',1085)#" width="100" type="boolean" display="yes" select="yes"/><!---20131107 GSO pozisyon detayi için şirket içi gerekçe--->
    <cf_wrk_grid_column name="IS_DEPARTMENT" header="#getLang('main',160)#" width="100" type="boolean" display="yes" select="no"/><!---20191205ERu departman--->
    <cf_wrk_grid_column name="IS_IN_OUT" header="#getLang('hr',1037)#" width="100" type="boolean" display="yes" select="yes"/><!---20131107 GSO giriş çıkış için şirket içi gerekçe--->
    <cf_wrk_grid_column name="REASON" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="REASON_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
