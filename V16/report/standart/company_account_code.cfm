<!--- Querylerde performans iyilestirme yapildi, liste yontemleri kaldirildi FBS 20140911 --->
<!--- 
Author : Sevim Çelik
Date   : 09/09/2019
Description : Rapora Müşteri Kategorisi (kategoriye göre cariler getirilir), Sadece Fark Olanları Göster (hesap ve muhasebe hesap bakiyesi arasında fark olanlar) ve Sadece Bakiyesi Olanlar (muhasebe veya hesap bakiyesi olanlar) filresi eklendi.
--->
<cf_xml_page_edit fuseact="report.company_account_code">
<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.cash_id" default="">
<cfparam name="attributes.bank_id" default="">
<cfparam name="attributes.our_company_name" default="">
<cfparam name="attributes.other_money" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.account_type" default="0">
<cfparam name="attributes.account_type_status" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_acc_code" default="">
<cfparam name="attributes.is_difference" default="">
<cfparam name="attributes.filter_acc_code" default="">
<cfparam name="attributes.category_id" default="">
<cfparam name="attributes.is_bakiye" default="">
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT
		OC.COMP_ID,
		SP.PERIOD_ID,
		SP.PERIOD_YEAR,
		SP.PERIOD,
		OC.COMPANY_NAME,
		OC.NICK_NAME
	FROM
		OUR_COMPANY OC,
		SETUP_PERIOD SP
	WHERE
		OC.COMP_ID = SP.OUR_COMPANY_ID
	ORDER BY
		OC.COMPANY_NAME,
		SP.PERIOD_YEAR
</cfquery>
<cfset our_company_id_ = #session.ep.company_id#>
<cfif isdefined("get_our_company") and get_our_company.recordcount>
	<cfset our_company_id_ = valuelist(get_our_company.comp_id,',')>
</cfif>
<cfscript>
	CreateCompenent = createObject("component", "/V16/workdata/get_company_consumer_cats");
	get_comp_category = CreateCompenent.get_comp_category_fnc(our_company_id: '#our_company_id_#');
	get_cons_category = CreateCompenent.get_cons_category_fnc(our_company_id: '#our_company_id_#');
</cfscript>
<cfif len(attributes.our_company_name)>
	<cfset data_source = dsn & '_' & listfirst(attributes.our_company_name,'-') & '_' & listlast(attributes.our_company_name,'-')>
	<cfset data_source_3 = dsn & '_' & listlast(attributes.our_company_name,'-')>
<cfelse>
	<cfset data_source = dsn2>
	<cfset data_source_3 = dsn3>
</cfif>
<cfquery name="get_cash_name" datasource="#data_source#">
	SELECT CASH_ID, CASH_NAME, BRANCH_ID FROM CASH ORDER BY CASH_NAME
</cfquery>
<cfquery name="get_acc_name" datasource="#data_source_3#">
	SELECT ACCOUNT_ID, ACCOUNT_NAME,ACCOUNT_CURRENCY_ID FROM ACCOUNTS ORDER BY ACCOUNT_NAME
