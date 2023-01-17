<cf_get_lang_set module_name="account">
<cfparam name="is_dsp_cari_member" default="0">
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.card_id" default="">
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
<cfparam name="attributes.acc_project_id" default="">
<cfparam name="attributes.DETAIL" default="" >
<cfparam name="attributes.other_amount" default="" >
<cfparam name="attributes.other_currency" default="" >
<cfparam name="attributes.CARD_DETAIL" default="" >
<cfparam name="attributes.paper_no" default="" >
<cfparam name="attributes.card_document_type" default="">
<cfparam name="attributes.card_payment_method" default="">
<cfparam name="attributes.due_date" default="#now()#" >
<cf_xml_page_edit fuseact="account.form_add_bill_collecting">
<cfquery name="GET_MONEY_DOVIZ" datasource="#DSN#">
	SELECT
		MONEY,
		RATE2,
		RATE1
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	ORDER BY 
		MONEY_ID
</cfquery>
<cfquery name="GET_CASH_PLAN" datasource="#dsn2#">
	SELECT DISTINCT
		A.ACCOUNT_CODE,
		A.ACCOUNT_NAME
	FROM
		ACCOUNT_PLAN A,
		CASH C
	WHERE
		A.ACCOUNT_CODE = C.CASH_ACC_CODE
	ORDER BY
		ACCOUNT_NAME
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
<cfif not IsDefined("attributes.event") or (IsDefined(attributes.event) and (attributes.event eq 'add' or attributes.event eq 'copy'))>
	<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add' )>
        <cfquery name="kontrol" datasource="#DSN2#">
            SELECT BILL_ID FROM BILLS
        </cfquery>
        <cfif not kontrol.recordcount>
            <font color="##FF0000">
                <a href="<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>" class="tableyazi"><cf_get_lang_main no ='1616.LUtfen Muhasebe Fis Numaralarini Duzenleyiniz'> </a>
            </font>
            <cfabort>
        </cfif>
        <cfquery name="get_money_bskt" datasource="#dsn2#">
            SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
        </cfquery>
    </cfif>
	<script type="text/javascript">
		function display_duedate()
		{
			if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
				document.getElementById('tr_due_date').style.display = '';
			else
				document.getElementById('tr_due_date').style.display = 'none';
		}
	</script>
</cfif>

<cfif IsDefined("attributes.event") and (attributes.event eq 'upd' or attributes.event eq 'copy')>
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
        SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL WHERE BA=0
    </cfquery>
    <cfquery name="GET_ACCOUNT_ROWS_A" dbtype="query">
        SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL WHERE BA=1
    </cfquery>
    <!--- money bilgileri --->
    <cfquery name="get_money_bskt" datasource="#dsn2#"><!--- account money tablosunda kayıt varsa --->
        SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID = #attributes.card_id#
    </cfquery>
    <cfif not get_money_bskt.recordcount>
        <cfif not get_money_bskt.recordcount><!--- setup_money den --->
            <cfquery name="get_money_bskt" datasource="#dsn#">
                SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
            </cfquery>
        </cfif>
	</cfif>
    <cfif attributes.event eq 'upd'>
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
        </cfif>
        <cfquery name="CONTROL_ACC_UPDATE" datasource="#DSN#">
				SELECT ISNULL(IS_ACCOUNT_CARD_UPDATE,0) AS IS_ACCOUNT_CARD_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.COMPANY_ID#
			</cfquery>
        <script type="text/javascript">
			function control()
			{ 
				kontrol2();
				if(document.getElementById('document_type').value != '' && document.getElementById('paper_no').value == '')
				{
					alert("Belge No Giriniz!");
					return false;
				}
				return true;
			}
			function ekle()
			{
				window.opener.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.form_add_bill_collecting';
				window.close();
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
	<cfset attributes.other_amount = GET_ACCOUNT_ROWS_MAIN.OTHER_AMOUNT>
	<cfset attributes.other_currency = GET_ACCOUNT_ROWS_MAIN.OTHER_CURRENCY>
	<cfset attributes.DETAIL = get_account_card.CARD_DETAIL>
	<cfset attributes.CARD_DETAIL = get_account_card.CARD_DETAIL>
	<cfset attributes.paper_no = get_account_card.paper_no>
	<cfset attributes.card_document_type = get_account_card.card_document_type>
	<cfset attributes.card_payment_method = get_account_card.card_payment_method>
	<cfset attributes.due_date = get_account_card.due_date>
</cfif>
<cfscript>
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.form_add_bill_collecting';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/upd_bill_collecting.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_bill_collecting.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.form_add_bill_collecting&event=upd';
	
	WOStruct['#attributes.fuseaction#']['copy'] = structNew();
	WOStruct['#attributes.fuseaction#']['copy']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'account.popup_add_bill_collecting_copy';
	WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'account/form/upd_bill_collecting.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'account/query/add_bill_collecting.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'account.form_add_bill_collecting&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_upd_bill_collecting';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'account/form/upd_bill_collecting.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'account/query/upd_bill_collecting.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.form_add_bill_collecting&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'card_id=##attributes.card_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.card_id##';

	if(IsDefined("attributes.event") and attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		if (isdefined('link_str') and len(link_str) and len(get_account_card.action_cat_id))
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
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=account.form_add_bill_collecting";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=account.form_add_bill_collecting&event=copy&card_id=#attributes.card_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.card_id#&print_type=290','page')";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountCardCollecting';
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-8']"; 
	}
</cfscript>
