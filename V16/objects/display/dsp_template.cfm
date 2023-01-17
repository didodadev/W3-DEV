<!--- Şablonu hazırlanmış bütün sayfaların şablonları --->
<cfif isdefined("attributes.trail") and attributes.trail eq 1>
	<cfinclude template="view_company_logo.cfm">
</cfif>
<!-- sil -->
<cfinclude template="../../#application.objects['#attributes.module#.#attributes.operation#']['filePath']#">

<!-- sil -->
<cfif isdefined("attributes.trail") and attributes.trail eq 1>
	<cfinclude template="view_company_info.cfm">
</cfif>
