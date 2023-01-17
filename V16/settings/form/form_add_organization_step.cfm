<cf_wrk_grid search_header = "#getLang('settings',966)#" table_name="SETUP_ORGANIZATION_STEPS" sort_column="ORGANIZATION_STEP_NAME" u_id="ORGANIZATION_STEP_ID" datasource="#dsn#" search_areas = "ORGANIZATION_STEP_NAME,DETAIL" dictionary_count="2"><!---<cf_get_lang no='964.Fonksiyonlar Birimler'>--->
    <cf_wrk_grid_column name="ORGANIZATION_STEP_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="ORG_DSP" header="#getLang('settings',1107)#" type="boolean" width="160" select="yes" display="yes"/>
    <cf_wrk_grid_column name="ORGANIZATION_STEP_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="ORGANIZATION_STEP_NO" header="#getLang('settings',1108)#" width="200" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="400" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
