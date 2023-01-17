
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('add,upd,addDebitPayment,updDebitPayment',attributes.event)>
	<cfif isdefined('form.active_period') and form.active_period neq session.ep.period_id>
		<script type="text/javascript">
			alertObject({message: "<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!",closeTime:3000});
		</script>
		<cfabort>
	</cfif>
    <cfquery name="get_paper_no" datasource="#DSN3#">
        SELECT CREDITCARD_PAYMENT_NO, CREDITCARD_PAYMENT_NUMBER FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
    </cfquery>
    <cfif isdefined('form.get_paper_no') and not (len(get_paper_no.CREDITCARD_PAYMENT_NO) and len(get_paper_no.CREDITCARD_PAYMENT_NUMBER))>
        <script type="text/javascript">
			alertObject({message: "<cf_get_lang_main no='1890.Lütfen Belge Numaralarınızı Tanımlayınız'>!",closeTime:3000});
        </script>
        <cfabort>
    </cfif>
    <cfif IsDefined('attributes.credit_card_info')>
        <cfquery name="GET_CREDIT_CARD" datasource="#dsn2#"><!--- Seçilen kredi kartının ek bilgileri --->
            SELECT 
                ISNULL(CLOSE_ACC_DAY,1) CLOSE_ACC_DAY,
                ACCOUNT_CODE
            FROM 
                #dsn3_alias#.CREDIT_CARD 
            WHERE 
                CREDITCARD_ID = #listgetat(attributes.credit_card_info,3,';')#
        </cfquery>
    </cfif>
    <cfif IsDefined('is_account') and is_account eq 1>
        <cfif isdefined('attributes.action_to_company_id') and len(attributes.action_to_company_id)><!--- firmanın muhasebe kodu --->
            <cfset my_acc_result = GET_COMPANY_PERIOD(attributes.action_to_company_id)>
        <cfelseif len(attributes.cons_id)><!---	bireysel uyenin muhasebe kodu--->
            <cfset my_acc_result = GET_CONSUMER_PERIOD(attributes.cons_id)>
        </cfif>
        <cfif not len(my_acc_result)>
            <script type="text/javascript">
				alertObject({message: "<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!",closeTime:3000});
            </script>
            <cfabort>
        </cfif>
        <cfif isdefined('GET_CREDIT_CARD') and not len(GET_CREDIT_CARD.ACCOUNT_CODE)>
            <script type="text/javascript">
				alertObject({message: "<cf_get_lang no ='395.Seçtiğiniz Kredi Kartının Muhasebe Kodu Seçilmemiş'>!",closeTime:3000});;	
            </script>
            <cfabort>
        </cfif>
    </cfif>
