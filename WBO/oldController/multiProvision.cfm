<cf_get_lang_set module_name="bank">

<cfif  IsDefined("attributes.event") and (attributes.event eq 'add' or attributes.event eq 'addProvision')>
	<cf_xml_page_edit fuseact="bank.popup_add_multi_provision">
<cfparam name="attributes.start_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.finish_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.contract_start" default="">
    <cfparam name="attributes.contract_finish" default="">
    <cfparam name="attributes.bank_name" default="">
    <cfparam name="attributes.setup_bank_type" default="">
    <cfparam name="attributes.open_form" default="0">
    <cfparam name="attributes.pay_method" default="">
    <cfparam name="attributes.month_info" default="">
    <cfparam name="attributes.year_info" default="">
    <cfparam name="attributes.prov_period" default="">
    <cfparam name="attributes.comp_code_info" default="">
    <cfif not isDefined("attributes.from_subs_detail")>
        <cfparam name="attributes.company_id" default="">
        <cfparam name="attributes.consumer_id" default="">
    </cfif>
    <cfquery name="GET_PAY_METHOD" datasource="#dsn3#">
        SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE ORDER BY CARD_NO
    </cfquery>
    <cfquery name="get_bank_type" datasource="#dsn#">
        SELECT BANK_NAME,BANK_ID FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
    </cfquery>
    <cf_get_lang_set module_name="bank">
    
    <cfif attributes.open_form eq 1>
       
        <cfif len(attributes.contract_start)><cf_date tarih='attributes.contract_start'></cfif>
        <cfif len(attributes.contract_finish)><cf_date tarih='attributes.contract_finish'></cfif>
        <cfif isDefined("attributes.is_detailed")>
            <cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
                <cfset new_dsn2 = '#dsn#_#ListGetAt(attributes.prov_period,1,";")#_#ListGetAt(attributes.prov_period,2,";")#'>
                <cfset period_id = ListGetAt(attributes.prov_period,3,";")>
            <cfelse>
                <cfset new_dsn2 = '#dsn2#'>
                <cfset period_id = session.ep.period_id>
            </cfif>
            <cfquery name="GET_PAYMENT_PLAN" datasource="#dsn3#"><!--- query de yapılan değişiklikler, action sayfasındaki desen querylerinde de yapılmalıdır.. mutlaka.. aysenur --->
                SELECT
                    SPR.SUBSCRIPTION_PAYMENT_ROW_ID,
                    SPR.SUBSCRIPTION_ID,
                    SPR.INVOICE_ID,
                    SPR.PERIOD_ID,
                    SPR.PAYMENT_DATE,
                    SPR.DETAIL,
                    SPR.UNIT,
                    SPR.AMOUNT,
                    SPR.MONEY_TYPE,
                    SPR.ROW_TOTAL,
                    SPR.DISCOUNT,
                    SPR.ROW_NET_TOTAL,
                    SPR.PAYMETHOD_ID,
                    SPR.CARD_PAYMETHOD_ID,
                    SPR.QUANTITY,
                    SC.SUBSCRIPTION_NO,
                    SC.SUBSCRIPTION_ID,
                    SC.MEMBER_CC_ID,
                    COMP_CC.COMPANY_CC_NUMBER CC_NUMBER,
                    COMP_CC.COMP_CVS CVS,
                    COMP_CC.COMPANY_EX_MONTH EX_MONTH,
                    COMP_CC.COMPANY_EX_YEAR EX_YEAR,
                    COMP_CC.COMPANY_ID MEMBER_ID,
                    COMPANY.NICKNAME MEMBER_NAME,
                    0 MEMBER_TYPE,
                    I.NETTOTAL,
                    I.INVOICE_ID INVOICE_ID,
                    I.INVOICE_NUMBER,
                    CARD_PAYM.CARD_NO,
                    ISNULL(I.CREDITCARD_PAYMENT_ID,0) CREDITCARD_PAYMENT_ID
                FROM
                    SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
                    SUBSCRIPTION_CONTRACT SC,
                    #dsn_alias#.COMPANY_CC COMP_CC,
                    #dsn_alias#.COMPANY COMPANY,
                    #new_dsn2#.INVOICE I,
                    CREDITCARD_PAYMENT_TYPE CARD_PAYM
                WHERE
                    SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
                    SC.INVOICE_COMPANY_ID = COMP_CC.COMPANY_ID AND
                    SC.INVOICE_COMPANY_ID = COMPANY.COMPANY_ID AND
                    COMPANY.COMPANY_ID = COMP_CC.COMPANY_ID AND
                    SC.MEMBER_CC_ID = COMP_CC.COMPANY_CC_ID AND
                    I.INVOICE_ID = SPR.INVOICE_ID AND
                    CARD_PAYM.PAYMENT_TYPE_ID = SPR.CARD_PAYMETHOD_ID AND
                    SPR.PAYMENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
                    <cfif len(attributes.pay_method)>
                        SPR.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pay_method#"> AND<!---ödeme yöntemi--->
                    </cfif>
                    SPR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#"> AND
                    SPR.IS_BILLED = 1 AND<!--- faturalandı --->
                    SPR.IS_PAID = 0 AND<!--- ödenmedi --->
                    SPR.IS_COLLECTED_PROVISION = 0 AND<!--- toplu provizyon oluşturulmadı --->
                    SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
                    I.NETTOTAL > 0 AND
                    I.IS_IPTAL = 0 AND
                    I.INVOICE_CAT <> 57 AND <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
                    COMP_CC.IS_DEFAULT = 1
                    <cfif len(attributes.company_id)>
                        AND SC.INVOICE_COMPANY_ID =	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                    </cfif>
                    <cfif len(attributes.consumer_id)>
                        AND SC.INVOICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                    </cfif>
                    <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
                        AND SC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                    </cfif>
                    <cfif isDefined("attributes.setup_bank_type") and len(attributes.setup_bank_type)>
                        AND COMP_CC.COMPANY_BANK_TYPE IN (#attributes.setup_bank_type#)
                    </cfif>
                    <cfif isDefined("attributes.is_cvv")>
                        AND COMP_CC.COMP_CVS IS NOT NULL
                    </cfif>
                    <cfif len(attributes.year_info) and len(attributes.month_info)>
                        AND (
                                (COMP_CC.COMPANY_EX_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month_info#"> AND COMP_CC.COMPANY_EX_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#">)
                                 OR 
                                (COMP_CC.COMPANY_EX_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#"> AND COMP_CC.COMPANY_EX_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month_info#">)
                                 OR
                                (COMP_CC.COMPANY_EX_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#">)			    
                            )
                    </cfif>
                    <cfif len(attributes.contract_start) and len(attributes.contract_finish)>
                        AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_finish#">)
                    <cfelseif len(attributes.contract_start)>
                        AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_start#">)
                    <cfelseif len(attributes.contract_finish)>
                        AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_finish#">)
                    </cfif>
            UNION ALL
                SELECT
                    SPR.SUBSCRIPTION_PAYMENT_ROW_ID,
                    SPR.SUBSCRIPTION_ID,
                    SPR.INVOICE_ID,
                    SPR.PERIOD_ID,
                    SPR.PAYMENT_DATE,
                    SPR.DETAIL,
                    SPR.UNIT,
                    SPR.AMOUNT,
                    SPR.MONEY_TYPE,
                    SPR.ROW_TOTAL,
                    SPR.DISCOUNT,
                    SPR.ROW_NET_TOTAL,
                    SPR.PAYMETHOD_ID,
                    SPR.CARD_PAYMETHOD_ID,
                    SPR.QUANTITY,
                    SC.SUBSCRIPTION_NO,
                    SC.SUBSCRIPTION_ID,
                    SC.MEMBER_CC_ID,
                    CONS_CC.CONSUMER_CC_NUMBER CC_NUMBER,
                    CONS_CC.CONS_CVS CVS,
                    CONS_CC.CONSUMER_EX_MONTH EX_MONTH,
                    CONS_CC.CONSUMER_EX_YEAR EX_YEAR,
                    CONS_CC.CONSUMER_ID MEMBER_ID,
                    CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME MEMBER_NAME,
                    1 MEMBER_TYPE,
                    I.NETTOTAL,
                    I.INVOICE_ID INVOICE_ID,
                    I.INVOICE_NUMBER,
                    CARD_PAYM.CARD_NO,
                    ISNULL(I.CREDITCARD_PAYMENT_ID,0) CREDITCARD_PAYMENT_ID
                FROM
                    SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
                    SUBSCRIPTION_CONTRACT SC,
                    #dsn_alias#.CONSUMER_CC CONS_CC,
                    #dsn_alias#.CONSUMER CONSUMER,
                    #new_dsn2#.INVOICE I,
                    CREDITCARD_PAYMENT_TYPE CARD_PAYM
                WHERE
                    SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
                    SC.INVOICE_CONSUMER_ID = CONS_CC.CONSUMER_ID AND
                    SC.INVOICE_CONSUMER_ID = CONSUMER.CONSUMER_ID AND
                    CONSUMER.CONSUMER_ID = CONS_CC.CONSUMER_ID AND
                    SC.MEMBER_CC_ID = CONS_CC.CONSUMER_CC_ID AND
                    I.INVOICE_ID = SPR.INVOICE_ID AND
                    CARD_PAYM.PAYMENT_TYPE_ID = SPR.CARD_PAYMETHOD_ID AND
                    SPR.PAYMENT_DATE BETWEEN  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
                    <cfif len(attributes.pay_method)>
                        SPR.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pay_method#"> AND<!---ödeme yöntemi--->
                    </cfif>
                    SPR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#"> AND
                    SPR.IS_BILLED = 1 AND<!--- faturalandı --->
                    SPR.IS_PAID = 0 AND<!--- ödenmedi --->
                    SPR.IS_COLLECTED_PROVISION = 0 AND<!--- toplu provizyon oluşturulmadı --->
                    SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
                    I.NETTOTAL > 0 AND
                    I.IS_IPTAL = 0 AND
                    I.INVOICE_CAT <> 57 AND <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
                    CONS_CC.IS_DEFAULT = 1
                    <cfif len(attributes.company_id)>
                        AND SC.INVOICE_COMPANY_ID =	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                    </cfif>
                    <cfif len(attributes.consumer_id)>
                        AND SC.INVOICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                    </cfif>
                    <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
                        AND SC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                    </cfif>
                    <cfif isDefined("attributes.setup_bank_type") and len(attributes.setup_bank_type)>
                        AND CONS_CC.CONSUMER_BANK_TYPE IN (#attributes.setup_bank_type#)
                    </cfif>
                    <cfif isDefined("attributes.is_cvv")>
                        AND CONS_CC.CONS_CVS IS NOT NULL
                    </cfif>
                    <cfif len(attributes.year_info) and len(attributes.month_info)>
                        AND (
                                (CONS_CC.CONSUMER_EX_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month_info#"> AND CONS_CC.CONSUMER_EX_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#">)
                                 OR 
                                (CONS_CC.CONSUMER_EX_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#"> AND CONS_CC.CONSUMER_EX_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month_info#">)
                                 OR
                                (CONS_CC.CONSUMER_EX_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#">)			    
                            )
                    </cfif>
                    <cfif len(attributes.contract_start) and len(attributes.contract_finish)>
                        AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_finish#">)
                    <cfelseif len(attributes.contract_start)>
                        AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_start#">)
                    <cfelseif len(attributes.contract_finish)>
                        AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_finish#">)
                    </cfif>
                ORDER BY
                    I.INVOICE_ID<!--- provizyon sırası değiştirilmemeli!! AE--->
            </cfquery>
        </cfif>
    </cfif>
    
    <cfif isDefined("attributes.is_detailed")>
		<script type="text/javascript">
			function check_all(deger)
			{
				<cfif GET_PAYMENT_PLAN.recordcount >
					if(provision_rows.hepsi.checked)
					{
						for (var i=1; i <= <cfoutput>#GET_PAYMENT_PLAN.recordcount#</cfoutput>; i++)
						{
							if(eval("document.provision_rows.payment_row" + i).disabled == false)
							{
								var form_field = eval("document.provision_rows.payment_row" + i);
								form_field.checked = true;
								eval('provision_rows.payment_row'+i).focus();
							}
						}
					}
					else
					{
						for (var i=1; i <= <cfoutput>#GET_PAYMENT_PLAN.recordcount#</cfoutput>; i++)
						{
							if(eval("document.provision_rows.payment_row" + i).disabled == false)
							{
								form_field = eval("document.provision_rows.payment_row" + i);
								form_field.checked = false;
								eval('provision_rows.payment_row'+i).focus();
							}
						}				
					}
				</cfif>
				return true;
			}
		</script>
	</cfif>
    <script type="text/javascript">
	function kontrol()
	{  debugger;
		<cfif not attributes.fuseaction eq "sales.popup_add_multi_provision">
			if(add_multi_provision.bank_name.value=="")
			{
				alert("<cf_get_lang no ='302.Pos Tipi Seçiniz'>");
				return false;
			}
			if(add_multi_provision.pay_method.value=="")
			{
				alert("<cf_get_lang_main no='615.Lutfen Odeme Yontemi Seciniz'>");
				return false;
			}
		</cfif>
		document.add_multi_provision.open_form.value = 1
		return true;
	}
	function input_control()
	{
		if(provision_rows.key_type.value == "")
		{
			alert("<cf_get_lang no ='303.Anahtar Giriniz'>");
			return false;
		}
		<cfif isDefined("attributes.is_detailed")>
			var checked_info = false;
			var toplam = document.provision_rows.all_records.value;
			for(var i=1; i<=toplam; i++)
			{
				if(eval('provision_rows.payment_row'+i).checked){
					checked_info = true;
					i = toplam+1;
				}
			}
			if(!checked_info)
			{
				alert("<cf_get_lang no ='304.Seçim Yapmadınız'>!");
				return false;
			}
			return true;
		</cfif>
		return true;
	}
	function open_code_input(pos_type_info)
	{
		<cfif isDefined("xml_company_code") and len(xml_company_code)>//xml den pos tipi verilerek üye işyeri numarası girilmesi sağlanması için
			if(list_find('<cfoutput>#xml_company_code#</cfoutput>',pos_type_info,','))
				document.getElementById('comp_code').style.display = '';
			else
				document.getElementById('comp_code').style.display = 'none';
		</cfif>
		return true;
	}
	
	$(document).ready(function(){
		$("#page-subtitle").html("Document-ready was called!");
	  });
	
</script>
</cfif>


<cfif not IsDefined("attributes.event") or attributes.event eq 'list'>
	<cfparam name="attributes.bank_type" default="">
	<cfif isdefined("attributes.form_varmi")>
		
        <cfquery name="GET_PROVISIONS" datasource="#dsn2#">
            SELECT
                FILE_EXPORTS.FILE_NAME,
                FILE_EXPORTS.TARGET_SYSTEM,
                FILE_EXPORTS.RECORD_DATE,
                FILE_EXPORTS.RECORD_EMP,
                FILE_EXPORTS.IS_IPTAL,
                FILE_EXPORTS.E_ID,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME
            FROM
                FILE_EXPORTS
                LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = FILE_EXPORTS.RECORD_EMP
            WHERE
                PROCESS_TYPE = -6 AND
                FILE_EXPORTS.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("d",1,attributes.finish_date)#">
            <cfif len(attributes.bank_type)>
                AND TARGET_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">
            </cfif>
            ORDER BY
                E_ID DESC
        </cfquery>
    <cfelse>
        <cfset arama_yapilmali = 1>
        <cfset GET_PROVISIONS.recordcount = 0>
    </cfif>
     <script>
    	function kontrol()
			{
				if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
					return false;
				else
					return true;	
			}
    </script> 
</cfif>
	

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_multi_provision';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_multi_provision.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.list_multi_provision';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/add_multi_provision.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/form/add_multi_provision.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_multi_provision&event=add';
	
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'bank.list_multi_provision';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'bank/form/open_multi_prov_file.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'bank/query/open_multi_prov_file.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'bank.list_multi_provision';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'export_import_id=##attributes.export_import_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.export_import_id##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.list_multi_provision';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/form/open_multi_prov_file.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/cancel_provision_file.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_multi_provision';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'export_import_id=##attributes.export_import_id##';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'is_iptal=1';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.export_import_id##';
	
	
	WOStruct['#attributes.fuseaction#']['addProvision'] = structNew();
	WOStruct['#attributes.fuseaction#']['addProvision']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addProvision']['fuseaction'] = 'bank.list_multi_provision';
	WOStruct['#attributes.fuseaction#']['addProvision']['filePath'] = 'bank/form/add_multi_provision.cfm';
	WOStruct['#attributes.fuseaction#']['addProvision']['queryPath'] = 'bank/query/multi_provision_file.cfm';
	WOStruct['#attributes.fuseaction#']['addProvision']['nextEvent'] = 'bank.list_multi_provision';
	/*
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_creditcard&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'creditcard_id=##attributes.creditcard_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.creditcard_id##';
	
	
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_creditcard&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} */
</cfscript>

