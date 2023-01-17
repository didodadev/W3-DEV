<cfquery name="UPDPRO_WORK_CAT" datasource="#dsn#">
	UPDATE 
		PRO_WORK_CAT 
	SET 
		WORK_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_work_cat#">,
		DETAIL = <cfif len(detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#"><cfelse>NULL</cfif>,
		TEMPLATE_ID = <cfif len(template_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#template_id#"><cfelse>NULL</cfif>,
        PROCESS_ID = <cfif isdefined("attributes.process_id") and len(attributes.process_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_id#"><cfelse>NULL</cfif>,
        OUR_COMPANY_ID = <cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_id#"><cfelse>NULL</cfif>,
		MAIN_PROCESS_ID = <cfif isdefined("attributes.main_process_cat") and len(attributes.main_process_cat)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_process_cat#"><cfelse>NULL</cfif>,
		IS_RD_SSK = <cfif isDefined("attributes.is_rd_ssk") and len(attributes.is_rd_ssk)>1<cfelse>0</cfif>,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	WHERE 
		WORK_CAT_ID=#WORK_CAT_ID#
</cfquery>
<script>
	location.href= document.referrer;
</script>
