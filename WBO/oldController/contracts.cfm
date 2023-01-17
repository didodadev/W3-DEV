<cf_get_lang_set module_name="contract">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.employee" default="">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_position_id" datasource="#DSN#">
            SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
        </cfquery>
        <cfquery name="get_setup_period" datasource="#DSN#"><!--- Yetkili olunan şirketler --->
            SELECT DISTINCT
                OUR_COMPANY_ID
            FROM 
                SETUP_PERIOD SP, 
                EMPLOYEE_POSITION_PERIODS EP 
            WHERE 
                EP.PERIOD_ID = SP.PERIOD_ID AND 
                EP.POSITION_ID = #get_position_id.position_id#
        </cfquery>
        <cfset setup_period_comp = ValueList(get_setup_period.our_company_id,',')>
        <cfquery name="get_company_credit" datasource="#DSN#">
            SELECT 
                COMPANY_CREDIT.OUR_COMPANY_ID,
                COMPANY_CREDIT.COMPANY_ID,
                COMPANY_CREDIT.CONSUMER_ID,
                COMPANY_CREDIT.RECORD_EMP,
                C.COMPANY_ID,
                C.FULLNAME,
                OC.COMP_ID,
                OC.NICK_NAME,
                CON.CONSUMER_ID,
                CON.CONSUMER_NAME,
                CON.CONSUMER_SURNAME,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
            FROM 
                COMPANY_CREDIT
                LEFT JOIN COMPANY C ON C.COMPANY_ID = COMPANY_CREDIT.COMPANY_ID
                LEFT JOIN CONSUMER CON ON CON.CONSUMER_ID = COMPANY_CREDIT.CONSUMER_ID
                LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = COMPANY_CREDIT.OUR_COMPANY_ID
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = COMPANY_CREDIT.RECORD_EMP
            WHERE 
                COMPANY_CREDIT.OUR_COMPANY_ID IN (<cfif len(setup_period_comp)>#setup_period_comp#<cfelse>0</cfif>)
            AND (COMPANY_CREDIT.CONSUMER_ID IS NOT NULL OR COMPANY_CREDIT.COMPANY_ID IS NOT NULL)
            <cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>
                AND COMPANY_CREDIT.COMPANY_ID=	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            </cfif>
            <cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>
                AND COMPANY_CREDIT.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfif>
            <cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.employee)>
                AND COMPANY_CREDIT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
            </cfif>
            ORDER BY
                COMPANY_CREDIT.COMPANY_ID,
                COMPANY_CREDIT.CONSUMER_ID
        </cfquery>
        
    <cfelse>
        <cfset get_company_credit.recordcount = 0>
    </cfif>
    <script type="text/javascript">
        $( document ).ready(function() {
            document.getElementById('company').focus();
        });
        function uyar()
        {
            alert("<cf_get_lang no ='312.Anlasmayı Görebilmek İçin Lütfen Şirketinizi Değiştiriniz'>");
        }
    </script>
</cfif>


