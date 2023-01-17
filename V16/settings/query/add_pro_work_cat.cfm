<cfquery name="GET_PRO_WORK_CAT" datasource="#DSN#">
	SELECT
		MAX(WORK_CAT_ID) AS MAX_ID
	FROM
		PRO_WORK_CAT
</cfquery>
<cfif GET_PRO_WORK_CAT.RECORDCOUNT and len(GET_PRO_WORK_CAT.MAX_ID)>
	<cfset work_id=GET_PRO_WORK_CAT.MAX_ID+1>
<cfelse>
	<cfset work_id=1>
</cfif>
<cfquery name="ADD_PRO_WORK_CAT" datasource="#DSN#">
	INSERT INTO 
		PRO_WORK_CAT
		(
			WORK_CAT_ID,	
			WORK_CAT,
			DETAIL,
			TEMPLATE_ID,
            PROCESS_ID,
			OUR_COMPANY_ID,
			MAIN_PROCESS_ID,
			IS_RD_SSK,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
		VALUES
		(
		    <cfqueryparam cfsqltype="cf_sql_integer" value="#work_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#WORK_CAT#">,
			<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#"><cfelse>NULL</cfif>,
			<cfif len(attributes.template_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#template_id#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.process_id") and len(attributes.process_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_id#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_id#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.main_process_cat") and len(attributes.main_process_cat)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_process_cat#"><cfelse>NULL</cfif>,
			<cfif isDefined("attributes.is_rd_ssk") and len(attributes.is_rd_ssk)>1<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_pro_work_cat" addtoken="no">
