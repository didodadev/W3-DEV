<cfsavecontent variable="Title"><cf_get_lang dictionary_id='30275.Gizli Soru'></cfsavecontent>
<cf_wrk_grid search_header = "#Title#" table_name="SECRET_QUESTION" sort_column="QUESTION" u_id="QUESTION_ID" datasource="#dsn#" search_areas = "QUESTION">
    <cf_wrk_grid_column name="QUESTION_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="QUESTION" header="#getLang('main',1398)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
