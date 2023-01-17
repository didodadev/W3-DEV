<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact="contract.list_progress">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.startdate" default="">
    <cfparam name="attributes.finishdate" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.progress_type" default="">
    <cfparam name="attributes.is_invoice" default="">
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_emp_name" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.order_progress" default="4">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.form_submitted")>
        <cfif Len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
        <cfif Len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
        <cfquery name="get_progress_payment" datasource="#dsn3#">
            SELECT
                PP.*,
                ISNULL(RC.CONTRACT_TAX,0) AS CONTRACT_TAX,
                ISNULL(RC.STOPPAGE_RATE,0) AS STOPPAGE_RATE,
                RC.STOPPAGE_RATE_ID,
                PRO_PROJECTS.PROJECT_HEAD,
                PRO_PROJECTS.DEPARTMENT_ID,
                PRO_PROJECTS.LOCATION_ID,
                COMPANY.FULLNAME AS COMPANY_NAME,
                CONSUMER.CONSUMER_NAME +' '+  CONSUMER.CONSUMER_SURNAME AS CONSUMER_NAME
            FROM 
                PROGRESS_PAYMENT PP
                LEFT JOIN RELATED_CONTRACT RC ON RC.CONTRACT_ID = PP.CONTRACT_ID
                LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = PP.PROJECT_ID
                LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = PP.COMPANY_ID
                LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = PP.CONSUMER_ID
                <cfif len(attributes.is_invoice)>
                    LEFT JOIN #dsn2_alias#.INVOICE ON INVOICE.PROGRESS_ID = PP.PROGRESS_ID AND FROM_PROGRESS = 1
                </cfif>
            WHERE
                1 = 1
                <cfif len(attributes.company_id) and len(attributes.company)>
                    AND PP.COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
                </cfif>
                <cfif len(attributes.consumer_id) and len(attributes.company)>
                    AND PP.CONSUMER_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
                </cfif>
                <cfif len(attributes.keyword)>
                    AND PP.PROGRESS_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                </cfif>
                <cfif Len(attributes.project_id) and Len(attributes.project_head)>
                    AND PP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>
                <cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
                    AND PP.RECORD_EMP = #attributes.record_emp_id#
                </cfif>
                <cfif attributes.is_invoice eq 1>
                    AND INVOICE_NUMBER IS NOT NULL
                <cfelseif attributes.is_invoice eq 2>
                    AND INVOICE_NUMBER IS NULL
                </cfif>
                <cfif attributes.progress_type eq 1>
                    AND PP.PROGRESS_TYPE = 1
                <cfelseif attributes.progress_type eq 2>
                    AND PP.PROGRESS_TYPE = 2
                </cfif>
                <cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>
                    AND PROGRESS_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                <cfelseif isdate(attributes.startdate)>
                    AND PROGRESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                <cfelseif isdate(attributes.finishdate)>
                    AND PROGRESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                </cfif>
                <cfif len(attributes.order_progress)>
                    ORDER BY
                    <cfif attributes.order_progress eq 1>
                        PROGRESS_DATE 
                    <cfelseif attributes.order_progress eq 2>
                        PROGRESS_DATE DESC
                    <cfelseif attributes.order_progress eq 3>
                        CAST(REPLACE(PROGRESS_NO,'-','.')AS FLOAT)
                    <cfelseif attributes.order_progress eq 4>
                        CAST(REPLACE(PROGRESS_NO,'-','.')AS FLOAT) DESC
                    </cfif>
                </cfif>
        </cfquery>
    <cfelse>
        <cfset get_progress_payment.recordcount = 0>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#get_progress_payment.recordcount#">
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>  
	<!--- <cfif isdefined('attributes.id') and len(attributes.id)>
        <script language="javascript">
            <cfoutput>
                window.open('#request.self#?fuseaction=contract.popup_detail_progress&id=#attributes.id#','list'); 
            </cfoutput>
        </script>
    </cfif> --->
    <cf_xml_page_edit fuseact="contract.add_progress_payment">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.contract_id" default="">
    <cfparam name="attributes.contract_no" default="">
    <cfparam name="attributes.contract_type" default="1">
    <cfif isdefined('attributes.form_submited')>
        <cfquery name="get_contracts" datasource="#dsn3#">
            SELECT 
                COMPANY_ID,
                CONSUMER_ID,
                CONTRACT_ID,
                CONTRACT_NO,
                CONTRACT_MONEY,
                ISNULL(CONTRACT_TAX,0) CONTRACT_TAX,
                CONTRACT_CALCULATION,
                ISNULL(GUARANTEE_RATE,0) GUARANTEE_RATE,
                ISNULL(ADVANCE_RATE,0) ADVANCE_RATE,
                ISNULL(TEVKIFAT_RATE,0) TEVKIFAT_RATE,
                ISNULL(STOPPAGE_RATE,0) STOPPAGE_RATE,
                ISNULL(DISCOUNT_RATE,0) DISCOUNT_RATE
            FROM 
                RELATED_CONTRACT
            WHERE 
                STATUS = 1 AND
                OUR_COMPANY_ID = #session.ep.company_id# AND
                CONTRACT_TYPE = #attributes.contract_type# 
                <cfif len(attributes.contract_id) and len(attributes.contract_no)>
                    AND CONTRACT_ID = #attributes.contract_id# 
                </cfif>
                <cfif len(attributes.project_id) and len(attributes.project_head)>
                    AND PROJECT_ID = #attributes.project_id# 
                </cfif>
                <cfif len(attributes.company_id) and len(attributes.member_name)>
                    AND COMPANY_ID = #attributes.company_id#
                </cfif>
                <cfif len(attributes.consumer_id) and len(attributes.member_name)>
                    AND CONSUMER_ID = #attributes.consumer_id#
                </cfif>
        </cfquery>
    <cfelse>
        <cfset get_contracts.recordcount = 0>
    </cfif>
    <cfset contract_id_list = ''>
    <cfif get_contracts.recordcount>
        <!--- bir önceki kayıtlı hakedisler --->
        <cfset contract_id_list = valuelist(get_contracts.CONTRACT_ID,',')>
        <cfquery name="getProgress" datasource="#dsn3#">
            SELECT CONTRACT_ID,PROGRESS_VALUE FROM PROGRESS_PAYMENT WHERE CONTRACT_ID IN (#contract_id_list#)
        </cfquery>
        <!---sözlesme ile ilişkili isler 
            CONTRACT_CALCULATION = 1 %
            CONTRACT_CALCULATION = 2 Süre
            CONTRACT_CALCULATION = 3 Miktar
        --->
        <cfquery name="getContractWorks" datasource="#dsn3#">
            SELECT 
                RC.CONTRACT_ID,
                RC.CONTRACT_CALCULATION,
                RC.CONTRACT_AMOUNT,
                PW.WORK_ID,
                PW.ESTIMATED_TIME,
                PW.TO_COMPLETE,
                PW.SALE_CONTRACT_AMOUNT,
                PW.PURCHASE_CONTRACT_AMOUNT,
                PW.COMPLETED_AMOUNT,
                ISNULL((
                CASE 
                <cfif attributes.contract_type eq 1>
                    WHEN (RC.CONTRACT_CALCULATION = 1) THEN ((ISNULL(RC.CONTRACT_AMOUNT,0)/#dsn_alias#.IS_ZERO(ISNULL((SELECT SUM(CAST(ESTIMATED_TIME AS FLOAT))/60 FROM #dsn_alias#.PRO_WORKS WHERE PURCHASE_CONTRACT_ID = RC.CONTRACT_ID),0),1))*(ISNULL(CAST(ESTIMATED_TIME AS FLOAT),0)/60)*(ISNULL(CAST(TO_COMPLETE AS FLOAT),0)/100))
                <cfelse>
                    WHEN (RC.CONTRACT_CALCULATION = 1) THEN ((ISNULL(RC.CONTRACT_AMOUNT,0)/#dsn_alias#.IS_ZERO(ISNULL((SELECT SUM(CAST(ESTIMATED_TIME AS FLOAT))/60 FROM #dsn_alias#.PRO_WORKS WHERE SALE_CONTRACT_ID = RC.CONTRACT_ID),0),1))*(ISNULL(CAST(ESTIMATED_TIME AS FLOAT),0)/60)*(ISNULL(CAST(TO_COMPLETE AS FLOAT),0)/100))
                </cfif>
                    WHEN (RC.CONTRACT_CALCULATION = 2) THEN ((SELECT SUM(((ISNULL(CAST(TOTAL_TIME_HOUR AS FLOAT),0)*60) + ISNULL(CAST(TOTAL_TIME_MINUTE AS FLOAT),0))/60) AS HARCANAN_ZAMAN FROM #dsn_alias#.PRO_WORKS_HISTORY PWH WHERE PWH.WORK_ID = PW.WORK_ID)* CASE WHEN (RC.CONTRACT_TYPE =1) THEN ISNULL(PW.PURCHASE_CONTRACT_AMOUNT,0) WHEN (RC.CONTRACT_TYPE =2) THEN ISNULL(PW.SALE_CONTRACT_AMOUNT,0) ELSE 0 END )
                    WHEN (RC.CONTRACT_CALCULATION = 3) THEN ((ISNULL(PW.COMPLETED_AMOUNT,0)*CASE WHEN (RC.CONTRACT_TYPE =1) THEN ISNULL(PW.PURCHASE_CONTRACT_AMOUNT,0) WHEN (RC.CONTRACT_TYPE =2) THEN ISNULL(PW.SALE_CONTRACT_AMOUNT,0) ELSE 0 END ))
                ELSE 0
                END),0) AS PROGRESS
            FROM	
                RELATED_CONTRACT RC,
                #dsn_alias#.PRO_WORKS PW
            WHERE
                <cfif attributes.contract_type eq 1>
                    PW.PURCHASE_CONTRACT_ID = RC.CONTRACT_ID AND	
                <cfelse>
                    PW.SALE_CONTRACT_ID = RC.CONTRACT_ID AND	
                </cfif>
                RC.STATUS = 1 AND
                RC.CONTRACT_ID IN (#contract_id_list#)
            ORDER BY
                CONTRACT_ID
        </cfquery>
        
        <!--- dekontlu dönemsel kesintiler sözlesme taseron tipli ise borc dekontları isveren tipli ise alacak dekontları gelir --->
        <cfquery name="getContractReceipt" datasource="#dsn2#">
            SELECT 
                ACTION_ID,
                CASE WHEN (ACTION_CURRENCY_ID = '#session.ep.money#') 
                THEN 
                    ACTION_VALUE 
                ELSE 
                    (ACTION_VALUE*(SELECT (RATE2/RATE1) FROM CARI_ACTION_MONEY CM WHERE CM.ACTION_ID = CARI_ACTIONS.ACTION_ID AND CM.MONEY_TYPE = ACTION_CURRENCY_ID))
                END AS ACTION_VALUE,
                '#session.ep.money#' ACTION_CURRENCY_ID,
                CONTRACT_ID,
                MULTI_ACTION_ID
            FROM
                CARI_ACTIONS
            WHERE
                ACTION_VALUE > 0
                AND CONTRACT_ID IN (#contract_id_list#)
                --AND (TO_CMP_ID = #attributes.company_id# OR FROM_CMP_ID = #attributes.company_id# )
                AND PROGRESS_ID IS NULL
                <cfif attributes.contract_type eq 1> AND ACTION_TYPE_ID = 41<cfelse> AND ACTION_TYPE_ID = 42</cfif>
        </cfquery>
        <!--- Faturalı Dönemsel Kesintiler sözlesme taseron tipli ise satıs faturaları isveren tipli ise alıs faturaları gelir--->
        <cfquery name="getContractInvoice" datasource="#dsn2#">
            SELECT 
                INVOICE_ID,
                GROSSTOTAL ACTION_VALUE,
                '#session.ep.money#' ACTION_CURRENCY_ID,
                CONTRACT_ID
            FROM 
                INVOICE
            WHERE
                INVOICE_ID > 0
                <cfif attributes.contract_type eq 1>
                    AND PURCHASE_SALES = 1 
                    AND INVOICE_CAT NOT IN(67,69)
                <cfelse>
                    AND PURCHASE_SALES = 0
                </cfif>
                AND IS_IPTAL = 0 
                AND CONTRACT_ID IN (#contract_id_list#)
                AND PROGRESS_ID IS NULL
        </cfquery>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_contracts.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

</cfif>
<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	document.getElementById('keyword').focus();
	function kontrol()
		{
			if( !date_check(document.getElementById('startdate'),document.getElementById('finishdate'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
	function KontrolEt_Gonder(type,satir_no)
	{
		document.add_hakedis_fatura.project_id.value = eval('add_hakedis_fatura.project_id_' + satir_no).value;
		document.add_hakedis_fatura.department_id.value = eval('add_hakedis_fatura.department_id_' + satir_no).value;
		document.add_hakedis_fatura.location_id.value = eval('add_hakedis_fatura.location_id_' + satir_no).value;
		document.add_hakedis_fatura.stock_id.value = eval('add_hakedis_fatura.stock_id_' + satir_no).value;
		document.add_hakedis_fatura.company_id.value = eval('add_hakedis_fatura.company_id_' + satir_no).value;
		document.add_hakedis_fatura.net_total.value = eval('add_hakedis_fatura.net_total_' + satir_no).value;
		document.add_hakedis_fatura.net_total_money.value = eval('add_hakedis_fatura.net_total_money_' + satir_no).value;
		document.add_hakedis_fatura.invoice_tax.value = eval('add_hakedis_fatura.invoice_tax_' + satir_no).value;
		document.add_hakedis_fatura.contract_id.value = eval('add_hakedis_fatura.contract_id_' + satir_no).value;
		document.add_hakedis_fatura.progress_id.value = eval('add_hakedis_fatura.progress_id_' + satir_no).value;
		
		document.add_hakedis_fatura.stoppage_amount.value = eval('add_hakedis_fatura.stoppage_amount_' + satir_no).value;
		document.add_hakedis_fatura.stoppage_rate.value = eval('add_hakedis_fatura.stoppage_rate_' + satir_no).value;
		document.add_hakedis_fatura.stoppage_rate_id.value = eval('add_hakedis_fatura.stoppage_rate_id_' + satir_no).value;
		
		if(type == 1)		
			add_hakedis_fatura.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase</cfoutput>";
		else
			add_hakedis_fatura.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill</cfoutput>";
			
		add_hakedis_fatura.submit();
	}
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	function control()
	{
		if((document.all.company_id.value == '' || document.all.member_name.value == '') && (document.all.consumer_id.value == '' || document.all.member_name.value == '') && (document.all.contract_id.value == '' || document.all.contract_no.value == ''))
		{
			alert('<cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="107.Cari Hesap"> <cf_get_lang_main no="586.veya"> <cf_get_lang_main no="1725.Sözleşme">');
			return false;
		}
		document.progress_report.submit();
	}
	
	function degeriata(satir_no)
	{	
		document.add_hakedis_fatura.contract_id.value = eval('add_hakedis_fatura.contract_id_' + satir_no).value;
		document.add_hakedis_fatura.company_id.value = eval('add_hakedis_fatura.company_id_' + satir_no).value;
		document.add_hakedis_fatura.consumer_id.value = eval('add_hakedis_fatura.consumer_id_' + satir_no).value;
		document.add_hakedis_fatura.action_value.value = eval('add_hakedis_fatura.gross_total_' + satir_no).value;
		document.add_hakedis_fatura.gross_progress_value.value = eval('add_hakedis_fatura.gross_total_' + satir_no).value;
		document.add_hakedis_fatura.today_progress_value.value = eval('add_hakedis_fatura.today_total_' + satir_no).value;
		document.add_hakedis_fatura.net_progress_value.value = eval('add_hakedis_fatura.net_progress_' + satir_no).value;
		document.add_hakedis_fatura.tevkifat_amount_value.value = eval('add_hakedis_fatura.tevkifat_amount_' + satir_no).value;
		document.add_hakedis_fatura.action_currency_id.value = eval('add_hakedis_fatura.net_total_money_' + satir_no).value;
	}
	function KontrolEt_Gonder()
	{
		var kontrol_ = 0;
		for (var i=0; i < <cfoutput>#get_contracts.recordcount#</cfoutput>; i++)
		{
			if((document.add_hakedis_fatura.line_id[i]!=undefined && document.add_hakedis_fatura.line_id[i].checked == true) || (document.add_hakedis_fatura.line_id!=undefined && document.add_hakedis_fatura.line_id.checked == true))
				var kontrol_ = 1;
		}
		if(kontrol_ == 0)
		{
			alert('<cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="1096.Satır">!');
			return false;
		}
		if(document.add_hakedis_fatura.company_id.value == '' && document.add_hakedis_fatura.consumer_id.value == '')
		{
			alert('<cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="107.Cari Hesap">!');
			return false;
		}
		
		if(add_hakedis_fatura.stock_id.value=="" || add_hakedis_fatura.stock_name.value=="")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='245.Ürün'>");
			return false;
		}
		
		add_hakedis_fatura.action="<cfoutput>#request.self#?fuseaction=contract.emptypopup_add_progress_payment</cfoutput>";
		add_hakedis_fatura.submit();
	}
</cfif>
</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'contract.list_progress';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'contract/display/list_progress.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'contract.list_progress';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'contract/form/add_progress_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'contract/query/add_progress_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'contract.list_progress&event=upd';
	

		
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Upd //	
	
</cfscript>