<cfif IsDefined("attributes.event") and attributes.event eq 'det'>
	<cf_xml_page_edit fuseact="contract.detail_contract_company">
    <cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
        SELECT
            COMPANY_CREDIT_ID, 
            PROCESS_STAGE, 
            COMPANY_ID, 
            CONSUMER_ID, 
            OPEN_ACCOUNT_RISK_LIMIT, 
            OPEN_ACCOUNT_RISK_LIMIT_OTHER, 
            FORWARD_SALE_LIMIT,
            FORWARD_SALE_LIMIT_OTHER, 
            MONEY, 
            PAYMETHOD_ID, 
            FIRST_PAYMENT_INTEREST, 
            LAST_PAYMENT_INTEREST, 
            PAYMENT_BLOKAJ, 
            PAYMENT_BLOKAJ_TYPE, 
            OUR_COMPANY_ID, 
            BRANCH_ID, 
            SHIP_METHOD_ID, 
            PRICE_CAT, 
            REVMETHOD_ID, 
            IS_INSTALMENT_INFO, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_PAR, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            TRANSPORT_COMP_ID, 
            TRANSPORT_DELIVER_ID, 
            IS_BLACKLIST, 
            BLACKLIST_INFO, 
            BLACKLIST_DATE, 
            CARD_REVMETHOD_ID, 
            CARD_PAYMETHOD_ID, 
            PAYMENT_RATE_TYPE
        FROM
            COMPANY_CREDIT
        WHERE
            <cfif isdefined("attributes.is_upd") and len(attributes.is_upd)>
                COMPANY_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_credit_id#">
            <cfelse>
                <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
                <cfelse>
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
                </cfif>
                OUR_COMPANY_ID = <cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
                                <cfelse>	
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                                </cfif>
            </cfif>
    </cfquery>
    <cfset our_comp_id_ = GET_CREDIT_LIMIT.OUR_COMPANY_ID>
    <cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
        SELECT
            COMP_ID,
            COMPANY_NAME
        FROM
            OUR_COMPANY
        WHERE
            COMP_ID = <cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
                    <cfelseif isdefined("attributes.is_upd") and len(attributes.is_upd)>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
                    <cfelse>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    </cfif>
        ORDER BY
            COMPANY_NAME
    </cfquery>
    <cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
        SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT ORDER BY PRICE_CAT
    </cfquery>
    <cfquery name="GET_BLACKLIST_INFO" datasource="#DSN#">
        SELECT BLACKLIST_INFO_ID,BLACKLIST_INFO_NAME FROM SETUP_BLACKLIST_INFO ORDER BY BLACKLIST_INFO_NAME
    </cfquery>
    <cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
        SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.COMPANY_ID#
    </cfquery>
    <cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> ORDER BY MONEY
    </cfquery>
    <cfquery name="GET_PAYMETHOD" datasource="#DSN#">
        SELECT
            SP.* 
        FROM 
            SETUP_PAYMETHOD SP,
            SETUP_PAYMETHOD_OUR_COMPANY SPOC
        WHERE 
            SP.PAYMETHOD_STATUS = 1
            AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
            AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        ORDER BY	
            SP.PAYMETHOD
	</cfquery>

    <cfif GET_CREDIT_LIMIT.recordcount>
        <cfquery name="GET_CREDIT_MONEY" datasource="#DSN#">
            WITH CTE1 AS (
                SELECT 
                    MONEY_TYPE,
                    RATE1,
                    RATE2 
                FROM 
                    COMPANY_CREDIT_MONEY 
                WHERE 
                    ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.company_credit_id#">        
            )
            SELECT 
                CTE1.* 
            FROM 
                CTE1        
    
            UNION ALL
    
            SELECT
                MONEY,
                RATE1,
                RATE2 
            FROM 
                SETUP_MONEY 
            WHERE 
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND 
                MONEY NOT IN (
                    SELECT
                        MONEY_TYPE
                    FROM 
                        CTE1       
                )	
            ORDER BY MONEY_TYPE
        </cfquery>
    <cfelse>
        <cfquery name="GET_RISK_MONEY" datasource="#DSN#">
            SELECT IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#    
        </cfquery>
    </cfif>
    <cfif session.ep.rate_valid eq 1>
        <cfset readonly_info = "yes">
    <cfelse>
        <cfset readonly_info = "no">
    </cfif>
    <cfif GET_CREDIT_LIMIT.recordcount>
        <cfset url_str1="#request.self#?fuseaction=contract.emptypopup_updcompany_credit_total">
    <cfelse>
        <cfset url_str1="#request.self#?fuseaction=contract.emptypopup_addcompany_credit_total">
    </cfif>
    <cfif len(GET_CREDIT_LIMIT.paymethod_id)>
        <cfquery name="GET_PAY_METHOD" datasource="#DSN#">
            SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.paymethod_id#">
        </cfquery>
        <cfset paymethod_name_ = get_pay_method.paymethod>
    <cfelseif len(GET_CREDIT_LIMIT.card_paymethod_id)>
        <cfquery name="GET_PAY_METHOD" datasource="#DSN3#">
            SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.card_paymethod_id#">
        </cfquery>
        <cfset paymethod_name_ = get_pay_method.card_no>
    <cfelse>
        <cfset paymethod_name_= ''>
    </cfif>
    
    <cfif len(GET_CREDIT_LIMIT.revmethod_id)>
        <cfquery name="GET_PAY_METHOD" datasource="#DSN#">
            SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.revmethod_id#">
        </cfquery>
        <cfset revmethod_name_ = get_pay_method.paymethod>
    <cfelseif len(GET_CREDIT_LIMIT.card_revmethod_id)>
        <cfquery name="GET_PAY_METHOD" datasource="#DSN3#">
            SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.card_revmethod_id#">
        </cfquery>
        <cfset revmethod_name_ = get_pay_method.card_no>
    <cfelse>
        <cfset revmethod_name_= ''>
    </cfif>
    <cfif len(GET_CREDIT_LIMIT.ship_method_id)>
        <cfquery name="GET_METHOD" datasource="#DSN#">
            SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.ship_method_id#">
        </cfquery>
    </cfif>
    <script type="text/javascript">
		$( document ).ready(function() {
			ytl_hesapla();
		});
		function kontrol()
		{ 
			if (document.add_credit.company_name.value == "")
			{
				alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='107.Cari Hesap'> !");
				return false;
			}
			unformat_fields();
			return process_cat_control();
			return true ;
		}
		function doviz_hesapla()
		{
			toplam =eval("document.add_credit.open_account_risk_limit");
			toplam1=eval("document.add_credit.forward_sale_limit");
			toplam.value=filterNum(toplam.value);
			toplam1.value=filterNum(toplam1.value);
			toplam=parseFloat(toplam.value);
			toplam1=parseFloat(toplam1.value);
			for(s=1;s<=add_credit.deger_get_money.value;s++)
			{
				if(document.add_credit.other_money[s-1].checked == true)
				{
					deger_diger_para = document.add_credit.other_money[s-1];
					form_value_rate2=eval("document.add_credit.value_rate2"+s);
				}
			}
			deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
			form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			if(toplam>0)
			{
				document.add_credit.open_account_risk_limit_other_cash.value = commaSplit(toplam * parseFloat(deger_money_id_3)/(parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')));
				document.add_credit.open_account_risk_limit.value=commaSplit(toplam);
			}
			else
			{
				document.add_credit.open_account_risk_limit_other_cash.value =0;
				document.add_credit.open_account_risk_limit.value=0;
			}
			if(toplam1>0)
			{
				document.add_credit.forward_sale_limit_other_cash.value = commaSplit(toplam1 * parseFloat(deger_money_id_3)/(parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')));
				document.add_credit.forward_sale_limit.value=commaSplit(toplam1);
			}
			else
			{
				document.add_credit.forward_sale_limit_other_cash.value = 0;
				document.add_credit.forward_sale_limit.value=0;
			}
			form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			return true;
		}
		function ytl_hesapla()
		{
			toplam2 =eval("document.add_credit.open_account_risk_limit_other_cash");
			toplam3=eval("document.add_credit.forward_sale_limit_other_cash");
			toplam2.value=filterNum(toplam2.value);
			toplam3.value=filterNum(toplam3.value);
			toplam2=parseFloat(toplam2.value);
			toplam3=parseFloat(toplam3.value);
			for(s=1;s<=add_credit.deger_get_money.value;s++)
			{
				if(document.add_credit.other_money[s-1].checked == true)
				{
					deger_diger_para = document.add_credit.other_money[s-1];
					form_value_rate2=eval("document.add_credit.value_rate2"+s);
				}
			}
			deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
			form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			if(toplam2>0)
			{
				document.add_credit.open_account_risk_limit.value = commaSplit(toplam2 * parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(deger_money_id_3)));
				document.add_credit.open_account_risk_limit_other_cash.value=commaSplit(toplam2);
			}
			else
			{
				document.add_credit.open_account_risk_limit.value =0;
				document.add_credit.open_account_risk_limit_other_cash.value=0;
			}
			if(toplam3>0)
			{
				document.add_credit.forward_sale_limit.value = commaSplit(toplam3 *parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>') /(parseFloat(deger_money_id_3)));
				document.add_credit.forward_sale_limit_other_cash.value=commaSplit(toplam3);
			}
			else
			{
				document.add_credit.forward_sale_limit.value = 0;
				document.add_credit.forward_sale_limit_other_cash.value=0;
			}
			form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			return true;
		}
		function check_info()
		{
			if(document.add_credit.is_blacklist.checked == true)
				blacklist_tr.style.display='';
			else
				blacklist_tr.style.display='none';
				return true;
		}
		
		function unformat_fields()
		{
			for(s=1;s<=add_credit.deger_get_money.value;s++)
			{
				eval('add_credit.value_rate2' + s).value = filterNum(eval('add_credit.value_rate2' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				eval('add_credit.txt_rate1_' + s).value = filterNum(eval('add_credit.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
			add_credit.open_account_risk_limit.value = filterNum(add_credit.open_account_risk_limit.value);
			add_credit.forward_sale_limit.value = filterNum(add_credit.forward_sale_limit.value);
			add_credit.payment_blokaj.value = filterNum(add_credit.payment_blokaj.value);
			add_credit.first_payment_interest.value = filterNum(add_credit.first_payment_interest.value);
			add_credit.last_payment_interest.value = filterNum(add_credit.last_payment_interest.value);
			add_credit.open_account_risk_limit_other_cash.value = filterNum(add_credit.open_account_risk_limit_other_cash.value);
			add_credit.forward_sale_limit_other_cash.value = filterNum(add_credit.forward_sale_limit_other_cash.value);
			return true;
		}	
	</script>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'contract.list_contracts';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'contract/display/list_partner_contract.cfm';
	
	if( isdefined('attributes.event') and attributes.event eq 'det')
	{
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'contract.detail_contract_company';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'contract/query/detail_contract_company.cfm';
		if(GET_CREDIT_LIMIT.recordcount)
		{
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'contract/query/upd_company_credit.cfm';
		}
		else
		{
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'contract/query/add_company_credit.cfm';
		}
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'contract.list_contracts&event=det';
		if(isdefined("attributes.company_id") and len(attributes.company_id))
		{
			WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'company_id=##attributes.company_id##';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.company_id##';
		}
		else
		{
			WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'consumer_id=##attributes.consumer_id##';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.consumer_id##';
		}
	}
	
		if( isdefined('attributes.event') and attributes.event eq 'det')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
		
		if(isdefined("attributes.company_id") and len(attributes.company_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item[61]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=contract.popup_risc_contract_history&member_type=company&member_id=#attributes.company_id#</cfoutput>','medium','popup_risc_contract_history')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#lang_array_main.item[345]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=contract.detail_contract_company&action_name=company_id&action_id=#attributes.company_id#</cfoutput>','list')";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array_main.item[313]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['href'] = "#request.self#?fuseaction=member.detail_company&cpid=#attributes.company_id#";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['text'] = '#lang_array_main.item[163]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#attributes.company_id#";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item[61]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=contract.popup_risc_contract_history&member_type=consumer&member_id=#attributes.consumer_id#</cfoutput>','medium','popup_risc_contract_history')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#lang_array_main.item[345]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=contract.detail_contract_company&action_name=consumer_id&action_id=#attributes.consumer_id#</cfoutput>','list')";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array_main.item[313]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['href'] = "#request.self#?fuseaction=member.detail_consumer&cid=#attributes.consumer_id#";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['text'] = '#lang_array_main.item[163]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#attributes.consumer_id#";
		
		}
		if(not listfindnocase(denied_pages,'member.popup_list_securefund'))
		{
			if(isdefined("attributes.company_id") and len(attributes.company_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['text'] = '#lang_array_main.item[264]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=member.popup_list_securefund&company_id=#url.company_id#</cfoutput>','list')";
			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['text'] = '#lang_array_main.item[264]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=member.popup_list_securefund&consumer_id=#url.consumer_id#</cfoutput>','list')";
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

