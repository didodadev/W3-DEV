<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfparam name="attributes.act_type" default="">
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = ''>
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    <cfelse>
        <cfset attributes.finish_date = ''>
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_actions" datasource="#dsn2#">
            SELECT
                *,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
            FROM
                CARI_DUE_DIFF_ACTIONS
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = CARI_DUE_DIFF_ACTIONS.RECORD_EMP
            WHERE
                1 = 1
                <cfif len(attributes.act_type)>
                    AND ACTION_TYPE = #attributes.act_type#
                </cfif>
                <cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
                    AND ACTION_DATE >= #attributes.start_date#
                <cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
                    AND ACTION_DATE <= #attributes.finish_date#
                <cfelseif isdate(attributes.start_date) and  isdate(attributes.finish_date)>
                    AND ACTION_DATE >= #attributes.start_date#
                    AND ACTION_DATE <= #attributes.finish_date#
                </cfif>
        </cfquery>
    <cfelse>
        <cfset get_actions.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_actions.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <script type="text/javascript">
		$( document ).ready(function() {
			$('#start_date').focus();
		});
		
		function kontrol()
		{
			if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;	
		}
	</script>
</cfif>

<cfif IsDefined("attributes.event") and (attributes.event eq 'add' or attributes.event eq 'addOther')>
	
    <cf_xml_page_edit fuseact="ch.form_add_due_diff_action">
    <cfparam name="attributes.member_cat_type" default="">
    <cfparam name="attributes.consumer_cat_type" default="">
    <cfparam name="attributes.member_action_type" default="1">
    <cfparam name="attributes.customer_value" default="">
    <cfparam name="attributes.due_date1" default="">
    <cfparam name="attributes.due_date2" default="">
    <cfparam name="attributes.action_date1" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.action_date2" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.pos_code" default="">
    <cfparam name="attributes.pos_code_text" default="">
    <cfparam name="attributes.payment_type_id" default="">
    <cfparam name="attributes.card_paymethod_id" default="">
    <cfparam name="attributes.payment_type" default="">
    <cfparam name="attributes.ozel_kod" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.subscription_type" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfparam name="attributes.due_diff_rate" default="">
    <cfparam name="attributes.make_age_type" default="">
    <cfparam name="attributes.due_diff_rate_info" default="0">
    
    
    <cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
        SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
    </cfquery>
    <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
        SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
    </cfquery>
    <cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
        SELECT
            CUSTOMER_VALUE_ID,
            CUSTOMER_VALUE 
        FROM
            SETUP_CUSTOMER_VALUE
        ORDER BY
            CUSTOMER_VALUE
    </cfquery>
    <cfquery name="GET_SUB_TYPE" datasource="#DSN3#">
        SELECT
            SUBSCRIPTION_TYPE_ID,
            SUBSCRIPTION_TYPE
        FROM 
            SETUP_SUBSCRIPTION_TYPE
        ORDER BY
            SUBSCRIPTION_TYPE
    </cfquery>
    <cfquery name="GET_SUB_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_subscription_contract%">
    </cfquery>
    <cfquery name="GET_MONEY_RATE" datasource="#DSN2#">
        SELECT 
            <cfif xml_money_type eq 1>
                ISNULL(RATE3,RATE2) RATE2_
            <cfelseif xml_money_type eq 3>
                ISNULL(EFFECTIVE_PUR,RATE2) RATE2_
            <cfelseif xml_money_type eq 4>
                ISNULL(EFFECTIVE_SALE,RATE2) RATE2_
            <cfelse>
                RATE2 RATE2_
            </cfif>,
            * 
         FROM 
            SETUP_MONEY 
        WHERE 
            MONEY_STATUS=1 
        ORDER BY 
            MONEY_ID
    </cfquery>
    <cfquery name="GET_PERIOD" datasource="#DSN#"><!--- yetkili olduğum aktif şirketler --->
        SELECT 
            PERIOD_ID, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID, 
            OTHER_MONEY, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP
        FROM 
            SETUP_PERIOD 
        WHERE 
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfif isdefined("is_act_type") and is_act_type eq 1>
        <cfset act_type = 1><!--- Dekont Eklenecek --->
    <cfelseif isdefined("is_act_type") and is_act_type eq 2>
        <cfset act_type = 2><!--- Sistem Ödeme Planı Eklenecek --->
    <cfelseif isdefined("is_act_type") and is_act_type eq 3>
        <cfset act_type = 3><!--- Fatura kontrol satırı ekleniyor --->
    <cfelse>
        <cfset act_type = 1><!--- Eğer xml den seçim yapılmamışsa default dekont ekleniyor --->
    </cfif>
    
    <script type="text/javascript">
		
			
		
		
		function hepsi_view()
		{
			if(document.add_due_diff_action.all_view.checked)
			{
			
				for(i=1;i<=document.getElementById('all_records').value; i++)
				{
					if(eval('add_due_diff_action.is_pay_'+i)!= undefined)
						eval('add_due_diff_action.is_pay_'+i).checked = true;
					control_checked++;
				}
			}
			else
			{
				for(i=1;i<=add_due_diff_action.all_records.value; i++)
				{
					if(eval('add_due_diff_action.is_pay_'+i)!= undefined)
						eval('add_due_diff_action.is_pay_'+i).checked = false;
					control_checked--;
				}
			}
		}
		function check_kontrol(nesne)
		{
			if(nesne.checked)
				control_checked++;
			else
				control_checked--;
				return true;
		}
		function kontrol_display()
		{
			if(add_due_diff_action.member_action_type[0].checked)
			{
				comp_cat.style.display='';
				cons_cat.style.display='none';
			}
			else
			{
				comp_cat.style.display='none';
				cons_cat.style.display='';
			}
			return true;			
		}
		function kontrol()
		{  debugger;
			if(control_checked > 0)
			{
				<cfif act_type eq 1>
					if(!chk_process_cat('add_due_diff_action')) return false;
					if(!check_display_files('add_due_diff_action')) return false;
				</cfif>
				if(!chk_period(add_due_diff_action.action_date,'İşlem')) return false;
				if(<cfoutput>#act_type#</cfoutput> != 1)
				{
					if(document.getElementById('product_id').value == '' || document.getElementById('product_name').value == '')
					{
						alert("<cf_get_lang_main no ='313.Ürün Seçmelisiniz'> !");
						return false;
					}
				}
				
				add_due_diff_action.action='<cfoutput>#request.self#?fuseaction=ch.list_due_diff_actions&event=addOther</cfoutput>';
				add_due_diff_action.submit();
				add_due_diff_action.action='';
				return false;
			}
			else
			{
				return false;
			}
			return true;
		}
		function toplam_hesapla()
		{
			for (var t=1; t<=document.getElementById('kur_say').value; t++)
			{
				if(document.add_due_diff_action.rd_money[t-1].checked == true)
				{
					rate2_value = filterNum(eval('document.add_due_diff_action.txt_rate2_'+t).value);
				}
			}
			for(j=1;j<=document.getElementById('all_records').value;j++)
			{
				eval('document.add_due_diff_action.control_amount_2_'+j).value = commaSplit(eval("document.add_due_diff_action.control_amount_"+j).value/rate2_value,4);
			}
		}
		function check_paym_type()
		{
			<cfif isdefined("is_act_type") and is_act_type eq 2 and is_paymethod_from_contract eq 0>//ödeme planı kaydederken ödeme yöntemi zorunlu oldğ. için
				if(document.getElementById('payment_type').value == "")
				{
					alert("<cf_get_lang_main no='615.Ödeme Yöntemi Seçiniz!'>");
					return false;
				}
			</cfif>
			return true;
		}
	</script>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'det' >
	<cfquery name="get_actions" datasource="#dsn2#">
        SELECT 
            *
        FROM 
            CARI_DUE_DIFF_ACTIONS
        WHERE 
            DUE_DIFF_ID = #attributes.due_diff_id# 
    </cfquery>
    <cfquery name="get_rate" datasource="#dsn2#">
        SELECT 
            RATE2,
            MONEY_TYPE MONEY
        FROM 
            CARI_DUE_DIFF_ACTIONS_MONEY
        WHERE 
            ACTION_ID = #attributes.due_diff_id# 
            AND IS_SELECTED = 1
    </cfquery>
    <cfif get_actions.action_type eq 2>
        <cfquery name="GET_PERIOD" datasource="#dsn#"><!--- yetkili olduğum aktif şirketler --->
            SELECT PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
        </cfquery>
        <cfquery name="get_rows" datasource="#dsn2#">
            SELECT
                *
            FROM
            (
                <cfoutput query="GET_PERIOD">
                    SELECT 
                        C.COMPANY_ID,
                        C.CONSUMER_ID,
                        C.INVOICE_ID,
                        C.CARI_ROW_ID,
                        C.ACTION_VALUE,
                        C.DUE_DIFF_VALUE,
                        C.PERIOD_ID,
                        I.DUE_DATE,
                        I.INVOICE_NUMBER PAPER_NO
                    FROM 
                        CARI_DUE_DIFF_ACTIONS_ROW C,
                        #dsn#_#GET_PERIOD.PERIOD_YEAR#_#session.ep.company_id#.INVOICE I
                    WHERE 
                        DUE_DIFF_ID = #attributes.due_diff_id#
                        AND C.INVOICE_ID = I.INVOICE_ID
                        AND C.PERIOD_ID = #GET_PERIOD.PERIOD_ID#
                <cfif GET_PERIOD.recordcount neq 1 and currentrow neq GET_PERIOD.recordcount> UNION ALL </cfif>
                </cfoutput>
            ) GET_ROWS
        </cfquery>	
    <cfelse>
        <cfquery name="get_rows" datasource="#dsn2#">
            SELECT 
                C.COMPANY_ID,
                C.CONSUMER_ID,
                C.INVOICE_ID,
                C.CARI_ROW_ID,
                C.ACTION_VALUE,
                C.DUE_DIFF_VALUE,
                CR.DUE_DATE,
                CR.PAPER_NO,
                CP.COMPANY_ID,
                CP.NICKNAME,
                CP.MEMBER_CODE
            FROM 
                CARI_DUE_DIFF_ACTIONS_ROW C
                LEFT JOIN CARI_ROWS CR ON C.CARI_ROW_ID = CR.CARI_ACTION_ID
                LEFT JOIN #dsn_alias#.COMPANY CP ON CP.COMPANY_ID = C.COMPANY_ID
                LEFT JOIN #dsn_alias#.CONSUMER CN ON CN.CONSUMER_ID = C.CONSUMER_ID
            WHERE 
                DUE_DIFF_ID = #attributes.due_diff_id#
        </cfquery>
    </cfif>
    <cfif get_actions.action_type eq 1>
        <cfquery name="control_payment_row" datasource="#dsn2#">
            SELECT
                ACTION_ID
            FROM
                CARI_ACTIONS CR
            WHERE
                DUE_DIFF_ID = #attributes.due_diff_id#
                AND ACTION_ID IN(SELECT ICR.ACTION_ID FROM CARI_CLOSED_ROW ICR WHERE ICR.ACTION_ID = CR.ACTION_ID AND ICR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID)
        </cfquery>
    <cfelseif get_actions.action_type eq 2>
        <cfquery name="control_payment_row" datasource="#dsn3#">
            SELECT
                SUBSCRIPTION_ID
            FROM
                SUBSCRIPTION_PAYMENT_PLAN_ROW
            WHERE
                DUE_DIFF_ID = #attributes.due_diff_id#
                AND PERIOD_ID = #session.ep.period_id#
                AND (IS_PAID = 1 OR IS_BILLED =1)
        </cfquery>
    <cfelseif get_actions.action_type eq 3>
        <cfquery name="control_payment_row" datasource="#dsn2#">
            SELECT
                DIFF_INVOICE_ID
            FROM
                INVOICE_CONTRACT_COMPARISON
            WHERE
                DUE_DIFF_ID = #attributes.due_diff_id#
                AND DIFF_INVOICE_ID IS NOT NULL
        </cfquery>									
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_due_diff_actions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'ch/display/list_due_diff_actions.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_due_diff_action';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'ch/form/add_due_diff_action.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'ch/form/add_due_diff_action.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.list_due_diff_actions&event=add';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_due','add_due_row')";
	
	WOStruct['#attributes.fuseaction#']['addOther'] = structNew();
	WOStruct['#attributes.fuseaction#']['addOther']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addOther']['fuseaction'] = 'ch.form_add_due_diff_action';
	WOStruct['#attributes.fuseaction#']['addOther']['filePath'] = 'ch/query/add_due_diff_action.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['queryPath'] = 'ch/query/add_due_diff_action.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['nextEvent'] = 'ch.list_due_diff_actions&event=det';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'ch.form_upd_due_diff_action';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'ch/form/upd_due_diff_action.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'ch/form/upd_due_diff_action.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'ch.list_due_diff_actions';
	
	if(IsDefined("attributes.event") and  (attributes.event is 'det' or attributes.event is 'del' ))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ch.emptypopup_del_due_diff_action&due_diff_id=#attributes.due_diff_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'ch/query/del_due_diff_action.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'ch/query/del_due_diff_action.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.list_due_diff_actions';
	}
		if(IsDefined("attributes.event") and attributes.event is 'det')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=ch.list_due_diff_actions&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'dueDiffActions';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CARI_DUE_DIFF_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-11','item-12']"; 
</cfscript>
