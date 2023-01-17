<cf_papers paper_type="virman">
<cfparam name="attributes.money_type_control" default="">
<cfparam name="attributes.currency_id_info" default="">
<cfset to_branch_id = ''>
<cfinclude template="../../cash/query/get_money.cfm">
<cfset pageHead = getLang('','','29882')><!--- Toplu Virman --->
<cf_catalystHeader>
<cf_box>
	<cfform name="add_process">
		<cf_basket_form id="collacted_virman">
			<cf_box_elements>
				<input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="<cfoutput>#UCase(getLang('main',2085))#</cfoutput>">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>">
			
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-action_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfsavecontent>
							<div class="input-group">
								<cfinput type="text" name="action_date" value="#dateformat(now(),dateformat_style)#" maxlength="10" validate="#validate_style#" required="Yes" message="#message#" onBlur="change_money_info('add_process','action_date');">
								<span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'>*</label>
						<div class="col col-8 col-xs-12">
							<cfif isdefined('get_action_detail') and get_action_detail.recordcount neq 0 >
								<cf_workcube_process_cat process_cat="#get_action_detail.process_cat#">
							<cfelse>
								<cf_workcube_process_cat>
							</cfif>                                	
						</div>
					</div>
					<div class="form-group" id="item-to_branch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-8 col-xs-12">
							<cf_wrkDepartmentBranch selected_value='#to_branch_id#' fieldId='branch_id' is_branch='1' is_default='1' is_deny_control='1'>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12 text-right"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></div>
			</cf_box_footer>
					
		</cf_basket_form>
		<cf_basket id="collacted_virman_sepet">
			<cf_grid_list class="detail_basket_list">
				<thead>
					<tr>
						<th align="center" style="width:35px;"><a href="javascript://" onClick="add_row();" ><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0"></i></a></th>
						<th style="width:70px;"><cf_get_lang dictionary_id='57880.Belge No'></th>
						<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='48723.Hangi Hesaptan'>*</th>
						<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='48726.Hangi Hesaba'>*</th>
						<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'>*</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='57416.Proje'></th>
						<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='58930.Masraf'></th>
						<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
						<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
					</tr>
				</thead>
				<tbody id="table1" name="table1">
				</tbody>
			</cf_grid_list>
			<cf_basket_footer height="95">
				<input name="record_num" id="record_num" type="hidden" value="0">
				<div class="ui-row">
					<div id="sepetim_total" class="padding-0">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='50370.Dövizler'> </span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
								<div class="row">
									<div class="col col-12" class="totalBoxBody">
										<table>
											<cfoutput>
												<input id="kur_say" type="hidden" name="kur_say" value="#get_money.recordcount#">
												<cfloop query="get_money">
													<cfif is_selected eq 1><cfset str_money_bskt_main = money></cfif>
														<tr>
														<td>
															<cfif session.ep.rate_valid eq 1>
																<cfset readonly_info = "yes">
															<cfelse>
																<cfset readonly_info = "no">
															</cfif>
															<input type="hidden" name="hidden_rd_money_#currentrow#" value="#money#" id="hidden_rd_money_#currentrow#">
															<input type="hidden" name="txt_rate1_#currentrow#" value="#rate1#" id="txt_rate1_#currentrow#">
															<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla();" <cfif str_money_bskt_main eq money>checked</cfif>>#money#
														</td>
														<td valign="bottom">#TLFormat(rate1,0)#/<input type="text" class="box" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,rate_round_num_info)#"  onKeyUp="return(FormatCurrency(this,event,'#rate_round_num_info#'));" onBlur="if(filterNum(this.value,'#rate_round_num_info#') <=0) this.value=commaSplit(1);"></td>
														</tr>
												</cfloop>
											</cfoutput>                   	
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
							
								<div class="col col-12">
									<table>
										<tr>
											<td style="text-align:right;">
												<input type="text" name="total_amount" id="total_amount" class="box" value="0" readonly>&nbsp;
												<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="readonly" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:40px;">
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cf_basket_footer>
		</cf_basket>
	</cfform>
