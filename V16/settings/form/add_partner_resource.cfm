<cfset iysList = 'HS_2015,HS_FIZIKSEL_ORTAM,HS_ISLAK_IMZA,HS_ETKINLIK,HS_ATM,HS_EORTAM,HS_WEB,HS_MOBIL,HS_MESAJ,HS_EPOSTA,HS_CAGRI_MERKEZI,HS_SOSYAL_MEDYA'>
<cf_wrk_grid search_header = "#getLang('settings',1605)#" table_name="COMPANY_PARTNER_RESOURCE" sort_column="RESOURCE" u_id="RESOURCE_ID" datasource="#dsn#" search_areas = "RESOURCE,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="RESOURCE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IYS_INFO" header="İYS Karşılığı" type="select" listsource="iysList" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>