</cfquery>
<cfquery name="get_system_money" datasource="#data_source#">
	SELECT MONEY, RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.is_submit')>
	<cfif len(attributes.date1) and isdate(attributes.date1)><cf_date tarih = "attributes.date1"></cfif>
	<cfif len(attributes.date2) and isdate(attributes.date2)><cf_date tarih = "attributes.date2"></cfif>
	<cfif attributes.account_type eq 0>
		<cfset kurumsal = ''>
		<cfset bireysel = ''>
		<cfif listlen(attributes.category_id)>
			<cfset uzunluk=listlen(attributes.category_id)>
			<cfloop from="1" to="#uzunluk#" index="catyp">
				<cfset eleman = listgetat(attributes.category_id,catyp,',')>
				<cfif listlen(eleman) and listfirst(eleman,'-') eq 1>
					<cfset kurumsal = listappend(kurumsal,listlast(eleman,'-'))>
				<cfelseif listlen(eleman) and listfirst(eleman,'-') eq 2>
					<cfset bireysel = listappend(bireysel,listlast(eleman,'-'))>
				</cfif>
			</cfloop>
		</cfif>		
		<!--- Cari Hesap Islemleri --->
		<cfquery name="Main_Query" datasource="#dsn#">
			<cfif (len(attributes.company_id) and len(attributes.company_name)) or not len(attributes.company_name)>
				SELECT 
					0 PROCESS_TYPE,
					COMPANY.COMPANY_ID PROCESS_ID,
					COMPANY.FULLNAME PROCESS_NAME,
					COMPANY.MEMBER_CODE PROCESS_CODE,
					ACCOUNT_CODE ACC_CODE,
					<cfif len(attributes.our_company_name)>
						(SELECT ACCOUNT_NAME FROM #dsn#_#listgetat(attributes.our_company_name,1,'-')#_#listgetat(attributes.our_company_name,3,'-')#.ACCOUNT_PLAN AP WHERE AP.ACCOUNT_CODE = COMPANY_PERIOD.ACCOUNT_CODE) ACC_NAME,
					<cfelse>
						(SELECT ACCOUNT_NAME FROM #dsn2_alias#.ACCOUNT_PLAN AP WHERE AP.ACCOUNT_CODE = COMPANY_PERIOD.ACCOUNT_CODE) ACC_NAME,
					</cfif>
					COMPANY.COMPANYCAT_ID COMPANYCAT_ID,
					COMPANY_CAT.COMPANYCAT MEMBER_CAT,
					CURRENT_REMAINDER.CURRENT_OTHER_MONEY,
					ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0) CURRENT_BAKIYE,
					ACCOUNT_REMAINDER.ACCOUNT_ACCOUNT_ID,
					ACCOUNT_REMAINDER.ACCOUNT_ACCOUNT_NAME,
					ACCOUNT_REMAINDER.ACCOUNT_OTHER_MONEY,
					ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0) ACCOUNT_BAKIYE
				FROM
					COMPANY_PERIOD,
					COMPANY
					LEFT JOIN COMPANY_CAT ON COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
					LEFT JOIN
					(	<!--- Get_Current_Remainder --->
						SELECT
							COMPANY_ID,
							OTHER_MONEY CURRENT_OTHER_MONEY,
							(BORC-ALACAK) AS CURRENT_BAKIYE
						FROM
							(
							SELECT
								COMPANY_ID,
								<cfif len(attributes.other_money)>
									OTHER_MONEY,
									SUM(BORC3) AS BORC,
									SUM(ALACAK3) AS ALACAK
								<cfelse>
									'#session.ep.money#' OTHER_MONEY,
									SUM(BORC) AS BORC,
									SUM(ALACAK) AS ALACAK
								</cfif>
							FROM
								#dsn2_alias#.CARI_ROWS_TOPLAM
							WHERE
								1 = 1
								<cfif len(attributes.other_money)>
									AND OTHER_MONEY = '#attributes.other_money#'
								</cfif>
								<cfif len(attributes.date1) and isdate(attributes.date1)>
									AND ACTION_DATE > = #attributes.date1#
								</cfif>
								<cfif len(attributes.date2) and isdate(attributes.date2)>
									AND ACTION_DATE < = #attributes.date2#
								</cfif>
							GROUP BY
								<cfif len(attributes.other_money)>
									OTHER_MONEY,
								</cfif>
								COMPANY_ID
							)T1
					) CURRENT_REMAINDER ON CURRENT_REMAINDER.COMPANY_ID = COMPANY.COMPANY_ID
					LEFT JOIN 
					(	<!--- Get_Account_Remainder --->
						SELECT
							COMPANY_ID,
							ACCOUNT_ACCOUNT_ID,
							ACCOUNT_ACCOUNT_NAME,
							ACCOUNT_OTHER_MONEY,
							SUM(ACCOUNT_BAKIYE) ACCOUNT_BAKIYE
						FROM
						(
							SELECT
								CP.COMPANY_ID,
								<cfif len(attributes.other_money)>
									SUM(AART.BORC3-AART.ALACAK3) ACCOUNT_BAKIYE
								<cfelse>
									SUM(AART.BORC-AART.ALACAK) ACCOUNT_BAKIYE
								</cfif>,
								AART.ACCOUNT_ID ACCOUNT_ACCOUNT_ID,
								AP.ACCOUNT_NAME ACCOUNT_ACCOUNT_NAME,
								<cfif len(attributes.other_money)>
									AART.OTHER_MONEY ACCOUNT_OTHER_MONEY
								<cfelse>
									'#session.ep.money#' ACCOUNT_OTHER_MONEY
								</cfif>
							FROM
								#dsn_alias#.COMPANY_PERIOD CP,
								#dsn_alias#.OUR_COMPANY OC,
								#dsn_alias#.SETUP_PERIOD SP,
								<cfif len(attributes.other_money)>
									#dsn2_alias#.ACCOUNT_ACCOUNT_REMAINDER_MONEY AART
								<cfelse>
									#dsn2_alias#.ACCOUNT_ACCOUNT_REMAINDER AART
								</cfif>,
								#dsn2_alias#.ACCOUNT_PLAN AP
							WHERE
								<cfif len(attributes.other_money)>
									AART.OTHER_MONEY = '#attributes.other_money#' AND
								</cfif>
								<cfif len(attributes.our_company_name)>
									SP.PERIOD_YEAR = #listfirst(attributes.our_company_name,'-')# AND
									OC.COMP_ID = #listlast(attributes.our_company_name,'-')# AND
								<cfelse>
									SP.PERIOD_YEAR = #session.ep.period_year# AND
									OC.COMP_ID = #session.ep.company_id# AND
								</cfif>
								CP.ACCOUNT_CODE = AART.ACCOUNT_ID AND
								AP.ACCOUNT_CODE = AART.ACCOUNT_ID AND
								SP.PERIOD_ID = CP.PERIOD_ID AND
								OC.COMP_ID = SP.OUR_COMPANY_ID
								<cfif len(attributes.date1) and isdate(attributes.date1)>
									AND AART.ACTION_DATE > = #attributes.date1#
								</cfif>
								<cfif len(attributes.date2) and isdate(attributes.date2)>
									AND AART.ACTION_DATE < = #attributes.date2#
								</cfif>
							GROUP BY
								<cfif len(attributes.other_money)>
									AART.OTHER_MONEY,
								</cfif>
								AART.ACCOUNT_ID,
								CP.COMPANY_ID,
								AP.ACCOUNT_NAME
						)T1
						GROUP BY
							<cfif len(attributes.other_money)>
								ACCOUNT_OTHER_MONEY,
							</cfif>
							COMPANY_ID,
							ACCOUNT_ACCOUNT_ID,
							ACCOUNT_ACCOUNT_NAME,
							ACCOUNT_OTHER_MONEY
						) ACCOUNT_REMAINDER ON ACCOUNT_REMAINDER.COMPANY_ID = COMPANY.COMPANY_ID
				WHERE
					1 = 1
					<cfif len(attributes.other_money)>
						AND ACCOUNT_OTHER_MONEY = '#attributes.other_money#'
					</cfif>
					<cfif attributes.is_acc_code eq 1>
						AND ACCOUNT_CODE IS NOT NULL
					</cfif>
					<cfif len(attributes.filter_acc_code)>
						AND (ACCOUNT_CODE LIKE '#attributes.filter_acc_code#.%' OR ACCOUNT_CODE LIKE '#attributes.filter_acc_code#')
					</cfif>
					<cfif len(attributes.keyword)>
						AND COMPANY.FULLNAME LIKE '%#attributes.keyword#%'
					</cfif>
					<cfif len(attributes.company_id) and len(attributes.company_name)>
						AND COMPANY.COMPANY_ID = #attributes.company_id#
					</cfif>
					AND COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID
					<cfif len(attributes.our_company_name)>
						AND COMPANY_PERIOD.PERIOD_ID = #listgetat(attributes.our_company_name,2,'-')#
					<cfelse>
						AND COMPANY_PERIOD.PERIOD_ID = #session.ep.period_id#
					</cfif>
					<cfif len(kurumsal)>
						AND COMPANY.COMPANYCAT_ID IN (#kurumsal#)
					<cfelseif not len(kurumsal) and len(bireysel)>
						AND 1=0
					</cfif>
					<cfif attributes.is_difference eq 1>
						AND ROUND(ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0),2) <> ROUND(ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0),2)
					</cfif>
					<cfif attributes.is_bakiye eq 1>
						AND (ROUND(ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0),2) <> 0 OR ROUND(ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0),2) <> 0)
					</cfif>
					<cfif Len(attributes.account_type_status)>
						AND ISNULL(COMPANY.COMPANY_STATUS,0) = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#attributes.account_type_status#">
					</cfif>
			</cfif>
			<cfif not len(attributes.company_name)>
				UNION ALL
			</cfif>
			<cfif (len(attributes.consumer_id) and len(attributes.company_name)) or not len(attributes.company_name)>
				SELECT 
					1 PROCESS_TYPE,
					CONSUMER.CONSUMER_ID PROCESS_ID,
					CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME PROCESS_NAME,
					CONSUMER.MEMBER_CODE PROCESS_CODE,
					ACCOUNT_CODE ACC_CODE,
					<cfif len(attributes.our_company_name)>
						(SELECT ACCOUNT_NAME FROM #dsn#_#listgetat(attributes.our_company_name,1,'-')#_#listgetat(attributes.our_company_name,3,'-')#.ACCOUNT_PLAN AP WHERE AP.ACCOUNT_CODE = CONSUMER_PERIOD.ACCOUNT_CODE) ACC_NAME,
					<cfelse>
						(SELECT ACCOUNT_NAME FROM #dsn2_alias#.ACCOUNT_PLAN AP WHERE AP.ACCOUNT_CODE = CONSUMER_PERIOD.ACCOUNT_CODE) ACC_NAME,
					</cfif>
					CONSUMER.CONSUMER_CAT_ID COMPANYCAT_ID,
					CONSUMER_CAT.CONSCAT MEMBER_CAT,
					CURRENT_REMAINDER.CURRENT_OTHER_MONEY,
					ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0) CURRENT_BAKIYE,
					ACCOUNT_REMAINDER.ACCOUNT_ACCOUNT_ID,
					ACCOUNT_REMAINDER.ACCOUNT_ACCOUNT_NAME,
					ACCOUNT_REMAINDER.ACCOUNT_OTHER_MONEY,
					ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0) ACCOUNT_BAKIYE
				FROM
					CONSUMER_PERIOD,
					CONSUMER
					LEFT JOIN CONSUMER_CAT ON CONSUMER_CAT.CONSCAT_ID = CONSUMER.CONSUMER_CAT_ID
					LEFT JOIN 
					(	<!--- Get_Consumer_Current_Remainder --->
						SELECT
							1 PROCESS_TYPE,
							CONSUMER_ID,
							OTHER_MONEY CURRENT_OTHER_MONEY,
							(BORC-ALACAK) AS CURRENT_BAKIYE
						FROM
							(
							SELECT
								CONSUMER_ID,
								<cfif len(attributes.other_money)>
									OTHER_MONEY,
									SUM(BORC3) AS BORC,
									SUM(ALACAK3) AS ALACAK
								<cfelse>
									'#session.ep.money#' OTHER_MONEY,
									SUM(BORC) AS BORC,
									SUM(ALACAK) AS ALACAK
								</cfif>
							FROM
								#dsn2_alias#.CARI_ROWS_CONSUMER
							WHERE
								1 = 1
								
								<cfif len(attributes.date1) and isdate(attributes.date1)>
									AND ACTION_DATE > = #attributes.date1#
								</cfif>
								<cfif len(attributes.date2) and isdate(attributes.date2)>
									AND ACTION_DATE < = #attributes.date2#
								</cfif>
							GROUP BY
								<cfif len(attributes.other_money)>
									OTHER_MONEY,
								</cfif>
								CONSUMER_ID
							)T1
					) CURRENT_REMAINDER ON CURRENT_REMAINDER.CONSUMER_ID = CONSUMER.CONSUMER_ID
					LEFT JOIN
					(	<!--- Get_Consumer_Account_Remainder --->
						SELECT
							CONSUMER_ID,
							ACCOUNT_ACCOUNT_ID,
							ACCOUNT_ACCOUNT_NAME,
							ACCOUNT_OTHER_MONEY,
							SUM(ACCOUNT_BAKIYE) ACCOUNT_BAKIYE
						FROM
						(
							SELECT
								CP.CONSUMER_ID,
								<cfif len(attributes.other_money)>
									SUM(AART.BORC3-AART.ALACAK3) ACCOUNT_BAKIYE
								<cfelse>
									SUM(AART.BORC-AART.ALACAK) ACCOUNT_BAKIYE
								</cfif>,
								AART.ACCOUNT_ID ACCOUNT_ACCOUNT_ID,
								AP.ACCOUNT_NAME ACCOUNT_ACCOUNT_NAME,
								<cfif len(attributes.other_money)>
									AART.OTHER_MONEY ACCOUNT_OTHER_MONEY
								<cfelse>
									'#session.ep.money#' ACCOUNT_OTHER_MONEY
								</cfif>
							FROM
								#dsn_alias#.CONSUMER_PERIOD CP,
								#dsn_alias#.OUR_COMPANY OC,
								#dsn_alias#.SETUP_PERIOD SP,
								<cfif len(attributes.other_money)>
									#dsn2_alias#.ACCOUNT_ACCOUNT_REMAINDER_MONEY AART
								<cfelse>
									#dsn2_alias#.ACCOUNT_ACCOUNT_REMAINDER AART
								</cfif>,
								#dsn2_alias#.ACCOUNT_PLAN AP
							WHERE
								<cfif len(attributes.other_money)>
									AART.OTHER_MONEY = '#attributes.other_money#' AND
								</cfif>
								<cfif len(attributes.our_company_name)>
									SP.PERIOD_YEAR = #listfirst(attributes.our_company_name,'-')# AND
									OC.COMP_ID = #listlast(attributes.our_company_name,'-')# AND
								<cfelse>
									SP.PERIOD_YEAR = #session.ep.period_year# AND
									OC.COMP_ID = #session.ep.company_id# AND
								</cfif>
								CP.ACCOUNT_CODE = AART.ACCOUNT_ID AND
								AP.ACCOUNT_CODE = AART.ACCOUNT_ID AND
								SP.PERIOD_ID = CP.PERIOD_ID AND
								OC.COMP_ID = SP.OUR_COMPANY_ID
								<cfif len(attributes.date1) and isdate(attributes.date1)>
									AND AART.ACTION_DATE > = #attributes.date1#
								</cfif>
								<cfif len(attributes.date2) and isdate(attributes.date2)>
									AND AART.ACTION_DATE < = #attributes.date2#
								</cfif>
							GROUP BY
								<cfif len(attributes.other_money)>
									AART.OTHER_MONEY,
								</cfif>
								AART.ACCOUNT_ID,
								CP.CONSUMER_ID,
								AP.ACCOUNT_NAME
						)T1
						GROUP BY
							<cfif len(attributes.other_money)>
								ACCOUNT_OTHER_MONEY,
							</cfif>
							CONSUMER_ID,
							ACCOUNT_ACCOUNT_ID,
							ACCOUNT_ACCOUNT_NAME,
							ACCOUNT_OTHER_MONEY
						) ACCOUNT_REMAINDER ON ACCOUNT_REMAINDER.CONSUMER_ID = CONSUMER.CONSUMER_ID
				WHERE
					1 = 1
					<cfif len(attributes.other_money)>
						AND ACCOUNT_OTHER_MONEY = '#attributes.other_money#'
					</cfif>
					<cfif attributes.is_acc_code eq 1>
						AND ACCOUNT_CODE IS NOT NULL
					</cfif>
					<cfif len(attributes.filter_acc_code)>
						AND (ACCOUNT_CODE LIKE '#attributes.filter_acc_code#.%' OR ACCOUNT_CODE LIKE '#attributes.filter_acc_code#')
					</cfif>
					<cfif len(attributes.keyword)>
						AND CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME LIKE '%#attributes.keyword#%'
					</cfif>
					<cfif len(attributes.consumer_id) and len(attributes.company_name)>
						AND CONSUMER.CONSUMER_ID = #attributes.consumer_id#
					</cfif>
					AND CONSUMER_PERIOD.CONSUMER_ID = CONSUMER.CONSUMER_ID
					<cfif len(attributes.our_company_name)>
						AND CONSUMER_PERIOD.PERIOD_ID = #listgetat(attributes.our_company_name,2,'-')#
					<cfelse>
						AND CONSUMER_PERIOD.PERIOD_ID = #session.ep.period_id#
					</cfif>
					<cfif len(bireysel)>
						AND CONSUMER.CONSUMER_CAT_ID IN (#bireysel#)
					<cfelseif not len(bireysel) and len(kurumsal)>
						AND 1=0
					</cfif>
					<cfif attributes.is_difference eq 1>
						AND ROUND(ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0),2)  <> ROUND(ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0),2)
					</cfif>
					<cfif attributes.is_bakiye eq 1>
						AND (ROUND(ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0),2) <> 0 OR ROUND(ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0),2) <> 0)
					</cfif>
					<cfif Len(attributes.account_type_status)>
						AND ISNULL(CONSUMER.CONSUMER_STATUS,0) = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#attributes.account_type_status#">
					</cfif>
			</cfif>
			ORDER BY
				PROCESS_NAME
		</cfquery>
	<cfelseif attributes.account_type eq 1>
		<!--- Banka Islemleri --->
		<cfquery name="Main_Query" datasource="#data_source_3#">
			SELECT
				0 PROCESS_TYPE,
				ACCOUNTS.ACCOUNT_ID PROCESS_ID,
				ACCOUNTS.ACCOUNT_NAME PROCESS_NAME,
				ACCOUNTS.ACCOUNT_NO PROCESS_CODE,
				ACCOUNT_ACC_CODE ACC_CODE,
				AP.ACCOUNT_NAME ACC_NAME,
				'' COMPANYCAT_ID,
				CURRENT_REMAINDER.CURRENT_OTHER_MONEY,
				ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0) CURRENT_BAKIYE,
				ACCOUNT_REMAINDER.ACCOUNT_ACCOUNT_ID,
				ACCOUNT_REMAINDER.ACCOUNT_ACCOUNT_NAME,
				ACCOUNT_REMAINDER.ACCOUNT_OTHER_MONEY,
				ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0) ACCOUNT_BAKIYE
			FROM
				#data_source#.ACCOUNT_PLAN AP,
				ACCOUNTS
				LEFT JOIN
				(	<!--- Get_Current_Remainder --->
					SELECT
						ACCOUNT_ID,
						<cfif len(attributes.other_money)>
							ACCOUNT_CURRENCY_ID CURRENT_OTHER_MONEY,
						<cfelse>
							'#session.ep.money#' CURRENT_OTHER_MONEY,
						</cfif>
						SUM(BORC-ALACAK) AS CURRENT_BAKIYE
					FROM
						(
						SELECT     
							ACCOUNTS.ACCOUNT_ID,
							<cfif len(attributes.other_money)>
								ACCOUNT_CURRENCY_ID,
								SUM(BANK_ACTIONS.ACTION_VALUE) AS BORC,
								0 ALACAK
							<cfelse>
								CASE WHEN ACTION_TYPE_ID = 1043
								THEN
								SUM(BANK_ACTIONS.SYSTEM_ACTION_VALUE -MASRAF) 
								ELSE
								SUM(BANK_ACTIONS.SYSTEM_ACTION_VALUE) 
								END
								AS BORC,
								--SUM(BANK_ACTIONS.SYSTEM_ACTION_VALUE) AS BORC,
								0 ALACAK
							</cfif>
						FROM
							#dsn2_alias#.BANK_ACTIONS, 
							#dsn3_alias#.ACCOUNTS AS ACCOUNTS
						WHERE
							ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_TO_ACCOUNT_ID
							-- AND BANK_ACTIONS.ACTION_TYPE_ID <> 93
							<cfif len(attributes.other_money)>
								AND ACCOUNT_CURRENCY_ID = '#attributes.other_money#'
							</cfif>
							<cfif len(attributes.date1) and isdate(attributes.date1)>
								AND ACTION_DATE > = #attributes.date1#
							</cfif>
							<cfif len(attributes.date2) and isdate(attributes.date2)>
								AND ACTION_DATE < = #attributes.date2#
							</cfif>
						GROUP BY
							ACCOUNTS.ACCOUNT_ID, 
							ACCOUNTS.ACCOUNT_NAME,
							ACTION_TYPE_ID,
							ACCOUNTS.ACCOUNT_CURRENCY_ID,
							BANK_ACTIONS.ACTION_DATE
					UNION ALL
						SELECT
							ACCOUNT_ID,
							<cfif len(attributes.other_money)>
								ACCOUNT_CURRENCY_ID,
								0 AS BORC,
								SUM(BANK_ACTIONS.ACTION_VALUE) ALACAK
							<cfelse>
								0 AS BORC,
								CASE WHEN ACTION_TYPE_ID = 293
								THEN
								SUM(BANK_ACTIONS.SYSTEM_ACTION_VALUE+MASRAF) 
								ELSE
								SUM(BANK_ACTIONS.SYSTEM_ACTION_VALUE) 
								END
								AS ALACAK
							</cfif>
						FROM
							#dsn2_alias#.BANK_ACTIONS, 
							#dsn3_alias#.ACCOUNTS AS ACCOUNTS
						WHERE    
							ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID 
							--AND BANK_ACTIONS.ACTION_TYPE_ID <> 93
							<cfif len(attributes.other_money)>
								AND ACCOUNT_CURRENCY_ID = '#attributes.other_money#'
							</cfif>
							<cfif len(attributes.date1) and isdate(attributes.date1)>
								AND ACTION_DATE > = #attributes.date1#
							</cfif>
							<cfif len(attributes.date2) and isdate(attributes.date2)>
								AND ACTION_DATE < = #attributes.date2#
							</cfif>
						GROUP BY
							ACCOUNTS.ACCOUNT_ID, 
							ACCOUNTS.ACCOUNT_NAME, 
							ACCOUNTS.ACCOUNT_CURRENCY_ID,
							BANK_ACTIONS.ACTION_DATE,
							BANK_ACTIONS.ACTION_TYPE_ID
						)T1
					GROUP BY
						ACCOUNT_ID
						<cfif len(attributes.other_money)>
							,ACCOUNT_CURRENCY_ID
						</cfif>
				) CURRENT_REMAINDER ON CURRENT_REMAINDER.ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID
				LEFT JOIN 
				(	<!--- Get_Account_Remainder --->
					SELECT
						A.ACCOUNT_ID,
						<cfif len(attributes.other_money)>
							AART.OTHER_MONEY ACCOUNT_OTHER_MONEY,
						<cfelse>
							'#session.ep.money#' ACCOUNT_OTHER_MONEY,
						</cfif>
						<cfif len(attributes.other_money)>
							SUM(AART.BORC3-AART.ALACAK3) ACCOUNT_BAKIYE
						<cfelse>
							SUM(AART.BORC-AART.ALACAK) ACCOUNT_BAKIYE
						</cfif>,
						AART.ACCOUNT_ID ACCOUNT_ACCOUNT_ID,
						AP.ACCOUNT_NAME ACCOUNT_ACCOUNT_NAME
					FROM
						#data_source_3#.ACCOUNTS A,
						<cfif len(attributes.other_money)>
							#dsn2_alias#.ACCOUNT_ACCOUNT_REMAINDER_MONEY AART
						<cfelse>
							#dsn2_alias#.ACCOUNT_ACCOUNT_REMAINDER AART
						</cfif>,
						#dsn2_alias#.ACCOUNT_PLAN AP
					WHERE
						A.ACCOUNT_ACC_CODE = AART.ACCOUNT_ID
						AND AP.ACCOUNT_CODE = AART.ACCOUNT_ID
						<cfif len(attributes.other_money)>
							AND AART.OTHER_MONEY = '#attributes.other_money#'
						</cfif>
						<cfif len(attributes.date1) and isdate(attributes.date1)>
							AND AART.ACTION_DATE > = #attributes.date1#
						</cfif>
						<cfif len(attributes.date2) and isdate(attributes.date2)>
							AND AART.ACTION_DATE < = #attributes.date2#
						</cfif>
					GROUP BY
						A.ACCOUNT_ID,
						A.ACCOUNT_NAME,
						A.ACCOUNT_ACC_CODE,
						<cfif len(attributes.other_money)>
							OTHER_MONEY,
						</cfif>
						AART.ACCOUNT_ID,
						AP.ACCOUNT_NAME
				) ACCOUNT_REMAINDER ON ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID
			WHERE
				ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn_alias#.SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND COMPANY_ID=#session.ep.company_id#)
				<cfif attributes.is_acc_code eq 1>
					AND ACCOUNTS.ACCOUNT_ACC_CODE IS NOT NULL
				</cfif>
				<cfif len(attributes.filter_acc_code)>
					AND (ACCOUNTS.ACCOUNT_ACC_CODE LIKE '#attributes.filter_acc_code#.%' OR ACCOUNTS.ACCOUNT_ACC_CODE LIKE '#attributes.filter_acc_code#')
				</cfif>
				AND ACCOUNTS.ACCOUNT_ACC_CODE = AP.ACCOUNT_CODE
				<cfif len(attributes.bank_id)>
					AND ACCOUNTS.ACCOUNT_ID = #attributes.bank_id#
				</cfif>
				<cfif len(attributes.other_money)>
					AND ACCOUNT_CURRENCY_ID = '#attributes.other_money#'
				</cfif>
				<cfif len(attributes.keyword)>
					AND ACCOUNTS.ACCOUNT_NAME LIKE '%#attributes.keyword#%'
				</cfif>
				<cfif attributes.is_difference eq 1>
					AND ROUND(ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0),2)  <> ROUND(ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0),2)
				</cfif>
				<cfif attributes.is_bakiye eq 1>
					AND (ROUND(ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0),2) <> 0 OR ROUND(ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0),2) <> 0)
				</cfif>
				<cfif Len(attributes.account_type_status)>
					AND ISNULL(ACCOUNTS.ACCOUNT_STATUS,0) = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#attributes.account_type_status#">
				</cfif>
			ORDER BY
				PROCESS_NAME
		</cfquery>
	<cfelseif attributes.account_type eq 2>
		<!--- Kasa Islemleri --->
		<cfquery name="Main_Query" datasource="#data_source#">
			SELECT
				0 PROCESS_TYPE,
				CASH_ID PROCESS_ID,
				CASH_NAME PROCESS_NAME,
				CASH_CODE PROCESS_CODE,
				CASH_ACC_CODE ACC_CODE,
				ACCOUNT_NAME ACC_NAME,
				'' COMPANYCAT_ID,
				CURRENT_REMAINDER.CURRENT_OTHER_MONEY,
				ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0) CURRENT_BAKIYE,
				ACCOUNT_REMAINDER.ACCOUNT_ACCOUNT_ID,
				ACCOUNT_REMAINDER.ACCOUNT_ACCOUNT_NAME,
				ACCOUNT_REMAINDER.ACCOUNT_OTHER_MONEY,
				ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0) ACCOUNT_BAKIYE
			FROM
				ACCOUNT_PLAN AP,
				CASH
				LEFT JOIN
				(	<!--- Get_Current_Remainder --->
					SELECT 
						CURRENT_CASH_ID,
						<cfif len(attributes.other_money)>
							CASH_ACTION_CURRENCY_ID CURRENT_OTHER_MONEY,
						<cfelse>
							'#session.ep.money#' CURRENT_OTHER_MONEY,
						</cfif>
						SUM(BORC-ALACAK) AS CURRENT_BAKIYE
					FROM
						(
							SELECT
								<cfif len(attributes.other_money)>
									CA.CASH_ACTION_CURRENCY_ID,
									0 AS BORC,
									SUM(CA.CASH_ACTION_VALUE) ALACAK,
								<cfelse>
									0 AS BORC,
									SUM(CA.ACTION_VALUE) ALACAK,
								</cfif>
								C.CASH_ID CURRENT_CASH_ID
							FROM
								#dsn2_alias#.CASH_ACTIONS CA, 
								#dsn2_alias#.CASH C
							WHERE
								CA.CASH_ACTION_FROM_CASH_ID = C.CASH_ID
								<cfif len(attributes.other_money)>
									AND CASH_ACTION_CURRENCY_ID = '#attributes.other_money#'
								</cfif>
								<cfif len(attributes.date1) and isdate(attributes.date1)>
									AND CA.ACTION_DATE > = #attributes.date1#
								</cfif>
								<cfif len(attributes.date2) and isdate(attributes.date2)>
									AND CA.ACTION_DATE < = #attributes.date2#
								</cfif>
							GROUP BY
								<cfif len(attributes.other_money)>
									CA.CASH_ACTION_CURRENCY_ID,
								</cfif>
								C.CASH_ID
						UNION
							SELECT
								<cfif len(attributes.other_money)>
									CA.CASH_ACTION_CURRENCY_ID,
									SUM(CA.CASH_ACTION_VALUE) AS BORC,
									0 ALACAK,
								<cfelse>
									SUM(CA.ACTION_VALUE) AS BORC,
									0 ALACAK,
								</cfif>
								C.CASH_ID CURRENT_CASH_ID
							FROM
								#dsn2_alias#.CASH_ACTIONS CA, 
								#dsn2_alias#.CASH C
							WHERE
								CA.CASH_ACTION_TO_CASH_ID = C.CASH_ID 
								<cfif len(attributes.other_money)>
									AND CASH_ACTION_CURRENCY_ID = '#attributes.other_money#'
								</cfif>
								<cfif len(attributes.date1) and isdate(attributes.date1)>
									AND CA.ACTION_DATE > = #attributes.date1#
								</cfif>
								<cfif len(attributes.date2) and isdate(attributes.date2)>
									AND CA.ACTION_DATE < = #attributes.date2#
								</cfif>
							GROUP BY
								<cfif len(attributes.other_money)>
									CA.CASH_ACTION_CURRENCY_ID,
								</cfif>
								C.CASH_ID
						) T3
					GROUP BY
						CURRENT_CASH_ID
						<cfif len(attributes.other_money)>
							,CASH_ACTION_CURRENCY_ID
						</cfif>
				) CURRENT_REMAINDER ON CURRENT_REMAINDER.CURRENT_CASH_ID = CASH.CASH_ID
				LEFT JOIN
				(	<!--- Get_Account_Remainder --->
					SELECT
						C.CASH_ID ACCOUNT_CASH_ID,
						<cfif len(attributes.other_money)>
							AART.OTHER_MONEY ACCOUNT_OTHER_MONEY,
						<cfelse>
							'#session.ep.money#' ACCOUNT_OTHER_MONEY,
						</cfif>
						<cfif len(attributes.other_money)>
							SUM(AART.BORC3-AART.ALACAK3) ACCOUNT_BAKIYE
						<cfelse>
							SUM(AART.BORC-AART.ALACAK) ACCOUNT_BAKIYE
						</cfif>,
						AART.ACCOUNT_ID ACCOUNT_ACCOUNT_ID,
						AP.ACCOUNT_NAME ACCOUNT_ACCOUNT_NAME
					FROM
						CASH C,
						<cfif len(attributes.other_money)>
							ACCOUNT_ACCOUNT_REMAINDER_MONEY AART
						<cfelse>
							ACCOUNT_ACCOUNT_REMAINDER AART
						</cfif>,
						ACCOUNT_PLAN AP
					WHERE
						 C.CASH_ACC_CODE = AART.ACCOUNT_ID
						AND AP.ACCOUNT_CODE = AART.ACCOUNT_ID
						<cfif len(attributes.other_money)>
							AND AART.OTHER_MONEY = '#attributes.other_money#'
						</cfif>
						<cfif len(attributes.date1) and isdate(attributes.date1)>
							AND AART.ACTION_DATE > = #attributes.date1#
						</cfif>
						<cfif len(attributes.date2) and isdate(attributes.date2)>
							AND AART.ACTION_DATE < = #attributes.date2#
						</cfif>	
					GROUP BY
						C.CASH_ID,
						C.CASH_NAME,
						C.CASH_ACC_CODE,
						<cfif len(attributes.other_money)>
							OTHER_MONEY,
						</cfif>
						AART.ACCOUNT_ID,
						AP.ACCOUNT_NAME	
				) ACCOUNT_REMAINDER ON ACCOUNT_REMAINDER.ACCOUNT_CASH_ID = CASH.CASH_ID
			WHERE
				CASH_CURRENCY_ID IN (SELECT MONEY FROM #dsn_alias#.SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND COMPANY_ID=#session.ep.company_id#)
				<cfif attributes.is_acc_code eq 1>
					AND CASH.CASH_ACC_CODE IS NOT NULL
				</cfif>
				<cfif len(attributes.filter_acc_code)>
					AND (CASH.CASH_ACC_CODE LIKE '#attributes.filter_acc_code#.%' OR CASH.CASH_ACC_CODE LIKE '#attributes.filter_acc_code#')
				</cfif>
				AND CASH.CASH_ACC_CODE = AP.ACCOUNT_CODE
				<cfif len(attributes.cash_id)>
					AND CASH_ID = #attributes.cash_id#
				</cfif>
				<cfif len(attributes.other_money)>
					AND CASH_CURRENCY_ID = '#attributes.other_money#'
				</cfif>
				<cfif len(attributes.keyword)>
					AND CASH_NAME LIKE '%#attributes.keyword#%'
				</cfif>
				<cfif attributes.is_difference eq 1>
					AND ROUND(ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0),2)  <> ROUND(ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0),2)
				</cfif>
				<cfif attributes.is_bakiye eq 1>
					AND (ROUND(ISNULL(CURRENT_REMAINDER.CURRENT_BAKIYE,0),2) <> 0 OR ROUND(ISNULL(ACCOUNT_REMAINDER.ACCOUNT_BAKIYE,0),2) <> 0)
				</cfif>
				<cfif Len(attributes.account_type_status)>
					AND ISNULL(CASH.CASH_STATUS,0) = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#attributes.account_type_status#">
				</cfif>
			ORDER BY
				PROCESS_NAME
		</cfquery>
	<cfelse>
		<cfset Main_Query.RecordCount = 0>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57519.Cari Hesap'> , <cf_get_lang dictionary_id='57520.Kasa'> <cf_get_lang dictionary_id='57998.veya'> <cf_get_lang dictionary_id='57521.Banka'>");
			history.back();
		</script>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#Main_Query.RecordCount#">
	<cfif attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = Main_Query.recordcount>
	</cfif>
