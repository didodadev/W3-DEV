<cf_get_lang_set module_name = "stock">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.process_stage_type" default="">
    <cfparam name="attributes.assetp_id" default="">
    <cfparam name="attributes.assetp_name" default="">
    <cfparam name="attributes.team_employee_id" default="">
    <cfparam name="attributes.team_employee_name" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.planning_date" default="">
    <cfif isdate(attributes.planning_date)><cf_date tarih = "attributes.planning_date"></cfif>
    <cfquery name="get_dispatch_stage" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_dispatch_team_planning%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfif isdefined("attributes.submitted")>
        <cfquery name="get_dispatch_team_planning" datasource="#dsn3#">
            SELECT
                DISPATCH_TEAM_PLANNING.*,
                ASSET_P.ASSETP
            FROM
                DISPATCH_TEAM_PLANNING
                LEFT JOIN #DSN_ALIAS#.ASSET_P ON ASSET_P.ASSETP_ID = DISPATCH_TEAM_PLANNING.ASSETP_ID
            WHERE
                1 = 1
                <cfif Len(attributes.assetp_id) and Len(attributes.assetp_name)>AND ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"></cfif>
                <cfif Len(attributes.process_stage_type) and Len(attributes.process_stage_type)>AND PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#"></cfif>
                <cfif Len(attributes.team_employee_id) and Len(attributes.team_employee_name)>AND TEAM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_employee_id#"></cfif>
                <cfif Len(attributes.keyword)>AND TEAM_ZONES LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                <cfif isdate(attributes.planning_date)>AND PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#"></cfif>
            ORDER BY
                PLANNING_DATE DESC,
                TEAM_CODE
        </cfquery>
    <cfelse>
        <cfset get_dispatch_team_planning.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_dispatch_team_planning.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cf_xml_page_edit fuseact="stock.dispatch_team_planning">
	<cfif isdefined("attributes.planning_id")>
        <cfquery name="get_team_planning" datasource="#dsn3#">
            SELECT 
                DISPATCH_TEAM_PLANNING.*,
                ASSET_P.ASSETP
            FROM 
                DISPATCH_TEAM_PLANNING 
                LEFT JOIN #DSN_ALIAS#.ASSET_P ON ASSET_P.ASSETP_ID = DISPATCH_TEAM_PLANNING.ASSETP_ID
            WHERE 
                PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">
        </cfquery>
    </cfif>
	<cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.assetp_id)>
        <cfif Len(get_team_planning.assetp_id)><!--- Son Km Bilgisini Getir --->
            <cfquery name="get_assetp_km" datasource="#dsn#">
                SELECT TOP 1 KM_FINISH, FINISH_DATE FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_team_planning.assetp_id#"> ORDER BY KM_FINISH DESC,KM_CONTROL_ID DESC
            </cfquery>
            <cfset assetp_km_last_ = get_assetp_km.km_finish>
            <cfset assetp_km_lastdate_ = get_assetp_km.finish_date>
        <cfelse>
            <cfset assetp_km_last_ = 0>
            <cfset assetp_km_lastdate_ = "">
        </cfif>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_xml_page_edit fuseact="stock.dispatch_team_planning">
    <cfquery name="get_team_planning" datasource="#dsn3#">
        SELECT 
            DISPATCH_TEAM_PLANNING.*,
            ASSET_P.ASSETP
        FROM 
            DISPATCH_TEAM_PLANNING 
            LEFT JOIN #DSN_ALIAS#.ASSET_P ON ASSET_P.ASSETP_ID = DISPATCH_TEAM_PLANNING.ASSETP_ID
        WHERE 
            PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">
    </cfquery>
    <cfquery name="get_team_planning_row" datasource="#dsn3#">
        SELECT 
            PLANNING_ROW_ID, 
            PLANNING_ID, 
            TEAM_EMPLOYEE_ID, 
            OVERTIME_PAY, 
            SUNDAY_OVERTIME_PAY, 
            FOOD_PAY 
        FROM 
            DISPATCH_TEAM_PLANNING_ROW 
        WHERE 
            PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">
    </cfquery>
