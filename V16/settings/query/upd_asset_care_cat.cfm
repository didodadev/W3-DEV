<cfquery name="UPD_ASSET_CARE_CAT" datasource="#DSN#">
	UPDATE 
		ASSET_CARE_CAT
	SET
		ASSET_CARE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_care#">,
		ASSETP_CAT = #attributes.assetp_cat#,
		IS_YASAL = <cfif isDefined("attributes.is_yasal")>1<cfelse>0</cfif>,
		DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE  
		ASSET_CARE_ID = #url.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_asset_care_cat" addtoken="no">
