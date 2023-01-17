<cf_get_lang_set module_name="bank">
<cfif  IsDefined("attributes.event") and attributes.event eq 'add'>
<script type="text/javascript">
function kontrol()
{
	if(provision_import.key_type.value == "")
	{
		alert("<cf_get_lang no ='303.Anahtar Giriniz'>!");
		return false;
	}
	if(provision_import.bank_type.value=="")
	{
		alert("<cf_get_lang no ='88.Banka Seçiniz'>!");
		return false;
	}
	return true;
}
</script>
</cfif>
<cfif  IsDefined("attributes.event") and attributes.event eq 'addp'>
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO
	FROM
		ACCOUNTS ACCOUNTS,
		CREDITCARD_PAYMENT_TYPE CPT
	WHERE
		ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT
		<cfif session.ep.period_year lt 2009>
			AND (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')  
		<cfelse>
			AND ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) 
		</cfif>
		AND CPT.IS_ACTIVE = 1
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
<cfquery name="GET_PERIODS" datasource="#dsn#">
    SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
</cfquery>
<script type="text/javascript">
provision_import.key_type.focus();
function control()
{  
	if (!chk_process_cat('provision_import')) return false;
	if(!check_display_files('provision_import')) return false;
	x = document.provision_import.action_to_account_id.selectedIndex;
	if (document.provision_import.action_to_account_id[x].value == "")
	{ 
		alert ("Ödeme Yöntemi Seçiniz!");
		return false;
	}
	if(provision_import.key_type.value == "")
	{
		alert("Şifre Giriniz!");
		return false;
	}
	return true;
}
</script>
</cfif>

<cfif not IsDefined("attributes.event") or attributes.event eq 'list'>
	<cfparam name="attributes.bank_type" default="">
	<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
        <cf_date tarih='attributes.start_date'>
    <cfelse>
        <cfset attributes.start_date = date_add('d',-1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
    </cfif>
    <cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
        <cf_date tarih='attributes.finish_date'>
    <cfelse>
        <cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
    </cfif>
	<cfif isdefined("attributes.form_varmi")>
	<cfset arama_yapilmali = 0>
        <cfquery name="GET_PROVISION_IMPORTS" datasource="#dsn2#">
            SELECT<!--- tahsilat kaydı yapabilmiş olanlar --->
                SUM(CREDIT_CARD_BANK_PAYMENTS.SALES_CREDIT) TOPLAM_TUTAR,
                COUNT(CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID) ADET,		
                FILE_IMPORTS.I_ID,
                FILE_IMPORTS.RECORD_EMP,
                FILE_IMPORTS.RECORD_DATE,
                FILE_IMPORTS.SOURCE_SYSTEM,
                FILE_IMPORTS.IMPORTED,
                FILE_IMPORTS.FILE_NAME,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME
            FROM
                FILE_IMPORTS
                LEFT JOIN #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS ON CREDIT_CARD_BANK_PAYMENTS.FILE_IMPORT_ID = FILE_IMPORTS.I_ID 
                LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEE_ID = FILE_IMPORTS.RECORD_EMP
            WHERE
                FILE_IMPORTS.PROCESS_TYPE = -7 AND
                CREDIT_CARD_BANK_PAYMENTS.ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                FILE_IMPORTS.IMPORTED = 1 AND
                FILE_IMPORTS.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
            <cfif len(attributes.bank_type)>
                AND SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">
            </cfif>
            GROUP BY
                FILE_IMPORTS.I_ID,
                FILE_IMPORTS.RECORD_EMP,
                FILE_IMPORTS.RECORD_DATE,
                FILE_IMPORTS.SOURCE_SYSTEM,
                FILE_IMPORTS.IMPORTED,
                FILE_IMPORTS.FILE_NAME,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME
            UNION
            SELECT<!--- import edilmemiş olanlar veya import edilip tahsilat kaydı yapamamış olanlar --->
                '' TOPLAM_TUTAR,
                '' ADET,		
                I_ID,
                FILE_IMPORTS.RECORD_EMP,
                FILE_IMPORTS.RECORD_DATE,
                FILE_IMPORTS.SOURCE_SYSTEM,
                FILE_IMPORTS.IMPORTED,
                FILE_IMPORTS.FILE_NAME,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME
            FROM
                FILE_IMPORTS
                LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEE_ID = FILE_IMPORTS.RECORD_EMP
            WHERE
                PROCESS_TYPE = -7 AND<!--- Toplu Provizyon Import --->
                FILE_IMPORTS.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#"> AND
                (
                        FILE_IMPORTS.IMPORTED = 0
                    OR
                    (
                        FILE_IMPORTS.IMPORTED = 1 AND
                        FILE_IMPORTS.I_ID NOT IN (SELECT FILE_IMPORT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE FILE_IMPORT_ID IS NOT NULL AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
                    )
                )
            <cfif len(attributes.bank_type)>
                AND SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">
            </cfif>
            ORDER BY
                FILE_IMPORTS.I_ID DESC
        </cfquery>
    <cfelse>
        <cfset arama_yapilmali = 1>
        <cfset GET_PROVISION_IMPORTS.recordcount = 0>
    </cfif>
    <script>
	function kontrol()
	{
		if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
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
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_multi_provision_import';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_multi_provision_import.cfm';
	
	if( IsDefined("attributes.event") and attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=bank.emptypopup_del_provision_file';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_provision_file.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_provision_file.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_multi_provision_import';
	}
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'bank.list_multi_provision_import';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'bank/form/open_multi_prov_file.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'bank/query/open_multi_prov_file.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'bank.list_multi_provision';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'export_import_id=##attributes.export_import_id##';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'is_import=1';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.export_import_id##';
	
	WOStruct['#attributes.fuseaction#']['addp'] = structNew();
	WOStruct['#attributes.fuseaction#']['addp']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addp']['fuseaction'] = 'bank.list_multi_provision_import';
	WOStruct['#attributes.fuseaction#']['addp']['filePath'] = 'bank/form/add_provision_import.cfm';
	WOStruct['#attributes.fuseaction#']['addp']['queryPath'] = 'bank/query/import_provision.cfm';
	WOStruct['#attributes.fuseaction#']['addp']['nextEvent'] = 'bank.list_multi_provision_import';
	WOStruct['#attributes.fuseaction#']['addp']['parameters'] = 'i_id=##attributes.I_ID##';
	WOStruct['#attributes.fuseaction#']['addp']['Identity'] = '##attributes.I_ID##';
	
	WOStruct['#attributes.fuseaction#']['importback'] = structNew();
	WOStruct['#attributes.fuseaction#']['importback']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['importback']['fuseaction'] = 'bank.list_multi_provision_import';
	WOStruct['#attributes.fuseaction#']['importback']['filePath'] = 'bank/form/open_multi_prov_file.cfm';
	WOStruct['#attributes.fuseaction#']['importback']['queryPath'] = 'bank/query/del_provision_import.cfm';
	WOStruct['#attributes.fuseaction#']['importback']['nextEvent'] = 'bank.list_multi_provision_import';
	WOStruct['#attributes.fuseaction#']['importback']['parameters'] = 'is_del_prov=1';
	WOStruct['#attributes.fuseaction#']['importback']['parameters'] = 'export_import_id=##attributes.I_ID##';
	WOStruct['#attributes.fuseaction#']['importback']['Identity'] = '##attributes.I_ID##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.list_multi_provision_import';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/add_multi_provision_import.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/multi_provision_file_import.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_multi_provision_import';
	
	/*
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_creditcard&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'creditcard_id=##attributes.creditcard_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.creditcard_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_creditcard&event=upd';
	
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

