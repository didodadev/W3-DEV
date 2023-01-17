<cf_get_lang_set module_name="credit">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cf_xml_page_edit fuseact="credit.popup_list_credit_contract">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.credit_employee_id" default="">
    <cfparam name="attributes.credit_employee" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.is_active" default="1">
    <cfparam name="attributes.process_type" default="">
    <cfparam name="attributes.listing_type" default="1">
    <cfparam name="attributes.credit_limit_id" default="">
    <cfparam name="attributes.credit_type_id" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.expense_center_id" default="">
    <cfparam name="attributes.capital_price" default="">
    <cfparam name="attributes.CAPITAL_ACCOUNT_ID" default="">
    <cfparam name="attributes.capital_expense_item_id" default="">
    <cfparam name="attributes.expense_item_name" default="">
    <cfparam name="attributes.interest_price" default="">
    <cfparam name="attributes.interest_account_id" default="">
    <cfparam name="attributes.expense_item_id" default="">
    <cfparam name="attributes.expense_item_name" default="">
    <cfparam name="attributes.tax_price" default="">
    <cfparam name="attributes.total_account_id" default="">
    <cfparam name="attributes.total_expense_item_id" default="">
    <cfparam name="attributes.total_price" default="">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif len(attributes.start_date)>
        <cf_date tarih='attributes.start_date'>
    </cfif>
    <cfif len(attributes.finish_date)>
        <cf_date tarih='attributes.finish_date'>
    </cfif>
    <cfscript>
        getCredit_ = createobject("component","credit.cfc.credit");
        getCredit_.dsn3 = dsn3;
    </cfscript>
    <cfif isdefined("attributes.form_submitted")>
        <cfscript>
            get_credit_contracts = getCredit_.getCredit
            (
                listing_type : attributes.listing_type,
                company_id : attributes.company_id,
                company : attributes.company,
                keyword : attributes.keyword,
                credit_employee_id : attributes.credit_employee_id,
                credit_employee:attributes.credit_employee,
                start_date : attributes.start_date,
                finish_date :  attributes.finish_date,
                is_active : attributes.is_active,
                process_type : attributes.process_type,
                credit_limit_id : attributes.credit_limit_id,
                credit_type_id : attributes.credit_type_id,
                startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
            );
        </cfscript>
        <cfparam name="attributes.totalrecords" default='#get_credit_contracts.QUERY_COUNT#'>
    <cfelse> 
        <cfset get_credit_contracts.recordcount = 0>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif> 
       <cfquery name="get_credit_limit" datasource="#dsn3#">
        SELECT CREDIT_LIMIT_ID, LIMIT_HEAD FROM CREDIT_LIMIT ORDER BY LIMIT_HEAD
    </cfquery>
    <cfscript>
        get_setup_process_cat_fusename = getCredit_.get_setup_process_cat_fusename();
    </cfscript>
    <cfscript>
		getTotalCreditPayment = getCredit_.getTotalCreditPayment(
			listing_type : attributes.listing_type,
			company_id : attributes.company_id,
			company : attributes.company,
			keyword : attributes.keyword,
			credit_employee_id : attributes.credit_employee_id,
			credit_employee : attributes.credit_employee,
			start_date : attributes.start_date,
			finish_date :  attributes.finish_date,
			is_active : attributes.is_active,
			process_type : attributes.process_type,
			credit_limit_id : attributes.credit_limit_id,
			credit_type_id : attributes.credit_type_id 
		);
	</cfscript>
    <script type="text/javascript">
		$( document ).ready(function() {
			$('#keyword').focus();
		});
	</script>
</cfif>

