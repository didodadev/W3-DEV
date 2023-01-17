<cf_get_lang_set module_name="bank">
<cfif (isdefined("attributes.event") and attributes.event eq "list") or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact ="bank.popup_add_autopayment_export">
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
    <cfparam name="attributes.source" default="1">
    <cfparam name="attributes.bank_name" default="">
    <cfparam name="attributes.bank" default="">
	<cfif isdefined("attributes.is_submitted")>
        <cfquery name="GET_AUTOPAYMENTS" datasource="#DSN2#">
            <!--- tahsilat kaydi yapabilmis olanlar --->
            SELECT
                SUM(ROUND(BANK_ACTIONS.ACTION_VALUE,2)) TOPLAM_TUTAR,
                COUNT(BANK_ACTIONS.ACTION_ID) ADET,		
                FILE_IMPORTS.I_ID,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME FULLNAME,
                FILE_IMPORTS.RECORD_EMP,
                FILE_IMPORTS.RECORD_DATE,
                SBT.BANK_NAME,
                FILE_IMPORTS.SOURCE_SYSTEM,
                FILE_IMPORTS.IMPORTED,
                FILE_IMPORTS.FILE_NAME,
                FILE_IMPORTS.IS_DBS
            FROM
                FILE_IMPORTS
                LEFT JOIN BANK_ACTIONS ON BANK_ACTIONS.FILE_IMPORT_ID = FILE_IMPORTS.I_ID
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = FILE_IMPORTS.RECORD_EMP
                LEFT JOIN #dsn_alias#.SETUP_BANK_TYPES SBT ON SBT.BANK_ID = FILE_IMPORTS.SOURCE_SYSTEM
            WHERE
                FILE_IMPORTS.PROCESS_TYPE = -12 AND<!--- Otomatik odeme Import --->
                FILE_IMPORTS.IMPORTED = 1 AND
                FILE_IMPORTS.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
                <cfif attributes.source eq 2>
                    AND FILE_IMPORTS.IS_DBS = 1
                </cfif>
                <cfif len(attributes.bank) and attributes.source eq 2>
                    AND FILE_IMPORTS.IS_DBS = 1 AND FILE_IMPORTS.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank#">
                </cfif>
                <cfif attributes.source eq 1>
                    AND (FILE_IMPORTS.IS_DBS = 0 OR FILE_IMPORTS.IS_DBS IS NULL)
                </cfif>
                <cfif len(attributes.bank_name) and attributes.source eq 1>
                    AND FILE_IMPORTS.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_name#">
                </cfif>
            GROUP BY
                FILE_IMPORTS.I_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                FILE_IMPORTS.RECORD_EMP,
                FILE_IMPORTS.RECORD_DATE,
                SBT.BANK_NAME,
                FILE_IMPORTS.SOURCE_SYSTEM,
                FILE_IMPORTS.IMPORTED,
                FILE_IMPORTS.FILE_NAME,
                FILE_IMPORTS.IS_DBS
            
            UNION
            <!--- import edilmemis olanlar veya import edilip tahsilat kaydı yapamamis olanlar --->
            SELECT
                '' TOPLAM_TUTAR,
                '' ADET,		
                I_ID,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME FULLNAME,
                FILE_IMPORTS.RECORD_EMP,
                FILE_IMPORTS.RECORD_DATE,
                SBT.BANK_NAME,
                FILE_IMPORTS.SOURCE_SYSTEM,
                IMPORTED,
                FILE_NAME,
                IS_DBS
            FROM
                FILE_IMPORTS
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = FILE_IMPORTS.RECORD_EMP
                LEFT JOIN #dsn_alias#.SETUP_BANK_TYPES SBT ON SBT.BANK_ID = FILE_IMPORTS.SOURCE_SYSTEM
            WHERE
                PROCESS_TYPE = -12 AND<!--- Otomatik ödeme Import --->
                FILE_IMPORTS.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)# AND
                (
                        FILE_IMPORTS.IMPORTED = 0
                    OR
                    (
                        FILE_IMPORTS.IMPORTED = 1 AND
                        FILE_IMPORTS.I_ID NOT IN (SELECT FILE_IMPORT_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID IS NOT NULL)
                    )
                )
                <cfif attributes.source eq 2>
                    AND FILE_IMPORTS.IS_DBS = 1
                </cfif>
                <cfif len(attributes.bank) and attributes.source eq 2>
                    AND FILE_IMPORTS.IS_DBS = 1 AND FILE_IMPORTS.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank#">
                </cfif>
                <cfif attributes.source eq 1>
                    AND (FILE_IMPORTS.IS_DBS = 0 OR FILE_IMPORTS.IS_DBS IS NULL)
                </cfif>
                <cfif len(attributes.bank_name) and attributes.source eq 1>
                    AND FILE_IMPORTS.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_name#">
                </cfif>
            ORDER BY
                FILE_IMPORTS.I_ID DESC
        </cfquery>
    <cfelse>
        <cfset get_autopayments.recordcount = 0>
    </cfif>
    <cfquery name="get_bank_names" datasource="#dsn#">
		SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
	</cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_autopayments.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif (isdefined("attributes.event") and attributes.event eq "add_file")>
	<cf_xml_page_edit fuseact ="bank.popup_open_multi_prov_file">
	<cfparam name="attributes.source" default="1">
	<cfparam name="attributes.bank" default="">
	<cfquery name="get_bank_names" datasource="#dsn#">
		SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
	</cfquery>
