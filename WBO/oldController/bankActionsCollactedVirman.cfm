<cf_get_lang_set module_name="bank">
<cf_papers paper_type="virman">
<cfparam name="attributes.money_type_control" default="">
<cfparam name="attributes.currency_id_info" default="">
<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
    <cfset branch_id = ''>
	<cfinclude template="../cash/query/get_money.cfm">
    <cfset date_info = now()>
    <cfset process_cat = ''>
    <cfset is_default = 1>
<cfelse>
    <cfquery name="get_action_detail" datasource="#dsn2#">
        SELECT
            BAM.PROCESS_CAT,
            BAM.ACTION_TYPE_ID,
            BAM.ACTION_DATE,
            BAM.MULTI_ACTION_ID,
            BAM.UPD_STATUS,
            BAM.RECORD_EMP,
            BAM.RECORD_IP,
            BAM.RECORD_DATE,
            BAM.UPDATE_EMP,
            BAM.UPDATE_IP,
            BAM.UPDATE_DATE,
            BA.ACTION_ID,
            (BA.ACTION_ID+1) ACTION_ID_,
            BA.ACTION_TYPE,
            BA.PROCESS_CAT,
            BA.ACTION_FROM_ACCOUNT_ID,
            BA.ACTION_VALUE,
            BA.ACTION_DATE,
            BA.ACTION_CURRENCY_ID,
            BA.ACTION_DETAIL,
            BA.OTHER_CASH_ACT_VALUE,
            BA.OTHER_MONEY,
            BA.PAPER_NO,
            BA.MASRAF,
            EC.EXPENSE,
            BA.EXPENSE_CENTER_ID,
            EI.EXPENSE_ITEM_NAME,
            BA.EXPENSE_ITEM_ID,
            BA.FROM_BRANCH_ID,
            LBA.ACTION_TO_ACCOUNT_ID,
            PP.PROJECT_HEAD,
            BA.PROJECT_ID
        FROM
            BANK_ACTIONS_MULTI BAM
            LEFT JOIN BANK_ACTIONS BA ON BAM.MULTI_ACTION_ID = BA.MULTI_ACTION_ID
            LEFT JOIN BANK_ACTIONS LBA ON (BA.ACTION_ID)+1 = LBA.ACTION_ID
            LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = BA.PROJECT_ID
            LEFT JOIN EXPENSE_CENTER EC ON BA.EXPENSE_CENTER_ID = EC.EXPENSE_ID
            LEFT JOIN EXPENSE_ITEMS EI ON BA.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID
        WHERE
            BA.WITH_NEXT_ROW = 1
            AND BAM.MULTI_ACTION_ID = #attributes.multi_id#
    </cfquery>
    <cfdump var="#get_action_detail#"><cfabort>
    <cfif not get_action_detail.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    <cfelse>
    	<cfset date_info = get_action_detail.action_date>
        <cfset process_cat = get_action_detail.process_cat>
        <cfset is_default = 0>
        <cfset branch_id = get_action_detail.from_branch_id>
    </cfif>
    <cfquery name="get_money" datasource="#dsn2#">
        SELECT 
            MONEY_TYPE AS MONEY,
            RATE2,
            RATE1,
            IS_SELECTED
        FROM 
            BANK_ACTION_MULTI_MONEY 
        WHERE 
            ACTION_ID = #attributes.multi_id# 
        ORDER BY 
            ACTION_MONEY_ID
    </cfquery>
    <cfif not GET_MONEY.recordcount>
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT 
                MONEY,
                0 AS IS_SELECTED,
                RATE2,
                RATE1
            FROM 
                SETUP_MONEY 
            WHERE 	
                MONEY_STATUS=1 
            ORDER BY 	
                MONEY_ID
        </cfquery>
    </cfif>
</cfif>
<cfscript>
	CreateComponent = CreateObject("component","/../workdata/getAccounts");
	queryResult = CreateComponent.getCompenentFunction(is_system_money:0,money_type_control:attributes.money_type_control,is_branch_control:0,control_status:1,is_open_accounts:0,currency_id_info:attributes.currency_id_info);	
