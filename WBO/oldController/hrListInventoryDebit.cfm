<cf_get_lang_set module_name='hr'>
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('add',attributes.event)>
    <cfquery name="get_emp" datasource="#DSN#">
        SELECT
            ZIMMET_ID
        FROM
            EMPLOYEES_INVENT_ZIMMET
        WHERE
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfquery>
    
    <cfif get_emp.recordcount>
        <script type="text/javascript">
            alert("Seçtiginiz Çalışana Ait Zimmet Kaydı Bulunmaktadır!");
            history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfif isdefined("attributes.is_form_submitted")>
		<cfquery name="get_zimmet" datasource="#dsn#">
			SELECT
				EI.ZIMMET_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME 
			FROM 
				EMPLOYEES_INVENT_ZIMMET EI
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
			WHERE
				1=1
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
					AND	
					(E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
						E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
						E.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
					)
				</cfif>
                AND EI.COMPANY_ID = #session.ep.company_id#
		</cfquery>
		<cfparam name="attributes.totalrecords" default='#get_zimmet.recordcount#'>
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfelseif isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'add')>
	<cfquery name="get_our_comp" datasource="#DSN#">
    	SELECT 
        	NICK_NAME,
            COMP_ID 
       	FROM 
        	OUR_COMPANY
    </cfquery>
    <cfif attributes.event is 'upd'>
	    <cfinclude template="../hr/query/get_zimmet_detail.cfm">
	    <cfquery name="get_zimmet_row" datasource="#DSN#">
	    	SELECT 
	            ZIMMET_ID, 
	            DEVICE_NAME, 
	            INVENTORY_NO, 
	            PROPERTY, 
	            ZIMMET_DATE, 
	            GIVEN_EMP_ID,
	            ASSET_ID 
	        FROM 
	            EMPLOYEES_INVENT_ZIMMET_ROWS 
	        WHERE 
	            ZIMMET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zimmet_id#">
	    </cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		$(document).ready(function() {
			<cfif attributes.event is 'add'>
				row_count=0;
			<cfelseif attributes.event is 'upd'>
				row_count=<cfoutput>#get_zimmet_row.recordcount#</cfoutput>;
			</cfif>
			
		});
		function sil(sy)
		{
			row_control = $('#record_num').val();
			$('#row_kontrol'+sy).val(0);
			var my_elementx = document.getElementById('frm_row' + sy);
			my_elementx.parentNode.removeChild(my_elementx);
			row_control--;
			$('#record_num').val(row_control);
		}

		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			$('#record_num').val(row_count);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			newCell = newRow.insertCell(newRow.cells.length);	
			newCell.innerHTML = '<i class="icon-trash-o btnPointer" onclick="sil('+ row_count +');"></i>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'"><input type="text" name="device_name' + row_count + '"style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '"style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="property_' + row_count + '"style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			
			newCell.setAttribute("id","tarih" + row_count + "_td");
			newCell.innerHTML = '<input type="text" data-format="date" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10" style="width:100px;" value="" data-msg="<cf_get_lang_main no='1091.Lütfen Tarih Giriniz'>">';
			wrk_date_image('tarih' + row_count);
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML =	'<input type="hidden" name="given_id_' + row_count +'" id="given_id_' + row_count +'"><input type="text" id="given_name_' + row_count +'" name="given_name_' + row_count +'" style="width:130px;" data-msg="<cf_get_lang no='1222.Teslim Eden Giriniz'>"> <i class="icon-ellipsis btnPointer" onClick="opage('+ row_count +');"></i><input type="hidden" name="is_active_' + row_count +'">';
		}
		
		function opage(deger)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_inventory_zimmet.given_id_' + deger + '&field_emp_name=add_inventory_zimmet.given_name_' + deger,'list');
		}
		
		function kontrol()
		{
			var formName = 'add_inventory_zimmet',
  			form = $('form[name="'+ formName +'"]');

			if (form.find('input#employee_id').val() =='' && form.find('input#employee_name').val() == ''){
				validateMessage('notValid',form.find('input#employee_name'),0);
				return false;
			}else{
				validateMessage('valid', form.find('input#employee_name') );
			}
			
			row_count = $('#record_num').val();
			if(row_count == 0)
			{
				alertObject({ message : 'Satır Eklemelisiniz', closeTime: 5000, type: 'warning'});
				return false;
			}
			if(row_count>0)
			{
				for(var i=1; i<=row_count; i++)
				{	
					if($('#frm_row'+i) != undefined && $('#frm_row'+i) != null)
					{
						if (form.find('input#tarih'+i).val() ==''){
							validateMessage('notValid',form.find('input#tarih'+i) );
							return false;
						}else{
							validateMessage('valid', form.find('input#tarih'+i) );
						}
						
						if (form.find('input#given_id_'+i).val() =='' && form.find('input#given_name_'+i).val() ==''){
							validateMessage('notValid',form.find('input#given_name_'+i) );
							return false;
						}else{
							validateMessage('valid', form.find('input#given_name_'+i) );
						}
					}
				}
			}
			return true;
		}
		<cfif attributes.event is 'upd'>
			function opage2(deger)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_inventory_zimmet.taken_id_' + deger + '&field_emp_name=add_inventory_zimmet.taken_name_' + deger,'list');
			}		
			function ac_tarih(deger)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_inventory_zimmet.tarih' + deger + '&field_name=add_inventory_zimmet.given_name_' + deger  , 'date');	
			}
		</cfif>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_inventory_zimmet';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_inventory_zimmet.cfm';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();	
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn; // Transaction icin yapildi.
			
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_INVENT_ZIMMET';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ZIMMET_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-employee_name','item-company_id']";
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_inventory_zimmet';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_inventory_zimmet.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_inventory_zimmet.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_inventory_zimmet&event=upd&zimmet_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_inventory_zimmet';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_inventory_zimmet';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_inventory_zimmet.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_inventory_zimmet.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_inventory_zimmet&event=upd&zimmet_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'zimmet_id=##attributes.zimmet_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_zimmet.employee_id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_zimmet';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'add_inventory_zimmet';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' or attributes.event is 'del' ))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_inventory_zimmet&event=del&zimmet_id=#attributes.zimmet_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_zimmet_rows.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_zimmet_rows.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_inventory_zimmet';
	}
	
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (isdefined("attributes.is_form_submitted"))
			url_str = '#url_str#&is_form_submitted=1';
		if (isdefined("attributes.keyword"))
			url_str = "#url_str#&keyword=#attributes.keyword#";
	}
</cfscript>