<cfelseif (isdefined("attributes.event") and attributes.event eq "add_incoming")>
	<cf_xml_page_edit fuseact ="bank.popup_add_autopayment_export">
	<cfparam name="attributes.prov_period" default="">
    <cfif isdefined("attributes.i_id")>
        <cfquery name="get_is_dbs" datasource="#dsn2#">
            SELECT IS_DBS FROM FILE_IMPORTS WHERE I_ID = #attributes.i_id#
        </cfquery>
    <cfelse>
        <cfset get_is_dbs.recordcount = 0>
    </cfif>
    <cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
        SELECT
            ACCOUNTS.ACCOUNT_ID,
            ACCOUNTS.ACCOUNT_NAME,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID
            </cfif> 
        FROM
            ACCOUNTS,
            BANK_BRANCH
        WHERE
            ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND
            ACCOUNTS.ACCOUNT_STATUS = 1
            <cfif isdefined("attributes.money_type") and len(attributes.money_type)>
                AND ACCOUNTS.ACCOUNT_CURRENCY_ID = '#attributes.money_type#'
            </cfif>
            <cfif not (isdefined("get_is_dbs.is_dbs") and get_is_dbs.is_dbs eq 1)>
                <cfif not isDefined("attributes.bank_order_type")>
                    <cfif session.ep.period_year lt 2009>
                        AND ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL'<!--- bankadan gelen dosyalarda sadece ytl işlemler yapıldıgı için --->
                    <cfelse>
                        AND ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#'<!--- bankadan gelen dosyalarda sadece ytl işlemler yapıldıgı için --->
                    </cfif>
                </cfif>
            </cfif>
        ORDER BY
            BANK_NAME,
            ACCOUNT_NAME
    </cfquery>
    <cfquery name="get_money_rate" datasource="#dsn2#">
        SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
    </cfquery>
    <cfquery name="GET_PERIODS" datasource="#DSN#">
        SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
    </cfquery>
