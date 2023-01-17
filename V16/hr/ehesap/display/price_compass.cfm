<cf_xml_page_edit fuseact="ehesap.popup_view_price_compass">
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
    <cfset employee_id = "&employee_id="&attributes.employee_id&"&sal_mon=1&sal_mon_end=12">
<cfelse>
    <cfset employee_id = "">
</cfif>
<iframe frameborder="0" src="<cfoutput>#request.self#?fuseaction=ehesap.popup_view_price_compass&style=one#employee_id#</cfoutput>" width="100%" height="1000"></iframe>