</cfif>
<cf_get_lang_set module_name="bank">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date_format" default="1">
<cfparam name="attributes.credit_card_info" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.bank_action_type" default="">
<cfparam name="attributes.list_type" default="1">	
<cfparam name="attributes.date_1" default="">	
<cfparam name="attributes.date_2" default="">	
<cfparam name="attributes.pay_date1" default="">
<cfparam name="attributes.pay_date2" default="">
<cfparam name="attributes.id" default="">
<cfparam name="attributes.active_period" default="#session.ep.period_id#">
<cfparam name="attributes.creditcard_id" default="">
<cfparam name="attributes.from_branch_id" default="">
<cfparam name="attributes.special_definition_id1" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.ACTION_TO_COMPANY_ID" default="">
<cfparam name="attributes.project_id1" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.assetp_id" default="">
<cfparam name="attributes.installment_number" default="">
<cfparam name="attributes.delay_info1" default="">
<cfparam name="attributes.paper_no" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.total_cost_value" default="">
<cfparam name="attributes.other_cost_value" default="">
<cfparam name="attributes.detail" default="">
<cfset action_date =now()>
<cfset process_cat = "">
<cfif IsDefined("attributes.event") and (attributes.event eq 'upd' or attributes.event eq 'add')>
	<cfif attributes.event eq 'upd'>
    	<cfquery name="GET_EXPENSE" datasource="#dsn3#">
            SELECT 
                CC.CREDITCARD_EXPENSE_ID,
                CC.PROCESS_CAT,
                CC.PROCESS_TYPE,
                CC.ACTION_DATE,
                CC.ACTION_TO_COMPANY_ID,
                CC.CONS_ID,
                CC.PAR_ID,
                ISNULL((C.CONSUMER_NAME +' '+C.CONSUMER_SURNAME),COM.FULLNAME) AS COMP_NAME ,
                CC.CREDITCARD_ID,
                CC.TOTAL_COST_VALUE,
                CC.OTHER_COST_VALUE,
                CC.OTHER_MONEY,
                CC.DETAIL,
                CC.PROJECT_ID,
                CC.PAPER_NO,
                CC.UPD_STATUS,
                CC.FROM_BRANCH_ID,
                CC.INSTALLMENT_NUMBER,
                CC.ACTION_PERIOD_ID,
                CC.ASSETP_ID,
                CC.SPECIAL_DEFINITION_ID,
                CC.EXPENSE_ID,
                CC.DELAY_INFO,
                CC.RECORD_EMP,
                CC.RECORD_DATE,
                CC.UPDATE_EMP,
                CC.UPDATE_DATE,
                PP.PROJECT_HEAD
            FROM 
                CREDIT_CARD_BANK_EXPENSE  CC
                LEFT JOIN #dsn_alias#.CONSUMER C ON C.CONSUMER_ID = CC.CONS_ID
                LEFT JOIN #dsn_alias#.COMPANY COM ON COM.COMPANY_ID = CC.ACTION_TO_COMPANY_ID
                LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = CC.PROJECT_ID
            WHERE 
                CC.CREDITCARD_EXPENSE_ID = #attributes.id#
        </cfquery>
        <cfquery name="CONTROL_INFO" datasource="#dsn3#">
            SELECT
                CRR.BANK_ACTION_ID,
                CRR.BANK_ACTION_PERIOD_ID,
                CR.INSTALLMENT_DETAIL,
                CR.INSTALLMENT_AMOUNT,
                CRR.CLOSED_AMOUNT
            FROM
                CREDIT_CARD_BANK_EXPENSE_RELATIONS CRR,
                CREDIT_CARD_BANK_EXPENSE_ROWS CR
            WHERE
                CRR.CC_BANK_EXPENSE_ROWS_ID = CR.CC_BANK_EXPENSE_ROWS_ID AND
                CR.CREDITCARD_EXPENSE_ID = #attributes.id# AND
                CRR.BANK_ACTION_ID IS NOT NULL
        </cfquery> 
     	<cfset attributes.id =attributes.id>
		<cfset attributes.process_type =GET_EXPENSE.process_type>
        <cfset attributes.active_period=session.ep.period_id>
        <cfset attributes.creditcard_id=get_expense.creditcard_id>
        <cfset process_cat =get_expense.process_cat>
        <cfset attributes.from_branch_id=get_expense.from_branch_id>
        <cfset attributes.special_definition_id1=get_expense.special_definition_id>
        <cfset attributes.cons_id=get_expense.cons_id>
        <cfset attributes.par_id = get_expense.par_id>
        <cfset attributes.ACTION_TO_COMPANY_ID = get_expense.ACTION_TO_COMPANY_ID>
        <cfset attributes.project_id1 = GET_EXPENSE.project_id>
        <cfset attributes.comp_name = GET_EXPENSE.COMP_NAME>
        <cfset attributes.project_head = GET_EXPENSE.project_head>
        <cfset attributes.assetp_id = get_expense.assetp_id>
        <cfset attributes.installment_number = get_expense.installment_number>
        <cfset attributes.delay_info1 = get_expense.delay_info>
        <cfset attributes.paper_no = get_expense.paper_no>
        <cfset paper_num = get_expense.paper_no>
        <cfset action_date =get_expense.action_date>
        <cfset attributes.total_cost_value = get_expense.total_cost_value>
        <cfset attributes.other_cost_value = get_expense.other_cost_value>
        <cfset attributes.detail = get_expense.detail>   
	</cfif>
	<script type="text/javascript">
		<cfif attributes.event eq 'upd'>
			function del_kontrol()
			{
				return control_account_process(<cfoutput>'#attributes.id#','#get_expense.process_type#'</cfoutput>);
				if(!chk_period(credit_card_expense.action_date,'İşlem')) return false;
				else return true;
			}
		</cfif>
		function kontrol()
		{  
			<cfif   attributes.event eq 'upd'>
				return control_account_process(<cfoutput>'#attributes.id#','#get_expense.process_type#'</cfoutput>);
			</cfif>
			if (!chk_process_cat('credit_card_expense')) return false;
			if(!check_display_files('credit_card_expense')) return false;
			if(!chk_period(document.credit_card_expense.action_date, 'İşlem')) return false;
			return true;
		}
		$(document).ready(function(){
			kur_ekle_f_hesapla('credit_card_info');	
		});
	</script>