<cfif IsDefined("attributes.event")>
<cf_xml_page_edit fuseact="credit.add_credit_contract">
	<cfquery name="get_expense_center" datasource="#dsn2#">
        SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE
    </cfquery>
    <cfquery name="get_credit_limit" datasource="#dsn3#">
        SELECT * FROM CREDIT_LIMIT ORDER BY LIMIT_HEAD
    </cfquery>
	<cfif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)>
    	<cfquery name="GET_CREDIT_CONTRACT" datasource="#DSN3#">
            SELECT * FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = #attributes.credit_contract_id#
        </cfquery>
        <cfquery name="GET_ROWS_1" datasource="#DSN3#">
            SELECT
                C.CREDIT_CONTRACT_ROW_ID,
                C.CREDIT_CONTRACT_TYPE,
                C.CREDIT_CONTRACT_ID,
                C.PROCESS_DATE,
                C.CAPITAL_PRICE,					
                C.INTEREST_PRICE,
                C.TAX_PRICE,
                C.TOTAL_PRICE,
                C.OTHER_MONEY,
                C.EXPENSE_CENTER_ID,
                C.EXPENSE_ITEM_ID,
                C.INTEREST_ACCOUNT_ID,
                C.TOTAL_EXPENSE_ITEM_ID,
                C.TOTAL_ACCOUNT_ID,	
                C.DETAIL,
                C.IS_PAID,
                C.CAPITAL_EXPENSE_ITEM_ID,
                C.CAPITAL_ACCOUNT_ID ,
                C.BORROW,
                EI.EXPENSE_ITEM_NAME,
                EI.ACCOUNT_CODE
            FROM
                CREDIT_CONTRACT_ROW C
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = ISNULL(C.EXPENSE_ITEM_ID,ISNULL(C.TOTAL_EXPENSE_ITEM_ID,C.CAPITAL_EXPENSE_ITEM_ID))
            WHERE
                C.CREDIT_CONTRACT_ID = #url.credit_contract_id# AND
                C.CREDIT_CONTRACT_TYPE = 1 AND
                C.IS_PAID = 0
        </cfquery>
        <cfquery name="GET_ROWS_2" datasource="#DSN3#">
            SELECT
                C.CREDIT_CONTRACT_ROW_ID,
                C.CREDIT_CONTRACT_TYPE,
                C.CREDIT_CONTRACT_ID,
                C.PROCESS_DATE,
                C.CAPITAL_PRICE,					
                C.INTEREST_PRICE,
                C.TAX_PRICE,
                C.TOTAL_PRICE,
                C.OTHER_MONEY,
                C.EXPENSE_CENTER_ID,
                C.EXPENSE_ITEM_ID,
                C.INTEREST_ACCOUNT_ID,
                C.TOTAL_EXPENSE_ITEM_ID,
                C.TOTAL_ACCOUNT_ID,	
                C.DETAIL,
                C.IS_PAID,
                C.CAPITAL_EXPENSE_ITEM_ID,
                C.CAPITAL_ACCOUNT_ID ,
                EI.EXPENSE_ITEM_NAME,
                EI.ACCOUNT_CODE
            FROM
                CREDIT_CONTRACT_ROW C
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = ISNULL(C.EXPENSE_ITEM_ID,ISNULL(C.TOTAL_EXPENSE_ITEM_ID,C.CAPITAL_EXPENSE_ITEM_ID))
            WHERE
                C.CREDIT_CONTRACT_ID = #url.credit_contract_id# AND
                C.CREDIT_CONTRACT_TYPE = 2 AND
                C.IS_PAID = 0
        </cfquery>
        <cfif len(get_credit_contract.project_id)> 
            <cfquery name="GET_PROJECT_HEAD" datasource="#DSN#">
                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_credit_contract.project_id#
            </cfquery>
        </cfif>
    </cfif>
    <cfif attributes.event eq 'add'>
    	<cfquery name="get_money" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# ORDER BY MONEY_ID
        </cfquery>
        <script type="text/javascript">
			$( document ).ready(function() {
				<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)>
					payment_row_count=<cfoutput>#get_rows_1.recordcount#</cfoutput>;
					revenue_row_count=<cfoutput>#get_rows_2.recordcount#</cfoutput>;
					payment_kontrol_row_count=<cfoutput>#get_rows_1.recordcount#</cfoutput>;
					revenue_kontrol_row_count=<cfoutput>#get_rows_2.recordcount#</cfoutput>;
					document.getElementById("payment_record_num").value = payment_row_count;
					document.getElementById("payment_record_num2").value = payment_row_count;
					document.getElementById("revenue_record_num").value = revenue_row_count;
				<cfelse>
					payment_row_count=0;
					revenue_row_count=0;
					payment_kontrol_row_count=0;
					revenue_kontrol_row_count=0;
				</cfif>
				write_total_amount(1);
				write_total_amount(2);
				gizle_finance();
			});
			
			function pencere_ac_date(no,type)
			{
				if(type == 1)
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_credit_contract.payment_date' + no ,'date');
				else
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_credit_contract.revenue_date' + no ,'date');
			}
			
			function add_row(type,payment_date,payment_capital_price,payment_interest_price,payment_tax_price,payment_total_price,payment_detail,total_payment_price,expense_center_id,expense_item_id,expense_item_name,interest_account_id,interest_account_code,total_expense_item_id,total_expense_item_name,capital_expense_item_id,capital_expense_item_name,capital_account_id,capital_account_code,total_account_id,total_account_code,borrow_id,borrow_code)
			{
				
				
				//Normal rken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
				if (payment_date == undefined)payment_date ="";
				if (payment_capital_price == undefined)payment_capital_price =0;
				if (payment_interest_price == undefined)payment_interest_price =0;
				if (payment_tax_price == undefined)payment_tax_price =0;
				if (payment_total_price == undefined)payment_total_price =0;
				if (payment_detail == undefined)payment_detail ="";
				if (total_payment_price == undefined)total_payment_price =0;
				if (expense_center_id == undefined)expense_center_id ="";
				if (expense_item_id == undefined)expense_item_id ="";
				if (expense_item_name == undefined)expense_item_name ="";
				if (interest_account_id == undefined)interest_account_id ="";
				if (interest_account_code == undefined)interest_account_code ="";
				if (total_expense_item_id == undefined)total_expense_item_id ="";
				if (total_expense_item_name == undefined)total_expense_item_name ="";
				if (total_account_id == undefined)total_account_id ="";
				if (total_account_code == undefined)total_account_code ="";
				if (borrow_id == undefined)borrow_id ="";
				if (borrow_code == undefined)borrow_code ="";
				if (capital_expense_item_id == undefined)capital_expense_item_id ="";
				if (capital_expense_item_name == undefined)capital_expense_item_name ="";
				if (capital_account_id == undefined)capital_account_id ="";
				if (capital_account_code == undefined)capital_account_code ="";
				
				if(type == 1)
				{
					
					var selected_ptype = document.getElementById("process_cat").options[document.getElementById('process_cat').selectedIndex].value;
					if(selected_ptype != '')
					{
						eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
						table2.style.display = '';
						payment_row_count++;	
						payment_kontrol_row_count++;
						var newRow;
						var newCell;
						newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
						newRow.setAttribute("name","payment_frm_row" + payment_row_count);
						newRow.setAttribute("id","payment_frm_row" + payment_row_count);		
						newRow.setAttribute("NAME","payment_frm_row" + payment_row_count);
						newRow.setAttribute("ID","payment_frm_row" + payment_row_count);		
						document.getElementById("payment_record_num").value=payment_row_count;
						document.getElementById('payment_record_num2').value=payment_row_count;
						
						document.getElementById('rowCount').value = parseInt(document.getElementById('rowCount').value) + 1;
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML =document.getElementById('rowCount').value;
						
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML =  ' <input  type="hidden" name="payment_row_kontrol' + payment_row_count +'" id="payment_row_kontrol' + payment_row_count +'" value="1"><a style="cursor:pointer" onclick="delete_row(' + payment_row_count + ',1);"><img  src="images/delete_list.gif" alt="Sil" border="0"></a><a style="cursor:pointer" onclick="open_row_add(1,' + payment_row_count + ');" title="Satır Çoğalt"><img  src="images/shema_list.gif" alt="Satır Çoğalt" border="0"></a><a style="cursor:pointer" onclick="copy_row(1,' + payment_row_count + ');" title="<cf_get_lang_main no='1560.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.setAttribute("id","payment_date" + payment_row_count + "_td");
						newCell.innerHTML = '<input type="hidden" name="payment_credit_contract_row_id' + payment_row_count +'" id="payment_credit_contract_row_id' + payment_row_count +'" value=""><input type="text" name="payment_date' + payment_row_count +'" id="payment_date' + payment_row_count +'" class="text" maxlength="10" style="width:65px;" alt="Sil" value="' + payment_date + '"> ';
						wrk_date_image('payment_date' + payment_row_count);
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<input type="text" name="payment_capital_price' + payment_row_count +'" id="payment_capital_price' + payment_row_count +'" maxlength="20" onchange="payment_capital_price_amount('+payment_row_count+');" value="'+payment_capital_price+'" value="" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(1);" class="moneybox" style="width:80px;">';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<input type="text" name="payment_interest_price' + payment_row_count +'" id="payment_interest_price' + payment_row_count +'" onchange="payment_interest_price_amount('+payment_row_count+');" value="'+payment_interest_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(1);" class="moneybox" style="width:80px;">';
						if(proc_control == 296)
						{
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="total_payment_price' + payment_row_count +'" id="total_payment_price' + payment_row_count +'" value="'+total_payment_price+'" readonly class="moneybox" style="width:80px;">';
						}
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<input type="text" name="payment_tax_price' + payment_row_count +'" id="payment_tax_price' + payment_row_count +'" onchange="payment_tax_price_amount('+payment_row_count+');" value="'+payment_tax_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(1);" class="moneybox" style="width:80px;">';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML = '<input type="text" name="payment_total_price' + payment_row_count +'" id="payment_total_price' + payment_row_count +'" value="'+payment_total_price+'" class="moneybox" readonly style="width:80px;">';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<input type="text" name="payment_detail' + payment_row_count +'" id="payment_detail' + payment_row_count +'" value="'+payment_detail+'" maxlength="100" style="width:100px;">';
						newCell = newRow.insertCell(newRow.cells.length);
						a = '<select name="expense_center_id' + payment_row_count  +'" id="expense_center_id' + payment_row_count  +'" style="width:125px;" class="text"><option value="">M. Merkezi</option>';
						<cfoutput query="get_expense_center">
						if('#expense_id#' == expense_center_id)
							a += '<option value="#expense_id#" selected>#expense#</option>';
						else
							a += '<option value="#expense_id#">#expense#</option>';
						</cfoutput>
						newCell.innerHTML =a+ '</select>';
						if(proc_control != 296)
						{
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input  type="hidden" name="capital_expense_item_id' + payment_row_count +'" id="capital_expense_item_id' + payment_row_count +'" value="'+capital_expense_item_id+'"><input type="text" name="capital_expense_item_name' + payment_row_count +'" id="capital_expense_item_name' + payment_row_count +'" readonly="yes" style="width:100px;" value="'+capital_expense_item_name+'" class="text"><a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'capital_expense_item_id\',\'capital_expense_item_name\',\'capital_account_id\',\'capital_account_code\',\''+payment_row_count+'\')" align="absmiddle" border="0"></a>';
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input  type="hidden" name="capital_account_id' + payment_row_count +'" id="capital_account_id' + payment_row_count +'" value="'+capital_account_id+'"><input type="text" value="'+capital_account_code+'"  name="capital_account_code' + payment_row_count +'" id="capital_account_code' + payment_row_count +'" class="text" style="width:120px;"> <a href="javascript://" onClick="pencere_ac_acc(\'capital_account_id\',\'capital_account_code\',\''+payment_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
						}
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML = '<input  type="hidden" name="expense_item_id' + payment_row_count +'" id="expense_item_id' + payment_row_count +'" value="'+expense_item_id+'"><input type="text" onFocus="AutoComplete_Create(\'expense_item_name' + payment_row_count +'\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'GET_EXPENSE_ITEM\',\'0\',\'EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE\',\'expense_item_id' + payment_row_count +','+'expense_item_name'+payment_row_count+','+'interest_account_code'+payment_row_count+','+'interest_account_id'+payment_row_count+'\',\'add_credit_contract\',1);" style="width:100px;" value="'+expense_item_name+'" name="expense_item_name' + payment_row_count +'" id="expense_item_name' + payment_row_count +'" class="text"><a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'expense_item_id\',\'expense_item_name\',\'interest_account_id\',\'interest_account_code\',\''+payment_row_count+'\')" align="absmiddle" border="0"  id="expense_item_name2' + payment_row_count +'"></a>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML = '<input  type="hidden" name="interest_account_id' + payment_row_count +'" id="interest_account_id' + payment_row_count +'" value="'+interest_account_id+'"><input type="text" value="'+interest_account_code+'"  name="interest_account_code' + payment_row_count +'"  id="interest_account_code' + payment_row_count +'" class="text" style="width:100px;"> <a href="javascript://" onClick="pencere_ac_acc(\'interest_account_id\',\'interest_account_code\',\''+payment_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="interest_account_code2' + payment_row_count +'"></a>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML = '<input  type="hidden" name="total_expense_item_id' + payment_row_count +'" id="total_expense_item_id' + payment_row_count +'" value="'+total_expense_item_id+'"><input type="text" name="total_expense_item_name' + payment_row_count +'" onFocus="AutoComplete_Create(\'total_expense_item_name' + payment_row_count +'\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'GET_EXPENSE_ITEM\',\'0\',\'EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE\',\'total_expense_item_id' + payment_row_count +','+'total_expense_item_name'+payment_row_count+','+'total_account_code'+payment_row_count+','+'total_account_id'+payment_row_count+'\',\'add_credit_contract\',1);" id="total_expense_item_name' + payment_row_count +'"  style="width:170px;" value="'+total_expense_item_name+'" class="text"><a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'total_expense_item_id\',\'total_expense_item_name\',\'total_account_id\',\'total_account_code\',\''+payment_row_count+'\')" align="absmiddle" border="0"  id="expense_item_name2' + payment_row_count +'"></a>';
						
						
						newCell = newRow.insertCell(newRow.cells.length);
								newCell.setAttribute('nowrap','nowrap');
								newCell.innerHTML = '<input  type="hidden" name="total_account_id' + payment_row_count +'" id="total_account_id' + payment_row_count +'" value="'+total_account_id+'"><input type="text" value="'+total_account_code+'"  name="total_account_code' + payment_row_count +'" id="total_account_code' + payment_row_count +'" class="text" style="width:170px;"> <a href="javascript://" onClick="pencere_ac_acc(\'total_account_id\',\'total_account_code\',\''+payment_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="total_account_code2' + payment_row_count +'"></a>';
						if(proc_control == 296){
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input  type="hidden" name="borrow_id' + payment_row_count +'" id="borrow_id' + payment_row_count +'" value="'+borrow_id+'"><input type="text" value="'+borrow_code+'"  name="borrow_code' + payment_row_count +'" onFocus="AutoComplete_Create(\'borrow_code' + payment_row_count +'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'CODE_NAME\',\'get_account_code\',\'0\',\'ACCOUNT_CODE,CODE_NAME\',\'borrow_id' + payment_row_count +','+'borrow_code'+payment_row_count+'\',\'add_credit_contract\',1);" id="borrow_code' + payment_row_count +'" class="text" style="width:170px;"> <a href="javascript://"  onClick="pencere_ac_acc(\'borrow_id\',\'borrow_code\',\''+payment_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="total_account_code2' + payment_row_count +'"></a>';
						}
						write_total_amount(1);
					}
					else
						alert("<cf_get_lang no ='71.Önce İşlem Tipi Seçmelisiniz'> !");
				}
				else
				{
					
					var selected_ptype = document.getElementById("process_cat").options[document.getElementById('process_cat').selectedIndex].value;
					if(selected_ptype != '')
					{
						eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
						table4.style.display = '';
						revenue_row_count++;	
						revenue_kontrol_row_count++;
						var newRow;
						var newCell;
						newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);	
						newRow.setAttribute("name","revenue_frm_row" + revenue_row_count);
						newRow.setAttribute("id","revenue_frm_row" + revenue_row_count);		
						newRow.setAttribute("NAME","revenue_frm_row" + revenue_row_count);
						newRow.setAttribute("ID","revenue_frm_row" + revenue_row_count);		
						document.getElementById('revenue_record_num').value=revenue_row_count;
						document.getElementById('rowCount_2').value = parseInt(document.getElementById('rowCount_2').value) + 1;
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML =document.getElementById('rowCount_2').value;
						
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						//document.getElementById('rowCount_2').value = parseInt(document.getElementById('rowCount_2').value) + 1;
						newCell.innerHTML ='<input  type="hidden" name="revenue_row_kontrol' + revenue_row_count +'" id="revenue_row_kontrol' + revenue_row_count +'" value="1"><a style="cursor:pointer" onclick="delete_row(' + revenue_row_count + ',2);"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="open_row_add(2,' + revenue_row_count + ');" title="Satır Çoğalt"><img  src="images/shema_list.gif" alt="Satır Çoğalt" border="0"></a><a style="cursor:pointer" onclick="copy_row(2,' + revenue_row_count + ');" title="<cf_get_lang_main no='1560.Satır Kopyala'>"><img  src="images/copy_list.gif" alt="<cf_get_lang_main no='1560.Satır Kopyala'>" border="0"></a>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.setAttribute("id","revenue_date" + revenue_row_count + "_td");
						newCell.innerHTML = '<input type="hidden" name="revenue_credit_contract_row_id' + revenue_row_count +'" id="revenue_credit_contract_row_id' + revenue_row_count +'" value=""><input type="hidden" name="payment_credit_contract_row_id' + revenue_row_count +'" id="payment_credit_contract_row_id' + revenue_row_count +'" value=""><input type="text" name="revenue_date' + revenue_row_count +'" id="revenue_date' + revenue_row_count +'" class="text" maxlength="10" style="width:65px;" value="' + payment_date + '">';
						wrk_date_image('revenue_date' + revenue_row_count);
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML ='<input type="text" name="revenue_capital_price' + revenue_row_count +'" id="revenue_capital_price' + revenue_row_count +'" maxlength="20" value="'+payment_capital_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(2);" class="moneybox" style="width:80px;">';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML ='<input type="text" name="revenue_interest_price' + revenue_row_count +'" id="revenue_interest_price' + revenue_row_count +'"  value="'+payment_interest_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(2);" class="moneybox" style="width:80px;">';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML ='<input type="text" name="revenue_tax_price' + revenue_row_count +'" id="revenue_tax_price' + revenue_row_count +'" value="'+payment_tax_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(2);" class="moneybox" style="width:80px;">';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML ='<input type="text" name="revenue_total_price' + revenue_row_count +'" id="revenue_total_price' + revenue_row_count +'"  value="'+payment_total_price+'" class="moneybox" readonly style="width:80px;">';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<input type="text" name="revenue_detail' + revenue_row_count +'" id="revenue_detail' + revenue_row_count +'"  value="'+payment_detail+'"  maxlength="100" style="width:100px;">';
						if(proc_control != 296)
						{
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							a = '<select name="revenue_expense_center_id' + revenue_row_count  +'" id="revenue_expense_center_id' + revenue_row_count  +'" style="width:125px;" class="text"><option value="">M. Merkezi</option>';
							<cfoutput query="get_expense_center">
							if('#expense_id#' == expense_center_id)
								a += '<option value="#expense_id#" selected>#expense#</option>';
							else
								a += '<option value="#expense_id#">#expense#</option>';
							</cfoutput>
							newCell.innerHTML =a+ '</select>';
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML = '<input  type="hidden" name="revenue_capital_expense_item_id' + revenue_row_count +'" id="revenue_capital_expense_item_id' + revenue_row_count +'" value="'+capital_expense_item_id+'"><input type="text" name="revenue_capital_expense_item_name' + revenue_row_count +'" id="revenue_capital_expense_item_name' + revenue_row_count +'" readonly="yes" style="width:125px;" value="'+capital_expense_item_name+'" class="text"> <a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'revenue_capital_expense_item_id\',\'revenue_capital_expense_item_name\',\'revenue_capital_account_id\',\'revenue_capital_account_code\',\''+revenue_row_count+'\')" align="absmiddle" border="0"></a>';
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML = '<input  type="hidden" name="revenue_capital_account_id' + revenue_row_count +'" id="revenue_capital_account_id' + revenue_row_count +'" value="'+capital_account_id+'"><input type="text" value="'+capital_account_code+'" name="revenue_capital_account_code' + revenue_row_count +'" id="revenue_capital_account_code' + revenue_row_count +'" class="text" style="width:125px;"> <a href="javascript://" onClick="pencere_ac_acc(\'revenue_capital_account_id\',\'revenue_capital_account_code\',\''+revenue_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML = '<input  type="hidden" name="revenue_expense_item_id' + revenue_row_count +'" id="revenue_expense_item_id' + revenue_row_count +'" value="'+expense_item_id+'"><input type="text" readonly="yes" style="width:110px;" name="revenue_expense_item_name' + revenue_row_count +'" id="revenue_expense_item_name' + revenue_row_count +'" value="'+expense_item_name+'" class="text"> <a href="javascript://"><img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'revenue_expense_item_id\',\'revenue_expense_item_name\',\'revenue_interest_account_id\',\'revenue_interest_account_code\',\''+revenue_row_count+'\')" align="absmiddle" border="0"  id="expense_item_name2' + revenue_row_count +'"></a>';
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML = '<input  type="hidden" name="revenue_interest_account_id' + revenue_row_count +'" id="revenue_interest_account_id' + revenue_row_count +'" value="'+interest_account_id+'"><input type="text" value="'+interest_account_code+'" name="revenue_interest_account_code' + revenue_row_count +'" id="revenue_interest_account_code' + revenue_row_count +'" class="text" style="width:110px;"> <a href="javascript://" onClick="pencere_ac_acc(\'revenue_interest_account_id\',\'revenue_interest_account_code\',\''+revenue_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="interest_account_code2' + revenue_row_count +'"></a>';
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML = '<input  type="hidden" name="revenue_total_expense_item_id' + revenue_row_count +'" id="revenue_total_expense_item_id' + revenue_row_count +'" value="'+total_expense_item_id+'"><input type="text" name="revenue_total_expense_item_name' + revenue_row_count +'" id="revenue_total_expense_item_name' + revenue_row_count +'" readonly="yes" style="width:170px;" value="'+total_expense_item_name+'" class="text"> <a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'revenue_total_expense_item_id\',\'revenue_total_expense_item_name\',\'revenue_total_account_id\',\'revenue_total_account_code\',\''+revenue_row_count+'\')" align="absmiddle" border="0"  id="expense_item_name2' + revenue_row_count +'"></a>';
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML = '<input  type="hidden" name="revenue_total_account_id' + revenue_row_count +'" id="revenue_total_account_id' + revenue_row_count +'" value="'+total_account_id+'"><input type="text" value="'+total_account_code+'"  name="revenue_total_account_code' + revenue_row_count +'" id="revenue_total_account_code' + revenue_row_count +'" class="text" style="width:170px;"> <a href="javascript://" onClick="pencere_ac_acc(\'revenue_total_account_id\',\'revenue_total_account_code\',\''+revenue_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="total_account_code2' + revenue_row_count +'"></a>';
						}
						write_total_amount(2);
					}
					else
						alert("<cf_get_lang dictionary_id='51403.Önce İşlem Tipi Seçmelisiniz'>");
				}
			}
			function copy_row(type,no)
			{
				var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
				eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
				if(type == 1)
				{
					payment_date = document.getElementById('payment_date' + no).value;
					payment_capital_price = document.getElementById('payment_capital_price' + no).value;
					payment_interest_price = document.getElementById('payment_interest_price' + no).value;
					payment_tax_price = document.getElementById('payment_tax_price' + no).value;
					payment_total_price = document.getElementById('payment_total_price' + no).value;
					payment_detail = document.getElementById('payment_detail' + no).value;
					expense_center_id = document.getElementById('expense_center_id' + no).value;
					expense_item_id = document.getElementById('expense_item_id' + no).value;
					expense_item_name = document.getElementById('expense_item_name' + no).value;
					interest_account_id = document.getElementById('interest_account_id' + no).value;
					interest_account_code = document.getElementById('interest_account_code' + no).value;
					total_expense_item_id = document.getElementById('total_expense_item_id' + no).value;
					total_expense_item_name = document.getElementById('total_expense_item_name' + no).value;
					total_account_id = document.getElementById('total_account_id' + no).value;
					total_account_code = document.getElementById('total_account_code' + no).value;
					if(proc_control == 296)
					{
						total_payment_price = document.getElementById('total_payment_price' + no).value;				
						capital_expense_item_id = '';
						capital_expense_item_name = '';
						capital_account_id = '';
						capital_account_code = '';
					}
					else
					{
						total_payment_price = '';
						capital_expense_item_id = document.getElementById('capital_expense_item_id' + no).value;
						capital_expense_item_name = document.getElementById('capital_expense_item_name' + no).value;
						capital_account_id = document.getElementById('capital_account_id' + no).value;
						capital_account_code = document.getElementById('capital_account_code' + no).value;
					}
				}
				else
				{
					payment_date = document.getElementById('revenue_date' + no).value;
					payment_capital_price = document.getElementById('revenue_capital_price' + no).value;
					payment_interest_price = document.getElementById('revenue_interest_price' + no).value;
					payment_tax_price = document.getElementById('revenue_tax_price' + no).value;
					payment_total_price = document.getElementById('revenue_total_price' + no).value;
					payment_detail = document.getElementById('revenue_detail' + no).value;
					if(proc_control != 296)
					{	
						total_payment_price = '';
						expense_center_id = document.getElementById('revenue_expense_center_id' + no).value;
						expense_item_id = document.getElementById('revenue_expense_item_id' + no).value;
						expense_item_name = document.getElementById('revenue_expense_item_name' + no).value;
						interest_account_id = document.getElementById('revenue_interest_account_id' + no).value;
						interest_account_code = document.getElementById('revenue_interest_account_code' + no).value;
						total_expense_item_id = document.getElementById('revenue_total_expense_item_id' + no).value;
						total_expense_item_name = document.getElementById('revenue_total_expense_item_name' + no).value;
						total_account_id = document.getElementById('revenue_total_account_id' + no).value;
						total_account_code = document.getElementById('revenue_total_account_code' + no).value;
						capital_expense_item_id = document.getElementById('revenue_capital_expense_item_id' + no).value;
						capital_expense_item_name = document.getElementById('revenue_capital_expense_item_name' + no).value;
						capital_account_id = document.getElementById('revenue_capital_account_id' + no).value;
						capital_account_code = document.getElementById('revenue_capital_account_code' + no).value;	
					}
					else
					{
						total_payment_price = '';
						expense_center_id = '';
						expense_item_id = '';
						expense_item_name = '';
						interest_account_id = '';
						interest_account_code = '';
						total_expense_item_id = '';
						total_expense_item_name = '';
						total_account_id = '';
						total_account_code = '';
						capital_expense_item_id = '';
						capital_expense_item_name = '';
						capital_account_id = '';
						capital_account_code = '';
					}
				}
				add_row(type,payment_date,payment_capital_price,payment_interest_price,payment_tax_price,payment_total_price,payment_detail,total_payment_price,expense_center_id,expense_item_id,expense_item_name,interest_account_id,interest_account_code,total_expense_item_id,total_expense_item_name,total_account_id,total_account_code,capital_expense_item_id,capital_expense_item_name,capital_account_id,capital_account_code);
			}
			function delete_row(sy,type)
			{
				if(type == 1)
				{
					document.getElementById('rowCount').value  = parseInt(document.getElementById('rowCount').value) - 1;
					document.getElementById('payment_record_num2').value--;		
					var my_element=eval("add_credit_contract.payment_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("payment_frm_row"+sy);
					my_element.style.display="none";
					payment_kontrol_row_count--;
					if(payment_kontrol_row_count <= 0)
						table2.style.display = 'none';
					else
						write_total_amount(1);
				}
				else
				{
					document.getElementById('rowCount_2').value  = parseInt(document.getElementById('rowCount_2').value) - 1;
					var my_element=eval("add_credit_contract.revenue_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("revenue_frm_row"+sy);
					my_element.style.display="none";
					revenue_kontrol_row_count--;
					if(revenue_kontrol_row_count <= 0)
						table4.style.display = 'none';
					else
						write_total_amount(2);	
				}
			}
			function kontrol()
			{
				if (!chk_process_cat('add_credit_contract')) return false;
				var get_process_cat_account = wrk_safe_query('crd_get_process_cat','dsn3',0,document.getElementById('process_cat').value);
				if(get_process_cat_account.IS_ACCOUNT == 1 && document.getElementById('credit_date').value != "")
					if(!chk_period(add_credit_contract.credit_date,"İşlem")) return false;
					
				if(!check_display_files('add_credit_contract')) return false;
				<cfif is_same_limit_currency eq 1>
					if(document.getElementById('credit_limit_id').value != '')
					{
						var get_credit_all = wrk_safe_query('crd_get_crd_all','dsn3',0,document.getElementById('credit_limit_id').value);
						for(var i=1;i<=<cfoutput>#get_money.recordcount#</cfoutput>;i++)
						{
							if(eval('add_credit_contract.rd_money['+(i-1)+'].checked'))
							{
								if(get_credit_all.MONEY_TYPE != document.getElementById('hidden_rd_money_'+i).value)
								{
									alert("<cf_get_lang dictionary_id='54536.Kredi Limiti İle Kredi Sözleşmesinin Para Birimi Aynı Olmalı'>");
									return false;
								}
							}
						}
					}
				</cfif>
				<cfif is_company_required eq 1>
					if(document.getElementById('company').value=='')	
					{
						alert("<cf_get_lang no='16.Lütfen Kredi Kurumu Seçiniz'>! ");
						return false;
					}
				</cfif>
				x=(100 - document.getElementById('detail').value.length);
				if(x < 0)
				{ 
					alert ("<cf_get_lang_main no='217.Açıklama'><cf_get_lang_main no='1712.En Fazla 100 Karakter Giriniz'><cf_get_lang_main no='1687.Fazla Karakter Sayısı'>:"+ ((-1) * x));
					return false;
				}
				var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
				eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
				if(proc_control == 296)
				{
					if(document.getElementById('action_account_code').value=='')
					{
						alert("<cf_get_lang no ='72.Lütfen Finansal Kiralama Muhasebe Kodu Seçiniz'> !");
						return false;
					}
				}
				// Satir kontrolleri odeme
				for(r=1;r<=add_credit_contract.payment_record_num.value;r++)
				{
					deger_row_kontrol = document.getElementById("payment_row_kontrol"+r);
					deger_date = document.getElementById("payment_date"+r);
					deger_capital_price = document.getElementById("payment_capital_price"+r);
					deger_expense = document.getElementById("expense_item_name"+r);
					deger_total_expense = document.getElementById("total_expense_item_name"+r);
					deger_interest_account_code = document.getElementById("interest_account_code"+r);
					deger_interest_value = document.getElementById("payment_interest_price"+r);
					deger_total_account_code = document.getElementById("total_account_code"+r);
					if(deger_row_kontrol.value == 1)
					{
						if(deger_date.value == "")
						{
							alert("<cf_get_lang no='40.Lütfen Ödeme Tarihi Giriniz'> ! ");
							return false;
						}
						if(deger_capital_price.value == "")
						{
							alert("<cf_get_lang no='20.Ana Para Tutarı Giriniz'> ! ");
							return false;
						}
						if(proc_control == 296)
						{
							if(deger_expense.value=='')
							{
								alert("<cf_get_lang no ='52.Lütfen Faiz Gider Kalemi Seçiniz'> !");
								return false;
							}
							if(filterNum(deger_interest_value.value) > 0 && deger_interest_account_code.value=='')
							{
								alert("<cf_get_lang no ='73.Lütfen Faiz Muhasebe Kodu Seçiniz'> !");
								return false;
							}
							if(deger_total_expense.value=='')
							{
								alert("<cf_get_lang no ='74.Lütfen Kira Gider Kalemi Seçiniz '>!");
								return false;
							}
							if(deger_total_account_code.value=='')
							{
								alert("<cf_get_lang no ='75.Lütfen Kira Muhasebe Kodu Seçiniz'> !");
								return false;
							}
						}
					}
				}
				// Satir kontrolleri tahsilat
				for(k=1;k<=add_credit_contract.revenue_record_num.value;k++)
				{
					deger_row_kontrol = document.getElementById("revenue_row_kontrol"+k);
					deger_date = document.getElementById("revenue_date"+k);
					deger_capital_price = document.getElementById("revenue_capital_price"+k);
					if(deger_row_kontrol.value == 1)
					{
						if(deger_date.value == "")
						{
							alert("<cf_get_lang no='34.Lütfen Tahsilat Tarihi Giriniz'>!");
							return false;
						}
						if(deger_capital_price.value == "")
						{
							alert("<cf_get_lang no='20.Ana Para Tutarı Giriniz'> ! ");
							return false;
						}
					}
				}
				unformat_fields();
				return true;
			}
		
			function write_total_amount(type,type2)
			{
				if(type == 1)
				{
					var payment_total_capital_price = 0;
					var payment_total_interest_price = 0;
					var payment_total_tax_price = 0;
					var payment_total_price = 0;
		
					for (var i=1; i <= add_credit_contract.payment_record_num.value; i++)
					{
						var payment_row_total_price = 0;
						deger_row_kontrol = document.getElementById("payment_row_kontrol"+i);
						if(deger_row_kontrol.value == 1)
						{
							if(type2 == undefined)
							{
								payment_total_capital_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
								payment_total_interest_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
								payment_total_tax_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value));
								if(document.getElementById('payment_capital_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
								if(document.getElementById('payment_interest_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
								if(document.getElementById("total_payment_price"+i) != undefined)
									document.getElementById("total_payment_price"+i).value = commaSplit(payment_row_total_price);
								if(document.getElementById('payment_tax_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value));
								document.getElementById("payment_total_price"+i).value = commaSplit(payment_row_total_price);
								payment_total_price += parseFloat(payment_row_total_price);
							}
							else
							{
								payment_total_capital_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
								payment_total_interest_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
								if(document.getElementById('payment_capital_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
								if(document.getElementById('payment_interest_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
								if(document.getElementById("total_payment_price"+i) != undefined)
									document.getElementById("total_payment_price"+i).value = commaSplit(payment_row_total_price);
								document.getElementById("payment_tax_price"+i).value = parseFloat(filterNum(document.getElementById("payment_total_price"+i).value)-filterNum(document.getElementById("payment_capital_price"+i).value)-filterNum(document.getElementById("payment_interest_price"+i).value));
								payment_total_tax_price += filterNum(document.getElementById('payment_tax_price'+i).value);
								if(document.getElementById('payment_tax_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value));
								payment_total_price += parseFloat(payment_row_total_price);
							}	
						}
					}
					document.getElementById('payment_total_capital_price').value = commaSplit(payment_total_capital_price);
					document.getElementById('payment_total_interest_price').value = commaSplit(payment_total_interest_price);
					document.getElementById('payment_total_tax_price').value = commaSplit(payment_total_tax_price);
					document.getElementById('payment_total_price').value = commaSplit(payment_total_price);
					document.getElementById('total_payment').value = commaSplit(payment_total_price);
					document.getElementById('payment_total_price_kdvsiz').value = commaSplit(payment_total_price-payment_total_tax_price);
				}
				else
				{
					var revenue_total_capital_price = 0;
					var revenue_total_interest_price = 0;
					var revenue_total_tax_price = 0;
					var revenue_total_price = 0;
					for (var i=1; i <= add_credit_contract.revenue_record_num.value; i++)
					{
						deger_row_kontrol = document.getElementById("revenue_row_kontrol"+i);
						if(deger_row_kontrol.value == 1)
						{
							var revenue_row_total_price = 0;
							revenue_total_capital_price += parseFloat(filterNum(document.getElementById('revenue_capital_price'+i).value));
							revenue_total_interest_price += parseFloat(filterNum(document.getElementById('revenue_interest_price'+i).value));
							revenue_total_tax_price += parseFloat(filterNum(document.getElementById('revenue_tax_price'+i).value));
							if(document.getElementById('revenue_capital_price'+i).value != "") revenue_row_total_price += parseFloat(filterNum(document.getElementById('revenue_capital_price'+i).value));
							if(document.getElementById('revenue_interest_price'+i).value != "") revenue_row_total_price += parseFloat(filterNum(document.getElementById('revenue_interest_price'+i).value));
							if(document.getElementById('revenue_tax_price'+i).value != "") revenue_row_total_price += parseFloat(filterNum(document.getElementById('revenue_tax_price'+i).value));
							document.getElementById("revenue_total_price"+i).value = commaSplit(revenue_row_total_price);
							revenue_total_price += parseFloat(revenue_row_total_price);
						}
					}
					document.getElementById('revenue_total_capital_price').value = commaSplit(revenue_total_capital_price);
					document.getElementById('revenue_total_interest_price').value = commaSplit(revenue_total_interest_price);
					document.getElementById('revenue_total_tax_price').value = commaSplit(revenue_total_tax_price);
					document.getElementById('revenue_total_price').value = commaSplit(revenue_total_price);
					document.getElementById('total_revenue').value = commaSplit(revenue_total_price);
				}
				f_kur_hesapla_multi();
			}
			function unformat_fields()
			{
				for(r=1; r<=document.getElementById('payment_record_num').value; r++)
				{
					if(document.getElementById("payment_row_kontrol"+r).value == 1)
					{
						document.getElementById("payment_capital_price"+r).value = filterNum(document.getElementById("payment_capital_price"+r).value);
						document.getElementById("payment_interest_price"+r).value = filterNum(document.getElementById("payment_interest_price"+r).value);
						document.getElementById("payment_tax_price"+r).value = filterNum(document.getElementById("payment_tax_price"+r).value);
						document.getElementById("payment_total_price"+r).value = filterNum(document.getElementById("payment_total_price"+r).value);
					}
				}
				for(r=1; r<=document.getElementById('revenue_record_num').value; r++)
				{
					if(document.getElementById("revenue_row_kontrol"+r).value == 1)
					{
						document.getElementById("revenue_capital_price"+r).value = filterNum(document.getElementById("revenue_capital_price"+r).value);
						document.getElementById("revenue_interest_price"+r).value = filterNum(document.getElementById("revenue_interest_price"+r).value);
						document.getElementById("revenue_tax_price"+r).value = filterNum(document.getElementById("revenue_tax_price"+r).value);
						document.getElementById("revenue_total_price"+r).value = filterNum(document.getElementById("revenue_total_price"+r).value);
					}
				}
				for(s=1; s<=document.getElementById('deger_get_money').value; s++)
				{
					document.getElementById('txt_rate2_' + s).value = filterNum(document.getElementById('txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
				document.getElementById('total_revenue').value = filterNum(document.getElementById('total_revenue').value);
				document.getElementById('other_total_revenue').value = filterNum(document.getElementById('other_total_revenue').value);
				document.getElementById('total_payment').value = filterNum(document.getElementById('total_payment').value);
				document.getElementById('other_total_payment').value = filterNum(document.getElementById('other_total_payment').value);
				document.getElementById("interest_rate").value = filterNum(document.getElementById("interest_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
			function f_kur_hesapla_multi()//sistem para birimi hesaplama
			{
				var system_cur_value;
				for(var i=1;i<=<cfoutput>#get_money.recordcount#</cfoutput>;i++)
				{
					if(document.add_credit_contract.rd_money[i-1].checked == true)
					{
						rate1_eleman = filterNum(document.getElementById('txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						rate2_eleman = filterNum(document.getElementById('txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						system_cur_value = filterNum(document.getElementById('revenue_total_price').value)*rate2_eleman/rate1_eleman;
						add_credit_contract.other_total_revenue.value = commaSplit(system_cur_value);
		
						system_cur_value = filterNum(document.getElementById('payment_total_price').value)*rate2_eleman/rate1_eleman;
						add_credit_contract.other_total_payment.value = commaSplit(system_cur_value);
						
						add_credit_contract.money_info_rev.value = eval('add_credit_contract.hidden_rd_money_'+i).value;
						add_credit_contract.money_info_pay.value = eval('add_credit_contract.hidden_rd_money_'+i).value;
					}
				}
			}
			function gizle_finance()
			{
				var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
				if(selected_ptype != '')
				{
					eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
					if(proc_control == 296)
					{
						finance5.style.display = 'none';
						finance6.style.display = 'none';
						finance7.style.display = '';
						finance8.style.display = '';
						finance9.style.display = '';
						finance10.style.display = 'none';
						finance11.style.display = 'none';
						finance12.style.display = 'none';
						finance13.style.display = 'none';
						finance14.style.display = 'none';
						credit_limit.style.display = 'none';
						
						credit5.style.display = 'none';
						credittable.style.display = 'none';
						baslik1.style.display = 'none';
						baslik2.style.display = 'none';
						baslik3.style.display = '';
					}
					else
					{
						
						finance5.style.display = '';
						finance6.style.display = '';
						finance7.style.display = 'none';
						finance8.style.display = 'none';
						finance9.style.display = 'none';
						finance10.style.display = '';
						finance11.style.display = '';
						finance12.style.display = '';
						finance13.style.display = '';
						finance14.style.display = '';
						credit_limit.style.display = '';
						credit5.style.display = '';
						credittable.style.display = 'none';
						baslik1.style.display = '';
						baslik2.style.display = '';
						baslik3.style.display = 'none';
					}
				}
				else
				{
					credittable.style.display = 'none';			
				}
			}
			//satir cogalt
			function open_row_add(type,row_number)
			{
				document.getElementById('add_multi_row').style.display='';
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=credit.popup_add_multi_credit_row&type='+ type +'&row_number='+ row_number,'add_multi_row',1);
			}
			//gider kalemleri popup
			function pencere_ac_items(input_id,input_name,input_acc_id,input_acc_code,row_number)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_credit_contract.'+input_id+row_number+'&field_name=add_credit_contract.'+input_name+row_number+'&field_account_no=add_credit_contract.'+input_acc_code+row_number+'&field_account_no2=add_credit_contract.'+input_acc_id+row_number+'','list');
			}
			//muhasebe kodlari popup
			function pencere_ac_acc(input_acc_id,input_acc_code,row_number)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_contract.'+input_acc_id+row_number+'&field_name=add_credit_contract.'+input_acc_code+row_number+'','list');
			}
			
		</script>
    </cfif>
   
     <cfif attributes.event eq 'det'>
     	<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
            SELECT
                *
            FROM
                SETUP_MONEY
            WHERE
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
        </cfquery>
        <!--- ödemeler --->
        <cfquery name="GET_PAYMENTS" datasource="#dsn3#">
            SELECT
                CR.CREDIT_CONTRACT_ROW_ID,
                CR.PROCESS_DATE,
                CR.PROCESS_TYPE,
                CR.IS_PAID,
                CR.IS_PAID_ROW,
                CR.CAPITAL_PRICE,
                CR.INTEREST_PRICE,
                CR.TAX_PRICE,
                CR.DELAY_PRICE,
                CR.TOTAL_PRICE,
                CR.OTHER_MONEY,
                CR.ACTION_ID,
                CR.PERIOD_ID,
                CR.OUR_COMPANY_ID,
                CR.DETAIL,
                EIP.EXPENSE_ID,
                EIP.CREDIT_CONTRACT_ROW_ID
            FROM
                CREDIT_CONTRACT_ROW CR
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEM_PLANS EIP ON EIP.CREDIT_CONTRACT_ROW_ID = CR.CREDIT_CONTRACT_ROW_ID
            WHERE
                CR.CREDIT_CONTRACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
                CR.CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> AND
                CR.IS_PAID = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
            UNION ALL
            SELECT
                CR.CREDIT_CONTRACT_ROW_ID,
                CR.PROCESS_DATE,
                CR.PROCESS_TYPE,
                CR.IS_PAID,
                CR.IS_PAID_ROW,
                CR.CAPITAL_PRICE,
                CR.INTEREST_PRICE,
                CR.TAX_PRICE,
                CR.DELAY_PRICE,
                CR.TOTAL_PRICE,
                CR.OTHER_MONEY,
                CR.ACTION_ID,
                CR.PERIOD_ID,
                CR.OUR_COMPANY_ID,
                CR.DETAIL,
                EIP.EXPENSE_ID,
                EIP.CREDIT_CONTRACT_ROW_ID
            FROM
                CREDIT_CONTRACT_ROW CR
                LEFT JOIN #dsn2_alias#.EXPENSE_ITEM_PLANS EIP ON EIP.CREDIT_CONTRACT_ROW_ID = CR.CREDIT_CONTRACT_ROW_ID
            WHERE
                CR.CREDIT_CONTRACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
                CR.CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> AND
                CR.IS_PAID = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
            ORDER BY
                PROCESS_DATE
        </cfquery>
        <!--- tahsilatlar --->
        <cfquery name="GET_REVENUE" datasource="#dsn3#">
            SELECT
                CREDIT_CONTRACT_ROW_ID,
                PROCESS_DATE,
                IS_PAID,
                IS_PAID_ROW,
                CAPITAL_PRICE,
                INTEREST_PRICE,
                TAX_PRICE,
                DELAY_PRICE,
                TOTAL_PRICE,
                OTHER_MONEY,
                ACTION_ID,
                PERIOD_ID,
                OUR_COMPANY_ID,
                DETAIL
            FROM
                CREDIT_CONTRACT_ROW
            WHERE
                CREDIT_CONTRACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2"> AND
                CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> AND
                IS_PAID = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
            UNION ALL
            SELECT
                CREDIT_CONTRACT_ROW_ID,
                PROCESS_DATE,
                IS_PAID,
                IS_PAID_ROW,
                CAPITAL_PRICE,
                INTEREST_PRICE,
                TAX_PRICE,
                DELAY_PRICE,
                TOTAL_PRICE,
                OTHER_MONEY,
                ACTION_ID,
                PERIOD_ID,
                OUR_COMPANY_ID,
                DETAIL
            FROM
                CREDIT_CONTRACT_ROW
            WHERE
                CREDIT_CONTRACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2"> AND
                CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> AND
                IS_PAID = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
            ORDER BY
                PROCESS_DATE
        </cfquery>
        <cfif len(get_credit_contract.credit_type)>
            <cfquery name="get_type" datasource="#dsn#">
                SELECT * FROM SETUP_CREDIT_TYPE WHERE CREDIT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_contract.credit_type#">
            </cfquery>
            <cfset credit_type = get_type.credit_type>
        <cfelse>
            <cfset credit_type = ''>
        </cfif>
        <cfquery name="GET_PROCESS_TYPE" datasource="#dsn3#">
            SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_contract.process_cat#">
        </cfquery>
         <cfif GET_PAYMENTS.recordcount>
			<cfoutput query="GET_PAYMENTS">
				<cfquery name="get_money" datasource="#dsn3#">
                    SELECT * FROM CREDIT_CONTRACT_MONEY WHERE MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_payments.other_money#"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
                </cfquery>
                <!--- 20130212 kredi sozlesmelerinde CREDIT_CONTRACT_PAYMENT_INCOME tablosundan, leasing'lerde ise EXPENSE_ITEM_PLANS tablosundan veriler alinir  --->
                <cfif len(get_payments.action_id)and get_credit_contract.process_type neq 296>
                    <cfquery name="GET_PERIOD" datasource="#DSN#">
                        SELECT
                            PERIOD_YEAR,
                            OUR_COMPANY_ID
                        FROM
                            SETUP_PERIOD
                        WHERE
                            PERIOD_ID = #get_payments.period_id# AND
                            OUR_COMPANY_ID = #get_payments.our_company_id#
                    </cfquery>
                    <cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
                    <cfquery name="get_payment_income" datasource="#temp_dsn#">
                        SELECT 
                            ISNULL(OTHER_TOTAL_PRICE,0) OTHER_TOTAL_PRICE,
                            OTHER_MONEY,
                            CAPITAL_PRICE,
                            INTEREST_PRICE,
                            TAX_PRICE,
                            DELAY_PRICE,
                            ACTION_CURRENCY_ID,
                            DETAIL
                        FROM
                            CREDIT_CONTRACT_PAYMENT_INCOME
                        WHERE
                            CREDIT_CONTRACT_PAYMENT_ID = #get_payments.action_id#
                    </cfquery>
                    <cfquery name="get_income_money_" datasource="#temp_dsn#">
                        SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME_MONEY WHERE ACTION_ID = #action_id# AND MONEY_TYPE = '#get_payment_income.OTHER_MONEY#'
                    </cfquery>
                    <cfquery name="get_income_money_2" datasource="#temp_dsn#">
                        SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME_MONEY WHERE ACTION_ID = #action_id# AND MONEY_TYPE = '#get_payment_income.ACTION_CURRENCY_ID#'
                    </cfquery>
                <cfelseif len(get_payments.action_id)>
                    <cfquery name="GET_PERIOD" datasource="#DSN#">
                        SELECT
                            PERIOD_YEAR,
                            OUR_COMPANY_ID
                        FROM
                            SETUP_PERIOD
                        WHERE
                            PERIOD_ID = #get_payments.period_id# AND
                            OUR_COMPANY_ID = #get_payments.our_company_id#
                    </cfquery>
                    <cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
                    <cfquery name="get_expense_" datasource="#temp_dsn#">
                        SELECT 
                            EXPENSE_ID
                        FROM
                            EXPENSE_ITEM_PLANS
                        WHERE
                            EXPENSE_ID = #get_payments.action_id#
                    </cfquery>
                    <cfif get_expense_.recordcount>
                        <cfquery name="get_payment_income" datasource="#temp_dsn#">
                            SELECT
                                SUM(OTHER_TOTAL_PRICE) OTHER_TOTAL_PRICE,
                                SUM(CAPITAL_PRICE) CAPITAL_PRICE,
                                SUM(INTEREST_PRICE) INTEREST_PRICE,
                                SUM(TAX_PRICE) TAX_PRICE,
                                SUM(DELAY_PRICE) DELAY_PRICE,
                                ACTION_CURRENCY_ID,
                                OTHER_MONEY,
                                DETAIL
                            FROM
                            (
                                SELECT 
                                    ISNULL(OTHER_MONEY_GROSS_TOTAL,0) OTHER_TOTAL_PRICE,
                                    MONEY_CURRENCY_ID ACTION_CURRENCY_ID,
                                    OTHER_MONEY_GROSS_TOTAL/(1+(CAST(KDV_RATE AS FLOAT)/100)) CAPITAL_PRICE,
                                    0 INTEREST_PRICE,
                                    0 TAX_PRICE,
                                    0 DELAY_PRICE,
                                    MONEY_CURRENCY_ID OTHER_MONEY,
                                    (SELECT CAST(DETAIL AS NVARCHAR) FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID) DETAIL
                                FROM
                                    EXPENSE_ITEMS_ROWS
                                WHERE
                                    EXPENSE_ID = #get_expense_.expense_id#
                                    AND IS_INTEREST = 0
                                UNION ALL
                                SELECT 
                                    ISNULL(OTHER_MONEY_GROSS_TOTAL,0) OTHER_TOTAL_PRICE,
                                    MONEY_CURRENCY_ID ACTION_CURRENCY_ID,
                                    0 CAPITAL_PRICE,
                                    OTHER_MONEY_GROSS_TOTAL/(1+(CAST(KDV_RATE AS FLOAT)/100)) INTEREST_PRICE,
                                    0 TAX_PRICE,
                                    0 DELAY_PRICE,
                                    MONEY_CURRENCY_ID OTHER_MONEY,
                                    (SELECT CAST(DETAIL AS NVARCHAR) FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID) DETAIL
                                FROM
                                    EXPENSE_ITEMS_ROWS
                                WHERE
                                    EXPENSE_ID = #get_expense_.expense_id#
                                    AND IS_INTEREST = 1
                            )T1
                            GROUP BY
                                ACTION_CURRENCY_ID,
                                OTHER_MONEY,
                                DETAIL
                        </cfquery>
                        <cfquery name="get_total_kdv" datasource="#temp_dsn#">
                            SELECT OTHER_MONEY_KDV FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = #get_expense_.expense_id#
                        </cfquery>
                        <cfset get_payment_income.TAX_PRICE = get_total_kdv.OTHER_MONEY_KDV>
                        <cfquery name="get_income_money_" datasource="#temp_dsn#">
                            SELECT * FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = #action_id# AND MONEY_TYPE = '#get_payment_income.OTHER_MONEY#'
                        </cfquery>
                        <cfquery name="get_income_money_2" datasource="#temp_dsn#">
                            SELECT * FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = #action_id# AND MONEY_TYPE = '#get_payment_income.ACTION_CURRENCY_ID#'
                        </cfquery>
                    <cfelse>
                        <cfset get_payment_income.recordcount = 0>
                    </cfif>
                </cfif>               
			</cfoutput>
		 </cfif>
         <cfif GET_REVENUE.recordcount>
         	<cfoutput query="GET_REVENUE">
				<cfquery name="get_money" datasource="#dsn3#">
					SELECT * FROM CREDIT_CONTRACT_MONEY WHERE MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_revenue.other_money#"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
				</cfquery>
				<cfif len(GET_REVENUE.action_id)>
					<cfquery name="GET_PERIOD" datasource="#DSN#">
						SELECT
							PERIOD_YEAR,
							OUR_COMPANY_ID
						FROM
							SETUP_PERIOD
						WHERE
							PERIOD_ID = #period_id# AND
							OUR_COMPANY_ID = #our_company_id#
					</cfquery>
					<cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
					<cfquery name="get_payment_revenue" datasource="#temp_dsn#">
						SELECT 
							ISNULL(OTHER_TOTAL_PRICE,0) OTHER_TOTAL_PRICE,
							OTHER_MONEY,
							CAPITAL_PRICE,
							INTEREST_PRICE,
							TAX_PRICE,
							DELAY_PRICE,
							ACTION_CURRENCY_ID,
							DETAIL
						FROM
							CREDIT_CONTRACT_PAYMENT_INCOME
						WHERE
							CREDIT_CONTRACT_PAYMENT_ID = #action_id#
					</cfquery>
					<cfquery name="get_payment_money" datasource="#temp_dsn#">
						SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME_MONEY WHERE ACTION_ID = #GET_REVENUE.action_id# AND MONEY_TYPE = '#get_payment_revenue.OTHER_MONEY#'
					</cfquery>
					<cfquery name="get_payment_money_2_" datasource="#temp_dsn#">
						SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME_MONEY WHERE ACTION_ID = #GET_REVENUE.action_id# AND MONEY_TYPE = '#get_payment_revenue.ACTION_CURRENCY_ID#'
					</cfquery>
				</cfif>
				<cfif IS_PAID eq 0>
					<cfset sozlesme_bakiye_ = TOTAL_PRICE>
					<cfset money_ = OTHER_MONEY>
				<cfelse>
					<cfif len(GET_REVENUE.action_id) and get_payment_revenue.recordcount>
						<cfset gerceklesen_bakiye_ = get_payment_revenue.OTHER_TOTAL_PRICE * get_payment_money.rate2>
						<cfset money_ = get_payment_money.MONEY_TYPE>
						<cfset money_rate2_ = get_payment_money.rate2>
						<cfset rate_ = (get_payment_money_2_.rate2/get_payment_money_2_.rate1)>
						<cfset rate_1 = (get_payment_money.rate1/get_payment_money.rate2)>
						<cfset gerceklesen_capital_price_ = wrk_round((get_payment_revenue.CAPITAL_PRICE * rate_) * rate_1,4)>
						<cfset gerceklesen_interest_price_ = wrk_round((get_payment_revenue.INTEREST_PRICE * rate_) * rate_1,4)>
						<cfset gerceklesen_tax_price_ = wrk_round((get_payment_revenue.TAX_PRICE * rate_) * rate_1,4)>
						<cfset gerceklesen_delay_price_ = wrk_round((get_payment_revenue.DELAY_PRICE * rate_) * rate_1,4)>
						<cfset detail_ = get_payment_revenue.detail>
					<cfelse>
						<cfset gerceklesen_bakiye_ = 0>
						<cfset money_ = ''>
						<cfset money_rate2_ = 1>
						<cfset rate_ = 1>
						<cfset rate_1 = 1>
						<cfset gerceklesen_capital_price_ = 0>
						<cfset gerceklesen_interest_price_ = 0>
						<cfset gerceklesen_tax_price_ = 0>
						<cfset gerceklesen_delay_price_ = 0>
						<cfset detail_ = ''>
					</cfif>
				</cfif>
			</cfoutput>
         </cfif>
     </cfif>
    <cfif attributes.event eq 'upd'>
    	<cfquery name="get_credit_contract_payment_income" datasource="#dsn2#">
            SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME WHERE CREDIT_CONTRACT_ROW_ID IN (SELECT CREDIT_CONTRACT_ROW_ID FROM #dsn3_alias#.CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ID = #url.credit_contract_id#)
        </cfquery>
        <cfquery name="get_credit_contract_income_control" datasource="#dsn2#"><!--- Gerceklesen satirlar olsumus ise sozlesme silinmemeli --->
            SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
        </cfquery>
        <cfquery name="GET_MONEY" datasource="#dsn3#">
            SELECT MONEY_TYPE AS MONEY,* FROM CREDIT_CONTRACT_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
        </cfquery>
        <cfif not GET_MONEY.recordcount>
            <cfquery name="GET_MONEY" datasource="#DSN#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS=1 ORDER BY MONEY_ID
            </cfquery>
        </cfif>
        <script type="text/javascript">
        	$( document ).ready(function() {
			    payment_row_count=<cfoutput>#get_rows_1.recordcount#</cfoutput>;
				revenue_row_count=<cfoutput>#get_rows_2.recordcount#</cfoutput>;
				payment_kontrol_row_count=<cfoutput>#get_rows_1.recordcount#</cfoutput>;
				revenue_kontrol_row_count=<cfoutput>#get_rows_2.recordcount#</cfoutput>;
				document.getElementById('payment_record_num').value=payment_row_count;
				document.getElementById('payment_record_num2').value=payment_row_count;
				document.getElementById('revenue_record_num').value=revenue_row_count;
				write_total_amount(1);
				write_total_amount(2);
			});
	
		function add_row(type,payment_date,payment_capital_price,payment_interest_price,payment_tax_price,payment_total_price,payment_detail,total_payment_price,expense_center_id,expense_item_id,expense_item_name,interest_account_id,interest_account_code,total_expense_item_id,total_expense_item_name,capital_expense_item_id,capital_expense_item_name,capital_account_id,capital_account_code,total_account_id,total_account_code,borrow_id,borrow_code)
	{
		
		//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
		if (payment_date == undefined)payment_date ="";
		if (payment_capital_price == undefined)payment_capital_price =0;
		if (payment_interest_price == undefined)payment_interest_price =0;
		if (payment_tax_price == undefined)payment_tax_price =0;
		if (payment_total_price == undefined)payment_total_price =0;
		if (payment_detail == undefined)payment_detail ="";
		if (total_payment_price == undefined)total_payment_price =0;
		if (expense_center_id == undefined)expense_center_id ="";
		if (expense_item_id == undefined)expense_item_id ="";
		if (expense_item_name == undefined)expense_item_name ="";
		if (interest_account_id == undefined)interest_account_id ="";
		if (interest_account_code == undefined)interest_account_code ="";
		if (total_expense_item_id == undefined)total_expense_item_id ="";
		if (total_expense_item_name == undefined)total_expense_item_name ="";
		if (capital_expense_item_id == undefined)capital_expense_item_id ="";
		if (capital_expense_item_name == undefined)capital_expense_item_name ="";
		if (capital_account_id == undefined)capital_account_id ="";
		if (capital_account_code == undefined)capital_account_code ="";
		if (total_account_id == undefined)total_account_id ="";
		if (total_account_code == undefined)total_account_code ="";
		if (borrow_id == undefined)borrow_id ="";
		if (borrow_code == undefined)borrow_code ="";
		
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
		/* odeme */
		if(type == 1)
		{
			if(selected_ptype != '')
			{
				h_ = parseInt(document.getElementById('kredi_sepet').style.height);
				document.getElementById('kredi_sepet').style.height = h_ + 25;
				table2.style.display = '';
				payment_row_count++;	
				payment_kontrol_row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
				newRow.setAttribute("name","payment_frm_row" + payment_row_count);
				newRow.setAttribute("id","payment_frm_row" + payment_row_count);		
				newRow.setAttribute("NAME","payment_frm_row" + payment_row_count);
				newRow.setAttribute("ID","payment_frm_row" + payment_row_count);		
				document.getElementById('payment_record_num').value=payment_row_count;
				document.getElementById('payment_record_num2').value=payment_row_count;
				document.getElementById('rowCount').value = parseInt(document.getElementById('rowCount').value) + 1;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML =document.getElementById('rowCount').value;

				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML =  ' <input  type="hidden" name="payment_row_kontrol' + payment_row_count +'" id="payment_row_kontrol' + payment_row_count +'" value="1"><a style="cursor:pointer" onclick="delete_row(' + payment_row_count + ',1);"><img  src="images/delete_list.gif" alt="Sil" border="0"></a><a style="cursor:pointer" onclick="open_row_add(1,' + payment_row_count + ');" title="Satır Çoğalt"> <img  src="images/shema_list.gif" alt="Satır Çoğalt" border="0"></a><a style="cursor:pointer" onclick="copy_row(1,' + payment_row_count + ');" title="Satır Kopyala">&nbsp;<img  src="images/copy_list.gif" alt="Satır Kopyalama" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","payment_date" + payment_row_count + "_td");
				newCell.innerHTML = '<input type="hidden" name="payment_credit_contract_row_id' + payment_row_count +'" id="payment_credit_contract_row_id' + payment_row_count +'" value=""><input type="text" name="payment_date' + payment_row_count +'" id="payment_date' + payment_row_count +'" class="text" maxlength="10" style="width:65px;" value="' + payment_date + '"> ';
				wrk_date_image('payment_date' + payment_row_count);
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="payment_capital_price' + payment_row_count +'" id="payment_capital_price' + payment_row_count +'" maxlength="20" onchange="payment_capital_price_amount('+payment_row_count+');" value="'+payment_capital_price+'" value="" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox" style="width:80px;">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="payment_interest_price' + payment_row_count +'" id="payment_interest_price' + payment_row_count +'" value="'+payment_interest_price+'" onchange="payment_interest_price_amount('+payment_row_count+');" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox" style="width:80px;">';
				if(proc_control == 296)
				{
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="text" name="total_payment_price' + payment_row_count +'" id="total_payment_price' + payment_row_count +'" value="'+total_payment_price+'" readonly class="moneybox" style="width:80px;">';
				}
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="payment_tax_price' + payment_row_count +'" id="payment_tax_price' + payment_row_count +'" onchange="payment_tax_price_amount('+payment_row_count+');" value="'+payment_tax_price+'" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox" style="width:80px;">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="payment_total_price' + payment_row_count +'" id="payment_total_price' + payment_row_count +'" value="'+payment_total_price+'" class="moneybox" readonly style="width:80px;">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="payment_detail' + payment_row_count +'" id="payment_detail' + payment_row_count +'" value="'+payment_detail+'" maxlength="100" style="width:100px;">';
				newCell = newRow.insertCell(newRow.cells.length);
				a = '<select name="expense_center_id' + payment_row_count  +'" id="expense_center_id' + payment_row_count  +'" style="width:90px;" class="text"><option value="">M. Merkezi</option>';
				<cfoutput query="get_expense_center">
				if('#expense_id#' == expense_center_id)
					a += '<option value="#expense_id#" selected>#expense#</option>';
				else
					a += '<option value="#expense_id#">#expense#</option>';
				</cfoutput>
				newCell.innerHTML =a+ '</select>';
				if(proc_control != 296)
				{
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input  type="hidden" name="capital_expense_item_id' + payment_row_count +'" id="capital_expense_item_id' + payment_row_count +'" value="'+capital_expense_item_id+'"><input type="text" name="capital_expense_item_name' + payment_row_count +'" id="capital_expense_item_name' + payment_row_count +'" readonly="yes" style="width:80px;" value="'+capital_expense_item_name+'" class="text"><a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'capital_expense_item_id\',\'capital_expense_item_name\',\'capital_account_id\',\'capital_account_code\',\''+payment_row_count+'\')" align="absmiddle" border="0"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input  type="hidden" name="capital_account_id' + payment_row_count +'" id="capital_account_id' + payment_row_count +'" value="'+capital_account_id+'"><input type="text" value="'+capital_account_code+'"  name="capital_account_code' + payment_row_count +'" id="capital_account_code' + payment_row_count +'" class="text" style="width:120px;"> <a href="javascript://" onClick="pencere_ac_acc(\'capital_account_id\',\'capital_account_code\',\''+payment_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				}
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="expense_item_id' + payment_row_count +'" id="expense_item_id' + payment_row_count +'" value="'+expense_item_id+'"><input type="text" onFocus="AutoComplete_Create(\'expense_item_name' + payment_row_count +'\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'GET_EXPENSE_ITEM\',\'0\',\'EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE\',\'expense_item_id' + payment_row_count +','+'expense_item_name'+payment_row_count+','+'interest_account_code'+payment_row_count+','+'interest_account_id'+payment_row_count+'\',\'add_credit_contract\',1);" style="width:80px;" value="'+expense_item_name+'" name="expense_item_name' + payment_row_count +'" id="expense_item_name' + payment_row_count +'" class="text"><a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'expense_item_id\',\'expense_item_name\',\'interest_account_id\',\'interest_account_code\',\''+payment_row_count+'\')" align="absmiddle" border="0"  id="expense_item_name2' + payment_row_count +'"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="interest_account_id' + payment_row_count +'" id="interest_account_id' + payment_row_count +'" value="'+interest_account_id+'"><input type="text" value="'+interest_account_code+'"  name="interest_account_code' + payment_row_count +'"  id="interest_account_code' + payment_row_count +'" class="text" style="width:80px;"> <a href="javascript://" onClick="pencere_ac_acc(\'interest_account_id\',\'interest_account_code\',\''+payment_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="interest_account_code2' + payment_row_count +'"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="total_expense_item_id' + payment_row_count +'" id="total_expense_item_id' + payment_row_count +'" value="'+total_expense_item_id+'"><input type="text" name="total_expense_item_name' + payment_row_count +'" onFocus="AutoComplete_Create(\'total_expense_item_name' + payment_row_count +'\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'GET_EXPENSE_ITEM\',\'0\',\'EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE\',\'total_expense_item_id' + payment_row_count +','+'total_expense_item_name'+payment_row_count+','+'total_account_code'+payment_row_count+','+'total_account_id'+payment_row_count+'\',\'add_credit_contract\',1);" id="total_expense_item_name' + payment_row_count +'" id="total_expense_item_name' + payment_row_count +'"  style="width:80px;" value="'+total_expense_item_name+'" class="text"><a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'total_expense_item_id\',\'total_expense_item_nam				e\',\'total_account_id\',\'total_account_code\',\''+payment_row_count+'\')" align="absmiddle" border="0"  id="expense_item_name2' + payment_row_count +'"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML = '<input  type="hidden" name="total_account_id' + payment_row_count +'" id="total_account_id' + payment_row_count +'" value="'+total_account_id+'"><input type="text" value="'+total_account_code+'"  name="total_account_code' + payment_row_count +'" id="total_account_code' + payment_row_count +'" class="text" style="width:170px;"> <a href="javascript://" onClick="pencere_ac_acc(\'total_account_id\',\'total_account_code\',\''+payment_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="total_account_code2' + payment_row_count +'"></a>';
				
				if(proc_control == 296){
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input  type="hidden" name="borrow_id' + payment_row_count +'"  id="borrow_id' + payment_row_count +'" value="'+borrow_id+'"><input type="text" value="'+borrow_code+'"  name="borrow_code' + payment_row_count +'" onFocus="AutoComplete_Create(\'borrow_code' + payment_row_count +'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'CODE_NAME\',\'get_account_code\',\'0\',\'ACCOUNT_CODE,CODE_NAME\',\'borrow_id' + payment_row_count +','+'borrow_code'+payment_row_count+'\',\'add_credit_contract\',1);" id="borrow_code' + payment_row_count +'" class="text" style="width:110px;"> <a href="javascript://"  onClick="pencere_ac_acc(\'borrow_id\',\'borrow_code\',\''+payment_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="total_account_code2' + payment_row_count +'"></a>';
				}
				write_total_amount(1);
			}
			else
				alert("<cf_get_lang dictionary_id='51403.Önce İşlem Tipi Seçmelisiniz'>");
		}
		else /* tahsilat */
		{
			table4.style.display = '';
			revenue_row_count++;	
			revenue_kontrol_row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);	
			newRow.setAttribute("name","revenue_frm_row" + revenue_row_count);
			newRow.setAttribute("id","revenue_frm_row" + revenue_row_count);		
			newRow.setAttribute("NAME","revenue_frm_row" + revenue_row_count);
			newRow.setAttribute("ID","revenue_frm_row" + revenue_row_count);		
			document.getElementById('revenue_record_num').value=revenue_row_count;
			document.getElementById('rowCount_2').value = parseInt(document.getElementById('rowCount_2').value) + 1;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML =document.getElementById('rowCount_2').value;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML =  '<div style=" float:right;"><input  type="hidden" name="revenue_row_kontrol' + revenue_row_count +'" id="revenue_row_kontrol' + revenue_row_count +'" value="1"><a style="cursor:pointer" onclick="delete_row(' + revenue_row_count + ',2);"  ><img  src="images/delete_list.gif" alt="Sil" border="0"></a><a style="cursor:pointer" onclick="open_row_add(2,' + revenue_row_count + ');" title="Satır Çoğalt"><img  src="images/shema_list.gif" alt="Satır Çoğalt" border="0"></a> <a style="cursor:pointer" onclick="copy_row(2,' + revenue_row_count + ');" title="Satır Kopyala"><img  src="images/copy_list.gif" alt="Satır Kopyalama" border="0"></a></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.setAttribute("style","text-align:right");
			newCell.setAttribute("id","revenue_date" + revenue_row_count + "_td");
			newCell.innerHTML = '<input type="hidden" name="revenue_credit_contract_row_id' + revenue_row_count +'" id="revenue_credit_contract_row_id' + revenue_row_count +'" value=""><input type="hidden" name="payment_credit_contract_row_id' + revenue_row_count +'" id="payment_credit_contract_row_id' + revenue_row_count +'" value=""><input type="text" name="revenue_date' + revenue_row_count +'" id="revenue_date' + revenue_row_count +'" class="text" maxlength="10" style="width:69px;float:right;" value="' + payment_date + '">';
			wrk_date_image('revenue_date' + revenue_row_count);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="revenue_capital_price' + revenue_row_count +'" id="revenue_capital_price' + revenue_row_count +'" maxlength="20" value="'+payment_capital_price+'" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);" class="moneybox" style="width:80px; float:right;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="revenue_interest_price' + revenue_row_count +'" id="revenue_interest_price' + revenue_row_count +'" value="'+payment_interest_price+'" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);" class="moneybox" style="width:80px; float:right;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="revenue_tax_price' + revenue_row_count +'" id="revenue_tax_price' + revenue_row_count +'" value="'+payment_tax_price+'" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);" class="moneybox" style="width:80px; float:right;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="revenue_total_price' + revenue_row_count +'" id="revenue_total_price' + revenue_row_count +'" value="'+payment_total_price+'" class="moneybox" readonly style="width:80px;float:right;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="revenue_detail' + revenue_row_count +'" id="revenue_detail' + revenue_row_count +'" value="'+payment_detail+'"  maxlength="100" style="width:100px;float:right;">';
			if(proc_control != 296)
			{
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				a = '<select name="revenue_expense_center_id' + revenue_row_count  +'" id="revenue_expense_center_id' + revenue_row_count  +'" style="width:90px;float:right;" class="text"><option value="">M. Merkezi</option>';
				<cfoutput query="get_expense_center">
				if('#expense_id#' == expense_center_id)
					a += '<option value="#expense_id#" selected>#expense#</option>';
				else
					a += '<option value="#expense_id#">#expense#</option>';
				</cfoutput>
				newCell.innerHTML =a+ '</select>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div style=" float:right;"><input  type="hidden" name="revenue_capital_expense_item_id' + revenue_row_count +'" id="revenue_capital_expense_item_id' + revenue_row_count +'" value="'+capital_expense_item_id+'"><input type="text" name="revenue_capital_expense_item_name' + revenue_row_count +'" id="revenue_capital_expense_item_name' + revenue_row_count +'" readonly="yes" style="width:80px;" value="'+capital_expense_item_name+'" class="text"><a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'revenue_capital_expense_item_id\',\'revenue_capital_expense_item_name\',\'revenue_capital_account_id\',\'revenue_capital_account_code\',\''+revenue_row_count+'\')" align="absmiddle" border="0"></a></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div style=" float:right;"><input  type="hidden" name="revenue_capital_account_id' + revenue_row_count +'" id="revenue_capital_account_id' + revenue_row_count +'" value="'+capital_account_id+'"><input type="text" value="'+capital_account_code+'" name="revenue_capital_account_code' + revenue_row_count +'" id="revenue_capital_account_code' + revenue_row_count +'" class="text" style="width:120px;"><a href="javascript://" onClick="pencere_ac_acc(\'revenue_capital_account_id\',\'revenue_capital_account_code\',\''+revenue_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div style=" float:right;"><input  type="hidden" name="revenue_expense_item_id' + revenue_row_count +'" id="revenue_expense_item_id' + revenue_row_count +'" value="'+expense_item_id+'"><input type="text" readonly="yes" style="width:80px;" name="revenue_expense_item_name' + revenue_row_count +'" id="revenue_expense_item_name' + revenue_row_count +'" value="'+expense_item_name+'" class="text"><a href="javascript://"><img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'revenue_expense_item_id\',\'revenue_expense_item_name\',\'revenue_interest_account_id\',\'revenue_interest_account_code\',\''+revenue_row_count+'\')" align="absmiddle" border="0"  id="expense_item_name2' + revenue_row_count +'"></a></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div style=" float:right;"><input  type="hidden" name="revenue_interest_account_id' + revenue_row_count +'" id="revenue_interest_account_id' + revenue_row_count +'" value="'+interest_account_id+'"><input type="text" value="'+interest_account_code+'" name="revenue_interest_account_code' + revenue_row_count +'" id="revenue_interest_account_code' + revenue_row_count +'" class="text" style="width:80px;"> <a href="javascript://" onClick="pencere_ac_acc(\'revenue_interest_account_id\',\'revenue_interest_account_code\',\''+revenue_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="interest_account_code2' + revenue_row_count +'"></a></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div style=" float:right;"><input  type="hidden" name="revenue_total_expense_item_id' + revenue_row_count +'" id="revenue_total_expense_item_id' + revenue_row_count +'" value="'+total_expense_item_id+'"><input type="text" name="revenue_total_expense_item_name' + revenue_row_count +'" id="revenue_total_expense_item_name' + revenue_row_count +'" readonly="yes" style="width:80px;" value="'+total_expense_item_name+'" class="text"><a href="javascript://"> <img src="/images/plus_thin.gif" onClick="pencere_ac_items(\'revenue_total_expense_item_id\',\'revenue_total_expense_item_name\',\'revenue_total_account_id\',\'revenue_total_account_code\',\''+revenue_row_count+'\')" align="absmiddle" border="0"  id="expense_item_name2' + revenue_row_count +'"></a></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div style=" float:right;"><input  type="hidden" name="revenue_total_account_id' + revenue_row_count +'" id="revenue_total_account_id' + revenue_row_count +'" value="'+total_account_id+'"><input type="text" value="'+total_account_code+'"  name="revenue_total_account_code' + revenue_row_count +'" id="revenue_total_account_code' + revenue_row_count +'" class="text" style="width:120px;"> <a href="javascript://" onClick="pencere_ac_acc(\'revenue_total_account_id\',\'revenue_total_account_code\',\''+revenue_row_count+'\')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" id="total_account_code2' + revenue_row_count +'"></a></div>';
			}
			write_total_amount(2);
		}
	}
	function copy_row(type,no)
	{
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
		
		if(type == 1)
		{ 
			payment_date = document.getElementById('payment_date' + no).value;
			payment_capital_price = document.getElementById('payment_capital_price' + no).value;
			payment_interest_price = document.getElementById('payment_interest_price' + no).value;
			payment_tax_price = document.getElementById('payment_tax_price' + no).value;
			payment_total_price = document.getElementById('payment_total_price' + no).value;
			payment_detail = document.getElementById('payment_detail' + no).value;
			expense_center_id = document.getElementById('expense_center_id' + no).value;
			expense_item_id = document.getElementById('expense_item_id' + no).value;
			expense_item_name = document.getElementById('expense_item_name' + no).value;
			interest_account_id = document.getElementById('interest_account_id' + no).value;
			interest_account_code = document.getElementById('interest_account_code' + no).value;
			total_expense_item_id = document.getElementById('total_expense_item_id' + no).value;
			total_expense_item_name = document.getElementById('total_expense_item_name' + no).value;
			total_account_id = document.getElementById('total_account_id' + no).value;
			total_account_code = document.getElementById('total_account_code' + no).value;
			if(document.getElementById('borrow_id'+no) != undefined || document.getElementById('borrow_code'+no) != undefined)
			{
			borrow_id = document.getElementById('borrow_id' + no).value;
			borrow_code = document.getElementById('borrow_code' + no).value;
			}
			else
			{
				borrow_id = '';
				borrow_code = '';
			}
			if(proc_control == 296)
			{
				total_payment_price = document.getElementById('total_payment_price' + no).value;				
				capital_expense_item_id = '';
				capital_expense_item_name = '';
				capital_account_id = '';
				capital_account_code = '';
			}
			else
			{
				total_payment_price = '';
				capital_expense_item_id = document.getElementById('capital_expense_item_id' + no).value;
				capital_expense_item_name = document.getElementById('capital_expense_item_name' + no).value;
				capital_account_id = document.getElementById('capital_account_id' + no).value;
				capital_account_code = document.getElementById('capital_account_code' + no).value;
			}
		}
		else
		{
			payment_date = document.getElementById('revenue_date' + no).value;
			payment_capital_price = document.getElementById('revenue_capital_price' + no).value;
			payment_interest_price = document.getElementById('revenue_interest_price' + no).value;
			payment_tax_price = document.getElementById('revenue_tax_price' + no).value;
			payment_total_price = document.getElementById('revenue_total_price' + no).value;
			payment_detail = document.getElementById('revenue_detail' + no).value;
			if(proc_control != 296)
			{	
				total_payment_price = '';
				expense_center_id = document.getElementById('revenue_expense_center_id' + no).value;
				expense_item_id = document.getElementById('revenue_expense_item_id' + no).value;
				expense_item_name = document.getElementById('revenue_expense_item_name' + no).value;
				interest_account_id = document.getElementById('revenue_interest_account_id' + no).value;
				interest_account_code = document.getElementById('revenue_interest_account_code' + no).value;
				total_expense_item_id = document.getElementById('revenue_total_expense_item_id' + no).value;
				total_expense_item_name = document.getElementById('revenue_total_expense_item_name' + no).value;
				total_account_id = document.getElementById('revenue_total_account_id' + no).value;
				total_account_code = document.getElementById('revenue_total_account_code' + no).value;

				capital_expense_item_id = document.getElementById('revenue_capital_expense_item_id' + no).value;
				capital_expense_item_name = document.getElementById('revenue_capital_expense_item_name' + no).value;
				capital_account_id = document.getElementById('revenue_capital_account_id' + no).value;
				capital_account_code = document.getElementById('revenue_capital_account_code' + no).value;	
			}
			else
			{
				total_payment_price = '';
				expense_center_id = '';
				expense_item_id = '';
				expense_item_name = '';
				interest_account_id = '';
				interest_account_code = '';
				total_expense_item_id = '';
				total_expense_item_name = '';
				total_account_id = '';
				total_account_code = '';
				capital_expense_item_id = '';
				capital_expense_item_name = '';
				capital_account_id = '';
				capital_account_code = '';
				borrow_id = '';
				borrow_code = '';
			}
		}
		add_row(type,payment_date,payment_capital_price,payment_interest_price,payment_tax_price,payment_total_price,payment_detail,total_payment_price,expense_center_id,expense_item_id,expense_item_name,interest_account_id,interest_account_code,total_expense_item_id,total_expense_item_name,capital_expense_item_id,capital_expense_item_name,capital_account_id,capital_account_code,total_account_id,total_account_code,borrow_id,borrow_code);
	}
	function delete_row(sy,type)
	{
		document.getElementById('rowCount').value  = parseInt(document.getElementById('rowCount').value) - 1;
		if(type == 1)
		{
			document.getElementById('payment_record_num2').value--;		
			var my_element=eval("add_credit_contract.payment_row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("payment_frm_row"+sy);
			my_element.style.display="none";
			payment_kontrol_row_count--;
			if(payment_kontrol_row_count <= 0)
				table2.style.display = 'none';
			else
				write_total_amount(1);
		}
		else
		{
			var my_element=eval("add_credit_contract.revenue_row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("revenue_frm_row"+sy);
			my_element.style.display="none";
			revenue_kontrol_row_count--;
			if(revenue_kontrol_row_count <= 0)
				table4.style.display = 'none';
			else
				write_total_amount(2);	
		}
	}
	function secim1()
	{
		if(document.getElementById('is_active').checked == false)
			document.getElementById('is_scenario').checked = false;
	}
	
	function kontrol()
	{
		control_account_process(<cfoutput>'#attributes.credit_contract_id#','#get_credit_contract.process_type#'</cfoutput>);
		if (!chk_process_cat('add_credit_contract')) return false; 
		var get_process_cat_account = wrk_safe_query('crd_get_process_cat','dsn3',0,document.getElementById('process_cat').value);
		if(get_process_cat_account.IS_ACCOUNT == 1 && document.getElementById('credit_date').value != "")
			if(!chk_period(add_credit_contract.credit_date,"İşlem")) return false;
	
		if(!check_display_files('add_credit_contract')) return false;
		<cfif is_same_limit_currency eq 1>
			if(document.getElementById('credit_limit_id').value != '')
			{
				var get_credit_all = wrk_safe_query('crd_get_crd_all','dsn3',0,document.getElementById('credit_limit_id').value);
				for(var i=1;i<=<cfoutput>#get_money.recordcount#</cfoutput>;i++)
				{
					if(eval('add_credit_contract.rd_money['+(i-1)+'].checked'))
					{
						if(get_credit_all.MONEY_TYPE != document.getElementById('hidden_rd_money_'+i).value)
						{
							alert("<cf_get_lang dictionary_id='54536.Kredi Limiti İle Kredi Sözleşmesinin Para Birimi Aynı Olmalı'>");
							return false;
						}
					}
				}
			}
		</cfif>
		<cfif is_company_required eq 1>
			if(document.getElementById('company_id').value=='')	
			{
				alert("<cf_get_lang no='16.Lütfen Kredi Kurumu Seçiniz'>! ");
				return false;
			}
		</cfif>
		x=(100 - document.getElementById('detail').value.length);
		if(x < 0)
		{ 
			alert ("<cf_get_lang_main no='217.Açıklama'><cf_get_lang_main no='1712.En Fazla 100 Karakter Giriniz'><cf_get_lang_main no='1687.Fazla Karakter Sayısı'>:"+ ((-1) * x));
			return false;
		}
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
		
		// Odeme satir kontrolleri
		for(r=1;r<=add_credit_contract.payment_record_num.value;r++)
		{
			deger_row_kontrol = document.getElementById("payment_row_kontrol"+r);
			deger_date = document.getElementById("payment_date"+r);
			deger_capital_price = document.getElementById("payment_capital_price"+r);
			deger_expense = document.getElementById("expense_item_name"+r);
			deger_total_expense = document.getElementById("total_expense_item_name"+r);
			deger_interest_account_code = document.getElementById("interest_account_code"+r);
			deger_interest_value = document.getElementById("payment_interest_price"+r);
			deger_total_account_code = document.getElementById("total_account_code"+r);
			if(proc_control == 296) {
			deger_borrow_code = document.getElementById("borrow_code"+r);
			}
			if(deger_row_kontrol.value == 1)
			{
				if(deger_date.value == "")
				{
					alert("<cf_get_lang no='40.Lütfen Ödeme Tarihi Giriniz'>! ");
					return false;
				}
				if(deger_capital_price.value == "")
				{
					alert("<cf_get_lang no='20.Ana Para Tutarı Giriniz'> ! ");
					return false;
				}
				if(proc_control == 296)
				{
					if(deger_expense.value=='')
					{
						alert("<cf_get_lang dictionary_id='51384.Lütfen Faiz Gider Kalemi Seçiniz'>");
						return false;
					}
					if(filterNum(deger_interest_value.value) > 0 && deger_interest_account_code.value=='')
					{
						alert("<cf_get_lang dictionary_id='51405.Lütfen Faiz Muhasebe Kodu Seçiniz'>");
						return false;
					}
					if(deger_total_expense.value=='')
					{
						alert("<cf_get_lang dictionary_id='51406.Lütfen Kira Gider Kalemi Seçiniz'>");
						return false;
					}
					if(deger_total_account_code.value=='')
					{
						alert("<cf_get_lang dictionary_id='51407.Lütfen Kira Muhasebe Kodu Seçiniz'>");
						return false;
					}
					if(document.getElementById('total_account_code'+r).value=='')
					{
						alert("<cf_get_lang dictionary_id='51404.Lütfen Finansal Kiralama Muhasebe Kodu Seçiniz'>!");
						return false;
					}
					if(deger_borrow_code.value == "")
					{
						alert("<cf_get_lang dictionary_id='54538.Lütfen Borçlanma Maliyet Kodu Giriniz'>!");
						return false;
					}
					if(document.getElementById('payment_interest_price'+r).value=='')
					{
						document.getElementById("payment_interest_price"+r).value=commaSplit(0,'4');
						return false;
					}
				}
			}
		}
		// Tahsilat satir kontrolleri
		for(k=1;k<=add_credit_contract.revenue_record_num.value;k++)
		{
			deger_row_kontrol = document.getElementById("revenue_row_kontrol"+k);
			deger_date = document.getElementById("revenue_date"+k);
			deger_capital_price = document.getElementById('revenue_capital_price'+k);
			if(deger_row_kontrol.value == 1)
			{
				if(deger_date.value == "")
				{
					alert("<cf_get_lang no='34.Lütfen Tahsilat Tarihi Giriniz'> !");
					return false;
				}
				if(deger_capital_price.value == "")
				{
					alert("<cf_get_lang no='20.Ana Para Tutarı Giriniz'> ! ");
					return false;
				}
			}
		}	
		unformat_fields();
		return true;
	}
	function payment_interest_price_amount(row){
		if(document.getElementById('payment_interest_price'+row).value=='')
				{
					document.getElementById("payment_interest_price"+row).value=commaSplit(0,'4');
					return false;
				}
	}
	function payment_capital_price_amount(row){
		if(document.getElementById('payment_capital_price'+row).value=='')
				{
					document.getElementById("payment_capital_price"+row).value=commaSplit(0,'4');
					return false;
				}
	}
	
	function payment_tax_price_amount(row){
		if(document.getElementById('payment_tax_price'+row).value=='')
				{
					document.getElementById("payment_tax_price"+row).value=commaSplit(0,'4');
					return false;
				}
	}
	function write_total_amount(type,type2)
	{
		if(type == 1)
		{
			var payment_total_capital_price = 0;
			var payment_total_interest_price = 0;
			var payment_total_tax_price = 0;
			var payment_total_price = 0;
				
			for (var i=1; i <= add_credit_contract.payment_record_num.value; i++)
			{
				deger_row_kontrol = document.getElementById("payment_row_kontrol"+i);
				if(deger_row_kontrol.value == 1)
				{
					if(type2 == undefined)
					{
						var payment_row_total_price = 0;
						payment_total_capital_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
						payment_total_interest_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
						payment_total_tax_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value));
						if(document.getElementById('payment_capital_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
						if(document.getElementById('payment_interest_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
						if(document.getElementById("total_payment_price"+i) != undefined)
							document.getElementById("total_payment_price"+i).value = commaSplit(payment_row_total_price);
						if(document.getElementById('payment_tax_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value));
						document.getElementById("payment_total_price"+i).value = commaSplit(payment_row_total_price);
						payment_total_price += parseFloat(payment_row_total_price);
					}
					else
					{
						var payment_row_total_price = 0;
						payment_total_capital_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
						payment_total_interest_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
						if(document.getElementById('payment_capital_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
						if(document.getElementById('payment_interest_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
						if(document.getElementById("total_payment_price"+i) != undefined)
							document.getElementById("total_payment_price"+i).value = commaSplit(payment_row_total_price);
						document.getElementById("payment_tax_price"+i).value = parseFloat(filterNum(document.getElementById("payment_total_price"+i).value)-filterNum(document.getElementById("payment_capital_price"+i).value)-filterNum(document.getElementById("payment_interest_price"+i).value));
						payment_total_tax_price += filterNum(document.getElementById('payment_tax_price'+i).value);
						if(document.getElementById('payment_tax_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value));
						payment_total_price += parseFloat(payment_row_total_price);
					}	
				}
			}
			document.getElementById('payment_total_capital_price').value = commaSplit(payment_total_capital_price);
			document.getElementById('payment_total_interest_price').value = commaSplit(payment_total_interest_price);
			document.getElementById('payment_total_tax_price').value = commaSplit(payment_total_tax_price);
			document.getElementById('payment_total_price').value = commaSplit(payment_total_price);
			document.getElementById('total_payment').value = commaSplit(payment_total_price);
			document.getElementById('payment_total_price_kdvsiz').value = commaSplit(payment_total_price-payment_total_tax_price);
		}
		else
		{
			var revenue_total_capital_price = 0;
			var revenue_total_interest_price = 0;
			var revenue_total_tax_price = 0;
			var revenue_total_price = 0;
				
			for (var i=1; i <= add_credit_contract.revenue_record_num.value; i++)
			{
				deger_row_kontrol = document.getElementById("revenue_row_kontrol"+i);
				if(deger_row_kontrol.value == 1)
				{
					var revenue_row_total_price = 0;
					revenue_total_capital_price += parseFloat(filterNum(document.getElementById('revenue_capital_price'+i).value));
					revenue_total_interest_price += parseFloat(filterNum(document.getElementById('revenue_interest_price'+i).value));
					revenue_total_tax_price += parseFloat(filterNum(document.getElementById('revenue_tax_price'+i).value));
					if(document.getElementById('revenue_capital_price'+i).value != "") revenue_row_total_price += parseFloat(filterNum(document.getElementById('revenue_capital_price'+i).value));
					if(document.getElementById('revenue_interest_price'+i).value != "") revenue_row_total_price += parseFloat(filterNum(document.getElementById('revenue_interest_price'+i).value));
					if(document.getElementById('revenue_tax_price'+i).value != "") revenue_row_total_price += parseFloat(filterNum(document.getElementById('revenue_tax_price'+i).value));
					document.getElementById("revenue_total_price"+i).value = commaSplit(revenue_row_total_price);
					revenue_total_price += parseFloat(revenue_row_total_price);
				}
			}
			document.getElementById('revenue_total_capital_price').value = commaSplit(revenue_total_capital_price);
			document.getElementById('revenue_total_interest_price').value = commaSplit(revenue_total_interest_price);
			document.getElementById('revenue_total_tax_price').value = commaSplit(revenue_total_tax_price);
			document.getElementById('revenue_total_price').value = commaSplit(revenue_total_price);
			document.getElementById('total_revenue').value = commaSplit(revenue_total_price);
		}
		f_kur_hesapla_multi();
	}
	function unformat_fields()
	{
		for(r=1;r<=add_credit_contract.payment_record_num.value;r++)
		{
			if(document.getElementById("payment_row_kontrol"+r).value == 1)
			{
				document.getElementById("payment_capital_price"+r).value = filterNum(document.getElementById("payment_capital_price"+r).value);
				document.getElementById("payment_interest_price"+r).value = filterNum(document.getElementById("payment_interest_price"+r).value);
				document.getElementById("payment_tax_price"+r).value = filterNum(document.getElementById("payment_tax_price"+r).value);
				document.getElementById("payment_total_price"+r).value = filterNum(document.getElementById("payment_total_price"+r).value);
			}
		}
		
		for(k=1;k<=add_credit_contract.revenue_record_num.value;k++)
		{
			if(document.getElementById("revenue_row_kontrol"+k).value == 1)
			{
				document.getElementById("revenue_capital_price"+k).value = filterNum(document.getElementById("revenue_capital_price"+k).value);
				document.getElementById("revenue_interest_price"+k).value = filterNum(document.getElementById("revenue_interest_price"+k).value);
				document.getElementById("revenue_tax_price"+k).value = filterNum(document.getElementById("revenue_tax_price"+k).value);
				document.getElementById("revenue_total_price"+k).value = filterNum(document.getElementById("revenue_total_price"+k).value);
			}
		}
		
		for(s=1;s<=add_credit_contract.deger_get_money.value;s++)
		{
			document.getElementById('txt_rate2_' + s).value = filterNum(document.getElementById('txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		document.getElementById("interest_rate").value = filterNum(document.getElementById("interest_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		add_credit_contract.total_revenue.value = filterNum(add_credit_contract.total_revenue.value);
		add_credit_contract.other_total_revenue.value = filterNum(add_credit_contract.other_total_revenue.value);
		add_credit_contract.total_payment.value = filterNum(add_credit_contract.total_payment.value);
		add_credit_contract.other_total_payment.value = filterNum(add_credit_contract.other_total_payment.value);
	}
	function f_kur_hesapla_multi()//sistem para birimi hesaplama
	{
		var system_cur_value;
		for(var i=1;i<=<cfoutput>#get_money.recordcount#</cfoutput>;i++)
		{
			if(document.add_credit_contract.rd_money[i-1].checked == true)
			{
				rate1_eleman = filterNum(document.getElementById('txt_rate1_'+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				rate2_eleman = filterNum(document.getElementById('txt_rate2_'+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				system_cur_value = filterNum(document.getElementById('revenue_total_price').value)*rate2_eleman/rate1_eleman;
				add_credit_contract.other_total_revenue.value = commaSplit(system_cur_value);

				system_cur_value = filterNum(document.getElementById('payment_total_price').value)*rate2_eleman/rate1_eleman;
				add_credit_contract.other_total_payment.value = commaSplit(system_cur_value);
				
				add_credit_contract.money_info_rev.value = document.getElementById('hidden_rd_money_'+i).value;
				add_credit_contract.money_info_pay.value = document.getElementById('hidden_rd_money_'+i).value;
			}
		}
	}
	function gizle_finance()
	{
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		if(selected_ptype != '')
		{
			eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
			if(proc_control == 296)
			{
				finance7.style.display = '';
				finance8.style.display = '';
				finance9.style.display = '';
				credit_limit.style.display = 'none';
				
				credittable.style.display = 'none';
			}
			else
			{
				finance7.style.display = 'none';
				finance8.style.display = 'none';
				finance9.style.display = 'none';
				credit_limit.style.display = '';
				
			}
		}
	}
	//satir cogalt
	function open_row_add(type,row_number)
	{
		document.getElementById('add_multi_row').style.display='';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=credit.popup_add_multi_credit_row&type='+ type +'&row_number='+ row_number,'add_multi_row',1);
	}
	//gider kalemleri popup
	function pencere_ac_items(input_id,input_name,input_acc_id,input_acc_code,row_number)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_credit_contract.'+input_id+row_number+'&field_name=add_credit_contract.'+input_name+row_number+'&field_account_no=add_credit_contract.'+input_acc_code+row_number+'&field_account_no2=add_credit_contract.'+input_acc_id+row_number+'','list');
	}
	//muhasebe kodlari popup
	function pencere_ac_acc(input_acc_id,input_acc_code,row_number)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_contract.'+input_acc_id+row_number+'&field_name=add_credit_contract.'+input_acc_code+row_number+'','list');
	}
	
	document.getElementById('kredi_sepet').style.width = screen.width-50;
	document.getElementById('kredi_sepet').style.height = 150;
	h_ = parseInt(document.getElementById('kredi_sepet').style.height);
	if (document.getElementById('kredi_sepet').style.height != '')
		document.getElementById('kredi_sepet').style.height = h_ + <cfoutput>#get_rows_1.recordcount#*</cfoutput>20+25;
	gizle_finance();
</script>
    </cfif>
</cfif>
<cfif IsDefined("attributes.event") and (attributes.event eq 'addRevenue' or attributes.event eq 'updRevenue')>
	<cf_xml_page_edit fuseact="credit.popup_add_credit_payment">
    <cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
        SELECT
            ACCOUNTS.ACCOUNT_ID,
            ACCOUNTS.ACCOUNT_NAME,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID
            </cfif>
        FROM
            ACCOUNTS,
            BANK_BRANCH
        WHERE
            ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND
            ACCOUNTS.ACCOUNT_STATUS = 1 AND
            <cfif session.ep.period_year lt 2009>
                (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
            </cfif>
            <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
                AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
            </cfif>
        ORDER BY
            BANK_NAME,
            ACCOUNT_NAME
    </cfquery>
    <cfif not isdefined("temp_dsn")>
		<cfset temp_dsn = "#dsn2#">
    </cfif>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#temp_dsn#">
        SELECT
            EXPENSE_ID,
            EXPENSE
        FROM
            EXPENSE_CENTER
        WHERE
            EXPENSE_ACTIVE = 1
        ORDER BY
            EXPENSE
    </cfquery>
    <cfif attributes.event eq 'addRevenue'>
    	<cfquery name="GET_CREDIT_CONTRACT" datasource="#DSN3#">
            SELECT
                CC.COMPANY_ID,
                CC.PARTNER_ID,
                CC.MONEY_TYPE
                <cfif isdefined("attributes.credit_contract_row_id")>		
                    ,CCR.PROCESS_DATE
                    ,CCR.CAPITAL_PRICE
                    ,CCR.INTEREST_PRICE
                    ,CCR.TAX_PRICE
                    ,CCR.TOTAL_PRICE
                    ,CCR.EXPENSE_CENTER_ID
                    ,CCR.EXPENSE_ITEM_ID
                    ,CCR.INTEREST_ACCOUNT_ID
                    ,CCR.TOTAL_EXPENSE_ITEM_ID
                    ,CCR.TOTAL_ACCOUNT_ID
                    ,CCR.CAPITAL_EXPENSE_ITEM_ID
                    ,CCR.CAPITAL_ACCOUNT_ID
                    ,EI.EXPENSE_ITEM_NAME
                    ,EI.ACCOUNT_CODE
                <cfelse>
                    ,0 AS PROCESS_DATE
                    ,0 AS CAPITAL_PRICE
                    ,0 AS INTEREST_PRICE
                    ,0 AS TAX_PRICE
                    ,0 AS TOTAL_PRICE
                    ,0 AS EXPENSE_CENTER_ID
                    ,0 AS EXPENSE_ITEM_ID
                    ,'' AS INTEREST_ACCOUNT_ID
                    ,0 AS TOTAL_EXPENSE_ITEM_ID
                    ,'' AS TOTAL_ACCOUNT_ID
                    ,0 AS CAPITAL_EXPENSE_ITEM_ID
                    ,'' AS CAPITAL_ACCOUNT_ID
                    ,'' AS EXPENSE_ITEM_NAME
                    ,'' AS ACCOUNT_CODE
                </cfif>
            FROM
            	 CREDIT_CONTRACT CC
                <cfif isdefined("attributes.credit_contract_row_id")>
                    LEFT JOIN CREDIT_CONTRACT_ROW CCR ON  CCR.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID 
                    LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = ISNULL(CCR.EXPENSE_ITEM_ID ,ISNULL(CCR.TOTAL_EXPENSE_ITEM_ID,CCR.CAPITAL_EXPENSE_ITEM_ID))
                </cfif>
               
            WHERE
                <cfif isdefined("attributes.credit_contract_row_id")>		
                    CCR.CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id# AND
                   
                </cfif>
                CC.CREDIT_CONTRACT_ID = #attributes.credit_contract_id#
        </cfquery>
        <cfquery name="credit_contract_money" datasource="#dsn3#">
            SELECT MONEY_TYPE FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
        </cfquery>
        <cfset attributes.expense_center_id = GET_CREDIT_CONTRACT.EXPENSE_CENTER_ID>
        <cfset attributes.capital_price = GET_CREDIT_CONTRACT.CAPITAL_PRICE>
        <cfset attributes.capital_account_id = GET_CREDIT_CONTRACT.CAPITAL_ACCOUNT_ID >
        <cfset attributes.capital_expense_item_id = GET_CREDIT_CONTRACT.CAPITAL_EXPENSE_ITEM_ID>
        <cfset attributes.expense_item_name = GET_CREDIT_CONTRACT.expense_item_name  >
        <cfset attributes.interest_price = get_credit_contract.interest_price>
        <cfset attributes.interest_account_id = get_credit_contract.interest_account_id>
        <cfset attributes.expense_item_id = get_credit_contract.interest_price>
        <cfset attributes.expense_item_name = get_credit_contract.interest_account_id>
        <cfset attributes.tax_price = get_credit_contract.tax_price>
        <cfset attributes.total_account_id = get_credit_contract.total_account_id>
        <cfset attributes.total_expense_item_id = get_credit_contract.total_expense_item_id>
        <cfset attributes.total_price = get_credit_contract.total_price>
        <script type="text/javascript">
	form_txt_rate2_2 = '';
	row_count = 1;
	function sil(sy)
	{
		var my_element=eval("add_credit_revenue.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		write_total_amount();
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;	
		document.add_credit_revenue.record_num.value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tax_price_'+ row_count +'" id="tax_price_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount();kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tax_price_other_'+ row_count +'" id="tax_price_other_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ' <input type="hidden" name="debt_account_id3_'+ row_count +'" id="debt_account_id3_'+ row_count +'" value=""><input type="text" style="width:140px;" name="debt_account_code3_'+ row_count +'" id="debt_account_code3_'+ row_count +'" value="" onFocus="auto_account('+ row_count +');">   <a href="javascript://" onClick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ' <input type="hidden" name="tax_expense_id_'+ row_count +'" id="tax_expense_id_'+ row_count +'" value=""><input type="text" style="width:140px;" name="tax_expense_'+ row_count +'" id="tax_expense_'+ row_count +'" value="" onFocus="auto_expense('+ row_count +');">   <a href="javascript://" onClick="pencere_ac_expense('+ row_count +');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='322.Seçiniz'>"></a><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"> <a href="javascript://" onclick="sil(' + row_count + ');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>';
	}
	function auto_account(no)
	{
		AutoComplete_Create('debt_account_code3_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id3_'+no,'add_credit_revenue','3','140');
	}
	function auto_expense(no)
	{
		AutoComplete_Create('tax_expense_'+no,'EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','tax_expense_id_'+no+',debt_account_code3_'+no+',debt_account_id3_'+no,'add_credit_revenue','3');
	}	
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_revenue.debt_account_id3_' + no +'&field_name=add_credit_revenue.debt_account_code3_' + no +'','list');
	}
	function pencere_ac_expense(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_credit_revenue.tax_expense_id_' + no +'&field_name=add_credit_revenue.tax_expense_' + no +'&field_account_no=add_credit_revenue.debt_account_id3_' + no +'&field_account_no2=add_credit_revenue.debt_account_code3_' + no +'','list');
	}
	function kontrol()
	{
		process=document.add_credit_revenue.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		/* tarih kontrolu */
		if(get_process_cat.IS_ACCOUNT == 1 && document.getElementById('revenue_date').value != "")
			if(!chk_period(add_credit_revenue.revenue_date,"İşlem")) return false;
		
		if(!chk_process_cat('add_credit_revenue')) return false;
		if(!check_display_files('add_credit_revenue')) return false;
		
		<cfif is_company_required eq 1>
			if(document.add_credit_revenue.company_id.value=='')	
			{
				alert("<cf_get_lang no='16.Lütfen Kredi Kurumu Seçiniz'>! ");
				return false;
			}
		</cfif>
		
		x = document.add_credit_revenue.action_from_account_id.selectedIndex;
		if (document.add_credit_revenue.action_from_account_id[x].value == "")
		{
			alert('<cf_get_lang no='49.Banka Hesabı Seçiniz'>! ');
			return false;
		}	
		if (document.add_credit_revenue.expense_center_id.value == "")
		{
			alert('<cf_get_lang no='50.Masraf Merkezi Seçiniz'>!');
			return false;
		}
		if(document.add_credit_revenue.revenue_date.value == "")
		{
			alert('<cf_get_lang no='34.Lütfen Tahsilat Tarihi Giriniz'>! ');
			return false;
		}
		
		if(document.add_credit_revenue.capital_price.value == "" || document.add_credit_revenue.capital_price.value == 0)
		{
			alert('<cf_get_lang no='20.Lütfen Ana Para Tutarı Giriniz'> ! ');
			return false;
		}
		<cfif is_budget_control eq 1>
			if(document.add_credit_revenue.is_capital_budget_act.value == 1 && filterNum(document.add_credit_revenue.capital_price.value) != 0 && document.add_credit_revenue.capital_expense.value == "")
			{
				alert('<cf_get_lang no='51.Lütfen Ana Para Gider Kalemi Seçiniz '>! ');
				return false;		
			}
			if(filterNum(document.add_credit_revenue.interest_price.value) != 0 && document.add_credit_revenue.interest_expense_id.value == "")
			{
				alert('<cf_get_lang no='52.Lütfen Faiz Gider Kalemi Seçiniz'>!');
				return false;
			}
		</cfif>
		if(filterNum(document.add_credit_revenue.interest_price.value) != 0 && document.add_credit_revenue.debt_account_code2.value == "")
		{
			alert("<cf_get_lang dictionary_id='51405.Lütfen Faiz Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		<cfif is_budget_control eq 1>
			if(filterNum(document.add_credit_revenue.delay_price.value) != 0 && document.add_credit_revenue.delay_expense_id.value == "")
			{
				alert('<cf_get_lang no='54.Lütfen Gecikme Gider Kalemi Seçiniz'> !');
				return false;
			}
		</cfif>
		if(filterNum(document.add_credit_revenue.delay_price.value) != 0 && document.add_credit_revenue.debt_account_code4.value == "")
		{
			alert("<cf_get_lang dictionary_id='54539.Lütfen Gecikme Muhasebe Kodu Seçiniz'>");
			return false;
		}
		for(r=1;r<=document.add_credit_revenue.record_num.value;r++)
		{
			if(eval("document.add_credit_revenue.row_kontrol"+r).value==1)
			{
				if(filterNum(eval('document.add_credit_revenue.tax_price_'+r).value) > 0 && eval('document.add_credit_revenue.debt_account_id3_'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id ='54540.Lütfen Vergi Muhasebe Kodu Seçiniz'>");
					return false;
				}
				<cfif is_budget_control eq 1>
					if(filterNum(eval('document.add_credit_revenue.tax_price_'+r).value) > 0 && eval('document.add_credit_revenue.tax_expense_id_'+r).value == "")
					{
						alert('<cf_get_lang no='53.Lütfen Vergi Gider Kalemi Seçiniz'> !');
						return false;
					}
				</cfif>
			}
		}
		unformat_fields();
		return true;
	}
	function write_total_amount(type)
	{
		if(type == undefined) type = 1;
		bank_currency_type = list_getat(document.getElementById("action_from_account_id").value,2,';');
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			if(document.add_credit_revenue.rd_money[s-1].checked == true)
			{
				if(document.getElementById("txt_rate2_"+s))
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s).value;
			}
			if(bank_currency_type != '' &&  document.getElementById("hidden_rd_money_"+s).value == bank_currency_type)
			{
				if (document.getElementById("txt_rate2_"+s))
					form_txt_rate2_2 = document.getElementById("txt_rate2_"+s).value;
				else
					form_txt_rate2_2 = '';
			}
		}
		<cfoutput>
			if(type == 1)
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					document.getElementById("capital_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
					document.getElementById("interest_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
					document.getElementById("delay_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.add_credit_revenue.record_num.value;r++)
					{
						if(eval("document.add_credit_revenue.row_kontrol"+r).value==1)
						{
							if(eval('document.add_credit_revenue.tax_price_'+r).value != "")
								eval('document.add_credit_revenue.tax_price_other_'+r).value = commaSplit(parseFloat(filterNum(eval('document.add_credit_revenue.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
			else
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("capital_price").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("interest_price").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("delay_price").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.add_credit_revenue.record_num.value;r++)
					{
						if(eval("document.add_credit_revenue.row_kontrol"+r).value==1)
						{
							if(eval('document.add_credit_revenue.tax_price_other_'+r).value != "")
				    			eval('document.add_credit_revenue.tax_price_'+r).value = commaSplit(parseFloat(filterNum(eval('document.add_credit_revenue.tax_price_other_'+r).value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
		var total_price = 0;
		var other_total_price = 0;
		var system_amount = 0;
		if(document.add_credit_revenue.capital_price.value != "")
			total_price += parseFloat(filterNum(add_credit_revenue.capital_price.value));
		if(document.add_credit_revenue.interest_price.value != "")
			total_price += parseFloat(filterNum(add_credit_revenue.interest_price.value));
		if(document.add_credit_revenue.delay_price.value != "")
			total_price += parseFloat(filterNum(add_credit_revenue.delay_price.value));
		for(r=1;r<=document.add_credit_revenue.record_num.value;r++)
		{
			if(eval("document.add_credit_revenue.row_kontrol"+r).value==1)
			{
				if(eval('document.add_credit_revenue.tax_price_'+r).value != "")
					total_price += parseFloat(filterNum(eval('document.add_credit_revenue.tax_price_'+r).value));
			}
		}
		if(document.add_credit_revenue.capital_price_other.value != "")
			other_total_price += parseFloat(filterNum(add_credit_revenue.capital_price_other.value));
		if(document.add_credit_revenue.interest_price_other.value != "")
			other_total_price += parseFloat(filterNum(add_credit_revenue.interest_price_other.value));
		if(document.add_credit_revenue.delay_price_other.value != "")
			other_total_price += parseFloat(filterNum(add_credit_revenue.delay_price_other.value));
		for(r=1;r<=document.add_credit_revenue.record_num.value;r++)
		{
			if(eval("document.add_credit_revenue.row_kontrol"+r).value==1)
			{
				if(eval('document.add_credit_revenue.tax_price_other_'+r).value != "")
					other_total_price += parseFloat(filterNum(eval('document.add_credit_revenue.tax_price_other_'+r).value));
			}
		}
		rate_2 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
		document.add_credit_revenue.cash_action_value.value = commaSplit(total_price,'#session.ep.our_company_info.rate_round_num#');
		document.add_credit_revenue.other_cash_act_value.value = commaSplit(other_total_price,'#session.ep.our_company_info.rate_round_num#');
		document.add_credit_revenue.system_amount_value.value = commaSplit(parseFloat(total_price)*rate_2,'#session.ep.our_company_info.rate_round_num#');
		</cfoutput>
	}
	function unformat_fields()
	{
		<cfoutput>
			document.add_credit_revenue.capital_price.value = filterNum(document.add_credit_revenue.capital_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_revenue.interest_price.value = filterNum(document.add_credit_revenue.interest_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_revenue.delay_price.value = filterNum(document.add_credit_revenue.delay_price.value,'#session.ep.our_company_info.rate_round_num#');
			for(r=1;r<=document.add_credit_revenue.record_num.value;r++)
			{
				if(eval("document.add_credit_revenue.row_kontrol"+r).value==1)
				{
					if(eval('document.add_credit_revenue.tax_price_'+r).value != "")
						eval('document.add_credit_revenue.tax_price_'+r).value = filterNum(eval('document.add_credit_revenue.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#');
				}
			}
			document.add_credit_revenue.cash_action_value.value = filterNum(document.add_credit_revenue.cash_action_value.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_revenue.other_cash_act_value.value = filterNum(document.add_credit_revenue.other_cash_act_value.value,'#session.ep.our_company_info.rate_round_num#');
			add_credit_revenue.system_amount.value = filterNum(add_credit_revenue.system_amount.value,'#session.ep.our_company_info.rate_round_num#');
			add_credit_revenue.system_amount.value = filterNum(add_credit_revenue.system_amount.value);
			add_credit_revenue.system_amount_value.value = filterNum(add_credit_revenue.system_amount_value.value);
			for(var i=1;i<=add_credit_revenue.kur_say.value;i++)
			{
				eval('add_credit_revenue.txt_rate1_' + i).value = filterNum(eval('add_credit_revenue.txt_rate1_' + i).value,'#session.ep.our_company_info.rate_round_num#');
				eval('add_credit_revenue.txt_rate2_' + i).value = filterNum(eval('add_credit_revenue.txt_rate2_' + i).value,'#session.ep.our_company_info.rate_round_num#');
			}
		</cfoutput>
	}
	kur_ekle_f_hesapla('action_from_account_id');
</script>
    </cfif>
    <cfif attributes.event eq 'updRevenue'>
    	<cf_xml_page_edit fuseact="credit.popup_add_credit_revenue">
		<cfif not len(url.credit_contract_row_id)>
            <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
            <cfexit method="exittemplate">
        </cfif>
        <cfif not isdefined("attributes.period_id")><cfset attributes.period_id = session.ep.period_id></cfif>
        <cfif not isdefined("attributes.our_company_id")><cfset attributes.our_company_id = session.ep.company_id></cfif>
        <cfquery name="GET_PERIOD" datasource="#DSN#">
            SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
        </cfquery> 
        <cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
        
        <cfquery name="GET_CREDIT_CONTRACT_PAYMENT" datasource="#temp_dsn#">
            SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME WHERE CREDIT_CONTRACT_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_row_id#">
        </cfquery>
        <cfif not isdefined("url.credit_contract_id")><cfset url.credit_contract_id = GET_CREDIT_CONTRACT_PAYMENT.CREDIT_CONTRACT_ID></cfif>
        <cfquery name="get_credit_contract_payment_tax" datasource="#temp_dsn#">
            SELECT
                CC.*,
                EX.EXPENSE_ITEM_NAME
            FROM
                CREDIT_CONTRACT_PAYMENT_INCOME_TAX CC
                LEFT JOIN EXPENSE_ITEMS EX ON EX.EXPENSE_ITEM_ID = CC.TAX_EXPENSE_ITEM_ID
            WHERE
                CC.CREDIT_CONTRACT_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_row_id#">
        </cfquery>
        <cfquery name="credit_contract_money" datasource="#dsn3#">
            SELECT MONEY_TYPE FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
        </cfquery>
        <cfquery name="get_project_from_bank_actions" datasource="#dsn2#">
            SELECT PROJECT_ID FROM BANK_ACTIONS WHERE ACTION_ID = #GET_CREDIT_CONTRACT_PAYMENT.BANK_ACTION_ID#
        </cfquery>
        <cfif not GET_CREDIT_CONTRACT_PAYMENT.recordcount>
            <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
            <cfexit method="exittemplate">
        </cfif>
        <cfif is_capital_budget_act neq 0>
			<cfif len(get_credit_contract_payment.capital_expense_item_id)>
                <cfquery name="GET_EXPENSE_CAPITAL" datasource="#dsn2#">
                    SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_credit_contract_payment.capital_expense_item_id#
                </cfquery>
            </cfif>
        </cfif>
        <cfif len(get_credit_contract_payment.interest_expense_item_id)>
            <cfquery name="GET_EXPENSE_INTEREST" datasource="#dsn2#">
                SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_credit_contract_payment.interest_expense_item_id#
            </cfquery>
        </cfif>
		<cfif len(get_credit_contract_payment.delay_expense_item_id)>
            <cfquery name="GET_EXPENSE_DELAY" datasource="#dsn2#">
                SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_credit_contract_payment.delay_expense_item_id#
            </cfquery>
        </cfif>
        <cfset attributes.expense_center_id = get_credit_contract_payment.EXPENSE_CENTER_ID>
        <cfset attributes.capital_price = get_credit_contract_payment.CAPITAL_PRICE>
        <cfset attributes.capital_account_id = get_credit_contract_payment.CAPITAL_EXPENSE_ITEM_ID_ACC >
        <cfset attributes.capital_expense_item_id = get_credit_contract_payment.capital_expense_item_id >
        <cfset attributes.interest_price = get_credit_contract_payment.interest_price>
        <cfset attributes.interest_account_id = get_credit_contract_payment.INTEREST_EXPENSE_ITEM_ID_ACC>
        <cfset attributes.expense_item_id = get_credit_contract_payment.interest_expense_item_id>
        <cfif attributes.expense_item_id neq ''>
        	<cfset attributes.expense_item_name = get_expense_interest.expense_item_name>
        <cfelse>
        	<cfset attributes.expense_item_name = ''>
        </cfif>
        <cfif attributes.capital_expense_item_id neq ''>
        	<cfset attributes.expense_item_name = get_expense_capital.expense_item_name>
        <cfelse>
        	<cfset attributes.expense_item_name = ''>
        </cfif>
          <cfset attributes.tax_price = 0>
          <cfset attributes.total_account_id = "">
          <cfset attributes.total_expense_item_id = "">
          <cfset attributes.total_price = get_credit_contract_payment.total_price>
        <script type="text/javascript">
			$( document ).ready(function() {
			<cfif get_credit_contract_payment_tax.recordcount>
				row_count = <cfoutput>#get_credit_contract_payment_tax.recordcount#</cfoutput>;
			<cfelse>
				row_count = 1;
			</cfif>
			kur_ekle_f_hesapla('action_from_account_id');
			write_total_amount();
		});
	
	function sil(sy)
	{
		var my_element=eval("upd_credit_revenue.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		write_total_amount();
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;	
		document.upd_credit_revenue.record_num.value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tax_price_'+ row_count +'" id="tax_price_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount();kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:130px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tax_price_other_'+ row_count +'" id="tax_price_other_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ' <input type="hidden" name="debt_account_id3_'+ row_count +'" id="debt_account_id3_'+ row_count +'" value=""><input type="text" style="width:140px;" name="debt_account_code3_'+ row_count +'" id="debt_account_code3_'+ row_count +'" value="" onFocus="auto_account('+ row_count +');">   <a href="javascript://" onClick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ' <input type="hidden" name="tax_expense_id_'+ row_count +'" id="tax_expense_id_'+ row_count +'" value=""><input type="text" style="width:130px;" name="tax_expense_'+ row_count +'" id="tax_expense_'+ row_count +'" value="" onFocus="auto_expense('+ row_count +');">   <a href="javascript://" onClick="pencere_ac_expense('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"> <a href="javascript://" onclick="sil(' + row_count + ');"><img src="/images/delete_list.gif" alt="sil" border="0" align="absmiddle"></a>';
	}
	function auto_account(no)
	{
		AutoComplete_Create('debt_account_code3_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id3_'+no,'upd_credit_revenue','3','140');
	}
	function auto_expense(no)
	{
		AutoComplete_Create('tax_expense_'+no,'EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','tax_expense_id_'+no+',debt_account_code3_'+no+',debt_account_id3_'+no,'upd_credit_revenue','3');
	}	
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_credit_revenue.debt_account_id3_' + no +'&field_name=upd_credit_revenue.debt_account_code3_' + no +'','list');
	}
	function pencere_ac_expense(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_credit_revenue.tax_expense_id_' + no +'&field_name=upd_credit_revenue.tax_expense_' + no +'&field_account_no=upd_credit_revenue.debt_account_id3_' + no +'&field_account_no2=upd_credit_revenue.debt_account_code3_' + no +'','list');
	}
	function del_kontrol() 
	{
		return control_account_process(<cfoutput>'#get_credit_contract_payment.credit_contract_payment_id#','#get_credit_contract_payment.process_type#'</cfoutput>);
	}
	function kontrol()
	{
		control_account_process(<cfoutput>'#get_credit_contract_payment.credit_contract_payment_id#','#get_credit_contract_payment.process_type#'</cfoutput>);
		process=document.upd_credit_revenue.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		/* tarih kontrolu */
		if(get_process_cat.IS_ACCOUNT == 1 && document.getElementById('revenue_date').value != "")
			if(!chk_period(upd_credit_revenue.revenue_date,"İşlem")) return false;
		
		if(!chk_process_cat('upd_credit_revenue')) return false;
		if(!check_display_files('upd_credit_revenue')) return false;
		
		<cfif is_company_required eq 1>
			if(document.upd_credit_revenue.company_id.value=='')	
			{
				alert("<cf_get_lang no='16.Lütfen Kredi Kurumu Seçiniz'>!");
				return false;
			}
		</cfif>	
		debugger;
		x = document.upd_credit_revenue.action_from_account_id.selectedIndex;
		
		if (document.upd_credit_revenue.action_from_account_id[x].value == "")
		{
			alert('<cf_get_lang no='49.Banka Hesabı Seçiniz'>!');
			return false;
		}	
		if (document.upd_credit_revenue.expense_center_id.value == "")
		{
			alert('<cf_get_lang no='50.Masraf Merkezi Seçiniz'>!');
			return false;
		}
		if(document.upd_credit_revenue.revenue_date.value == "")
		{
			alert('<cf_get_lang no='34.Lütfen Tahsilat Tarihi Giriniz'> ');
			return false;
		}
		
		if(document.upd_credit_revenue.capital_price.value == "" || document.upd_credit_revenue.capital_price.value == 0)
		{
			alert('<cf_get_lang no='20.Lütfen Ana Para Tutarı Giriniz'> !');
			return false;
		}
		<cfif is_budget_control eq 1>
			if(document.upd_credit_revenue.capital_expense != undefined && filterNum(document.upd_credit_revenue.capital_price.value) != 0 && document.upd_credit_revenue.capital_expense.value == "")
			{
				alert('<cf_get_lang no='51.Lütfen Ana Para Gider Kalemi Seçiniz '>! ');
				return false;		
			}
		</cfif>
		if(filterNum(document.upd_credit_revenue.capital_price.value) != 0 && document.upd_credit_revenue.debt_account_code.value == "")
		{
			alert("<cf_get_lang dictionary_id='54541.Lütfen Ana Para Muhasebe Kodu Seçiniz'>!");
			return false;
		}	
		<cfif is_budget_control eq 1>
			if(filterNum(document.upd_credit_revenue.interest_price.value) != 0 && document.upd_credit_revenue.interest_expense_id.value == "")
			{
				alert('<cf_get_lang no='52.Lütfen Faiz Gider Kalemi Seçiniz'>!');
				return false;
			}
		</cfif>
		if(filterNum(document.upd_credit_revenue.interest_price.value) != 0 && document.upd_credit_revenue.debt_account_code2.value == "")
		{
			alert("<cf_get_lang dictionary_id='51405.Lütfen Faiz Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		<cfif is_budget_control eq 1>
			if(filterNum(document.upd_credit_revenue.delay_price.value) != 0 && document.upd_credit_revenue.delay_expense_id.value == "")
			{
				alert('<cf_get_lang no='54.Lütfen Gecikme Gider Kalemi Seçiniz'> !');
				return false;
			}
		</cfif>
		if(filterNum(document.upd_credit_revenue.delay_price.value) != 0 && document.upd_credit_revenue.debt_account_code4.value == "")
		{
			alert("<cf_get_lang dictionary_id='54539.Lütfen Gecikme Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		for(r=1;r<=document.upd_credit_revenue.record_num.value;r++)
		{
			if(eval("document.upd_credit_revenue.row_kontrol"+r).value==1)
			{
				if(filterNum(eval('document.upd_credit_revenue.tax_price_'+r).value) > 0 && eval('document.upd_credit_revenue.debt_account_id3_'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='54540.Lütfen Vergi Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				<cfif is_budget_control eq 1>
					if(filterNum(eval('document.upd_credit_revenue.tax_price_'+r).value) > 0 && eval('document.upd_credit_revenue.tax_expense_id_'+r).value == "")
					{
						alert("<cf_get_lang no='53.Lütfen Vergi Gider Kalemi Seçiniz'>!");
						return false;
					}
				</cfif>
			}
		}
		unformat_fields();
		return true;
	}
	function write_total_amount(type)
	{
		if(type == undefined) type = 1;
		bank_currency_type = list_getat(document.getElementById("action_from_account_id").value,2,';');
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			if(document.upd_credit_revenue.rd_money[s-1].checked == true)
				form_txt_rate2_ = document.getElementById("txt_rate2_"+s).value;
			if(bank_currency_type != '' &&  document.getElementById("hidden_rd_money_"+s).value == bank_currency_type)
				form_txt_rate2_2 = document.getElementById("txt_rate2_"+s).value;
			else
				{
					deneme= document.getElementById("session_money_id").value;
					if(deneme != '' &&  document.getElementById("hidden_rd_money_"+s).value == deneme)
					form_txt_rate2_2 = document.getElementById("txt_rate2_"+s).value;
				}
		}
		<cfoutput>
			if(type == 1)
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("capital_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("interest_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("delay_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.upd_credit_revenue.record_num.value;r++)
					{
						if(eval("document.upd_credit_revenue.row_kontrol"+r).value==1)
						{
							if(eval('document.upd_credit_revenue.tax_price_'+r).value != "")
				    			eval('document.upd_credit_revenue.tax_price_other_'+r).value = commaSplit(parseFloat(filterNum(eval('document.upd_credit_revenue.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
			else
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("capital_price").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("interest_price").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("delay_price").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.upd_credit_revenue.record_num.value;r++)
					{
						if(eval("document.upd_credit_revenue.row_kontrol"+r).value==1)
						{
							if(eval('document.upd_credit_revenue.tax_price_other_'+r).value != "")
				    			eval('document.upd_credit_revenue.tax_price_'+r).value = commaSplit(parseFloat(filterNum(eval('document.upd_credit_revenue.tax_price_other_'+r).value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
		var total_price = 0;
		var other_total_price = 0;
		var system_amount = 0;
		if(document.upd_credit_revenue.capital_price.value != "")
			total_price += parseFloat(filterNum(upd_credit_revenue.capital_price.value));
		if(document.upd_credit_revenue.interest_price.value != "")
			total_price += parseFloat(filterNum(upd_credit_revenue.interest_price.value));
		if(document.upd_credit_revenue.delay_price.value != "")
			total_price += parseFloat(filterNum(upd_credit_revenue.delay_price.value));
		for(r=1;r<=document.upd_credit_revenue.record_num.value;r++)
		{
			if(eval("document.upd_credit_revenue.row_kontrol"+r).value==1)
			{
				if(eval('document.upd_credit_revenue.tax_price_'+r).value != "")
					total_price += parseFloat(filterNum(eval('document.upd_credit_revenue.tax_price_'+r).value));
			}
		}
		if(document.upd_credit_revenue.capital_price_other.value != "")
			other_total_price += parseFloat(filterNum(upd_credit_revenue.capital_price_other.value));
		if(document.upd_credit_revenue.interest_price_other.value != "")
			other_total_price += parseFloat(filterNum(upd_credit_revenue.interest_price_other.value));
		if(document.upd_credit_revenue.delay_price_other.value != "")
			other_total_price += parseFloat(filterNum(upd_credit_revenue.delay_price_other.value));
		for(r=1;r<=document.upd_credit_revenue.record_num.value;r++)
		{
			if(eval("document.upd_credit_revenue.row_kontrol"+r).value==1)
			{
				if(eval('document.upd_credit_revenue.tax_price_other_'+r).value != "")
					other_total_price += parseFloat(filterNum(eval('document.upd_credit_revenue.tax_price_other_'+r).value));
			}
		}
		rate_2 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
		document.upd_credit_revenue.cash_action_value.value = commaSplit(total_price,'#session.ep.our_company_info.rate_round_num#');
		document.upd_credit_revenue.other_cash_act_value.value = commaSplit(other_total_price,'#session.ep.our_company_info.rate_round_num#');
		document.upd_credit_revenue.system_amount_value.value = commaSplit(parseFloat(total_price)*rate_2,'#session.ep.our_company_info.rate_round_num#');
		</cfoutput>
	}
	function unformat_fields()
	{
		document.upd_credit_revenue.capital_price.value = filterNum(document.upd_credit_revenue.capital_price.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.upd_credit_revenue.interest_price.value = filterNum(document.upd_credit_revenue.interest_price.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.upd_credit_revenue.delay_price.value = filterNum(document.upd_credit_revenue.delay_price.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		for(r=1;r<=document.upd_credit_revenue.record_num.value;r++)
		{
			if(eval("document.upd_credit_revenue.row_kontrol"+r).value==1)
			{
				if(eval('document.upd_credit_revenue.tax_price_'+r).value != "")
					eval('document.upd_credit_revenue.tax_price_'+r).value = filterNum(eval('document.upd_credit_revenue.tax_price_'+r).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		document.upd_credit_revenue.cash_action_value.value = filterNum(document.upd_credit_revenue.cash_action_value.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.upd_credit_revenue.other_cash_act_value.value = filterNum(document.upd_credit_revenue.other_cash_act_value.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		upd_credit_revenue.system_amount_value.value = filterNum(upd_credit_revenue.system_amount_value.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		upd_credit_revenue.system_amount.value = filterNum(upd_credit_revenue.system_amount.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		for(var i=1;i<=upd_credit_revenue.kur_say.value;i++)
		{
			eval('upd_credit_revenue.txt_rate1_' + i).value = filterNum(eval('upd_credit_revenue.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('upd_credit_revenue.txt_rate2_' + i).value = filterNum(eval('upd_credit_revenue.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	
</script>
    </cfif>
</cfif>

<cfif IsDefined("attributes.event") and (attributes.event eq 'addPayment' or attributes.event eq 'updPayment')>
	<cf_xml_page_edit fuseact="credit.popup_add_credit_payment">
    <cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
        SELECT
            ACCOUNTS.ACCOUNT_ID,
            ACCOUNTS.ACCOUNT_NAME,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID
            </cfif>
        FROM
            ACCOUNTS,
            BANK_BRANCH
        WHERE
            ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND
            ACCOUNTS.ACCOUNT_STATUS = 1 AND
            <cfif session.ep.period_year lt 2009>
                (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
            </cfif>
            <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
                AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
            </cfif>
        ORDER BY
            BANK_NAME,
            ACCOUNT_NAME
    </cfquery>
    <cfif not isdefined("temp_dsn")>
		<cfset temp_dsn = "#dsn2#">
    </cfif>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#temp_dsn#">
        SELECT
            EXPENSE_ID,
            EXPENSE
        FROM
            EXPENSE_CENTER
        WHERE
            EXPENSE_ACTIVE = 1
        ORDER BY
            EXPENSE
    </cfquery>
    
    <cfif attributes.event eq 'addPayment'>
    	<cfquery name="GET_CREDIT_CONTRACT" datasource="#DSN3#">
            SELECT
                CC.COMPANY_ID,
                CC.PARTNER_ID,
                CC.MONEY_TYPE
                <cfif isdefined("attributes.credit_contract_row_id")>		
                    ,CCR.PROCESS_DATE
                    ,CCR.CAPITAL_PRICE
                    ,CCR.INTEREST_PRICE
                    ,CCR.TAX_PRICE
                    ,CCR.TOTAL_PRICE
                    ,CCR.EXPENSE_CENTER_ID
                    ,CCR.EXPENSE_ITEM_ID
                    ,CCR.INTEREST_ACCOUNT_ID
                    ,CCR.TOTAL_EXPENSE_ITEM_ID
                    ,CCR.TOTAL_ACCOUNT_ID
                    ,CCR.CAPITAL_EXPENSE_ITEM_ID
                    ,CCR.CAPITAL_ACCOUNT_ID
                    ,EI.EXPENSE_ITEM_NAME
                    ,EI.ACCOUNT_CODE
                <cfelse>
                    ,0 AS PROCESS_DATE
                    ,0 AS CAPITAL_PRICE
                    ,0 AS INTEREST_PRICE
                    ,0 AS TAX_PRICE
                    ,0 AS TOTAL_PRICE
                    ,0 AS EXPENSE_CENTER_ID
                    ,0 AS EXPENSE_ITEM_ID
                    ,'' AS INTEREST_ACCOUNT_ID
                    ,0 AS TOTAL_EXPENSE_ITEM_ID
                    ,'' AS TOTAL_ACCOUNT_ID
                    ,0 AS CAPITAL_EXPENSE_ITEM_ID
                    ,'' AS CAPITAL_ACCOUNT_ID
                    ,'' AS EXPENSE_ITEM_NAME
                    ,'' AS ACCOUNT_CODE
                </cfif>
            FROM
            	 CREDIT_CONTRACT CC
                <cfif isdefined("attributes.credit_contract_row_id")>
                    LEFT JOIN CREDIT_CONTRACT_ROW CCR ON  CCR.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID 
                    LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = ISNULL(CCR.EXPENSE_ITEM_ID ,ISNULL(CCR.TOTAL_EXPENSE_ITEM_ID,CCR.CAPITAL_EXPENSE_ITEM_ID))
                </cfif>
               
            WHERE
                <cfif isdefined("attributes.credit_contract_row_id")>		
                    CCR.CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id# AND
                   
                </cfif>
                CC.CREDIT_CONTRACT_ID = #attributes.credit_contract_id#
        </cfquery>
        <cfset attributes.expense_center_id = GET_CREDIT_CONTRACT.EXPENSE_CENTER_ID>
        <cfset attributes.capital_price = GET_CREDIT_CONTRACT.CAPITAL_PRICE>
        <cfset attributes.capital_account_id = GET_CREDIT_CONTRACT.CAPITAL_ACCOUNT_ID >
        <cfset attributes.capital_expense_item_id = GET_CREDIT_CONTRACT.CAPITAL_EXPENSE_ITEM_ID>
        <cfset attributes.expense_item_name = GET_CREDIT_CONTRACT.expense_item_name  >
        <cfset attributes.interest_price = get_credit_contract.interest_price>
        <cfset attributes.interest_account_id = get_credit_contract.interest_account_id>
        <cfset attributes.expense_item_id = get_credit_contract.interest_price>
        <cfset attributes.expense_item_name = get_credit_contract.interest_account_id>
        <cfset attributes.tax_price = get_credit_contract.tax_price>
        <cfset attributes.total_account_id = get_credit_contract.total_account_id>
        <cfset attributes.total_expense_item_id = get_credit_contract.total_expense_item_id>
        <cfset attributes.total_price = get_credit_contract.total_price>
        <script type="text/javascript">
        	$( document ).ready(function() {
        		row_count = 1;
		    kur_ekle_f_hesapla('action_from_account_id');
		});
	
	function sil(sy)
	{
		var my_element=eval("add_credit_payment.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		write_total_amount();
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;	
		document.add_credit_payment.record_num.value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tax_price_'+ row_count +'" id="tax_price_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tax_price_other_'+ row_count +'" id="tax_price_other_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ' <input type="hidden" name="debt_account_id3_'+ row_count +'" id="debt_account_id3_'+ row_count +'" value=""><input type="text" style="width:140px;" name="debt_account_code3_'+ row_count +'" id="debt_account_code3_'+ row_count +'" value="" onFocus="auto_account('+ row_count +');">   <a href="javascript://" onClick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ' <input type="hidden" name="tax_expense_id_'+ row_count +'" id="tax_expense_id_'+ row_count +'" value=""><input type="text" style="width:140px;" name="tax_expense_'+ row_count +'" id="tax_expense_'+ row_count +'" value="" onFocus="auto_expense('+ row_count +');">   <a href="javascript://" onClick="pencere_ac_expense('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"> <a href="javascript://" onclick="sil(' + row_count + ');"><img src="/images/delete_list.gif" border="0" alt="Sil" align="absmiddle"></a>';
	}
	function auto_account(no)
	{
		AutoComplete_Create('debt_account_code3_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id3_'+no,'add_credit_payment','3','140');
	}
	function auto_expense(no)
	{
		AutoComplete_Create('tax_expense_'+no,'EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','tax_expense_id_'+no+',debt_account_code3_'+no+',debt_account_id3_'+no,'add_credit_payment','3');
	}	
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_payment.debt_account_id3_' + no +'&field_name=add_credit_payment.debt_account_code3_' + no +'','list');
	}
	function pencere_ac_expense(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_credit_payment.tax_expense_id_' + no +'&field_name=add_credit_payment.tax_expense_' + no +'&field_account_no=add_credit_payment.debt_account_id3_' + no +'&field_account_no2=add_credit_payment.debt_account_code3_' + no +'','list');
	}
	function kontrol()
	{
		
		process=document.add_credit_payment.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		/* tarih kontrolu */
		if(get_process_cat.IS_ACCOUNT == 1 && document.getElementById('payment_date').value != "")
			if(!chk_period(add_credit_payment.payment_date,"İşlem")) return false;
			
		if(!chk_process_cat('add_credit_payment')) return false;
		if(!check_display_files('add_credit_payment')) return false;
		
		<cfif is_company_required eq 1>
			if(document.add_credit_payment.company_id.value=='')	
			{
				alert("<cf_get_lang no='16.Lütfen Kredi Kurumu Seçiniz'>! ");
				return false;
			}
		</cfif>
		x = document.add_credit_payment.action_from_account_id.selectedIndex;
			
		if (document.add_credit_payment.action_from_account_branch.value == "")
		{
			alert('<cf_get_lang_main no='1521.Banka Şubeleri'> <cf_get_lang_main no='322.Seçiniz'> ! ');
			return false;
		}	
		if (document.add_credit_payment.action_from_account_id[x].value == "")
		{
			alert("<cf_get_lang no='49.Banka Hesabı Seçiniz'>!");
			return false;
		}	
		if (document.add_credit_payment.expense_center_id.value == "")
		{
			alert("<cf_get_lang no='50.Masraf Merkezi Seçiniz'>!");
			return false;
		}
		if(document.add_credit_payment.payment_date.value == "")
		{
			alert("<cf_get_lang no='40.Lütfen Ödeme Tarihi Giriniz'> !");
			return false;
		}
		if( document.getElementById('debt_account_code').value=='' )
		{
			alert("<cf_get_lang dictionary_id='54549.Anapara muhasebe kodu giriniz'>");
			return false;
		}
		
		if(document.getElementById('debt_account_code2').value=='' )
		{
			alert("<cf_get_lang dictionary_id='54551.Faiz muhasebe kodu giriniz'>");
			return false;
		}
		
		if(document.getElementById('debt_account_code4').value=='' )
		{
			alert("<cf_get_lang dictionary_id='54556.Gecikme muhasebe kodu giriniz'>");
			return false;
		}
		
		if(document.getElementById('debt_account_code3_1').value=='' )
		{
			alert("<cf_get_lang dictionary_id='54561.Vergi muhasebe kodu giriniz'>");
			return false;
		}
		<cfif is_budget_control eq 1>
			if(document.add_credit_payment.is_capital_budget_act.value == 1 && filterNum(document.add_credit_payment.capital_price.value) != 0 && document.add_credit_payment.capital_expense.value == "")
			{
				alert("<cf_get_lang no='51.Lütfen Ana Para Gider Kalemi Seçiniz '>!");
				return false;		
			}
			if(filterNum(document.add_credit_payment.interest_price.value) != 0 && document.add_credit_payment.interest_expense_id.value == "")
			{
				alert("<cf_get_lang no='52.Lütfen Faiz Gider Kalemi Seçiniz'>!");
				return false;
			}
		</cfif>
		if(filterNum(document.add_credit_payment.interest_price.value) != 0 && document.add_credit_payment.debt_account_code2.value == "")
		{
			alert("<cf_get_lang dictionary_id='51405.Lütfen Faiz Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		<cfif is_budget_control eq 1>
			if(filterNum(document.add_credit_payment.delay_price.value) != 0 && document.add_credit_payment.delay_expense_id.value == "")
			{
				alert("<cf_get_lang no='54.Lütfen Gecikme Gider Kalemi Seçiniz'> !");
				return false;
			}
		</cfif>
		if(filterNum(document.add_credit_payment.delay_price.value) != 0 && document.add_credit_payment.debt_account_code4.value == "")
		{
			alert("<cf_get_lang dictionary_id='54539.Lütfen Gecikme Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		for(r=1;r<=document.add_credit_payment.record_num.value;r++)
		{
			if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
			{
				<cfif is_budget_control eq 1>
					if(filterNum(eval('document.add_credit_payment.tax_price_'+r).value) > 0 && eval('document.add_credit_payment.tax_expense_id_'+r).value == "")
					{
						alert("<cf_get_lang no='53.Lütfen Vergi Gider Kalemi Seçiniz'> !");
						return false;
					}
				</cfif>
				if(filterNum(eval('document.add_credit_payment.tax_price_'+r).value) > 0 && eval('document.add_credit_payment.debt_account_id3_'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='54540.Lütfen Vergi Muhasebe Kodu Seçiniz'>");
					return false;
				}
			}
		}
		unformat_fields();
		return true;
	}
	function pencere_ac_acc2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_payment.debt_account_id' + no +'&field_name=add_credit_payment.debt_account_code' + no +'','list');
	}
	function write_total_amount(type)
	{ 
		if(type == undefined) type = 1;
		bank_currency_type = list_getat(document.getElementById("action_from_account_id").value,2,';');
		if(bank_currency_type == '')
			bank_currency_type = '<cfoutput>#session.ep.money#</cfoutput>'
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			if(document.add_credit_payment.rd_money[s-1].checked == true)
				form_txt_rate2_ = document.getElementById("txt_rate2_"+s).value;
				
			if(bank_currency_type != '' &&  document.getElementById("hidden_rd_money_"+s).value == bank_currency_type)
				form_txt_rate2_2 = document.getElementById("txt_rate2_"+s).value;
		}
		<cfoutput>
			if(type == 1)
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("capital_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("interest_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("delay_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.add_credit_payment.record_num.value;r++)
					{
						if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
						{
							if(eval('document.add_credit_payment.tax_price_'+r).value != "")
				    			eval('document.add_credit_payment.tax_price_other_'+r).value = commaSplit(parseFloat(filterNum(eval('document.add_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
			else
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("capital_price").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("interest_price").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("delay_price").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.add_credit_payment.record_num.value;r++)
					{
						if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
						{
							if(eval('document.add_credit_payment.tax_price_other_'+r).value != "")
				    			eval('document.add_credit_payment.tax_price_'+r).value = commaSplit(parseFloat(filterNum(eval('document.add_credit_payment.tax_price_other_'+r).value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
		var total_price = 0;
		var other_total_price = 0;
		var system_amount = 0;
		if(document.add_credit_payment.capital_price.value != "")
			total_price += parseFloat(filterNum(add_credit_payment.capital_price.value));
		if(document.add_credit_payment.interest_price.value != "")
			total_price += parseFloat(filterNum(add_credit_payment.interest_price.value));
		if(document.add_credit_payment.delay_price.value != "")
			total_price += parseFloat(filterNum(add_credit_payment.delay_price.value));
		for(r=1;r<=document.add_credit_payment.record_num.value;r++)
		{
			if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
			{
				if(eval('document.add_credit_payment.tax_price_'+r).value != "")
					total_price += parseFloat(filterNum(eval('document.add_credit_payment.tax_price_'+r).value));
			}
		}
		if(document.add_credit_payment.capital_price_other.value != "")
			other_total_price += parseFloat(filterNum(add_credit_payment.capital_price_other.value));
		if(document.add_credit_payment.interest_price_other.value != "")
			other_total_price += parseFloat(filterNum(add_credit_payment.interest_price_other.value));
		if(document.add_credit_payment.delay_price_other.value != "")
			other_total_price += parseFloat(filterNum(add_credit_payment.delay_price_other.value));
		for(r=1;r<=document.add_credit_payment.record_num.value;r++)
		{
			if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
			{
				if(eval('document.add_credit_payment.tax_price_other_'+r).value != "")
					other_total_price += parseFloat(filterNum(eval('document.add_credit_payment.tax_price_other_'+r).value));
			}
		}
		rate_2 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
		document.add_credit_payment.cash_action_value.value = commaSplit(total_price,'#session.ep.our_company_info.rate_round_num#');
		document.add_credit_payment.other_cash_act_value.value = commaSplit(other_total_price,'#session.ep.our_company_info.rate_round_num#');
		document.add_credit_payment.system_amount_value.value = commaSplit(parseFloat(total_price)*rate_2,'#session.ep.our_company_info.rate_round_num#');			
		</cfoutput>
	}
	function unformat_fields()
	{
		<cfoutput>
			document.add_credit_payment.capital_price.value = filterNum(document.add_credit_payment.capital_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_payment.interest_price.value = filterNum(document.add_credit_payment.interest_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_payment.delay_price.value = filterNum(document.add_credit_payment.delay_price.value,'#session.ep.our_company_info.rate_round_num#');
			for(r=1;r<=document.add_credit_payment.record_num.value;r++)
			{
				if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
				{
					if(eval('document.add_credit_payment.tax_price_'+r).value != "")
						eval('document.add_credit_payment.tax_price_'+r).value = filterNum(eval('document.add_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#');
				}
			}
			document.add_credit_payment.cash_action_value.value = filterNum(document.add_credit_payment.cash_action_value.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_payment.other_cash_act_value.value = filterNum(document.add_credit_payment.other_cash_act_value.value,'#session.ep.our_company_info.rate_round_num#');
			add_credit_payment.system_amount.value = filterNum(add_credit_payment.system_amount.value,'#session.ep.our_company_info.rate_round_num#');
			add_credit_payment.system_amount_value.value = filterNum(add_credit_payment.system_amount_value.value,'#session.ep.our_company_info.rate_round_num#');
			for(var i=1;i<=add_credit_payment.kur_say.value;i++)
			{
				eval('add_credit_payment.txt_rate1_' + i).value = filterNum(eval('add_credit_payment.txt_rate1_' + i).value,'#session.ep.our_company_info.rate_round_num#');
				eval('add_credit_payment.txt_rate2_' + i).value = filterNum(eval('add_credit_payment.txt_rate2_' + i).value,'#session.ep.our_company_info.rate_round_num#');
			}
		</cfoutput>
	}
	function showDepartment(no)	
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=credit.popup_ajax_list_branch&action_from_account_id="+no;

		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
	
</script>
    </cfif>
    <cfif attributes.event eq 'updPayment'>
    	<cf_xml_page_edit fuseact="credit.popup_add_credit_payment">
		<cfif not len(url.credit_contract_row_id)>
            <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
            <cfexit method="exittemplate">
        </cfif>
        <cfif not isdefined("attributes.period_id")><cfset attributes.period_id = session.ep.period_id></cfif>
        <cfif not isdefined("attributes.our_company_id")><cfset attributes.our_company_id = session.ep.company_id></cfif>
        <cfquery name="GET_PERIOD" datasource="#DSN#">
            SELECT
                *
            FROM
                SETUP_PERIOD
            WHERE
                PERIOD_ID = #attributes.period_id# AND
                OUR_COMPANY_ID = #attributes.our_company_id#
        </cfquery> 
        <cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
        <cfquery name="get_credit_contract_payment" datasource="#temp_dsn#">
            SELECT
                *
            FROM
                CREDIT_CONTRACT_PAYMENT_INCOME
            WHERE
                CREDIT_CONTRACT_PAYMENT_ID = #url.credit_contract_row_id#
        </cfquery>
        <cfif not isdefined("url.credit_contract_id")><cfset url.credit_contract_id = GET_CREDIT_CONTRACT_PAYMENT.CREDIT_CONTRACT_ID></cfif>
        <cfquery name="get_credit_contract_payment_tax" datasource="#temp_dsn#">
            SELECT
                CC.*,
                EX.EXPENSE_ITEM_NAME
            FROM
                CREDIT_CONTRACT_PAYMENT_INCOME_TAX CC
                LEFT JOIN EXPENSE_ITEMS EX ON EX.EXPENSE_ITEM_ID = CC.TAX_EXPENSE_ITEM_ID
            WHERE
                CC.CREDIT_CONTRACT_PAYMENT_ID = #url.credit_contract_row_id#
        </cfquery>
        <cfquery name="credit_contract_money" datasource="#dsn3#">
            SELECT MONEY_TYPE FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
        </cfquery>
        <cfquery name="get_project_from_bank_actions" datasource="#dsn2#">
            SELECT PROJECT_ID FROM BANK_ACTIONS WHERE ACTION_ID = #GET_CREDIT_CONTRACT_PAYMENT.BANK_ACTION_ID#
        </cfquery>
        <cfif not GET_CREDIT_CONTRACT_PAYMENT.recordcount>
            <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
            <cfexit method="exittemplate">
        </cfif>
        <cfif is_capital_budget_act neq 0>
			<cfif len(get_credit_contract_payment.capital_expense_item_id)>
                <cfquery name="GET_EXPENSE_CAPITAL" datasource="#dsn2#">
                    SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_credit_contract_payment.capital_expense_item_id#
                </cfquery>
            </cfif>
        </cfif>
        <cfif len(get_credit_contract_payment.interest_expense_item_id)>
            <cfquery name="GET_EXPENSE_INTEREST" datasource="#dsn2#">
                SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_credit_contract_payment.interest_expense_item_id#
            </cfquery>
        </cfif>
		<cfif len(get_credit_contract_payment.delay_expense_item_id)>
            <cfquery name="GET_EXPENSE_DELAY" datasource="#dsn2#">
                SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_credit_contract_payment.delay_expense_item_id#
            </cfquery>
        </cfif>
        <cfset attributes.expense_center_id = get_credit_contract_payment.EXPENSE_CENTER_ID>
        <cfset attributes.capital_price = get_credit_contract_payment.CAPITAL_PRICE>
        <cfset attributes.capital_account_id = get_credit_contract_payment.CAPITAL_EXPENSE_ITEM_ID_ACC >
        <cfset attributes.capital_expense_item_id = get_credit_contract_payment.capital_expense_item_id >
        <cfset attributes.interest_price = get_credit_contract_payment.interest_price>
        <cfset attributes.interest_account_id = get_credit_contract_payment.INTEREST_EXPENSE_ITEM_ID_ACC>
        <cfset attributes.expense_item_id = get_credit_contract_payment.interest_expense_item_id>
        <cfif attributes.expense_item_id neq ''>
        	<cfset attributes.expense_item_name = get_expense_interest.expense_item_name>
        <cfelse>
        	<cfset attributes.expense_item_name = ''>
        </cfif>
        <cfif attributes.capital_expense_item_id neq ''>
        	<cfset attributes.expense_item_name = get_expense_capital.expense_item_name>
        <cfelse>
        	<cfset attributes.expense_item_name = ''>
        </cfif>
          <cfset attributes.tax_price = 0>
          <cfset attributes.total_account_id = "">
          <cfset attributes.total_expense_item_id = "">
          <cfset attributes.total_price = get_credit_contract_payment.total_price>
        <script type="text/javascript">
			$( document ).ready(function() {
				<cfif get_credit_contract_payment_tax.recordcount>
					row_count = <cfoutput>#get_credit_contract_payment_tax.recordcount#</cfoutput>;
				<cfelse>
					row_count = 1;
				</cfif>
				kur_ekle_f_hesapla('action_from_account_id');
				write_total_amount();
				var deneme = document.getElementById('action_from_account_id').value.split(";",1);
				showDepartment(deneme);	
			});
	
	function sil(sy)
	{
		var my_element=eval("upd_credit_payment.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		write_total_amount();
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;	
		document.upd_credit_payment.record_num.value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tax_price_'+ row_count +'" id="tax_price_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount();kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tax_price_other_'+ row_count +'" id="tax_price_other_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ' <input type="hidden" name="debt_account_id3_'+ row_count +'" id="debt_account_id3_'+ row_count +'" value=""><input type="text" style="width:130px;" name="debt_account_code3_'+ row_count +'" id="debt_account_code3_'+ row_count +'" value="" onFocus="auto_account('+ row_count +');">   <a href="javascript://" onClick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ' <input type="hidden" name="tax_expense_id_'+ row_count +'" id="tax_expense_id_'+ row_count +'" value=""><input type="text" style="width:130px;" name="tax_expense_'+ row_count +'" id="tax_expense_'+ row_count +'" value="" onFocus="auto_expense('+ row_count +');">   <a href="javascript://" onClick="pencere_ac_expense('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"> <a href="javascript://" onclick="sil(' + row_count + ');"><img src="/images/delete_list.gif" border="0" alt="sil" align="absmiddle"></a>';
	}
	function auto_account(no)
	{
		AutoComplete_Create('debt_account_code3_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id3_'+no,'upd_credit_payment','3','140');
	}
	function auto_expense(no)
	{
		AutoComplete_Create('tax_expense_'+no,'EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','tax_expense_id_'+no+',debt_account_code3_'+no+',debt_account_id3_'+no,'upd_credit_payment','3');
	}	
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_credit_payment.debt_account_id3_' + no +'&field_name=upd_credit_payment.debt_account_code3_' + no +'','list');
	}
	function pencere_ac_expense(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_credit_payment.tax_expense_id_' + no +'&field_name=upd_credit_payment.tax_expense_' + no +'&field_account_no=upd_credit_payment.debt_account_id3_' + no +'&field_account_no2=upd_credit_payment.debt_account_code3_' + no +'','list');
	}
	function del_kontrol() 
	{
		return control_account_process(<cfoutput>'#get_credit_contract_payment.credit_contract_payment_id#','#get_credit_contract_payment.process_type#'</cfoutput>)
	}
	function kontrol()
	{	debugger;	
		control_account_process(<cfoutput>'#get_credit_contract_payment.credit_contract_payment_id#','#get_credit_contract_payment.process_type#'</cfoutput>);
		process=document.upd_credit_payment.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		/* tarih kontrolu */
		if(get_process_cat.IS_ACCOUNT == 1 && document.getElementById('payment_date').value != "")
			if(!chk_period(upd_credit_payment.payment_date,"İşlem")) return false;
		
		if(!chk_process_cat('upd_credit_payment')) return false;
		if(!check_display_files('upd_credit_payment')) return false;
		
		<cfif is_company_required eq 1>
			if(document.upd_credit_payment.company_id.value=='')	
			{
				alert("<cf_get_lang no='16.Lütfen Kredi Kurumu Seçiniz'>!");
				return false;
			}
		</cfif>	
		x = document.upd_credit_payment.action_from_account_id.selectedIndex;
		
		if (document.upd_credit_payment.action_from_account_branch.value == "")
		{
			alert('<cf_get_lang_main no='1521.Banka Şubeleri'> <cf_get_lang_main no='322.Seçiniz'> ! ');
			return false;
		}	
		
		if (document.upd_credit_payment.action_from_account_id[x].value == "")
		{
			alert("<cf_get_lang no='49.Banka Hesabı Seçiniz'> !");
			return false;
		}	
		
		if (document.upd_credit_payment.expense_center_id.value == "")
		{
			alert("<cf_get_lang no='50.Masraf Merkezi Seçiniz'> !");
			return false;
		}
	
		if(document.upd_credit_payment.payment_date.value == "")
		{
			alert("<cf_get_lang no='40.Lütfen Ödeme Tarihi Giriniz'> !");
			return false;
		}
		<cfif is_budget_control eq 1>
		if(document.upd_credit_payment.is_capital_budget_act.value == 1 && filterNum(document.upd_credit_payment.capital_price.value) != 0 && document.upd_credit_payment.capital_expense.value == "")
		{
			alert('<cf_get_lang no='51.Lütfen Ana Para Gider Kalemi Seçiniz '>! ');
			return false;		
		}
		</cfif>
		if(filterNum(document.upd_credit_payment.capital_price.value) != 0 && document.upd_credit_payment.debt_account_code.value == "")
		{
			alert("<cf_get_lang dictionary_id='54541.Lütfen Ana Para Muhasebe Kodu Seçiniz'>");
			return false;
		}
		<cfif is_budget_control eq 1>
			if(filterNum(document.upd_credit_payment.capital_price.value) != 0 && document.upd_credit_payment.capital_expense_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='54541.Lütfen Ana Para Gider Kalemi Seçiniz'>");
				return false;
			}
		</cfif>
		if(filterNum(document.upd_credit_payment.interest_price.value) != 0 && document.upd_credit_payment.debt_account_code2.value == "")
		{
			alert("<cf_get_lang dictionary_id='51405.Lütfen Faiz Muhasebe Kodu Seçiniz'>!");
			return false;
		}	
		<cfif is_budget_control eq 1>
			if(filterNum(document.upd_credit_payment.interest_price.value) != 0 && document.upd_credit_payment.interest_expense_id.value == "")
			{
				alert('<cf_get_lang no='52.Lütfen Faiz Gider Kalemi Seçiniz'>!');
				return false;
			}
		</cfif>
		if(filterNum(document.upd_credit_payment.delay_price.value) != 0 && document.upd_credit_payment.debt_account_code4.value == "")
		{
			alert("<cf_get_lang dictionary_id='54539.Lütfen Gecikme Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		<cfif is_budget_control eq 1>
			if(filterNum(document.upd_credit_payment.delay_price.value) != 0 && document.upd_credit_payment.delay_expense_id.value == "")
			{
				alert('<cf_get_lang no='54.Lütfen Gecikme Gider Kalemi Seçiniz'> !');
				return false;
			}
		</cfif>
		for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
		{
			if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
			{
				if(filterNum(eval('document.upd_credit_payment.tax_price_'+r).value) > 0 && eval('document.upd_credit_payment.debt_account_id3_'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='54540.Lütfen Vergi Muhasebe Kodu Seçiniz'>");
					return false;
				}
				<cfif is_budget_control eq 1>
					if(filterNum(eval('document.upd_credit_payment.tax_price_'+r).value) > 0 && eval('document.upd_credit_payment.tax_expense_id_'+r).value == "")
					{
						alert('<cf_get_lang no='53.Lütfen Vergi Gider Kalemi Seçiniz'> !');
						return false;
					}
				</cfif>
			}
		}
		unformat_fields();
		return true;
	}
	
	function write_total_amount(type)
	{  
		if(type == undefined) type = 1;
		bank_currency_type = list_getat(document.getElementById("action_from_account_id").value,2,';');
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{	
			if(document.upd_credit_payment.rd_money[s-1].checked == true)
				form_txt_rate2_ = document.getElementById("txt_rate2_"+s).value;
				
			if(bank_currency_type != '' &&  document.getElementById("hidden_rd_money_"+s).value == bank_currency_type)
				form_txt_rate2_2 = document.getElementById("txt_rate2_"+s).value;
			else
				{
					deneme= document.getElementById("session_money_id").value;
					if(deneme != '' &&  document.getElementById("hidden_rd_money_"+s).value == deneme)
					form_txt_rate2_2 = document.getElementById("txt_rate2_"+s).value;
				}
		}
		<cfoutput>
			if(type == 1)
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("capital_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("interest_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("delay_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
					{
						if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
						{
							if(eval('document.upd_credit_payment.tax_price_'+r).value != "")
				    			eval('document.upd_credit_payment.tax_price_other_'+r).value = commaSplit(parseFloat(filterNum(eval('document.upd_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
			else
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("capital_price").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("interest_price").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("delay_price").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
					{
						if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
						{
							if(eval('document.upd_credit_payment.tax_price_other_'+r).value != "")
				    			eval('document.upd_credit_payment.tax_price_'+r).value = commaSplit(parseFloat(filterNum(eval('document.upd_credit_payment.tax_price_other_'+r).value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
		var total_price = 0;
		var other_total_price = 0;
		var system_amount = 0;
		if(document.upd_credit_payment.capital_price.value != "")
			total_price += parseFloat(filterNum(upd_credit_payment.capital_price.value,'#session.ep.our_company_info.rate_round_num#'));
		if(document.upd_credit_payment.interest_price.value != "")
			total_price += parseFloat(filterNum(upd_credit_payment.interest_price.value,'#session.ep.our_company_info.rate_round_num#'));
		if(document.upd_credit_payment.delay_price.value != "")
			total_price += parseFloat(filterNum(upd_credit_payment.delay_price.value,'#session.ep.our_company_info.rate_round_num#'));
		for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
		{
			if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
			{
				if(eval('document.upd_credit_payment.tax_price_'+r).value != "")
					total_price += parseFloat(filterNum(eval('document.upd_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
			}
		}
		if(document.upd_credit_payment.capital_price_other.value != "")
			other_total_price += parseFloat(filterNum(upd_credit_payment.capital_price_other.value));
		if(document.upd_credit_payment.interest_price_other.value != "")
			other_total_price += parseFloat(filterNum(upd_credit_payment.interest_price_other.value));
		if(document.upd_credit_payment.delay_price_other.value != "")
			other_total_price += parseFloat(filterNum(upd_credit_payment.delay_price_other.value));
		for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
		{
			if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
			{
				if(eval('document.upd_credit_payment.tax_price_other_'+r).value != "")
					other_total_price += parseFloat(filterNum(eval('document.upd_credit_payment.tax_price_other_'+r).value));
			}
		}
		rate_2 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
		document.upd_credit_payment.cash_action_value.value = commaSplit(total_price,'#session.ep.our_company_info.rate_round_num#');
		document.upd_credit_payment.other_cash_act_value.value = commaSplit(other_total_price,'#session.ep.our_company_info.rate_round_num#');
		document.upd_credit_payment.system_amount_value.value = commaSplit(parseFloat(total_price)*rate_2,'#session.ep.our_company_info.rate_round_num#');
		</cfoutput>
	}
	
	function unformat_fields()
	{
		<cfoutput>
			document.upd_credit_payment.capital_price.value = filterNum(document.upd_credit_payment.capital_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.upd_credit_payment.interest_price.value = filterNum(document.upd_credit_payment.interest_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.upd_credit_payment.delay_price.value = filterNum(document.upd_credit_payment.delay_price.value,'#session.ep.our_company_info.rate_round_num#');
			for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
			{
				if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
				{
					if(eval('document.upd_credit_payment.tax_price_'+r).value != "")
						eval('document.upd_credit_payment.tax_price_'+r).value = filterNum(eval('document.upd_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#');
				}
			}
			document.upd_credit_payment.cash_action_value.value = filterNum(document.upd_credit_payment.cash_action_value.value,'#session.ep.our_company_info.rate_round_num#');
			document.upd_credit_payment.other_cash_act_value.value = filterNum(document.upd_credit_payment.other_cash_act_value.value,'#session.ep.our_company_info.rate_round_num#');
			upd_credit_payment.system_amount.value = filterNum(upd_credit_payment.system_amount.value,'#session.ep.our_company_info.rate_round_num#');
			upd_credit_payment.system_amount_value.value = filterNum(upd_credit_payment.system_amount_value.value,'#session.ep.our_company_info.rate_round_num#');
			for(var i=1;i<=upd_credit_payment.kur_say.value;i++)
			{
				eval('upd_credit_payment.txt_rate1_' + i).value = filterNum(eval('upd_credit_payment.txt_rate1_' + i).value,'#session.ep.our_company_info.rate_round_num#');
				eval('upd_credit_payment.txt_rate2_' + i).value = filterNum(eval('upd_credit_payment.txt_rate2_' + i).value,'#session.ep.our_company_info.rate_round_num#');
			}
		</cfoutput>
	}
	
	function showDepartment(no)	
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=credit.popup_ajax_list_branch&action_from_account_id="+no+"&credit_contract_row_id="+<cfoutput>#url.credit_contract_row_id#</cfoutput>;
	
			AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
		}
</script>
    </cfif>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'credit.list_credit_contract';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'credit/display/list_credit_contract.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'credit.add_credit_contract';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'credit/form/add_credit_contract.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'credit/query/add_credit_contract.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'credit.list_credit_contract&event=det';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('credit_contract','credit_contract_bask')";
	
	WOStruct['#attributes.fuseaction#']['addPayment'] = structNew();
	WOStruct['#attributes.fuseaction#']['addPayment']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['addPayment']['fuseaction'] = 'credit.popup_add_credit_payment';
	WOStruct['#attributes.fuseaction#']['addPayment']['filePath'] = 'credit/form/add_credit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['addPayment']['queryPath'] = 'credit/query/add_credit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['addPayment']['nextEvent'] = 'credit.list_credit_contract&event=det';
	
	WOStruct['#attributes.fuseaction#']['updPayment'] = structNew();
	WOStruct['#attributes.fuseaction#']['updPayment']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['updPayment']['fuseaction'] = 'credit.popup_upd_credit_payment';
	WOStruct['#attributes.fuseaction#']['updPayment']['filePath'] = 'credit/form/add_credit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['updPayment']['queryPath'] = 'credit/query/upd_credit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['updPayment']['nextEvent'] = 'credit.list_credit_contract&event=det';
	WOStruct['#attributes.fuseaction#']['updPayment']['parameters'] = 'credit_contract_id=##attributes.credit_contract_id##';
	WOStruct['#attributes.fuseaction#']['updPayment']['Identity'] = '##attributes.credit_contract_id##';
	
	if(IsDefined("attributes.event") and attributes.event eq 'updPayment')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updPayment'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updPayment']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updPayment']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updPayment']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_credit_contract_payment.credit_contract_payment_id#&process_cat=#get_credit_contract_payment.process_type#','page','add_process')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(IsDefined("attributes.event") and attributes.event eq 'updRevenue')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updRevenue'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updRevenue']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updRevenue']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updRevenue']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_credit_contract_payment.credit_contract_payment_id#&process_cat=#get_credit_contract_payment.process_type#','page','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updRevenue']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updRevenue']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updRevenue']['icons']['add']['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=addRevenue";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updRevenue']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(IsDefined("attributes.event") and attributes.event eq 'upd')
	{
		if(get_credit_contract.process_type eq 296)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.credit_contract_id#&process_cat=#get_credit_contract.process_type#','page','upd_gelenh')";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=credit.list_credit_contract&event=add&credit_contract_id=#url.credit_contract_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(IsDefined("attributes.event") and (attributes.event eq 'updPayment' or attributes.event eq 'updRevenue' or attributes.event eq 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'credit.emptypopup_del_credit_payment&old_process_type=#get_credit_contract_payment.process_type#&bank_action_id=#get_credit_contract_payment.bank_action_id#&credit_contract_payment_id=#get_credit_contract_payment.credit_contract_payment_id#&temp_dsn=#dsn#_#get_period.period_year#_#get_period.our_company_id#&period_id=#get_period.period_id#&company_id=#get_period.our_company_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'credit/query/del_credit_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'credit/query/del_credit_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'credit.list_credit_contract&event=det';
	}
	
	 if(IsDefined("attributes.event") and attributes.event eq 'det')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=credit.detail_credit_contract&action_name=credit_contract_id&action_id=#attributes.credit_contract_id#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#lang_array_main.item[52]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['href'] = '#request.self#?fuseaction=credit.list_credit_contract&event=upd&credit_contract_id=#get_credit_contract.credit_contract_id#';
		
		if(get_credit_contract.process_type neq 296)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array_main.item[435]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=addPayment&credit_contract_id=#get_credit_contract.credit_contract_id#&project_id=#get_credit_contract.project_id#','project')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['text'] = '#lang_array_main.item[433]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=addRevenue&credit_contract_id=#get_credit_contract.credit_contract_id#&project_id=#get_credit_contract.project_id#','project')";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array_main.item[433]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.credit_contract_id#&process_cat=#get_credit_contract.process_type#','page','upd_gelenh')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['addRevenue'] = structNew();
	WOStruct['#attributes.fuseaction#']['addRevenue']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addRevenue']['fuseaction'] = 'credit.popup_add_credit_revenue';
	WOStruct['#attributes.fuseaction#']['addRevenue']['filePath'] = 'credit/form/add_credit_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['addRevenue']['queryPath'] = 'credit/query/add_credit_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['addRevenue']['nextEvent'] = 'credit.list_credit_contract&event=det';
	
	WOStruct['#attributes.fuseaction#']['updRevenue'] = structNew();
	WOStruct['#attributes.fuseaction#']['updRevenue']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['updRevenue']['fuseaction'] = 'credit.popup_upd_credit_revenue';
	WOStruct['#attributes.fuseaction#']['updRevenue']['filePath'] = 'credit/form/add_credit_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['updRevenue']['queryPath'] = 'credit/query/upd_credit_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['updRevenue']['nextEvent'] = 'credit.list_credit_contract&event=det';
	WOStruct['#attributes.fuseaction#']['updRevenue']['parameters'] = 'credit_contract_id=##attributes.credit_contract_id##';
	WOStruct['#attributes.fuseaction#']['updRevenue']['Identity'] = '##attributes.credit_contract_id##';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'credit.detail_credit_contract';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'credit/display/detail_credit_contract.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'credit/display/detail_credit_contract.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'credit.list_credit_contract&event=det';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'credit_contract_id=##attributes.credit_contract_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.credit_contract_id##';
	WOStruct['#attributes.fuseaction#']['det']['js'] = "javascript:gizle_goster_ikili('credit_contract','credit_contract_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'credit.upd_credit_contract';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'credit/form/add_credit_contract.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'credit/query/upd_credit_contract.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'credit.list_credit_contract&event=det';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'credit_contract_id=##attributes.credit_contract_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.credit_contract_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('credit_contract','credit_contract_bask')";
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'creditContract';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CREDIT_CONTRACT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-2','item-3']"; 
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'creditContract';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CREDIT_CONTRACT_PAYMENT_INCOME';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-2','item-3']"; 
</cfscript>

