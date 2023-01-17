<cf_xml_page_edit  fuseact="account.form_add_bill_cash2cash">
<cf_get_lang_set module_name="account">
<cfparam name="attributes.action_id" default="" >
<cfparam name="attributes.card_id" default="" >
<cfparam name="attributes.is_other_currency" default="">
<cfparam name="attributes.IS_ACCOUNT_CODE2" default="">
<cfparam name="attributes.card_cat_id" default="" >
<cfparam name="attributes.BILL_NO" default="" >
<cfparam name="attributes.CARD_TYPE_NO" default="">
<cfparam name="attributes.ACTION_DATE" default="#now()#">
<cfparam name="attributes.acc_company_id" default="" >
<cfparam name="attributes.acc_consumer_id" default="" >
<cfparam name="attributes.fullname" default="">
<cfparam name="attributes.consumer_fullname" default="">
<cfparam name="attributes.CARD_DETAIL" default="" >
<cfparam name="attributes.paper_no" default="" >
<cfparam name="attributes.card_document_type" default="">
<cfparam name="attributes.card_payment_method" default="">
<cfparam name="attributes.due_date" default="#now()#" >
<cfif (isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'copy') )>
	<cfparam name="is_dsp_cari_member" default="0">
	<cfquery name="GET_ACCOUNT_CARD" datasource="#dsn2#">
        SELECT 
            AC.*,
            C.FULLNAME COMPANY,
            CO.CONSUMER_NAME + ' ' + CO.CONSUMER_SURNAME CONSUMER,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME EMPLOYEE
        FROM 
            ACCOUNT_CARD AC 
            LEFT JOIN #dsn_alias#.COMPANY C ON AC.ACC_COMPANY_ID = C.COMPANY_ID
            LEFT JOIN #dsn_alias#.CONSUMER CO ON AC.ACC_CONSUMER_ID = CO.CONSUMER_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES E ON AC.ACC_EMPLOYEE_ID = E.EMPLOYEE_ID
        WHERE 
            AC.CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_id#">
    </cfquery>
    <cfquery name="GET_ACCOUNT_ROWS_MAIN_ALL" datasource="#dsn2#">
        SELECT 
            ACR.*, 
            AP.ACCOUNT_NAME
        FROM 
            ACCOUNT_CARD_ROWS ACR, 
            ACCOUNT_PLAN AP 
        WHERE 
            ACR.CARD_ID=#attributes.card_id# AND 
            ACR.ACCOUNT_ID=AP.ACCOUNT_CODE
        ORDER BY 
            ACR.BA ASC,
            ACR.AMOUNT DESC
    </cfquery>
    <cfquery name="GET_ACCOUNT_ROWS_MAIN" dbtype="query">
        SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL
    </cfquery>
	<cfset acc_process_type= GET_ACCOUNT_CARD.ACTION_TYPE><!--- get_acc_process_type_info.cfm'de kullanılıyor --->
	<cfquery name="get_money_bskt" datasource="#dsn2#"><!--- account money tablosunda kayıt varsa --->
        SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID = #attributes.card_id# AND MONEY_TYPE <> '#session.ep.money#'
    </cfquery>
    <cfif not get_money_bskt.recordcount>
        <cfif not get_money_bskt.recordcount><!--- setup_money den --->
            <cfquery name="get_money_bskt" datasource="#dsn#">
                SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#'
            </cfquery>
        </cfif>
    </cfif>
    <cfif attributes.event eq 'upd'>
		<cfif len(get_account_card.acc_company_id)>
            <cfquery name="get_company_name" datasource="#dsn#">
                SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_account_card.acc_company_id#
            </cfquery>
        <cfelseif len(get_account_card.acc_consumer_id)>
            <cfquery name="get_consumer_name" datasource="#dsn#">
                SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS CONSUMER_FULLNAME FROM CONSUMER WHERE CONSUMER_ID = #get_account_card.acc_consumer_id#
            </cfquery>
        </cfif>
        <cfsavecontent variable="title_">
            <cfif GET_ACCOUNT_CARD.CARD_TYPE eq 14>
                <cf_get_lang_main no='1638.Özel Fiş'>
            <cfelseif GET_ACCOUNT_CARD.CARD_TYPE eq 19>
                <cf_get_lang_main no='1746.Kapanış Fiş'>
            <cfelse>
                <cf_get_lang_main no='1040.Mahsup Fişi'>
            </cfif>
        </cfsavecontent>
        <cfif listfind('31',get_account_card.action_type,',')>
            <cfquery name="get_order_id" datasource="#dsn3#">
                SELECT
                    ORDER_ID
                FROM
                    ORDER_CASH_POS
                WHERE
                    CASH_ID = #get_account_card.action_id# AND
                    KASA_PERIOD_ID = #session.ep.period_id#
            </cfquery>
        <cfelseif listfind('241',get_account_card.action_type,',')>
            <cfquery name="get_order_id" datasource="#dsn3#">
                SELECT
                    ORDER_ID
                FROM
                    ORDER_CASH_POS
                WHERE
                    POS_ACTION_ID = #get_account_card.action_id#
            </cfquery>
          <cfelseif listfind('97',get_account_card.action_type,',')>
            <cfquery name="get_order_id" datasource="#dsn2#">
                SELECT
                    PAYMENT_ORDER_ID ORDER_ID
                FROM
                    VOUCHER_PAYROLL
                WHERE
                    ACTION_ID = #get_account_card.action_id#
            </cfquery>
        <cfelseif listfind('90',get_account_card.action_type,',')>
            <cfquery name="get_order_id" datasource="#dsn2#">
                SELECT
                    PAYMENT_ORDER_ID ORDER_ID
                FROM
                    PAYROLL
                WHERE
                    ACTION_ID = #get_account_card.action_id#
            </cfquery>
        <cfelseif listfind('1043,1044',get_account_card.action_type,',')>
            <cfquery name="get_cheque_id" datasource="#dsn2#">
                SELECT
                    BA.CHEQUE_ID
                FROM
                    BANK_ACTIONS BA,
                    CHEQUE C
                WHERE
                    BA.ACTION_ID = #get_account_card.action_id# AND
                    BA.ACTION_TYPE_ID = #get_account_card.action_type# AND
                    BA.CHEQUE_ID = C.CHEQUE_ID
            </cfquery>
     	<cfelseif listfind('1053,1054',get_account_card.action_type,',')>
            <cfquery name="get_voucher_id" datasource="#dsn2#">
                SELECT
                    BA.VOUCHER_ID
                FROM
                    BANK_ACTIONS BA,
                    VOUCHER V
                WHERE
                    BA.ACTION_ID = #get_account_card.action_id# AND
                    BA.ACTION_TYPE_ID = #get_account_card.action_type# AND
                    BA.CHEQUE_ID = V.VOUCHER_ID
            </cfquery>
         <cfelseif listfind('8110',get_account_card.action_type,',')>
            <cfquery name="get_ship_id" datasource="#dsn2#">
                SELECT
                    SHIP_ID
                FROM
                    INVOICE_COST
                WHERE
                    INVOICE_COST_ID = #get_account_card.action_id#
            </cfquery>
         </cfif>
         <cfquery name="CONTROL_ACC_UPDATE" datasource="#DSN#">
            SELECT ISNULL(IS_ACCOUNT_CARD_UPDATE,0) AS IS_ACCOUNT_CARD_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.COMPANY_ID#
         </cfquery>
    	 <script type="text/javascript">
            function ekle()
            {
                window.opener.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.form_add_bill_cash2cash';
                window.close();
            }
        
            function control()
            {
                kontrol2();
                if (!check_display_files('add_bill'))
                    return false;
                    
                    return true;
            }
        
            function display_duedate()
            {
                if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
                    document.getElementById('tr_due_date').style.display = '';
                else
                    document.getElementById('tr_due_date').style.display = 'none';
            }
         </script>
    </cfif>
    <cfparam name="attributes.action_id" default="" >
	<cfset attributes.card_id = GET_ACCOUNT_CARD.card_id>
	<cfset attributes.is_other_currency = get_account_card.is_other_currency>
	<cfset attributes.IS_ACCOUNT_CODE2 = get_account_card.IS_ACCOUNT_CODE2>
	<cfset attributes.card_cat_id = get_account_card.card_cat_id>
	<cfset attributes.BILL_NO = get_account_card.BILL_NO>
	<cfset attributes.CARD_TYPE_NO = get_account_card.CARD_TYPE_NO>
	<cfset attributes.ACTION_DATE = get_account_card.ACTION_DATE>
	<cfset attributes.acc_company_id = get_account_card.acc_company_id>
	<cfif len( attributes.acc_company_id )>
		<cfset attributes.fullname = get_company_name.fullname>
	<cfelse>
		<cfset attributes.fullname = "">
	</cfif>
	<cfset attributes.acc_consumer_id = get_account_card.acc_consumer_id>
	<cfif len( attributes.acc_consumer_id )>
		<cfset attributes.consumer_fullname = get_consumer_name.consumer_fullname>
	<cfelse>
		<cfset attributes.consumer_fullname ="">
	</cfif>
	<cfset attributes.CARD_DETAIL = get_account_card.CARD_DETAIL>
	<cfset attributes.paper_no = get_account_card.paper_no>
	<cfset attributes.card_document_type = get_account_card.card_document_type>
	<cfset attributes.card_payment_method = get_account_card.card_payment_method>
	<cfset attributes.due_date = get_account_card.due_date>