</cfif>
<script type="text/javascript">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	document.getElementById('keyword').focus();
<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
	$( document ).ready(function() {
		row_count_team=document.getElementById('record_num_team').value;
		<cfif isdefined("attributes.event") and attributes.event is 'add'>
			row_count=0;
		<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
			row_count=<cfoutput>#get_team_planning_row.recordcount#</cfoutput>;
		</cfif>
	});
	function kontrol()
	{
		if (document.getElementById('process_stage').value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='70.Aşama'> !");
			return false;
		}
		if(document.getElementById('team_zones').value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='580.Bölge'> !");
			return false;
		}
		if(document.getElementById('planning_date').value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='330.Tarih'> !");
			return false;
		}
		if(document.getElementById('assetp_id').value == '' || document.getElementById('assetp_name').value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1068.Araç'> !");
			return false;
		}
		if(document.getElementById('assetp_km_finishdate').value != '' && datediff(document.getElementById('assetp_km_finishdate').value,document.getElementById('assetp_km_startdate').value,0) > 0)
		{
			alert("<cf_get_lang no='602.Araç Son Km Tarihi Önceki Km Tarihinden Büyük Olmalıdır'> !");
			return false;
		}
		unformat_fields();
		if(document.getElementById('assetp_km_finish').value != '' && parseInt(document.getElementById('assetp_km_start').value) >= parseInt(document.getElementById('assetp_km_finish').value))
		{
			alert("<cf_get_lang no='627.Araç Son Km Değeri Önceki Km Değerinden Büyük Olmalıdır'> !");
			return false;
		}
		<cfif ListFind(x_required_personel_company,session.ep.company_id,',')><!--- Personel Zorunlulugu olacak sirket idleri  --->
			if(document.getElementById('record_num').value == 0)
			{
				alert("<cf_get_lang no='603.Ekip Bilgileri İçin Personel Seçmelisiniz'> !");
				return false;
			}
			else
			{
				for(r=1;r<=document.getElementById('record_num').value;r++)
				{
					if(document.getElementById('row_kontrol'+r).value == 1)
					{
						if(document.getElementById('team_employee_id'+r).value == '' || document.getElementById('team_employee_name'+r).value == '')
						{
							alert(r + ". <cf_get_lang no='604.Satır İçin Personel Seçmelisiniz'> !");
							return false;
						}
					}
				}
		}
		</cfif>
	
		for(i=1;i<=document.getElementById('record_num_team');i++)
		{
			if(document.getElementById('row_kontrol_team'+i).value==1)
			{
				if(document.getElementById('rel_row_name'+i).value == '')
				{
					alert(i + ". Satır İçin Lütfen Üye Seçiniz!");
					return false;
				}
			}
		}
		return true;
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
	
		newRow = document.getElementById('table1').insertRow();
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		
		document.getElementById('record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><img src="/images/delete_list.gif" align="absmiddle" border="0" alt="Sil"></a>';							
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1"  id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'"><input type="hidden" id="team_employee_id'+ row_count +'" name="team_employee_id'+ row_count +'" value=""><input type="text"  id="team_employee_name'+ row_count +'" name="team_employee_name'+ row_count +'" value="" readonly="yes" style="width:155px;"><a href="javascript://" onClick="pencere_ac('+ row_count +');" style="cursor:pointer;"> <img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="Personel Ekle"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" id="overtime_pay'+ row_count +'" name="overtime_pay'+ row_count +'" class="moneybox" onKeyup="return(FormatCurrency(this,event));" style="width:100px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text"  id="food_pay'+ row_count +'" name="food_pay'+ row_count +'" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" style="width:100px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" id="sunday_overtime_pay'+ row_count +'" name="sunday_overtime_pay'+ row_count +'" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" style="width:100px;">';
	}
	
	function sil(sy)
	{
		var my_element= document.getElementById('row_kontrol'+sy).value =0; 
		document.getElementById('frm_row'+sy).style.display ='none'; 
/*		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
*/	}
	
	function add_row_dispatch()
	{
		row_count_team++;
		var newRowDis;
		var newCellDis;
		newRowDis = document.getElementById("table_team").insertRow(document.getElementById("table_team").rows.length);
		newRowDis.setAttribute("name","frm_row_dispatch" + row_count_team);
		newRowDis.setAttribute("id","frm_row_dispatch" + row_count_team);	
		document.getElementById('record_num_team').value=row_count_team;
		newCellDis = newRowDis.insertCell(newRowDis.cells.length);
		newCellDis.innerHTML = '<input type="hidden"  id="row_kontrol_team'+row_count_team+'" name="row_kontrol_team'+row_count_team+'" value="1"><a style="cursor:pointer" onclick="sil_dispatch(' + row_count_team + ');"><img src="images/delete_list.gif" border="0"></a>';
		newCellDis = newRowDis.insertCell(newRowDis.cells.length);
		newCellDis.innerHTML = '<input type="text"  id="rel_row_name'+row_count_team+'" name="rel_row_name'+row_count_team+'" value="" style="width:155px;" readonly> <input type="hidden"  id="rel_cons_id'+row_count_team+'" name="rel_cons_id'+row_count_team+'" value=""><input type="hidden"  id="rel_comp_id'+row_count_team+'" name="rel_comp_id'+row_count_team+'" value=""><a href="javascript://" onClick="pencre_ac_team('+row_count_team+');"><img border="0" src="/images/plus_thin.gif" align="absmiddle"></a>';
	}
	function sil_dispatch(sy)
	{
		document.getElementById('row_kontrol_team'+sy).value =0;
		document.getElementById('frm_row_dispatch'+sy).style.display="none";
	}
	function pencre_ac_team(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=7,8&field_consumer=teamPlanning.rel_cons_id'+no+'&field_comp_id=teamPlanning.rel_comp_id'+no+'&field_member_name=teamPlanning.rel_row_name'+no,'list');
	}	
	function pencere_ac(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=teamPlanning.team_employee_id'+ no +'&field_name=teamPlanning.team_employee_name'+ no +'&select_list=1','list');
	}
	
	function unformat_fields()
	{
		document.getElementById('assetp_km_start').value = filterNum(document.getElementById('assetp_km_start').value);
		document.getElementById('assetp_km_finish').value = filterNum(document.getElementById('assetp_km_finish').value);
		for(r=1;r<=document.getElementById('record_num').value;r++)
		{
			document.getElementById('overtime_pay'+r).value = filterNum(document.getElementById('overtime_pay'+r).value);
			document.getElementById('food_pay'+r).value = filterNum(document.getElementById('food_pay'+r).value);
			document.getElementById('sunday_overtime_pay'+r).value = filterNum(document.getElementById('sunday_overtime_pay'+r).value);
		}	
	}
</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_dispatch_team_planning';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_dispatch_team_planning.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.list_dispatch_team_planning&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/add_dispatch_team_planning.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_dispatch_team_planning.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_dispatch_team_planning';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.list_dispatch_team_planning&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/upd_dispatch_team_planning.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_dispatch_team_planning.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_dispatch_team_planning';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'planning_id=##attributes.planning_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.planning_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')       
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.list_dispatch_team_planning&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=stock.list_dispatch_team_planning&event=add&planning_id=#attributes.planning_id#";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockListDispatchTeamPlanning';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'DISPATCH_TEAM_PLANNING';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-assetp_name','item-assetp_km_startdate','item-assetp_name','item-assetp_km_start','item-process_stage','item-planning_date']";
</cfscript>
