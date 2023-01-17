<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
</cfquery>
<cfquery name="GET_WORKGROUPS" datasource="#dsn#">
	SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_NAME
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID,REPLACE(REPLACE(EXPENSE_ITEM_NAME,'+',' '),'''',' ') EXPENSE_ITEM_NAME,IS_EXPENSE,INCOME_EXPENSE,IS_ACTIVE FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_ITEM_EXPENSE" dbtype="query">
	SELECT EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME FROM GET_EXPENSE_ITEM WHERE IS_EXPENSE = 1 AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_ITEM_INCOME" dbtype="query">
	SELECT EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME FROM GET_EXPENSE_ITEM WHERE INCOME_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,REPLACE(REPLACE(EXPENSE,'+',' '),'''',' ') EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cf_catalystHeader>
	<cf_box>
<cfform name="add_costplan" id="add_costplan" method="post" action="#request.self#?fuseaction=budget.emptypopup_add_cost_bill_template">
	<cf_box_elements>
            	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                	<div class="form-group" id="item-template_name">
                    	<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1097)#</cfoutput> *</label>
                        <div class="col col-8 col-xs-12">
                        	<input type="text" name="template_name" id="template_name" value="" maxlength="150">
                        </div>
                    </div>
                    <div class="form-group" id="item-template_type">
                    	<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',52)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                        	<label><cfoutput>#getLang('main',1266)#</cfoutput><input type="radio" name="template_type" id="template_type" value="0" checked onClick="masraf_gelir();"></label>
                        	<label><cfoutput>#getLang('main',1265)#</cfoutput><input type="radio" name="template_type" id="template_type" value="1" onClick="masraf_gelir();"></label>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                	<div class="form-group" id="item-is_department">
                    	<label><cf_get_lang dictionary_id="33965.Departmanı Depo Bazında Dağıt"><input type="checkbox" name="is_department" id="is_department" value="1"></label>
                    </div>
                </div>
			</cf_box_elements>
<cf_basket id="cost_bill_template_bask">
<input name="record_num" id="record_num" type="hidden" value="0">
<cf_grid_list id="detail_basket_list_expense" class="detail_basket_list">
    <thead>
        <tr>
            <th width="5"><a onClick="add_row();"><i class="fa fa-plus"></i></a></th>
            <th width="40" nowrap="nowrap">% *</th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='58460.Masraf Merkezi'> *</th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='58551.Gider Kalemi'> *</th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='57572.Departman'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='51319.Aktivite Tipi'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='58140.İş Grubu'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='51309.Harcama Yapan'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='29502.Abone No'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='57416.Proje'></th>
        </tr>
    </thead>
    <tbody name="table1" id="table1">
    </tbody>
</cf_grid_list>
<cf_grid_list id="detail_basket_list_income" class="detail_basket_list" style="display:none;">
    <thead>
        <tr>
            <th width="5"><a onClick="add_row();"><i class="fa fa-plus"></i></a></th>
            <th width="40" nowrap="nowrap">% *</th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='58172.Gelir Merkezi'> *</th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='58173.Gelir Kalemi'> *</th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='57572.Departman'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='51319.Aktivite Tipi'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='58140.İş Grubu'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='56987.Satış Yapan'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='29502.Abone No'></th>
            <th style="width:100px;" nowrap="nowrap"><cf_get_lang dictionary_id='57416.Proje'></th>
        </tr>
    </thead>
    <tbody name="table2" id="table2">
    </tbody>
</cf_grid_list>
</cf_basket>
<cf_box_footer>
	<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
	</cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
