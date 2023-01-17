<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#"> 
	<cfparam name="attributes.sal_year" default="#year(now())#">
	<cfparam name="attributes.related_company" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.pay_mon" default="">
	<cfparam name="attributes.pay_year" default="#year(now())#">
	
	<cfquery name="get_related_company" datasource="#dsn#">
		SELECT DISTINCT
			RELATED_COMPANY
		FROM 
			BRANCH
		WHERE
			BRANCH_STATUS = 1 AND
			BRANCH_ID IS NOT NULL
			<cfif not session.ep.ehesap>
				AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
		ORDER BY 
				RELATED_COMPANY
	</cfquery>
	
	<cfquery name="get_branch" datasource="#dsn#">
		SELECT DISTINCT
			BRANCH_NAME,
			BRANCH_ID,
			RELATED_COMPANY
		FROM 
			BRANCH
		WHERE
			BRANCH_STATUS = 1 AND
			BRANCH_ID IS NOT NULL
			<cfif not session.ep.ehesap>
				AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
		ORDER BY 
			BRANCH_NAME
	</cfquery>
	<cfif isdefined("attributes.form_varmi")>
		<cfquery name="get_bank_payments" datasource="#DSN#">
			SELECT DISTINCT
			  	EBP.OUR_COMPANY_ID,
				EBP.BRANCH_ID,
				EBP.RECORD_DATE,
				EBP.RELATED_COMPANY,
				EBP.PAYMENT_TYPE,
				EBP.PAY_YEAR,
				EBP.PAY_MON,
				EBP.TOTAL_ROWS,
				EBP.TOTAL_AMOUNT,
				EBP.TOTAL_AMOUNT_MONEY,
				EBP.PAY_DATE,
				EBP.XML_FILE_NAME,
				EBP.XML_FILE_SERVER_ID,
				EBP.BANK_PAYMENT_ID,
				EBP.BANK_NAME,
				(SELECT FTP_SERVER_NAME FROM SETUP_BANK_TYPES WHERE BANK_ID= EBP.BANK_ID) FTP_SERVER_NAME,
				SBT.EXPORT_TYPE,
				B.BRANCH_NAME,
				OC.NICK_NAME
			FROM 
				EMPLOYEES_BANK_PAYMENTS EBP
				LEFT JOIN SETUP_BANK_TYPES SBT ON SBT.BANK_ID = EBP.BANK_ID
				LEFT JOIN BRANCH B ON B.BRANCH_ID = EBP.BRANCH_ID
				LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = EBP.OUR_COMPANY_ID
			WHERE
				EBP.BANK_PAYMENT_ID IS NOT NULL
				<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
					AND	EBP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
				</cfif>
				<cfif isdefined('attributes.related_company') and len(attributes.related_company)>
					AND	EBP.RELATED_COMPANY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_company#">
				</cfif>
				<cfif isdefined('attributes.payment_type_id') and len(attributes.payment_type_id)>
					AND	EBP.PAYMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type_id#">
				</cfif>
	            <cfif isdefined('attributes.pay_mon') and len(attributes.pay_mon)>
					AND	EBP.PAY_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pay_mon#">
				</cfif>
	            <cfif isdefined('attributes.pay_year') and len(attributes.pay_year)>
					AND	EBP.PAY_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pay_year#">
				</cfif>
				<cfif not session.ep.ehesap>
					AND 
					(
						(
							EBP.BRANCH_ID IS NOT NULL AND EBP.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
						)
					OR
					<cfoutput query="get_related_company">
						(
							EBP.RELATED_COMPANY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#related_company#%"> 
						)
						<cfif currentrow neq recordcount>OR</cfif>
					</cfoutput>
					OR
						(
						EBP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
						EBP.BRANCH_ID IS NULL AND EBP.RELATED_COMPANY IS NULL
						)
					)
				</cfif>
			ORDER BY
				EBP.PAY_YEAR DESC,
				EBP.PAY_MON DESC,
				EBP.RECORD_DATE DESC,
				EBP.RELATED_COMPANY DESC
		</cfquery>
	
		<cfset arama_yapilmali=0>
		<cfparam name="attributes.totalrecords" default="#get_bank_payments.recordcount#">
	<cfelse>
		<cfset get_bank_payments.recordcount=0>
		<cfset arama_yapilmali=1>
		<cfparam name="attributes.totalrecords" default="0">	
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
	<cfscript>
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		excel_exp_type_list = '7,8,9,11';
		adres="ehesap.list_bank_payment_emps";
		if (isdefined("attributes.form_varmi") and len(attributes.form_varmi))
			adres = "#adres#&form_varmi=#attributes.form_varmi#";
		if (isdefined("attributes.branch_id") and len(attributes.branch_id))
			adres = "#adres#&branch_id=#attributes.branch_id#";
		if (isdefined("attributes.related_company") and len(attributes.related_company))
			adres = "#adres#&related_company=#attributes.related_company#";
		if (isdefined("attributes.payment_type_id") and len(attributes.payment_type_id))
			adres = "#adres#&payment_type_id=#attributes.payment_type_id#";
		if (isdefined("attributes.pay_mon") and len(attributes.pay_mon))
			adres = "#adres#&pay_mon=#attributes.pay_mon#";
		if (isdefined("attributes.pay_year") and len(attributes.pay_year))
			adres = "#adres#&pay_year=#attributes.pay_year#";
	</cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_get_lang_set module_name="ehesap">
	<cfinclude template="../hr/ehesap/query/get_branch.cfm">
	<cfquery name="get_related_company" datasource="#dsn#">
		SELECT DISTINCT
			RELATED_COMPANY
		FROM 
			BRANCH
		WHERE
			BRANCH_ID IS NOT NULL AND
			RELATED_COMPANY IS NOT NULL
			<cfif not session.ep.ehesap>
				AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
		ORDER BY 
			RELATED_COMPANY
	</cfquery>
	<cfquery name="GET_ACCOUNTS" datasource="#DSN#">
		SELECT
			BANK_ID,
			BANK_NAME,
			EXPORT_TYPE
		FROM
			SETUP_BANK_TYPES
		WHERE 
			EXPORT_TYPE IS NOT NULL
		ORDER BY
			BANK_NAME
	</cfquery>
	<cfquery name="get_our_companies" datasource="#DSN#">
		SELECT
			NICK_NAME,
			COMP_ID
		FROM
			OUR_COMPANY
		<cfif not session.ep.ehesap>
		WHERE
			COMP_ID IN (SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
		</cfif>
		ORDER BY
			NICK_NAME
	</cfquery>
	<cfparam name="attributes.pay_mon" default="#dateformat(now(),'MM')#"> 
	<cfparam name="attributes.pay_year" default="#session.ep.period_year#">
	<cfparam name="attributes.pay_date" default="#dateformat(now(),'dd/mm/yyyy')#">
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
		function kontrol()
		{
			related_ = 0;
			if (document.getElementsByName('related_company').length != undefined) /* n tane*/
			{
				for (i=1; i <= document.getElementsByName('related_company').length; i++)
				{
					if(document.getElementById('related_company'+i).checked==true)
						related_ = 1;							
				}
			}
			else /* 1 tane*/
			{			
				if(document.getElementById('related_company').checked==true)
					related_ = 1;				
			}
			
			if($('#firm_code').val() =='1' && related_==1)
			{
				alert("<cf_get_lang no ='844.Şube Kodunu Kullanarak Oluşturduğunuz Ödemede İlgili Şirket Seçemezsiniz'>!");
				return false;
			}
				
			if($('#firm_code').val() =='1' && $('#branch_id').val() =='')
			{
				alert("<cf_get_lang no ='845.Şube Kodunu Kullanarak Oluşturduğunuz Ödemede Şube Seçmelisiniz'>!");
				return false;
			}
			
			if (related_==0 && $('#branch_id').val() =='' && $('#our_company_id').val() =='')
			{
				alert("<cf_get_lang no ='846.İlişkili Şirket veya Şube Seçiniz'>!");
				return false;
			}
			
			if($('#avans_startdate').val().length != 0 && $('#avans_finishdate').val().length == 0)
			{
				alert("<cf_get_lang no ='847.Avans Çıkış Tarihi Olmadan Giriş Tarihi Kullanamazsınız'>!");
				return false;
			}
		
			if($('#avans_finishdate').val().length != 0 && $('#avans_startdate').val().length == 0)
			{
				alert("<cf_get_lang no ='848.Avans Giriş Tarihi Olmadan Çıkış Tarihi Kullanamazsınız'>!");
				return false;
			}
			
			if($('#bank_id').val() == '')
			{
				alert("<cf_get_lang dictionary_id='48830.Banka Hesabı Seçmelisiniz'>!");
				return false;
			}
			return true;
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_bank_payment_emps';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_bank_payment_emps.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_bank_payment_emps';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_bank_payment_emps.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_bank_payment_emps.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_bank_payment_emps';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_bank_payment_emps';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_bank_payment_emps.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_bank_payment_emps.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_bank_payment_emps';
		
		WOStruct['#attributes.fuseaction#']['gen_excel'] = structNew();
		WOStruct['#attributes.fuseaction#']['gen_excel']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['gen_excel']['fuseaction'] = 'ehesap.emptypopup_generate_bank_to_excel';
		WOStruct['#attributes.fuseaction#']['gen_excel']['filePath'] = 'hr/ehesap/query/generate_bank_to_excel.cfm';
		WOStruct['#attributes.fuseaction#']['gen_excel']['queryPath'] = 'hr/ehesap/query/generate_bank_to_excel.cfm';
		WOStruct['#attributes.fuseaction#']['gen_excel']['nextEvent'] = 'ehesap.list_bank_payment_emps';
		
		WOStruct['#attributes.fuseaction#']['send_ftp'] = structNew();
		WOStruct['#attributes.fuseaction#']['send_ftp']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['send_ftp']['fuseaction'] = 'ehesap.emptypopup_send_file_ftp';
		WOStruct['#attributes.fuseaction#']['send_ftp']['filePath'] = 'hr/ehesap/query/send_file_ftp.cfm';
		WOStruct['#attributes.fuseaction#']['send_ftp']['queryPath'] = 'hr/ehesap/query/send_file_ftp.cfm';
		WOStruct['#attributes.fuseaction#']['send_ftp']['nextEvent'] = 'ehesap.list_bank_payment_emps';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapBankPaymentEmps.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_BANK_PAYMENTS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-bank_id','item-pay_year','item-pay_date']";
</cfscript>
