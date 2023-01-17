<cfset session_base = evaluate('session.ep')>
<cfset attributes.is_page = 1>
<cfparam name="attributes.maxrows" default="#session_base.maxrows#">
<cfparam name="attributes.is_duedate_group" default="1">
<cfparam name="attributes.is_date_filter" default="">
<cfparam name="attributes.due_date_2" default="">
<cfparam name="attributes.due_date_1" default="">
<cfparam name="attributes.action_date_1" default="">
<cfparam name="attributes.action_date_2" default="">
<cfparam name="attributes.other_money_2" default="">
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.other_money" default="">
<cfparam name="attributes.list_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.process_catid" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.special_definition_id" default="" >
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.startrow" default="1">
<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.get_comp_name")>
	<cfset attributes.company = get_par_info(attributes.company_id,1,0,0)>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.get_comp_name")>
	<cfset attributes.company = get_cons_info(attributes.consumer_id,0,0)>
</cfif>
<cf_xml_page_edit fuseact='objects.popup_list_extre,ch.list_company_extre'>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT DISTINCT
		MONEY,
		RATE2,
		RATE1 
	FROM 
		SETUP_MONEY 
	WHERE 
		MONEY_STATUS = 1
		AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN#">
    SELECT
        DISTINCT 
        SMC.MAIN_PROCESS_CAT_ID,
        SMC.MAIN_PROCESS_CAT
    FROM 
        SETUP_MAIN_PROCESS_CAT SMC,
        SETUP_MAIN_PROCESS_CAT_ROWS SMR,
        EMPLOYEE_POSITIONS
    WHERE
        SMC.MAIN_PROCESS_CAT_ID = SMR.MAIN_PROCESS_CAT_ID AND
        EMPLOYEE_POSITIONS.POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
        (EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE = SMR.MAIN_POSITION_CODE)
    ORDER BY
    	SMC.MAIN_PROCESS_CAT
</cfquery>

<cfif isdefined("attributes.is_page") and attributes.is_page eq 1>
	<cfset action = "#listgetat(attributes.fuseaction,1,'.')#.list_extre">
	<cfset action1 = "#listgetat(attributes.fuseaction,1,'.')#.emptypopup_list_extre">
<cfelse>
	<cfset action = "objects.popup_list_extre">
	<cfset action1 = "objects.emptypopup_list_extre">
</cfif>
<script type="text/javascript">
	function degistir_action()
	{
		if(document.list_ekstre.is_excel.checked==false)
			document.list_ekstre.action="<cfoutput>#request.self#?fuseaction=#action#</cfoutput>"
		else
			document.list_ekstre.action="<cfoutput>#request.self#?fuseaction=#action1#</cfoutput>"
	}
</script>
<cfif isdefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
	<cf_date tarih = "attributes.due_date_2">
</cfif>
<cfif isdefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
	<cf_date tarih = "attributes.due_date_1">
</cfif>
<cfif isdefined("attributes.action_date_1") and isdate(attributes.action_date_1)>
	<cf_date tarih = "attributes.action_date_1">
</cfif>
<cfif isdefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
	<cf_date tarih = "attributes.action_date_2">
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih = "attributes.date1">
<cfelse>
	<cfset date1="01/01/#session_base.period_year#">
	<cfparam name="attributes.date1" default="#date1#">
</cfif>
<cfif isdefined('attributes.date2') and isdate(attributes.date2)>
	<cf_date tarih = "attributes.date2">
<cfelse>
	<cfset date2 = "31/12/#session_base.period_year#">
	<cfparam name="attributes.date2" default="#date2#">
</cfif>
<cfif listgetat(attributes.fuseaction,1,'.') eq 'store'>
	<cfset module = 32>
<cfelse>
	<cfset module = 23>
