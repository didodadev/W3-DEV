<cfif isDefined("is_del") and is_del eq 1>
	<cfquery name="DEL_OPPORTUNITY" datasource="#dsn3#">
		DELETE FROM SETUP_OPPORTUNITY_TYPE WHERE OPPORTUNITY_TYPE_ID = #attributes.opportunity_type_id#
	</cfquery>
<cfelse>
	<cfquery name="UPD_OPPORTUNITY" datasource="#dsn3#">
		UPDATE
			SETUP_OPPORTUNITY_TYPE
		SET
			OPPORTUNITY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.opportunity_type#">,
			OPPORTUNITY_TYPE_DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
			IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
			IS_SALES = <cfif isdefined("attributes.is_sales")>1<cfelse>0</cfif>,
			IS_PURCHASE = <cfif isdefined("attributes.is_purchase")>1<cfelse>0</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			OPPORTUNITY_TYPE_ID = #attributes.opportunity_type_id#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_add_opportunity_type" addtoken="no">
