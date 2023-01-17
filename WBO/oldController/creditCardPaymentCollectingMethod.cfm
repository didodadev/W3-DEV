<cf_get_lang_set module_name="bank">
<cfif (not IsDefined("attributes.event") or attributes.event eq 'list' ) >
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_activeid" default="1">
    <cfparam name="attributes.bank_name" default="">
    
    <cfif isdefined('attributes.is_submitted')>
        <cfquery name="creditcard_paymentCREDITCARD_EXPENSE" datasource="#DSN3#">
            SELECT 
                * ,
          		ACCOUNTS.ACCOUNT_NAME,
                ACCOUNTS.ACCOUNT_ID
            FROM 
                CREDITCARD_PAYMENT_TYPE 
                LEFT JOIN ACCOUNTS ON ACCOUNTS.ACCOUNT_ID = CREDITCARD_PAYMENT_TYPE.BANK_ACCOUNT
                LEFT JOIN BANK_BRANCH ON ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID
            WHERE	
                PAYMENT_TYPE_ID IS NOT NULL
                <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                AND CARD_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                </cfif>
                <cfif isdefined("attributes.is_activeid") and attributes.is_activeid eq 1>
                    AND IS_ACTIVE = 1
                <cfelseif isdefined("attributes.is_activeid") and attributes.is_activeid eq 2>
                    AND IS_ACTIVE = 0
                </cfif>
                 <cfif isdefined("attributes.bank_name") and len(attributes.bank_name)>
                    AND BANK_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_name#">
                </cfif>
            ORDER BY CARD_NO
        </cfquery>
    <cfelse>
        <cfset creditcard_paymentcreditcard_expense.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#creditcard_paymentcreditcard_expense.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset url_str = "">
    <cfif isdefined("attributes.keyword")>
      <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
    <cfif isdefined("attributes.is_active") >
      <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
    </cfif>
    <cfif isdefined("attributes.is_activeid") >
      <cfset url_str = "#url_str#&is_activeid=#attributes.is_activeid#">
    </cfif>
    <cfif isdefined("attributes.bank_name") >
      <cfset url_str = "#url_str#&bank_name=#attributes.bank_name#">
    </cfif>
    <cfif isdefined("attributes.is_submitted")>
        <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
    </cfif>
	<cfquery name="creditcard_paymentBANK_BRANCH" datasource="#dsn3#">
        SELECT
            ACCOUNTS.ACCOUNT_NAME,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID,
            </cfif>
            ACCOUNTS.ACCOUNT_ID
        FROM
            ACCOUNTS,
            BANK_BRANCH
        WHERE
            ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND 
            <cfif session.ep.period_year lt 2009>
            (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
            </cfif>
        ORDER BY
            ACCOUNTS.ACCOUNT_ID
    </cfquery>
</cfif>
<cfif IsDefined("attributes.event") and (attributes.event eq 'add' or attributes.event eq 'upd')>
	<cfset cardNo = "">
    <cfset instalmentCount = "">
    <cfset passingDay = "">
    <cfset vftCode = "">
    <cfset vftRate = "">
    <cfset serviceRate = "">
    <cfset serviceAccCodeId = "">
    <cfset serviceAccCode = "">
    <cfset paymentRate = "">
    <cfset paymentRateDsp = "">
    <cfset paymentRateAcc = "">
    <cfset paymentRateAccCode = "">
    <cfset commissionMuliplier = "">
    <cfset productId = "">
    <cfset stockId = "">
    <cfset productName = "">
    <cfset commissionMuliplierDsp = "">
    <cfset publicCommMultiplier = "">
    <cfset publicProductId = "">
    <cfset publicStockId = "">
    <cfset publicProductName = "">
    <cfset publicCommMultiplierDsp = "">
    <cfset firstInterestRate = "">
    <cfset accountCode = "">
    <cfset publicMinAmount = "">
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
        SELECT
            ACCOUNT_NAME,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS ACCOUNT_CURRENCY_ID,
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID,
            </cfif>
            ACCOUNT_ID
        FROM
            ACCOUNTS,
            BANK_BRANCH
        WHERE
            ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND 
            <cfif session.ep.period_year lt 2009>
                (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')  
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) 
            </cfif>
        ORDER BY
            BANK_NAME,
            ACCOUNT_NAME
    </cfquery>
    <cfquery name="GETSANALPOS" datasource="#DSN#">
        SELECT 
            POS_ID,
            POS_NAME
        FROM 
            OUR_COMPANY_POS_RELATION AS POS_REL,
            OUR_COMPANY AS COMP
        WHERE
            COMP.COMP_ID = POS_REL.OUR_COMPANY_ID AND
            COMP.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            IS_ACTIVE = 1
        ORDER BY
            POS_ID
    </cfquery>
     <cfquery name="CONTROL_EINVOICE" datasource="#DSN#">
        SELECT 
            IS_EFATURA 
        FROM 
            OUR_COMPANY_INFO 
        WHERE 
            IS_EFATURA = 1 AND 
            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
    </cfquery>
    <cfif attributes.event eq 'upd'>
    	<cfquery name="CREDIT_CONTROL" datasource="#DSN3#">
            SELECT 
                IS_ACTIVE,
                IS_PESIN,
                IS_PARTNER,
                IS_PUBLIC,
                IS_SPECIAL,
                IS_COMISSION_TOTAL_AMOUNT,
                IS_PROM_CONTROL,
                CARD_NO,
                CARD_IMAGE,
                CARD_IMAGE_SERVER_ID,
                BANK_ACCOUNT,
                <!---COMPANY_ID,6 aya siline FA22102013--->
                POS_TYPE,
                NUMBER_OF_INSTALMENT,
                P_TO_INSTALMENT_ACCOUNT,
                VFT_CODE,
                VFT_RATE,
                SERVICE_ACCOUNT_CODE,
                SERVICE_RATE,
                PAYMENT_RATE,
                PAYMENT_RATE_DSP,
                PAYMENT_RATE_ACC,
                COMMISSION_PRODUCT_ID,
                COMMISSION_STOCK_ID,
                COMMISSION_MULTIPLIER,
                COMMISSION_MULTIPLIER_DSP,
                PUBLIC_COMMISSION_PRODUCT_ID,
                PUBLIC_COMMISSION_STOCK_ID,
                PUBLIC_COMMISSION_MULTIPLIER,
                PUBLIC_COM_MULTIPLIER_DSP,
                FIRST_INTEREST_RATE,
                ACCOUNT_CODE,
                RECORD_EMP,
                RECORD_DATE,
                UPDATE_EMP,
                UPDATE_DATE,
                PUBLIC_MIN_AMOUNT,
                PAYMENT_MEANS_CODE,
                PAYMENT_MEANS_CODE_NAME      
            FROM 
                CREDITCARD_PAYMENT_TYPE 
            WHERE	
                PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfquery>
        <cfquery name="GET_CREDIT_PAYMENTS" datasource="#DSN3#">
            SELECT 
                CREDITCARD_PAYMENT_ID,
                PAYMENT_TYPE_ID
            FROM
                CREDIT_CARD_BANK_PAYMENTS
            WHERE 
                PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfquery>
        <cfquery name="GET_SUBS_PAYM" datasource="#dsn3#">
            SELECT 
                CARD_PAYMETHOD_ID
            FROM
                SUBSCRIPTION_PAYMENT_PLAN_ROW
            WHERE 
                CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfquery>
        <cfquery name="GET_ACCOUNT_CODE_1" datasource="#DSN2#">
            SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#credit_control.service_account_code#">
        </cfquery>
        <cfset cardNo = credit_control.card_no> 
        <cfset instalmentCount = credit_control.number_of_instalment>
        <cfset passingDay = credit_control.p_to_instalment_account>
        <cfset vftCode = credit_control.vft_code>
        <cfset vftRate = TLFormat(credit_control.vft_rate)>
        <cfset serviceRate = TLFormat(credit_control.service_rate)>
        <cfset serviceAccCodeId = credit_control.service_account_code>
        <cfset serviceAccCode = get_account_code_1.account_name>
        <cfset paymentRate = TLFormat(credit_control.PAYMENT_RATE)>
        <cfset paymentRateDsp = TLFormat(credit_control.PAYMENT_RATE_DSP)>
        <cfset paymentRateAcc = credit_control.payment_rate_acc>
        <cfset paymentRateAccCode = credit_control.payment_rate_acc>
        <cfset commissionMuliplier = TLFormat(credit_control.commission_multiplier)>
		<cfset productId = credit_control.commission_product_id>
        <cfset stockId = credit_control.commission_stock_id>
        <cfif len(credit_control.commission_product_id)>
        	<cfset productName = get_product_name(credit_control.commission_product_id)>
        </cfif>
        <cfset commissionMuliplierDsp = TLFormat(credit_control.commission_multiplier_dsp)>
        <cfset publicCommMultiplier = TLFormat(credit_control.public_commission_multiplier)>
        <cfset publicProductId = credit_control.public_commission_product_id>
        <cfset publicStockId = credit_control.public_commission_stock_id>
        <cfif len(credit_control.public_commission_product_id)>
        	<cfset publicProductName = get_product_name(credit_control.public_commission_product_id)>
        </cfif>
        <cfset publicCommMultiplierDsp = TLFormat(credit_control.public_com_multiplier_dsp)>
        <cfset firstInterestRate = TLFormat(credit_control.first_interest_rate)>
        <cfset accountCode = credit_control.ACCOUNT_CODE>
        <cfset publicMinAmount = TLFormat(credit_control.public_min_amount)>
    </cfif>
    <script type="text/javascript">
		<cfif attributes.event is "add" or attributes.event is "upd">
			$(document).ready(function()
			{
				<cfif attributes.event is "upd" and credit_control.is_public eq 1>
					$('#public_min_amount_id').show();
				</cfif>
				$('#is_public').change(function(){
					if($('#is_public').is(':checked'))
						$('#public_min_amount_id').show();
					else
					{
						$('#public_min_amount_id').hide();
						$('#is_public').prop('checked', false);
					}
				});
			});
		</cfif>
		function kontrol()
		{
			<cfif control_einvoice.recordcount>
			if(document.getElementById('payment_means_code').value == "")
			{
				alert("<cf_get_lang dictionary_id='58027.Lütfen Ödeme Şekli Kodunu Giriniz'>!");
				return false;
			}
			</cfif>
			if (document.getElementById('account_id').value == "")
			{
				alert("<cf_get_lang no='445.Banka Hesabı Seçiniz'> ! ");
				return false;
			}
			unformat_fields();
			return true;
		}
		
		function unformat_fields()
		{
			document.getElementById('service_rate').value = filterNum(document.getElementById('service_rate').value);
			document.getElementById('payment_rate').value = filterNum(document.getElementById('payment_rate').value);
			document.getElementById('payment_rate_dsp').value = filterNum(document.getElementById('payment_rate_dsp').value);
			document.getElementById('commission_multiplier').value = filterNum(document.getElementById('commission_multiplier').value);
			document.getElementById('commission_multiplier_dsp').value = filterNum(document.getElementById('commission_multiplier_dsp').value);
			document.getElementById('public_commission_multiplier').value = filterNum(document.getElementById('public_commission_multiplier').value);
			document.getElementById('public_com_multiplier_dsp').value = filterNum(document.getElementById('public_com_multiplier_dsp').value);
			document.getElementById('first_interest_rate').value = filterNum(document.getElementById('first_interest_rate').value);
			<cfif attributes.event eq 'upd'>
				document.getElementById('vft_rate').value = filterNum(document.getElementById('vft_rate').value);
			</cfif>
			document.getElementById('public_min_amount').value = filterNum(document.getElementById('public_min_amount').value);
		}	
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_credit_payment_types';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'finance/display/list_credit_payment_types.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.list_credit_payment_types';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/form_add_credit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_credit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_credit_payment_types&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.list_credit_payment_types';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/form_add_credit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_credit_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_credit_payment_types&event=upd';
	
	if( IsDefined("attributes.event") && attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=finance.emptypopup_del_credit_payment&id=#attributes.id#&detail=#credit_control.card_no#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'finance/query/del_credit_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'finance/query/del_credit_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'finance.list_credit_payment_types';
	}
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[5]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=finance.popup_add_payment_for_member&cc_payment_type_id=#attributes.id#','list','popup_member_schema');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_credit_payment_types&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'creditCardPaymentCollectingMethod';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CREDITCARD_PAYMENT_TYPE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-card_no','item-payment_means_code','item-account_id','item-passingday_to_instalment_account','item-account_code']";
</cfscript>

