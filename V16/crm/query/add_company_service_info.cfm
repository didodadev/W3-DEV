<cfquery name="DEL_COMPANY_CARGO_INFO" datasource="#dsn#">
	DELETE FROM COMPANY_CARGO_INFO WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfif len(attributes.record_num) and attributes.record_num neq "">
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfscript>
				form_company_id = evaluate("attributes.company_id#i#");
				form_cargo_code = evaluate("attributes.cargo_code#i#");
			</cfscript>
			<cfquery name="ADD_HOBBY" datasource="#dsn#">
				INSERT 
				INTO 
					COMPANY_CARGO_INFO
					(
						COMPANY_ID,
						CARGO_COMP_ID,
						CARGO_CODE
					)
					VALUES
					(
						#attributes.cpid#,
						#form_company_id#,
						'#form_cargo_code#'
					)
			</cfquery>
		</cfif>
	</cfloop>	
</cfif>
<cflocation url="#request.self#?fuseaction=crm.popup_company_service_info&cpid=#attributes.cpid#" addtoken="no">
