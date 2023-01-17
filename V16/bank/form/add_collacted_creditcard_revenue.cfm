<cf_papers paper_type="creditcard_revenue">
<cfset select_input = 'account_id'>
<cfparam name="attributes.money_type_control" default="">
<cfparam name="attributes.currency_id_info" default="">
<cfset to_branch_id = ''>
<cfinclude template="../../cash/query/get_money.cfm">
<!--- tahsilat tipleri --->
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#dsn#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1
</cfquery>
<!--- hesap/odeme yontemleri --->
<cfquery name="getCreditCards" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		ACCOUNTS.ACCOUNT_CURRENCY_ID,
		PAYMENT_RATE,
		PAYMENT_RATE_ACC,
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO
	FROM
		ACCOUNTS ACCOUNTS WITH (NOLOCK),
		CREDITCARD_PAYMENT_TYPE CPT WITH (NOLOCK)
	WHERE
		ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#"> AND
		ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT
		AND CPT.IS_ACTIVE = 1
		AND ACCOUNT_STATUS = 1
	UNION ALL
		SELECT
			0 AS ACCOUNT_ID,
			'' AS ACCOUNT_NAME,
			'#session.ep.money#' AS ACCOUNT_CURRENCY_ID,
			PAYMENT_RATE,
			PAYMENT_RATE_ACC,
			CPT.PAYMENT_TYPE_ID,
			CPT.CARD_NO
		FROM
			CREDITCARD_PAYMENT_TYPE CPT WITH (NOLOCK)
		WHERE
			CPT.COMPANY_ID IS NOT NULL 
			AND CPT.IS_ACTIVE = 1
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
<cfset pageHead = getLang('main','Toplu Kredi Kartı Tahsilatı',47230)>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_process">
			<cf_basket_form id="collacted_creditcard">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>">
				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="process_date" value="#dateformat(now(),dateformat_style)#" maxlength="10" validate="#validate_style#" required="Yes" message="#getLang('','Lutfen Tarih Giriniz',58503)#" onBlur="change_money_info('add_process','process_date');">
									<span class="input-group-addon"><cf_wrk_date_image date_field="process_date" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.işlem tipi'>*</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat process_type_info="2410">
							</div>
						</div>
						<div class="form-group" id="item-branch_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkDepartmentBranch fieldId='branch_id' selected_value='#to_branch_id#' is_branch='1' is_default='1' is_deny_control='1'>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</cf_basket_form>
			<cf_basket id="collacted_creditcard_sepet">
				<cf_grid_list>
					<thead>
						<tr>
							<th width="20" nowrap="nowrap"></th>
							<th width="20" class="text-center"><a href="javascript://" onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57880.Belge No'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57416.Proje'></th>
							<th width="152" nowrap="nowrap"><cf_get_lang dictionary_id ='29502.Abone No'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='48894.Kart hamili'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='49031.Hesap/Ödeme Yöntemi'> *</th>
							<th nowrap="nowrap" class="text-right"><cf_get_lang dictionary_id='57673.Tutar'>*</th>
							<th nowrap="nowrap" class="text-right"><cf_get_lang dictionary_id='50421.Komisyonlu Tutar'> *</th>
							<th nowrap="nowrap" class="text-right"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57742.Tarih'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='50447.Vade Başlangıç Tarihi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58929.Tahsilat Tipi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='50233.Tahsil Eden'></th>
						</tr>
					</thead>
					<tbody id="table1">
					</tbody>
				</cf_grid_list>
				<cf_basket_footer>
					<div class="ui-row">
						<div id="sepetim_total" class="padding-0">
							<input name="record_num" id="record_num" type="hidden" value="0">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='50370.Dövizler'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table cellspacing="0">
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
														<td valign="bottom">#TLFormat(rate1,0)#/<input type="text" class="box" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,rate_round_num_info)#" onKeyUp="return(FormatCurrency(this,event,'#rate_round_num_info#'));" onBlur="if(filterNum(this.value,'#rate_round_num_info#') <=0) this.value=commaSplit(1);kur_ekle_f_hesapla('#select_input#',false);"></td>
														</tr>
												</cfloop>
											</cfoutput>                   	
										</table>
									</div>
								</div>
							</div>
							<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<tr>
												<td style="text-align:right;">
													<input type="text" name="total_amount" id="total_amount" class="box" value="0" readonly>
													<input type="text" name="total_amount_currency" id="total_amount_currency" class="box" readonly="readonly" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:40px;">
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
</div>
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
					
	function add_row(action_company_id,card_owner,project_id,project_name,action_consumer_id,action_par_id,comp_name,paper_no,amount,system_amount,commission_amount,other_amount,other_money,action_date,due_start_date,special_definition_id,employee_id,employee_name,payment_type_id,currency_id,account_acc_code,account_id,payment_rate,payment_rate_acc,subscription_id,subscription_no)
	{
		if(action_company_id == undefined) action_company_id = '';
		if(action_consumer_id == undefined) action_consumer_id = '';
		if(action_par_id == undefined) action_par_id = '';
		if(comp_name == undefined) comp_name = '';
		if(paper_no == undefined) paper_no = '';
		if(amount == undefined) amount = 0;
		if(system_amount == undefined) system_amount = 0;
		if(commission_amount == undefined) commission_amount = 0;	
		if(other_amount == undefined) other_amount = 0;	
		if(other_money == undefined) other_money = '<cfoutput>#session.ep.money#</cfoutput>';
		if(action_date == undefined) action_date = "<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>";
		if(due_start_date == undefined) due_start_date = "<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>";
		if(special_definition_id == undefined) special_definition_id = '';
		if(employee_id == undefined) employee_id = '<cfoutput>#session.ep.userid#</cfoutput>';
		if(employee_name == undefined) employee_name = '<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>';
		if(payment_type_id == undefined) payment_type_id = '';
		if(currency_id == undefined) currency_id = '';
		if(account_acc_code == undefined) account_acc_code = '';
		if(account_id == undefined) account_id = '';
		if(payment_rate == undefined) payment_rate = '';
		if(payment_rate_acc == undefined) payment_rate_acc = '';
		if(project_name == undefined) project_name = '';
		if(project_id == undefined) project_id = '';
		if(subscription_id == undefined) subscription_id = '';
		if(subscription_no == undefined) subscription_no = '';
		if(card_owner == undefined) card_owner = '';		
		
		row_count++;
		var newRow;
		var newCell;	
		document.getElementById('record_num').value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newRow.setAttribute("class","nohover");
		newRow.id = "frm_row" + row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="row_' + row_count +'" id="row_' + row_count +'" value="'+row_count+'" readonly="readonly" style="text-align:left; width:20px;" class="box">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><ul class="ui-icon-list"><li><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="Sil"></i></a></li><li><a onclick="copy_row('+row_count+');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li></ul>';
		//cari hesap
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML += '<input type="hidden" name="action_company_id' + row_count +'" id="action_company_id' + row_count +'"  value="'+action_company_id+'"><input type="hidden" name="action_consumer_id' + row_count +'" id="action_consumer_id' + row_count +'"  value="'+action_consumer_id+'"><input type="hidden" name="action_par_id' + row_count +'" id="action_par_id' + row_count +'"  value="'+action_par_id+'"><input type="text" name="comp_name' + row_count +'" id="comp_name' + row_count +'" onFocus="autocomp('+row_count+');"  value="'+comp_name+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		//belge no
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="paper_number' + row_count +'" id="paper_number' + row_count +'" value="'+auto_paper_code + auto_paper_number+'" class="boxtext">';
		if(auto_paper_number != '')
			auto_paper_number++;
		//proje
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML += '<input type="hidden" name="project_id' + row_count +'" id="project_id' + row_count +'"  value="'+project_id+'"><input type="text" name="project_name' + row_count +'" id="project_name' + row_count +'" value="'+project_name+'" class="boxtext"><a href="javascript://" onClick="open_project('+row_count+');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		//abone
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value="'+subscription_id+'" /><input type="text" name="subscription_no'+ row_count +'" id="subscription_no'+ row_count +'" value="'+subscription_no+'" /><a href="javascript://" onClick="open_subscription('+ row_count +')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
	
		//kart hamili
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML += '<input name="card_owner' +row_count+ '" id="card_owner' +row_count+ '" type="text" value="'+card_owner+'" maxlength="30">';
		//hesap/odeme yontemi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		c = '<select name="payment_type_id' + row_count  +'" id="payment_type_id' + row_count  +'" class="boxtext" onChange="get_acc_info('+row_count+'); change_comm_value('+row_count+'); kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
		<cfoutput query="getCreditCards">
			if('#payment_type_id#' == payment_type_id)
				c += '<option value="#payment_type_id#" selected><cfif len(account_name)>#account_name#/</cfif>#card_no#</option>';
			else
				c += '<option value="#payment_type_id#"><cfif len(account_name)>#account_name#/</cfif>#card_no#</option>';
		</cfoutput>
		newCell.innerHTML =c+ '</select><input type="hidden" name="currency_id' + row_count +'" id="currency_id' + row_count +'" value="'+currency_id+'"><input type="hidden" name="account_acc_code' + row_count +'" id="account_acc_code' + row_count +'" value="'+account_acc_code+'"><input type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+account_id+'"><input type="hidden" name="payment_rate' + row_count +'" id="payment_rate' + row_count +'" value="'+payment_rate+'"><input type="hidden" name="payment_rate_acc'+row_count+'" id="payment_rate_acc'+row_count+'" value="'+payment_rate_acc+'">';
		//tutar
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="system_amount' + row_count +'" id="system_amount'+ row_count + '" value="'+commaSplit(system_amount)+'"><input type="text" name="amount' + row_count +'" id="amount' + row_count + '" value="'+commaSplit(amount)+'" onkeyup="return(FormatCurrency(this,event));" onBlur="change_comm_value('+row_count+'); kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');" float:right;" class="box">';
		// komisyon tutari
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="commission_amount' + row_count +'" id="commission_amount' + row_count +'" value="'+commaSplit(commission_amount)+'" onkeyup="return(FormatCurrency(this,event));" style="width:100px; float:right;" class="box">';
		//doviz tutar
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="other_amount' + row_count +'" id="other_amount' + row_count + '" value="'+commaSplit(other_amount)+'" readonly="readonly" onkeyup="return(FormatCurrency(this,event));" class="box" onBlur="kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',true,'+row_count+');">';
		//para birimi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select name="money_id' + row_count  +'" id="money_id' + row_count + '" class="boxtext" onChange="kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');">';
		<cfoutput query="get_money">
			if('#money#' == other_money)
				a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#" selected>#money#</option>';
			else
				a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#">#money#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select>';
		//tarih
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("id","action_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="action_date' + row_count +'" name="action_date' + row_count +'" class="text" maxlength="10" value="' + action_date +'"> ';
		wrk_date_image('action_date' + row_count);
		//vade baslangic tarih
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("id","due_start_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="due_start_date' + row_count +'" name="due_start_date' + row_count +'" class="text" maxlength="10" value="' + due_start_date +'"> ';
		wrk_date_image('due_start_date' + row_count);
		//tahsilat tipi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select name="special_definition_id' + row_count  +'" id="special_definition_id' + row_count  +'" class="boxtext"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
		<cfoutput query="GET_SPECIAL_DEFINITION">
			if('#SPECIAL_DEFINITION_ID#' == special_definition_id)
				b += '<option value="#SPECIAL_DEFINITION_ID#" selected>#SPECIAL_DEFINITION#</option>';
			else
				b += '<option value="#SPECIAL_DEFINITION_ID#">#SPECIAL_DEFINITION#</option>';
		</cfoutput>
		newCell.innerHTML =b+ '</select>';
		//tahsil eden
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="employee_id'+ row_count +'" id="employee_id'+ row_count +'" value="'+employee_id+'"><input type="text" name="employee_name'+ row_count +'" id="employee_name'+ row_count +'" onFocus="autocomp_employee('+row_count+');" value="'+employee_name+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_employee('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		
		kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',true,row_count);
	}
	
	function copy_row(no_info)
	{
		action_company_id = document.getElementById('action_company_id' + no_info).value; 
		action_consumer_id = document.getElementById('action_consumer_id' + no_info).value; 	
		action_par_id = document.getElementById('action_par_id' + no_info).value;
		comp_name = document.getElementById('comp_name' + no_info).value;
		paper_number = document.getElementById('paper_number' + no_info).value;
		amount = document.getElementById('amount' + no_info).value;
		system_amount = document.getElementById('system_amount' + no_info).value;
		commission_amount = document.getElementById('commission_amount' + no_info).value;
		amount = document.getElementById('amount' + no_info).value;
		other_amount = document.getElementById('other_amount' + no_info).value;
		money_id = list_getat(document.getElementById('money_id' + no_info).value,1,';');
		action_date = document.getElementById('action_date' + no_info).value;
		due_start_date = document.getElementById('due_start_date' + no_info).value;
		special_definition_id = document.getElementById('special_definition_id' + no_info).value;
		employee_id = document.getElementById('employee_id' + no_info).value;
		employee_name = document.getElementById('employee_name' + no_info).value;
		payment_type_id = document.getElementById('payment_type_id' + no_info).value;
		currency_id = document.getElementById('currency_id' + no_info).value;
		account_acc_code = document.getElementById('account_acc_code' + no_info).value;
		account_id = document.getElementById('account_id' + no_info).value;
		payment_rate = document.getElementById('payment_rate' + no_info).value;
		payment_rate_acc = document.getElementById('payment_rate_acc' + no_info).value;
		project_id = document.getElementById('project_id' + no_info).value;
		project_name = document.getElementById('project_name' + no_info).value;
		subscription_id = document.getElementById('subscription_id' + no_info).value;
		subscription_no = document.getElementById('subscription_no' + no_info).value;
		card_owner = document.getElementById('card_owner' + no_info).value;
			
		add_row(action_company_id,card_owner,project_id,project_name,action_consumer_id,action_par_id,comp_name,paper_number,amount,system_amount,commission_amount,other_amount,money_id,action_date,due_start_date,special_definition_id,employee_id,employee_name,payment_type_id,currency_id,account_acc_code,account_id,payment_rate,payment_rate_acc,subscription_id,subscription_no);
	}
	
	function autocomp(no)
	{
		AutoComplete_Create("comp_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME","MEMBER_NAME,MEMBER_PARTNER_NAME","get_member_autocomplete","\'1,2\'","COMPANY_ID,PARTNER_ID,CONSUMER_ID","action_company_id"+no+",action_par_id"+no+",action_consumer_id"+no+"","",3,250,"");
	}
	function autocomp_employee(no)
	{
		AutoComplete_Create("employee_name"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","3","EMPLOYEE_ID","employee_id"+no,"",3,140);
	}
	
	function pencere_ac_company(sira_no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&row_no='+ sira_no +'&select_list=2,3&field_comp_id=add_process.action_company_id'+ sira_no +'&field_member_name=add_process.comp_name'+ sira_no +'&field_name=add_process.comp_name' + sira_no +'&field_partner=add_process.action_par_id'+ sira_no +'&field_consumer=add_process.action_consumer_id'+ sira_no);
	}
	function pencere_ac_employee(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_process.employee_id' + no +'&field_name=add_process.employee_name' + no +'&select_list=1,9');
	}
	function open_subscription(sira_no){
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_process.subscription_id'+ sira_no +'&field_no=add_process.subscription_no'+ sira_no);
	}
	function open_project(no){
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=add_process.project_name' + no+'&project_id=add_process.project_id' + no);
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
				get_rate_ = wrk_query("SELECT RATE2 FROM SETUP_MONEY WHERE MONEY ='" +list_getat(document.getElementById('money_id'+j).value,2,';')+ "' AND PERIOD_ID=" + document.getElementById('active_period').value + " AND COMPANY_ID="+ document.getElementById('active_company').value,"dsn");
				if(get_rate_.recordcount)
					var rate_ = get_rate_.RATE2;
				total_amount += parseFloat(filterNum(document.getElementById('amount'+j).value)*rate_);
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
		
		paper_num_list = '';
		
		for(j=1; j<=document.getElementById('record_num').value; j++)
		{
			if(document.getElementById('row_kontrol'+j).value==1)
			{
				record_exist=1;
				//belge no kontrolü
				if(document.getElementById('paper_number'+j).value != "")
				{
					if(!paper_control(document.getElementById('paper_number'+j),'CREDITCARD_REVENUE','1','','','','','','<cfoutput>#dsn3#</cfoutput>')) return false;
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
						alert("<cf_get_lang dictionary_id='33815.Aynı Belge Numarası İle Eklenen İki Farklı Satır Var'>:"+ paper+"");
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
		//Satirda eksik bilgi kontrolleri
		for(var n=1; n<=add_process.record_num.value;n++)
		{
			if(document.getElementById("row_kontrol"+n).value == 1)
			{
				//Satirda cari hesap kontrolu
				if((document.getElementById("action_company_id"+n).value=="" || document.getElementById("action_consumer_id"+n).value=="" || document.getElementById("action_par_id"+n).value=="") && document.getElementById("comp_name"+n).value=="")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57519.Cari Hesap'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
				//Satirda tutar kontrolu
				if(document.getElementById("amount"+n).value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57673.Tutar'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
				//Satirda komisyonlu tutar kontrolu
				if(document.getElementById("commission_amount"+n).value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='48895.Komisyonlu'> <cf_get_lang dictionary_id ='57673.Tutar'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
				//Satirda hesap-odeme yontemi kontrolu
				if(document.getElementById("payment_type_id"+n).value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='49031.Hesap/Ödeme Yöntemi'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
			}
		}
			
		if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id ='48664.Lütfen Satır Ekleyiniz'>!");
			return false;
		}
		return true;
	}
	<cfoutput>
		function get_acc_info(row_no)
		{
			var acc_info = document.getElementById('payment_type_id'+row_no).value;
			if(acc_info != '')
			{
				var get_acc = wrk_query('SELECT ACCOUNTS.ACCOUNT_CURRENCY_ID,ACCOUNTS.ACCOUNT_ACC_CODE,ACCOUNTS.ACCOUNT_ID,CPT.PAYMENT_RATE,CPT.PAYMENT_RATE_ACC,CPT.CARD_NO FROM ACCOUNTS,CREDITCARD_PAYMENT_TYPE CPT WHERE ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND PAYMENT_TYPE_ID = '+acc_info,'dsn3');
				if(get_acc.recordcount != 0)
				{
					document.getElementById('currency_id'+row_no).value = get_acc.ACCOUNT_CURRENCY_ID;
					document.getElementById('account_acc_code'+row_no).value = get_acc.ACCOUNT_ACC_CODE;
					document.getElementById('account_id'+row_no).value = get_acc.ACCOUNT_ID;
					document.getElementById('payment_rate'+row_no).value = get_acc.PAYMENT_RATE;
					document.getElementById('payment_rate_acc'+row_no).value = get_acc.PAYMENT_RATE_ACC;
				}
				else
				{
					var get_acc = wrk_query('SELECT CPT.PAYMENT_RATE,CPT.PAYMENT_RATE_ACC,CPT.CARD_NO FROM CREDITCARD_PAYMENT_TYPE CPT WHERE PAYMENT_TYPE_ID = '+acc_info,'dsn3');
					document.getElementById('currency_id'+row_no).value = "#session.ep.money#";
					document.getElementById('account_acc_code'+row_no).value = '';
					document.getElementById('account_id'+row_no).value = 0;
					document.getElementById('payment_rate'+row_no).value = get_acc.PAYMENT_RATE;
					document.getElementById('payment_rate_acc'+row_no).value = get_acc.PAYMENT_RATE_ACC;
				}
				
			}
			else
			{
				document.getElementById('currency_id'+row_no).value = '';
				document.getElementById('account_acc_code'+row_no).value = '';
				document.getElementById('account_id'+row_no).value = '';
				document.getElementById('payment_rate'+row_no).value = '';
				document.getElementById('payment_rate_acc'+row_no).value = '';
			}
		}
	</cfoutput>
	
	function kur_ekle_f_hesapla(select_input,doviz_tutar,satir)
	{
		if(satir != undefined)
		{
			if(!doviz_tutar) doviz_tutar=false;
			var currency_type = document.getElementById('<cfoutput>#select_input#</cfoutput>'+satir).value;
			if(document.getElementById('currency_id'+satir) != undefined)
				currency_type = document.getElementById('currency_id'+satir).value;
			else
				currency_type = list_getat(currency_type,2,';');
			row_currency = list_getat(eval("document.add_process.money_id"+satir).value,1,';');
			var other_money_value_eleman=eval("document.add_process.other_amount"+satir);
			var temp_act,rate1_eleman,rate2_eleman;
			if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
			{
				other_money_value_eleman.value = '';
				return false;
			}
			if(!doviz_tutar && eval("document.add_process.commission_amount"+satir) != "" && currency_type != "")
			{
				for(var i=1;i<=add_process.kur_say.value;i++)
				{
					rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					if( eval('add_process.hidden_rd_money_'+i).value == currency_type)
					{
						temp_act=filterNum(eval("document.add_process.commission_amount"+satir).value)*rate2_eleman/rate1_eleman;
						eval("document.add_process.system_amount"+satir).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
					}
				}
				for(var i=1;i<=add_process.kur_say.value;i++)
				{
					rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
					{
						other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.system_amount"+satir).value)*rate1_eleman/rate2_eleman);
						eval("document.add_process.system_amount"+satir).value = commaSplit(filterNum(eval("document.add_process.system_amount"+satir).value));
					}
				}
			}
			else if(doviz_tutar)
			{
				for(var i=1;i<=add_process.kur_say.value;i++)
				{
					if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
					{
						if (eval('add_process.hidden_rd_money_'+i).value != '<cfoutput>#str_money_bskt_main#</cfoutput>' && filterNum(eval("document.add_process.system_amount"+satir).value) > 0)
							eval('add_process.txt_rate2_' + i).value = commaSplit(filterNum(eval("document.add_process.system_amount"+satir).value)/filterNum(other_money_value_eleman.value),'<cfoutput>#rate_round_num_info#</cfoutput>');
						else
							for(var t=1;t<=add_process.kur_say.value;t++)
								if( eval('add_process.hidden_rd_money_'+t).value == currency_type && eval("document.add_process.commission_amount"+satir).value > 0  && eval('add_process.hidden_rd_money_'+t).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
									eval('add_process.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(eval("document.add_process.commission_amount"+satir).value),'<cfoutput>#rate_round_num_info#</cfoutput>');
					}
				}					
				eval("document.add_process.commission_amount"+satir).value = commaSplit(filterNum(eval("document.add_process.commission_amount"+satir).value));
			}
		}
		else
		{
			if(!doviz_tutar) doviz_tutar=false;
			
			for(var kk=1;kk<=add_process.record_num.value;kk++)
			{
				var currency_type = document.getElementById('<cfoutput>#select_input#</cfoutput>'+kk).value;
				if(document.getElementById('currency_id'+kk) != undefined)
					currency_type = document.getElementById('currency_id'+kk).value;
				else
					currency_type = list_getat(currency_type,2,';');
					
				document.getElementById('total_amount_currency').value = currency_type;
				var other_money_value_eleman=eval("document.add_process.other_amount"+kk);
				var temp_act,rate1_eleman,rate2_eleman;
				row_currency = list_getat(eval("document.add_process.money_id"+kk).value,1,';');						
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{
					other_money_value_eleman.value = '';
					return false;
				}if(currency_type != "")
				if(!doviz_tutar && eval("document.add_process.commission_amount"+kk) != "" && currency_type != "")
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if(eval('add_process.hidden_rd_money_'+i).value == currency_type)
						{
							temp_act=filterNum(eval("document.add_process.commission_amount"+kk).value)*rate2_eleman/rate1_eleman;
							eval("document.add_process.system_amount"+kk).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
						}
					}
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.system_amount"+kk).value)*rate1_eleman/rate2_eleman);
							eval("document.add_process.system_amount"+kk).value = commaSplit(filterNum(eval("document.add_process.system_amount"+kk).value));
						}
					}
				}
				else if(doviz_tutar)
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							if (eval('add_process.hidden_rd_money_'+i).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
								eval('add_process.txt_rate2_' + i).value = commaSplit(filterNum(eval("document.add_process.system_amount"+kk).value)/filterNum(other_money_value_eleman.value),'<cfoutput>#rate_round_num_info#</cfoutput>');
							else
								for(var t=1;t<=add_process.kur_say.value;t++)
									if( eval('add_process.hidden_rd_money_'+t).value == currency_type && eval('add_process.hidden_rd_money_'+t).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
										eval('add_process.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(eval("document.add_process.commission_amount"+kk).value),'<cfoutput>#rate_round_num_info#</cfoutput>');
							if (eval('add_process.hidden_rd_money_'+i).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
								for(var k=1;k<=add_process.kur_say.value;k++)
								{
									rate1_eleman = filterNum(eval('add_process.txt_rate1_' + k).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
									rate2_eleman = filterNum(eval('add_process.txt_rate2_' + k).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
									if( eval('add_process.hidden_rd_money_'+k).value == currency_type)
									{
										temp_act=filterNum(eval("document.add_process.commission_amount"+kk).value)*rate2_eleman/rate1_eleman;
										eval("document.add_process.system_amount"+kk).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
									}
								}
							else
								eval("document.add_process.system_amount"+kk).value = other_money_value_eleman.value;
						}
					eval("document.add_process.commission_amount"+kk).value = commaSplit(filterNum(eval("document.add_process.commission_amount"+kk).value));
				}
			}
		}	
		toplam_hesapla();
		return true;
	}
	
	
	function change_comm_value(row_no)
	{
		if(document.getElementById('payment_rate_acc'+row_no).value != "" && document.getElementById('payment_rate'+row_no).value != "" && document.getElementById('payment_rate'+row_no).value != 0 && document.getElementById('amount'+row_no).value != "" && document.getElementById('currency_id'+row_no).value != "")
			document.getElementById('commission_amount'+row_no).value = commaSplit(parseFloat(filterNum(document.getElementById('amount'+row_no).value)) + (parseFloat(filterNum(document.getElementById('amount'+row_no).value )) * (parseFloat(document.getElementById('payment_rate'+row_no).value)/100)));
		else
			document.getElementById('commission_amount'+row_no).value = document.getElementById('amount'+row_no).value;
	}
</script>
