<cfset workcube_license = createObject("component","V16.settings.cfc.workcube_license") />

<cfset save_workcube_license = workcube_license.save_license_information(
    license_id : ( IsDefined("attributes.license_id") and len( attributes.license_id ) ) ? attributes.license_id : 0,
    workcube_id : "#attributes.workcube_id#",
    owner_company_id : attributes.owner_company_id,
    implementetion_project_id : attributes.implementetion_project_id,
    implementetion_project_domain : attributes.implementetion_project_domain,
    support_project_id : "#attributes.support_project_id#",
    support_project_domain : "#attributes.support_project_domain#",
    technical_persons_id : "#attributes.technical_persons_id#",
    technical_person_employee_id : "#attributes.technical_person_employee_id#",
    technical_person_employee_title : "#attributes.technical_person_employee_title#",
    implementation_power_user_id : "#attributes.implementation_power_user_id#",
    implementation_power_user_employee_id : "#attributes.implementation_power_user_employee_id#",
    implementation_power_user_employee_title : "#attributes.implementation_power_user_employee_title#",
    workcube_partner_company_id : "#attributes.workcube_partner_company_id#",
    workcube_partner_company_team_id : "#attributes.workcube_partner_company_team_id#",
    workcube_partner_company_team : "#attributes.workcube_partner_company_team#",
    workcube_support_team_id : "#attributes.workcube_support_team_id#",
    workcube_partner_company_title : "#attributes.workcube_partner_company_title#",
    owner_company_title : "#attributes.owner_company_title#",
    owner_company_email : "#attributes.owner_company_email#",
    owner_company_phone : "#attributes.owner_company_phone#",
    license_type : "#attributes.license_type#"
)/>

<cfif save_workcube_license.status>
    <cfset attributes.actionid = ( IsDefined("attributes.license_id") and len( attributes.license_id ) ) ? attributes.license_id : save_workcube_license.result.identitycol />
<cfelse>
    <script>
        alert("<cf_get_lang dictionary_id = '52126.Bir hata oluştu'>!");
        location.reload();
    </script>
</cfif>