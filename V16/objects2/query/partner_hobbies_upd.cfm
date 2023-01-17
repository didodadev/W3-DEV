<cfquery name="del_partner_hobbies" datasource="#dsn#"> 
	DELETE FROM COMPANY_PARTNER_HOBBY WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
</cfquery>
<cfdump var="#attributes#">
<cfoutput>
	<cfif isDefined('attributes.hobby')>
		<cfloop from="1" to="#Listlen(attributes.hobby)#" index="i"> 
			<cfset liste = ListGetAt(attributes.hobby,i)>
			<cfquery name="add_partner_hobbies" datasource="#dsn#"> 
				INSERT INTO
					COMPANY_PARTNER_HOBBY
						(
							PARTNER_ID,
							HOBBY_ID
						)
					VALUES
						(
							#attributes.partner_id#,
							#liste#
						)
			</cfquery> 
		 </cfloop>
	</cfif>
 </cfoutput>
<script type="text/javascript">
	<cfif isDefined("session.pp") or isDefined("session.ww")>
		window.location.replace(document.referrer);
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=objects2.form_upd_partner&pid=#attributes.partner_id#</cfoutput>';
	</cfif>
</script>
