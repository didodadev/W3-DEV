<cfif (isdefined("attributes.event") and attributes.event eq "list") or not isdefined("attributes.event")>
	<cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.employee_name" default="">
    <cfparam name="attributes.source_system" default="">
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
            SELECT
                FILE_IMPORTS.*,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME RECORD_EMPLOYEE
            FROM
                FILE_IMPORTS
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON FILE_IMPORTS.RECORD_EMP = E.EMPLOYEE_ID
            WHERE
                PROCESS_TYPE = -8 AND
                FILE_IMPORTS.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
            <cfif len(attributes.source_system)>
                AND SOURCE_SYSTEM = #attributes.source_system#
            </cfif>
            <cfif len(attributes.employee_name) and len(attributes.employee_id)>
                AND RECORD_EMP = #attributes.employee_id#
            </cfif>
            ORDER BY
                I_ID DESC
        </cfquery>
    <cfelse>
        <cfset arama_yapilmali = 1>
        <cfset GET_PROVISION_IMPORTS.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#GET_PROVISION_IMPORTS.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif (isdefined("attributes.event") and attributes.event eq "add_import")>
	<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
        SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY = '#session.ep.money2#'
    </cfquery>
<cfelseif (isdefined("attributes.event") and attributes.event eq "det_pos")>
    <cfquery name="GET_PROVISION_IMPORTS" datasource="#dsn2#">
        SELECT
            F_I_ROW.IS_CANCEL,
            F_I_ROW.SELLER_CODE,
            F_I_ROW.TERMINAL_NO,
            F_I_ROW.PROCESS_DATE,
            F_I_ROW.VALOR_DATE,
            F_I_ROW.POS_PROCESS_TYPE,
            F_I_ROW.NUMBER_OF_INSTALMENT,
            F_I_ROW.COMMISSION,
            F_I_ROW.MONEY2_MULTIPLIER,
            F_I_ROW.AWARD,
            F_I_ROW.GROSS_TOTAL,
            F_I_ROW.CARI_TUTAR,
            F_I_ROW.NET_TOTAL,
            F_I_ROW.FILE_IMPORT_BANK_POS_ROW_ID,
            F_I_ROW.BANK_TYPE,
            F_I_ROW.CC_REVENUE_ID,
            POS_EQUIPMENT_BANK.COMPANY_ID,
            C.NICKNAME
        FROM
            FILE_IMPORT_BANK_POS_ROWS F_I_ROW,
            #dsn3_alias#.POS_EQUIPMENT_BANK POS_EQUIPMENT_BANK
            LEFT JOIN #dsn_alias#.COMPANY C ON POS_EQUIPMENT_BANK.COMPANY_ID = C.COMPANY_ID
        WHERE
            FILE_IMPORT_ID = #attributes.I_ID# AND
            F_I_ROW.SELLER_CODE = POS_EQUIPMENT_BANK.SELLER_CODE
    UNION ALL
        SELECT
            F_I_ROW.IS_CANCEL,
            F_I_ROW.SELLER_CODE,
            F_I_ROW.TERMINAL_NO,
            F_I_ROW.PROCESS_DATE,
            F_I_ROW.VALOR_DATE,
            F_I_ROW.POS_PROCESS_TYPE,
            F_I_ROW.NUMBER_OF_INSTALMENT,
            F_I_ROW.COMMISSION,
            F_I_ROW.MONEY2_MULTIPLIER,
            F_I_ROW.AWARD,
            F_I_ROW.GROSS_TOTAL,
            F_I_ROW.CARI_TUTAR,
            F_I_ROW.NET_TOTAL,
            F_I_ROW.FILE_IMPORT_BANK_POS_ROW_ID,
            F_I_ROW.BANK_TYPE,
            F_I_ROW.CC_REVENUE_ID,
            0 COMPANY_ID,
            '' NICKNAME
        FROM
            FILE_IMPORT_BANK_POS_ROWS F_I_ROW
        WHERE
            FILE_IMPORT_ID = #attributes.I_ID# AND
            F_I_ROW.SELLER_CODE NOT IN 
            (
                SELECT SELLER_CODE FROM #dsn3_alias#.POS_EQUIPMENT_BANK
            ) 
        ORDER BY
            F_I_ROW.FILE_IMPORT_BANK_POS_ROW_ID
    </cfquery>
    <cfsavecontent variable="head_">
        <cfif GET_PROVISION_IMPORTS.BANK_TYPE eq 10>Akbank
        <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 11>İşBankası
        <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 12>HSBC
        <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 13>Garanti
        <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 14>YapıKredi
        <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 15>Finansbank
        </cfif>
        <cf_get_lang no ='337.Banka Pos Satırları'>
    </cfsavecontent>
