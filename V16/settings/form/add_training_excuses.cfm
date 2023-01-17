<cf_wrk_grid search_header = "Eğitim Mazeretleri" dictionary_count="1" table_name="SETUP_TRAINING_EXCUSES" sort_column="EXCUSE_HEAD" u_id="TRAINING_EXCUSE_ID" datasource="#dsn#" search_areas = "EXCUSE_HEAD,COMMENT">
	<cf_wrk_grid_column name="TRAINING_EXCUSE_ID" header="ID" display="no" select="yes"/>
	<cf_wrk_grid_column name="IS_ACTIVE" header="#getLang('main',81)#" type="boolean" width="100" select="yes" display="yes"/>
	<cf_wrk_grid_column name="REASON_TO_START" header="Başlamama Sebebi̇" type="boolean" width="100" select="yes" display="yes"/>
	<cf_wrk_grid_column name="REASON_TO_LEAVE" header="Bırakma Sebebi̇" type="boolean" width="100" select="yes" display="yes"/>
	<cf_wrk_grid_column name="EXCUSE_HEAD" header="#getLang('main',68)#" width="200" select="yes" display="yes"/>
	<cf_wrk_grid_column name="COMMENT" header="#getLang('main',217)#" width="200" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
