<cfif isdefined("attributes.fuseaction") and attributes.fuseaction eq 'settings.form_add_company_relation'>
    <cfset attributes.relation_type_info = 1>
    <cf_wrk_grid search_header = "#getLang('settings',684)#" table_name="SETUP_PARTNER_RELATION" sort_column="PARTNER_RELATION" u_id="PARTNER_RELATION_ID" datasource="#dsn#" search_areas = "PARTNER_RELATION,DETAIL" dictionary_count="2">
        <cf_wrk_grid_column name="PARTNER_RELATION_ID" header="ID" display="no" select="yes"/>
        <cf_wrk_grid_column name="PARTNER_RELATION" header="#getLang('main',68)#" select="yes" display="yes"/>
        <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
        <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
        <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
    </cf_wrk_grid>
<cfelseif isdefined("attributes.fuseaction") and attributes.fuseaction eq 'settings.form_add_consumer_relation'>
    <cfset attributes.relation_type_info = 2>
    <cf_wrk_grid search_header = "#getLang('settings',145)#" table_name="SETUP_CONSUMER_RELATION" sort_column="CONSUMER_RELATION" u_id="CONSUMER_RELATION_ID" datasource="#dsn#" search_areas = "CONSUMER_RELATION,CONSUMER_RELATION_DETAIL" dictionary_count="2">
        <cf_wrk_grid_column name="CONSUMER_RELATION_ID" header="ID" display="no" select="yes"/>
        <cf_wrk_grid_column name="CONSUMER_RELATION" header="#getLang('main',68)#" select="yes" display="yes"/>
        <cf_wrk_grid_column name="CONSUMER_RELATION_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
        <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
        <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
    </cf_wrk_grid>
<cfelse>
    <cf_wrk_grid search_header = "#getLang('settings',952)#" table_name="SETUP_SUBSCRIPTION_RELATION" sort_column="SUBSCRIPTION_RELATION" u_id="SUBSCRIPTION_RELATION_ID" datasource="#dsn#" search_areas = "SUBSCRIPTION_RELATION,DETAIL" dictionary_count="2">
        <cf_wrk_grid_column name="SUBSCRIPTION_RELATION_ID" header="ID" display="no" select="yes"/>
        <cf_wrk_grid_column name="SUBSCRIPTION_RELATION" header="#getLang('main',68)#" select="yes" display="yes"/>
        <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
        <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
        <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
    </cf_wrk_grid>
</cfif>
