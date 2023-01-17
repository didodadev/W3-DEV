<cfscript>
    if(attributes.tabMenuController eq 0)
	    {
            WOStruct = StructNew();

            WOStruct['#attributes.fuseaction#'] = structNew();

            WOStruct['#attributes.fuseaction#']['default'] = 'list';

            /* if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default']; */
            WOStruct['#attributes.fuseaction#']['list'] = structNew();
		    WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/mail_server_settings.cfm';
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.list_mail_server_settings';
	    	/* WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = ''; */

            WOStruct['#attributes.fuseaction#']['add'] = structNew();
		    WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.list_mail_server_settings';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/mail_server_settings.cfm';
		    WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_mail_server.cfm';

            if(isDefined("attributes.event") and listFind('del,upd', attributes.event)){
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_mail_server_settings';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_mail_server_settings.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_mail_server.cfm';


                WOStruct['#attributes.fuseaction#']['del'] = structNew();
                WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
                WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'settings.list_mail_server_settings&cpid=#attributes.cpid#';
                WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_mail_server.cfm';
                WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_mail_server.cfm';
            }
        }
</cfscript>
