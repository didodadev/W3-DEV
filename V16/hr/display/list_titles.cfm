<cf_wrk_grid search_header = "#getLang('hr',83)#" table_name="SETUP_TITLE" left_menu="1" sort_column="TITLE" u_id="TITLE_ID" datasource="#dsn#" search_areas = "TITLE,TITLE_DETAIL">
    <cf_wrk_grid_column name="TITLE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="TITLE" width="300" header="#getLang('main',159)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="TITLE_DETAIL" header="#getLang('main',217)#" width="200" select="yes" display="yes"/>
	<cf_wrk_grid_column name="HIERARCHY" header="#getLang('main',349)#" width="200" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme Tarihi" type="date" mask="date" width="150" select="no" display="yes"/>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#getLang('main',81)#" type="boolean" width="100" select="yes" display="yes"/>
</cf_wrk_grid>

