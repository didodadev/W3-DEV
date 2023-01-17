<cfquery name="GET_PROP" datasource="#DSN#">
	SELECT PROPERTY_VALUE FROM FUSEACTION_PROPERTY WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PROPERTY_NAME = 'is_module_authority'
</cfquery>
<cfif get_prop.recordcount>
	<cfset inner_module_control = get_prop.property_value>
<cfelse>
	<cfset inner_module_control = 1>
</cfif>
<cfif inner_module_control eq 1>
	<cfset module_pass = 0>
	<cfloop list="#attributes.module_id_control#" index="ccc">
		<cfif get_module_user(ccc)>
			<cfset module_pass = 1>
		</cfif>
	</cfloop>
	<cfif module_pass eq 0>
		<cfset hata = 11>
		<cfsavecontent variable="hata_mesaj"><cf_get_lang dictionary_id="29985.Bu Raporu Görüntülemeye Yetkili Değilsiniz!"></cfsavecontent>
		<cfinclude template="../../dsp_hata.cfm">
		<cfabort>
	</cfif>
</cfif>