</cf_box>
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
	</cfoutput>
	row_count=0;
	record_exist=0;
	
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
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="icon-copy"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="paper_number' + row_count +'" id="paper_number' + row_count +'" value="'+auto_paper_code + auto_paper_number+'" style="width:60px;">';
		if(auto_paper_number != '')
			auto_paper_number++;
		// hangi hesaptan	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select name="from_account_id' + row_count +'" id="from_account_id' + row_count +'" style="width:150px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
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
		b = '<select name="to_account_id' + row_count +'" id="to_account_id' + row_count +'" style="width:150px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
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
		newCell.innerHTML = '<input type="text" name="action_value' + row_count +'" id="action_value' + row_count + '" value="'+commaSplit(amount)+'" onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_hesapla();" style="width:100%;float:right;" class="box">';
		//aciklama
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="action_detail' + row_count +'" id="action_detail' + row_count + '" value="'+action_detail+'" style="width:100%;" class="boxtext">';
		// proje
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="project_id' + row_count +'" value="'+project_id+'" id="project_id' + row_count +'"><input type="text" id="project_head' + row_count +'" name="project_head' + row_count +'" onFocus="autocomp_project('+row_count+');" value="'+project_head+'" style="width:150px;" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_project('+ row_count +');"></span></div></div>';
		// masraf tutari
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="expense_amount' + row_count +'" id="expense_amount' + row_count +'" value="'+commaSplit(expense_amount)+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;float:right;" class="box">';
		// masraf merkezi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" value="'+exp_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'"  onFocus="exp_center('+row_count+');" value="'+exp_center_name+'" style="width:200px;" class="boxtext"><span class="input-group-addon icon-ellipsis"  onClick="pencere_ac_exp('+ row_count +');"></span></div></div>';
		//gider kalemi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_item_id' + row_count +'" value="'+exp_item_id+'" id="expense_item_id' + row_count +'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item_name+'" style="width:200px;" onFocus="exp_item('+row_count+');" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_item('+ row_count +');"></span></div></div>';
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
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_process.project_id' + no +'&project_head=add_process.project_head' + no +'');
	}
	function pencere_ac_exp(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_process.expense_center_id' + no +'&field_name=add_process.expense_center_name' + no);
	}
	function pencere_ac_item(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_process.expense_item_id' + no +'&field_name=add_process.expense_item_name' + no);
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
		var total_amount = 0;
		var rate_ = 1;
		for(j=1; j<=document.getElementById('record_num').value; j++)
		{
			if(document.getElementById('row_kontrol'+j).value==1)
			{
				get_rate_ = wrk_query("SELECT RATE2 FROM SETUP_MONEY WHERE MONEY ='" +list_getat(document.getElementById('from_account_id'+j).value,2,';')+ "' AND PERIOD_ID=" + document.getElementById('active_period').value + " AND COMPANY_ID="+ document.getElementById('active_company').value,"dsn");
				if(get_rate_.recordcount)
					var rate_ = get_rate_.RATE2;
				total_amount += parseFloat(filterNum(document.getElementById('action_value'+j).value)*rate_);
				var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
				if (selected_ptype != '')
					eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
				else
					var proc_control = '';
			}
		}
		/* alert($('input[name=rd_money]:checked ').val()); */
		document.getElementById('total_amount').value = commaSplit(total_amount);
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
				document.getElementById('total_amount').value = commaSplit(total_amount/rate2_value);
				document.getElementById('tl_value1').value = deger_diger_para;
			}
		}

	}
	
	function kontrol()
	{
		if(!chk_process_cat('add_process')) return false;
		if(!check_display_files('add_process')) return false;
		if(!chk_period(add_process.action_date,'İşlem')) return false;
		
		var p_type_ = "VIRMAN";
		var table_name_ = "BANK_ACTIONS";
		var alert_name_ = "<cf_get_lang dictionary_id='52371.Aynı Belge No İle Kayıtlı Virman İşlemi Var'>";
		paper_num_list = '';
		
		for(j=1; j<=document.getElementById('record_num').value; j++)
		{
			if(document.getElementById('row_kontrol'+j).value==1)
			{
				record_exist=1;
				//belge no kontrolü
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
				if(document.getElementById('paper_number'+j).value != "" )
				{
					paper = document.getElementById('paper_number'+j).value;
					paper = "'"+paper+"'";
					if(list_find(paper_num_list,paper,','))
					{
						alert("<cf_get_lang dictionary_id='33815.Aynı Belge Numarası İle Eklenen İki Farklı Satır Var'>:" +paper+"");
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
				//satirda hesaplarin kontrolu 
				if (list_getat(document.getElementById('from_account_id'+j).value,1,';') == "" || list_getat(document.getElementById('to_account_id'+j).value,1,';') == "")
				{ 
					alert (document.getElementById('paper_number'+j).value+":<cf_get_lang dictionary_id='58205.Lütfen Banka Hesabı Seçiniz'>!");
					return false;
				}
				//satirda bankalarin farkliligi kontrolu
				if(list_getat(document.getElementById('from_account_id'+j).value,1,';') == list_getat(document.getElementById('to_account_id'+j).value,1,';'))				
				{
					alert(document.getElementById('paper_number'+j).value+":<cf_get_lang dictionary_id='48755.Seçtiğiniz Banka Hesapları Aynı !'>");		
					return false; 
				}
				//satirda bankalara ait para birimi kontrolu
				if (list_getat(document.getElementById('from_account_id'+j).value,2,';') != list_getat(document.getElementById('to_account_id'+j).value,2,';'))
				{ 
					alert (document.getElementById('paper_number'+j).value+ ":<cf_get_lang dictionary_id='52402.Seçilen Bankalara Ait Para birimleri Aynı Olmalıdır'>!");
					return false;
				}
				//masraf girilmisse buna bagli masraf merkezi ve gider kalemi kontrolu
				if(document.getElementById('expense_amount'+j).value != "" && parseFloat(filterNum(document.getElementById('expense_amount'+j).value)) > 0)
				{
					if(document.getElementById('expense_center_id'+j).value == "" || document.getElementById('expense_center_name'+j).value == "")
					{
						alert (document.getElementById('paper_number'+j).value+ ":<cf_get_lang dictionary_id='50369.Masraf Merkezi Seçiniz'>");
						return false;
					}
					if(document.getElementById('expense_item_id'+j).value == "" || document.getElementById('expense_item_name'+j).value == "")
					{
						alert (document.getElementById('paper_number'+j).value+ ":<cf_get_lang dictionary_id='50368.Gider Kalemi Seçiniz'>");
						return false;
					}
				}
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id='48664.Lütfen Satır Ekleyiniz'>");
			return false;
		}
		return true;
	}
</script>