</cfscript>
<script type="text/javascript">
	<cfoutput>
		<cfif not (len(paper_code) and len(paper_number))>
			var auto_paper_code = "";
			var auto_paper_number = "";
		<cfelse>
			var auto_paper_code = "#paper_code#-";
			var auto_paper_number = "#paper_number#";
		</cfif>
		<cfif (isdefined("attributes.event") and attributes.event is 'upd')>
			var all_action_list = "#ListDeleteDuplicates(ValueList(get_action_detail.action_id,','))#";
			var all_action_list_ = "#ListDeleteDuplicates(ValueList(get_action_detail.action_id_,','))#";
			all_action_list += ","+all_action_list_;
			row_count=#get_action_detail.recordcount#;
		<cfelseif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
			row_count=0;
		</cfif>
	</cfoutput>
	function sil(sy)
	{
		var my_element=document.getElementById('row_kontrol'+sy);	
		my_element.value=0;		
		var my_element=eval("frm_row"+sy);	
		my_element.style.display="none";
		toplam_hesapla();		
	}
   function add_row(amount,paper_no,exp_center_id,exp_item_id,exp_center_name,exp_item_name,expense_amount,action_detail,from_account_id,to_account_id,project_id,project_head)
	{
		if(amount == undefined) amount = 0;
		if(expense_amount == undefined) expense_amount = 0;	
		if(paper_no == undefined) paper_no = '';
		if(action_detail == undefined) action_detail = '';
        if(project_id == undefined) project_id = '';
        if(project_head == undefined) project_head = '';
		if(exp_center_id == undefined) exp_center_id = '';
		if(exp_item_id == undefined) exp_item_id = '';
		if(exp_center_name == undefined) exp_center_name = '';
		if(exp_item_name == undefined) exp_item_name = '';
		if(from_account_id == undefined) from_account_id = '';
		if(to_account_id == undefined) to_account_id = '';
		
		row_count++;
		var newRow;
		var newCell;	
		document.getElementById('record_num').value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.className = 'color-row';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0" align="absmiddle"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="paper_number' + row_count +'" id="paper_number' + row_count +'" value="'+auto_paper_code + auto_paper_number+'" class="boxtext">';
		if(auto_paper_number != '')
			auto_paper_number++;
		// hangi hesaptan	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select name="from_account_id' + row_count +'" id="from_account_id' + row_count +'" style="width:200px;"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
		<cfoutput query="queryResult">
			if ('#account_id#;#account_currency_id#' == from_account_id)
				a += '<option value="#account_id#;#account_currency_id#" selected>#account_name# #account_currency_id#</option>';
			else
				a += '<option value="#account_id#;#account_currency_id#">#account_name# #account_currency_id#</option>';
		</cfoutput>
		newCell.innerHTML = a+ '</select>';
		// hangi hesaba
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select name="to_account_id' + row_count +'" id="to_account_id' + row_count +'" style="width:200px;"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
		<cfoutput query="queryResult">
			if ('#account_id#;#account_currency_id#' == to_account_id)
				b += '<option value="#account_id#;#account_currency_id#" selected>#account_name# #account_currency_id#</option>';
			else
				b += '<option value="#account_id#;#account_currency_id#">#account_name# #account_currency_id#</option>';
		</cfoutput>
		newCell.innerHTML = b + '</select>';
		//tutar
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="action_value' + row_count +'" id="action_value' + row_count + '" value="'+commaSplit(amount)+'" onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_hesapla();" style="width:100%;" class="box">';
		//aciklama
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="action_detail' + row_count +'" id="action_detail' + row_count + '" value="'+action_detail+'" style="width:100%;" class="boxtext">';
        // proje
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.setAttribute("nowrap","nowrap");
        newCell.innerHTML ='<input type="hidden" name="project_id' + row_count +'" value="'+project_id+'" id="project_id' + row_count +'"><input type="text" id="project_head' + row_count +'" name="project_head' + row_count +'"  onFocus="autocomp_project('+row_count+');" value="'+project_head+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		// masraf tutari
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="expense_amount' + row_count +'" id="expense_amount' + row_count +'" value="'+commaSplit(expense_amount)+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box">';
		// masraf merkezi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+exp_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'"  onFocus="exp_center('+row_count+');" value="'+exp_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		//gider kalemi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_item_id' + row_count +'" value="'+exp_item_id+'" id="expense_item_id' + row_count +'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item_name+'" style="width:150px;" onFocus="exp_item('+row_count+');" class="boxtext"><a href="javascript://" onClick="pencere_ac_item('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		toplam_hesapla();
	}
	function copy_row(no_info)
	{
		paper_number = document.getElementById('paper_number' + no_info).value;
		if(filterNum(document.getElementById('action_value' + no_info).value) > 0 )
			action_value = filterNum(document.getElementById('action_value' + no_info).value,'<cfoutput>#rate_round_num_info#</cfoutput>');else action_value = 0;
		action_detail = document.getElementById('action_detail' + no_info).value;
        project_id = document.getElementById('project_id' + no_info).value;
        project_head = document.getElementById('project_head' + no_info).value;
		expense_amount = document.getElementById('expense_amount' + no_info).value;
		expense_center_id = document.getElementById('expense_center_id' + no_info).value;
		expense_center_name = document.getElementById('expense_center_name' + no_info).value;
		expense_item_id = document.getElementById('expense_item_id' + no_info).value;
		expense_item_name = document.getElementById('expense_item_name' + no_info).value;
		from_account_id = document.getElementById('from_account_id' + no_info).value;
		to_account_id = document.getElementById('to_account_id' + no_info).value;

        add_row(action_value,paper_number,expense_center_id,expense_item_id,expense_center_name,expense_item_name,expense_amount,action_detail,from_account_id,to_account_id,project_id,project_head);    
	}
    function autocomp_project(no)
    {
        AutoComplete_Create("project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","project_id"+no,"",3,200);
    }
    function pencere_ac_project(no)
    {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_process.project_id' + no +'&project_head=add_process.project_head' + no +'','list');
    }
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_process.expense_center_id' + no +'&field_name=add_process.expense_center_name' + no,'list');
	}
	function pencere_ac_item(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_process.expense_item_id' + no +'&field_name=add_process.expense_item_name' + no,'list');
	}
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	function exp_item(no)
	{
		AutoComplete_Create("expense_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID","expense_item_id"+no,"",3);
	}
	function toplam_hesapla()
	{
		rate2_value = 0;
		deger_diger_para = '<cfoutput>#session.ep.money#</cfoutput>';
		for (var t=1; t<=document.getElementById('kur_say').value; t++)
		{
			if(document.add_process.rd_money[t-1].checked == true)
			{
				for(k=1; k<=document.getElementById('record_num').value; k++)
				{
					rate2_value = filterNum(document.getElementById('txt_rate2_'+t).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					deger_diger_para = list_getat(document.add_process.rd_money[t-1].value,1,',');
				}
			}
		}
		var total_amount = 0;
		var rate_ = 1;
		for(j=1; j<=document.getElementById('record_num').value; j++)
		{
			if(document.getElementById('row_kontrol'+j).value==1)
			{
				url_= '/V16/bank/cfc/bankInfo.cfc?method=getCurrencyInfo';
				
				$.ajax({
					type: "get",
					url: url_,
					data: {money: list_getat(document.getElementById('from_account_id'+j).value,2,';'),period: document.getElementById('active_period').value,company: document.getElementById('active_company').value},
					cache: false,
					async: false,
					success: function(read_data){
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
							$.each(data_.DATA,function(i){
								rate_ = data_.DATA[i][0];
								});
						}
					}
				});
				total_amount += parseFloat(filterNum(document.getElementById('action_value'+j).value)*rate_);
				var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
				if (selected_ptype != '')
					eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
				else
					var proc_control = '';
			}
		}
		document.getElementById('total_amount').value = commaSplit(total_amount);
	}
	function kontrol()
	{
		if(!chk_process_cat('add_process')) return false;
		if(!check_display_files('add_process')) return false;
		if(!chk_period(add_process.action_date,'İşlem')) return false;
		<cfsavecontent variable="messages">
			<cf_get_lang dictionary_id='52371.Aynı Belge No İle Kayıtlı Virman İşlemi Var'>
		</cfsavecontent>
		var p_type_ = "VIRMAN";
		var table_name_ = "BANK_ACTIONS";
		var alert_name_ = messages;
		paper_num_list = '';
		for(j=1; j<=document.getElementById('record_num').value; j++)
		{
			if(document.getElementById('row_kontrol'+j).value==1)
			{
				record_exist=1;
				<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
					if(document.getElementById('paper_number'+j).value != "")
					{
						paper_control(document.getElementById('paper_number'+j),p_type_);
						kontrol_no = list_getat(document.getElementById('paper_number'+j).value,1,'-');
						kontrol_number = list_getat(document.getElementById('paper_number'+j).value,2,'-');
					}
					else
					{
						if(kontrol_number != undefined && kontrol_number != '')
						{
							if(document.getElementById('paper_number'+j).value == "")
							{
								kontrol_number++;
								document.getElementById('paper_number'+j).value = kontrol_no+'-'+kontrol_number;
							}
						}
					}
				</cfif>
				//satirda hesaplarin kontrolu 
				if (list_getat(document.getElementById('from_account_id'+j).value,1,';') == "" || list_getat(document.getElementById('to_account_id'+j).value,1,';') == "")
				{ 
					alert (document.getElementById('paper_number'+j).value+":<cf_get_lang_main no='793.Lutfen Banka Hesabi Seciniz'>!");
					return false;
				}
				//satirda bankalarin farkliligi kontrolu
				if(list_getat(document.getElementById('from_account_id'+j).value,1,';') == list_getat(document.getElementById('to_account_id'+j).value,1,';'))				
				{
					alert(document.getElementById('paper_number'+j).value+":<cf_get_lang no='94.Seçtiğiniz Banka Hesapları Aynı'>");		
					return false; 
				}
				//satirda bankalara ait para birimi kontrolu
				if (list_getat(document.getElementById('from_account_id'+j).value,2,';') != list_getat(document.getElementById('to_account_id'+j).value,2,';'))
				{ 
					alert (document.getElementById('paper_number'+j).value+":<cf_get_lang dictionary_id='52402.Seçilen Bankalara Ait Para birimleri Aynı Olmalıdır'>!");
					return false;
				}
				//masraf girilmisse buna bagli masraf merkezi ve gider kalemi kontrolu
				if(document.getElementById('expense_amount'+j).value != "" && parseFloat(filterNum(document.getElementById('expense_amount'+j).value)) > 0)
				{
					if(document.getElementById('expense_center_id'+j).value == "" || document.getElementById('expense_center_name'+j).value == "")
					{
						alert (document.getElementById('paper_number'+j).value+": <cf_get_lang dictionary_id='48881.Masraf Merkezi Seçiniz'>!");
						return false;
					}
					if(document.getElementById('expense_item_id'+j).value == "" || document.getElementById('expense_item_name'+j).value == "")
					{
						alert (document.getElementById('paper_number'+j).value+": <cf_get_lang dictionary_id='50018.Gider Kalemi Seçiniz'>!");
						return false;
					}
				}
				if(document.getElementById('paper_number'+j).value != "" )
				{
					paper = document.getElementById('paper_number'+j).value;
					paper = "'"+paper+"'";
					if(list_find(paper_num_list,paper,','))
					{
						alert('<cf_get_lang dictionary_id="33815.Aynı Belge Numarası İle Eklenen İki Farklı Satır Var:">'+ paper);
						return false;
					}
					else
					{
						if(list_len(paper_num_list,',') == 0)
							paper_num_list+=paper;
						else
							paper_num_list+=","+paper;
					}
				}
			}
		}
		<cfif (isdefined("attributes.event") and attributes.event is 'upd')>
			if (list_len(paper_num_list))
			{
				//kontroller yeniden duzenlendi. Belge numaralarinin kullanimi ile ilgili uyarilarin kosullari hatali calisiyordu. 20130207
				var listParam = table_name_ + "*" + paper_num_list + "*" + all_action_list;
				var get_paper_no = wrk_safe_query('obj_get_paper_no','dsn2',0,listParam);
				if(get_paper_no != undefined)
				{
					if(get_paper_no.recordcount != 0)
					{
						alert(alert_name_+ ' : ' + get_paper_no.PAPER_NO);
						return false;
					}
				}
			}
		</cfif>
		if (record_exist == 0) 
		{
			alert("<cf_get_lang no ='3.Lütfen Satır Ekleyiniz'>!");
			return false;
		}
		return true;
	}
	<cfif (isdefined("attributes.event") and attributes.event is 'upd')>
		function control_del_form()
		{
			return control_account_process(<cfoutput>'#get_action_detail.multi_action_id#','#get_action_detail.action_type_id#'</cfoutput>);
		}
		$( document ).ready(function() {
			toplam_hesapla();
		});
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.add_collacted_virman';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/form_collacted_virman.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/add_collacted_virman.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.add_collacted_virman&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('collacted_virman','collacted_virman_sepet')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.add_collacted_virman';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/form_collacted_virman.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'bank/query/upd_collacted_virman.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.add_collacted_virman&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'multi_id=##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('collacted_virman','collacted_virman_sepet')";
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.del_collacted_action&multi_id=#attributes.multi_id#&old_process_type=#get_action_detail.action_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_collacted_action.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_collacted_action.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';
	}
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="BANK_MULTI_ACTION_ID" action_id="#attributes.multi_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=#get_action_detail.action_type_id#','page','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.add_collacted_virman";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'bankActionsCollactedVirman';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'BANK_ACTIONS_MULTI';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-action_date','item-processCat']";
</cfscript>