</cfif>
<cfif len(attributes.date1) and isdate(attributes.date1)><cfset attributes.date1 = dateformat(attributes.date1, dateformat_style)></cfif>
<cfif len(attributes.date2) and isdate(attributes.date2)><cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)></cfif>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='47828.Muhasebe ve Cari Bakiye Karşılaştırması'></cfsavecontent>
<cf_report_list_search title="#title#">	
	<cf_report_list_search_area>
		<cfform name="form" id="form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
			<cfoutput>
			<input type="hidden" name="is_submit" id="is_submit" value="1">
				<div class="row">
               	 	<div class="col col-12 col-xs-12">
                    	<div class="row formContent">
                        	<div class="row" type="row">
								<div class="col col-4 col-md-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">										
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
											<div class="col col-12 col-xs-12">
												<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="255">
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38729.Şirket Dönem'></label>
											<div class="col col-12 col-xs-12">
												<select name="our_company_name" id="our_company_name" style="width:180px;">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfloop query="get_our_company">
														<option value="#period_year#-#period_id#-#comp_id#" <cfif attributes.our_company_name eq '#period_year#-#period_id#-#comp_id#'>selected</cfif>>#nick_name# - #period#</option>
													</cfloop>
												</select>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-5 col-xs-5">
												<label><cf_get_lang dictionary_id='57519.Cari Hesap'><input type="radio" name="account_type" id="account_type" value="0" onclick="change_relation_input(0);" <cfif attributes.account_type eq 0>checked</cfif>></label>
												<label><cf_get_lang dictionary_id='29449.Banka Hesabı'><input type="radio" name="account_type" id="account_type" value="1" onclick="change_relation_input(1);" <cfif attributes.account_type eq 1>checked</cfif>></label>
												<label><cf_get_lang dictionary_id='40641.Kasa Hesabı'><input type="radio" name="account_type" id="account_type" value="2" onclick="change_relation_input(2);" <cfif attributes.account_type eq 2>checked</cfif>></label>
											</div>
											<div class="col col-7 col-xs-7">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
												<select name="account_type_status" id="account_type_status">
													<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
													<option value="1" <cfif attributes.account_type_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
													<option value="0" <cfif attributes.account_type_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
												</select>
											</div>
										</div>										
									</div>
								</div>
								<div class="col col-4 col-md-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">										
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<cfif len(attributes.date1)>
														<cfinput value="#attributes.date1#" type="text" name="date1" id="date1" maxlength="10" style="width:65px;" validate="#validate_style#">
													<cfelse>
														<cfinput value="" type="text" name="date1" id="date1" maxlength="10" style="width:65px;" validate="#validate_style#">
													</cfif>
													<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>   
													<span class="input-group-addon no-bg"></span>
													<cfif len(attributes.date2)>
														<cfinput value="#attributes.date2#"  type="text" name="date2" id="date2" maxlength="10" style="width:65px;" validate="#validate_style#">
													<cfelse>
														<cfinput value=""  type="text" name="date2" id="date2" maxlength="10" style="width:65px;" validate="#validate_style#">
													</cfif>
													<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>   
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<input type="text" name="filter_acc_code" id="filter_acc_code" value="<cfif len(attributes.filter_acc_code)>#attributes.filter_acc_code#</cfif>" style="width:180px;" onFocus="AutoComplete_Create('filter_acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');" >
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=form.filter_acc_code','list');"></span>  
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></label>
											<div class="col col-9 col-xs-12">
												<select name="other_money" id="other_money" style="width:100px;">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfloop query="get_system_money">
														<option value="#money#" <cfif attributes.other_money eq money>selected</cfif>>#money#</option>
													</cfloop>
												</select>
											</div>
										</div>										
									</div>
								</div>
								<div class="col col-4 col-md-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">										
										<div class="form-group" id="td_member_head" style="<cfif attributes.account_type neq 0>display:none;</cfif>">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57519.Cari Hesap'></label>
											<div class="col col-12 col-xs-12" id="td_member_body">
												<div class="input-group">
													<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id) and len(attributes.company_name)>#attributes.consumer_id#</cfif>">
													<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id) and len(attributes.company_name)>#attributes.company_id#</cfif>">
													<input type="text" name="company_name" id="company_name" style="width:180px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'1\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','form','3','250');" value="<cfif (len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.company_name)>#attributes.company_name#</cfif>" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_consumer=form.consumer_id&field_member_name=form.company_name&field_comp_name=form.company_name&field_comp_id=form.company_id&select_list=7,8','list');"></span>  
												</div>
											</div>
										</div>
										<div class="form-group" id="td_member_cat" style="<cfif attributes.account_type neq 0>display:none;</cfif>">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='39242.Müşteri Kat'></label>
											<div class="col col-12 col-xs-12" id="td_member_cat_body">
												<select name="category_id" id="category_id" style="width:180px;" multiple="multiple">
													<optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
														<cfloop query="get_comp_category">
															<option value="1-#category_id#"  <cfif listfind(attributes.category_id,'1-#category_id#')>selected</cfif>>&nbsp;&nbsp;#category_name#</option>
														</cfloop>
													</optgroup>
													<optgroup label="<cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'>">
														<cfloop query="get_cons_category">
															<option value="2-#category_id#"  <cfif listfind(attributes.category_id,'2-#category_id#')>selected</cfif>>&nbsp;&nbsp;#category_name#</option>
														</cfloop>
													</optgroup>
												</select> 
											</div>											
										</div>
										<div class="form-group" id="td_bank_head" style="<cfif attributes.account_type neq 1>display:none;</cfif>">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'></label>
											<div class="col col-12 col-xs-12" id="td_bank_body">
												<select name="bank_id" id="bank_id" style="width:180px;">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfloop query="get_acc_name">
														<option value="#account_id#" <cfif len(attributes.bank_id) and attributes.bank_id eq account_id>selected</cfif>>#account_name#-#account_currency_id#</option>
													</cfloop>
												</select>
											</div>
										</div>
										<div class="form-group" id="td_cash_head" style="<cfif attributes.account_type neq 2>display:none;</cfif>">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
											<div class="col col-12 col-xs-12" id="td_cash_body">
												<select name="cash_id" id="cash_id" style="width:180px;">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfloop query="get_cash_name">
														<option value="#cash_id#" <cfif len(attributes.cash_id) and attributes.cash_id eq cash_id>selected</cfif>>#cash_name#</option>
													</cfloop>
												</select>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-xs-12">
												<label><cf_get_lang dictionary_id='38987.Muhasebe Kodu Olmayanlar Gelmesin'><input type="checkbox" name="is_acc_code" id="is_acc_code" value="1" <cfif attributes.is_acc_code eq 1>checked</cfif>></label>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-xs-12">
												<label>#getlang('finance',514)#<input type="checkbox" name="is_difference" id="is_difference" value="1" <cfif attributes.is_difference eq 1>checked</cfif>></label>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-xs-12">
												<label><cf_get_lang dictionary_id='40363.Sadece Bakiyesi Olanlar'><input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif attributes.is_bakiye eq 1>checked</cfif>></label>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row ReportContentBorder">
							<div class="ReportContentFooter">
								<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
								<cfinput type="text" name="maxrows" id="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1," required="yes" onKeyUp="isNumber(this);" message="#message#">
								<cf_wrk_report_search_button button_type='1' is_excel='1' search_function='control()'>
							</div>
						</div>
					</div>
				</div>
			</cfoutput>
		</cfform>
	</cf_report_list_search_area>