<cfelseif (isdefined("attributes.event") and attributes.event eq "cancel_import")>
	<!--- islem tarihine ait e-defter varsa silinmesi engelleniyor --->
	<cfif session.ep.our_company_info.is_edefter eq 1>
    	<cfquery name="get_startdate" datasource="#dsn2#">
        	SELECT
            	STARTDATE
            FROM
            	FILE_IMPORTS
            WHERE
            	I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#export_import_id#">
        </cfquery>
        <cfstoredproc procedure="GET_NETBOOK" datasource="#dsn2#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#get_startdate.startdate#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#get_startdate.startdate#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="">
            <cfprocresult name="getNetbook">
		</cfstoredproc>
	
		<cfsavecontent variable="message">
			<cf_get_lang dictionary_id="52611.İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.">
		</cfsavecontent>
		<cfscript>
            if(getNetbook.recordcount)
                abort(message);
        </cfscript>
   </cfif>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and (attributes.event eq "list" or attributes.event eq "add_file")) or not isdefined("attributes.event")>
		$(document).ready(function(){
		
			$('#source').change(function(){
				
				var data = $(this).val();
				
				if( data == 1)
				{
					$('#bank_sistem').show();
					$('#bank_fatura').hide();
				}
				else
				{
					$('#bank_sistem').hide();
					$('#bank_fatura').show();
				}	
			})
		});
		<cfif (not isdefined("attributes.event")) or attributes.event neq "add_file">
			function kontrol()
			{
				if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
					return false;
				else
					return true;
			}
			function delAutoPaymentImport(identity,message)
			{
				if(confirm(message))
					AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_bank_autopayment_import&event=del&i_id='+identity,'autoPaymentImport','','','',pageRefresh());
				else
					return false;
			}
			function pageRefresh()
			{
				location.reload();
			}
		<cfelseif isdefined("attributes.event") and attributes.event eq "add_file">
			function kontrol()
			{
				<cfif is_encrypt_file eq 1>//xml den şifreleme yapılsn
					if(autopayment_import_file.key_type.value == "")
					{
						alert("<cf_get_lang dictionary_id='48964.Anahtar Giriniz!'>");
						return false;
					}
				</cfif>
				//Sistem Odeme Plani Secili Ise
				if(document.getElementById('source').value==1 && document.getElementById('bank_type').value=="")
				{
					alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz!'>");
					return false;
				}
				//Fatura Odeme Plani Secili Ise
				if(document.getElementById('source').value==2 && document.getElementById('bank').value=="")
				{
					alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz!'>");
					return false;
				}
				return true;
			}
		</cfif>
	<cfelseif (isdefined("attributes.event") and attributes.event eq "add_incoming")>
		$(document).ready(function(){
			if(autopayment_import.key_type != undefined)
				autopayment_import.key_type.focus();	
		});
		function control()
		{
			if (!chk_process_cat('autopayment_import')) return false;
			if (!check_display_files('autopayment_import')) return false;
			if (!chk_period(document.autopayment_import.process_date, 'İşlem')) return false;
			var selected_ptype = document.autopayment_import.process_cat.options[document.autopayment_import.process_cat.selectedIndex].value;
			eval('var proc_control = document.autopayment_import.ct_process_type_'+selected_ptype+'.value');
			if(proc_control == 25)//giden havale
			{
				<cfif isDefined("attributes.bank_order_type") and attributes.bank_order_type eq 0>//otomatik havale ekranından gelen banka talimatları için yapıldysa,gelen havale seçmeli
					alert ("<cf_get_lang dictionary_id='52616.Gelen Havale İşlem Tipi Seçiniz'>!");
					return false;
				<cfelseif not isDefined("attributes.bank_order_type")>//otomatik ödeme sayfasndan yapıldıgı durumda,sadece gelen havale yapıyor çünkü
					alert ("<cf_get_lang dictionary_id='52616.Gelen Havale İşlem Tipi Seçiniz'>!");
					return false;
				</cfif>
			}
			else if(proc_control == 24)//gelen havale
			{
				<cfif isDefined("attributes.bank_order_type") and attributes.bank_order_type eq 1>//otomtk havale ekranından giden banka talimatı seçildğnde işlem tipi de giden havale seçilmeli
					alert ("<cf_get_lang dictionary_id='52619.Giden Havale İşlem Tipi Seçiniz'>!");
					return false;
				</cfif>
			}
			<cfif not isDefined("attributes.bank_order_type") or not get_is_dbs.recordcount>
				x = document.autopayment_import.action_to_account_id.selectedIndex;
				if (document.autopayment_import.action_to_account_id[x].value == "")
				{ 
					alert ("<cf_get_lang no ='347.Hesap Seçiniz'>!");
					return false;
				}
			</cfif>
			<cfif isDefined("attributes.i_id") and is_encrypt_file eq 1>// xml den şifreleme yapılsn
				if(autopayment_import.key_type.value == "")
				{
					alert("<cf_get_lang no ='378.Şifre Giriniz'>!");
					return false;
				}
			</cfif>
			<cfif not get_is_dbs.recordcount>
				if(document.getElementById('action_to_account_id').disabled == true)
					document.getElementById('action_to_account_id').disabled = false;
			</cfif>
			return true;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_autopayment_import';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_bank_autopayment_import.cfm';
	
	WOStruct['#attributes.fuseaction#']['add_file'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_file']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_file']['fuseaction'] = 'bank.popup_open_multi_prov_file';
	WOStruct['#attributes.fuseaction#']['add_file']['filePath'] = 'bank/form/add_autopayment_import_file.cfm';
	WOStruct['#attributes.fuseaction#']['add_file']['queryPath'] = 'bank/query/add_autopayment_import_file.cfm';
	WOStruct['#attributes.fuseaction#']['add_file']['nextEvent'] = 'bank.list_bank_autopayment_import';
	
	WOStruct['#attributes.fuseaction#']['add_incoming'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_incoming']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_incoming']['fuseaction'] = 'bank.popup_add_autopayment_export';
	WOStruct['#attributes.fuseaction#']['add_incoming']['filePath'] = 'bank/form/add_autopayment_import.cfm';
	WOStruct['#attributes.fuseaction#']['add_incoming']['queryPath'] = 'bank/query/add_autopayment_import.cfm';
	WOStruct['#attributes.fuseaction#']['add_incoming']['nextEvent'] = 'bank.list_bank_autopayment_import';
	WOStruct['#attributes.fuseaction#']['add_incoming']['parameters'] = 'i_id=##attributes.i_id##';
	WOStruct['#attributes.fuseaction#']['add_incoming']['Identity'] = '##attributes.i_id##';
	
	if(attributes.event is 'list' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.list_bank_autopayment_import';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_provision_file.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_provision_file.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_autopayment_import';
	}
	if(attributes.event is 'list' or attributes.event is 'cancel_import')
	{
		WOStruct['#attributes.fuseaction#']['cancel_import'] = structNew();
		WOStruct['#attributes.fuseaction#']['cancel_import']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['cancel_import']['fuseaction'] = 'bank.list_bank_autopayment_import';
		WOStruct['#attributes.fuseaction#']['cancel_import']['filePath'] = 'bank/form/open_multi_prov_file.cfm';
		WOStruct['#attributes.fuseaction#']['cancel_import']['queryPath'] = 'bank/query/del_autopayment_import.cfm';
		WOStruct['#attributes.fuseaction#']['cancel_import']['nextEvent'] = 'bank.list_bank_autopayment_import';
	}

</cfscript>
