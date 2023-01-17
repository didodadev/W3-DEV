
<cfparam name="attributes.request_plan" default="0">
<cfparam name="attributes.workmanship_plan" default="0">
<cf_xml_page_edit fuseact="textile.list_sample_request">
<cfif isdefined("attributes.gm")>
		<cfinclude template="dsp_workmanship_pricedemand_gm.cfm">
<cfelse>
		<cfinclude template="dsp_workmanship_pricedemand.cfm">
</cfif>