</cf_report_list_search>	
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
<cf_report_list>
	<thead>
    <tr> 
		<th width="20" align="center"><cf_get_lang dictionary_id='57487.No'></th>
		<th><cf_get_lang dictionary_id='38890.Hesap Adı'></th>
		<th><cf_get_lang dictionary_id='38889.Hesap Kodu'></th>
		<cfif x_show_companycat eq 1 and (isdefined("account_type") and account_type eq 0)><th><cf_get_lang dictionary_id='58609.Üye Kategorisi'></th></cfif>
		<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
		<th width="250"><cf_get_lang dictionary_id='39383.Muhasebe Kodu Açıklaması'></th>
		<th width="150" align="right" style="text-align:right;">
			<cfif attributes.account_type eq 0>
				<cf_get_lang dictionary_id='40359.Üye Hesap Bakiyesi'>
			<cfelseif attributes.account_type eq 1>
				<cf_get_lang dictionary_id='40642.Banka Bakiyesi'>
			<cfelseif attributes.account_type eq 2>
				<cf_get_lang dictionary_id='40643.Kasa Bakiyesi'>
			</cfif>
		</th>
		<th width="50" align="center"><cf_get_lang dictionary_id='29683.B/A'></th>
		<th width="150" align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40360.Muhasebe Hesap Bakiyesi'></th>
		<th width="50" align="center"><cf_get_lang dictionary_id='29683.B/A'></th>
		<th width="120"><cf_get_lang dictionary_id ='57489.Para Br'></th>
	</tr>
    </thead>
    <tbody>
	<cfif isdefined("attributes.is_submit") and Main_Query.RecordCount>
		<cfoutput query="Main_Query" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif compare(wrk_round(current_bakiye),wrk_round(account_bakiye))>
				<cfset color_value='FF0000'>
			<cfelse>
				<cfset color_value='000000'>
			</cfif>
			<tr>
				<td height="20" align="center">
					<cfif type_ eq 1>
						#currentrow#
					<cfelse>
						<font color="#color_value#">#currentrow#</font>
					</cfif>
				</td>
				<td height="20">
					<cfif type_ eq 1>
						#process_name#
					<cfelse>
						<cfif attributes.account_type eq 0> 
							<cfif Process_Type eq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#process_id#','medium','popup_con_det');">
							<cfelse>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#process_id#','medium','popup_com_det');">
							</cfif>
							<font color="#color_value#">#process_name#</font>
							</a>
						<cfelse>
							<font color="#color_value#">#process_name#</font>
						</cfif>				
					</cfif>
				</td>
				<td>
					<cfif type_ eq 1>
						#process_code#
					<cfelse>
						<font color="#color_value#">#process_code#</font>					
					</cfif>
				</td>
				<cfif x_show_companycat eq 1 and (isdefined("account_type") and account_type eq 0)>
					<td><cfif len(companycat_id)>#member_cat#</cfif></td>
				</cfif>
				<td style="mso-number-format:\@;">
					<cfif Len(account_account_id)>#account_account_id#<cfelse>#acc_code#</cfif>
				</td>
				<td>
					<cfif Len(account_account_name)>#account_account_name#<cfelse>#acc_name#</cfif>
				</td>
				<td align="right" style="text-align:right;" format="numeric">
					<cfif type_ eq 1>
						#TLFormat(abs(current_bakiye))#
					<cfelse>
						<font color="#color_value#">#TLFormat(abs(current_bakiye))#</font>
					</cfif>
				</td>
				<td align="center">
					<cfif type_ eq 1>
						<cfif current_bakiye lte 0><cf_get_lang dictionary_id='29684.A'><cfelse><cf_get_lang dictionary_id='58591.B'></cfif>
					<cfelse>
						<font color="#color_value#"><cfif current_bakiye lte 0><cf_get_lang dictionary_id='29684.A'><cfelse><cf_get_lang dictionary_id='58591.B'></cfif></font>
					</cfif>
				</td>
				<td align="right" style="text-align:right;" format="numeric">
					<cfif type_ eq 1>
						#TLFormat(abs(account_bakiye))#
					<cfelse>
						<font color="#color_value#">#TLFormat(abs(account_bakiye))#</font>
					</cfif>
				</td>
				<td align="center">
					<cfif type_ eq 1>
						<cfif account_bakiye lte 0><cf_get_lang dictionary_id='29684.A'><cfelse><cf_get_lang dictionary_id='58591.B'></cfif>
					<cfelse>
						<font color="#color_value#"><cfif account_bakiye lte 0><cf_get_lang dictionary_id='29684.A'><cfelse><cf_get_lang dictionary_id='58591.B'></cfif></font>
					</cfif>
				</td>
				<td>
					<cfif type_ eq 1>
						#account_other_money#
					<cfelse>
						<font color="#color_value#">#account_other_money#</font>
					</cfif>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<cfset colspan_ = 10>
			<cfif x_show_companycat eq 1>
				<cfset colspan_ = colspan_ + 1>
			</cfif>
			<td colspan="<cfoutput>#colspan_#</cfoutput>" class="color-row"><cfif isdefined('attributes.is_submit')><cf_get_lang dictionary_id='57484.Kayıt yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
		</tr>
	</cfif>
    </tbody>