</cfif>
<!--- print icin ekstra parametreler degiskene atiliyor --->
<cfscript>
	extra_params = '';
	
	if(isdefined("attributes.company_id") and len(attributes.company_id) and ((isdefined("attributes.company") and len(attributes.company)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.company_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.consumer_id") and len(attributes.consumer_id) and ((isdefined("attributes.company") and len(attributes.company)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.consumer_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.employee_id") and len(attributes.employee_id) and ((isdefined("attributes.company") and len(attributes.company)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.employee_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.member_type") and len(attributes.member_type) and ((isdefined("attributes.company") and len(attributes.company)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.member_type,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.action_type") and len(attributes.action_type))
		extra_params = listAppend(extra_params,attributes.action_type,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		extra_params = listAppend(extra_params,attributes.branch_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.process_catid") and len(attributes.process_catid))
		extra_params = listAppend(extra_params,attributes.process_catid,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head))
		extra_params = listAppend(extra_params,attributes.project_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.company_id2") and len(attributes.company_id2) and ((isdefined("attributes.company2") and len(attributes.company2)) or (isdefined("attributes.comp_name2") and len(attributes.comp_name2))))
		extra_params = listAppend(extra_params,attributes.company_id2,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.consumer_id2") and len(attributes.consumer_id2) and ((isdefined("attributes.company2") and len(attributes.company2)) or (isdefined("attributes.comp_name2") and len(attributes.comp_name2))))
		extra_params = listAppend(extra_params,attributes.consumer_id2,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.employee_id2") and len(attributes.employee_id2) and ((isdefined("attributes.company2") and len(attributes.company2)) or (isdefined("attributes.comp_name2") and len(attributes.comp_name2))))
		extra_params = listAppend(extra_params,attributes.employee_id2,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.member_type2") and len(attributes.member_type2) and ((isdefined("attributes.company2") and len(attributes.company2)) or (isdefined("attributes.comp_name2") and len(attributes.comp_name2))))
		extra_params = listAppend(extra_params,attributes.member_type2,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.pos_code") and len(attributes.pos_code) and isdefined("attributes.pos_code_text") and len(attributes.pos_code_text))
		extra_params = listAppend(extra_params,attributes.pos_code,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.member_cat_type") and len(attributes.member_cat_type))
		extra_params = listAppend(extra_params,attributes.member_cat_type,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
		
	if(isdefined("attributes.asset_id") and len(attributes.asset_id) and isdefined("attributes.asset_name") and len(attributes.asset_name))
		extra_params = listAppend(extra_params,attributes.asset_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.buy_status") and len(attributes.buy_status))
		extra_params = listAppend(extra_params,attributes.buy_status,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and ((isdefined("attributes.company") and len(attributes.company)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.acc_type_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');	
</cfscript>
<cfif isdefined("attributes.is_collacted") and attributes.is_collacted eq 1>
	<cfif isdefined("attributes.company") and len(attributes.company)>
		<cfif listlen(attributes.company,'-') eq 2>
			<cfset max_name = listfirst(attributes.company,'-')>
		<cfelse>	
			<cfset max_name = attributes.company>
		</cfif>
		<cfif isdefined("attributes.company2") and len(attributes.company2)>
			<cfif listlen(attributes.company2,'-') eq 2>
				<cfset min_name = listfirst(attributes.company2,'-')>
			<cfelse>	
				<cfset min_name = attributes.company2>
			</cfif>
			<cfif max_name lt min_name and len(min_name)>
				<cfif listlen(attributes.company2,'-') eq 2>
					<cfset max_name = listfirst(attributes.company2,'-')>
				<cfelse>	
					<cfset max_name = attributes.company2>
				</cfif>
				<cfif listlen(attributes.company,'-') eq 2>
					<cfset min_name = listfirst(attributes.company,'-')>
				<cfelse>	
					<cfset min_name = attributes.company>
				</cfif>
			</cfif>
		</cfif>
		<cfif len(attributes.COMPANY_ID) and len(attributes.company) and attributes.member_type eq 'partner'>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT 
					COMPANY_ID,
					'' CONSUMER_ID,
					'' EMPLOYEE_ID,
					FULLNAME,
					MEMBER_CODE MEMBER_CODE,
					COMPANY_ADDRESS ADDRESS,
					SEMT SEMT,
					COUNTY,
					CITY,
					COUNTRY,
					'('+COMPANY_TELCODE+')'+' '+COMPANY_TEL1 TELEFON
				FROM 
					COMPANY
				WHERE
					<cfif len(max_name) and LEN(min_name)>
						FULLNAME >= '#min_name#' AND 
						FULLNAME <= '#max_name#'
					<cfelseif LEN(max_name)>
						FULLNAME >= '#max_name#' 
					</cfif>
					AND COMPANY_STATUS = 1
					<cfif listfind(attributes.list_type,1)>
						<cfif isdefined("attributes.is_sifir_bakiye")>
							AND 
							(
								COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
								OR COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
							)
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_sifir_bakiye")>AND COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
					</cfif>
					<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
						AND WORK_CITY_ID = #attributes.city_id# 
					</cfif>	
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
						AND IS_BUYER = 1
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
						AND IS_SELLER = 1
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
						AND ISPOTANTIAL = 1
					</cfif>
					<!--- <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND 1 = 2
					</cfif> --->
					AND COMPANY.COMPANYCAT_ID IN (SELECT COMPANYCAT_ID FROM COMPANY_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#)
				ORDER BY
					FULLNAME
			</cfquery>
            <!--- İlişkili üyelerin bilgileri çekiliyor --->
            <cfif isdefined('is_rel_mem')>
                <cfquery name="get_related_companies" datasource="#dsn#">
                    SELECT 
                        CPR.COMPANY_ID AS REL_COMP_ID,
                        C.COMPANY_ID,
                        '' CONSUMER_ID,
                        '' EMPLOYEE_ID,
                        FULLNAME,
                        MEMBER_CODE MEMBER_CODE,
                        COMPANY_ADDRESS ADDRESS,
                        SEMT SEMT,
                        SCT.COUNTY_NAME,
                        SC.CITY_NAME,
                        SCN.COUNTRY_NAME,
                        '('+COMPANY_TELCODE+')'+' '+COMPANY_TEL1 TELEFON
                    FROM 
                        COMPANY_PARTNER_RELATION CPR
                            LEFT JOIN COMPANY C ON C.COMPANY_ID = CPR.PARTNER_COMPANY_ID
                            LEFT JOIN SETUP_COUNTRY SCN ON SCN.COUNTRY_ID = C.COUNTRY
                            LEFT JOIN SETUP_CITY SC ON SC.CITY_ID = C.CITY
                            LEFT JOIN SETUP_COUNTY SCT ON SCT.COUNTY_ID = C.COUNTY
                    WHERE
                        --COMPANY_STATUS = 1 AND
                        CPR.COMPANY_ID IN (#valueList(get_cmp_ids.company_id)#)
                </cfquery> 
            </cfif> 
		<cfelseif len(attributes.consumer_id) and len(attributes.company) and attributes.member_type eq 'consumer'> 
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
			SELECT 
				'' COMPANY_ID,
				CONSUMER_ID,
				'' EMPLOYEE_ID,
				CONSUMER_NAME + ' ' +CONSUMER_SURNAME FULLNAME,
				MEMBER_CODE MEMBER_CODE,
				WORKADDRESS ADDRESS,
				WORKSEMT SEMT,
				WORK_COUNTY_ID COUNTY,
				WORK_CITY_ID AS CITY,
				WORK_COUNTRY_ID COUNTRY,
				'('+CONSUMER_HOMETELCODE+')'+' '+CONSUMER_HOMETEL TELEFON
			FROM 
				CONSUMER
			WHERE
				<cfif len(max_name) and LEN(min_name)>
					CONSUMER_NAME + ' ' +CONSUMER_SURNAME >= '#min_name#' AND 
					CONSUMER_NAME + ' ' +CONSUMER_SURNAME <= '#max_name#'
				<cfelseif LEN(max_name)>
					CONSUMER_NAME + ' ' +CONSUMER_SURNAME >= '#max_name#' 
				</cfif>
				AND CONSUMER_STATUS = 1
				<cfif listfind(attributes.list_type,1)>
					<cfif isdefined("attributes.is_sifir_bakiye")>
						AND 
						(
							CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
							OR CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
						)
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.is_sifir_bakiye")>AND CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.CONSUMER_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
				</cfif>
				<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
					AND WORK_CITY_ID = #attributes.city_id#
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND ISPOTANTIAL = 1
				</cfif>
				<!--- <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND 1 = 2
				</cfif> --->
				AND CONSUMER.CONSUMER_CAT_ID IN (SELECT CONSUMER_CAT_ID FROM CONSUMER_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#)
			ORDER BY
				FULLNAME
			</cfquery> 
		<cfelseif len(attributes.employee_id) and len(attributes.company) and attributes.member_type eq 'employee'>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT 
					'' COMPANY_ID,
					'' CONSUMER_ID,
					EMPLOYEE_ID,
					EMPLOYEE_NAME + ' ' +EMPLOYEE_SURNAME FULLNAME,
					'' MEMBER_CODE,
					'' ADDRESS,
					'' SEMT,
					'' COUNTY,
					'' AS CITY,
					'' COUNTRY,
					'' TELEFON
				FROM 
					EMPLOYEES
				WHERE
					<cfif len(max_name) and LEN(min_name)>
						EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#min_name#' AND 
						EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME <= '#max_name#'
					<cfelseif LEN(max_name)>
						EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#max_name#' 
					</cfif>
					<cfif listfind(attributes.list_type,1)>
						<cfif isdefined("attributes.is_sifir_bakiye")>
							AND 
							(
								EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
								OR EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
							)
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_sifir_bakiye")>AND EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.EMPLOYEE_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
					</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND EMPLOYEE_ID IN
						(
							SELECT 		
								EMPLOYEE_POSITIONS.EMPLOYEE_ID
							FROM							
								EMPLOYEE_POSITIONS,
								DEPARTMENT
							WHERE		
								 EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
								AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID								
								AND DEPARTMENT.BRANCH_ID IN (#attributes.branch_id#) 
						)
					</cfif>
					AND EMPLOYEE_STATUS = 1
				ORDER BY
					FULLNAME
		  </cfquery> 
		 <cfelseif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT 
					'' COMPANY_ID,
					'' CONSUMER_ID,
					'' EMPLOYEE_ID,
					ASSETP_ID,
					ASSETP ASSET_NAME,
					'' FULLNAME,
					'' MEMBER_CODE,
					'' ADDRESS,
					'' SEMT,
					'' COUNTY,
					'' AS CITY,
					'' COUNTRY,
					'' TELEFON				
				FROM 
					ASSETP
				WHERE
					ASSETP_ID = #attributes.asset_id#
				ORDER BY
					FULLNAME
		  </cfquery> 
		</cfif> 
	<cfelseif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') eq '1'>
		<cfquery name="GET_CMP_IDS" datasource="#dsn#">
			SELECT 
				COMPANY_ID,
				'' CONSUMER_ID,
				'' EMPLOYEE_ID,
				FULLNAME,
				MEMBER_CODE,
				COMPANY_ADDRESS ADDRESS,
				SEMT SEMT,
				COUNTY,
				CITY,
				COUNTRY,
				'('+COMPANY_TELCODE+')'+' '+COMPANY_TEL1 TELEFON
			FROM 
				COMPANY 
			WHERE
				COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#)
				AND COMPANY_STATUS = 1
				<cfif listfind(attributes.list_type,1)>
					<cfif isdefined("attributes.is_sifir_bakiye")>
						AND 
						(
							COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
							OR COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
						)
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.is_sifir_bakiye")>AND COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
				</cfif>
				<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
					AND CITY = #attributes.city_id# 
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
					AND IS_BUYER = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
					AND IS_SELLER = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND ISPOTANTIAL = 1
				</cfif>
			ORDER BY
				FULLNAME
		  </cfquery> 	
	<cfelseif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') eq '2'>
		<cfquery name="GET_CMP_IDS" datasource="#dsn#">
			SELECT 
				'' COMPANY_ID,					
				CONSUMER_ID,
				'' EMPLOYEE_ID,
				CONSUMER_NAME + ' ' +CONSUMER_SURNAME FULLNAME,
				MEMBER_CODE MEMBER_CODE,
				WORKADDRESS ADDRESS,
				WORKSEMT SEMT,
				WORK_COUNTY_ID COUNTY,
				WORK_CITY_ID AS CITY,
				WORK_COUNTRY_ID COUNTRY,
				'('+CONSUMER_HOMETELCODE+')'+' '+CONSUMER_HOMETEL TELEFON
			FROM 
				CONSUMER
			WHERE
				CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(attributes.member_cat_type,'-')# )
				AND CONSUMER_STATUS = 1
				<cfif listfind(attributes.list_type,1)>
					<cfif isdefined("attributes.is_sifir_bakiye")>
						AND 
						(
							CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
							OR CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
						)
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.is_sifir_bakiye")>AND CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.CONSUMER_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
				</cfif>
				<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
					AND WORK_CITY_ID = #attributes.city_id# 
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND ISPOTANTIAL = 1
				</cfif>
			ORDER BY
				FULLNAME
		  </cfquery> 
	<cfelseif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>	
		<cfquery name="GET_CMP_IDS" datasource="#dsn#">
			SELECT
				C.COMPANY_ID,
				'' CONSUMER_ID,
				'' EMPLOYEE_ID,
				C.MEMBER_CODE,
				C.FULLNAME,
				C.COMPANY_ADDRESS ADDRESS,
				C.SEMT SEMT,
				C.COUNTY,
				C.CITY,
				C.COUNTRY,
				'('+C.COMPANY_TELCODE+')'+' '+C.COMPANY_TEL1 TELEFON
			FROM
				WORKGROUP_EMP_PAR WP,
				COMPANY C
			WHERE
				WP.COMPANY_ID = C.COMPANY_ID AND
				WP.COMPANY_ID IS NOT NULL AND
				WP.OUR_COMPANY_ID = #session.ep.company_id# AND
				WP.IS_MASTER = 1 AND
				<cfif listfind(attributes.list_type,1)>
					<cfif isdefined("attributes.is_sifir_bakiye")>
						AND 
						(
							COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
							OR COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
						)
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.is_sifir_bakiye")>AND COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
				</cfif>
				<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
					CITY = #attributes.city_id# AND
				</cfif>
				WP.POSITION_CODE = #attributes.pos_code#
	  </cfquery> 	
	<cfelseif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		<cfquery name="GET_CMP_IDS" datasource="#dsn#">
			SELECT 
				'' COMPANY_ID,
				'' CONSUMER_ID,
				EMPLOYEE_ID,
				EMPLOYEE_NAME + ' ' +EMPLOYEE_SURNAME FULLNAME,
				'' MEMBER_CODE,
				'' ADDRESS,
				'' SEMT,
				'' COUNTY,
				'' AS CITY,
				'' COUNTRY,
				'' TELEFON
			FROM 
				EMPLOYEES
			WHERE
				1 = 1
				<cfif len(max_name) and LEN(min_name)>
					AND EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#min_name#' AND 
					AND EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME <= '#max_name#'
				<cfelseif LEN(max_name)>
					AND EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#max_name#' 
				</cfif>
				<cfif listfind(attributes.list_type,1)>
					<cfif isdefined("attributes.is_sifir_bakiye")>
						AND 
						(
							EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
							OR EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
						)
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.is_sifir_bakiye")>AND EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.EMPLOYEE_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND EMPLOYEE_ID IN
					(
						SELECT 		
							EMPLOYEE_POSITIONS.EMPLOYEE_ID
						FROM							
							EMPLOYEE_POSITIONS,
							DEPARTMENT
						WHERE		
							EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
							AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID								
							AND DEPARTMENT.BRANCH_ID IN (#attributes.branch_id#)
					)
				</cfif>
				AND EMPLOYEE_STATUS = 1
			ORDER BY
				FULLNAME
		</cfquery> 
	</cfif>
<cfelseif isdefined("attributes.member_type") and isdefined("attributes.company") and len(attributes.company) and attributes.member_type is 'partner'>
	<cfquery name="GET_CMP_IDS" datasource="#DSN#">
		SELECT 
			COMPANY_ID,
			'' CONSUMER_ID,
			'' EMPLOYEE_ID,
			FULLNAME,
			MEMBER_CODE,
			COMPANY_ADDRESS ADDRESS,
			SEMT SEMT,
			COUNTY,
			CITY,
			COUNTRY,
			'('+COMPANY_TELCODE+')'+' '+COMPANY_TEL1 TELEFON
		FROM 
			COMPANY 
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfif listfind(attributes.list_type,1)>
				<cfif isdefined("attributes.is_sifir_bakiye")>
					AND 
					(
						COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
						OR COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
					)
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.is_sifir_bakiye")>AND COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
			</cfif>
	</cfquery>
<cfelseif isdefined("attributes.member_type") and isdefined("attributes.company") and len(attributes.company) and attributes.member_type is 'consumer'>
	<cfquery name="GET_CMP_IDS" datasource="#dsn#">
		SELECT 
			'' COMPANY_ID,
			CONSUMER_ID,
			'' EMPLOYEE_ID,
			CONSUMER_NAME + ' ' +CONSUMER_SURNAME FULLNAME,
			MEMBER_CODE MEMBER_CODE,
			WORKADDRESS ADDRESS,
			WORKSEMT SEMT,
			WORK_COUNTY_ID COUNTY,
			WORK_CITY_ID AS CITY,
			WORK_COUNTRY_ID COUNTRY,
			'('+CONSUMER_HOMETELCODE+')'+' '+CONSUMER_HOMETEL TELEFON
		FROM 
			CONSUMER 
		WHERE
			CONSUMER_ID = #attributes.consumer_id#
			<cfif listfind(attributes.list_type,1)>
				<cfif isdefined("attributes.is_sifir_bakiye")>
					AND 
					(
						CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
						OR CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
					)
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.is_sifir_bakiye")>AND CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.CONSUMER_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
			</cfif>
  </cfquery> 
<cfelseif isdefined("attributes.member_type") and isdefined("attributes.company") and len(attributes.company) and attributes.member_type is 'employee'>
	<cfquery name="GET_CMP_IDS" datasource="#dsn#">
		SELECT 
			'' COMPANY_ID,
			'' CONSUMER_ID,
			EMPLOYEE_ID,
			EMPLOYEE_NAME + ' ' +EMPLOYEE_SURNAME FULLNAME,
			'' MEMBER_CODE,
			'' ADDRESS,
			'' SEMT,
			'' COUNTY,
			'' CITY,
			'' COUNTRY,
			'' TELEFON
		FROM 
			EMPLOYEES 
		WHERE
			EMPLOYEE_ID = #attributes.employee_id#
			<cfif listfind(attributes.list_type,1)>
				<cfif isdefined("attributes.is_sifir_bakiye")>
					AND 
					(
						EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
						OR EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
					)
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.is_sifir_bakiye")>AND EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.EMPLOYEE_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
			</cfif>
  </cfquery>   
<cfelseif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
	<cfquery name="GET_CMP_IDS" datasource="#dsn#">
		SELECT 
			'' COMPANY_ID,
			'' CONSUMER_ID,
			'' EMPLOYEE_ID,
			ASSETP_ID,
			ASSETP ASSET_NAME,
			'' FULLNAME,
			'' MEMBER_CODE,
			'' ADDRESS,
			'' SEMT,
			'' COUNTY,
			'' AS CITY,
			'' COUNTRY,
			'' TELEFON
		FROM 
			ASSET_P
		WHERE
			ASSETP_ID = #attributes.asset_id#
		ORDER BY
			FULLNAME
  </cfquery> 
  </cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_extre';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'objects/display/list_extre.cfm';
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
<script type="text/javascript">
	$( document ).ready(function() {
	   list_ekstre.wrk_search_button.focus();
	});
	function kontrol()
	{
		if((document.list_ekstre.company.value.length == 0))
			{
				document.list_ekstre.company_id.value = '';
				document.list_ekstre.consumer_id.value = '';
				document.list_ekstre.employee_id.value = '';
			}
		if (document.list_ekstre.is_collacted.value == 1)
		{
			if ((document.list_ekstre.is_make_age != undefined && document.list_ekstre.is_make_age.checked == false))
			{
				if((document.list_ekstre.company2.value.length == 0))
					{
						document.list_ekstre.company_id2.value = '';
						document.list_ekstre.consumer_id2.value = '';
						document.list_ekstre.employee_id2.value = '';
					}
			}
		}
		if (document.list_ekstre.is_collacted.value == 1)
		{
			if ((document.list_ekstre.is_make_age != undefined && document.list_ekstre.is_make_age.checked == true))
			{
				document.list_ekstre.company2.value.length ='';
				document.list_ekstre.company_id2.value = '';
				document.list_ekstre.consumer_id2.value = '';
				document.list_ekstre.employee_id2.value = '';
				document.list_ekstre.is_collacted.value = 0;
			}
		}
		if (document.list_ekstre.is_collacted.value == 1)
		{
			if( (document.list_ekstre.company_id.value == "")&&(document.list_ekstre.consumer_id.value == "") && (document.list_ekstre.branch_id.value == "") && (document.list_ekstre.company.value == "") &&(document.list_ekstre.employee_id.value == "")&& (document.list_ekstre.pos_code_text.value == "")&& ((document.list_ekstre.member_cat_type.value == "") || document.list_ekstre.member_cat_type.value == 2 || document.list_ekstre.member_cat_type.value == 1))
				{ 
				alert ("<cf_get_lang_main no ='1217.Cari Hesap , Çalışan Hesap , Temsilci veya Üye Kategorisi Seçiniz'>!");
				return false;
				}
		}
		else
		{
			<cfif session.ep.our_company_info.asset_followup eq 1>
				if((document.list_ekstre.asset_id.value == "" || document.list_ekstre.asset_name.value == "") && (document.list_ekstre.company_id.value == "") && (document.list_ekstre.consumer_id.value == "") && (document.list_ekstre.employee_id.value == ""))
					{ 
					alert ("<cf_get_lang_main no ='1217.Cari Hesap , Çalışan Hesap , Temsilci veya Üye Kategorisi Seçiniz'> !");
					return false;
					}		
			<cfelse>
				if((document.list_ekstre.company_id.value == "") && (document.list_ekstre.consumer_id.value == "") && (document.list_ekstre.employee_id.value == ""))
					{ 
					alert ("<cf_get_lang_main no ='1217.Cari Hesap , Çalışan Hesap , Temsilci veya Üye Kategorisi Seçiniz'> !");
					return false;
					}
			</cfif>
		}		
		if (document.list_ekstre.is_collacted.value == 1)
		{
			if((document.list_ekstre.company2.value!='') && (document.list_ekstre.member_type.value != document.list_ekstre.member_type2.value))
				{ 
				alert ("<cf_get_lang_main no='393.Lütfen Aynı Türde Hesaplar Seçiniz'> !");
				return false;
				}
		}
		<cfif is_date_kontrol eq 0>
			return date_diff(document.list_ekstre.date1,document.list_ekstre.date2,1,"<cf_get_lang_main no ='394.Tarih Aralığını Kontrol Ediniz'>!");
		<cfelse>
			if(document.list_ekstre.is_collacted.value == 1)
				return date_diff(document.list_ekstre.date1,document.list_ekstre.date2,1,"<cf_get_lang_main no ='394.Tarih Aralığını Kontrol Ediniz'>!");
			else
				return true;	
		</cfif>
	}
	function hesap_sec(no)
	{
		if (no==1)
		{
			if(document.list_ekstre.pos_code_text != undefined)
				document.list_ekstre.pos_code_text.value='';
			if(document.list_ekstre.company_id.value!='')
			{
				document.list_ekstre.company_id.value='';
				document.list_ekstre.company.value='';
			}
			if(document.list_ekstre.employee_id.value!='')
			{
				document.list_ekstre.employee_id.value='';
				document.list_ekstre.company.value='';
			}
			if(document.list_ekstre.consumer_id.value!='')
			{
				document.list_ekstre.consumer_id.value='';
				document.list_ekstre.company.value='';
			}
		}
		else if (no==2)
		{
			if(document.list_ekstre.pos_code_text != undefined)
				document.list_ekstre.pos_code_text.value='';
			if(document.list_ekstre.company_id2.value!='')
			{
				document.list_ekstre.company_id2.value='';
				document.list_ekstre.company2.value='';
			}
			if(document.list_ekstre.employee_id2.value!='')
			{
				document.list_ekstre.employee_id2.value='';
				document.list_ekstre.company2.value='';
			}
			if(document.list_ekstre.consumer_id2.value!='')
			{
				document.list_ekstre.consumer_id2.value='';
				document.list_ekstre.company2.value='';
			}
		}
		else if (no==3)
		{
			if(document.list_ekstre.company_id.value!='')
			{
				document.list_ekstre.company_id.value='';
				document.list_ekstre.company.value='';
			}
			if(document.list_ekstre.employee_id.value!='')
			{
				document.list_ekstre.employee_id.value='';
				document.list_ekstre.company.value='';
			}
			if(document.list_ekstre.consumer_id.value!='')
			{
				document.list_ekstre.consumer_id.value='';
				document.list_ekstre.company.value='';
			}
			if(document.list_ekstre.company_id2.value!='')
			{
				document.list_ekstre.company_id2.value='';
				document.list_ekstre.company2.value='';
			}
			if(document.list_ekstre.employee_id2.value!='')
			{
				document.list_ekstre.employee_id2.value='';
				document.list_ekstre.company2.value='';
			}
			if(document.list_ekstre.consumer_id2.value!='')
			{

				document.list_ekstre.consumer_id2.value='';
				document.list_ekstre.company2.value='';
			}
		}
	}
	function kontrol_perf(kont)
	{
		if(kont==1)
		{
			if(document.list_ekstre.is_make_age != undefined && document.list_ekstre.is_make_age.checked== true)
			{	
				is_cheque_duedate.style.display='';
				if(document.list_ekstre.is_make_age_manuel != undefined)
					document.list_ekstre.is_make_age_manuel.checked = false;
			}
			else
				is_cheque_duedate.style.display='none';
		}
		else
		{
			if(document.list_ekstre.is_make_age_manuel.checked== true && document.list_ekstre.is_make_age != undefined)
			{
				document.list_ekstre.is_make_age.checked = false;
				is_cheque_duedate.style.display='none';
			}
		}
	}
	function pencere_ac_cari()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_pars&is_cari_action=1&is_company_info=1&field_name=list_ekstre.company&field_type=list_ekstre.member_type&field_comp_name=list_ekstre.company&field_consumer=list_ekstre.consumer_id&field_emp_id=list_ekstre.employee_id&field_comp_id=list_ekstre.company_id<cfif fusebox.circuit is "store" or isdefined("attributes.is_store_module")>&is_store_module=1</cfif>&select_list=2,3<cfif get_module_power_user(48)>,1</cfif>','list');
	}
	function auto_complate_cari()
	{
		AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'1\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','225');
	}	
	function pencere_ac_project()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_projects&project_id=list_ekstre.project_id&project_head=list_ekstre.project_head&is_empty_project','list');
	}
	function auto_complate_project()
	{
		AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','217');
	}
	function pencere_ac_comp2()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_pars&is_cari_action=1&is_company_info=1&field_name=list_ekstre.company2&field_type=list_ekstre.member_type2&field_comp_name=list_ekstre.company2&field_consumer=list_ekstre.consumer_id2&field_emp_id=list_ekstre.employee_id2&field_comp_id=list_ekstre.company_id2<cfif fusebox.circuit is "store" or isdefined("attributes.is_store_module")>&is_store_module=1</cfif>&select_list=2,3<cfif get_module_power_user(48)>,1</cfif>','list');
	}
	function auto_complate_comp2()
	{
		AutoComplete_Create('company2','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'1\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id2,consumer_id2,employee_id2,member_type2','','3','225');
	}
	function pencere_ac_temsilci()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_code=list_ekstre.pos_code&field_name=list_ekstre.pos_code_text&select_list=1','list');
	}
	function auto_complate_temsilci()
	{
		AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','130');
	}
</script>

