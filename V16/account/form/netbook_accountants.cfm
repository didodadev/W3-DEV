<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	getAccountants = netbook.getAccountants();
</cfscript>
<cf_box title="#getLang('account',308)#"> <!--- Muhasebeci Tanımları --->
    <cfform name="accountants" method="post" action="#request.self#?fuseaction=account.emptypopup_upd_accountants">
        <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#getAccountants.recordcount#</cfoutput>">
        <cf_grid_list class="basket_list">
            <thead>
                <tr>
                    <th width="30" class="text-center">	<a style="cursor:pointer" onClick="add_row();" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus"></i></a></th>
                    <th width="30" class="text-center"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                    <th><cf_get_lang dictionary_id='57578.Yetkili'></th>
                    <th><cfoutput>#getLang('contract',340)#</cfoutput></th>
                    <th><cf_get_lang dictionary_id='30044.Sözleşme No'></th>
					<th width="120"><cf_get_lang dictionary_id='57747.Sözleşme Tarihi'></th>
                </tr>
             </thead>
             <tbody id="table1">
                <cfoutput query="getAccountants">
                    <tr id="frm_row#currentrow#"  class="text-center">
                        <input type="hidden" id="acc_id#currentrow#" name="acc_id#currentrow#" value="#ACC_ID#">
                        <input type="hidden" id="row_kontrol#currentrow#" name="row_kontrol#currentrow#" value="1">
                        <td>
                            <a href="javascript://" onClick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                        </td>
                        <td>#currentrow#</td>
                        <td style="width:220px;">
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="#ACC_CONSUMER_ID#" class="boxtext">
									<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#ACC_COMPANY_ID#" class="boxtext">
									<input type="text" name="about_company#currentrow#" id="about_company#currentrow#" value="#FULLNAME#" class="boxtext" style="width:300px;" onfocus="auto_company('#currentrow#');">
									<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_company(#currentrow#)"></span>
								</div>
							</div>
							
						</td>
                        <td>
							<div class="form-group">
								<input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="#ACC_PARTNER_ID#">
								<input readonly type="text" name="about_partner#currentrow#" id="about_partner#currentrow#" style="width:150px;" class="boxtext" value="<cfif len(getAccountants.acc_company_id) and getAccountants.acc_company_id neq 0>#getAccountants.PARTNER_FULLNAME#<cfelseif len(getAccountants.acc_consumer_id) and getAccountants.acc_consumer_id neq 0>#getAccountants.CONSUMER_FULLNAME#</cfif>">
							</div>
                        </td>
                        <td>	
							<div class="form-group">
								<input type="text" class="boxtext" name="description#currentrow#" id="description#currentrow#" value="#description#" style="width:200px;" maxlength="250">
							</div>
						</td>
                        <td>
							<div class="form-group">
								<input type="text" class="boxtext" name="contract_no#currentrow#" id="contract_no#currentrow#" value="#contract_no#" style="width:100px;" maxlength="50">
							</div>
						</td>
                        <td id="contract_start#currentrow#_td">
							<div class="form-group">
								<div class="input-group">
									<input type="text" name="contract_start#currentrow#" id="contract_start#currentrow#" value="<cfif len(getAccountants.CONTRACT_DATE)>#DateFormat(date_add('h',session.ep.time_zone,getAccountants.CONTRACT_DATE),dateformat_style)#</cfif>" style="width:120px;" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="contract_start#currentrow#"></span>
								</div>
							</div>
                        </td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
        <cf_box_footer>
        	<cf_record_info query_name="getAccountants">
    		<cf_workcube_buttons is_upd='0' is_delete='0' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	row_count=<cfoutput>#getAccountants.recordcount#</cfoutput>;
	function sil(sy)
	{
		var my_element=document.getElementById('row_kontrol'+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		document.getElementById('record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="" id="acc_id' + row_count +'" name="acc_id' + row_count +'"><input type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';		


		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = row_count;

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="">';
		newCell.innerHTML += '<input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="">';
		newCell.innerHTML += '<div class="form-group"><div class="input-group"><input type="text" name="about_company' + row_count +'" id="about_company' + row_count +'" value="" style="width:150px;" onFocus="auto_company('+ row_count +');"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_company('+ row_count +');"></span></div></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="">';
		newCell.innerHTML += '<input type="text" name="about_partner' + row_count +'" id="about_partner' + row_count +'" value="" class="boxtext" readonly>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="description' + row_count +'" id="description' + row_count +'" style="width:200px;" maxlength="250" class="boxtext">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="contract_no' + row_count +'" id="contract_no' + row_count +'" style="width:100px;" class="boxtext">';

		newCell = newRow.insertCell(newRow.cells.length);
					
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="contract_start' + row_count +'" id="contract_start' + row_count +'" maxlength="10" class="text" style="width:75px;" validate="#validate_style#"  value="<cfoutput>#DateFormat(date_add('h',session.ep.time_zone,Now()),dateformat_style)#</cfoutput>"><span class="input-group-addon" id="contract_start'+ row_count +'_td"></span></div></div>';
		wrk_date_image('contract_start' + row_count);
	}
	function pencere_ac_company(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=accountants.company_id' + no +'&is_period_kontrol=1&field_comp_name=accountants.about_company' + no +'&field_partner=accountants.partner_id' + no +'&field_consumer=accountants.consumer_id' + no +'&field_name=accountants.about_partner' + no +'&par_con=1&select_list=2,3');
	}
	function auto_company(no)
	{
		AutoComplete_Create('about_company'+no,'MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','MEMBER_PARTNER_NAME2,CONSUMER_ID,PARTNER_ID,COMPANY_ID','about_partner'+ no +',consumer_id'+ no +',partner_id'+ no +',company_id'+ no +'','','3','200');
	}
   	function kontrol()
	{
		for (i=1; i<=row_count; i++)
		{
			if(document.getElementById("row_kontrol"+i).value == 1 && (document.getElementById("company_id"+i).value =='' && document.getElementById("consumer_id"+i).value ==''))
			{
				alert(i +". <cf_get_lang dictionary_id ='58508.Satır'>: <cf_get_lang dictionary_id='57785.Üye Seçmelisiniz'> !");
				return false;
			}
			if(document.getElementById("row_kontrol"+i).value == 1 && document.getElementById("description"+i).value =='')
			{
				alert(i +". <cf_get_lang dictionary_id ='58508.Satır'>: <cf_get_lang dictionary_id='47569.Lütfen Sözleşme Tipi Giriniz'> !");
				return false;
			}
			if(document.getElementById("row_kontrol"+i).value == 1 && document.getElementById("contract_no"+i).value =='')
			{
				alert(i +". <cf_get_lang dictionary_id ='58508.Satır'>:<cf_get_lang dictionary_id='47350.Lütfen Sözleşme No Giriniz'> !");
				return false;
			}
		}
	}
</script>