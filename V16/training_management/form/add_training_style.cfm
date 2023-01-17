<cf_wrk_grid search_header = "#getLang('training_management',29)#" table_name="SETUP_TRAINING_STYLE" sort_column="TRAINING_STYLE" u_id="TRAINING_STYLE_ID" datasource="#dsn#" search_areas = "TRAINING_STYLE" left_menu="1" dictionary_count="2">
    <cf_wrk_grid_column name="TRAINING_STYLE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="TRAINING_STYLE" header="#getLang('main',68,57480)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#getLang('main',344,57756)#" width="100" type="boolean" select="yes" display="yes"/>
	<cf_wrk_grid_column name="DETAIL" header="#getLang('main',217,57629)#" width="350" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215,57627)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','Güncelleme Tarihi',55055)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