<cfelseif isdefined("attributes.event") and (attributes.event eq "det_rev" or attributes.event eq "add_rev")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_process_cancel" default="0">
    <cfquery name="GET_PROVISION_IMPORTS" datasource="#dsn2#">
        SELECT
            FILE_IMPORT_BANK_POS_ROW_ID,
            F_I_ROW.SELLER_CODE,
            TERMINAL_NO,
            PROCESS_DATE,
            VALOR_DATE,
            BANK_TYPE,
            C.COMPANY_ID,
            ACCOUNT_ID,
            NET_TOTAL,
            COMMISSION,
            NUMBER_OF_INSTALMENT,
            AWARD,
            GROSS_TOTAL,
            CARI_TUTAR,
            POS_PROCESS_TYPE,
            EQUIPMENT,
            1 DEF_INFO,<!--- banka pos tanımlarda kaydı olması durumu --->
            F_I_ROW.IS_CANCEL,
            C.NICKNAME
        FROM
            FILE_IMPORT_BANK_POS_ROWS F_I_ROW,
            #dsn3_alias#.POS_EQUIPMENT_BANK POS_EQUIPMENT_BANK
            LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = POS_EQUIPMENT_BANK.COMPANY_ID
        WHERE
            F_I_ROW.SELLER_CODE = POS_EQUIPMENT_BANK.SELLER_CODE AND
            F_I_ROW.FILE_IMPORT_ID = #attributes.i_id# AND
            F_I_ROW.CC_REVENUE_ID IS NULL
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                AND DATEDIFF(d,PROCESS_DATE,VALOR_DATE) = #attributes.keyword#
            </cfif>
            <cfif isDefined("attributes.is_process_cancel") and len(attributes.is_process_cancel)>
                AND F_I_ROW.IS_CANCEL = #attributes.is_process_cancel#
            </cfif>
    UNION ALL
        SELECT
            FILE_IMPORT_BANK_POS_ROW_ID,
            F_I_ROW.SELLER_CODE,
            TERMINAL_NO,
            PROCESS_DATE,
            VALOR_DATE,
            BANK_TYPE,
            0 COMPANY_ID,
            0 ACCOUNT_ID,
            NET_TOTAL,
            COMMISSION,
            NUMBER_OF_INSTALMENT,
            AWARD,
            GROSS_TOTAL,
            CARI_TUTAR,
            POS_PROCESS_TYPE,
            '' EQUIPMENT,
            0 DEF_INFO,
            F_I_ROW.IS_CANCEL,
            '' NICKNAME
        FROM
            FILE_IMPORT_BANK_POS_ROWS F_I_ROW
        WHERE
            F_I_ROW.FILE_IMPORT_ID = #attributes.i_id# AND
            F_I_ROW.CC_REVENUE_ID IS NULL AND
            F_I_ROW.SELLER_CODE NOT IN 
            (
                SELECT SELLER_CODE FROM #dsn3_alias#.POS_EQUIPMENT_BANK POS_EQUIPMENT_BANK
            ) 
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)><!--- kayıt getirmesin diye --->
                AND FILE_IMPORT_BANK_POS_ROW_ID IS NULL
            </cfif>
            <cfif isDefined("attributes.is_process_cancel") and len(attributes.is_process_cancel)>
                AND F_I_ROW.IS_CANCEL = #attributes.is_process_cancel#
            </cfif>
        ORDER BY
            FILE_IMPORT_BANK_POS_ROW_ID
    </cfquery>
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
            <cfif session.ep.period_year lt 2009>
                ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL' AND<!--- toplu pos işlemlerinde sadece ytl işlemler alınabiliyor sisteme --->
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#' AND
            </cfif>
            ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
            CPT.IS_ACTIVE = 1 AND
            POS_TYPE IS NULL<!--- sanal pos ödeme yöntemleri gelmesin --->
        ORDER BY
            ACCOUNTS.ACCOUNT_NAME
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#GET_PROVISION_IMPORTS.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfsavecontent variable="head_">
                <cfif GET_PROVISION_IMPORTS.BANK_TYPE eq 10>Akbank
                <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 11>İşBankası
                <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 12>HSBC
                <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 13>Garanti
                <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 14>YapıKredi
                <cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 15>Finansbank
                </cfif>
                <cf_get_lang no ='337.Banka Pos Satırları'>
    </cfsavecontent>
    <cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
        SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfif attributes.is_process_cancel eq 0> 241 <cfelseif attributes.is_process_cancel eq 1> 245</cfif>
    </cfquery>