</cfif>

<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and (attributes.event eq 'add' or attributes.event eq 'copy' ))>
	<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add' )>
        <cfparam name="is_dsp_cari_member" default="0">
        <cfquery name="kontrol" datasource="#DSN2#">
            SELECT BILL_ID FROM BILLS
        </cfquery>
        <cfif not kontrol.recordcount>
            <font color="##FF0000">
                <a href="<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>" class="tableyazi"><cf_get_lang_main no ='1616.LUtfen Muhasebe Fis Numaralarini Duzenleyiniz'> </a>
            </font>
            <cfabort>
        </cfif>
        <cfquery name="get_money_bskt" datasource="#dsn#">
            SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#'
        </cfquery>
        <script language="javascript">
            $( document ).ready(function() {
                change_money_info('add_bill','process_date');
            });
        </script>
    </cfif>
	<script type="text/javascript">
		function display_duedate()
		{
			if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
			{
				document.getElementById('td_due_date_label').style.display = '';
				document.getElementById('td_due_date_input').style.display = '';
			}
			else
			{
				document.getElementById('td_due_date_label').style.display = 'none';
				document.getElementById('td_due_date_input').style.display = 'none';
			}
		}
	</script>
</cfif>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT
		BRANCH_ID,BRANCH_NAME
	FROM
		BRANCH
	WHERE
		BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cfscript>
	netbook = createObject("component","account.cfc.netbook");
	netbook.dsn = dsn;
	get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
	get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);
	//sirket akis parametrelerinde "islem dövizi ile muhasebe hareketi yapilsin" secenegini kontrol eder
	get_bill_info = createObject("component","account.cfc.get_bill_info");
	get_bill_info.dsn = dsn;
	get_comp_info = get_bill_info.getBillInfo();
