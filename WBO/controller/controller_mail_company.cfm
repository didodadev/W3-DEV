<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();

            WOStruct['#attributes.fuseaction#']['default'] = 'list';
            if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];


                WOStruct['#attributes.fuseaction#']['list'] = structNew();
                WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/list_mail_companies.cfm';
                WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.list_mail_companies';
                WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = '';

                WOStruct['#attributes.fuseaction#']['listTemplates'] = structNew();
                WOStruct['#attributes.fuseaction#']['listTemplates']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['listTemplates']['filePath'] = 'V16/settings/display/list_mail_templates.cfm';
                WOStruct['#attributes.fuseaction#']['listTemplates']['fuseaction'] = 'settings.list_mail_companies';
                WOStruct['#attributes.fuseaction#']['listTemplates']['nextEvent'] = '';

                WOStruct['#attributes.fuseaction#']['listMailList'] = structNew();
                WOStruct['#attributes.fuseaction#']['listMailList']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['listMailList']['filePath'] = 'V16/settings/display/list_mail recipient.cfm';
                WOStruct['#attributes.fuseaction#']['listMailList']['fuseaction'] = 'settings.list_mail_companies';
                WOStruct['#attributes.fuseaction#']['listMailList']['nextEvent'] = '';

                WOStruct['#attributes.fuseaction#']['addMailContent'] = structNew();
                WOStruct['#attributes.fuseaction#']['addMailContent']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['addMailContent']['fuseaction'] = 'settings.list_mail_companies';
                WOStruct['#attributes.fuseaction#']['addMailContent']['filePath'] = 'V16/settings/form/mail_company_settings.cfm';
                WOStruct['#attributes.fuseaction#']['addMailContent']['queryPath'] = 'V16/settings/query/mail_company_settings.cfm';
                WOStruct['#attributes.fuseaction#']['addMailContent']['nextEvent'] = 'settings.list_mail_companies&event=addMailContent&tid=';

                WOStruct['#attributes.fuseaction#']['addMailRecipient'] = structNew();
                WOStruct['#attributes.fuseaction#']['addMailRecipient']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['addMailRecipient']['fuseaction'] = 'settings.list_mail_companies';
                WOStruct['#attributes.fuseaction#']['addMailRecipient']['filePath'] = 'V16/settings/form/add_mail_recipient.cfm';
                WOStruct['#attributes.fuseaction#']['addMailRecipient']['queryPath'] = 'V16/settings/query/add_mail_recipient.cfm';
                WOStruct['#attributes.fuseaction#']['addMailRecipient']['nextEvent'] = 'settings.list_mail_companies&event=add_mail_recipient&tid=';

                WOStruct['#attributes.fuseaction#']['addMailTemplate'] = structNew();
                WOStruct['#attributes.fuseaction#']['addMailTemplate']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['addMailTemplate']['fuseaction'] = 'settings.list_mail_companies';
                WOStruct['#attributes.fuseaction#']['addMailTemplate']['filePath'] = 'V16/settings/form/add_mail_template.cfm';
                WOStruct['#attributes.fuseaction#']['addMailTemplate']['queryPath'] = 'V16/settings/query/add_mail_template.cfm';
                WOStruct['#attributes.fuseaction#']['addMailTemplate']['nextEvent'] = 'settings.list_mail_companies&event=updTemplate&tid=';

            if(isDefined("attributes.event") and listFind('updMailTemplate', attributes.event)){
                WOStruct['#attributes.fuseaction#']['updMailTemplate'] = structNew();
                WOStruct['#attributes.fuseaction#']['updMailTemplate']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['updMailTemplate']['fuseaction'] = 'settings.list_mail_companies';
                WOStruct['#attributes.fuseaction#']['updMailTemplate']['filePath'] = 'V16/settings/form/upd_mail_template.cfm';
                WOStruct['#attributes.fuseaction#']['updMailTemplate']['queryPath'] = 'V16/settings/query/upd_mail_template.cfm';
                WOStruct['#attributes.fuseaction#']['updMailTemplate']['nextEvent'] = 'settings.list_mail_companies&event=updTemplate&tid=';
                WOStruct['#attributes.fuseaction#']['updMailTemplate']['Identity'] = '#attributes.tid#';
            }
    }
</cfscript>