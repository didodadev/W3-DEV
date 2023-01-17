<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfif isdefined("attributes.form_submitted")>
		<cfquery name="get_accounts" datasource="#dsn#">
		    SELECT
		    	DEFINITION,
		    	PAYROLL_ID
		    FROM
		        SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF
			    <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			    	WHERE DEFINITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			   	</cfif>
		</cfquery>
	<cfelse>
		<cfset get_accounts.recordcount = 0>
	</cfif>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.totalrecords" default="#get_accounts.recordcount#">
	<cfscript>
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		url_str = '';
		if (isdefined("attributes.keyword") and len(attributes.keyword))
			url_str = '#url_str#&keyword=#attributes.keyword#';
		if (isdefined("attributes.form_submitted") and len(attributes.form_submitted))
			url_str = '#url_str#&form_submitted=#attributes.form_submitted#';
	</cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_xml_page_edit fuseact="ehesap.popup_form_upd_payroll_accounts">
	<cfif isdefined("attributes.payroll_id")>
		<cfquery name="get_definition" datasource="#dsn#">
			SELECT 
	    	    PAYROLL_ID, 
	            DEFINITION, 
	            RECORD_EMP, 
	            UPDATE_EMP, 
	            RECORD_IP, 
	            UPDATE_IP, 
	            RECORD_DATE, 
	            UPDATE_DATE 
	        FROM 
		        SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF 
	        WHERE 
	        	PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payroll_id#">
		</cfquery>
		<cfquery name="get_rows" datasource="#dsn#">
			SELECT 
	        	ADR.ROW_ID, 
	            ADR.PAYROLL_ID, 
	            ADR.PUANTAJ_ACCOUNT_COL, 
	            ADR.ACCOUNT_CODE, 
	            ADR.BUDGET_ITEM, 
	            ADR.PUANTAJ_BORC_ALACAK, 
	            ADR.RECORD_EMP, 
	            ADR.RECORD_IP, 
	            ADR.RECORD_DATE, 
	            ADR.PUANTAJ_ACCOUNT_DEFINITION, 
	            ADR.PUANTAJ_ACCOUNT, 
	            ADR.COMMENT_PAY_ID, 
	            ADR.IS_PROJECT, 
	            ADR.IS_NET,
	            ADR.IS_EXPENSE,
	            AP.ACCOUNT_NAME,
	            EI.ACCOUNT_CODE AS BUDGET_ACCOUNT_CODE,
	            EI.EXPENSE_ITEM_NAME
	        FROM 
	    	    SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS ADR
	    	    LEFT JOIN <cfif fusebox.use_period>#dsn2_alias#.</cfif>ACCOUNT_PLAN AP ON AP.ACCOUNT_CODE = ADR.ACCOUNT_CODE
	    	    LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = ADR.BUDGET_ITEM
	        WHERE 
		        ADR.PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payroll_id#"> 
	        ORDER BY 
	        	ADR.PUANTAJ_BORC_ALACAK
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		<cfif isdefined("get_rows") and get_rows.recordcount>
			row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
		<cfelse>
			row_count=0;
		</cfif>
		function get_puantaj_account(count)
		{	
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_puantaj_account_name&field_kesinti_id=accounts.comment_pay_id'+ count +'&field_net=accounts.is_net'+ count +'&field_detail=accounts.puantaj_account_definition'+ count +'&field_name=accounts.puantaj_account_name_list'+ count +'&field_id=accounts.puantaj_account'+count +'&field_expense=accounts.is_expense'+count +'&field_net_detail=accounts.is_net_detail'+count+'','list');
		}
		function get_account(count)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=accounts.account_name'+ count +'&field_id=accounts.account_code' + count ,'list');
		}
		function get_budget_item(count)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=accounts.budget_item' + count + '&field_acc_name=accounts.budget_name' + count,'list');
		}
		function sil(sy)
		{
			$('#row_kontrol_'+sy).val(0);
			$('#my_row_'+sy).css('display','none');
		}
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
			newRow.setAttribute("name","my_row_" + row_count);
			newRow.setAttribute("id","my_row_" + row_count);		
			newRow.setAttribute("NAME","my_row_" + row_count);
			newRow.setAttribute("ID","my_row_" + row_count);		
			document.accounts.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="icon-trash-o"></i></a>';	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.noWrap = true;
			newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" />';
			newCell.innerHTML += '<input type="hidden" name="puantaj_account'+ row_count +'" value="" /><input type="hidden" name="comment_pay_id'+ row_count +'" value="" /><input type="hidden" name="is_net'+ row_count +'" value="" /><input type="hidden" name="is_expense'+ row_count +'" value="" />';
			newCell.innerHTML += '<input type="text" readonly name="puantaj_account_name_list'+ row_count +'" value="" style="width:140px;" /> ';
			newCell.innerHTML+= '<a href="javascript://" onClick="get_puantaj_account('+ row_count +');"><i class="icon-ellipsis"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" class="boxtext" value="" name="is_net_detail'+ row_count +'" id="is_net_detail#currentrow#" readonly="readonly" style="width:40px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="borc_alacak'+ row_count +'" style="width:80px;"><option value="0"><cf_get_lang_main no='175.Borç'></option><option value="1"><cf_get_lang_main no='176.Alacak'></option></select>';
			newCell= newRow.insertCell(newRow.cells.length);
			newCell.noWrap = true;
			newCell.innerHTML = '<input type="hidden" name="account_code'+ row_count +'" value="">';
			newCell.innerHTML+= '<input type="text" name="account_name'+row_count+'" value="" style="width:140px;" readonly > ';
			newCell.innerHTML+= '<a href="javascript://" onClick="get_account(' + row_count + ');"><i class="icon-ellipsis"></i></a>';
			newCell= newRow.insertCell(newRow.cells.length);
			newCell.noWrap = true;
			newCell.innerHTML = '<input type="hidden" name="budget_item'+ row_count +'" value="">';
			newCell.innerHTML+= '<input type="text" name="budget_name' + row_count + '" value="" readonly style="width:140px;"> ';
			newCell.innerHTML+= '<a href="javascript://" onClick="get_budget_item(' + row_count +');"><i class="icon-ellipsis"></i></a>';
			newCell=newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="puantaj_account_definition' + row_count +'" value="" style="width:150px;" />';
			<cfif is_project_acc eq 1>
				newCell=newRow.insertCell(newRow.cells.length);
				newCell.style.textAlign = 'center';
				newCell.innerHTML = '<input type="checkbox" name="is_project' + row_count +'">';
			</cfif>
		}
		function kontrol()
		{
			$('#record_num').val(row_count);
			if(row_count == 0)
			{
				alert("<cf_get_lang dictionary_id='54622.Bir Kayıt Giriniz'>!");
				return false;
			}
			for(var j=1;j<=row_count;j++)
			{
				if($('#row_kontrol_'+j).val() == 1)
				{
					var liste = $('#puantaj_account_name_list'+j).val();
					if(liste == '')
					{
						alert("<cf_get_lang dictionary_id='54623.Lütfen Listeden Bir Veri Seçiniz'>");
						return false;
					}
					var borc_alacak = $('#borc_alacak'+j).val();
					if(borc_alacak == '')
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='455.Borç/alacak'>");
						return false;
					}
					var muhasebe_kodu = $('#account_code'+j).val();
					if(muhasebe_kodu == '')
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1399.Muhasebe Kodu'>");
						return false;
					}
					var definition = $('#puantaj_account_definition'+j).val();
					if(definition == '')
					{
						alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='217.açıklama'>");
						return false;
					}
				}
			}
			return true;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_payroll_accounts';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_payroll_accounts.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_payroll_accounts';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_payroll_accounts.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_payroll_accounts.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_payroll_accounts&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'payroll_id=##attributes.payroll_id##';
	if (isdefined("attributes.payroll_id") and not isdefined("attributes.is_copy"))
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_definition.definition##';
	else
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '';
	
	if(attributes.event is 'upd')
	{
		if (isdefined("attributes.payroll_id") and not isdefined("attributes.is_copy"))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=ehesap.list_payroll_accounts&event=upd&payroll_id=#attributes.payroll_id#&is_copy=1";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_payroll_accounts&event=upd";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>
