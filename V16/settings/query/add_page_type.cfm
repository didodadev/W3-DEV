<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_PAGE_TYPE" datasource="#dsn#">
			SELECT
				MAX(PAGE_TYPE_ID) + 1 AS MAX_ID
			FROM
				SETUP_PAGE_TYPES
		</cfquery>
		<cfquery name="add_PAGE_TYPE" datasource="#dsn#">
			INSERT INTO
				SETUP_PAGE_TYPES
			(
				PAGE_TYPE_ID,
				PAGE_TYPE,
				PAGE_TYPE_DETAIL,
				OUR_COMPANY_IDS,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
			VALUES
			(
				#get_page_type.max_id#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.page_type#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.detail#">,
				 <cfif isdefined("form.our_company_ids") and len(form.our_company_ids)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#form.our_company_ids#,"><cfelse>NULL</cfif>,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#session.ep.userid#
			)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_upd_page_type&page_type_id=#get_page_type.max_id#" addtoken="no">