</cf_report_list>
<cfif isdefined('attributes.is_submit') and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "&is_submit=1">
	<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
	<cfif len(attributes.company_id)><cfset url_str= "#url_str#&company_id=#attributes.company_id#&company_name=#attributes.company_name#"></cfif>
	<cfif len(attributes.consumer_id)><cfset url_str= "#url_str#&consumer_id=#attributes.consumer_id#&company_name=#attributes.company_name#"></cfif>
	<cfif len(attributes.our_company_name)><cfset url_str= "#url_str#&our_company_name=#attributes.our_company_name#"></cfif>
	<cfif len(attributes.other_money)><cfset url_str= "#url_str#&other_money=#attributes.other_money#"></cfif>
	<cfif len(attributes.date1)><cfset url_str = "#url_str#&date1=#attributes.date1#"></cfif>
	<cfif len(attributes.date2)><cfset url_str = "#url_str#&date2=#attributes.date2#"></cfif>
	<cfif isdefined("attributes.iz_zero_bakiye")><cfset url_str = "#url_str#&iz_zero_bakiye=#attributes.iz_zero_bakiye#"></cfif>
	<cfif len(attributes.account_type)><cfset url_str = "#url_str#&account_type=#attributes.account_type#"></cfif>
	<cfif len(attributes.account_type_status)><cfset url_str = "#url_str#&account_type_status=#attributes.account_type_status#"></cfif>
	<cfif len(attributes.cash_id)><cfset url_str = "#url_str#&cash_id=#attributes.cash_id#"></cfif>
	<cfif len(attributes.bank_id)><cfset url_str = "#url_str#&bank_id=#attributes.bank_id#"></cfif>
	<cfif len(attributes.is_excel)><cfset url_str = "#url_str#&is_excel=#attributes.is_excel#"></cfif>
	<cfif len(attributes.is_acc_code)><cfset url_str = "#url_str#&is_acc_code=#attributes.is_acc_code#"></cfif>
	<cfif len(attributes.is_difference)><cfset url_str = "#url_str#&is_difference=#attributes.is_difference#"></cfif>
	<cfif len(attributes.is_bakiye)><cfset url_str = "#url_str#&is_bakiye=#attributes.is_bakiye#"></cfif>
	<cfif len(attributes.filter_acc_code)><cfset url_str = "#url_str#&filter_acc_code=#attributes.filter_acc_code#"></cfif>
	<cfif len(attributes.category_id)><cfset url_str = "#url_str#&category_id=#attributes.category_id#"></cfif>
	<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#attributes.fuseaction##url_str#">
</cfif>
<script language="javascript">
	var account_type_ = "<cfoutput>#attributes.account_type#</cfoutput>";
	$(document).ready(function(e){
		change_relation_input(account_type_);
	});
	
	function control(){
		if(document.form.is_excel.checked==false)
		{
			document.form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_company_account_code</cfoutput>"
	}

	function change_relation_input(x)
	{
		if(x == 1)
		{
			gizle(td_member_head);gizle(td_member_body);
			gizle(td_member_cat);gizle(td_member_cat_body);
			gizle(td_cash_head);gizle(td_cash_body);
			goster(td_bank_head);goster(td_bank_body);
		}
		else if(x == 2)
		{
			gizle(td_member_head);gizle(td_member_body);
			gizle(td_member_cat);gizle(td_member_cat_body);
			gizle(td_bank_head);gizle(td_bank_body);
			goster(td_cash_head);goster(td_cash_body);
		}
		else
		{
			gizle(td_cash_head);gizle(td_cash_body);
			gizle(td_bank_head);gizle(td_bank_body);
			goster(td_member_head);goster(td_member_body);
			goster(td_member_cat);goster(td_member_cat_body);
		}
	}
</script>