$(".ui-scroll:eq(1)").css("display", "none");
	row_count=0;
	function sil(sy)
	{
		var my_element = document.getElementById("row_kontrol"+sy);
		my_element.value = 0;
		var my_element = document.getElementById("frm_row"+sy);
		my_element.style.display = "none";
	}
	function kontrol_et()
	{
		if(row_count ==0) return false;
		else return true;
	}
	function masraf_gelir()
	{
		satir_var = 0;
		for(var rw=1;rw<=row_count;rw++)
		{
			if(document.getElementById("frm_row"+rw).style.display != 'none')
				satir_var = 1;
		}
		if(satir_var == 1)
		{
			if(confirm("<cf_get_lang no='16.Satırları Silmek İstediğinizden Eminmisiniz'>?"))	
			{
				if(document.add_costplan.template_type[0].checked)
				{
					table2.style.display='none';
					$(".ui-scroll:eq(1)").css("display", "none");
					table1.style.display='';
					$(".ui-scroll:eq(0)").css("display", "");
				}
				else
				{
					table1.style.display='none';
					$(".ui-scroll:eq(0)").css("display", "none");
					table2.style.display='';
					$(".ui-scroll:eq(1)").css("display", "");
				}
			}
			else return false;
		}
		else
		{
			if(document.add_costplan.template_type[0].checked)
			{
				table2.style.display='none';
				$(".ui-scroll:eq(1)").css("display", "none");
				table1.style.display='';
				$(".ui-scroll:eq(0)").css("display", "");
			}
			else
			{
				table1.style.display='none';
				$(".ui-scroll:eq(0)").css("display", "none");
				table2.style.display='';
				$(".ui-scroll:eq(1)").css("display", "");
			}	
		}
		for(var rw=1;rw<=row_count;rw++)
		{
			var my_element = document.getElementById("row_kontrol"+rw);
			my_element.value = 0;
			var my_element = document.getElementById("frm_row"+rw);
			my_element.style.display = "none";
		}
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		if(document.add_costplan.template_type[0].checked)
		{
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.add_costplan.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="rate' + row_count +'" id="rate' + row_count +'" value="0" style="width:40px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:200px;" class="text"><option value=""><cf_get_lang_main no="1048.Masraf Merkezi"></option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:200px;" class="text"><option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option><cfoutput query="GET_EXPENSE_ITEM_EXPENSE"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="department_id'+ row_count +'" id="department_id'+ row_count +'" value=""><input type="text" name="department'+ row_count +'" id="department'+ row_count +'" value="" style="width:200px;"><a href="javascript://" style="margin-left: 5px;" onClick="pencere_ac_department('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang no="90.Aktivite Tipi"></option><cfoutput query="get_activity_types"><option value="#activity_id#">#activity_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no='728.İş Grubu'></option><cfoutput query="GET_WORKGROUPS"><option value="#workgroup_id#">#workgroup_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value=""><input type="hidden" name="member_code'+ row_count +'" id="member_code'+ row_count +'"  value=""><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'"  value=""><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value=""><input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="" style="width:90px;" class="txt">&nbsp;<input type="text" style="width:90px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="" class="txt"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');" style="margin-left: 5px;"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value=""><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_asset('+ row_count +');" style="margin-left: 5px;"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value=""><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="" style="width:100px;" onFocus="auto_subscription('+ row_count +');"> <a href="javascript://" onClick="pencere_ac_subs('+ row_count +');" style="margin-left: 5px;" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');" style="margin-left: 5px;"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		}
		else
		{
			newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			document.add_costplan.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="rate' + row_count +'" id="rate' + row_count +'" value="0" style="width:40px;" class="txt" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="760.Gelir Merkezi"></option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="761.Gelir Kalemi"></option><cfoutput query="GET_EXPENSE_ITEM_INCOME"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="department_id'+ row_count +'" id="department_id'+ row_count +'" value=""><input type="text" name="department'+ row_count +'" id="department'+ row_count +'" value="" style="width:200px;"><a href="javascript://" onClick="pencere_ac_department('+ row_count +');" style="margin-left: 5px;"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang no="90.Aktivite Tipi"></option><cfoutput query="get_activity_types"><option value="#activity_id#">#activity_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no='728.İş Grubu'></option><cfoutput query="GET_WORKGROUPS"><option value="#workgroup_id#">#workgroup_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value=""><input type="hidden" name="member_code'+ row_count +'" id="member_code'+ row_count +'" value=""><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'"  value=""><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value=""><input type="text" name="company'+ row_count +'" id="company'+ row_count +'"  value="" style="width:90px;" class="txt">&nbsp;<input type="text" style="width:90px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'"  value="" class="txt"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');" style="margin-left: 5px;"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value=""><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_asset('+ row_count +');" style="margin-left: 5px;"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value=""><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="" style="width:100px;" onFocus="auto_subscription('+ row_count +');"> <a href="javascript://" onClick="pencere_ac_subs('+ row_count +');" style="margin-left: 5px;" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');" style="margin-left: 5px;"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		}
	}
	function pencere_ac_asset(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_costplan.asset_id' + no +'&field_name=add_costplan.asset' + no +'&event_id=0&motorized_vehicle=0','list');
	}
	function pencere_ac_department(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_costplan.department_id' + no +'&field_name=add_costplan.department' + no,'list');
	}
	function pencere_ac_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_costplan.project_id' + no +'&project_head=add_costplan.project' + no);
	}
	function pencere_ac_subs(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_costplan.subscription_id' + no +'&field_no=add_costplan.subscription_name' + no,'list');
	}
	function auto_subscription(no)
	{
		AutoComplete_Create('subscription_name'+no,'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id'+no,'','3','150');
	}
	function pencere_ac_company(no)
	{
		document.getElementById("member_type"+no).value = '';
		document.getElementById("member_id"+no).value = '';
		document.getElementById("member_code"+no).value = '';
		document.getElementById("company_id"+no).value = '';
		document.getElementById("company"+no).value = '';
		document.getElementById("authorized"+no).value = '';
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_costplan.member_code' + no +'&field_id=add_costplan.member_id' + no +'&field_comp_name=add_costplan.company' + no +'&field_name=add_costplan.authorized' + no +'&field_comp_id=add_costplan.company_id' + no + '&field_type=add_costplan.member_type' + no + '&select_list=1,2,3','list');
	}
	function kontrol()
	{
		if(document.getElementById("template_name").value == "")
		{
			alert("<cf_get_lang no='77.Lütfen Şablon Adı Giriniz'>!");
		}
		var toplam_satir = 0;	
		var sira_deger = 0;
		var rate_total = 0;
		for (var r=1;r<=row_count;r++)
		{
			if(document.getElementById("row_kontrol"+r).value == 1)
			{
				toplam_satir = toplam_satir + 1;
				rate_value = parseFloat(filterNum(document.getElementById("rate"+r).value));
				rate_total += rate_value;
				
				form_expense_center_id = document.getElementById("expense_center_id"+r);
				form_expense_item_id = document.getElementById("expense_item_id"+r);
				
				sira_deger = sira_deger + 1;
				if(rate_value =="")
				{
					alert("" + sira_deger + ".<cf_get_lang no='73. Satırdaki Oranı Giriniz'>!");
					return false;
				}
				if(rate_value < 0)
				{
					alert("" + sira_deger + ".Satırdaki Oran Negatif Olamaz");
					return false;
				}
				if(form_expense_center_id.value =="")
				{
					alert("" + sira_deger + ". <cf_get_lang no='72. Satırdaki Masraf Merkezini Seçiniz'>!");
					return false;
				}
				if(form_expense_item_id.value =="")
				{
					alert("" + sira_deger + ". <cf_get_lang no='71. Satırdaki Gider Kalemini Seçiniz'>!");
					return false;
				}
			}
		}
		if(toplam_satir== 0)
		{
			alert("<cf_get_lang no='76.Lütfen Masraf Şablonuna Satır Ekleyiniz'>!");
			return false;
		}
		if(wrk_round(rate_total) != 100)
		{
			alert("<cf_get_lang dictionary_id='59039.Satır Oranlarının Toplamı %100 Olmalıdır.Lütfen Kontrol Ediniz.'>");
			return false;
		}
		for (var rc=1;rc<=row_count;rc++)
		{
			if(document.getElementById("row_kontrol"+rc).value == 1)
				document.getElementById("rate"+rc).value = filterNum(document.getElementById("rate"+rc).value);
		}
		return true;
	}
</script>
