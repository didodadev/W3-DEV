<cf_get_lang_set module_name="bank">
<cf_papers paper_type="creditcard_revenue">
<cfset select_input = 'account_id'>
<cfset to_branch_id = ''>
<cfset dateInfo = dateformat(now(),'dd/mm/yyyy')>
<cfset processCat = ''>
<cfset recordNum = 0>
<cfparam name="attributes.money_type_control" default="">
<cfparam name="attributes.currency_id_info" default="">
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY,
		RATE2,
		RATE1,
		0 AS IS_SELECTED
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY_STATUS = 1
		<cfif isDefined('attributes.money') and len(attributes.money)>
			AND MONEY_ID = #attributes.money#
		</cfif>
	ORDER BY 
		MONEY_ID
</cfquery>
	<cfif IsDefined("attributes.event") and attributes.event eq 'updmulti'>
        <cfquery name="get_payment" datasource="#dsn3#">
            SELECT
                CBPM.ACTION_TYPE_ID,
                CBPM.ACTION_DATE,
                CBPM.PROCESS_CAT,
                CBPM.ACC_BRANCH_ID,
                CBPM.RECORD_DATE,
                CBPM.RECORD_EMP,
                CBPM.UPDATE_DATE,
                CBPM.UPDATE_EMP,
                CBPM.ACTION_PERIOD_ID,
                CBP.*
            FROM
                CREDIT_CARD_BANK_PAYMENTS_MULTI CBPM
                LEFT JOIN CREDIT_CARD_BANK_PAYMENTS CBP ON CBPM.MULTI_ACTION_ID = CBP.MULTI_ACTION_ID 
                LEFT JOIN CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID=CBP.PAYMENT_TYPE_ID
                LEFT JOIN ACCOUNTS ON ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT 
            WHERE
                CBPM.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#">
        </cfquery>
		<cfif not get_payment.recordcount>
            <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
            <cfexit method="exittemplate">
        </cfif>
        <cfquery name="get_money" datasource="#dsn3#">
            SELECT MONEY_TYPE MONEY,ACTION_ID,RATE2,RATE1,IS_SELECTED FROM CREDIT_CARD_BANK_PAYMENTS_MULTI_MONEY WHERE ACTION_ID = #get_payment.multi_action_id#
        </cfquery>
        <cfset dateInfo = dateformat(get_payment.action_date,'dd/mm/yyyy')>
        <cfset processCat = get_payment.process_cat>
        <cfset to_branch_id = get_payment.acc_branch_id>
        <cfset recordNum = get_payment.recordcount>
    </cfif>
    <cfquery name="GET_SPECIAL_DEFINITION" datasource="#dsn#">
        SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1
    </cfquery>
	<cfquery name="getCreditCards" datasource="#dsn3#">
        SELECT
            ACCOUNTS.ACCOUNT_ID,
            ACCOUNTS.ACCOUNT_NAME,
            ACCOUNTS.ACCOUNT_CURRENCY_ID,
            ACCOUNTS.ACCOUNT_ACC_CODE,
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
                '' AS ACCOUNT_ACC_CODE,
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
	<script type="text/javascript">
	<cfoutput>
		<cfif not (len(paper_code) and len(paper_number))>
			var auto_paper_code = "";
			var auto_paper_number = "";
		<cfelse>
			var auto_paper_code = "#paper_code#-";
			var auto_paper_number = "#paper_number#";
		</cfif>
	<cfif  IsDefined("attributes.event") and attributes.event eq 'updmulti'>	
		row_count=#get_payment.recordcount#;
	</cfif>
	</cfoutput>
	<cfif attributes.event eq 'addmulti'>
		row_count=0;
	</cfif>
	record_exist=0;
	
	function sil(sy)
	{
		var my_element=document.getElementById('row_kontrol'+sy);	
		my_element.value=0;		
		var my_element=eval("frm_row"+sy);	
		my_element.style.display="none";
		toplam_hesapla();		
	}
					
	function add_row(action_company_id,action_consumer_id,action_par_id,comp_name,paper_no,amount,system_amount,commission_amount,other_amount,other_money,action_date,due_start_date,special_definition_id,employee_id,employee_name,payment_type_id,currency_id,account_acc_code,account_id,payment_rate,payment_rate_acc)
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
		if(action_date == undefined) action_date = "<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>";
		if(due_start_date == undefined) due_start_date = "<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>";
		if(special_definition_id == undefined) special_definition_id = '';
		if(employee_id == undefined) employee_id = '<cfoutput>#session.ep.userid#</cfoutput>';
		if(employee_name == undefined) employee_name = '<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>';
		if(payment_type_id == undefined) payment_type_id = '';
		if(currency_id == undefined) currency_id = '';
		if(account_acc_code == undefined) account_acc_code = '';
		if(account_id == undefined) account_id = '';
		if(payment_rate == undefined) payment_rate = '';
		if(payment_rate_acc == undefined) payment_rate_acc = '';
		
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
		newCell.innerHTML = '<input type="text" name="row_' + row_count +'" id="row_' + row_count +'" value="'+row_count+'" readonly="readonly" style="text-align:left; width:25px;" class="box">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0" align="absmiddle"></a>';
		//cari hesap
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML += '<input type="hidden" name="action_company_id' + row_count +'" id="action_company_id' + row_count +'"  value="'+action_company_id+'"><input type="hidden" name="action_consumer_id' + row_count +'" id="action_consumer_id' + row_count +'"  value="'+action_consumer_id+'"><input type="hidden" name="action_par_id' + row_count +'" id="action_par_id' + row_count +'"  value="'+action_par_id+'"><input type="text" name="comp_name' + row_count +'" id="comp_name' + row_count +'" onFocus="autocomp('+row_count+');"  value="'+comp_name+'" style="width:162px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		//belge no
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="paper_number' + row_count +'" id="paper_number' + row_count +'" value="'+auto_paper_code + auto_paper_number+'" class="boxtext">';
		if(auto_paper_number != '')
			auto_paper_number++;
		//hesap/odeme yontemi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		c = '<select name="payment_type_id' + row_count  +'" id="payment_type_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="get_acc_info('+row_count+'); change_comm_value('+row_count+'); kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
		<cfoutput query="getCreditCards">
			if('#payment_type_id#' == payment_type_id)
				c += '<option value="#payment_type_id#" selected><cfif len(account_name)>#account_name#/</cfif>#card_no#</option>';
			else
				c += '<option value="#payment_type_id#"><cfif len(account_name)>#account_name#/</cfif>#card_no#</option>';
		</cfoutput>
		newCell.innerHTML =c+ '<input type="hidden" name="currency_id' + row_count +'" id="currency_id' + row_count +'" value="'+currency_id+'"><input type="hidden" name="account_acc_code' + row_count +'" id="account_acc_code' + row_count +'" value="'+account_acc_code+'"><input type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+account_id+'"><input type="hidden" name="payment_rate' + row_count +'" id="payment_rate' + row_count +'" value="'+payment_rate+'"><input type="hidden" name="payment_rate_acc'+row_count+'" id="payment_rate_acc'+row_count+'" value="'+payment_rate_acc+'"></select>';
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
		newCell.innerHTML = '<input type="text" name="other_amount' + row_count +'" id="other_amount' + row_count + '" value="'+commaSplit(other_amount)+'" readonly="readonly" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',true,'+row_count+');">';
		//para birimi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select name="money_id' + row_count  +'" id="money_id' + row_count + '" style="width:100%;" class="boxtext" onChange="kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');">';
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
		newCell.innerHTML = '<input type="text" id="action_date' + row_count +'" name="action_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' + action_date +'"> ';
		wrk_date_image('action_date' + row_count);
		//vade baslangic tarih
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("id","due_start_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="due_start_date' + row_count +'" name="due_start_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' + due_start_date +'"> ';
		wrk_date_image('due_start_date' + row_count);
		//tahsilat tipi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select name="special_definition_id' + row_count  +'" id="special_definition_id' + row_count  +'" style="width:100%;" class="boxtext"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
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
		newCell.innerHTML = '<input type="hidden" name="employee_id'+ row_count +'" id="employee_id'+ row_count +'" value="'+employee_id+'"><input type="text" style="width:133px;" name="employee_name'+ row_count +'" id="employee_name'+ row_count +'" onFocus="autocomp_employee('+row_count+');" value="'+employee_name+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_employee('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		
		kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',true,row_count);
		<cfif attributes.event eq 'updmulti'>
			toplam_hesapla();
		</cfif>
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
		
		add_row(action_company_id,action_consumer_id,action_par_id,comp_name,paper_number,amount,system_amount,commission_amount,other_amount,money_id,action_date,due_start_date,special_definition_id,employee_id,employee_name,payment_type_id,currency_id,account_acc_code,account_id,payment_rate,payment_rate_acc);
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
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&row_no='+ sira_no +'&select_list=2,3&field_comp_id=add_process.action_company_id'+ sira_no +'&field_member_name=add_process.comp_name'+ sira_no +'&field_name=add_process.comp_name' + sira_no +'&field_partner=add_process.action_par_id'+ sira_no +'&field_consumer=add_process.action_consumer_id'+ sira_no,'list');
	}
	function pencere_ac_employee(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_process.employee_id' + no +'&field_name=add_process.employee_name' + no +'&select_list=1,9','list');
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
					data: {money: list_getat(document.getElementById('money_id'+j).value,1,';'),period: document.getElementById('active_period').value,company: document.getElementById('active_company').value},
					cache: false,
					async: false,
					success: function(read_data){
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
							$.each(data_.DATA,function(i){
								get_rate_ = data_.DATA[i][0];
								});
						}
					}
				});
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
				//belge no kontrolü----
				<cfif attributes.event eq 'addmulti'>
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
				</cfif>
				<cfif  attributes.event eq 'updmulti'>
					if(document.getElementById('id'+j) != undefined)
					{
						if(document.getElementById('paper_number'+j).value != "")
						{
							if(!paper_control(document.getElementById('paper_number'+j),'CREDITCARD_REVENUE','1',document.getElementById('id'+j).value,document.getElementById('paper_number'+j).value,'','','','<cfoutput>#dsn3#</cfoutput>')) return false;
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
					}
				</cfif>
				if(document.getElementById('paper_number'+j).value != "" )
				{
					paper = document.getElementById('paper_number'+j).value;
					paper = "'"+paper+"'";
					if(list_find(paper_num_list,paper,','))
					{
						alert("<cf_get_lang dictionary_id='33815.Aynı Belge Numarası İle Eklenen İki Farklı Satır Var'>:"+ paper);
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
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='107.Cari Hesap'>! <cf_get_lang_main no='818.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
				//Satirda tutar kontrolu
				if(document.getElementById("amount"+n).value == "")
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='261.Tutar'>! <cf_get_lang_main no='818.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
				//Satirda komisyonlu tutar kontrolu
				if(document.getElementById("commission_amount"+n).value == "")
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : Komisyonlu <cf_get_lang_main no ='261.Tutar'>! <cf_get_lang_main no='818.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
				//Satirda hesap-odeme yontemi kontrolu
				if(document.getElementById("payment_type_id"+n).value == "")
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : Hesap/Ödeme Yöntemi! <cf_get_lang_main no='818.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
			}
		}
			
		if (record_exist == 0) 
		{
			alert("<cf_get_lang no ='3.Lütfen Satır Ekleyiniz'>!");
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
				url_= '/V16/bank/cfc/bankInfo.cfc?method=paymentTypeAccount';
				
				$.ajax({
					type: "get",
					url: url_,
					data: {paymentType: acc_info},
					cache: false,
					async: false,
					success: function(read_data){
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
							$.each(data_.DATA,function(i){
								document.getElementById('currency_id'+row_no).value = data_.DATA[i][0];
								document.getElementById('account_acc_code'+row_no).value = data_.DATA[i][1];
								document.getElementById('account_id'+row_no).value = data_.DATA[i][2];
								document.getElementById('payment_rate'+row_no).value = data_.DATA[i][3];
								document.getElementById('payment_rate_acc'+row_no).value = data_.DATA[i][4];
								});
						}
						else
						{
							$.ajax({
								type: "get",
								url: '/V16/bank/cfc/bankInfo.cfc?method=paymentTypeInfo',
								data: {paymentType: acc_info},
								cache: false,
								async: false,
								success: function(read_data){
									data_ = jQuery.parseJSON(read_data.replace('//',''));
									if(data_.DATA.length != 0)
									{
										$.each(data_.DATA,function(i){
											document.getElementById('currency_id'+row_no).value = "#session.ep.money#";
											document.getElementById('account_acc_code'+row_no).value = '';
											document.getElementById('account_id'+row_no).value = 0;
											document.getElementById('payment_rate'+row_no).value = data_.DATA[i][0];
											document.getElementById('payment_rate_acc'+row_no).value = data_.DATA[i][1];
											});
									}
								}
							});
						}
					}
				});				
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
	<cfif  attributes.event eq 'updmulti'>
		$(document).ready(function(){
			toplam_hesapla();	
		});
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined("attributes.event"))
		attributes.event = 'add';
/*	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 2410;
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';*/
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.add_collacted_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/form_collacted_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/add_collacted_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.add_collacted_creditcard_revenue&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('collacted_creditcard','collacted_creditcard_sepet')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.add_collacted_creditcard_revenue';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/form_collacted_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'bank/query/upd_collacted_creditcard_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.add_collacted_creditcard_revenue&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'multi_id=##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('collacted_creditcard','collacted_creditcard_sepet')";

	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.emptypopup_del_collacted_creditcard_revenue&multi_action_id=#attributes.multi_id#&active_period=#get_payment.action_period_id#&old_process_type=#get_payment.action_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_collacted_creditcard_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_collacted_creditcard_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_creditcard_revenue';
	}
	
	if(IsDefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=#get_payment.ACTION_TYPE_ID#','wide','add_process');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.add_collacted_creditcard_revenue";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'collectedCreditcardRevenue';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CREDIT_CARD_BANK_PAYMENTS_MULTI';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_date','item-process_cat']";
</cfscript>