<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.search_type" default="">
<cfparam name="attributes.this_action_type" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.paymethod_id" default="">
<cfparam name="attributes.employee_bank_id" default="">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_)))>
<cfquery name="get_ssk_offices" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME,		
		SSK_OFFICE,
		COMPANY_ID,
		SSK_NO,
		RELATED_COMPANY
	FROM
		BRANCH
	WHERE
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.SSK_OFFICE IS NOT NULL AND
		BRANCH.SSK_BRANCH IS NOT NULL AND
		BRANCH.SSK_NO <> '' AND
		BRANCH.SSK_OFFICE <> '' AND
		BRANCH.SSK_BRANCH <> ''
		<cfif not session.ep.ehesap>
		AND BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
					)
		</cfif>
	ORDER BY
		BRANCH_NAME,
		SSK_OFFICE
</cfquery>
<cfquery name="get_rel_companies" dbtype="query">
	SELECT DISTINCT COMPANY_ID,RELATED_COMPANY FROM get_ssk_offices WHERE RELATED_COMPANY IS NOT NULL
</cfquery>

<cfquery name="GET_PAYMETHODS" datasource="#dsn#">
	SELECT 
		SP.PAYMETHOD,
		SP.PAYMETHOD_ID
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE 
		SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfquery name="get_banks_all" datasource="#DSN#">
	 SELECT
		  BANK_ID,
		  BANK_NAME
	 FROM
		  SETUP_BANK_TYPES
	 ORDER BY
		  BANK_ID
</cfquery>