</cfif>
<script>
	<cfif (isdefined("attributes.event") and attributes.event eq "list") or not isdefined("attributes.event")>
		$(document).ready(function(){
			document.getElementById('employee_name').focus();
		})
		
		function delMultiPosImport(identity,message)
		{
			if(confirm(message))
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_multi_pos_import&event=del&i_id='+identity,'multiPosImport','','','',pageRefresh());
			else
				return false;
		}
	<cfelseif (isdefined("attributes.event") and attributes.event eq "add_import")>
		function unformat_fields()
		{
			document.getElementById('money_rate2').value = filterNum(document.getElementById('money_rate2').value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			return true;
		}
	</cfif>
	function kontrol()
	{
		<cfif (isdefined("attributes.event") and attributes.event eq "list") or not isdefined("attributes.event")>
			if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		<cfelseif (isdefined("attributes.event") and attributes.event eq "add_file")>
			if(pos_import.bank_type.value=="")
			{
				alert("<cf_get_lang no ='88.Banka Seçiniz'>!");
				return false;
			}
			return true;
		</cfif>
	}
	<cfif (isdefined("attributes.event") and (attributes.event eq "list" or attributes.event eq "det_pos")) or not isdefined("attributes.event")>
		function cancelMultiPosImport(identity,message,type)
		{
			if(confirm(message))
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_multi_pos_import&event=cancel_import&'+type+'='+identity,'multiPosImport','','','',pageRefresh());
			else
				return false;
		}
		function pageRefresh()
		{
			location.reload();
		}	
	<cfelseif isdefined("attributes.event") and (attributes.event eq "det_rev" or attributes.event eq "add_rev")>
		function check_all(deger)
		{
			if(document.search_form.hepsi.checked)
			{
				if(search_form.checked_value != undefined)
				{
					if (search_form.checked_value.length > 1)
						for(i=0; i<search_form.checked_value.length; i++) search_form.checked_value[i].checked = true;
					else
						search_form.checked_value.checked = true;
				}
			}
			else
			{
				if(search_form.checked_value != undefined)
				{
					if (search_form.checked_value.length > 1)
						for(i=0; i<search_form.checked_value.length; i++) search_form.checked_value[i].checked = false;
					else
						search_form.checked_value.checked = false;
				}
			}
		}
		function add_cc_revenue()
		{
			if (!chk_process_cat('add_')) return false;
			if(!check_display_files('add_')) return false;
			x = document.add_.action_to_account_id.selectedIndex;
			if (document.add_.action_to_account_id[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='615.Lutfen Odeme Yontemi Seciniz'>");
				return false;
			}
		/*	windowopen('','small','cc_paym');
			add_.action='<cfoutput>#request.self#?fuseaction=bank.emptypopupflush_add_cc_rev_from_bankpos</cfoutput>';
			add_.target='cc_paym';*/
			add_.submit();
			return false;
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_multi_pos_import';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_multi_pos_import.cfm';
	
	WOStruct['#attributes.fuseaction#']['add_file'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_file']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add_file']['fuseaction'] = 'bank.list_multi_pos_import';
	WOStruct['#attributes.fuseaction#']['add_file']['filePath'] = 'bank/form/add_pos_import_file.cfm';
	WOStruct['#attributes.fuseaction#']['add_file']['queryPath'] = 'bank/query/add_pos_import_file.cfm';
	WOStruct['#attributes.fuseaction#']['add_file']['nextEvent'] = 'bank.list_multi_pos_import';
	
	WOStruct['#attributes.fuseaction#']['add_import'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_import']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add_import']['fuseaction'] = 'bank.list_multi_pos_import';
	WOStruct['#attributes.fuseaction#']['add_import']['filePath'] = 'bank/form/add_currency_info.cfm';
	WOStruct['#attributes.fuseaction#']['add_import']['queryPath'] = 'bank/query/import_pos_file.cfm';
	WOStruct['#attributes.fuseaction#']['add_import']['nextEvent'] = 'bank.list_multi_pos_import';
	WOStruct['#attributes.fuseaction#']['add_import']['parameters'] = 'i_id=##attributes.i_id##';
	WOStruct['#attributes.fuseaction#']['add_import']['Identity'] = '##attributes.i_id##';
	
	if(attributes.event is 'list' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.list_multi_pos_import';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_pos_import_file.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_pos_import_file.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_multi_pos_import';
	}
	if(attributes.event is 'list' or attributes.event is 'cancel_import' or attributes.event eq "det_pos")
	{
		WOStruct['#attributes.fuseaction#']['cancel_import'] = structNew();
		WOStruct['#attributes.fuseaction#']['cancel_import']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['cancel_import']['fuseaction'] = 'bank.list_multi_pos_import';
		WOStruct['#attributes.fuseaction#']['cancel_import']['filePath'] = 'bank/query/del_bank_pos_rows.cfm';
		WOStruct['#attributes.fuseaction#']['cancel_import']['queryPath'] = 'bank/query/del_bank_pos_rows.cfm';
		WOStruct['#attributes.fuseaction#']['cancel_import']['nextEvent'] = 'bank.list_multi_pos_import';
	}
	if(attributes.event is 'list' or attributes.event is 'det_pos')
	{
		WOStruct['#attributes.fuseaction#']['det_pos'] = structNew();
		WOStruct['#attributes.fuseaction#']['det_pos']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['det_pos']['fuseaction'] = 'bank.list_multi_pos_import';
		WOStruct['#attributes.fuseaction#']['det_pos']['filePath'] = 'bank/display/list_import_bank_pos_rows.cfm';
		WOStruct['#attributes.fuseaction#']['det_pos']['queryPath'] = 'bank/display/list_import_bank_pos_rows.cfm';
		WOStruct['#attributes.fuseaction#']['det_pos']['nextEvent'] = 'bank.list_multi_pos_import';
	}
	if(attributes.event is 'list' or attributes.event is 'det_rev')
	{
		WOStruct['#attributes.fuseaction#']['det_rev'] = structNew();
		WOStruct['#attributes.fuseaction#']['det_rev']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['det_rev']['fuseaction'] = 'bank.list_multi_pos_import';
		WOStruct['#attributes.fuseaction#']['det_rev']['filePath'] = 'bank/display/list_bank_pos_rows.cfm';
		WOStruct['#attributes.fuseaction#']['det_rev']['queryPath'] = 'bank/display/list_bank_pos_rows.cfm';
		WOStruct['#attributes.fuseaction#']['det_rev']['nextEvent'] = 'bank.list_multi_pos_import';
	}
	if(attributes.event is 'det_rev' or attributes.event is 'add_rev')
	{
		WOStruct['#attributes.fuseaction#']['det_rev'] = structNew();
		WOStruct['#attributes.fuseaction#']['det_rev']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['det_rev']['fuseaction'] = 'bank.list_multi_pos_import';
		WOStruct['#attributes.fuseaction#']['det_rev']['filePath'] = 'bank/display/list_bank_pos_rows.cfm';
		WOStruct['#attributes.fuseaction#']['det_rev']['queryPath'] = 'bank/query/add_cc_rev_from_bankpos.cfm';
		WOStruct['#attributes.fuseaction#']['det_rev']['nextEvent'] = 'bank.list_multi_pos_import';
	}
</cfscript>
