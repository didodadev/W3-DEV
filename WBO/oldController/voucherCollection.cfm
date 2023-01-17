<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.list_payment_voucher">
<cfparam name="attributes.is_payment" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.paper_type" default="">
<cfquery name="get_money" datasource="#dsn2#">
	SELECT 
    	MONEY_ID, 
        MONEY, 
        RATE1, 
        RATE2, 
        COMPANY_ID, 
        RATE3, 
        DSP_UPDATE_DATE
    FROM 
    	SETUP_MONEY 
    ORDER BY 
    	MONEY_ID
</cfquery>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset attributes.company = get_par_info(attributes.company_id,1,0,0)>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset attributes.company = get_cons_info(attributes.consumer_id,0,0)>
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="get_law_request" datasource="#dsn#">
		SELECT FILE_NUMBER FROM COMPANY_LAW_REQUEST WHERE COMPANY_ID = #attributes.company_id# AND REQUEST_STATUS = 1
	</cfquery>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="get_law_request" datasource="#dsn#">
		SELECT FILE_NUMBER FROM COMPANY_LAW_REQUEST WHERE CONSUMER_ID = #attributes.consumer_id# AND REQUEST_STATUS = 1
	</cfquery>
<cfelse>
	<cfset get_law_request.recordcount = 0>