</cfscript>

<cfscript>
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.form_add_bill_cash2cash';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/upd_bill_cash2cash.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_bill_cash2cash.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.form_add_bill_cash2cash&event=upd';
	
	WOStruct['#attributes.fuseaction#']['copy'] = structNew();
	WOStruct['#attributes.fuseaction#']['copy']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'account.popup_add_bill_cash2cash_copy';
	WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'account/form/upd_bill_cash2cash.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'account/query/add_bill_cash2cash.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'account.form_add_bill_cash2cash&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_upd_bill_cash2cash';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'account/form/upd_bill_cash2cash.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'account/query/upd_bill_cash2cash.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.form_add_bill_cash2cash&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'card_id=##attributes.card_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.card_id##';

	if(IsDefined("attributes.event") and attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		if (isdefined('link_str') and len(link_str) and len(get_account_card.action_cat_id) and get_account_card.action_id neq 0)
		{
		 	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[199]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#link_str##GET_ACCOUNT_CARD.ACTION_ID#";
		}
		else if (listfind('31',get_account_card.action_type,','))
		{
		 	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[35]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
		}
		else if (listfind('241',get_account_card.action_type,','))
		{
		 	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[35]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
		}
		else if ( listfind('97',get_account_card.action_type,','))
		{
		 	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[35]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
		}
		else if (listfind('90',get_account_card.action_type,','))
		{
		 	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[35]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
		}
		else if (listfind('1043,1044',get_account_card.action_type,','))
		{
		 	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[199]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=cheque.popup_view_cheque_detail&id=#get_cheque_id.cheque_id#','horizantal')";
		}
		else if ( get_account_card.action_type eq 1046)
		{
		 	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[199]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=cheque.popup_view_cheque_detail&id=#get_account_card.action_id#','horizantal')";
		}
		else if ( listfind('1053,1054',get_account_card.action_type,','))
		{
		 	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[199]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=cheque.popup_view_voucher_detail&id=#get_voucher_id.voucher_id#','horizantal')";
		}
		else if ( listfind('8110',get_account_card.action_type,','))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[35]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=stock.upd_stock_in_from_customs&ship_id=#get_ship_id.ship_id#";
		}else if ( get_account_card.action_type eq 1056)
		{
		 	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[199]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "windowopen('#request.self#?fuseaction=cheque.popup_view_voucher_detail&id=#get_account_card.action_id#','horizantal')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=account.form_add_bill_cash2cash";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=account.form_add_bill_cash2cash&event=copy&card_id=#attributes.card_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.card_id#&print_type=290','page')";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountCardCash2Cash';
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd,copy';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1']";
</cfscript>
