<cfif (isdefined("attributes.event") and attributes.event is 'upd') or not isdefined("attributes.event")>
    <cfinclude template="../hr/ehesap/query/get_hours_all.cfm"> 
</cfif>	
<cfif isdefined('attributes.event')><!--- add ve upd eventinde gelecek--->
    <cfinclude template="../settings/query/get_our_companies.cfm">
	<script type="text/javascript">
        function unformat_fields()
        {
            document.form_add.ssk_monthly_work_hours.value=filterNum(document.form_add.ssk_monthly_work_hours.value);
            document.form_add.daily_work_hours.value=filterNum(document.form_add.daily_work_hours.value);
            document.form_add.SSK_WORK_HOURS.value=filterNum(document.form_add.SSK_WORK_HOURS.value);
            document.form_add.SATURDAY_WORK_HOURS.value=filterNum(document.form_add.SATURDAY_WORK_HOURS.value);
            return true;
        }
    </script>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.hours';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/hours.cfm';
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_our_comp_hours';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_our_comp_hours.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_our_comp_hours.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.hours';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_our_comp_hours';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_our_comp_hours.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_our_comp_hours.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.hours';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapHoursController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'OUR_COMPANY_HOURS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-OUR_COMPANY_ID']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

</cfscript>