<cfif isdefined("attributes.form_varmi")>
	<cfif attributes.this_action_type eq 0 or attributes.this_action_type eq 2 or attributes.this_action_type eq 3><!--- puantajdan --->
		<cfquery name="get_puantaj_rows" datasource="#dsn#">
			SELECT DISTINCT
				EMPLOYEES_IN_OUT.SABIT_PRIM,
				BRANCH.BRANCH_NAME,
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES_IDENTY.TC_IDENTY_NO,
				EMPLOYEES.EMPLOYEE_NAME EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				EMPLOYEES_PUANTAJ_ROWS.NET_UCRET,
				EMPLOYEES_IN_OUT.PAYMETHOD_ID,
				0 AS BANK_ID,
				'' BANK_BRANCH_NAME,
				'' BANK_BRANCH_CODE,
				'' BANK_ACCOUNT_NO,
				'' IBAN_NO,
                '' BANK_SWIFT_CODE,
				'' BANK_NAME,
				SETUP_PAYMETHOD.PAYMETHOD
			FROM
				EMPLOYEES_PUANTAJ_ROWS,
				EMPLOYEES_PUANTAJ,
				EMPLOYEES,
				EMPLOYEES_IDENTY,
				EMPLOYEES_IN_OUT
				LEFT JOIN SETUP_PAYMETHOD ON SETUP_PAYMETHOD.PAYMETHOD_ID = EMPLOYEES_IN_OUT.PAYMETHOD_ID
				LEFT JOIN SETUP_PAYMETHOD_OUR_COMPANY ON SETUP_PAYMETHOD_OUR_COMPANY.PAYMETHOD_ID = SETUP_PAYMETHOD.PAYMETHOD_ID AND SETUP_PAYMETHOD_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				BRANCH
			WHERE		
				<cfif len(attributes.branch_id)>
					BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.company_id)>
					BRANCH.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.paymethod_id)>
					EMPLOYEES_IN_OUT.PAYMETHOD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.employee_bank_id)>
					EMPLOYEES_IN_OUT.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_bank_id#" list = "yes">) AND
				</cfif>
				<cfif not session.ep.ehesap>
				BRANCH.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
							) AND
				</cfif>
				<cfif attributes.this_action_type eq 0>	
					EMPLOYEES_IN_OUT.SABIT_PRIM = 0 AND
				<cfelseif attributes.this_action_type eq 2>
					EMPLOYEES_IN_OUT.SABIT_PRIM = 1 AND	
				</cfif>
				EMPLOYEES_PUANTAJ.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE AND
				BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO AND
				EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
				EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
				EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
				EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
				EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
				EMPLOYEES_IN_OUT.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> AND 
				(EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL) AND
				EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_BANK_ACCOUNTS)
		UNION ALL
			SELECT DISTINCT
				EMPLOYEES_IN_OUT.SABIT_PRIM,
				BRANCH.BRANCH_NAME,
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES_IDENTY.TC_IDENTY_NO,
				EMPLOYEES.EMPLOYEE_NAME EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				EMPLOYEES_PUANTAJ_ROWS.NET_UCRET,
				EMPLOYEES_IN_OUT.PAYMETHOD_ID,
				EMPLOYEES_BANK_ACCOUNTS.BANK_ID,
				EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_NAME,
				EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_CODE,
				EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO,
				EMPLOYEES_BANK_ACCOUNTS.IBAN_NO,
                EMPLOYEES_BANK_ACCOUNTS.BANK_SWIFT_CODE,
				SETUP_BANK_TYPES.BANK_NAME,
				SETUP_PAYMETHOD.PAYMETHOD
			FROM
				EMPLOYEES_PUANTAJ_ROWS,
				EMPLOYEES_PUANTAJ,
				EMPLOYEES,
				EMPLOYEES_IDENTY,
				EMPLOYEES_IN_OUT
				LEFT JOIN SETUP_PAYMETHOD ON SETUP_PAYMETHOD.PAYMETHOD_ID = EMPLOYEES_IN_OUT.PAYMETHOD_ID
				LEFT JOIN SETUP_PAYMETHOD_OUR_COMPANY ON SETUP_PAYMETHOD_OUR_COMPANY.PAYMETHOD_ID = SETUP_PAYMETHOD.PAYMETHOD_ID AND SETUP_PAYMETHOD_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				BRANCH,
				EMPLOYEES_BANK_ACCOUNTS
				LEFT JOIN SETUP_BANK_TYPES ON SETUP_BANK_TYPES.BANK_ID = EMPLOYEES_BANK_ACCOUNTS.BANK_ID
			WHERE		
				<cfif len(attributes.branch_id)>
					BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.company_id)>
					BRANCH.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.paymethod_id)>
					EMPLOYEES_IN_OUT.PAYMETHOD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.employee_bank_id)>
					EMPLOYEES_IN_OUT.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_bank_id#" list = "yes">) AND
				</cfif>
				<cfif not session.ep.ehesap>
				BRANCH.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
							) AND
				</cfif>
				<cfif attributes.this_action_type eq 0>	
					EMPLOYEES_IN_OUT.SABIT_PRIM = 0 AND
				<cfelseif attributes.this_action_type eq 2>
					EMPLOYEES_IN_OUT.SABIT_PRIM = 1 AND	
				</cfif>
				EMPLOYEES_PUANTAJ.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE AND
				BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO AND
				EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
				EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
				EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
				EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
				EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
				EMPLOYEES_IN_OUT.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> AND 
				(EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
				AND EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
				AND EMPLOYEES_BANK_ACCOUNTS.DEFAULT_ACCOUNT = 1
			ORDER BY
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
		</cfquery>
	<cfelseif attributes.this_action_type eq 1><!--- Avans taleplerinden --->
		<cfquery name="get_puantaj_rows" datasource="#dsn#">
			SELECT DISTINCT
				EMPLOYEES_IN_OUT.SABIT_PRIM,
				BRANCH.BRANCH_NAME,
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES_IDENTY.TC_IDENTY_NO,
				EMPLOYEES.EMPLOYEE_NAME EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				CORRESPONDENCE_PAYMENT.AMOUNT AS NET_UCRET,
				EMPLOYEES_IN_OUT.PAYMETHOD_ID,
				0 AS BANK_ID,
				'' BANK_BRANCH_NAME,
				'' BANK_BRANCH_CODE,
				'' BANK_ACCOUNT_NO,
				'' IBAN_NO,
                '' BANK_SWIFT_CODE,
				'' BANK_NAME,
				SETUP_PAYMETHOD.PAYMETHOD
			FROM
				CORRESPONDENCE_PAYMENT,
				EMPLOYEES,
				EMPLOYEES_IDENTY,
				EMPLOYEES_IN_OUT
				LEFT JOIN SETUP_PAYMETHOD ON SETUP_PAYMETHOD.PAYMETHOD_ID = EMPLOYEES_IN_OUT.PAYMETHOD_ID
				LEFT JOIN SETUP_PAYMETHOD_OUR_COMPANY ON SETUP_PAYMETHOD_OUR_COMPANY.PAYMETHOD_ID = SETUP_PAYMETHOD.PAYMETHOD_ID AND SETUP_PAYMETHOD_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				BRANCH
			WHERE		
				<cfif len(attributes.branch_id)>
					BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.company_id)>
					BRANCH.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.paymethod_id)>
					EMPLOYEES_IN_OUT.PAYMETHOD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.employee_bank_id)>
					EMPLOYEES_IN_OUT.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_bank_id#" list = "yes">) AND
				</cfif>
				<cfif not session.ep.ehesap>
				BRANCH.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
							) AND
				</cfif>
				CORRESPONDENCE_PAYMENT.TO_EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				CORRESPONDENCE_PAYMENT.TO_EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
				EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
				EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
				EMPLOYEES.EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_BANK_ACCOUNTS) AND
				MONTH(DUEDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				YEAR(DUEDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> 
		UNION ALL
			SELECT DISTINCT
				EMPLOYEES_IN_OUT.SABIT_PRIM,
				BRANCH.BRANCH_NAME,
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES_IDENTY.TC_IDENTY_NO,
				EMPLOYEES.EMPLOYEE_NAME EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				CORRESPONDENCE_PAYMENT.AMOUNT AS NET_UCRET,
				EMPLOYEES_IN_OUT.PAYMETHOD_ID,
				EMPLOYEES_BANK_ACCOUNTS.BANK_ID,
				EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_NAME,
				EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_CODE,
				EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO,
				EMPLOYEES_BANK_ACCOUNTS.IBAN_NO,
				EMPLOYEES_BANK_ACCOUNTS.BANK_SWIFT_CODE,
				SETUP_BANK_TYPES.BANK_NAME,
				SETUP_PAYMETHOD.PAYMETHOD
			FROM
				CORRESPONDENCE_PAYMENT,
				EMPLOYEES,
				EMPLOYEES_IDENTY,
				EMPLOYEES_IN_OUT
				LEFT JOIN SETUP_PAYMETHOD ON SETUP_PAYMETHOD.PAYMETHOD_ID = EMPLOYEES_IN_OUT.PAYMETHOD_ID
				LEFT JOIN SETUP_PAYMETHOD_OUR_COMPANY ON SETUP_PAYMETHOD_OUR_COMPANY.PAYMETHOD_ID = SETUP_PAYMETHOD.PAYMETHOD_ID AND SETUP_PAYMETHOD_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				BRANCH,
				EMPLOYEES_BANK_ACCOUNTS
				LEFT JOIN SETUP_BANK_TYPES ON SETUP_BANK_TYPES.BANK_ID = EMPLOYEES_BANK_ACCOUNTS.BANK_ID
			WHERE		
				<cfif len(attributes.branch_id)>
					BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.company_id)>
					BRANCH.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.paymethod_id)>
					EMPLOYEES_IN_OUT.PAYMETHOD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#" list = "yes">) AND
				</cfif>
				<cfif len(attributes.employee_bank_id)>
					EMPLOYEES_IN_OUT.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_bank_id#" list = "yes">) AND
				</cfif>
				<cfif not session.ep.ehesap>
				BRANCH.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
							) AND
				</cfif>
				CORRESPONDENCE_PAYMENT.TO_EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				CORRESPONDENCE_PAYMENT.TO_EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
				EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
				EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
				EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				EMPLOYEES_BANK_ACCOUNTS.DEFAULT_ACCOUNT = 1 AND
				MONTH(DUEDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				YEAR(DUEDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> 
			ORDER BY
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_puantaj_rows.recordcount =0>
</cfif>

<cfif get_puantaj_rows.recordcount>
	<cfif attributes.search_type eq 1>
		<cfquery name="get_banks" dbtype="query">
			SELECT * FROM get_puantaj_rows WHERE BANK_ID <> 0
		</cfquery>
	<cfelseif attributes.search_type eq 2> 
		<cfquery name="get_banks" dbtype="query">
			SELECT * FROM get_puantaj_rows WHERE BANK_ID = 0
		</cfquery>
	<cfelseif attributes.search_type eq 0> 
		<cfquery name="get_banks" dbtype="query">
			SELECT * FROM get_puantaj_rows
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_banks.recordcount =0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_banks.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39701.Çalışan Banka Maaş Kontrol Raporu'></cfsavecontent>
<cfform name="list_payments" method="post" action="#request.self#?fuseaction=report.employees_bank_payment_control_report">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="GET_PAYMETHODS"  
													name="paymethod_id"
													option_value="paymethod_id"
													option_name="PAYMETHOD"
													option_text="#getLang('main',322)#"
													value="#attributes.paymethod_id#">
												</div>											
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_banks_all"  
													name="employee_bank_id"
													option_value="bank_id"
													option_name="bank_name"
													option_text="#getLang('main',322)#"
													value="#attributes.employee_bank_id#">
												</div>											
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div id="BRANCH_PLACE" class="multiselect-z2">
													<cf_multiselect_check 
													query_name="GET_SSK_OFFICES"  
													name="branch_id"
													option_value="BRANCH_ID"
													option_name="BRANCH_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.branch_id#">
												</div>									
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='40082.Kayıt Tipi'></label>
											<div class="col col-12 col-md-12 col-xs-12">	
												<select name="this_action_type" id="this_action_type">
													<option value="0" <cfif attributes.this_action_type is 0>selected</cfif>><cf_get_lang dictionary_id='58544.Sabit'></option>
													<option value="2" <cfif attributes.this_action_type is 2>selected</cfif>><cf_get_lang dictionary_id='38981.Primli'></option>
													<option value="1" <cfif attributes.this_action_type is 1>selected</cfif>><cf_get_lang dictionary_id='40083.Avans Talepleri'></option>
													<option value="3" <cfif attributes.this_action_type is 3>selected</cfif>><cf_get_lang dictionary_id='58544.Sabit'> - <cf_get_lang dictionary_id ='38981.Primli'></option>
												</select>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='38955.İlgili Şirket'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_rel_companies"  
													name="company_id"
													option_value="COMPANY_ID"
													option_name="related_company"
													option_text="#getLang('main',322)#"
													value="#attributes.company_id#"
													onchange="get_branch_list(this.value)">
												</div>													
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57460.Filtre'></label>
											<div class="col col-12 col-md-12 col-xs-12">	
												<select name="search_type" id="search_type">
													<option value="0" <cfif attributes.search_type is 0>selected</cfif>><cf_get_lang dictionary_id='57952.Herkes'></option>
													<option value="1" <cfif attributes.search_type is 1>selected</cfif>><cf_get_lang dictionary_id='59260.Banka Hesabı Olanlar'></option>
													<option value="2" <cfif attributes.search_type is 2>selected</cfif>><cf_get_lang dictionary_id='40086.Banka Hesabı Olmayanlar'></option>
												</select>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58724.Ay'></label>
											<div class="col col-12 col-md-12 col-xs-12">	
												<select name="sal_mon" id="sal_mon">
													<cfloop from="1" to="12" index="i">
													<cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
													</cfloop>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58455.Yıl'></label>
											<div class="col col-12 col-md-12 col-xs-12">	
												<select name="sal_year" id="sal_year">
													<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+1#" index="i">
														<cfoutput>
														<option value="#i#"<cfif attributes.sal_year eq i> selected</cfif>>#i#</option>
														</cfoutput>
													</cfloop>
												</select>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="form_varmi" id="form_varmi" value="1" type="hidden">
							<cf_wrk_report_search_button button_type='1' is_excel='1' search_function="control()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>	
<cfif isdefined("attributes.form_varmi")>
	<cf_report_list>
		<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<cfset type_ = 1>
			<cfset attributes.maxrows = get_banks.recordcount>
		<cfelse>
			<cfset type_ = 0>
		</cfif>
			<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th width="75"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
				<th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
				<th width="100"><cf_get_lang dictionary_id ='40596.IBAN'></th>
				<th width="100"><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
				<th width="100"><cf_get_lang dictionary_id='58933.Banka Şubesi'></th>
				<th width="100"><cf_get_lang dictionary_id='59005.Şube Kodu'></th>
				<th width="100"><cf_get_lang dictionary_id='29530.Swift Kodu'></th>
				<th width="100"><cf_get_lang dictionary_id='58178.Hesap No'></th>
				<th width="65"><cf_get_lang dictionary_id ='38979.Ücret Tipi'></th>
				<th width="100"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
				<th width="100" align="right" style="text-align:right;"><cf_get_lang dictionary_id ='38999.Net Ücret'></th>
			</tr>
		</thead>
		<tbody>
			<cfif isdefined("attributes.form_varmi") and get_banks.recordcount>
				<cfoutput query="get_banks" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#branch_name#</td>
						<td><cf_duxi name='identity_no' class="tableyazi" type="label" value="#tc_identy_no#" gdpr="2"></td>
						<td>
							<cfif attributes.is_excel eq 1>
								#employee_name# #employee_surname#
							<cfelse>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi"> 
									#employee_name# #employee_surname#
								</a>
							</cfif>
						</td>
						<cfif attributes.search_type neq 2 and bank_id neq 0 and len(bank_name)>
							<td>#iban_no#</td>
							<td>#bank_name#</td>
							<td>#bank_branch_name#</td>
							<td>#bank_branch_code#</td>
							<td>#bank_swift_code#</td>
							<td>#bank_account_no#</td>
						<cfelse>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</cfif>
						<td><cfif sabit_prim eq 0><cf_get_lang dictionary_id='58544.Sabit'><cfelse><cf_get_lang dictionary_id ='38981.Primli'></cfif></td>
						<td>#paymethod#</td>
						<td style="text-align:right;"><cf_duxi name='net_ucret' class="tableyazi" type="label" value="#tlformat(net_ucret)#" gdpr="7"></td>
					</tr>
				</cfoutput>
			<cfelse>
			<tr>
				<td colspan="12"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayit Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
			</tr>
			</cfif>
		</tbody>
	</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = attributes.fuseaction>
	<cfif isdefined("attributes.form_varmi") and len(attributes.form_varmi)> 
		<cfset url_str = "#url_str#&form_varmi=1">
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)> 
		<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.related_company") and len(attributes.related_company)>
		<cfset url_str = "#url_str#&related_company=#attributes.related_company#">
	</cfif>
	<cfif isdefined("attributes.sal_mon") and len(attributes.sal_mon)> 
		<cfset url_str = "#url_str#&sal_mon=#attributes.sal_mon#">
	</cfif>
	<cfif isdefined("attributes.sal_year") and len(attributes.sal_year)> 
		<cfset url_str = "#url_str#&sal_year=#attributes.sal_year#">
	</cfif>
	<cfif isdefined("attributes.search_type") and len(attributes.search_type)> 
		<cfset url_str = "#url_str#&search_type=#attributes.search_type#">
	</cfif>
	<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)> 
		<cfset url_str = "#url_str#&paymethod_id=#attributes.paymethod_id#">
	</cfif>
	<cfif isdefined("attributes.this_action_type") and len(attributes.this_action_type)> 
		<cfset url_str = "#url_str#&this_action_type=#attributes.this_action_type#">
	</cfif>
	<cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#url_str#">
</cfif>
<script type="text/javascript">
    function control()	
	{
		if(document.list_payments.is_excel.checked==false)
		{
			document.list_payments.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.list_payments.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_employees_bank_payment_control_report</cfoutput>"
    }
	function get_branch_list(gelen)
	{
		checkedValues_b = $("#company_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
</script>
