<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'upd';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.workcube_license';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/list_workcube_license.cfm';

        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.workcube_license';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_workcube_license.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_workcube_license.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.workcube_license&license_id=';
    }
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WRK_LICENSE';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'LICENSE_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-workcube_id' , 'item-owner_company_id' , 'item-implementetion_project_id' , 'item-support_project_id' , 'item-technical_persons_id' , 'item-technical_person_employee_id' , 'item-implementation_power_user_id' , 'item-implementation_power_user_employee_id' , 'item-workcube_partner_company_id' , 'item-workcube_partner_company_team_id' , 'item-workcube_support_team_id' , 'item-workcube_partner_company_title' , 'item-workcube_partner_company_team' , 'item-implementation_power_user_employee_title' , 'item-technical_person_employee_title' , 'item-owner_company_title' , 'item-owner_company_email', 'item-owner_company_phone', 'item-license_type']";
</cfscript>