<cf_get_lang_set module_name ="assetcare">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
    <cfparam name="attributes.keyword" default="">
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_zimmet" datasource="#dsn#">
            SELECT 
                EI.*,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME ,
                E.EMPLOYEE_ID
            FROM 
                EMPLOYEES_INVENT_ZIMMET EI,
                EMPLOYEES E
            WHERE
                E.EMPLOYEE_ID=EI.EMPLOYEE_ID AND
                (E.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%')
        </cfquery>
    <cfelse>
        <cfset get_zimmet.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_zimmet.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfif isdefined("attributes.zimmet_id") and len(attributes.zimmet_id)>
        <cfquery name="get_zimmet_row" datasource="#dsn#">
            SELECT * FROM EMPLOYEES_INVENT_ZIMMET_ROWS WHERE ZIMMET_ID = #attributes.zimmet_id#
        </cfquery>
        <cfquery name="get_our_comp" datasource="#DSN#">
            SELECT NICK_NAME,COMP_ID FROM OUR_COMPANY
        </cfquery>
        <cfquery name="get_zimmet" datasource="#dsn#">
            SELECT 
                ZIMMET_ID, 
                COMPANY_ID, 
                EMPLOYEE_ID, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP
            FROM 
                EMPLOYEES_INVENT_ZIMMET 
            WHERE 
                ZIMMET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zimmet_id#">
        </cfquery>
        <cfquery name="get_employee_name" datasource="#dsn#">
            SELECT 
                EMPLOYEE_ID,
                EMPLOYEE_NAME,
                EMPLOYEE_NO,
                EMPLOYEE_SURNAME 
            FROM 
                EMPLOYEES		
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_zimmet.employee_id#">
        </cfquery>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfquery name="get_our_comp" datasource="#DSN#">
        SELECT NICK_NAME, COMP_ID FROM OUR_COMPANY
    </cfquery>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
		$(document).ready(function(){
			row_count=0;
			});
		
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			document.assetp_zimmet.record_num.value=row_count;
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);	
			newCell = newRow.insertCell(newRow.cells.length);	
			newCell.innerHTML = '<a style="cursor:hand" onclick="sil('+ row_count +');"><img  src="images/delete_list.gif" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" value="1"  name="row_kontrol' + row_count +'" ><input type="text" name="device_name' + row_count + '" style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '"style="width:100px;"><input  type="hidden" name="asset_id_' + row_count +'" value="0">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="property_' + row_count + '"style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","tarih" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10" style="width:100px;" value="">&nbsp;';
			wrk_date_image('tarih' + row_count);
		}
		
		
		function bilgi_al()
		{
			for(var i=1;i<=row_count;i++)
			{
				var my_element=eval("assetp_zimmet.row_kontrol"+i);
				my_element.value=0;
				var my_element=eval("frm_row"+i);
				my_element.style.display="none";	
			}
			
			var get_emp_asset = wrk_safe_query('ascr_get_emp_asset','dsn',0,document.assetp_zimmet.position_code.value);
			for(var j=0;j<get_emp_asset.recordcount;j++)
			{
				row_count++;
				var newRow;
				var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				document.assetp_zimmet.record_num.value=row_count;
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);
				newCell = newRow.insertCell(newRow.cells.length);	
				newCell.innerHTML = '<a style="cursor:hand" onclick="sil('+ row_count +');"><img  src="images/delete_list.gif" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input  type="hidden" value="1"  name="row_kontrol' + row_count +'"><input  type="hidden" name="asset_id_' + row_count +'" value="'+get_emp_asset.ASSETP_ID[j]+'"><input type="text" name="device_name' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP[j]+'">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP_ID[j]+'">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="property_' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP_CAT[j]+'">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","tarih" + row_count + "_td");
				newCell.innerHTML = '<input type="text" name="tarih' + row_count +'" class="text" maxlength="10" style="width:100px;" value="">';
				wrk_date_image('tarih' + row_count);
			}
		}
			
		function kontrol()
		{
				record_exist=0;
				for(r=1;r<=assetp_zimmet.record_num.value;r++)
				{
					deger_row_kontrol = eval("document.assetp_zimmet.row_kontrol"+r);
					if(deger_row_kontrol.value == 1)
					{
						record_exist=1;
					}
				}
				if (record_exist == 0) 
				{
					alert("<cf_get_lang no='607.Lütfen Satır Ekleyiniz' >!");
					return false;
				}
				return true;	
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		$(document).ready(function(){
			row_count=<cfoutput>#get_zimmet_row.recordcount#</cfoutput>;
			});
		
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			document.assetp_zimmet.record_num.value=row_count;
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');	
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil('+ row_count +');"><img  src="images/delete_list.gif" alt="" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input  type="hidden" value="1"  name="row_kontrol' + row_count +'" ><input type="text" name="device_name' + row_count + '"style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '"style="width:55px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="text" name="property_' + row_count + '"style="width:100px;"><input  type="hidden" name="asset_id_' + row_count +'" value="0">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.setAttribute("id","tarih" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10" style="width:65px;" value="">';
			wrk_date_image('tarih' + row_count);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML =	'<input type="hidden" name="given_id_' + row_count +'"><input type="text" name="given_name_' + row_count  +'" style="width:130px;"> <a href="javascript://" onClick="opage('+ row_count +');"><img src="/images/plus_thin.gif" alt="" align="absmiddle" border="0"></a><input type="hidden" name="is_active_' + row_count +'">';
		}
		
		function opage(deger)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=assetp_zimmet.given_id_' + deger + '&select_list=1&field_name=assetp_zimmet.given_name_' + deger,'list');
		}
		function opage2(deger)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=assetp_zimmet.taken_id_' + deger + '&select_list=1&field_name=assetp_zimmet.taken_name_' + deger,'list');
		}	
		
		function bilgi_al()
		{
			var get_emp_asset = wrk_safe_query('ascr_get_emp_asset','dsn',0,document.assetp_zimmet.position_code.value);
			for(var j=0;j<get_emp_asset.recordcount;j++)
			{
				row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				document.assetp_zimmet.record_num.value=row_count;
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);
				newCell = newRow.insertCell();	
				newCell.innerHTML = '<a style="cursor:pointer" onclick="sil('+ row_count +');"><img  src="images/delete_list.gif" border="0" alt=""></a>';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input  type="hidden" value="1"  name="row_kontrol' + row_count +'"><input  type="hidden" name="asset_id_' + row_count +'" value="'+get_emp_asset.ASSETP_ID[j]+'"><input type="text" name="device_name' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP[j]+'">';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '"style="width:55PX;" value="'+get_emp_asset.ASSETP_ID[j]+'">';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" name="property_' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP_CAT[j]+'">';
				newCell = newRow.insertCell();
				newCell.setAttribute("id","tarih" + row_count + "_td");
				newCell.innerHTML = '<input type="text" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10" style="width:65PX;" value="">';
				wrk_date_image('tarih' + row_count);
				newCell = newRow.insertCell();
				newCell.innerHTML =	'<input type="hidden" name="given_id_' + row_count +'"><input type="text" name="given_name_' + row_count  +'" style="width:130px;"> <a href="javascript://" onClick="opage('+ row_count +');"><img src="/images/plus_thin.gif"  alt="" align="absmiddle" border="0"></a><input type="hidden" name="is_active_' + row_count +'">';
			}
		}
			
	</cfif>
	
	function sil(sy)
	{
		var my_element=eval("assetp_zimmet.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";	
	}
</script> 
<cfscript>
WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.popup_form_add_zimmet';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'assetcare/form/form_add_zimmet.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'assetcare/query/add_inventory_zimmet.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_inventory_zimmet&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.popup_form_upd_zimmet';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'assetcare/form/form_upd_zimmet.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'assetcare/query/upd_inventory_zimmet.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_inventory_zimmet&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'assetp_id=##attributes.zimmet_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.zimmet_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_inventory_zimmet';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'assetcare/display/list_inventory_zimmet.cfm';
	
	if(isdefined('attributes.event') and attributes.event eq 'upd'){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_inventory_zimmet&event=add&window=popup";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		if( isdefined("attributes.zimmet_id") and len(attributes.zimmet_id)){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=252&action_id=#attributes.zimmet_id#','page')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'assetcareZimmetController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_INVENT_ZIMMET';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-position_code','item-company_id']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
	
</cfscript>