</cfif>
<cfset payroll_id_list=''>
<cfif (isDefined("attributes.company_id") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id))>
	<cfquery name="get_voucher_actions" datasource="#dsn2#">
		SELECT
			VP.*,
			VPA.ACTION_ID AS ACT_ID,
			VPA.ACTION_TYPE_ID,
            C.CASH_NAME,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME EMPLOYEE
		FROM
			VOUCHER_PAYROLL VP
			LEFT JOIN VOUCHER_PAYROLL_ACTIONS VPA ON VP.ACTION_ID = VPA.PAYROLL_ID
            LEFT JOIN CASH C ON C.CASH_ID = VP.PAYROLL_CASH_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = VP.PAYROLL_REV_MEMBER
		WHERE
			VP.PAYROLL_TYPE = 1057
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			AND VP.COMPANY_ID = #attributes.company_id#
		<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND VP.CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif fusebox.circuit is "store">
			AND VP.PAYROLL_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN(SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#))
		</cfif>
		ORDER BY PAYROLL_REVENUE_DATE
	</cfquery>
	<cfquery name="get_all_vouchers" datasource="#dsn2#">
		SELECT
			VOUCHER.VOUCHER_STATUS_ID,
			VOUCHER.VOUCHER_ID,
			VOUCHER.VOUCHER_NO,
			VOUCHER.CURRENCY_ID,
			VOUCHER.VOUCHER_DUEDATE,
			VOUCHER.VOUCHER_CODE,
			VOUCHER.OTHER_MONEY_VALUE,
			VOUCHER.DELAY_INTEREST_SYSTEM_VALUE,
			VOUCHER.EARLY_PAYMENT_SYSTEM_VALUE,
			VOUCHER.IS_PAY_TERM,
			VOUCHER_PAYROLL.PAYROLL_NO,
			VOUCHER_PAYROLL.ACTION_ID,
			VOUCHER_PAYROLL.COMPANY_ID,
			VOUCHER_PAYROLL.PAYROLL_ACCOUNT_ID,
			ISNULL(VOUCHER.CASH_ID,VOUCHER_PAYROLL.PAYROLL_CASH_ID) PAYROLL_CASH_ID,
			VOUCHER_PAYROLL.PAYMENT_ORDER_ID,
			VOUCHER_PAYROLL.CONSUMER_ID,
			SP.DELAY_INTEREST_DAY,
			ISNULL(SP.DELAY_INTEREST_RATE,0) DELAY_INTEREST_RATE,
			ISNULL(SP.FIRST_INTEREST_RATE,0) FIRST_INTEREST_RATE,
			SP.IN_ADVANCE,
			SP.DUE_MONTH,
			SP.DUE_DATE_RATE
		FROM
			VOUCHER VOUCHER,
			VOUCHER_PAYROLL VOUCHER_PAYROLL,
			#dsn_alias#.SETUP_PAYMETHOD SP
		WHERE
			VOUCHER.VOUCHER_ID IS NOT NULL AND
			VOUCHER_PAYROLL.PAYMETHOD_ID = SP.PAYMETHOD_ID AND 
			VOUCHER.VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND 
			VOUCHER.CURRENCY_ID = '#session.ep.money#'
			<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
				AND (VOUCHER_PAYROLL.COMPANY_ID = #attributes.company_id# OR VOUCHER.COMPANY_ID = #attributes.company_id#)
			<cfelseif len(attributes.company) and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
				AND (VOUCHER_PAYROLL.CONSUMER_ID = #attributes.consumer_id# OR VOUCHER.CONSUMER_ID = #attributes.consumer_id#)
			<cfelseif isdefined("attributes.employee_id") and len(attributes.company) and len(attributes.employee_id) and attributes.member_type eq 'employee'>
				AND (VOUCHER_PAYROLL.EMPLOYEE_ID = #attributes.employee_id# OR VOUCHER.EMPLOYEE_ID = #attributes.employee_id#)
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND VOUCHER_PAYROLL.PAYROLL_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
			</cfif>
			<cfif isdefined("attributes.paper_type") and len(attributes.paper_type)>
				AND VOUCHER.IS_PAY_TERM = #attributes.paper_type#
			</cfif>
		<cfif x_is_dsp_all_voucher eq 1>
			UNION ALL
			SELECT
				VOUCHER.VOUCHER_STATUS_ID,
				VOUCHER.VOUCHER_ID,
				VOUCHER.VOUCHER_NO,
				VOUCHER.CURRENCY_ID,
				VOUCHER.VOUCHER_DUEDATE,
				VOUCHER.VOUCHER_CODE,
				VOUCHER.OTHER_MONEY_VALUE,
				VOUCHER.DELAY_INTEREST_SYSTEM_VALUE,
				VOUCHER.EARLY_PAYMENT_SYSTEM_VALUE,
				VOUCHER.IS_PAY_TERM,
				VOUCHER_PAYROLL.PAYROLL_NO,
				VOUCHER_PAYROLL.ACTION_ID,
				VOUCHER_PAYROLL.COMPANY_ID,
				VOUCHER_PAYROLL.PAYROLL_ACCOUNT_ID,
				ISNULL(VOUCHER.CASH_ID,VOUCHER_PAYROLL.PAYROLL_CASH_ID) PAYROLL_CASH_ID,
				VOUCHER_PAYROLL.PAYMENT_ORDER_ID,
				VOUCHER_PAYROLL.CONSUMER_ID,
				0 DELAY_INTEREST_DAY,
				0 DELAY_INTEREST_RATE,
				0 FIRST_INTEREST_RATE,
				0 IN_ADVANCE,
				0 DUE_MONTH,
				0 DUE_DATE_RATE
			FROM
				VOUCHER VOUCHER,
				VOUCHER_PAYROLL VOUCHER_PAYROLL
			WHERE
				VOUCHER.VOUCHER_ID IS NOT NULL AND
				VOUCHER_PAYROLL.PAYMETHOD_ID IS NULL AND 
				VOUCHER.VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND 
				VOUCHER.CURRENCY_ID = '#session.ep.money#'
				<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
					AND (VOUCHER_PAYROLL.COMPANY_ID = #attributes.company_id# OR VOUCHER.COMPANY_ID = #attributes.company_id#)
				<cfelseif len(attributes.company) and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
					AND (VOUCHER_PAYROLL.CONSUMER_ID = #attributes.consumer_id# OR VOUCHER.CONSUMER_ID = #attributes.consumer_id#)
				<cfelseif isdefined("attributes.employee_id") and len(attributes.company) and len(attributes.employee_id) and attributes.member_type eq 'employee'>
					AND (VOUCHER_PAYROLL.EMPLOYEE_ID = #attributes.employee_id# OR VOUCHER.EMPLOYEE_ID = #attributes.employee_id#)
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND VOUCHER_PAYROLL.PAYROLL_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
				<cfif isdefined("attributes.paper_type") and len(attributes.paper_type)>
					AND VOUCHER.IS_PAY_TERM = #attributes.paper_type#
				</cfif>
		</cfif>
		ORDER BY
			VOUCHER.VOUCHER_DUEDATE
	</cfquery>
	<cfquery name="get_vouchers" dbtype="query">
		SELECT
			*
		FROM
			get_all_vouchers
		WHERE
			<cfif isdefined("attributes.is_payment") and attributes.is_payment eq 2>
				VOUCHER_STATUS_ID = 3
			<cfelseif isdefined("attributes.is_payment") and attributes.is_payment eq 1> 
				VOUCHER_STATUS_ID IN(1,11,10)
			<cfelse>
				VOUCHER_STATUS_ID IN(1,11,10,3,9)
			</cfif>
		ORDER BY
			VOUCHER_DUEDATE
	</cfquery>
<cfelse>
	<cfset get_voucher_actions.recordcount = 0>
</cfif>
<cfset member_type = "">
<cfif not (isdefined("attributes.consumer_id") and len(attributes.consumer_id))>
	<cfset attributes.consumer_id = ''>
    <cfif not (isdefined("attributes.company_id") and len(attributes.company_id))>
    	<cfset attributes.company = ''>
    <cfelse>
    	<cfset member_type = "partner">
    </cfif>
</cfif>
<cfif not (isdefined("attributes.company_id") and len(attributes.company_id))>
	<cfset attributes.company_id = ''>
    <cfif not (isdefined("attributes.consumer_id") and len(attributes.consumer_id))>
    	<cfset attributes.company = ''>
    <cfelse>
    	<cfset member_type = "consumer">
    </cfif>
</cfif>
<script type="text/javascript">
	function sayfa_getir(no,action_id)
	{
		gizle_goster(eval('document.all.voucher_info'+no));
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#</cfoutput>.emptypopup_display_pay_vouchers&action_id='+action_id,'show_voucher_info'+no);
	}
	<cfif (isDefined("attributes.company_id") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id))>
		var control_checked=0;
		row_count=0;
		function kontrol()
		{
			if((document.add_voucher_action.company.value=="" || document.add_voucher_action.company_id.value=="")&&(document.add_voucher_action.company.value=="" || document.add_voucher_action.consumer_id.value=="")&&(document.add_voucher_action.company.value=="" || document.add_voucher_action.employee_id.value==""))
			{
				alert("<cf_get_lang no ='177.Cari Hesap Seçiniz '>!");
				return false;
			}
			return true;
		}
		function kontrol2()
		{
			if (!chk_process_cat('add_voucher_action')) return false;
			if(!check_display_files('add_voucher_action')) return false;
			if(!chk_period(add_voucher_action.action_date, 'İşlem')) return false;
			if(add_voucher_action.kasa!= undefined && add_voucher_action.cash_amount != undefined && add_voucher_action.cash_amount.value != 0)
			{
				add_voucher_action.cash.value=1;
			}		
			if(add_voucher_action.pos_amount != undefined && add_voucher_action.pos_amount.value != 0)
			{
				add_voucher_action.is_pos.value=1;
			}
			if(add_voucher_action.bank_amount != undefined && add_voucher_action.bank_amount.value != 0)
			{
				add_voucher_action.is_bank.value=1;
			}
			if(add_voucher_action.cash.value == 1 && (add_voucher_action.paper_code.value =='' || add_voucher_action.paper_number.value ==''))
			{
			  alert("<cf_get_lang no ='217.Makbuz No Giriniz'> !");
			  return false;
			}
			if(add_voucher_action.action_date.value == '')
			{
			  alert("<cf_get_lang no ='218.İşlem Tarihi Giriniz'> !");
			  return false;
			}
			if(control_checked==0)
			{
				alert("<cf_get_lang no ='219.Tahsilat İşlemi İçin En Az Bir Senet Seçmelisiniz '>!");
				return false;
			}
			if(filterNum(add_voucher_action.total_interest_amount.value) > 0)
			{
				if(document.add_voucher_action.expense_item_name.value =="" || document.add_voucher_action.expense_item_id.value =="")
				{
					alert("Gecikme Cezası İçin Gelir Kalemi Seçmelisiniz !");
					return false;
				}
				if(document.add_voucher_action.expense_center.value =="" || document.add_voucher_action.expense_center_id.value =="")
				{
					alert("Gecikme Cezası İçin Gelir Merkezi Seçmelisiniz !");
					return false;
				}
			}
			var voucher_list='';//Tam kapanan senetler
			var voucher_list_2='';//Tüm senetler
			var voucher_list_3='';//Yarım kapanan senetler
			for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
			{		
				if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
				{
					if(eval('add_voucher_action.is_pay_'+i).checked)	
					{
						if(list_len(voucher_list_2,',') == 0)
							voucher_list_2+=eval("document.add_voucher_action.voucher_id_" + i+".value");//Üzerinde işlem yapılan tüm senetler
						else
							voucher_list_2+=","+eval("document.add_voucher_action.voucher_id_" + i+".value");
						deger_satir_other = eval('add_voucher_action.other_money_value_'+i).value;//Senetin değeri
						deger_satir_other = filterNum(deger_satir_other);
						deger_satir = eval('add_voucher_action.new_closed_amount_'+i).value;//Yeni kapanan değer
						deger_satir = filterNum(deger_satir);
						deger_satir_kapanan = eval('add_voucher_action.voucher_closed_amount_'+i).value;//Önceki işlemde kapanan değer
						deger_satir_kapanan = filterNum(deger_satir_kapanan);
						deger_satir_delay = eval('add_voucher_action.delay_interest_value_'+i).value;//Faiz değeri
						deger_satir_delay = filterNum(deger_satir_delay);
						deger_satir_voucher = eval('add_voucher_action.new_delay_closed_amount_'+i).value;//Yeni kapanan faiz değeri
						deger_satir_voucher = filterNum(deger_satir_voucher);				
						deger_satir_kapanan_delay = eval('add_voucher_action.delay_closed_amount_'+i).value;//Önceki işlemde kapanan faiz
						deger_satir_kapanan_delay = filterNum(deger_satir_kapanan_delay);
						deger_toplam = parseFloat(deger_satir_other) + parseFloat(deger_satir_delay) ;
						deger_toplam2 = parseFloat(deger_satir) + parseFloat(deger_satir_voucher)+ parseFloat(deger_satir_kapanan) + parseFloat(deger_satir_kapanan_delay);
						deger_toplam2 = wrk_round(deger_toplam2);
						deger_toplam = wrk_round(deger_toplam);
						if (deger_toplam2 == deger_toplam)
						{
							if(list_len(voucher_list,',') == 0)
								voucher_list+=eval("document.add_voucher_action.voucher_id_" + i+".value");//Tamamen kapatılmış olan senetler
							else
								voucher_list+=","+eval("document.add_voucher_action.voucher_id_" + i+".value");
						}
						else
						{
							if(list_len(voucher_list_3,',') == 0)
								voucher_list_3+=eval("document.add_voucher_action.voucher_id_" + i+".value");//Yarım kapatılmış olan senetler
							else
								voucher_list_3+=","+eval("document.add_voucher_action.voucher_id_" + i+".value");
						}
					}
				}
			}
			if(add_voucher_action.cash_amount != undefined)
			{
				add_voucher_action.cash_amount.value=filterNum(add_voucher_action.cash_amount.value);
			}
			if(add_voucher_action.pos_amount != undefined)
			{
				add_voucher_action.pos_amount.value=filterNum(add_voucher_action.pos_amount.value);
				add_voucher_action.com_amount.value=filterNum(add_voucher_action.com_amount.value);
				add_voucher_action.system_pos_amount.value=filterNum(add_voucher_action.system_pos_amount.value);
			}
			if(add_voucher_action.bank_amount != undefined)
			{
				add_voucher_action.bank_amount.value=filterNum(add_voucher_action.bank_amount.value);
				add_voucher_action.system_bank_amount.value=filterNum(add_voucher_action.system_bank_amount.value);
			}
			add_voucher_action.total_interest_amount.value=filterNum(add_voucher_action.total_interest_amount.value);
			add_voucher_action.company_id.value = document.add_voucher_action.company_id.value;
			add_voucher_action.consumer_id.value = document.add_voucher_action.consumer_id.value;
			add_voucher_action.voucher_ids.value = voucher_list;
			add_voucher_action.voucher_ids_2.value = voucher_list_2;
			add_voucher_action.voucher_ids_3.value = voucher_list_3;
			add_voucher_action.submit();
			add_voucher_action.action='';
			return true;
		}
		function kontrol3()
		{
			company_id = document.add_voucher_action.company_id.value;
			consumer_id = document.add_voucher_action.consumer_id.value;
			if(control_checked==0)
			{
				alert("<cf_get_lang no ='220.En Az Bir Senet Seçmelisiniz'> !");
				return false;
			}
			var voucher_list='';
			var total_value=0;
			var total_due_value=0;
			for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
			{		
				if(list_find('1,2,5,6,8,10',eval('add_voucher_action.voucher_status_'+i).value)) 
				{
					if(eval('add_voucher_action.is_pay_'+i).checked)	
					{
						if(list_len(voucher_list,',') == 0)
							voucher_list+=eval("document.add_voucher_action.voucher_id_" + i+".value");
						else
							voucher_list+=","+eval("document.add_voucher_action.voucher_id_" + i+".value");
						total_value = total_value + parseFloat(filterNum(eval("document.add_voucher_action.f_other_money_value_" + i+".value")));	
						total_due_value = total_due_value + (filterNum(eval("document.add_voucher_action.f_other_money_value_" + i+".value"))* datediff(add_voucher_action.action_date.value,eval("document.add_voucher_action.due_date_" + i+".value"),0));
					}
				}
			}
			if(total_value != 0)
				due_day = total_due_value / total_value;
			else
				due_day = 0;
			document.add_voucher_action.total_system_amount.value = commaSplit(filterNum(document.add_voucher_action.total_system_amount.value));
			windowopen('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_add_payment_with_voucher<cfif isdefined("company_id") and len(company_id)>&company_id='+company_id+'<cfelse>&company_id=</cfif><cfif isdefined("consumer_id") and len(consumer_id)>&consumer_id='+consumer_id+'<cfelse>&consumer_id=</cfif>&due_day='+due_day+'&net_total='+total_value+'&voucher_list='+voucher_list+'</cfoutput>','page');
			return false;
		}
		function check_kontrol(nesne)
		{
			if(nesne.checked)
				control_checked++;
			else
				control_checked--;
			total_amount();
		}
		function total_amount()
		{
			var total_amounts = 0;
			var total_interest = 0;
			var total_discount = 0;
			for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
			{		
				if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
				{
					if(eval('add_voucher_action.is_pay_'+i).checked)	
					{
						deger_satir_other = eval('add_voucher_action.other_money_value_'+i).value;//Senetin değeri
						deger_satir_other = filterNum(deger_satir_other);
						deger_satir = eval('add_voucher_action.voucher_closed_amount_'+i).value;//Kapatılmış değer
						deger_satir = filterNum(deger_satir);
						deger_satir_other_delay = eval('add_voucher_action.delay_interest_value_'+i).value;//Faiz değeri
						deger_satir_other_delay = filterNum(deger_satir_other_delay);
						deger_satir_delay = eval('add_voucher_action.delay_closed_amount_'+i).value;//Kapanmış faiz
						deger_satir_delay = filterNum(deger_satir_delay);
						deger_satir_discount = eval('add_voucher_action.payment_discount'+i).value;//Erken ödeme indirimi
						deger_satir_discount = filterNum(deger_satir_discount);
						total_interest = total_interest + parseFloat(deger_satir_other_delay)-parseFloat(deger_satir_delay);
						total_discount = total_discount + parseFloat(deger_satir_discount);
						total_amounts = total_amounts + parseFloat(deger_satir_other)-parseFloat(deger_satir);
						total_amounts = total_amounts + parseFloat(deger_satir_other_delay)-parseFloat(deger_satir_delay);
						eval('add_voucher_action.new_closed_amount_'+i).value =  commaSplit(parseFloat(deger_satir_other)-parseFloat(deger_satir));
						eval('add_voucher_action.new_delay_closed_amount_'+i).value = commaSplit(parseFloat(deger_satir_other_delay)-parseFloat(deger_satir_delay));
					}
					else
					{
						eval('add_voucher_action.new_closed_amount_'+i).value = 0;
						eval('add_voucher_action.new_delay_closed_amount_'+i).value = 0;
					}
				}
			}
			document.add_voucher_action.total_system_amount.value = commaSplit(total_amounts);
			document.add_voucher_action.total_interest_amount.value = commaSplit(total_interest);
			if(document.add_voucher_action.action_type[0].checked == true)
			{
				document.add_voucher_action.cash_amount.value = commaSplit(total_amounts);
				document.add_voucher_action.system_cash_amount.value = total_amounts;
			}
			else if(document.add_voucher_action.action_type[2].checked == true)
			{
				document.add_voucher_action.pos_amount_first.value = commaSplit(total_amounts);
				document.add_voucher_action.system_pos_amount_first.value = total_amounts;
				pos_hesapla(1);
			}
			else if(document.add_voucher_action.bank_amount != undefined)
			{
				document.add_voucher_action.bank_amount.value = commaSplit(total_amounts);
				document.add_voucher_action.system_bank_amount.value = total_amounts;
			}
		}
		function satir_hesapla(type)
		{
			if(type != undefined)
			{
				toplam = 0;
				for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
				{
					if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
					{
						deger_satir_ = eval('add_voucher_action.new_closed_amount_'+i).value;
						deger_satir_ = filterNum(deger_satir_);
						toplam = toplam +  parseFloat(deger_satir_);
					}
				}
				document.add_voucher_action.total_system_amount.value = commaSplit(toplam);
				if(document.add_voucher_action.action_type[0].checked == true)
				{
					document.add_voucher_action.cash_amount.value = commaSplit(toplam);
					document.add_voucher_action.system_cash_amount.value = toplam;
				}
				else if(document.add_voucher_action.action_type[2].checked == true)
				{
					document.add_voucher_action.pos_amount_first.value = commaSplit(toplam);
					document.add_voucher_action.system_pos_amount_first.value = toplam;
					pos_hesapla(1);
				}
				else if(document.add_voucher_action.bank_amount != undefined)
				{
					document.add_voucher_action.bank_amount.value = commaSplit(toplam);
					document.add_voucher_action.system_bank_amount.value = toplam;
				}
			}
			else
			{
				my_total_amount = document.add_voucher_action.total_system_amount.value;
				for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
				{
					if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value) && eval("document.add_voucher_action.is_pay_" + i).checked == true) 
					{
						var form_field = eval("document.add_voucher_action.is_pay_" + i);
						form_field.checked = false;
						control_checked--;
					}
				}
				last_value = document.add_voucher_action.total_system_amount.value;
				last_value = filterNum(last_value);
				for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
				{
					if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
					{
						closed_amount_delay = 0;
						closed_amount = 0;
						deger_satir_1 = eval('add_voucher_action.delay_interest_value_'+i).value;
						deger_satir_1 = filterNum(deger_satir_1);
						deger_satir_2 = eval('add_voucher_action.delay_closed_amount_'+i).value;
						deger_satir_2 = filterNum(deger_satir_2);
						deger_satir_voucher_1 = eval('add_voucher_action.other_money_value_'+i).value;
						deger_satir_voucher_1 = filterNum(deger_satir_voucher_1);
						deger_satir_voucher_2 = eval('add_voucher_action.voucher_closed_amount_'+i).value;
						deger_satir_voucher_2 = filterNum(deger_satir_voucher_2);
						deger_satir = parseFloat(deger_satir_1) - parseFloat(deger_satir_2);
						deger_satir_voucher = parseFloat(deger_satir_voucher_1) - parseFloat(deger_satir_voucher_2);
						if(last_value >= deger_satir && deger_satir != 0) 
						{
							last_value = last_value - parseFloat(deger_satir);
							closed_amount_delay = parseFloat(closed_amount_delay) + parseFloat(deger_satir);
							var form_field = eval("document.add_voucher_action.is_pay_" + i);
							form_field.checked = true;
							control_checked++;
						}
						else if (last_value > 0 && deger_satir != 0)
						{
							closed_amount_delay = parseFloat(closed_amount_delay) + parseFloat(last_value);
							last_value = 0;
							var form_field = eval("document.add_voucher_action.is_pay_" + i);
							form_field.checked = true;
							control_checked++;
						}
						if(last_value >= deger_satir_voucher && deger_satir_voucher != 0) 
						{
							last_value = last_value - parseFloat(deger_satir_voucher);
							closed_amount = parseFloat(closed_amount)+ parseFloat(deger_satir_voucher);
							var form_field = eval("document.add_voucher_action.is_pay_" + i);
							form_field.checked = true;
							control_checked++;
						}
						else if (last_value > 0 && deger_satir_voucher != 0)
						{
							closed_amount = parseFloat(closed_amount) + parseFloat(last_value);
							last_value = 0;
							var form_field = eval("document.add_voucher_action.is_pay_" + i);
							form_field.checked = true;
							control_checked++;
						}
						eval('add_voucher_action.new_closed_amount_'+i).value = commaSplit(closed_amount);
						eval('add_voucher_action.new_delay_closed_amount_'+i).value = commaSplit(closed_amount_delay);
					}
				}
			}
		}
		function check_all(deger)
		{
			<cfif get_vouchers.recordcount>
				if(add_voucher_action.all_voucher.checked)
				{
					for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
					{
						if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
						{
							var form_field = eval("document.add_voucher_action.is_pay_" + i);
							form_field.checked = true;
							control_checked++;
							eval('add_voucher_action.is_pay_'+i).focus();
							eval('add_voucher_action.new_closed_amount_'+i).value = eval('add_voucher_action.other_money_value_'+i).value;
							eval('add_voucher_action.new_delay_closed_amount_'+i).value = eval('add_voucher_action.delay_interest_value_'+i).value;
						}
					}
				}
				else
				{
					for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
					{
						if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
						{
							var form_field = eval("document.add_voucher_action.is_pay_" + i);
							form_field.checked = false;
							control_checked--;
							eval('add_voucher_action.is_pay_'+i).focus();
							eval('add_voucher_action.new_closed_amount_'+i).value = 0;
							eval('add_voucher_action.new_delay_closed_amount_'+i).value = 0;
						}
					}			
				}
			</cfif>
			total_amount();
		}
		function kasa_dovizi_hesapla()
		{	
			var currency_type = eval(add_voucher_action.kasa.options[add_voucher_action.kasa.selectedIndex]).value;
			money_type = currency_type.split(';')[1];
			for(s=1;s<=add_voucher_action.kur_say.value;s++)
			{
				if(eval('add_voucher_action.hidden_rd_money_'+s).value == money_type)
				{
					kasa_money_rate2 = eval('add_voucher_action.txt_rate2_' + s).value;
					kasa_money_rate1 = eval('add_voucher_action.txt_rate1_' + s).value;	
				}
			}
			if (add_voucher_action.cash_amount!=undefined && add_voucher_action.cash_amount.value!= "")
			{
				sistem_tutar=(parseFloat(filterNum(add_voucher_action.cash_amount.value))*(parseFloat(filterNum(kasa_money_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>))/parseFloat(filterNum(kasa_money_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>))));
				add_voucher_action.system_cash_amount.value=wrk_round(sistem_tutar);
			}
			if(document.add_voucher_action.system_pos_amount_first != undefined)
			{
				add_voucher_action.pos_amount.value=0;
				add_voucher_action.system_pos_amount.value=0;
				add_voucher_action.pos_amount_first.value=0;
				add_voucher_action.system_pos_amount_first.value=0;
				add_voucher_action.com_amount.value=0;
			}
			if(document.add_voucher_action.bank_amount != undefined)
			{
				add_voucher_action.bank_amount.value=0;
				add_voucher_action.system_bank_amount.value=0;
			}
			toplam_tahsilat();
		}
		function banka_dovizi_hesapla()
		{	
			var currency_type = eval(add_voucher_action.action_to_account_id.options[add_voucher_action.action_to_account_id.selectedIndex]).value;
			money_type = currency_type.split(';')[1];
			for(s=1;s<=add_voucher_action.kur_say.value;s++)
			{
				if(eval('add_voucher_action.hidden_rd_money_'+s).value == money_type)
				{
					bank_money_rate2 = eval('add_voucher_action.txt_rate2_' + s).value;
					bank_money_rate1 = eval('add_voucher_action.txt_rate1_' + s).value;	
				}
			}
			if (add_voucher_action.bank_amount!=undefined && add_voucher_action.bank_amount.value!= "")
			{
				sistem_tutar=(filterNum(add_voucher_action.bank_amount.value)*(filterNum(bank_money_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>)/filterNum(bank_money_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>)));
				add_voucher_action.system_bank_amount.value=wrk_round(sistem_tutar);
			}
			if(document.add_voucher_action.system_pos_amount_first != undefined)
			{
				add_voucher_action.pos_amount.value=0;
				add_voucher_action.system_pos_amount.value=0;
				add_voucher_action.pos_amount_first.value=0;
				add_voucher_action.system_pos_amount_first.value=0;
				add_voucher_action.com_amount.value=0;
			}
			add_voucher_action.cash_amount.value=0;
			add_voucher_action.system_cash_amount.value=0;
			toplam_tahsilat();
		}
		function pos_hesapla(type)
		{	
			add_voucher_action.cash_amount.value=0;
			add_voucher_action.system_cash_amount.value=0;
			if(document.add_voucher_action.bank_amount != undefined)
			{
				add_voucher_action.bank_amount.value=0;
				add_voucher_action.system_bank_amount.value=0;
			}
			if(add_voucher_action.pos_amount_first!= undefined)
			{
				if(add_voucher_action.pos_amount_first.value!="")
				{
					pos_money_list=new Array(1);
					<cfoutput query="get_money">
						pos_money_list.push('#get_money.money#');
					</cfoutput>
					for(var jxj=1; jxj<=pos_money_list.length-1; jxj++ )
					{	
						pos_deger = add_voucher_action.pos.value.split(';');
						pos_currency=pos_deger[1];
						payment_rate=pos_deger[2];
						if(pos_money_list[jxj] == pos_currency)
							{
								temp_pos_amount= add_voucher_action.pos_amount_first.value;
								temp_rate2=eval('add_voucher_action.txt_rate2_' + jxj).value;
								temp_rate1=eval('add_voucher_action.txt_rate1_' + jxj).value;
								new_value = filterNum(temp_pos_amount)*(filterNum(temp_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>)/filterNum(temp_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>));
								add_voucher_action.system_pos_amount_first.value=commaSplit(new_value);
								temp_pos_amount_= add_voucher_action.pos_amount_first.value;
								if(payment_rate != '')
								{
									pos_amount = filterNum(temp_pos_amount_) * (parseFloat(payment_rate)/100);
									add_voucher_action.com_amount.value =commaSplit(pos_amount);
								}
								else
									add_voucher_action.com_amount.value = 0;
								add_voucher_action.pos_amount.value = commaSplit(parseFloat(filterNum(add_voucher_action.pos_amount_first.value))+ parseFloat(filterNum(add_voucher_action.com_amount.value)));
								new_value2 =filterNum(add_voucher_action.pos_amount.value)* (filterNum(temp_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>)/filterNum(temp_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>));
								add_voucher_action.system_pos_amount.value =commaSplit(new_value2);
							}
					}
				}
				else
					add_voucher_action.system_pos_amount.value=0;
				if(type == undefined)
					toplam_tahsilat();
			}
		}
		function toplam_tahsilat()
		{	
			tahsilat_tutari=0;
			if(document.add_voucher_action.action_type[0].checked == true && add_voucher_action.cash_amount != undefined && add_voucher_action.cash_amount.value!="")
				tahsilat_tutari = tahsilat_tutari+parseFloat(add_voucher_action.system_cash_amount.value);
			else if(document.add_voucher_action.action_type[2].checked == true && add_voucher_action.pos_amount != undefined && add_voucher_action.pos_amount.value!="")
				tahsilat_tutari = tahsilat_tutari+parseFloat(filterNum(add_voucher_action.system_pos_amount_first.value));
			else if(document.add_voucher_action.action_type[1].checked == true && add_voucher_action.bank_amount != undefined && add_voucher_action.bank_amount.value!="")
				tahsilat_tutari = tahsilat_tutari+parseFloat(add_voucher_action.system_bank_amount.value);
			if(add_voucher_action.total_system_amount != undefined) 
				add_voucher_action.total_system_amount.value=commaSplit(tahsilat_tutari);
			satir_hesapla();
		}
		function kont_action_type()
		{
			if(document.add_voucher_action.cash_amount.value != 0)
			{
				amount_info = document.add_voucher_action.cash_amount.value;
				system_amount_info = document.add_voucher_action.system_cash_amount.value;
			}
			else if(document.add_voucher_action.pos_amount_first != undefined && document.add_voucher_action.pos_amount_first.value != 0)
			{
				amount_info = document.add_voucher_action.pos_amount_first.value;
				system_amount_info = document.add_voucher_action.system_pos_amount_first.value;
			}
			else if(document.add_voucher_action.bank_amount != undefined && document.add_voucher_action.bank_amount.value != 0)
			{
				amount_info = document.add_voucher_action.bank_amount.value;
				system_amount_info = document.add_voucher_action.system_bank_amount.value;
			}
			else
			{
				amount_info = 0;
				system_amount_info = 0;
			}
			if(document.add_voucher_action.action_type[0].checked == true)
			{
				document.getElementById('cash_td_1').style.display = '';
				document.getElementById('cash_td_2').style.display = '';
				document.add_voucher_action.cash_amount.value = amount_info;
				document.add_voucher_action.system_cash_amount.value = system_amount_info;
				if(document.add_voucher_action.bank_amount != undefined)
				{
					document.getElementById('bank_td_1').style.display = 'none';
					document.getElementById('bank_td_2').style.display = 'none';
					document.add_voucher_action.bank_amount.value = 0;
					document.add_voucher_action.system_bank_amount.value = 0;
				}
				if(document.add_voucher_action.pos_amount_first != undefined)
				{
					document.getElementById('pos_td_1').style.display = 'none';
					document.getElementById('pos_td_2').style.display = 'none';
					document.add_voucher_action.pos_amount_first.value = 0;
					document.add_voucher_action.system_pos_amount_first.value = 0;
				}
				kasa_dovizi_hesapla();
			}
			else if(document.add_voucher_action.action_type[2].checked == true)
			{
				document.getElementById('cash_td_1').style.display = 'none';
				document.getElementById('cash_td_2').style.display = 'none';
				document.add_voucher_action.cash_amount.value = 0;
				document.add_voucher_action.system_cash_amount.value = 0;
				if(document.add_voucher_action.bank_amount != undefined)
				{
					document.getElementById('bank_td_1').style.display = 'none';
					document.getElementById('bank_td_2').style.display = 'none';
					document.add_voucher_action.bank_amount.value = 0;
					document.add_voucher_action.system_bank_amount.value = 0;
				}
				if(document.add_voucher_action.pos_amount_first != undefined)
				{
					document.getElementById('pos_td_1').style.display = '';
					document.getElementById('pos_td_2').style.display = '';
					document.add_voucher_action.pos_amount_first.value = amount_info;
					document.add_voucher_action.system_pos_amount_first.value = system_amount_info;
					pos_hesapla();
				}
			}
			else if(document.add_voucher_action.bank_amount != undefined)
			{
				document.getElementById('bank_td_1').style.display = '';
				document.getElementById('bank_td_2').style.display = '';
				document.getElementById('cash_td_1').style.display = 'none';
				document.getElementById('cash_td_2').style.display = 'none';
				document.add_voucher_action.bank_amount.value = amount_info;
				document.add_voucher_action.system_bank_amount.value = system_amount_info;
				document.add_voucher_action.cash_amount.value = 0;
				document.add_voucher_action.system_cash_amount.value = 0;
				if(document.add_voucher_action.pos_amount_first != undefined)
				{
					document.getElementById('pos_td_1').style.display = 'none';
					document.getElementById('pos_td_2').style.display = 'none';
					document.add_voucher_action.pos_amount_first.value = 0;
					document.add_voucher_action.system_pos_amount_first.value = 0;
				}
				banka_dovizi_hesapla();
			}
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cheque.list_payment_voucher';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cheque/display/list_payment_voucher.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.list_payment_voucher';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cheque/display/list_payment_voucher.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cheque/query/add_payment_voucher_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.list_payment_voucher';
	
	if(attributes.event is 'list')
	{
		if(isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company))
		{
			member_name = '#attributes.company#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
			if(get_module_user(33) and not listfindnocase(denied_pages,'report.bsc_company'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[207]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=partner&company_id=#attributes.company_id#&member_name=#member_name#&finance=1','wide' )";
			}
			if(not listfindnocase(denied_pages,'myhome.my_company_details'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#lang_array_main.item[163]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#attributes.company_id#";
			}
			if(not listfindnocase(denied_pages,'member.detail_company'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][2]['text'] = '#lang_array.item[208]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][2]['href'] = "#request.self#?fuseaction=member.detail_company&cpid=#attributes.company_id#";
			}
			if(not listfindnocase(denied_pages,'contract.detail_contract_company'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][3]['text'] = '#lang_array.item[209]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][3]['href'] = "#request.self#?fuseaction=contract.detail_contract_company&company_id=#attributes.company_id#";
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][4]['text'] = '#lang_array_main.item[397]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=ch.list_company_extre&member_type=partner&member_id=#attributes.company_id#&popup_page=1','page')";		
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.company))
		{
			member_name = '#attributes.company#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
			if(get_module_user(3) and not listfindnocase(denied_pages,'report.bsc_company'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[207]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=consumer&consumer_id=#attributes.consumer_id#&member_name=#member_name#&finance=1','wide')";
			}
			if(not listfindnocase(denied_pages,'myhome.my_consumer_details'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#lang_array_main.item[163]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['href'] = "#request.self#?fuseaction=myhome.my_consumer_details&cid=#attributes.consumer_id#";
			}
			if(not listfindnocase(denied_pages,'member.detail_consumer'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][2]['text'] = '#lang_array.item[208]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][2]['href'] = "#request.self#?fuseaction=member.detail_consumer&cid=#attributes.consumer_id#";
			}
			if(not listfindnocase(denied_pages,'contract.detail_contract_company'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][3]['text'] = '#lang_array.item[209]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][3]['href'] = "#request.self#?fuseaction=contract.detail_contract_company&consumer_id=#attributes.consumer_id#";
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][4]['text'] = '#lang_array_main.item[397]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=ch.list_comp_extre&member_type=consumer&member_id=#attributes.consumer_id#&popup_page=1','page')";		
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>
