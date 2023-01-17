<cfquery name="GET_SERVICES" datasource="#DSN3#">
	SELECT 
    	SERVICE.SERVICE_ID, 
        SERVICE.SERVICE_COMPANY_ID, 
        SERVICE.SERVICE_PARTNER_ID, 
        SERVICE.SERVICE_CONSUMER_ID, 
        SERVICE.SERVICE_EMPLOYEE_ID, 
        SERVICE.SERVICE_NO, 
        SERVICE.DOC_NO, 
        SERVICE.APPLY_DATE, 
        SERVICE.SERVICE_HEAD, 
        SERVICE.APPLICATOR_NAME, 
        SERVICE.APPLICATOR_COMP_NAME, 
        SERVICE.SERVICE_PRODUCT_ID, 
        SERVICE.PRODUCT_NAME, 
        SERVICE.PRO_SERIAL_NO, 
        SERVICE.RECORD_MEMBER, 
        SERVICE.RECORD_PAR, 
        SERVICE.SERVICE_BRANCH_ID, 
        SERVICE.SUBSCRIPTION_ID, 
        SERVICE.SERVICE_SUBSTATUS_ID, 
        SERVICE.SERVICE_CITY_ID, 
        SERVICE.SERVICE_COUNTY_ID, 
        SERVICE_APPCAT.SERVICECAT
	FROM 
    	SERVICE WITH (NOLOCK), 
        SERVICE_APPCAT WITH (NOLOCK), 
        #dsn_alias#.SETUP_PRIORITY AS SP WITH (NOLOCK), 
        #dsn_alias#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS WITH (NOLOCK) 
	WHERE 
    	SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID AND 
        SP.PRIORITY_ID = SERVICE.PRIORITY_ID AND 
        SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND 
        SERVICE.SERVICE_ACTIVE = 1 AND 
        SERVICE.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
	ORDER BY SERVICE.RECORD_DATE DESC
</cfquery>

<div style="margin-top:30px;" class="form-title">İlişkili Servisler</div>
<cfoutput query="get_services">
	&nbsp;<a href="#request.self#?fuseaction=pda.detail_service&service_id=#service_id#" class="tableyazi">#service_head#</a><br/>
</cfoutput>
