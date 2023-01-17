<cfsavecontent  variable="header">
    <cf_get_lang dictionary_id='59954.Tedavi Kategorileri'>
</cfsavecontent>
<cfsavecontent  variable="title">
    <cf_get_lang dictionary_id='41534.Tedavi'><cf_get_lang dictionary_id='39091.Kategorisi'>
</cfsavecontent>
<cf_wrk_grid search_header = "#header#" table_name="SETUP_COMPLAINT_CAT" sort_column="COMPLAINT_CAT" u_id="COMPLAINT_CAT_ID" datasource="#dsn#" user_id="#session.ep.userid#" search_areas="COMPLAINT_CAT,COMPLAINT_CAT_DESCRIPTION" dictionary_count="2">
    <cf_wrk_grid_column name="COMPLAINT_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="COMPLAINT_CAT" header="#title#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="COMPLAINT_CAT_DESCRIPTION" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_EMP" header="#getLang('main',487)#" type="int" select="no" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>