</cfif>
<cfif (not IsDefined("attributes.event") or attributes.event eq 'list' ) >
	<cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_CREDIT" datasource="#dsn3#">
            SELECT
                CBE.ACTION_PERIOD_ID,
                CBE.CREDITCARD_EXPENSE_ID,
                CBE.PROCESS_TYPE,
                CBE.ACTION_DATE,
                CBE.ACTION_TO_COMPANY_ID,
                CBE.CONS_ID,
                CBE.ACTION_CURRENCY_ID,
                CBE.TOTAL_COST_VALUE,
                CBE.DETAIL,
                CBE.PAPER_NO,
                CBE.EXPENSE_ID,						
                ACCOUNTS.ACCOUNT_NAME,
                CREDIT_CARD.CREDITCARD_NUMBER,
                ISNULL(CREDIT_CARD.PAYMENT_DAY,0) PAYMENT_DAY
            <cfif  len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
                ,CC_BANK_EXPENSE_ROWS_ID
                ,CC_ACTION_DATE
                ,ACC_ACTION_DATE
                ,CARD_LIMIT
                ,CREDIT_CARD.MONEY_CURRENCY
                ,INSTALLMENT_DETAIL
                ,INSTALLMENT_AMOUNT
                ,ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0) CLOSED_AMOUNT
            </cfif>
            ,CONSUMER.CONSUMER_NAME
            ,CONSUMER.CONSUMER_SURNAME
            ,COMPANY.FULLNAME
            FROM
                CREDIT_CARD_BANK_EXPENSE CBE 
                LEFT JOIN
                    #DSN_ALIAS#.CONSUMER
                ON
                     CONSUMER.CONSUMER_ID = CBE.CONS_ID
                LEFT JOIN
                    #DSN_ALIAS#.COMPANY
                ON
                    COMPANY.COMPANY_ID=CBE.ACTION_TO_COMPANY_ID            
                ,ACCOUNTS AS ACCOUNTS,
                CREDIT_CARD AS CREDIT_CARD
            <cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
                ,CREDIT_CARD_BANK_EXPENSE_ROWS
            </cfif>
            WHERE
            <cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
                CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CBE.CREDITCARD_EXPENSE_ID AND
                <cfif len(attributes.credit_card_info)>
                    CBE.ACCOUNT_ID = #listgetat(attributes.credit_card_info,1,';')# AND
                    CBE.CREDITCARD_ID = #listgetat(attributes.credit_card_info,3,';')# AND
                </cfif>
            </cfif>
                ACCOUNTS.ACCOUNT_ID = CBE.ACCOUNT_ID AND
                CREDIT_CARD.CREDITCARD_ID = CBE.CREDITCARD_ID
                <cfif len(attributes.keyword)>
                    AND
                    (
                        CBE.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        CBE.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    )
                </cfif>
                <cfif len(attributes.date_1)>AND CBE.ACTION_DATE >= #attributes.date_1#</cfif>
                <cfif len(attributes.date_2)>AND CBE.ACTION_DATE < #DATEADD("d",1,attributes.date_2)#</cfif>
                <cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
                    <cfif len(attributes.pay_date1)>AND DATEADD(d,PAYMENT_DAY,ACC_ACTION_DATE) >= #attributes.pay_date1#</cfif>
                    <cfif len(attributes.pay_date2)>AND DATEADD(d,PAYMENT_DAY,ACC_ACTION_DATE) < #DATEADD("d",1,attributes.pay_date2)#</cfif>
                    <cfif len(attributes.date_1)>AND CC_ACTION_DATE >= #attributes.date_1#</cfif>
                    <cfif len(attributes.date_2)>AND CC_ACTION_DATE < #DATEADD("d",1,attributes.date_2)#</cfif>
                </cfif>
                <cfif len(attributes.company_id) and len(attributes.member_name)>
                    AND CBE.ACTION_TO_COMPANY_ID = #attributes.company_id#
                <cfelseif len(attributes.cons_id) and len(attributes.member_name)>
                    AND CBE.CONS_ID = #attributes.cons_id#
                </cfif>
                <cfif isDefined("attributes.check_payment_info")>
                    AND ROUND((INSTALLMENT_AMOUNT-(ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0))),2) > 0
                </cfif>
                <cfif isDefined("attributes.bank_action_type") and len(attributes.bank_action_type)>
                    AND CBE.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_action_type#">
                </cfif>
            ORDER BY
              <cfif len(attributes.date_format) and (attributes.date_format eq 1)>
                CBE.ACTION_DATE DESC
              <cfelse>
                CBE.ACTION_DATE
    </cfif>
        </cfquery>
    <cfelse>
    	<cfset get_credit.recordcount = 0>
    </cfif>
	<cfscript>
        getCCNOKey = createObject("component", "settings.cfc.setupCcnoKey");
        getCCNOKey.dsn = dsn;
        getCCNOKey1 = getCCNOKey.getCCNOKey1();
        getCCNOKey2 = getCCNOKey.getCCNOKey2();
    </cfscript>
    <cfif not isdefined('attributes.date_1') and not len(attributes.date_1)>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.date_1=''>
        <cfelse>
            <cfparam name="attributes.date_1" default="#dateformat(now(),'dd/mm/yyyy')#">
        </cfif>
    </cfif>
    <cfif not isdefined('attributes.date_2') and not len(attributes.date_2)>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.date_2=''>
        <cfelse>
            <cfparam name="attributes.date_2" default="#createodbcdate(date_add('d',1,now()))#">
        </cfif>
    </cfif>
    <cfif not isdefined('attributes.pay_date1') and not len(attributes.pay_date1)>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.pay_date1=''>
        <cfelse>
            <cfparam name="attributes.pay_date1" default="#dateformat(now(),'dd/mm/yyyy')#">
        </cfif>
    </cfif>
    <cfif not isdefined('attributes.pay_date2') and not len(attributes.pay_date2)>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.pay_date2=''>
        <cfelse>
            <cfparam name="attributes.pay_date2" default="#createodbcdate(date_add('d',1,now()))#">
        </cfif>
    </cfif>
    <cfquery name="get_money" datasource="#dsn2#">
        SELECT MONEY FROM SETUP_MONEY
    </cfquery>
    <cfparam name="attributes.totalrecords" default='#get_credit.recordcount#'>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
    <script type="text/javascript">
		function add_debit_payment()
		{
			document.getElementById('exp_info').innerHTML ='';
			var exp_count = 0;
			var _check_len_ = document.getElementsByName('_cc_expense_').length;
			var cc_expense_url = '&exp_row_count='+_check_len_+'';
			member_id_list_1='';
			member_id_list_2='';
			for(var _cl_ind_=0; _cl_ind_ < _check_len_; _cl_ind_++){
				if(document.getElementsByName('_cc_expense_')[_cl_ind_].checked && document.getElementsByName('_cc_expense_')[_cl_ind_].style.display != 'none')
				{//checkbox seçili ise..
					exp_count++;
					var amount = document.getElementsByName('_cc_expense_amount_')[_cl_ind_].value;
					var expense_row_id = document.getElementsByName('_cc_expense_')[_cl_ind_].value;
					var expense_type = document.getElementById('process_type_'+expense_row_id).value;
					var newInput = document.createElement("input"); newInput.type = 'text';	newInput.name = 'exp_amount'+exp_count+''; newInput.value=filterNum(amount);
					var newInput2 = document.createElement("input"); newInput2.type = 'text';	newInput2.name = 'exp_row_id'+exp_count+''; newInput2.value=expense_row_id;
					document.getElementById('exp_info').appendChild(newInput);
					document.getElementById('exp_info').appendChild(newInput2);
					if(expense_type == 246)
						member_id_list_1+=expense_row_id;
					else
						member_id_list_2+=expense_row_id;
				}
			}
			if(exp_count == 0)
			{
				alertObject({message: "<cf_get_lang no='304. Seçim Yapmadınız'>!",closeTime:3000});
				return false;
			}
			if(member_id_list_1 != '' && member_id_list_2 != '')
			{
				alertObject({message: "<cf_get_lang dictionary_id='48908.Kredi Kartı Ödeme ve İptal İşlemlerini Birlikte Seçemezsiniz'>!!",closeTime:3000});
				return false;
			}
			if(member_id_list_1 != '') process_type = 248; else process_type = 244;
			windowopen('','medium','cc_paym');
			pop_gonder.action='<cfoutput>#request.self#?fuseaction=bank.list_credit_card_expense&event=addDebitPayment&process_type='+process_type+'&exp_count='+exp_count+'<cfif IsDefined("attributes.credit_card_info") and len(attributes.credit_card_info)>&cc_info=#ListGetAt(attributes.credit_card_info,3,';')#</cfif></cfoutput>';
			pop_gonder.target='cc_paym';
			pop_gonder.submit();
			document.getElementById('debt_paym_button').disabled = true;
			return false;
		}
		function show_date_info(type)
		{
			if(type == 0)
			{
				if(document.list_credit_card_expense.list_type.value == 1)
					gizle(pay_date);
				else
					goster(pay_date);
			}
			else
			{
				if(document.list_credit_card_expense.credit_card_info.value != '')
				{
					document.list_credit_card_expense.list_type.value = 2;
					gizle(type_list);
				}
				else
					goster(type_list);
	
				if(document.list_credit_card_expense.list_type.value == 1)
					gizle(pay_date);
				else
					goster(pay_date);
			}
		}
	</script>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'addDebitPayment'>
	<cfparam name="attributes.process_type" default="">
	<cfset process_cat = "">
    <cfset action_date = now()>
	<cfset money_info = ''>
	<cfif isDefined("attributes.cc_info") and len(attributes.cc_info)>
        <cfquery name="get_cc_info" datasource="#dsn3#">
            SELECT
                <cfif session.ep.period_year lt 2009>
                    CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID
                <cfelse>
                    ACCOUNTS.ACCOUNT_CURRENCY_ID
                </cfif>
            FROM
                ACCOUNTS,
                CREDIT_CARD
            WHERE
                ACCOUNTS.ACCOUNT_ID = CREDIT_CARD.ACCOUNT_ID
                AND CREDIT_CARD.CREDITCARD_ID = #attributes.cc_info#
        </cfquery>
        <cfset money_info = get_cc_info.account_currency_id>
    </cfif>
    <cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
        SELECT
            ACCOUNTS.ACCOUNT_NAME,
        <cfif session.ep.period_year lt 2009>
            CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
        <cfelse>
            ACCOUNTS.ACCOUNT_CURRENCY_ID,
        </cfif>
            ACCOUNTS.ACCOUNT_ID,
            BANK_BRANCH.BANK_NAME
        FROM
            ACCOUNTS,
            BANK_BRANCH
        WHERE
            ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
        <cfif session.ep.period_year lt 2009>
            AND (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')  
            <cfif isDefined("system_money_info")>AND ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL'</cfif><!--- sadece sistem para birimi olanlarda --->
        <cfelse>
            AND ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) 
            <cfif isDefined("system_money_info")>AND ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#"></cfif><!--- sadece sistem para birimi olanlarda --->
        </cfif>
        <cfif isdefined("account_status")>
            AND ACCOUNT_STATUS = 1
        </cfif>	
        <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
            AND ACCOUNTS.ACCOUNT_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
        </cfif>
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
            AND ACCOUNTS.ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
        </cfif>
        <cfif isDefined("attributes.acc_type") and len(attributes.acc_type)>
            AND ACCOUNTS.ACCOUNT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_type#">
        </cfif>
        <cfif isDefined("money_info") and len(money_info)>
            AND ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money_info#">
        </cfif>
        <cfif isDefined("attributes.account_id_") and len(attributes.account_id_)>
            AND ACCOUNTS.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id_#">
        </cfif>
        <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
            AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,'-')#">) 
        </cfif>
        ORDER BY
            BANK_BRANCH.BANK_NAME,
            ACCOUNTS.ACCOUNT_NAME
    </cfquery>
	<script type="text/javascript">
		function change_currency_info()
		{
			new_kur_say = document.all.kur_say.value;
			if(document.getElementById('credit_card_info') != undefined && document.getElementById('credit_card_info').value != '')
			{
				currency_id_info = list_getat(document.getElementById('credit_card_info').value,2,';');
				for(var i=1;i<=new_kur_say;i++)
				{
					if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == currency_id_info)
						eval('document.all.rd_money['+(i-1)+']').checked = true;
				}
				kur_ekle_f_hesapla('ACTION_FROM_ACCOUNT_ID');
			}
		}
		$( document ).ready(function() {
			change_currency_info();
			kur_ekle_f_hesapla('ACTION_FROM_ACCOUNT_ID');
		});
		function kontrol()
		{ 
			var formName = 'add_cc_bank_action',  // scripttin en başına bir defa yazılacak
			form  = $('form[name="'+ formName +'"]'); // form'u seçer 

			if(!chk_process_cat('add_cc_bank_action')) return false;
			if(!check_display_files('add_cc_bank_action')) return false;
			
			if(form.find('input#masraf').val() != "" && form.find('input#masraf').val() != 0)
			{
				if(form.find('input#expense_center_id').val() == "" || form.find('input#expense_center').val() == "")
				{
					validateMessage('notValid',form.find('input#expense_center') );
					return false;
				}
				if(form.find('input#expense_item_id').val() == "" || form.find('input#expense_item_name').val() == "")
				{
					validateMessage('notValid',form.find('input#expense_item_name') );
					return false;
				}
			}
			document.add_cc_bank_action.credit_card_info.disabled = false;
			return true;
		}
		
	</script>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'updDebitPayment'>
	<cfif not isdefined("db_adres")>
		<cfset db_adres = "#dsn2#">
    </cfif>
    <cfset attributes.TABLE_NAME = "BANK_ACTIONS">
    <cfif (listgetat(attributes.fuseaction,1,'.') is 'store')>
        <cfquery name="get_all_cash" datasource="#dsn2#">
            SELECT CASH_ID FROM CASH WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
        </cfquery>
        <cfset cash_list = valuelist(get_all_cash.cash_id)>
        <cfif not listlen(cash_list)><cfset cash_list = 0></cfif>
        <cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
    </cfif>
    <cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
        SELECT
            *,
            PP.PROJECT_HEAD
        FROM
            #ATTRIBUTES.TABLE_NAME#
            LEFT JOIN #dsn_alias#.PRO_PROJECTS AS PP ON PP.PROJECT_ID = #ATTRIBUTES.TABLE_NAME#.PROJECT_ID
        WHERE
            ACTION_ID=#attributes.ID#
        <cfif (listgetat(attributes.fuseaction,1,'.') is 'store')>
            AND	(TO_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR FROM_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
        </cfif>
    </cfquery>
    <cfif not get_action_detail.recordcount or (isDefined("attributes.action_period_id") and attributes.action_period_id neq session.ep.period_id)>
		<cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
    </cfif>
    <cfquery name="get_process_cat_name" datasource="#dsn3#">
        SELECT PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_action_detail.process_cat#
    </cfquery>
    <cfif get_action_detail.ACTION_TYPE_ID eq 244 and len(get_action_detail.creditcard_id)>
        <cfquery name="get_credit_account_to_name" datasource="#dsn3#">
            SELECT
                CREDITCARD_NUMBER,
                ACCOUNT_NAME
            FROM
                CREDIT_CARD,
                ACCOUNTS
            WHERE
                CREDIT_CARD.ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID
                AND CREDIT_CARD.CREDITCARD_ID = #get_action_detail.creditcard_id#
        </cfquery>
        <cfset key_type = '#session.ep.company_id#'>
        <cfscript>
            getCCNOKey = createObject("component", "settings.cfc.setupCcnoKey");
            getCCNOKey.dsn = dsn;
            getCCNOKey1 = getCCNOKey.getCCNOKey1();
            getCCNOKey2 = getCCNOKey.getCCNOKey2();
        </cfscript>
        <cfset key_type = '#session.ep.company_id#'>
        <!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
        <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
            <!--- anahtarlar decode ediliyor --->
            <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
            <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
            <!--- kart no encode ediliyor --->
             <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:get_credit_account_to_name.creditcard_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
             <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
        <cfelse>
            <cfset content = '#mid(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex")))#'>
        </cfif>	
    </cfif>
	<cfif get_process_cat_name.process_type eq 244>
		<cfset account_id=get_action_detail.ACTION_FROM_ACCOUNT_ID>
    <cfelse>	
        <cfset account_id=get_action_detail.ACTION_TO_ACCOUNT_ID>
    </cfif>
	<cfquery name="GET_ACTION_ACCOUNT" datasource="#dsn3#">
        SELECT 
            ACCOUNT_ID,
            ACCOUNT_STATUS,
            ACCOUNT_TYPE,
            ACCOUNT_NAME,
            ACCOUNT_BRANCH_ID,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID,
            </cfif>
            ACCOUNT_NO,
            ACCOUNT_OWNER_CUSTOMER_NO,
            ACCOUNT_CREDIT_LIMIT,
            ACCOUNT_BLOCKED_VALUE,
            ACCOUNT_DETAIL,
            ACCOUNT_ACC_CODE,
            ACCOUNT_ORDER_CODE,
            ISOPEN,
            V_CHEQUE_ACC_CODE,
            V_VOUCHER_ACC_CODE,
            IS_INTERNET,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP,
            UPDATE_DATE,
            UPDATE_EMP,
            UPDATE_IP,
            CHEQUE_EXCHANGE_CODE,
            VOUCHER_EXCHANGE_CODE,
            IS_ALL_BRANCH
        FROM
            ACCOUNTS
        WHERE
            ACCOUNT_ID = #ACCOUNT_ID#
    </cfquery>
    <cfset attributes.action_type_id =get_action_detail.action_type_id>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	if(IsDefined("attributes.event") && (attributes.event eq 'add' || attributes.event eq 'upd'))
	{
		WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
		WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 242;
		WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;
		
		WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'creditcard_payment';
		   
		WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';
		WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2;
	}
	else if(IsDefined("attributes.event") && attributes.event eq 'addDebitPayment')
	{
		WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
		WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 244;
		WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;
		
		WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'creditcard_debit_payment';
		   
		WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';
		WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2;
	}
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_credit_card_expense';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_credit_card_expense.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.list_credit_card_expense';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/upd_creditcard_bank_expense.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'bank/query/upd_creditcard_bank_expense.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.list_credit_card_expense&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'GET_EXPENSE';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'credit_card_expense';
	if (IsDefined("attributes.event") && attributes.event is 'upd' && not len(isClosed('CREDIT_CARD_BANK_EXPENSE',attributes.id)))
	{	
		if(CONTROL_INFO.recordcount)
		{
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['info'] = '#getLang('finance',140)#';
		}
		else
		{
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate()';
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'del_kontrol()';	
		}
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['info'] = '#lang_array_main.item[2355]#';
	}
	
		   
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.list_credit_card_expense';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/upd_creditcard_bank_expense.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/add_creditcard_bank_expense.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_credit_card_expense&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'credit_card_expense';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate()';
	
	WOStruct['#attributes.fuseaction#']['addDebitPayment'] = structNew();
	WOStruct['#attributes.fuseaction#']['addDebitPayment']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['addDebitPayment']['fuseaction'] = 'bank.list_credit_card_expense';
	WOStruct['#attributes.fuseaction#']['addDebitPayment']['filePath'] = 'bank/form/add_cc_debit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['addDebitPayment']['queryPath'] = 'bank/query/add_cc_debit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['addDebitPayment']['nextEvent'] = '';
	WOStruct['#attributes.fuseaction#']['addDebitPayment']['formName'] = 'add_cc_bank_action';
	
	WOStruct['#attributes.fuseaction#']['addDebitPayment']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['addDebitPayment']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['addDebitPayment']['buttons']['saveFunction'] = 'kontrol() && validate()';
	
	WOStruct['#attributes.fuseaction#']['updDebitPayment'] = structNew();
	WOStruct['#attributes.fuseaction#']['updDebitPayment']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['updDebitPayment']['fuseaction'] = 'bank.list_credit_card_expense';
	WOStruct['#attributes.fuseaction#']['updDebitPayment']['filePath'] = 'bank/form/upd_cc_debit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['updDebitPayment']['queryPath'] = 'bank/form/upd_cc_debit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['updDebitPayment']['nextEvent'] = '';
	WOStruct['#attributes.fuseaction#']['updDebitPayment']['recordQuery'] = 'get_action_detail';
	WOStruct['#attributes.fuseaction#']['updDebitPayment']['formName'] = 'add_cc_bank_action';
	
	WOStruct['#attributes.fuseaction#']['updDebitPayment']['buttons']['update'] = 0;
	WOStruct['#attributes.fuseaction#']['updDebitPayment']['buttons']['isInsert'] = 0;
	if (IsDefined("get_action_detail.upd_status") &&(( len(get_action_detail.upd_status) && get_action_detail.upd_status eq 1) || not len(get_action_detail.upd_status)))
		{
			WOStruct['#attributes.fuseaction#']['updDebitPayment']['buttons']['delete'] = 1;
			//WOStruct['#attributes.fuseaction#']['updDebitPayment']['buttons']['del_function_for_submit'] = "window.location='<cfoutput>#request.self#?fuseaction=bank.emptypopup_del_bank_debit_payment&id=#url.id#&old_process_type=#attributes.action_type_id#<cfif isDefined('attributes.period_control')>&active_period=#attributes.period_control#<cfelse>&active_period=#session.ep.period_id#</cfif></cfoutput>";
		}
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'updDebitPayment' || attributes.event is 'del'))
	{ 
		if(IsDefined("attributes.period_control"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			if(not isdefined('attributes.formSubmittedController'))
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = "bank.emptypopup_del_bank_debit_payment&id=#attributes.id#&old_process_type=#attributes.action_type_id#&active_period=#session.ep.period_id#&period_control=#attributes.period_control#";
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_bank_debit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_bank_debit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_credit_card_expense';
		}
		else
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			if(not isdefined('attributes.formSubmittedController'))
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.emptypopup_del_creditcard_bank_expense&id=#attributes.id#&comp=#attributes.comp_name#&old_process_type=#attributes.process_type#&active_period=#attributes.active_period#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_creditcard_bank_expense.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_creditcard_bank_expense.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_credit_card_expense';
		}
	}		
	if(IsDefined("attributes.event") and attributes.event is 'updDebitPayment')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','upd_gelenh');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=156&action_type=#get_action_detail.action_type_id#','page');";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(IsDefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="CREDITCARD_EXPENSE_ID" action_id="#attributes.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_EXPENSE.CREDITCARD_EXPENSE_ID#&process_cat=#GET_EXPENSE.PROCESS_TYPE#&period_id=#GET_EXPENSE.ACTION_PERIOD_ID#','page','upd_gidenh');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=2448&print_type=153&action_type=242','page','upd_gidenh');";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(IsDefined("attributes.event") and (attributes.event eq 'add' or attributes.event eq 'upd'))
	{   
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDIT_CARD_BANK_EXPENSE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CREDITCARD_EXPENSE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-1','item-4','item-10']";
	}
	if(IsDefined("attributes.event") and attributes.event eq 'addDebitPayment')
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addDebitPayment';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-3','item-4']";
	}
</cfscript>