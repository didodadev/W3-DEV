<cf_wrk_grid search_header = "#getLang('training_management',46)#" table_name="TRAINING_CAT" left_menu="1" sort_column="TRAINING_CAT" u_id="TRAINING_CAT_ID" datasource="#dsn#" search_areas = "TRAINING_CAT,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="TRAINING_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="TRAINING_CAT" header="#getLang('main',68,57480)#" select="yes" display="yes"/>
<cf_wrk_grid_column name="DETAIL" header="#getLang('main',217,57629)#" width="400" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215,57627)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','Güncelleme Tarihi',55055)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
