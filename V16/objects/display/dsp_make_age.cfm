<cfsetting showdebugoutput="no"><!---bu sayfa toplu ödeme performansdan ajaxla çağrıldıgı zaman debug kapatılması gerekiyor..AE --->
<cfset kontrol_name = 0>
<cfif not isdefined("attributes.row_id")>
	<cfset attributes.row_id = 1>
</cfif>
<cfif not isdefined("is_make_age_date")>
	<cfset is_make_age_date = 0>
</cfif>
<cfif isdefined("attributes.is_make_age_date") and attributes.is_make_age_date eq 1>
	<cfset is_make_age_date = 1>
</cfif>
<cfif isdefined("attributes.is_pay_cheque") and attributes.is_pay_cheque eq 1><!--- Toplu ödeme performansından gelen parametre --->
	<cfset attributes.is_pay_cheques = 1>
</cfif>
<cfif isdefined("attributes.is_finish_day") and attributes.is_finish_day eq 1><!--- Toplu ödeme performansından gelen parametre bitis gunune gore --->
	<cfset attributes.is_finish_day = 1>
</cfif>
<cfif isdefined ('attributes.company') and len(attributes.company)>
	<cfquery name="get_periods" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			SETUP_PERIOD 
		WHERE 
			OUR_COMPANY_ID = #session_base.company_id# AND
			PERIOD_YEAR >= #dateformat(attributes.date1,'yyyy')# 
			AND PERIOD_YEAR <= #dateformat(attributes.date2,'yyyy')#
		ORDER BY 
			OUR_COMPANY_ID,
			PERIOD_YEAR 
	</cfquery> 
</cfif>
<cfif isDefined("session.pp.money")>
	<cfset session_base_money = session.pp.money>
<cfelseif isDefined("session.ww.money")>
	<cfset session_base_money = session.ww.money>
<cfelse>
	<cfset session_base_money = session.ep.money>
</cfif>
<cfif isdefined("attributes.is_ajax_popup")>
	<cfif isdefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
		<cf_date tarih = "attributes.due_date_2">
	</cfif>
	<cfif isdefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
		<cf_date tarih = "attributes.due_date_1">
	</cfif>
	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
		<cf_date tarih = "attributes.date1">
	</cfif>
	<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
		<cf_date tarih = "attributes.date2">
	</cfif>
</cfif>
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfset get_money_cmp = createObject("component","V16.objects.cfc.income_cost") />
<cfset get_money = get_money_cmp.GET_MONEY()>
<cfif isdefined ('attributes.employee_id_') and len(attributes.employee_id_)>
	<cfif listlen(attributes.employee_id_,'_') eq 2>
		<cfset attributes.employee_id = listfirst(attributes.employee_id_,'_')>
		<cfset attributes.acc_type_id = listlast(attributes.employee_id_,'_')>
	</cfif>
<cfelseif not isdefined("attributes.acc_type_id")>
	<cfset attributes.acc_type_id = "">
</cfif>
<cfset money_list = ''>
<cfset total_days_toplam = 0>
<cfset total_days = 0>
<form name="dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>" action="" method="post"></form>
<cfquery name="GET_SETUP_MONEY" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY <cfif not isDefined("attributes.is_doviz_group")>WHERE MONEY = '<cfoutput>#session_base_money#</cfoutput>'<cfelseif isdefined("attributes.other_money") and len(attributes.other_money)>WHERE MONEY = '#attributes.other_money#'</cfif>
</cfquery>
<cfif isDefined("attributes.is_doviz_group")>
	<cfset OPEN_INVOICE = QueryNew("INVOICE_NUMBER,TOTAL_SUB,TOTAL_OTHER_SUB,T_OTHER_MONEY,INVOICE_DATE,OLD_ACTION_DATE,ROW_COUNT,DUE_DATE,INV_RATE,ACTION_TYPE_ID,PROJECT_ID,CARI_ACTION_ID,ACTION_TABLE,PROCESS_CAT","VarChar,Double,Double,VarChar,Date,Date,integer,Date,Double,integer,integer,integer,VarChar,integer")>
