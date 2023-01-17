<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="ehesap">
	<cfparam name="attributes.sal_year" default="#year(now())#">
	<cfscript>
		include "../hr/ehesap/query/get_ssk_offices.cfm";
		cmp_zone = createObject("component","hr.cfc.get_zones");
		cmp_zone.dsn = dsn;
		zones = cmp_zone.get_zone();
	</cfscript>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function open_form_ajax()
		{
			var queryStrings = GetFormData(employee);
			//alert(queryStrings);
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_view_bordro_bread_ajax</cfoutput>&' + queryStrings,'bordro_list_layer',1,'<cf_get_lang no ="775.Bordro Görüntüleniyor">');
		}
	
		function get_branch_list(gelen)
		{
			document.getElementById('ssk_office').options.length = 0;
			var document_id = document.getElementById('zone_id').options.length;	
			var document_name = '';
			for(i=0;i<document_id;i++)
			{
				if(document.employee.zone_id.options[i].selected && document_name.length==0)
					document_name = document_name + document.employee.zone_id.options[i].value;
				else if(document.employee.zone_id.options[i].selected)
					document_name = document_name + ',' + document.employee.zone_id.options[i].value;
			}
	
			if (document.employee.zone_id.options[0].selected)
			{
				var get_department_name_ = wrk_query('SELECT BRANCH_NAME, SSK_OFFICE, SSK_NO,BRANCH_ID FROM BRANCH WHERE BRANCH_STATUS = 1','dsn');
				if(get_department_name_.recordcount != 0)
				{
					for(var xx = 0; xx < get_department_name_.recordcount; xx++)
						document.employee.ssk_office.options[xx + 1] = new Option(get_department_name_.BRANCH_NAME[xx], get_department_name_.SSK_OFFICE[xx] + '-' + get_department_name_.SSK_NO[xx]+ '-' + get_department_name_.BRANCH_ID[xx]);
				}
			}
	
			var get_department_name = wrk_query('SELECT BRANCH_NAME, SSK_OFFICE, SSK_NO,BRANCH_ID FROM BRANCH WHERE BRANCH_STATUS = 1 AND ZONE_ID IN ('+document_name+')','dsn');
			document.employee.ssk_office.options[0] = new Option('<cf_get_lang_main no="41.Sube">','')
			if(get_department_name.recordcount != 0)
			{
				for(var xx=0;xx<get_department_name.recordcount;xx++)
					document.employee.ssk_office.options[xx+1]=new Option(get_department_name.BRANCH_NAME[xx],get_department_name.SSK_OFFICE[xx] + '-' + get_department_name.SSK_NO[xx]+ '-' + get_department_name.BRANCH_ID[xx]);
				document.employee.ssk_office.options[0].selected = true;
			}
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_bordro_bread_discount';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_bordro_bread_discount.cfm';
</cfscript>
