
<!---
File: draw_organization_chart.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 11.02.2020
Controller: -
Description: Organizasyon Şema Chart
--->
<cfset organization_component= createObject("component","V16.hr.cfc.organization_chart") />
<cfif isdefined("attributes.type") and attributes.type eq 1>
    <cfset get_organization = organization_component.getOrganizationSchema(
        manager_nr : (isdefined("attributes.management_id")) ? "#attributes.management_id#" : "",
        headquarter_id : (isdefined("attributes.headquarters_id")) ? "#attributes.headquarters_id#" : "",
        company_id : (isdefined("attributes.company_id")) ? "#attributes.company_id#" : "",
        branch_id : (isdefined("attributes.branch_id")) ? "#attributes.branch_id#" : "",
        department_id : (isdefined("attributes.department_id")) ? "#attributes.department_id#" : "",
        organization_date :  (isdefined("attributes.organization_date")) ? "#attributes.organization_date#" : "",
        is_position :  (isdefined("attributes.is_position")) ? "#attributes.is_position#" : "",
        is_position_type :  (isdefined("attributes.is_position_type")) ? "#attributes.is_position_type#" : "",
        is_photo :  (isdefined("attributes.is_photo")) ? "#attributes.is_photo#" : "",
        is_title :  (isdefined("attributes.is_title")) ? "#attributes.is_title#" : ""
    )>
    <cfoutput>#get_organization#</cfoutput>
<cfelse>
    <cf_date tarih="attributes.organization_date">
    <cfset get_positions = organization_component.getSchema(
        position_code : (isdefined("attributes.upper_position_code")) ? "#attributes.upper_position_code#" : "",
        relation_type : (isdefined("attributes.baglilik")) ? "#attributes.baglilik#" : "",
        up_step_count : (isdefined("attributes.ust_cizim_sayisi")) ? "#attributes.ust_cizim_sayisi#" : "",
        down_step_count : (isdefined("attributes.alt_cizim_sayisi")) ? "#attributes.alt_cizim_sayisi#" : "",
        company_id : (isdefined("attributes.company_id_")) ? "#attributes.company_id_#" : "",
        organization_date :  (isdefined("attributes.organization_date")) ? "#attributes.organization_date#" : "",
        is_position :  (isdefined("attributes.is_position")) ? "#attributes.is_position#" : "",
        is_position_type :  (isdefined("attributes.is_position_type")) ? "#attributes.is_position_type#" : "",
        is_photo :  (isdefined("attributes.is_photo")) ? "#attributes.is_photo#" : "",
        is_title :  (isdefined("attributes.is_title")) ? "#attributes.is_title#" : ""
    )> 
    <cfoutput>#get_positions#</cfoutput>
</cfif>