</cfif>
<cfset open_rows_ = 0>
<cfif (isDefined("attributes.company_id") and len(attributes.company_id)) or (isDefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isdefined("attributes.employee_id") and len(attributes.employee_id))>
	<!--- Hesaplamalar --->  
	<cfif not (isdefined("attributes.detail_type") and len(attributes.detail_type) and attributes.detail_type eq 3)>
		<cfloop query="GET_SETUP_MONEY">
			<cfquery name="GET_COMP_REMAINDER" datasource="#dsn2#">
				SELECT
					ROUND(SUM(BORC-ALACAK),2) AS BAKIYE
				FROM
				(
					SELECT
					<cfif isDefined("attributes.is_doviz_group")>
						SUM(OTHER_CASH_ACT_VALUE) BORC,
					<cfelse>
						SUM(ACTION_VALUE) BORC,
					</cfif>
						0 ALACAK
					FROM
						CARI_ROWS
					WHERE
						1 = 1 AND
						<cfif isDefined("attributes.is_doviz_group")>
							ACTION_TYPE_ID NOT IN (48,49,46,45) AND
							OTHER_CASH_ACT_VALUE > 0 AND
						</cfif>
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							TO_CMP_ID = #attributes.company_id#
						<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
							TO_CONSUMER_ID = #attributes.consumer_id#
						<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
							TO_EMPLOYEE_ID = #attributes.employee_id#
						</cfif>
						<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
							AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
						</cfif>
						<cfif isDefined("attributes.is_doviz_group")>
							AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
						</cfif>
						<cfif isdefined("is_show_store_acts")> 
							<cfif is_show_store_acts eq 0>
								<cfif session.ep.isBranchAuthorization>
									AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
								</cfif>	
							</cfif>	
						<cfelse>
							<cfif session.ep.isBranchAuthorization>
								AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
						</cfif>
						<cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
							AND PROJECT_ID = #attributes.project_id#
						<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
							AND PROJECT_ID IS NULL						
						</cfif>
						<cfif isdefined("attributes.is_pay_cheques")>
							AND
							(
								(	
									CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
									AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
											AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
								OR
								(	
									CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
									AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
											AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
								OR 
								(
									CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
									AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
											AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
								OR 
								(
									CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
									AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
											AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
								OR 
								(
									CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
									AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
											AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
							)
						<cfelse>
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
									AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_pay_bankorders")>
							AND
							(
								CARI_ROWS.ACTION_TYPE_ID IN (250,251) AND CARI_ROWS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1)
								OR
								CARI_ROWS.ACTION_TYPE_ID NOT IN (250,251)
							)
						</cfif>
				UNION ALL
					SELECT
						0 BORC,
					<cfif isDefined("attributes.is_doviz_group")>
						SUM(OTHER_CASH_ACT_VALUE) ALACAK
					<cfelse>
						SUM(ACTION_VALUE) ALACAK
					</cfif>
					FROM
						CARI_ROWS
					WHERE
						1 = 1 AND
						<cfif isDefined("attributes.is_doviz_group")>
							ACTION_TYPE_ID NOT IN (48,49,46,45) AND
							OTHER_CASH_ACT_VALUE > 0 AND
						</cfif>
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							FROM_CMP_ID = #attributes.company_id#
						<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
							FROM_CONSUMER_ID = #attributes.consumer_id#
						<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
							FROM_EMPLOYEE_ID = #attributes.employee_id#
						</cfif>
						<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
							AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
						</cfif>
						<cfif isDefined("attributes.is_doviz_group")>
							AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
						</cfif>
						<cfif isdefined("is_show_store_acts")> 
							<cfif is_show_store_acts eq 0>
								<cfif session.ep.isBranchAuthorization>
									AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
								</cfif>	
							</cfif>	
						<cfelse>
							<cfif session.ep.isBranchAuthorization>
								AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
						</cfif>
						<cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
							AND PROJECT_ID = #attributes.project_id#
						<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
							AND PROJECT_ID IS NULL						
						</cfif>
						<cfif isdefined("attributes.is_pay_cheques")>
							AND
							(
								(	
									CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
									AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
											AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
								OR
								(	
									CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
									AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
											AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
								OR 
								(
									CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
									AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
											AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
								OR 
								(
									CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
									AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
											AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
								OR 
								(
									CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
									AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
									<cfif is_make_age_date>
										<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
											AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
										</cfif>
										<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
											AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
										</cfif>
									</cfif>
								)
							)
						<cfelse>
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
									AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_pay_bankorders")>
							AND
							(
								CARI_ROWS.ACTION_TYPE_ID IN (250,251) AND CARI_ROWS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1)
								OR
								CARI_ROWS.ACTION_TYPE_ID NOT IN (250,251)
							)
						</cfif>
				) AS COMP_REMAINDER
			</cfquery>
			<cfquery name="GET_REVENUE" datasource="#DSN2#">
				SELECT 
					FROM_CMP_ID,
					ACTION_VALUE AS TOTAL,
					ACTION_DATE OLD_ACTION_DATE,
					ISNULL(PAPER_ACT_DATE,ACTION_DATE) ACTION_DATE,
					<cfif isdefined("attributes.is_cheque_duedate")>
						<!--- Çek ve senetler tahsil tarihlerine göre hesaplansın seçiliyse --->
						CASE WHEN (ACTION_TABLE = 'CHEQUE') THEN 
						(
							ISNULL((SELECT ACT_DATE FROM CHEQUE_HISTORY WHERE STATUS = 3 AND CHEQUE_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CARI_ROWS.ACTION_ID)),DUE_DATE)
						)
						ELSE
						(
							CASE WHEN (ACTION_TABLE = 'VOUCHER') THEN 
								ISNULL((SELECT ACT_DATE FROM VOUCHER_HISTORY WHERE STATUS = 3 AND VOUCHER_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = CARI_ROWS.ACTION_ID)),DUE_DATE)
							ELSE
								DUE_DATE
							END
						)
						END AS DUE_DATE,
					<cfelseif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						CASE WHEN (ACTION_TYPE_ID = 241) THEN
							ACTION_DATE
						ELSE
							DUE_DATE	
						END AS DUE_DATE,
					<cfelse>
						DUE_DATE,	
					</cfif>
					ACTION_TYPE_ID,
					PROJECT_ID,
					OTHER_CASH_ACT_VALUE AS OTHER_MONEY_VALUE,
					OTHER_MONEY,
					PAPER_NO,
					CARI_ACTION_ID,
					ACTION_TABLE,
					PROCESS_CAT,
					FROM_BRANCH_ID,
					TO_BRANCH_ID
				FROM
					CARI_ROWS
				WHERE
				<cfif GET_COMP_REMAINDER.BAKIYE	gt 0>
					<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
						FROM_CMP_ID = #attributes.company_id#
					<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
						FROM_CONSUMER_ID = #attributes.consumer_id#
					<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
						FROM_EMPLOYEE_ID = #attributes.employee_id#
					</cfif>
					<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
						AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
					</cfif>
				<cfelse>
					<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
						TO_CMP_ID = #attributes.company_id#
					<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
						TO_CONSUMER_ID = #attributes.consumer_id#
					<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
						TO_EMPLOYEE_ID = #attributes.employee_id#
					</cfif>
					<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
						AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
					</cfif>
				</cfif>
				<cfif isDefined("attributes.is_doviz_group")>
					AND ACTION_TYPE_ID NOT IN (48,49,46,45) 
					AND	OTHER_CASH_ACT_VALUE > 0 
				</cfif>
				<cfif isDefined("attributes.is_doviz_group")>
					AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
				</cfif>
				<cfif isdefined("is_show_store_acts")> 
					<cfif is_show_store_acts eq 0>
						<cfif session.ep.isBranchAuthorization>
							AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>	
					</cfif>	
				<cfelse>
					<cfif session.ep.isBranchAuthorization>
						AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
					AND PROJECT_ID = #attributes.project_id#
				<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
					AND PROJECT_ID IS NULL						
				</cfif>
				<cfif isdefined("attributes.is_pay_cheques")>
					AND
					(
						(	
							CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
							AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
									AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
						OR
						(	
							CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
							AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
									AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
						OR 
						(
							CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
							AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
									AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
						OR 
						(
							CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
							AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
									AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
						OR 
						(
							CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
							AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
									AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
					)
				<cfelse>
					<cfif is_make_age_date>
						<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
							AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
						</cfif>
						<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
							AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
						</cfif>
					</cfif>
				</cfif>
				<cfif isdefined("attributes.is_pay_bankorders")>
					AND
					(
						CARI_ROWS.ACTION_TYPE_ID IN (250,251) AND CARI_ROWS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1)
						OR
						CARI_ROWS.ACTION_TYPE_ID NOT IN (250,251)
					)
				</cfif>
				ORDER BY
					<cfif isdefined("attributes.is_cheque_duedate")>
						CASE WHEN (ACTION_TABLE = 'CHEQUE') THEN 
						(
							ISNULL(ISNULL((SELECT ACT_DATE FROM CHEQUE_HISTORY WHERE STATUS = 3 AND CHEQUE_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
						)
						ELSE
						(
							CASE WHEN (ACTION_TABLE = 'VOUCHER') THEN 
								ISNULL(ISNULL((SELECT ACT_DATE FROM VOUCHER_HISTORY WHERE STATUS = 3 AND VOUCHER_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
							ELSE
								ISNULL(DUE_DATE,ACTION_DATE)
							END
						)
						END
					<cfelseif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						CASE WHEN (ACTION_TYPE_ID = 241) THEN
							ACTION_DATE
						ELSE
							ISNULL(DUE_DATE,ACTION_DATE)	
						END
					<cfelse>
						ISNULL(DUE_DATE,ACTION_DATE)
					</cfif>
			</cfquery>
			<cfquery name="get_invoice" datasource="#DSN2#">
				SELECT 
					ACTION_VALUE TOTAL,
					OTHER_CASH_ACT_VALUE OTHER_MONEY_VALUE,
					OTHER_MONEY,
					PAPER_NO INVOICE_NUMBER,
					ACTION_DATE OLD_ACTION_DATE,
					ISNULL(PAPER_ACT_DATE,ACTION_DATE) INVOICE_DATE,
					ACTION_TYPE_ID,
					PROJECT_ID,
					ACTION_NAME,
					<cfif isdefined("attributes.is_cheque_duedate")>
						<!--- Çek ve senetler tahsil tarihlerine göre hesaplansın seçiliyse --->
						CASE WHEN (ACTION_TABLE = 'CHEQUE') THEN 
						(
							ISNULL((SELECT ACT_DATE FROM CHEQUE_HISTORY WHERE STATUS = 3 AND CHEQUE_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CARI_ROWS.ACTION_ID)),DUE_DATE)
						)
						ELSE
						(
							CASE WHEN (ACTION_TABLE = 'VOUCHER') THEN 
								ISNULL((SELECT ACT_DATE FROM VOUCHER_HISTORY WHERE STATUS = 3 AND VOUCHER_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = CARI_ROWS.ACTION_ID)),DUE_DATE)
							ELSE
								DUE_DATE
							END
						)
						END AS DUE_DATE,
					<cfelseif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						CASE WHEN (ACTION_TYPE_ID = 241) THEN
							ACTION_DATE
						ELSE
							DUE_DATE	
						END AS DUE_DATE,
					<cfelse>
						DUE_DATE,	
					</cfif>
					<cfif isDefined("attributes.is_doviz_group")>
						(ACTION_VALUE/ISNULL(OTHER_CASH_ACT_VALUE,ACTION_VALUE)) INV_RATE,
					<cfelse>
						1 INV_RATE,
					</cfif>
					CARI_ACTION_ID,
					ACTION_TABLE,
					PROCESS_CAT
				FROM
					CARI_ROWS
				WHERE
					
					<cfif isDefined("attributes.is_doviz_group")>
						OTHER_CASH_ACT_VALUE > 0
						AND ACTION_TYPE_ID NOT IN (48,49,46,45) 
					<cfelse>
						ACTION_VALUE > 0
					</cfif>
				<cfif GET_COMP_REMAINDER.BAKIYE	gt 0>
					<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
						AND TO_CMP_ID = #attributes.company_id# 
					<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
						AND TO_CONSUMER_ID = #attributes.consumer_id# 
					<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
						AND TO_EMPLOYEE_ID = #attributes.employee_id# 
					</cfif>
					<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
						AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
					</cfif>
				<cfelse>
					<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
						AND FROM_CMP_ID = #attributes.company_id# 
					<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
						AND FROM_CONSUMER_ID = #attributes.consumer_id# 
					<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
						AND FROM_EMPLOYEE_ID = #attributes.employee_id# 
					</cfif>
					<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
						AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
					</cfif>
				</cfif>
				<cfif isDefined("attributes.is_doviz_group")>
					AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
				</cfif>
				<cfif isdefined("is_show_store_acts")> 
					<cfif is_show_store_acts eq 0>
						<cfif session.ep.isBranchAuthorization>
							AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>	
					</cfif>	
				<cfelse>
					<cfif session.ep.isBranchAuthorization>
						AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
					AND PROJECT_ID = #attributes.project_id#
				<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
					AND PROJECT_ID IS NULL						
				</cfif>
				<cfif isdefined("attributes.is_pay_cheques")>
					AND
					(
						(	
							CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
							AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
									AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
						OR
						(	
							CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
							AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
									AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
						OR 
						(
							CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
							AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
									AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
						OR 
						(
							CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
							AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
									AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
						OR 
						(
							CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
							AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
							<cfif is_make_age_date>
								<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
									AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
								</cfif>
								<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
									AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								</cfif>
							</cfif>
						)
					)
				<cfelse>
					<cfif is_make_age_date>
						<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
							AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
						</cfif>
						<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
							AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
						</cfif>
					</cfif>
				</cfif>
				<cfif isdefined("attributes.is_pay_bankorders")>
					AND
					(
						CARI_ROWS.ACTION_TYPE_ID IN (250,251) AND CARI_ROWS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1)
						OR
						CARI_ROWS.ACTION_TYPE_ID NOT IN (250,251)
					)
				</cfif>
				ORDER BY
					<cfif isdefined("attributes.is_cheque_duedate")>
						CASE WHEN (ACTION_TABLE = 'CHEQUE') THEN 
						(
							ISNULL(ISNULL((SELECT ACT_DATE FROM CHEQUE_HISTORY WHERE STATUS = 3 AND CHEQUE_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
						)
						ELSE
						(
							CASE WHEN (ACTION_TABLE = 'VOUCHER') THEN 
								ISNULL(ISNULL((SELECT ACT_DATE FROM VOUCHER_HISTORY WHERE STATUS = 3 AND VOUCHER_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
							ELSE
								ISNULL(DUE_DATE,ACTION_DATE)
							END
						)
						END
					<cfelseif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						CASE WHEN (ACTION_TYPE_ID = 241) THEN
							ACTION_DATE
						ELSE
							ISNULL(DUE_DATE,ACTION_DATE)	
						END 
					<cfelse>
						ISNULL(DUE_DATE,ACTION_DATE),
                        ACTION_DATE
					</cfif>
			</cfquery>
			<cfset process_cat_id_list = ''>
			<cfif isdefined('attributes.list_type') and listfind(attributes.list_type,7)>
				<cfoutput query="get_revenue">
					<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
						<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
					</cfif>
				</cfoutput>
				<cfoutput query="get_invoice">
					<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
						<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
					</cfif>
				</cfoutput>  	
				<cfif len(process_cat_id_list)>
					<cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
					<cfquery name="get_process_cat" datasource="#DSN3#">
						SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
					</cfquery>
					<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.PROCESS_CAT_ID,',')),'numeric','ASC',',')>
				</cfif>
			</cfif>
			<cfset row_of_query = 0>
			<cfset row_of_query_2 = 0>
			<cfset ALL_INVOICE = QueryNew("INVOICE_NUMBER,TOTAL_SUB,TOTAL_OTHER_SUB,T_OTHER_MONEY,INVOICE_DATE,OLD_ACTION_DATE,ROW_COUNT,DUE_DATE,INV_RATE,ACTION_TYPE_ID,PROJECT_ID,CARI_ACTION_ID,ACTION_TABLE,PROCESS_CAT","VarChar,Double,Double,VarChar,Date,Date,integer,Date,Double,integer,integer,integer,VarChar,integer")>
			<cfoutput query="get_invoice">
				<cfscript>
					tarih_inv = CreateODBCDateTime(get_invoice.INVOICE_DATE);
					total_pesin = 0;
					en_genel_toplam = 0;
					kalan_pesin = TOTAL - total_pesin;
					en_genel_toplam = en_genel_toplam + total_pesin;
					
					total_pesin = TOTAL;
					row_of_query = row_of_query + 1 ;
					QueryAddRow(ALL_INVOICE,1);
					QuerySetCell(ALL_INVOICE,"INVOICE_NUMBER","#INVOICE_NUMBER#",row_of_query);
					QuerySetCell(ALL_INVOICE,"TOTAL_SUB","#total_pesin#",row_of_query);
					QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB","#OTHER_MONEY_VALUE#",row_of_query);
					QuerySetCell(ALL_INVOICE,"T_OTHER_MONEY","#OTHER_MONEY#",row_of_query);
					QuerySetCell(ALL_INVOICE,"INVOICE_DATE","#tarih_inv#",row_of_query);
					QuerySetCell(ALL_INVOICE,"OLD_ACTION_DATE","#OLD_ACTION_DATE#",row_of_query);
					QuerySetCell(ALL_INVOICE,"ROW_COUNT","#row_of_query#",row_of_query);
					if(len(DUE_DATE))
						QuerySetCell(ALL_INVOICE,"DUE_DATE","#CreateODBCDateTime(DUE_DATE)#",row_of_query);
					else
						QuerySetCell(ALL_INVOICE,"DUE_DATE","#CreateODBCDateTime(INVOICE_DATE)#",row_of_query);
					QuerySetCell(ALL_INVOICE,"INV_RATE","#INV_RATE#",row_of_query);
					QuerySetCell(ALL_INVOICE,"ACTION_TYPE_ID","#ACTION_TYPE_ID#",row_of_query);
					QuerySetCell(ALL_INVOICE,"PROJECT_ID","#PROJECT_ID#",row_of_query);
					QuerySetCell(ALL_INVOICE,"CARI_ACTION_ID","#CARI_ACTION_ID#",row_of_query);
					QuerySetCell(ALL_INVOICE,"ACTION_TABLE","#ACTION_TABLE#",row_of_query);
					QuerySetCell(ALL_INVOICE,"PROCESS_CAT","#PROCESS_CAT#",row_of_query);
				</cfscript>
			</cfoutput>
			<!--- //Hesaplamalar --->
			<cfif GET_REVENUE.recordcount and get_invoice.recordcount>
				<cfif isDefined("attributes.is_doviz_group") and kontrol_name eq 0 and isdefined('attributes.company') and len(attributes.company)>
					<cfset kontrol_name = 1>
					<cfsavecontent variable="header_">
						<cfoutput>#attributes.company# #get_periods.period_year#</cfoutput>
					</cfsavecontent>
					<cf_medium_list_search title="#header_#" hide_images="1"></cf_medium_list_search>
				</cfif>
					<cfif not fusebox.fuseaction contains 'dsp_make_age'>
                    </cfif>
                    <cfif (isdefined("attributes.detail_type") and ((len(attributes.detail_type) and attributes.detail_type eq 1) or not len(attributes.detail_type)) or not isdefined('attributes.detail_type'))>
                        <cfsavecontent variable="title_">
                           <cfif not isdefined("attributes.is_ajax_popup")><a href="javascript:gizle_goster(make_age_<cfoutput>#currentrow#</cfoutput>_);">&raquo;</a></cfif><cfif isDefined("attributes.is_doviz_group")> <cfoutput>#GET_SETUP_MONEY.MONEY#</cfoutput><cf_get_lang dictionary_id='57777.İşlemler'><cfelse> <cfoutput><cfif isdefined ('attributes.company') and len(attributes.company)>#attributes.company# #get_periods.period_year#</cfif></cfoutput><cf_get_lang dictionary_id='57802.Ödeme Performansı'></cfif>
                        </cfsavecontent>
						<cfif isdefined("attributes.is_report") and len(attributes.is_report)>
							<table cellpadding="0" cellspacing="0" border="0" align="center" width="100%">
								<tr>
									<td>	
										<div class="pull-left font-green-sharp" style="float:left; font-size: 14px; padding: 7px;">		
											<p><cf_get_lang dictionary_id='57802.Ödeme Performansı'></p>
										</div>
									</td>
								</tr>
							</table>
						<cfelse>
                        	<cf_medium_list_search title="#title_#" hide_images="1"></cf_medium_list_search>
						</cfif>
                    </cfif>
                        <cfif fusebox.fuseaction contains 'dsp_make_age' and not isdefined("attributes.is_ajax_popup")>
						</cfif>
                       <!--- <table cellpadding="0" cellspacing="0" border="0" align="center" width="100%">--->
                            <tr <cfif not isdefined("attributes.is_ajax_popup") or (isdefined("attributes.is_ajax_popup") and isdefined("attributes.detail_type") and len(attributes.detail_type) and (attributes.detail_type eq 2 or attributes.detail_type eq 3))><cfif not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>style="display:none"</cfif></cfif> id="make_age_<cfoutput>#currentrow#</cfoutput>" class="nohover">
                                <td <cfif isdefined("attributes.is_ajax_popup")>style="border:1px solid #FFF;"</cfif>>
                                    <cf_medium_list id="make_age_#currentrow#_">
                                        <cfif (isdefined("attributes.detail_type") and ((len(attributes.detail_type) and attributes.detail_type eq 1) or not len(attributes.detail_type)) or not isdefined('attributes.detail_type'))>
                                            <thead>
                                                <tr>
                                                    <th style="width:40px;" align="center"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                                                    <th style="width:55px;" align="center"><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                                                    <th style="width:60px;"><cf_get_lang dictionary_id='57880.Belge No'></th>
                                                    <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                                                    <th style="width:85px;text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                                                    <th style="width:90px;text-align:right;"><cf_get_lang dictionary_id='57882.İşlem Tutarı'></th>
                                                    <th style="width:65px;" align="center"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                                                    <th style="width:65px;" align="center"><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                                                    <th style="width:60px;" align="center"><cf_get_lang dictionary_id='57883.Vade Farkı Gün'></th>
                                                    <th style="width:60px;" align="center"><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
                                                    <th style="width:60px;"><cf_get_lang dictionary_id='57880.Belge No'></th>
                                                    <th style="width:110px;"><cf_get_lang dictionary_id='57692.İşlem'></th>
                                                    <th style="text-align:right; width:85px;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                                                    <th style="text-align:right; width:85px;"><cf_get_lang dictionary_id='57882.İşlem Tutarı'></th>
                                                    <cfif isDefined("attributes.is_doviz_group")><th width="70" style="text-align:right;"><cf_get_lang dictionary_id='57884.Kur Farkı'></th></cfif>
                                               </tr>
                                            </thead>
                                        </cfif>
                                        <tbody>
                                            <cfset TOPLAM_VALUE = 0>
                                            <cfset TOPLAM_GUN_TUTARLARI=0>
                                            <cfset TOPLAM_AGIRLIK=0>
                                            <cfset TOPLAM_AGIRLIK_AVG=0>
                                            <cfset total_money=0>
                                            <cfset total_kur_farki=0>
                                            <cfset cari_toplam_tutar=0>
                                            <cfset cari_toplam_islem_tutar=0>
                                            <cfif GET_REVENUE.recordcount>
                                                <cfoutput query="GET_REVENUE">
                                                    <cfif isDefined("attributes.is_doviz_group")>
                                                        <cfset TOPLAM_VALUE = GET_REVENUE.OTHER_MONEY_VALUE[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
														<cfset TOPLAM_VALUE_ = GET_REVENUE.OTHER_MONEY_VALUE[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
                                                    <cfelse>
                                                        <cfset TOPLAM_VALUE = GET_REVENUE.TOTAL[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
														<cfset TOPLAM_VALUE_ = GET_REVENUE.TOTAL[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
                                                    </cfif>
                                                    <cfquery name="GET_INV_RECORD" dbtype="query">
                                                        SELECT
                                                            TOTAL_SUB,
                                                            TOTAL_OTHER_SUB,
                                                            INVOICE_NUMBER,
                                                            INVOICE_DATE,
                                                            T_OTHER_MONEY,
                                                            ROW_COUNT,
                                                            DUE_DATE,
                                                            INV_RATE,
                                                            ACTION_TYPE_ID,
                                                            PROJECT_ID,
                                                            PROCESS_CAT
                                                        FROM
                                                            ALL_INVOICE
                                                        WHERE
                                                        <cfif isDefined("attributes.is_doviz_group")>
                                                            TOTAL_OTHER_SUB IS NOT NULL AND 
                                                            TOTAL_OTHER_SUB <> 0
                                                        <cfelse>
                                                            TOTAL_SUB IS NOT NULL AND 
                                                            TOTAL_SUB <> 0
                                                        </cfif>
                                                        ORDER BY
                                                            DUE_DATE
                                                    </cfquery>
                                                    <cfif GET_INV_RECORD.recordcount>
                                                        <cfset a_index=0>
                                                        <cfloop condition="a_index lt GET_INV_RECORD.recordcount">
                                                            <cfset a_index=a_index+1>
                                                            <cfif isDefined("attributes.is_doviz_group")>
                                                                <cfset TOPLAM_VALUE_ = TOPLAM_VALUE_ - GET_INV_RECORD.TOTAL_OTHER_SUB[a_index] >
                                                            <cfelse>
                                                                <cfset TOPLAM_VALUE_ = TOPLAM_VALUE_ - GET_INV_RECORD.TOTAL_SUB[a_index] >
                                                            </cfif>
                                                            <cfif TOPLAM_VALUE_ gt 0>
															<cfelse>
                                                                <cfbreak>
                                                            </cfif>
                                                        </cfloop>
                                                    </cfif>
                                                    <cfset a_index = a_index+1>
                                                    
                                                    <cfif len(GET_REVENUE.OTHER_MONEY_VALUE[currentrow]) and GET_REVENUE.OTHER_MONEY_VALUE[currentrow] gt 0>
														<cfset kur_cari_row = wrk_round(GET_REVENUE.TOTAL[currentrow]/GET_REVENUE.OTHER_MONEY_VALUE[currentrow],4)>
                                                    <cfelse>
                                                        <cfset kur_cari_row = 0>
                                                    </cfif>
                                                    
                                                    <cfif (isdefined("attributes.detail_type") and ((len(attributes.detail_type) and attributes.detail_type eq 1) or not len(attributes.detail_type)) or not isdefined('attributes.detail_type'))>
                                                    <tr>
                                                        <td rowspan="#a_index#" width="100">#dateformat(GET_REVENUE.ACTION_DATE[currentrow],dateformat_style)#</td>
                                                        <td rowspan="#a_index#">#dateformat(GET_REVENUE.DUE_DATE[currentrow],dateformat_style)#</td>
                                                        <td rowspan="#a_index#">#PAPER_NO#</td>
                                                        <td rowspan="#a_index#">
                                                            <cfif isdefined('attributes.list_type') and listfind(attributes.list_type,7)>
                                                                <cfif listfind(process_cat_id_list,GET_REVENUE.PROCESS_CAT[currentrow],',')>
                                                                    #get_process_cat.process_cat[listfind(process_cat_id_list,GET_REVENUE.PROCESS_CAT[currentrow],',')]#
                                                                <cfelse>
                                                                    #get_process_name(GET_REVENUE.ACTION_TYPE_ID[currentrow])#
                                                                </cfif>
                                                            <cfelse>
                                                                #get_process_name(GET_REVENUE.ACTION_TYPE_ID[currentrow])#
                                                            </cfif>								
                                                        </td>
                                                        
                                                        <td rowspan="#a_index#" style="text-align:right;"><cfset cari_toplam_tutar = cari_toplam_tutar + GET_REVENUE.TOTAL[currentrow]>#TLFormat(GET_REVENUE.TOTAL[currentrow])# #session_base_money#</td>
                                                        <td rowspan="#a_index#" style="text-align:right;">
                                                            <cfif len(GET_REVENUE.OTHER_MONEY_VALUE[currentrow])>
                                                                <cfset cari_toplam_islem_tutar = cari_toplam_islem_tutar + GET_REVENUE.OTHER_MONEY_VALUE[currentrow]>
                                                            </cfif>
                                                            #TLFormat(GET_REVENUE.OTHER_MONEY_VALUE[currentrow])# #GET_REVENUE.OTHER_MONEY[currentrow]#
                                                        </td>
                                                   </cfif>
                                                        <!---<td colspan="<cfif isDefined("attributes.is_doviz_group")>9<cfelse>8</cfif>">--->
                                                            <cfquery name="GET_INV_RECORD" dbtype="query">
                                                                SELECT
                                                                    TOTAL_SUB,
                                                                    TOTAL_OTHER_SUB,
                                                                    INVOICE_NUMBER,
                                                                    INVOICE_DATE,
                                                                    T_OTHER_MONEY,
                                                                    ROW_COUNT,
                                                                    DUE_DATE,
                                                                    INV_RATE,
                                                                    ACTION_TYPE_ID,
                                                                    PROJECT_ID,
                                                                    PROCESS_CAT
                                                                FROM
                                                                    ALL_INVOICE
                                                                WHERE
                                                                <cfif isDefined("attributes.is_doviz_group")>
                                                                    TOTAL_OTHER_SUB IS NOT NULL AND 
                                                                    TOTAL_OTHER_SUB <> 0
                                                                <cfelse>
                                                                    TOTAL_SUB IS NOT NULL AND 
                                                                    TOTAL_SUB <> 0
                                                                </cfif>
                                                                ORDER BY
                                                                    DUE_DATE
                                                            </cfquery> 
															<!--- <table width="100%">sfdfd --->
                                                           		<cfif GET_INV_RECORD.recordcount>
                                                                    <cfset i_index=0>
                                                                    <cfloop condition="i_index lt GET_INV_RECORD.recordcount">
                                                                        <cfset i_index=i_index+1>
                                                                        <!--- Vade Tarihi Farkı/Gun --->
                                                                        <cfif len(GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
                                                                            <cfif GET_COMP_REMAINDER.BAKIYE	gt 0>
                                                                                <cfset GUN_FARKI = DateDiff("d",GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow],GET_INV_RECORD.DUE_DATE[i_index])>
                                                                            <cfelse>
                                                                                <cfset GUN_FARKI = DateDiff("d",GET_INV_RECORD.DUE_DATE[i_index],GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
                                                                            </cfif>
                                                                        <cfelse>
                                                                            <cfset GUN_FARKI = DateDiff("d",GET_INV_RECORD.DUE_DATE[i_index],GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow])>
                                                                        </cfif>
																		<cfif len(GET_REVENUE.TO_branch_id)  and GET_COMP_REMAINDER.BAKIYE lte 0>
																			
                                                                            <cfif len(GET_INV_RECORD.DUE_DATE[i_index])>
                                                                                <cfset GUN_FARKI_AVG = DateDiff("d",GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow],GET_INV_RECORD.DUE_DATE[i_index])>
                                                                            <cfelse>
                                                                                <cfset GUN_FARKI_AVG = DateDiff("d",GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow],GET_INV_RECORD.INVOICE_DATE[i_index])>
                                                                            </cfif>
                                                                        <cfelse>
                                                                            <cfif len(GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
                                                                                <cfset GUN_FARKI_AVG = DateDiff("d",GET_INV_RECORD.INVOICE_DATE[i_index],GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
                                                                            <cfelse>
                                                                                <cfset GUN_FARKI_AVG = DateDiff("d",GET_INV_RECORD.INVOICE_DATE[i_index],GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow])>
                                                                            </cfif>
                                                                        </cfif>
                                                                        <cfif GUN_FARKI eq 0><cfset GUN_FARKI=1></cfif>
                                                                        <cfif GUN_FARKI_AVG eq 0><cfset GUN_FARKI_AVG=1></cfif>
                                                                        <cfset TOPLAM_TEMP = TOPLAM_VALUE>
                                                                        <cfif isDefined("attributes.is_doviz_group")>
                                                                            <cfset TOPLAM_VALUE = TOPLAM_VALUE - GET_INV_RECORD.TOTAL_OTHER_SUB[i_index] >
                                                                        <cfelse>
                                                                            <cfset TOPLAM_VALUE = TOPLAM_VALUE - GET_INV_RECORD.TOTAL_SUB[i_index] >
                                                                        </cfif>
                                                                        <cfif TOPLAM_VALUE gt 0>
                                                                            <cfif isDefined("attributes.is_doviz_group")>
                                                                                <cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]>
                                                                            <cfelse>
                                                                                <cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_SUB[i_index]>
                                                                            </cfif>
                                                                        <cfelse>
                                                                            <cfif isDefined("attributes.is_doviz_group")>
                                                                                <cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]+TOPLAM_VALUE>
                                                                            <cfelse>
                                                                                <cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_SUB[i_index]+TOPLAM_VALUE>
                                                                            </cfif>
                                                                        </cfif>
                                                                        <!--- vade agirlikli ortalama toplam hesabi --->
                                                                        <cfset TOPLAM_GUN_TUTARLARI = TOPLAM_GUN_TUTARLARI + GUN_TUTARI><!--- gun tutarlari toplami --->
                                                                        <cfset TOPLAM_AGIRLIK = TOPLAM_AGIRLIK + (GUN_TUTARI*GUN_FARKI)><!--- gun agirliklari toplami --->
                                                                        <cfset TOPLAM_AGIRLIK_AVG = TOPLAM_AGIRLIK_AVG + (GUN_TUTARI*GUN_FARKI_AVG)><!--- gun agirliklari toplami --->
                                                                        <cfif (isdefined("attributes.detail_type") and ((len(attributes.detail_type) and attributes.detail_type eq 1) or not len(attributes.detail_type)) or not isdefined('attributes.detail_type'))>
                                                                            <tr>
                                                                                <td>#DateFormat(GET_INV_RECORD.INVOICE_DATE[i_index],dateformat_style)#</td>
                                                                                <td><cfif len(GET_INV_RECORD.DUE_DATE[i_index])>#DateFormat(GET_INV_RECORD.DUE_DATE[i_index],dateformat_style)#</cfif></td>
                                                                                <td style="text-align:center;">#GUN_FARKI#</td>
                                                                                <td style="text-align:center;">#GUN_FARKI_AVG#</td>
                                                                                <td>#GET_INV_RECORD.INVOICE_NUMBER[i_index]#</td>
                                                                                <td>
                                                                                    <cfif isdefined('attributes.list_type') and listfind(attributes.list_type,7)>
                                                                                        <cfif listfind(process_cat_id_list,GET_INV_RECORD.PROCESS_CAT[i_index],',')>
                                                                                            #get_process_cat.process_cat[listfind(process_cat_id_list,GET_INV_RECORD.PROCESS_CAT[i_index],',')]#
                                                                                        <cfelse>
                                                                                            #get_process_name(GET_INV_RECORD.ACTION_TYPE_ID[i_index])#
                                                                                        </cfif>
                                                                                    <cfelse>
                                                                                        #get_process_name(GET_INV_RECORD.ACTION_TYPE_ID[i_index])#
                                                                                    </cfif>	
                                                                                </td>
                                                                                <cfif isDefined("attributes.is_doviz_group")>
                                                                                    <cfif len(GET_INV_RECORD.INV_RATE[i_index]) and GET_INV_RECORD.INV_RATE[i_index] gt 0 and GUN_TUTARI gt 0>
                                                                                        <cfset kur_inv = wrk_round(GUN_TUTARI/(GUN_TUTARI/GET_INV_RECORD.INV_RATE[i_index]),4)>
                                                                                    <cfelse>
                                                                                        <cfset kur_inv = 1>
                                                                                    </cfif>
                                                                                </cfif>
                                                                                <td style="text-align:right;">
                                                                                    <cfif isDefined("attributes.is_doviz_group") and len(GET_INV_RECORD.INV_RATE[i_index])>
                                                                                        #TLFormat(GUN_TUTARI*GET_INV_RECORD.INV_RATE[i_index])# #session_base_money#
                                                                                        <cfset total_money = total_money + wrk_round(GUN_TUTARI*GET_INV_RECORD.INV_RATE[i_index])>
                                                                                    <cfelse>
                                                                                        #TLFormat(GUN_TUTARI)# #session_base_money#
                                                                                    </cfif>
                                                                                </td>
                                                                                <td style="text-align:right;">
                                                                                    <cfif isDefined("attributes.is_doviz_group") and len(GET_INV_RECORD.INV_RATE[i_index])>
                                                                                        #TLFormat(GUN_TUTARI)# #GET_INV_RECORD.T_OTHER_MONEY[i_index]#
                                                                                    <cfelse>
                                                                                        #TLFormat(GUN_TUTARI/GET_INV_RECORD.INV_RATE[i_index])# #GET_INV_RECORD.T_OTHER_MONEY[i_index]#
                                                                                    </cfif>
                                                                                </td>
                                                                                <cfif isDefined("attributes.is_doviz_group")>
                                                                                    <td style="text-align:right;">
                                                                                        <cfif len(GET_REVENUE.FROM_CMP_ID)>
                                                                                            <cfset ara_kur_farki = (kur_cari_row - kur_inv)>
                                                                                        <cfelse>
                                                                                            <cfset ara_kur_farki = (kur_inv - kur_cari_row)>
                                                                                        </cfif>
                                                                                        <cfset total_kur_farki = total_kur_farki + wrk_round(GUN_TUTARI * ara_kur_farki)>
                                                                                        #TLFormat(GUN_TUTARI * ara_kur_farki)#
                                                                                    </td>
                                                                                </cfif>
                                                                            </tr>
                                                                        </cfif>
                                                                        <cfif TOPLAM_VALUE gt 0>
                                                                            <cfif isDefined("attributes.is_doviz_group")>
                                                                                <cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
                                                                            <cfelse>
                                                                                <cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
                                                                            </cfif>
                                                                        <cfelse>
                                                                            <cfif isDefined("attributes.is_doviz_group")>
                                                                                <cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]-TOPLAM_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
                                                                            <cfelse>
                                                                                <cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",GET_INV_RECORD.TOTAL_SUB[i_index]-TOPLAM_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
                                                                            </cfif>
                                                                            <cfbreak>
                                                                        </cfif>
                                                                    </cfloop>
																<cfelse>
																	&nbsp;
																</cfif>
															<!--- </table> --->
                                                		</td>
                                        			</tr>
                                                </cfoutput>
                                        	</cfif>
                                        </tbody>
                                        <cfif (isdefined("attributes.detail_type") and ((len(attributes.detail_type) and attributes.detail_type eq 1) or not len(attributes.detail_type)) or not isdefined('attributes.detail_type'))>
	                                        <tfoot>
                                            <tr>
                                                <td class="txtbold" colspan="4"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                                <cfoutput>
                                                    <td  nowrap style="text-align:right;" class="txtbold">#TLFormat(cari_toplam_tutar)# #session_base_money#</td>
                                                    <cfif isDefined("attributes.is_doviz_group")>
                                                        <td  nowrap style="text-align:right;" class="txtbold">#TLFormat(cari_toplam_islem_tutar)# #GET_SETUP_MONEY.MONEY#</td>
                                                    </cfif>
                                                    <td colspan="2">&nbsp;</td> 
                                                    <cfif not isDefined("attributes.is_doviz_group")><td></td></cfif>
                                                    <td style="text-align:center" class="txtbold">
														<cfif TOPLAM_GUN_TUTARLARI neq 0>
															#TLFormat(TOPLAM_AGIRLIK/TOPLAM_GUN_TUTARLARI)#
															<cfset total_days = (TOPLAM_AGIRLIK/TOPLAM_GUN_TUTARLARI)*cari_toplam_tutar>
															<cfset total_days_toplam =  cari_toplam_tutar>
															&nbsp;(#dateformat(dateadd('d',-1 * ceiling(TOPLAM_AGIRLIK/TOPLAM_GUN_TUTARLARI),now()),dateformat_style)#)
														<cfelse>
															<cfset total_days = 0><cfset total_days_toplam =  0>
														</cfif>
														
                                                    </td>
                                                    <td style="text-align:center" class="txtbold">
														<cfif TOPLAM_GUN_TUTARLARI neq 0>
															#TLFormat(TOPLAM_AGIRLIK_AVG/TOPLAM_GUN_TUTARLARI)#
															&nbsp;(#dateformat(dateadd('d',-1 * ceiling(TOPLAM_AGIRLIK_AVG/TOPLAM_GUN_TUTARLARI),now()),dateformat_style)#)
														</cfif>
															
                                                    </td>
                                                    <td colspan="2">&nbsp;</td> 
                                                    <td width="85" nowrap="nowrap" style="text-align:right;" class="txtbold">&nbsp;<cfif GET_REVENUE.RECORDCOUNT><cfif isDefined("attributes.is_doviz_group")>#TLFormat(total_money)# #session_base_money#<cfelse>#TLFormat(wrk_round(TOPLAM_GUN_TUTARLARI))# #session_base_money#</cfif></cfif></td>
                                                    <td width="85" nowrap="nowrap" style="text-align:right;" class="txtbold"><cfif isDefined("attributes.is_doviz_group")>#TLFormat(wrk_round(TOPLAM_GUN_TUTARLARI))# #GET_SETUP_MONEY.MONEY#</cfif></td>
                                                    <cfif isDefined("attributes.is_doviz_group")><td width="60" nowrap="nowrap" style="text-align:right;" class="txtbold">#TLFormat(total_kur_farki)#</td></cfif>
                                                </cfoutput>
                                            </tr>
                                        </tfoot>
                                        </cfif>
                                    </cf_medium_list>
                                </td>
                            </tr>
                        <!---</table>--->
					   <cfif fusebox.fuseaction contains 'dsp_make_age' and not isdefined("attributes.is_ajax_popup")>
						</cfif>
                    <br />
					<cfif isDefined("attributes.is_doviz_group")>
						 <cf_medium_list>
                            <cfquery name="GET_RATE_DIFF_INV_1" datasource="#dsn2#"><!--- Alınan Kur Farkları --->
                                SELECT
                                    ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE
                                FROM
                                    CARI_ROWS
                                WHERE
                                    <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                                        FROM_CMP_ID = #attributes.company_id# AND
                                    <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                        FROM_CONSUMER_ID = #attributes.consumer_id# AND
                                    <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                                        FROM_EMPLOYEE_ID = #attributes.employee_id# AND
                                    </cfif>
                                    <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                                        ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
                                    </cfif>
                                    ACTION_TYPE_ID = 49 AND
                                    OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
                                    <cfif isdefined("is_show_store_acts")> 
										<cfif is_show_store_acts eq 0>
											<cfif session.ep.isBranchAuthorization>
												AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
											</cfif>	
										</cfif>	
									<cfelse>
										<cfif session.ep.isBranchAuthorization>
											AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
										</cfif>
									</cfif>
                                    <cfif isdefined('attributes.project_id') and  isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                                        AND PROJECT_ID = #attributes.project_id#
                                    <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup")>
                                        AND PROJECT_ID IS NULL						
                                    </cfif>
                            </cfquery>
                            <cfquery name="GET_RATE_DIFF_INV_2" datasource="#dsn2#"><!--- Verilen Kur Farkları --->
                                SELECT
                                    ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE
                                FROM
                                    CARI_ROWS
                                WHERE
                                    <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                                        TO_CMP_ID = #attributes.company_id# AND
                                    <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                        TO_CONSUMER_ID = #attributes.consumer_id# AND
                                    <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                                        TO_EMPLOYEE_ID = #attributes.employee_id# AND
                                    </cfif>
                                    <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                                        ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
                                    </cfif>
                                    ACTION_TYPE_ID =48 AND
                                    OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
                                    <cfif isdefined("is_show_store_acts")> 
										<cfif is_show_store_acts eq 0>
											<cfif session.ep.isBranchAuthorization>
												AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
											</cfif>	
										</cfif>	
									<cfelse>
										<cfif session.ep.isBranchAuthorization>
											AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
										</cfif>
									</cfif>
                                    <cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                                        AND PROJECT_ID = #attributes.project_id#
                                    <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup")>
                                        AND PROJECT_ID IS NULL						
                                    </cfif>
							</cfquery>
							<cfquery name="GET_RATE_DIFF_INV_2_IPTAL" datasource="#dsn2#">
								SELECT
                                    ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE
                                FROM
                                    CARI_ROWS
                                WHERE
                                    <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                                        FROM_CMP_ID = #attributes.company_id# AND
                                    <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
										FROM_CONSUMER_ID = #attributes.consumer_id# AND
                                    <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
										FROM_EMPLOYEE_ID = #attributes.employee_id# AND
                                    </cfif>
                                    <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                                        ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
                                    </cfif>
                                    ACTION_TYPE_ID =48 AND
                                    OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
                                    <cfif isdefined("is_show_store_acts")> 
										<cfif is_show_store_acts eq 0>
											<cfif session.ep.isBranchAuthorization>
												AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
											</cfif>	
										</cfif>	
									<cfelse>
										<cfif session.ep.isBranchAuthorization>
											AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
										</cfif>
									</cfif>
                                    <cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                                        AND PROJECT_ID = #attributes.project_id#
                                    <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup")>
                                        AND PROJECT_ID IS NULL						
									</cfif>
										AND IS_CANCEL = 1
							</cfquery>
                            <cfquery name="GET_RATE_DIFF_DEKONT_1" datasource="#dsn2#"><!--- Alacak değerleme --->
                                SELECT
                                    ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE
                                FROM
                                    CARI_ACTIONS
                                WHERE
                                    <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                                        FROM_CMP_ID = #attributes.company_id# AND
                                    <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                        FROM_CONSUMER_ID = #attributes.consumer_id# AND
                                    <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                                        FROM_EMPLOYEE_ID = #attributes.employee_id# AND
                                    </cfif>
                                    <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                                        ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
                                    </cfif>
                                    ACTION_TYPE_ID = 46 AND
                                    OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
                                    <cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                                        AND PROJECT_ID = #attributes.project_id#
                                    <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup")>
                                        AND PROJECT_ID IS NULL						
                                    </cfif>
                            </cfquery>
                            <cfquery name="GET_RATE_DIFF_DEKONT_2" datasource="#dsn2#"><!--- Borç değerleme --->
                                SELECT
                                    ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE
                                FROM
                                    CARI_ACTIONS
                                WHERE
                                    <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                                        TO_CMP_ID = #attributes.company_id# AND
                                    <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                        TO_CONSUMER_ID = #attributes.consumer_id# AND
                                    <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                                        TO_EMPLOYEE_ID = #attributes.employee_id# AND
                                    </cfif>
                                    <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                                        ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
                                    </cfif>
                                    ACTION_TYPE_ID = 45 AND
                                    OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
                                    <cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                                        AND PROJECT_ID = #attributes.project_id#
                                    <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup")>
                                        AND PROJECT_ID IS NULL						
                                    </cfif>
                            </cfquery>
                            <cfoutput>	
                            	<thead>					
                                    <tr>
                                        <th colspan="3" class="txtbold" nowrap="nowrap"><cf_get_lang dictionary_id='57885.Otomatik Kapama Sonucu Oluşan'> #GET_SETUP_MONEY.MONEY# <cf_get_lang dictionary_id='57886.İşlem Toplamları ve Kur Farkı'></th>
                                    </tr>
                                </thead>
                                <cfif isDefined("attributes.is_doviz_group")>
                                <tr>
                                    <td>#GET_SETUP_MONEY.MONEY# <cf_get_lang dictionary_id='57673.Tutar'></td>
                                    <td width="85" nowrap style="text-align:right;">#TLFormat(cari_toplam_islem_tutar)# #GET_SETUP_MONEY.MONEY#</td>
                                    <td width="85" nowrap style="text-align:right;">#TLFormat(wrk_round(TOPLAM_GUN_TUTARLARI))# #GET_SETUP_MONEY.MONEY#</td>

                                </cfif>
                                <tr>
                                    <td nowrap="nowrap">#session_base_money# <cf_get_lang dictionary_id='57673.Tutar'></td>
                                    <td nowrap style="text-align:right;" >#TLFormat(cari_toplam_tutar)# #session_base_money#</td>
                                    <td nowrap style="text-align:right;" >&nbsp;<cfif GET_REVENUE.RECORDCOUNT><cfif isDefined("attributes.is_doviz_group")>#TLFormat(total_money)# #session_base_money#<cfelse>#TLFormat(wrk_round(TOPLAM_GUN_TUTARLARI))# #session_base_money#</cfif></cfif></td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap"><cf_get_lang dictionary_id='58912.Alınan Kur Farkı Faturaları Toplamı'></td>
                                    <td></td>
                                    <td style="text-align:right;">#TLFormat(GET_RATE_DIFF_INV_1.ACTION_VALUE)#</td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap"><cf_get_lang dictionary_id='58913.Verilen Kur Farkı Faturaları Toplamı'></td>
                                    <td></td>
									<td style="text-align:right;">
										<cfset TOP_GET_RATE_DIFF_INV_2 = GET_RATE_DIFF_INV_2.ACTION_VALUE - GET_RATE_DIFF_INV_2_IPTAL.ACTION_VALUE>
                                        #TLFormat(TOP_GET_RATE_DIFF_INV_2)#
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap"><cf_get_lang dictionary_id='58914.Alacak Kur Değerleme Dekontları Toplamı'></td>
                                    <td></td>
                                    <td style="text-align:right;">
                                        #TLFormat(GET_RATE_DIFF_DEKONT_1.ACTION_VALUE)#
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap"><cf_get_lang dictionary_id='58915.Borç Kur Değerleme Dekontları Toplamı'></td>
                                    <td></td>
                                    <td style="text-align:right;">
                                        #TLFormat(GET_RATE_DIFF_DEKONT_2.ACTION_VALUE)#
                                    </td>
                                </tr>
                                <cfset total_diff_1 = GET_RATE_DIFF_INV_1.ACTION_VALUE + GET_RATE_DIFF_DEKONT_1.ACTION_VALUE><!--- alınan kur farkı toplam --->
                                <cfset total_diff_2 = TOP_GET_RATE_DIFF_INV_2 + TOP_GET_RATE_DIFF_INV_2><!--- verilen kur farkı toplam --->
                                <cfif total_kur_farki gt 0>
                                    <cfset new_diff = total_kur_farki - (total_diff_2-total_diff_1)>
                                <cfelseif total_kur_farki lte 0>
                                    <cfset new_diff = total_kur_farki + (total_diff_1 - total_diff_2)>
                                <cfelse>
                                    <cfset new_diff = 0>
                                </cfif>
                                <cfif new_diff gt 0>
                                    <tr>
                                        <td><cf_get_lang dictionary_id='57888.Kesilmesi Gereken Kur Farkı Fatura Tutarı'></td>
                                        <td></td>
                                        <td style="text-align:right;">#TLFormat(new_diff)#</td>
                                        <cfset function_info1 = "add_bill_sale_#attributes.row_id#">
                                    </tr>
                                    <tfoot>
                                    	<tr>
                                        	<td colspan="3"><cfif not (isDefined("session.pp") or isDefined("session.ww")) and new_diff neq 0><cfif not isdefined("attributes.is_excel")><cf_workcube_buttons is_upd='0' insert_info='Kur Farkı Faturası Kes' is_cancel='0' add_function='#function_info1#()' type_format="1"></cfif></cfif></td>
                                       </tr>
                                    </tfoot>
                                <cfelseif new_diff lt 0>
                                    <tr>
                                        <td><cf_get_lang dictionary_id='57889.Alınması Gereken Kur Farkı Fatura Tutarı'></td>
                                        <td></td>
                                        <td style="text-align:right;">#TLFormat(new_diff)#</td>
                                        <cfset function_info2 = "add_bill_purch_#attributes.row_id#">
                                    </tr>
                                    <tfoot>
                                    	<tr>
                                        	<td colspan="3">
												<cfif not (isDefined("session.pp") or isDefined("session.ww")) and new_diff neq 0><cfif not isdefined("attributes.is_excel")><cf_workcube_buttons is_upd='0' insert_info='Kur Farkı Faturası Kes' is_cancel='0' add_function='#function_info2#()' type_format="1"></cfif></cfif>
                                            </td>
                                       </tr>
                                    </tfoot>
                                </cfif>
                            </cfoutput>
                        </cf_medium_list>
					</cfif>
			</cfif>
			<cfif isDefined("attributes.is_doviz_group")>
				<cfif isdefined("ALL_INVOICE") and ALL_INVOICE.recordcount>
					<cfoutput query="ALL_INVOICE">
						<cfset open_rows_ = open_rows_ + 1> 
						<cfscript>
							QueryAddRow(OPEN_INVOICE,1);
							QuerySetCell(OPEN_INVOICE,"INVOICE_NUMBER","#INVOICE_NUMBER#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"TOTAL_SUB","#TOTAL_SUB#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"TOTAL_OTHER_SUB","#wrk_round(TOTAL_OTHER_SUB)#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"T_OTHER_MONEY","#T_OTHER_MONEY#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"INVOICE_DATE","#INVOICE_DATE#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"OLD_ACTION_DATE","#OLD_ACTION_DATE#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"ROW_COUNT","#open_rows_#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"DUE_DATE","#DUE_DATE#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"INV_RATE","#INV_RATE#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"ACTION_TYPE_ID","#ACTION_TYPE_ID#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"PROJECT_ID","#PROJECT_ID#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"CARI_ACTION_ID","#CARI_ACTION_ID#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"ACTION_TABLE","#ACTION_TABLE#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"PROCESS_CAT","#PROCESS_CAT#",open_rows_);
						</cfscript>
					</cfoutput>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.detail_type") and len(attributes.detail_type) and attributes.detail_type eq 3>
		<cfquery name="GET_INV_RECORD" datasource="#dsn2#">
			SELECT 
				ACTION_VALUE TOTAL_SUB,
				OTHER_CASH_ACT_VALUE TOTAL_OTHER_SUB,
				OTHER_MONEY T_OTHER_MONEY,
				PAPER_NO INVOICE_NUMBER,
				ACTION_DATE INVOICE_DATE,
				DUE_DATE,
				<cfif isDefined("attributes.is_doviz_group")>
					(ACTION_VALUE/ISNULL(OTHER_CASH_ACT_VALUE,ACTION_VALUE)) INV_RATE,
				</cfif>
				ACTION_TYPE_ID,
				PROJECT_ID,
				CARI_ACTION_ID,
				PROCESS_CAT
			FROM
				CARI_ROWS
			WHERE
				<cfif isDefined("attributes.is_doviz_group")>
					OTHER_CASH_ACT_VALUE > 0
					AND ACTION_TYPE_ID NOT IN (48,49,46,45) 
				<cfelse>
					ACTION_VALUE > 0
				</cfif>
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
					AND FROM_CMP_ID = #attributes.company_id# 
				<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
					AND FROM_CONSUMER_ID = #attributes.consumer_id# 
				<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
					AND FROM_EMPLOYEE_ID = #attributes.employee_id# 
				</cfif>
				<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
					AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
				</cfif>
				<cfif isDefined("attributes.is_doviz_group")>
					AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
				</cfif>
				<cfif isdefined("is_show_store_acts") and is_show_store_acts eq 0>
					<cfif session.ep.isBranchAuthorization>
						AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
					</cfif>	
				<cfelse>
					<cfif session.ep.isBranchAuthorization>
						AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
					AND PROJECT_ID = #attributes.project_id#
				<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
					AND PROJECT_ID IS NULL						
				</cfif>
				<cfif isdefined("attributes.is_pay_cheques")>
					AND
					(
					(CARI_ROWS.ACTION_TABLE = 'CHEQUE' AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND (CHEQUE_STATUS_ID IN (3,7) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">))))
					OR	
					(CARI_ROWS.ACTION_TABLE = 'PAYROLL' AND CARI_ROWS.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM CHEQUE C,CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND  (C.CHEQUE_STATUS_ID IN (3,7) OR (C.CHEQUE_STATUS_ID = 4 AND C.CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">))))
					OR 
					(CARI_ROWS.ACTION_TABLE = 'VOUCHER' AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND (VOUCHER_STATUS_ID IN (3,7) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">))))
					OR	
					(CARI_ROWS.ACTION_TABLE = 'VOUCHER_PAYROLL' AND CARI_ROWS.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM VOUCHER V,VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND  (V.VOUCHER_STATUS_ID IN (3,7) OR( V.VOUCHER_STATUS_ID = 4 AND V.VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">))))
					OR 
					(CARI_ROWS.ACTION_TABLE <> 'PAYROLL' AND CARI_ROWS.ACTION_TABLE <> 'CHEQUE' AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER_PAYROLL')
					)			
				</cfif>
				<cfif isdefined("attributes.is_pay_bankorders")>
					AND
					(
						CARI_ROWS.ACTION_TYPE_ID IN (250,251) AND CARI_ROWS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1)
						OR
						CARI_ROWS.ACTION_TYPE_ID NOT IN (250,251)
					)
				</cfif>
			ORDER BY
				<cfif isdefined("attributes.is_cheque_duedate")>
					CASE WHEN (ACTION_TABLE = 'CHEQUE') THEN 
					(
						ISNULL(ISNULL((SELECT ACT_DATE FROM CHEQUE_HISTORY WHERE STATUS = 3 AND CHEQUE_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
					)
					ELSE
					(
						CASE WHEN (ACTION_TABLE = 'VOUCHER') THEN 
							ISNULL(ISNULL((SELECT ACT_DATE FROM VOUCHER_HISTORY WHERE STATUS = 3 AND VOUCHER_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
						ELSE
							ISNULL(DUE_DATE,ACTION_DATE)
						END
					)
					END
				<cfelseif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
					CASE WHEN (ACTION_TYPE_ID = 241) THEN
						ACTION_DATE
					ELSE
						ISNULL(DUE_DATE,ACTION_DATE)	
					END 
				<cfelse>
					ISNULL(DUE_DATE,ACTION_DATE)
				</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="GET_INV_RECORD" dbtype="query">
			SELECT
				TOTAL_SUB,
				TOTAL_OTHER_SUB,
				T_OTHER_MONEY,
				INVOICE_NUMBER,
				INVOICE_DATE,
				ROW_COUNT,
				DUE_DATE,
				INV_RATE,
				ACTION_TYPE_ID,
				PROJECT_ID,
				CARI_ACTION_ID,
				PROCESS_CAT
			FROM
			<cfif isDefined("attributes.is_doviz_group")>
				OPEN_INVOICE
			<cfelse>
				ALL_INVOICE
			</cfif>
			WHERE
			<cfif isDefined("attributes.is_doviz_group")>
				TOTAL_OTHER_SUB IS NOT NULL AND 
				TOTAL_OTHER_SUB <> 0
			<cfelse>
				TOTAL_SUB IS NOT NULL AND 
				TOTAL_SUB <> 0
			</cfif>
			<cfif isDefined("attributes.due_date_2") and isdate(attributes.due_date_2) and isDefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
				AND DUE_DATE BETWEEN #attributes.due_date_1# AND #attributes.due_date_2#
			<cfelseif isDefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
				AND DUE_DATE >= #attributes.due_date_1#
			<cfelseif isDefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
				AND DUE_DATE <= #attributes.due_date_2#
			</cfif>
			<cfif isDefined("attributes.action_date_1") and isdate(attributes.action_date_1) and isDefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
				AND OLD_ACTION_DATE BETWEEN #attributes.action_date_1# AND #attributes.action_date_2#
			<cfelseif isDefined("attributes.action_date_1") and isdate(attributes.action_date_1)>
				AND OLD_ACTION_DATE >= #attributes.action_date_1#
			<cfelseif isDefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
				AND OLD_ACTION_DATE <= #attributes.action_date_2#
			<cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
				AND OLD_ACTION_DATE BETWEEN #createodbcdatetime(attributes.date1)# AND #createodbcdatetime(attributes.date2)#
			<cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isDefined("attributes.date1") and isdate(attributes.date1)>
				AND OLD_ACTION_DATE >= #createodbcdatetime(attributes.date1)#	
			<cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isDefined("attributes.date2") and isdate(attributes.date2)>
				AND OLD_ACTION_DATE <= #createodbcdatetime(attributes.date2)#			
			</cfif>
			<cfif isDefined("attributes.other_money_2") and len(attributes.other_money_2)>
				AND T_OTHER_MONEY = '#attributes.other_money_2#'
			</cfif>
			ORDER BY
				DUE_DATE
		</cfquery>	
	</cfif>
	<cfset process_cat_id_list_2 = ''>
	<cfif isdefined('attributes.list_type') and listfind(attributes.list_type,7)>
		<cfoutput query="GET_INV_RECORD">
			<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list_2,process_cat)>
				<cfset process_cat_id_list_2 = Listappend(process_cat_id_list_2,process_cat)>
			</cfif>
		</cfoutput>
		<cfif len(process_cat_id_list_2)>
			<cfset process_cat_id_list_2=listsort(process_cat_id_list_2,"numeric","ASC",",")>			
			<cfquery name="get_process_cat_2" datasource="#DSN3#">
				SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list_2#) ORDER BY PROCESS_CAT_ID
			</cfquery>
			<cfset process_cat_id_list_2 = listsort(listdeleteduplicates(valuelist(get_process_cat_2.PROCESS_CAT_ID,',')),'numeric','ASC',',')>
		</cfif>
	</cfif>
    <cfsavecontent variable="titile_">
            <cfif not isdefined("attributes.is_ajax_popup")><a href="javascript:gizle_goster(open_invoice_1);">&raquo;</a></cfif>
            <cfif not(GET_INV_RECORD.recordcount)>
                <cfif isdefined('attributes.company') and len(attributes.company)><cfoutput>#attributes.company# #get_periods.period_year#</cfoutput></cfif>
            </cfif>
            <cf_get_lang dictionary_id='57890.Açık İşlemler'>
    </cfsavecontent>
			<cfif isdefined("attributes.is_report") and len(attributes.is_report)>
				<table cellpadding="0" cellspacing="0" border="0" align="center" width="100%">
					<tr>
						<td>	
							<div class="pull-left font-green-sharp" style="float:left; font-size: 14px; padding: 7px;">
								<p><cf_get_lang dictionary_id='57890.Açık İşlemler'></p>
							</div>
						</td>
					</tr>
				</table>
			<cfelse>
				<cf_medium_list_search title="#titile_#" hide_images="1"></cf_medium_list_search>
			</cfif>
    <cfif fusebox.fuseaction contains 'dsp_make_age' and not isdefined("attributes.is_ajax_popup")>
    </cfif>
    <cfif not (isdefined("attributes.detail_type") and len(attributes.detail_type)) or attributes.detail_type eq 2 or attributes.detail_type eq 3>
        <cf_medium_list_search_area>
            <div id="noShow1">
                <cfif not isdefined("attributes.is_ajax_popup")></cfif>
                <!--- vade tarihine gore --->
                <cfset acik_fat_toplam_agirlik = 0>
                <cfset acik_fat_toplam = 0>
                <cfset acik_fat_toplam_agirlik_old = 0>
                <cfset acik_fat_toplam_old = 0>
                <!--- islem tarihine gore --->
                <cfset islem_tar_acik_fat_toplam_agirlik = 0>
                <cfset islem_tar_acik_fat_toplam = 0>
                <cfset islem_tar_acik_fat_toplam_agirlik_old = 0>
                <cfset islem_tar_acik_fat_toplam_old = 0>
                <cfif not isdefined("attributes.is_ajax_popup")></cfif>
                <cfif not isdefined("attributes.is_ajax_popup") and not isdefined("attributes.is_excel")>
                    <div class="row">
						<div class="form-inline col col-12 col-md-12 col-xs-12">
							<div class="form-group x-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></cfsavecontent>
									<input type="text" name="ic_action_date_1" placeholder="<cfoutput>#message#</cfoutput>" id="ic_action_date_1" value="<cfif isDefined("attributes.action_date_1") and isdate(attributes.action_date_1)><cfoutput>#dateformat(attributes.action_date_1,dateformat_style)#</cfoutput><cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isdefined("date1")><cfoutput>#date1#</cfoutput></cfif>" validate="eurodate" style="width:65px;">
									<span class="input-group-addon" title="<cfoutput>#message#</cfoutput>"><cf_wrk_date_image date_field="ic_action_date_1"></span>
								</div>
							</div>
							<div class="form-group x-12">
								<div class="input-group">
									<input type="text" name="ic_action_date_2" placeholder="<cfoutput>#message#</cfoutput>" id="ic_action_date_2" value="<cfif isDefined("attributes.action_date_2") and isdate(attributes.action_date_2)><cfoutput>#dateformat(attributes.action_date_2,dateformat_style)#</cfoutput><cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isdefined("date2")><cfoutput>#date2#</cfoutput></cfif>" validate="eurodate" style="width:65px;">
									<span class="input-group-addon" title="<cfoutput>#message#</cfoutput>"><cf_wrk_date_image date_field="ic_action_date_2"></span>
								</div>
							</div>
							<div class="form-group x-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57881.Vade Tarihi'></cfsavecontent>
									<input type="text" name="ic_due_date_1" id="ic_due_date_1" placeholder="<cfoutput>#message#</cfoutput>" value="<cfif isDefined("attributes.due_date_1") and isdate(attributes.due_date_1)><cfoutput>#dateformat(attributes.due_date_1,dateformat_style)#</cfoutput></cfif>" validate="eurodate" style="width:65px;">
									<span class="input-group-addon" title="<cfoutput>#message#</cfoutput>"><cf_wrk_date_image date_field="ic_due_date_1"></span>
								</div>
							</div>
							<div class="form-group x-12">
								<div class="input-group">
									<input type="text" name="ic_due_date_2" id="ic_due_date_2" placeholder="<cfoutput>#message#</cfoutput>" value="<cfif isDefined("attributes.due_date_2") and isdate(attributes.due_date_2)><cfoutput>#dateformat(attributes.due_date_2,dateformat_style)#</cfoutput></cfif>" validate="eurodate" style="width:65px;">
									<span class="input-group-addon" title="<cfoutput>#message#</cfoutput>"><cf_wrk_date_image date_field="ic_due_date_2"></span>
								</div>
							</div>	
							<div class="form-group x-14">
									<select name="ic_other_money_2" id="ic_other_money_2" style="width:65px;">
									<option value=""><cf_get_lang dictionary_id='57489.Para Birimi'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_money">
										<option value="#money#" <cfif isdefined("attributes.other_money_2") and attributes.other_money_2 eq money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</div>
							<div class="form-group x-22">
								<input type="checkbox" value="1"  name="ic_is_date_filter" id="ic_is_date_filter" style="vertical-align:bottom;" <cfif isDefined("attributes.is_date_filter") and attributes.is_date_filter eq 1>checked</cfif>><cf_get_lang dictionary_id ='58737.Vade Gününü Girilen Tarihten Hesapla'>
							</div>
							<div class="form-group">
								<cf_wrk_search_button search_function = 'gonder_ic_form()'>
							</div>
						</div>
                    </div>
                </cfif>
            </div>
        </cf_medium_list_search_area>
    <cf_medium_list id="open_invoice_1">
    <cfif GET_INV_RECORD.recordcount>
            <thead>
                 <tr>
                    <th nowrap="nowrap" width="100"><cf_get_lang dictionary_id='57880.Belge No'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='57416.Proje'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='57692.İşlem'></th>
                    <th width="150"><cf_get_lang dictionary_id='29689.Islem Tarihi Farkı Gün'></th>
                    <th width="150"><cf_get_lang dictionary_id='29690.Vade Tarihi Farkı Gün'></th>
                    <th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <cfif isDefined("attributes.is_doviz_group")>
						<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57795.İşlem Dövizli'></th>
						<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></th>
					</cfif>
                    <cfif isDefined("add_bank_order") and add_bank_order and isdefined("company_id")><th>&nbsp;</th></cfif>
                </tr>
            </thead>
            <tbody>
                <cfset project_name_list = "">
                <cfoutput query="GET_INV_RECORD">
                    <cfif len(project_id) and not listfind(project_name_list,project_id)>
                        <cfset project_name_list=listappend(project_name_list,project_id)>
                    </cfif>
                </cfoutput>
                <cfif len(project_name_list)>
                    <cfquery name="get_project_name" datasource="#dsn#">
                        SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
                    </cfquery>
                    <cfset project_name_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfoutput query="GET_INV_RECORD">
                    <cfif isDefined("attributes.is_doviz_group")>
                        <cfset KONTROL_VALUE = GET_INV_RECORD.TOTAL_OTHER_SUB>
                    <cfelse>
                        <cfset KONTROL_VALUE = GET_INV_RECORD.TOTAL_SUB>
                    </cfif>
                    <cfif wrk_round(KONTROL_VALUE) neq 0>
                        <!--- Vade Tarihi Farki/Gun --->
                        <cfif len(GET_INV_RECORD.DUE_DATE)>
                            <cfif isDefined("attributes.is_date_filter") and attributes.is_date_filter eq 1 and len(attributes.due_date_2)>
                                <cfset GUN_FARKI = DateDiff("d",DUE_DATE,createodbcdatetime('#year(attributes.due_date_2)#-#month(attributes.due_date_2)#-#day(attributes.due_date_2)#'))>
                            <cfelseif isDefined("attributes.is_finish_day") and is_finish_day>
                                <cfset GUN_FARKI = DateDiff("d",DUE_DATE,createodbcdatetime('#year(attributes.date2)#-#month(attributes.date2)#-#day(attributes.date2)#'))>
                            <cfelse>
                                <cfset GUN_FARKI = DateDiff("d",DUE_DATE,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
                            </cfif>
                        <cfelse>
                            <cfif isDefined("attributes.is_date_filter") and attributes.is_date_filter eq 1 and len(attributes.due_date_2)>
                                <cfset GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(attributes.due_date_2)#-#month(attributes.due_date_2)#-#day(attributes.due_date_2)#'))>
                            <cfelseif isDefined("attributes.is_finish_day") and is_finish_day>
                                <cfset GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(attributes.date2)#-#month(attributes.date2)#-#day(attributes.date2)#'))>
                            <cfelse>
                                <cfset GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
                            </cfif>
                        </cfif>
                        <!--- Islem Tarihi Farkı/Gun --->
                        <cfif len(GET_INV_RECORD.INVOICE_DATE)>
                            <cfif isDefined("attributes.is_date_filter") and attributes.is_date_filter eq 1 and len(attributes.date2)>
                                <cfset ISLEM_GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(attributes.date2)#-#month(attributes.date2)#-#day(attributes.date2)#'))>
                            <cfelseif isDefined("attributes.is_finish_day") and is_finish_day>
                                <cfset ISLEM_GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(attributes.date2)#-#month(attributes.date2)#-#day(attributes.date2)#'))>
                            <cfelse>
                                <cfset ISLEM_GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
                            </cfif>
                        <cfelse>
                            <cfif isDefined("attributes.is_date_filter") and attributes.is_date_filter eq 1 and len(attributes.date2)>
                                <cfset ISLEM_GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(attributes.date2)#-#month(attributes.date2)#-#day(attributes.date2)#'))>
                            <cfelseif isDefined("attributes.is_finish_day") and is_finish_day>
                                <cfset ISLEM_GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(attributes.date2)#-#month(attributes.date2)#-#day(attributes.date2)#'))>
                            <cfelse>
                                <cfset ISLEM_GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
                            </cfif>
                        </cfif>
                        
                        <cfif GUN_FARKI eq 0><cfset GUN_FARKI=1></cfif>
                        <cfif isDefined("attributes.is_doviz_group")>
                            <cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + ((TOTAL_OTHER_SUB*INV_RATE)*GUN_FARKI)>
                            <cfset islem_tar_acik_fat_toplam_agirlik = islem_tar_acik_fat_toplam_agirlik + ((TOTAL_OTHER_SUB*INV_RATE)*ISLEM_GUN_FARKI)>
                            <cfif GUN_FARKI gt 0>
                                <cfset acik_fat_toplam_agirlik_old = acik_fat_toplam_agirlik_old + ((TOTAL_OTHER_SUB*INV_RATE)*GUN_FARKI)>
                            </cfif>
                            <cfif ISLEM_GUN_FARKI gt 0>
                                <cfset islem_tar_acik_fat_toplam_agirlik_old = islem_tar_acik_fat_toplam_agirlik_old + ((TOTAL_OTHER_SUB*INV_RATE)*ISLEM_GUN_FARKI)>
                            </cfif>
                        <cfelse>
                            <cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + (TOTAL_SUB*GUN_FARKI)>
                            <cfset islem_tar_acik_fat_toplam_agirlik = islem_tar_acik_fat_toplam_agirlik + (TOTAL_SUB*ISLEM_GUN_FARKI)>
                            <cfif GUN_FARKI gt 0>
                                <cfset acik_fat_toplam_agirlik_old = acik_fat_toplam_agirlik_old + (TOTAL_SUB*GUN_FARKI)>
                            </cfif>
                            <cfif ISLEM_GUN_FARKI gt 0>
                                <cfset islem_tar_acik_fat_toplam_agirlik_old = islem_tar_acik_fat_toplam_agirlik_old + (TOTAL_SUB*ISLEM_GUN_FARKI)>
                            </cfif>
                        </cfif>
                        <cfif isDefined("attributes.is_doviz_group")>
                            <cfset acik_fat_toplam = acik_fat_toplam+(TOTAL_OTHER_SUB*INV_RATE)>
                            <cfset islem_tar_acik_fat_toplam = islem_tar_acik_fat_toplam+(TOTAL_OTHER_SUB*INV_RATE)>
                            <cfif GUN_FARKI gt 0>
                                <cfset acik_fat_toplam_old = acik_fat_toplam_old + (TOTAL_OTHER_SUB*INV_RATE)>
                            </cfif>
                            <cfif ISLEM_GUN_FARKI gt 0>
                                <cfset islem_tar_acik_fat_toplam_old = islem_tar_acik_fat_toplam_old + (TOTAL_OTHER_SUB*INV_RATE)>
                            </cfif>
                            <cfset bakiye_ = TOTAL_OTHER_SUB>
                        <cfelse>
                            <cfset acik_fat_toplam = acik_fat_toplam+TOTAL_SUB>
                            <cfset islem_tar_acik_fat_toplam = islem_tar_acik_fat_toplam+TOTAL_SUB>
                            <cfif GUN_FARKI gt 0>
                                <cfset acik_fat_toplam_old = acik_fat_toplam_old + TOTAL_SUB>
                            </cfif>
                            <cfif ISLEM_GUN_FARKI gt 0>
                                <cfset islem_tar_acik_fat_toplam_old = islem_tar_acik_fat_toplam_old + TOTAL_SUB>
                            </cfif>
                            <cfset bakiye_ = TOTAL_OTHER_SUB>
                        </cfif>
                        <cfset money = T_OTHER_MONEY>
                        <cfif bakiye_ gt 0>
                            <cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
                        <cfelse>
                            <cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
                        </cfif>	
                        <tr height="20">
                            <td width="60">#INVOICE_NUMBER#</td>
                            <td><cfif len(project_name_list)>#get_project_name.project_head[listfind(project_name_list,project_id,',')]#</cfif></td>
                            <td>#DateFormat(INVOICE_DATE,dateformat_style)#</td>
                            <td><cfif DUE_DATE lt date_add('d',1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))><font color="red"><cfset due_date_info = DateFormat(DUE_DATE,dateformat_style)>#due_date_info#</font><cfelse><cfset due_date_info = DateFormat(DUE_DATE,dateformat_style)>#due_date_info#</cfif></td>
                            <td>
                                <cfif isdefined('attributes.list_type') and listfind(attributes.list_type,7)>
                                    <cfif listfind(process_cat_id_list_2,GET_INV_RECORD.PROCESS_CAT,',')>
                                        #get_process_cat_2.process_cat[listfind(process_cat_id_list_2,GET_INV_RECORD.PROCESS_CAT,',')]#
                                    <cfelse>
                                        #get_process_name(GET_INV_RECORD.ACTION_TYPE_ID)#
                                    </cfif>
                                <cfelse>
                                    #get_process_name(GET_INV_RECORD.ACTION_TYPE_ID)#
                                </cfif>	
                            </td>
                            <td align="center">#ISLEM_GUN_FARKI#</td>
                            <td align="center">#GUN_FARKI#</td>
                            <td style="text-align:right;">
                                <cfif isDefined("attributes.is_doviz_group")>
                                    <cfset open_inv_value =TOTAL_OTHER_SUB*INV_RATE>
									#TLFormat(open_inv_value)# 
                                <cfelse>
                                    <cfset open_inv_value = TOTAL_SUB >
									#TLFormat(open_inv_value)# #session_base_money#
                                </cfif> 
                            </td>
                            <cfif isDefined("attributes.is_doviz_group")>
								<td style="text-align:right;">
                                	#TLFormat(TOTAL_OTHER_SUB)# 
                           		 </td>
								 <td style="text-align:right;">
                                	#T_OTHER_MONEY#
                           		 </td>
							</cfif>
                            <cfif isDefined("add_bank_order") and add_bank_order and isdefined("company_id")>
								<cfset member_type = "company">
                                <td style="text-align:center;"><input type="checkbox" checked name="_is_bank_order_" id="_is_bank_order_" value="#CARI_ACTION_ID#█#open_inv_value#█#company_id#█#DateFormat(INVOICE_DATE,dateformat_style)#█#due_date_info#█#member_type#█"></td>
                             <cfelseif isDefined("add_bank_order") and add_bank_order and isdefined("consumer_id")>
								<cfset member_type = "consumer">
                                <td style="text-align:center;"><input type="checkbox" checked name="_is_bank_order_" id="_is_bank_order_" value="#CARI_ACTION_ID#█#open_inv_value#█#consumer_id#█#DateFormat(INVOICE_DATE,dateformat_style)#█#due_date_info#█#member_type#█"></td>
							 <cfelseif isDefined("add_bank_order") and add_bank_order and isdefined("employee_id")>
								<cfset member_type = "employee">
                                <td style="text-align:center;"><input type="checkbox" checked name="_is_bank_order_" id="_is_bank_order_" value="#CARI_ACTION_ID#█#open_inv_value#█#employee_id#█#DateFormat(INVOICE_DATE,dateformat_style)#█#due_date_info#█#member_type#█"></td>
							</cfif>
                        </tr>
                    </cfif>
                </cfoutput>
            </tbody>
            <tfoot>
                <tr>
                    <cfset total_days_toplam =  total_days_toplam + acik_fat_toplam_old>
                    <cfset total_days_kontrol =  total_days + acik_fat_toplam_agirlik_old>
                    <cfset total_days =  abs(total_days) + abs(acik_fat_toplam_agirlik_old)>
                    <cfif total_days_kontrol lt 0><cfset dsp_info = -1><cfelse><cfset dsp_info = 1></cfif>
                    <cfif total_days neq 0><cfset due_day_old = total_days/total_days_toplam><cfelse><cfset due_day_old = 0></cfif>
                    <td colspan="4"><b><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="58501.Vade Farkı"> :<cfoutput>#TLFormat(dsp_info*due_day_old)#</cfoutput></b></td>
                    <cfoutput>
                        <td></td><cfset due_day = 0><cfset action_day = 0>
                        <td align="center" width="80" class="txtbold"><cfif islem_tar_acik_fat_toplam neq 0><cfset action_day = wrk_round(islem_tar_acik_fat_toplam_agirlik/islem_tar_acik_fat_toplam)>#TLFormat(islem_tar_acik_fat_toplam_agirlik/islem_tar_acik_fat_toplam)# (#dateformat(date_add('d',(-1*action_day),now()),dateformat_style)#)</cfif></td>
                        <td align="center" width="80" class="txtbold"><cfif acik_fat_toplam neq 0><cfset due_day = wrk_round(acik_fat_toplam_agirlik/acik_fat_toplam)>#TLFormat(acik_fat_toplam_agirlik/acik_fat_toplam)# (#dateformat(date_add('d',(-1*due_day),now()),dateformat_style)#)</cfif></td>
                        <cfif isDefined("attributes.is_doviz_group")>
							<td nowrap="nowrap" class="txtbold" style="text-align:right;">#TLFormat(acik_fat_toplam)#</td>
							<td nowrap="nowrap" class="txtbold" style="text-align:right;">#session_base_money#</td>
						</cfif>
                    </cfoutput>
                    <td nowrap="nowrap" class="txtbold" style="text-align:right;">
                        <cfif isDefined("attributes.is_doviz_group")>
                            <cfoutput query="get_money_rate">
                                <cfset toplam_ara = 0>
                                <cfloop list="#money_list#" index="i">
                                    <cfset tutar_ = listfirst(i,'*')>
                                    <cfset money_ = listlast(i,'*')>
                                    <cfif money_ eq money>
                                        <cfset toplam_ara = toplam_ara + tutar_>
                                    </cfif>
                                </cfloop>
                                <cfif toplam_ara neq 0>
                                    #TLFormat(ABS(toplam_ara))# #money#<br>
                                </cfif>
                            </cfoutput>
                        <cfelse>
                            <cfoutput>#TLFormat(acik_fat_toplam)# #session_base_money#</cfoutput>
                        </cfif>
                    </td>
                     <cfif isDefined("add_bank_order") and add_bank_order and isdefined("company_id")><td></td></cfif>
                </tr>
            </tfoot>
    <cfelse>
			<tr>
				<td colspan="<cfif isDefined("add_bank_order") and add_bank_order and isdefined("company_id")>10<cfelse>9</cfif>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
    </cfif>
    </cf_medium_list>
    </cfif>
</cfif>
<div style="display:none"><cf_report_list></cf_report_list></div> 
<script type="text/javascript">
	$("table.medium_list_head div.listIcon").hide();
	function gonder_ic_form()
	{
		if( document.list_ekstre != undefined && document.list_ekstre.due_date_2.value != undefined)
		{
			document.list_ekstre.due_date_2.value = document.getElementById('ic_due_date_2').value;
			document.list_ekstre.due_date_1.value = document.getElementById('ic_due_date_1').value;
			document.list_ekstre.other_money_2.value = document.getElementById('ic_other_money_2').value;
			document.list_ekstre.action_date_1.value = document.getElementById('ic_action_date_1').value;
			document.list_ekstre.action_date_2.value = document.getElementById('ic_action_date_2').value;
			document.list_ekstre.date_control.value = '0';
			if(document.getElementById('ic_is_date_filter').checked == true)
				document.list_ekstre.is_date_filter.value = document.getElementById('ic_is_date_filter').value;
			document.list_ekstre.submit();
		}
		else
		{
			document.cari.due_date_2.value = document.getElementById('ic_due_date_2').value;
			document.cari.due_date_1.value = document.getElementById('ic_due_date_1').value;
			document.cari.other_money_2.value = document.getElementById('ic_other_money_2').value;
			document.cari.action_date_1.value = document.getElementById('ic_action_date_1').value;
			document.cari.action_date_2.value = document.getElementById('ic_action_date_2').value;
			if(typeof(document.cari.date_control) == 'object')document.cari.date_control.value = '0';
			if(document.getElementById('ic_is_date_filter').checked == true)
				document.cari.is_date_filter.value = document.getElementById('ic_is_date_filter').value;
			document.cari.submit();
		}
	}
	function add_bill_sale_<cfoutput>#attributes.row_id#</cfoutput>()
	{
		windowopen('','wide','add_inv<cfoutput>#attributes.row_id#</cfoutput>');
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.action='<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.form_add_bill<cfif isDefined("attributes.company_id") and len(attributes.company_id)>&company_id=<cfoutput>#attributes.company_id#</cfoutput><cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>&consumer_id=<cfoutput>#attributes.consumer_id#</cfoutput><cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>&employee_id=<cfoutput>#attributes.employee_id#</cfoutput></cfif>';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.target='add_inv<cfoutput>#attributes.row_id#</cfoutput>';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.submit();
	}
	function add_bill_purch_<cfoutput>#attributes.row_id#</cfoutput>()
	{
		windowopen('','wide','add_inv<cfoutput>#attributes.row_id#</cfoutput>');
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.action='<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.form_add_bill_purchase<cfif isDefined("attributes.company_id") and len(attributes.company_id)>&company_id=<cfoutput>#attributes.company_id#</cfoutput><cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>&consumer_id=<cfoutput>#attributes.consumer_id#</cfoutput><cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>&employee_id=<cfoutput>#attributes.employee_id#</cfoutput></cfif>';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.target='add_inv<cfoutput>#attributes.row_id#</cfoutput>';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.submit();
	}
</script>