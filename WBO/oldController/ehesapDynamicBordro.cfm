<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="ehesap">
	<cfparam name="attributes.is_excel" default="">
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		SELECT
			EXPENSE,
			EXPENSE_CODE
		FROM
			EXPENSE_CENTER
		WHERE
			EXPENSE_ACTIVE = 1
		ORDER BY
			EXPENSE_CODE
	</cfquery>
	<cfquery name="get_department" datasource="#dsn#">
		SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN (#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
	</cfquery>
	<cfquery name="get_department2" datasource="#dsn#">
		SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.position_branch_id") and len(attributes.position_branch_id)>BRANCH_ID IN (#attributes.position_branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
	</cfquery>
	<cfquery name="get_company" datasource="#dsn#">
		SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
	</cfquery>
	<cfscript>
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		include "../hr/ehesap/query/get_ssk_offices.cfm";
		include "../hr/ehesap/display/view_dynamic_bordro_groups.cfm";
		if (isdefined("attributes.b_obj_hidden"))
		{
			puantaj_gun_ = daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1));
			get_puantaj_ = createObject("component", "hr.ehesap.cfc.get_dynamic_bordro");
			get_puantaj_.dsn = dsn;
			get_puantaj_.dsn_alias = dsn_alias;
			get_puantaj_rows = get_puantaj_.get_dynamic_bordro
			(
				sal_year : attributes.sal_year,
				sal_mon : attributes.sal_mon,
				sal_year_end : attributes.sal_year_end,
				sal_mon_end : attributes.sal_mon_end,
				puantaj_type : attributes.puantaj_type,
				keyword:attributes.keyword,
				sort_type: attributes.sort_type,
				upper_position_code:attributes.upper_position_code,
				upper_position :attributes.upper_position,
				upper_position_code2:attributes.upper_position_code2,
				upper_position2:attributes.upper_position2,
				branch_id: '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#' ,
				comp_id: '#iif(isdefined("attributes.comp_id"),"attributes.comp_id",DE(""))#',
				department:'#iif(isdefined("attributes.department"),"attributes.department",DE(""))#',
				position_branch_id:'#iif(isdefined("attributes.position_branch_id"),"attributes.position_branch_id",DE(""))#',
				position_department:'#iif(isdefined("attributes.position_department"),"attributes.position_department",DE(""))#',
				is_all_dep:'#iif(isdefined("attributes.is_all_dep"),"attributes.is_all_dep",DE(""))#',
				is_dep_level:'#iif(isdefined("attributes.is_dep_level"),"attributes.is_dep_level",DE(""))#',
				ssk_statute:'#iif(isdefined("attributes.ssk_statute"),"attributes.ssk_statute",DE(""))#',
				main_payment_control:'#iif(isdefined("attributes.main_payment_control"),"attributes.main_payment_control",DE(""))#',
				department_level:'#iif(isdefined("attributes.is_dep_level"),"1","0")#'
			);
		}
		
		get_main_payment_control = QueryNew("PAYMENT_CONTROL_ID,PAYMENT_CONTROL","Integer,VarChar");
		row_of_query = 0;
		row_of_query = row_of_query + 1;
		QueryAddRow(get_main_payment_control,1);
		QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL_ID","-1",row_of_query);
		QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL","#lang_array.item[702]#",row_of_query);
		row_of_query = row_of_query + 1;
		QueryAddRow(get_main_payment_control,1);
		QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL_ID","0",row_of_query);
		QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL","#lang_array.item[705]#",row_of_query);
		row_of_query = row_of_query + 1;
		QueryAddRow(get_main_payment_control,1);
		QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL_ID","1",row_of_query);
		QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL","#lang_array.item[717]#",row_of_query);
		
		get_ssk_statute = QueryNew("SSK_STATUTE_ID,SSK_STATUTE","Integer,VarChar");
		row_of_query = 0;
		
		if (isdefined("attributes.b_obj_hidden") and get_puantaj_rows.recordcount and isdefined("attributes.branch_id") and listlen(attributes.branch_id))
		{
			include "../hr/ehesap/query/get_branch.cfm";
		}
	</cfscript>
	<cfif isdefined("attributes.b_obj_hidden") and get_puantaj_rows.recordcount and isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
		<cfquery name="get_comp_id" dbtype="query">
			SELECT COMPANY_ID FROM GET_BRANCH
		</cfquery>
		<cfif listlen(attributes.branch_id) eq 1 or (isdefined("get_comp_id.comp_id") and listlen(valuelist(get_comp_id.comp_id,',')) and listlen(valuelist(get_comp_id.comp_id,',')) eq 1)>
			<cfinclude template="../hr/ehesap/display/dynamic_bordro_parameters.cfm">
		</cfif>
	</cfif>
	<cfquery name="get_main_payment_control" dbtype="query">
		SELECT PAYMENT_CONTROL_ID,PAYMENT_CONTROL FROM get_main_payment_control
	</cfquery>
	<cfloop list="#list_ucret()#" index="kk">
		<cfscript>
			row_of_query = row_of_query + 1;
			QueryAddRow(get_ssk_statute,1);
			QuerySetCell(get_ssk_statute,"SSK_STATUTE_ID","#kk#",row_of_query);
			QuerySetCell(get_ssk_statute,"SSK_STATUTE","#listgetat(list_ucret_names(),listfindnocase(list_ucret(),kk,','),'*')#",row_of_query);
		</cfscript>
	</cfloop>
	<cfquery name="get_ssk_statute" dbtype="query">
		SELECT SSK_STATUTE_ID,SSK_STATUTE FROM get_ssk_statute
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(){
			$('#branch_tb').css('width',$('#list_tb').css('width'));
			$('#keyword').focus();
		});
		function duzenle_bordro(siram)
		{
			if(siram==0)
			{
				goster(SHOW_BORDRO_0);
				<cfset sira_ = 0>
				<cfloop list="#b_coloum_groups#" index="ccc">
					<cfset sira_ = sira_ + 1>
					gizle(SHOW_BORDRO_<cfoutput>#sira_#</cfoutput>);
				</cfloop>
			}
			else
			{
				gizle(SHOW_BORDRO_0);
				
				<cfset sira_ = 0>
				<cfloop list="#b_coloum_groups#" index="ccc">
					<cfoutput>
						<cfset sira_ = sira_ + 1>
						gizle(SHOW_BORDRO_#sira_#);
					</cfoutput>
				</cfloop>
				goster(eval('SHOW_BORDRO_'+siram));
			}
		}
		function open_form_ajax()
		{
			b_obj_ = '';
			b_obj_sira_ = '';
			for(i=0; i<document.employee.b_objects.length; i++)
			{
				if(document.employee.b_objects[i].checked == true)
				{
					if(b_obj_ == '')
						b_obj_ = document.employee.b_objects[i].value;
					else
						b_obj_ = b_obj_ + ',' + document.employee.b_objects[i].value;
					if(b_obj_sira_ == '')
						b_obj_sira_ = document.employee.b_objects_sira[i].value;
					else
						b_obj_sira_ = b_obj_sira_ + ',' + document.employee.b_objects_sira[i].value;
				}
			}
			if(b_obj_ == '')
			{
				alert('En Az Bir Kolon Seçmelisiniz!');
				return false;
			}
			if (parseInt($('#sal_year').val()) == parseInt($('#sal_year_end').val()))
			{
				if (parseInt($('#sal_mon').val()) > parseInt($('#sal_mon_end').val()))
				{
					alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>.");
					return false;
				}
			}
			else if (parseInt($('#sal_year').val()) > parseInt($('#sal_year_end').val()))
			{
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>.");
				return false;
			}
			
			$('#b_obj_hidden').val(b_obj_);
			$('#b_obj_sira_hidden').val(b_obj_sira_);
			//if(document.employee.is_excel.checked == true)
			//	employee.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_list_dynamic_bordro</cfoutput>';
			//else
				employee.action='<cfoutput>#request.self#?fuseaction=ehesap.list_dynamic_bordro</cfoutput>';
			return true;
		}
		function get_branch_list(gelen)
		{		
			checkedValues_b = $("#comp_id").multiselect("getChecked");
			var comp_id_list='';
			for(kk=0;kk<checkedValues_b.length; kk++)
			{
				if(comp_id_list == '')
					comp_id_list = checkedValues_b[kk].value;
				else
					comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
			}
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&is_ssk_offices=1&comp_id="+comp_id_list;
			AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
		}
		function get_department_list(gelen)
		{
			checkedValues_b = $("#branch_id").multiselect("getChecked");
			var branch_id_list='';
			for(kk=0;kk<checkedValues_b.length; kk++)
			{
				if(branch_id_list == '')
					branch_id_list = checkedValues_b[kk].value;
				else
					branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
			}
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
		function get_department_list2(gelen)
		{
			checkedValues_c = $("#position_branch_id").multiselect("getChecked");
			var branch_id_list_2='';
			for(kk=0;kk<checkedValues_c.length; kk++)
			{
				if(branch_id_list_2 == '')
					branch_id_list_2 = checkedValues_c[kk].value;
				else
					branch_id_list_2 = branch_id_list_2 + ',' + checkedValues_b[kk].value;
			}
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department2&branch_id="+branch_id_list_2;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE2',1,'İlişkili Departmanlar');
		}
		function hepsini_sec()
		{
			var theForm = document.employee;
			for(i=0; i<theForm.elements.length; i++)
			{
				if(theForm.elements[i].type == "checkbox" && theForm.elements[i].id != 'is_excel')
				{
					if(document.getElementById('is_hepsi').checked)
					{
						theForm.elements[i].checked = true;
					}
					else
					{
						theForm.elements[i].checked = false;
					}
				}
		   }
		}
		function department_level_chckbx(i)
		{
			if (i == true)
			{
				$('#department_level_td').css('display','');
				$('#alt_departman_td').css('display','');
			}
			else
			{
				$('#department_level_td').css('display','none');
				$('#alt_departman_td').css('display','none');
				document.getElementById('is_dep_level').checked = false;
				document.getElementById('is_all_dep').checked = false;
			}
		}
		function change_mon(i)
		{
			$('#sal_mon_end').val(i);
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_dynamic_bordro';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_dynamic_bordro.cfm';
</cfscript>
