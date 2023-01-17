<cfset xmlPage = DeserializeJSON(URLDecode(form.xmlPage, "utf-8"))>

<cfif StructCount(xmlPage)>
	<cflock name="CreateUUID()" timeout="100">
		<cftransaction>
			<cfif isdefined('xmlPage.is_upd') and xmlPage.is_upd eq 1><!--- Eğer Güncelleme ise önce sildiriyoruz!Daha sonra tekrardan ekleme yapıyoruz!--->
				<cfquery name="DELETE_PROPERTY" datasource="#DSN#">
					DELETE FROM FUSEACTION_PROPERTY WHERE FUSEACTION_NAME = '#xmlPage.page_fuseaction#' AND OUR_COMPANY_ID = #xmlPage.our_company_id#
				</cfquery>
			</cfif>	
			<cfloop from="1" to="#xmlPage.record_num#" index="pro">
				<cfset property_name_value = evaluate("xmlPage.property_name_#pro#")>
				<cfset property_value = evaluate("xmlPage.property_#pro#")>
				<cfif listlast(property_name_value) is not 'EMPTY'>
					<cfquery name="add_pro" datasource="#dsn#">
						INSERT INTO
							FUSEACTION_PROPERTY
						(
							FUSEACTION_NAME,
							PROPERTY_NAME,
							PROPERTY_VALUE,
							OUR_COMPANY_ID,
							UPDATE_EMP,
							UPDATE_DATE,
							UPDATE_IP,
							FRIENDLY_URL
						)
						VALUES
						(
							'#xmlPage.page_fuseaction#',
							'<cfif len(property_name_value)>#property_name_value#</cfif>',
							<cfif len(property_value)>'#property_value#'<cfelse>NULL</cfif>,
							#xmlPage.our_company_id#,	
							#session.ep.userid#,
							#now()#,
							'#cgi.remote_addr#',
							<cfif isdefined("xmlPage.friendly_url") and len(xmlPage.friendly_url)>'#xmlPage.friendly_url#'<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cftransaction>
	</cflock>	
</cfif>