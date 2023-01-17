<cfflush interval="100">
<cfquery name="get_period" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #listfirst(attributes.period,';')#
</cfquery>
<cfset aciklama = '#get_period.PERIOD_YEAR+1# DEVIR ISLEMI'>
<cfif isdefined("attributes.is_cheque_voucher_transfer") and attributes.is_cheque_voucher_transfer eq 1>
	<cfset attributes.is_pay_cheques = 1>
</cfif>
<cfif isdefined("attributes.is_consumer")>	<!--- bireysel uye --->
	<cfquery name="DEL_CONSUMER_CARI_ACTION" datasource="#donem_db#">
		DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID=40 AND ACTION_ID= -1 AND (TO_CONSUMER_ID IS NOT NULL OR FROM_CONSUMER_ID IS NOT NULL) 
		<cfif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')>
			AND ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) = #attributes.consumer_id#
		</cfif>
		<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
			AND ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) IN(SELECT C.CONSUMER_ID FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_CAT_ID IN(#attributes.member_cat#))
		</cfif>
	</cfquery>
	<cfquery name="GET_COMP_REMAINDER_MAIN" datasource="#donem_eski#">
		SELECT
			C.CONSUMER_ID,
			MEMBER_CODE,
			0 ACC_TYPE_ID
			<cfif isDefined("attributes.is_project_transfer")>
				,CR.PROJECT_ID
			</cfif>
			<cfif isDefined("attributes.is_acc_type_transfer")>,CR.ACC_TYPE_ID</cfif>
			<cfif isDefined("attributes.is_subscription_transfer")>,CR.SUBSCRIPTION_ID</cfif>
		FROM 
			<cfif isDefined("attributes.is_project_transfer")>
				CONSUMER_REMAINDER_PROJECT CR,
			<cfelseif isDefined("attributes.is_subscription_transfer")>
				CONSUMER_REMAINDER_SUBSCRIPTION CR,
			<cfelseif isDefined("attributes.is_acc_type_transfer")>
				CONSUMER_REMAINDER_ACC_TYPE CR,
			<cfelse>
				CONSUMER_REMAINDER CR,
			</cfif>
			#dsn_alias#.CONSUMER C 
		WHERE 
			C.CONSUMER_ID = CR.CONSUMER_ID
			<cfif not isDefined("attributes.is_other_money_transfer")>
				AND BAKIYE <> 0
			</cfif>
			<cfif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')>
				AND C.CONSUMER_ID = #attributes.consumer_id#
			</cfif>
			<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
				AND C.CONSUMER_ID IN(SELECT C.CONSUMER_ID FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_CAT_ID IN(#attributes.member_cat#))
			</cfif>
		ORDER BY
			CONSUMER_NAME,
			CONSUMER_SURNAME
	</cfquery>
<cfelseif isdefined("attributes.is_company")>	<!--- kurumsal uye --->
	<cfquery name="DEL_CONSUMER_CARI_ACTION" datasource="#donem_db#">
		DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID=40 AND ACTION_ID= -1 AND (TO_CMP_ID IS NOT NULL OR FROM_CMP_ID IS NOT NULL) 
		<cfif (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner')>
			AND ISNULL(TO_CMP_ID,FROM_CMP_ID) = #attributes.company_id#
		</cfif>
		<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
			AND ISNULL(TO_CMP_ID,FROM_CMP_ID) IN(SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANYCAT_ID IN(#attributes.member_cat#))
		</cfif>
	</cfquery>
	<cfquery name="GET_COMP_REMAINDER_MAIN" datasource="#donem_eski#">
		SELECT
			C.COMPANY_ID,
			MEMBER_CODE,
			0 ACC_TYPE_ID
			<cfif isDefined("attributes.is_project_transfer")>
				,CR.PROJECT_ID
			</cfif>
			<cfif isDefined("attributes.is_acc_type_transfer")>,CR.ACC_TYPE_ID</cfif>
			<cfif isDefined("attributes.is_subscription_transfer")>,CR.SUBSCRIPTION_ID</cfif>
		FROM 
			<cfif isDefined("attributes.is_project_transfer")>
				COMPANY_REMAINDER_PROJECT CR,
			<cfelseif isDefined("attributes.is_subscription_transfer")>
				COMPANY_REMAINDER_SUBSCRIPTION CR,
			<cfelseif isDefined("attributes.is_acc_type_transfer")>
				COMPANY_REMAINDER_ACC_TYPE CR,
			<cfelse>
				COMPANY_REMAINDER CR,
			</cfif>
			#dsn_alias#.COMPANY C 
		WHERE 
			C.COMPANY_ID = CR.COMPANY_ID 
			<cfif (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner')>
				AND C.COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
				AND C.COMPANY_ID IN(SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANYCAT_ID IN(#attributes.member_cat#))
			</cfif>
			<cfif not isDefined("attributes.is_other_money_transfer")>
				AND BAKIYE <> 0
			</cfif>
		ORDER BY
			FULLNAME
	</cfquery>
<cfelse>	<!--- calisan --->
	<cfquery name="DEL_CONSUMER_CARI_ACTION" datasource="#donem_db#">
		DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID=40 AND ACTION_ID= -1 AND (TO_EMPLOYEE_ID IS NOT NULL OR FROM_EMPLOYEE_ID IS NOT NULL) 
		<cfif (isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee')>
			AND ISNULL(TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID) = #attributes.employee_id#
		</cfif>
	</cfquery>
	<cfquery name="GET_COMP_REMAINDER_MAIN" datasource="#donem_eski#">
		SELECT
			C.EMPLOYEE_ID,
			MEMBER_CODE,
			ISNULL(CR.ACC_TYPE_ID,0) ACC_TYPE_ID
			<cfif isDefined("attributes.is_project_transfer")>
				,CR.PROJECT_ID
			</cfif>
			<cfif isDefined("attributes.is_acc_type_transfer")>,CR.ACC_TYPE_ID</cfif>
			<cfif isDefined("attributes.is_subscription_transfer")>,CR.SUBSCRIPTION_ID</cfif>
		FROM 
			<cfif isDefined("attributes.is_project_transfer")>
				EMPLOYEE_REMAINDER_PROJECT CR,
			<cfelseif isDefined("attributes.is_subscription_transfer")>
				EMPLOYEE_REMAINDER_SUBSCRIPTION CR,
			<cfelseif isDefined("attributes.is_acc_type_transfer")>
				EMPLOYEE_REMAINDER_ACC_TYPE CR,
			<cfelse>
				EMPLOYEE_REMAINDER CR,
			</cfif>
			#dsn_alias#.EMPLOYEES C 
		WHERE 
			C.EMPLOYEE_ID = CR.EMPLOYEE_ID 
			<cfif (isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee')>
				AND C.EMPLOYEE_ID = #attributes.employee_id#
			</cfif>
			<cfif not isDefined("attributes.is_other_money_transfer")>
				AND BAKIYE <> 0
			</cfif>
		ORDER BY
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
	</cfquery>
</cfif>
<font color="FF0000">Cari Aktarım İşlemi Gerçekleştiriliyor. Lütfen Sayfayı Yenilemeyin  !!</font><br/><br/>
<cfloop query="GET_COMP_REMAINDER_MAIN">
	<cfoutput>#get_comp_remainder_main.currentrow# - #get_comp_remainder_main.member_code# No'lu Üyenin Aktarımı Tamamlandı.<br/></cfoutput>
	<cfif isDefined("attributes.is_project_transfer")><cfset project_id_info = GET_COMP_REMAINDER_MAIN.PROJECT_ID></cfif>
	<cfif isDefined("attributes.is_subscription_transfer")><cfset subscription_id_info = GET_COMP_REMAINDER_MAIN.SUBSCRIPTION_ID></cfif>
	<cfif isDefined("attributes.is_acc_type_transfer")><cfset acc_type_info = GET_COMP_REMAINDER_MAIN.ACC_TYPE_ID></cfif>
	<cfif isdefined("attributes.is_consumer")>
		<cfset attributes.consumer_id = GET_COMP_REMAINDER_MAIN.CONSUMER_ID>
	<cfelseif isdefined("attributes.is_company")>
		<cfset attributes.company_id = GET_COMP_REMAINDER_MAIN.COMPANY_ID>
	<cfelse>
		<cfset attributes.employee_id = GET_COMP_REMAINDER_MAIN.EMPLOYEE_ID>
	</cfif>
	<cfset acc_type_id = GET_COMP_REMAINDER_MAIN.ACC_TYPE_ID>
	<cfif isDefined("session.pp")>
		<cfset session_base_money = session.pp.money>
	<cfelseif isDefined("session.ww")>
		<cfset session_base_money = session.ww.money>
	<cfelse>
		<cfset session_base_money = session.ep.money>
	</cfif>
	<cfquery name="GET_MONEY_RATE" datasource="#donem_eski#">
		SELECT * FROM SETUP_MONEY
	</cfquery>
	<cfquery name="GET_SETUP_MONEY" datasource="#donem_eski#">
		SELECT * FROM SETUP_MONEY <cfif not isDefined("attributes.is_other_money_transfer")>WHERE MONEY = '<cfoutput>#session_base_money#</cfoutput>'</cfif>
	</cfquery>
	<cfif isDefined("attributes.is_other_money_transfer")>
		<cfset OPEN_INVOICE = QueryNew("INVOICE_NUMBER,TOTAL_SUB,TOTAL_OTHER_SUB,T_OTHER_MONEY,INVOICE_DATE,ROW_COUNT,DUE_DATE,INV_RATE,ACTION_TYPE_ID,PROJECT_ID,INV_RATE_2,BRANCH_ID,ACTION_DETAIL,ACC_TYPE_ID,SUBSCRIPTION_ID","VarChar,Double,Double,VarChar,Date,integer,Date,Double,integer,integer,Double,integer,VarChar,integer,integer")>
	</cfif>
	<cfset open_rows_ = 0>
	<cfif (isDefined("attributes.company_id") and len(attributes.company_id)) or (isDefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isDefined("attributes.employee_id") and len(attributes.employee_id))>
		<!--- Hesaplamalar --->  
		<cfloop query="GET_SETUP_MONEY">
			<cfif GET_SETUP_MONEY.MONEY eq session_base_money and not isDefined("attributes.is_other_money_transfer")>
				<cfquery name="GET_COMP_REMAINDER" datasource="#donem_eski#">
					SELECT
						ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
						ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2
						<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
						<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
						<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
					FROM
						(
							SELECT
								SUM(ACTION_VALUE) AS BORC,
								SUM(ACTION_VALUE_2) AS BORC2,		
								0 AS ALACAK,
								0 AS ALACAK2
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
							FROM
								CARI_ROWS
							WHERE
								ACTION_TYPE_ID NOT IN (48,49,45,46) AND
								<cfif isdefined("attributes.is_consumer")>
									TO_CONSUMER_ID = #attributes.consumer_id#
								<cfelseif isdefined("attributes.is_company")>
									TO_CMP_ID = #attributes.company_id#
								<cfelse>
									TO_EMPLOYEE_ID = #attributes.employee_id#
									<cfif isdefined("acc_type_id") and len(acc_type_id)>
										AND ACC_TYPE_ID = #acc_type_id#
									</cfif>
								</cfif>
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										)
									)
								</cfif>
								<cfif isDefined("attributes.is_project_transfer")>
									<cfif len(project_id_info)>
										AND PROJECT_ID = #project_id_info#
									<cfelse>
										AND PROJECT_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>
									<cfif len(acc_type_info)>
										AND ACC_TYPE_ID = #acc_type_info#
									<cfelse>
										AND ACC_TYPE_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>
									<cfif len(subscription_id_info)>
										AND SUBSCRIPTION_ID = #subscription_id_info#
									<cfelse>
										AND SUBSCRIPTION_ID IS NULL	
									</cfif>
								</cfif>
							<cfif isDefined("attributes.is_project_transfer")>GROUP BY PROJECT_ID</cfif>
							<cfif isDefined("attributes.is_acc_type_transfer")>GROUP BY ACC_TYPE_ID</cfif>
							<cfif isDefined("attributes.is_subscription_transfer")>GROUP BY SUBSCRIPTION_ID</cfif>
						UNION ALL
							SELECT
								0 AS BORC,
								0 AS BORC2,
								SUM(ACTION_VALUE) AS ALACAK,
								SUM(ACTION_VALUE_2) AS ALACAK2
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
							FROM
								CARI_ROWS
							WHERE
								ACTION_TYPE_ID NOT IN (48,49,45,46) AND
								<cfif isdefined("attributes.is_consumer")>
									FROM_CONSUMER_ID = #attributes.consumer_id#
								<cfelseif isdefined("attributes.is_company")>
									FROM_CMP_ID = #attributes.company_id#
								<cfelse>
									FROM_EMPLOYEE_ID = #attributes.employee_id#
									<cfif isdefined("acc_type_id") and len(acc_type_id)>
										AND ACC_TYPE_ID = #acc_type_id#
									</cfif>
								</cfif>
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										)
									)
								</cfif>
								<cfif isDefined("attributes.is_project_transfer")>
									<cfif len(project_id_info)>
										AND PROJECT_ID = #project_id_info#
									<cfelse>
										AND PROJECT_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>
									<cfif len(acc_type_info)>
										AND ACC_TYPE_ID = #acc_type_info#
									<cfelse>
										AND ACC_TYPE_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>
									<cfif len(subscription_id_info)>
										AND SUBSCRIPTION_ID = #subscription_id_info#
									<cfelse>
										AND SUBSCRIPTION_ID IS NULL	
									</cfif>
								</cfif>
							<cfif isDefined("attributes.is_project_transfer")>GROUP BY PROJECT_ID</cfif>
							<cfif isDefined("attributes.is_acc_type_transfer")>GROUP BY ACC_TYPE_ID</cfif>
							<cfif isDefined("attributes.is_subscription_transfer")>GROUP BY SUBSCRIPTION_ID</cfif>
						) AS COMP_REMAINDER
					<cfif isDefined("attributes.is_project_transfer")>GROUP BY PROJECT_ID</cfif>
					<cfif isDefined("attributes.is_acc_type_transfer")>GROUP BY ACC_TYPE_ID</cfif>
					<cfif isDefined("attributes.is_subscription_transfer")>GROUP BY SUBSCRIPTION_ID</cfif>
				</cfquery>
				<cfset bakiye_kontrol = GET_COMP_REMAINDER.BAKIYE>
				<cfquery name="LAST_COMP_REMAINDER" datasource="#donem_eski#">
					SELECT
						ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
						ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2
						<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
						<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
						<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
					FROM
						(
							SELECT
								SUM(ACTION_VALUE) AS BORC,
								SUM(ACTION_VALUE_2) AS BORC2,		
								0 AS ALACAK,
								0 AS ALACAK2
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
							FROM
								CARI_ROWS
							WHERE
								<cfif isdefined("attributes.is_consumer")>
									TO_CONSUMER_ID = #attributes.consumer_id#
								<cfelseif isdefined("attributes.is_company")>
									TO_CMP_ID = #attributes.company_id#
								<cfelse>
									TO_EMPLOYEE_ID = #attributes.employee_id#
									<cfif isdefined("acc_type_id") and len(acc_type_id)>
										AND ACC_TYPE_ID = #acc_type_id#
									</cfif>
								</cfif>
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										)
									)
								</cfif>
								<cfif isDefined("attributes.is_project_transfer")>
									<cfif len(project_id_info)>
										AND PROJECT_ID = #project_id_info#
									<cfelse>
										AND PROJECT_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>
									<cfif len(acc_type_info)>
										AND ACC_TYPE_ID = #acc_type_info#
									<cfelse>
										AND ACC_TYPE_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>
									<cfif len(subscription_id_info)>
										AND SUBSCRIPTION_ID = #subscription_id_info#
									<cfelse>
										AND SUBSCRIPTION_ID IS NULL	
									</cfif>
								</cfif>
							<cfif isDefined("attributes.is_project_transfer")>GROUP BY PROJECT_ID</cfif>
							<cfif isDefined("attributes.is_acc_type_transfer")>GROUP BY ACC_TYPE_ID</cfif>
							<cfif isDefined("attributes.is_subscription_transfer")>GROUP BY SUBSCRIPTION_ID</cfif>
						UNION ALL
							SELECT
								0 AS BORC,
								0 AS BORC2,
								SUM(ACTION_VALUE) AS ALACAK,
								SUM(ACTION_VALUE_2) AS ALACAK2
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
							FROM
								CARI_ROWS
							WHERE
								<cfif isdefined("attributes.is_consumer")>
									FROM_CONSUMER_ID = #attributes.consumer_id#
								<cfelseif isdefined("attributes.is_company")>
									FROM_CMP_ID = #attributes.company_id#
								<cfelse>
									FROM_EMPLOYEE_ID = #attributes.employee_id#
									<cfif isdefined("acc_type_id") and len(acc_type_id)>
										AND ACC_TYPE_ID = #acc_type_id#
									</cfif>
								</cfif>
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										)
									)
								</cfif>
								<cfif isDefined("attributes.is_project_transfer")>
									<cfif len(project_id_info)>
										AND PROJECT_ID = #project_id_info#
									<cfelse>
										AND PROJECT_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>
									<cfif len(acc_type_info)>
										AND ACC_TYPE_ID = #acc_type_info#
									<cfelse>
										AND ACC_TYPE_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>
									<cfif len(subscription_id_info)>
										AND SUBSCRIPTION_ID = #subscription_id_info#
									<cfelse>
										AND SUBSCRIPTION_ID IS NULL	
									</cfif>
								</cfif>
							<cfif isDefined("attributes.is_project_transfer")>GROUP BY PROJECT_ID</cfif>
							<cfif isDefined("attributes.is_acc_type_transfer")>GROUP BY ACC_TYPE_ID</cfif>
							<cfif isDefined("attributes.is_subscription_transfer")>GROUP BY SUBSCRIPTION_ID</cfif>
						) AS COMP_REMAINDER
					<cfif isDefined("attributes.is_project_transfer")>GROUP BY PROJECT_ID</cfif>
					<cfif isDefined("attributes.is_acc_type_transfer")>GROUP BY ACC_TYPE_ID</cfif>
					<cfif isDefined("attributes.is_subscription_transfer")>GROUP BY SUBSCRIPTION_ID</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="GET_COMP_REMAINDER" datasource="#donem_eski#">
					SELECT
						ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
						ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
						ROUND(SUM(BORC3-ALACAK3),5) AS BAKIYE3,
						OTHER_MONEY
						<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
						<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
						<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
					FROM
						(
							SELECT
								SUM(ACTION_VALUE) AS BORC,
								SUM(ISNULL(ACTION_VALUE_2,0)) AS BORC2,		
								0 AS ALACAK,
								0 AS ALACAK2,
								0 AS ALACAK3,		
								SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) AS BORC3,
								OTHER_MONEY
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
							FROM
								CARI_ROWS
							WHERE
								ACTION_TYPE_ID NOT IN (48,49,45,46) AND
								<cfif isdefined("attributes.is_consumer")>
									TO_CONSUMER_ID = #attributes.consumer_id# AND
								<cfelseif isdefined("attributes.is_company")>
									TO_CMP_ID = #attributes.company_id# AND
								<cfelse>
									TO_EMPLOYEE_ID = #attributes.employee_id# AND
									<cfif isdefined("acc_type_id") and len(acc_type_id)>
										 ACC_TYPE_ID = #acc_type_id# AND
									</cfif>
								</cfif>
								OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										)
									)
								</cfif>
								<cfif isDefined("attributes.is_project_transfer")>
									<cfif len(project_id_info)>
										AND PROJECT_ID = #project_id_info#
									<cfelse>
										AND PROJECT_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>
									<cfif len(acc_type_info)>
										AND ACC_TYPE_ID = #acc_type_info#
									<cfelse>
										AND ACC_TYPE_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>
									<cfif len(subscription_id_info)>
										AND SUBSCRIPTION_ID = #subscription_id_info#
									<cfelse>
										AND SUBSCRIPTION_ID IS NULL	
									</cfif>
								</cfif>
							GROUP BY
								OTHER_MONEY
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
						UNION ALL
							SELECT
								0 AS BORC,
								0 AS BORC2,
								SUM(ACTION_VALUE) AS ALACAK,
								SUM(ISNULL(ACTION_VALUE_2,0)) AS ALACAK2,
								SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) AS ALACAK3,		
								0 AS BORC3,
								OTHER_MONEY
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
							FROM
								CARI_ROWS
							WHERE
								ACTION_TYPE_ID NOT IN (48,49,45,46) AND
								<cfif isdefined("attributes.is_consumer")>
									FROM_CONSUMER_ID = #attributes.consumer_id# AND
								<cfelseif isdefined("attributes.is_company")>
									FROM_CMP_ID = #attributes.company_id# AND
								<cfelse>
									FROM_EMPLOYEE_ID = #attributes.employee_id# AND
									<cfif isdefined("acc_type_id") and len(acc_type_id)>
										 ACC_TYPE_ID = #acc_type_id# AND
									</cfif>
								</cfif>
								OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										)
									)
								</cfif>
								<cfif isDefined("attributes.is_project_transfer")>
									<cfif len(project_id_info)>
										AND PROJECT_ID = #project_id_info#
									<cfelse>
										AND PROJECT_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>
									<cfif len(acc_type_info)>
										AND ACC_TYPE_ID = #acc_type_info#
									<cfelse>
										AND ACC_TYPE_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>
									<cfif len(subscription_id_info)>
										AND SUBSCRIPTION_ID = #subscription_id_info#
									<cfelse>
										AND SUBSCRIPTION_ID IS NULL	
									</cfif>
								</cfif>
							GROUP BY
								OTHER_MONEY
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
						) AS COMP_REMAINDER
					GROUP BY
						OTHER_MONEY
						<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
						<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
						<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
				</cfquery>
				<cfset bakiye_kontrol = GET_COMP_REMAINDER.BAKIYE3>
				<cfquery name="LAST_COMP_REMAINDER" datasource="#donem_eski#">
					SELECT
						ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
						ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
						ROUND(SUM(BORC3-ALACAK3),5) AS BAKIYE3,
						OTHER_MONEY
						<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
						<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
						<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
					FROM
						(
							SELECT
								SUM(ACTION_VALUE) AS BORC,
								SUM(ISNULL(ACTION_VALUE_2,0)) AS BORC2,		
								0 AS ALACAK,
								0 AS ALACAK2,
								0 AS ALACAK3,		
								SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) AS BORC3,
								OTHER_MONEY
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
							FROM
								CARI_ROWS
							WHERE
								<cfif isdefined("attributes.is_consumer")>
									TO_CONSUMER_ID = #attributes.consumer_id# AND
								<cfelseif isdefined("attributes.is_company")>
									TO_CMP_ID = #attributes.company_id# AND
								<cfelse>
									TO_EMPLOYEE_ID = #attributes.employee_id# AND
									<cfif isdefined("acc_type_id") and len(acc_type_id)>
										 ACC_TYPE_ID = #acc_type_id# AND
									</cfif>
								</cfif>
								OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										)
									)
								</cfif>
								<cfif isDefined("attributes.is_project_transfer")>
									<cfif len(project_id_info)>
										AND PROJECT_ID = #project_id_info#
									<cfelse>
										AND PROJECT_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>
									<cfif len(acc_type_info)>
										AND ACC_TYPE_ID = #acc_type_info#
									<cfelse>
										AND ACC_TYPE_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>
									<cfif len(subscription_id_info)>
										AND SUBSCRIPTION_ID = #subscription_id_info#
									<cfelse>
										AND SUBSCRIPTION_ID IS NULL	
									</cfif>
								</cfif>
							GROUP BY
								OTHER_MONEY
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
						UNION ALL
							SELECT
								0 AS BORC,
								0 AS BORC2,
								SUM(ACTION_VALUE) AS ALACAK,
								SUM(ISNULL(ACTION_VALUE_2,0)) AS ALACAK2,
								SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) AS ALACAK3,		
								0 AS BORC3,
								OTHER_MONEY
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
							FROM
								CARI_ROWS
							WHERE
								<cfif isdefined("attributes.is_consumer")>
									FROM_CONSUMER_ID = #attributes.consumer_id# AND
								<cfelseif isdefined("attributes.is_company")>
									FROM_CMP_ID = #attributes.company_id# AND
								<cfelse>
									FROM_EMPLOYEE_ID = #attributes.employee_id# AND
									<cfif isdefined("acc_type_id") and len(acc_type_id)>
										 ACC_TYPE_ID = #acc_type_id# AND
									</cfif>
								</cfif>
								OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										)
									)
								</cfif>
								<cfif isDefined("attributes.is_project_transfer")>
									<cfif len(project_id_info)>
										AND PROJECT_ID = #project_id_info#
									<cfelse>
										AND PROJECT_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>
									<cfif len(acc_type_info)>
										AND ACC_TYPE_ID = #acc_type_info#
									<cfelse>
										AND ACC_TYPE_ID IS NULL	
									</cfif>
								</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>
									<cfif len(subscription_id_info)>
										AND SUBSCRIPTION_ID = #subscription_id_info#
									<cfelse>
										AND SUBSCRIPTION_ID IS NULL	
									</cfif>
								</cfif>
							GROUP BY
								OTHER_MONEY
								<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
								<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
								<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
						) AS COMP_REMAINDER
					GROUP BY
						OTHER_MONEY
						<cfif isDefined("attributes.is_project_transfer")>,PROJECT_ID</cfif>
						<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
						<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
				</cfquery>
			</cfif>
			<cfquery name="GET_REVENUE" datasource="#donem_eski#">
				SELECT 
					FROM_CMP_ID,
					ACTION_VALUE AS TOTAL,
					ACTION_DATE,
					DUE_DATE,
					ACTION_TYPE_ID,
					PROJECT_ID,
					OTHER_CASH_ACT_VALUE AS OTHER_MONEY_VALUE ,
					OTHER_MONEY,
					PAPER_NO,
					CARI_ACTION_ID,
					#dsn_alias#.IS_ZERO((ACTION_VALUE/#dsn_alias#.IS_ZERO(ACTION_VALUE_2,1)),1) INV_RATE_2	,
					ACTION_DETAIL
					,ACC_TYPE_ID
					,SUBSCRIPTION_ID
				FROM
					CARI_ROWS
				WHERE
					OTHER_CASH_ACT_VALUE > 0 AND
				<cfif bakiye_kontrol gt 0>
					<cfif isdefined("attributes.is_consumer")>
						FROM_CONSUMER_ID = #attributes.consumer_id# AND
					<cfelseif isdefined("attributes.is_company")>
						FROM_CMP_ID = #attributes.company_id#  AND
					<cfelse>
						FROM_EMPLOYEE_ID = #attributes.employee_id#  AND
						<cfif isdefined("acc_type_id") and len(acc_type_id)>
							 ACC_TYPE_ID = #acc_type_id# AND
						</cfif>
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.is_consumer")>
						TO_CONSUMER_ID = #attributes.consumer_id# AND
					<cfelseif isdefined("attributes.is_company")>
						TO_CMP_ID = #attributes.company_id# AND
					<cfelse>
						TO_EMPLOYEE_ID = #attributes.employee_id# AND
						<cfif isdefined("acc_type_id") and len(acc_type_id)>
							 ACC_TYPE_ID = #acc_type_id# AND
						</cfif>
					</cfif>
				</cfif>
					ACTION_TYPE_ID NOT IN (48,49,45,46)
				<cfif isDefined("attributes.is_other_money_transfer")>
					AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
				</cfif>
				<cfif isdefined("attributes.is_pay_cheques")>
					AND
					(
						(	
							CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
							AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
						)
						OR
						(	
							CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
							AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
						)
						OR 
						(
							CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
							AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
						)
						OR 
						(
							CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
							AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
						)
						OR 
						(
							CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
							AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
						)
					)
				</cfif>
				<cfif isDefined("attributes.is_project_transfer")>
					<cfif len(project_id_info)>
						AND PROJECT_ID = #project_id_info#
					<cfelse>
						AND PROJECT_ID IS NULL	
					</cfif>
				</cfif>
				<cfif isDefined("attributes.is_acc_type_transfer")>
					<cfif len(acc_type_info)>
						AND ACC_TYPE_ID = #acc_type_info#
					<cfelse>
						AND ACC_TYPE_ID IS NULL	
					</cfif>
				</cfif>
				<cfif isDefined("attributes.is_subscription_transfer")>
					<cfif len(subscription_id_info)>
						AND SUBSCRIPTION_ID = #subscription_id_info#
					<cfelse>
						AND SUBSCRIPTION_ID IS NULL	
					</cfif>
				</cfif>
				ORDER BY
					ISNULL(DUE_DATE,ACTION_DATE)			
			</cfquery>
			<cfquery name="get_invoice" datasource="#donem_eski#">
				SELECT 
					ACTION_VALUE TOTAL,
					OTHER_CASH_ACT_VALUE OTHER_MONEY_VALUE,
					OTHER_MONEY,
					PAPER_NO INVOICE_NUMBER,
					ACTION_DATE INVOICE_DATE,
					ACTION_TYPE_ID,
					PROJECT_ID,
					ACTION_NAME,
					DUE_DATE,
					(ACTION_VALUE/#dsn_alias#.IS_ZERO(ISNULL(OTHER_CASH_ACT_VALUE,ACTION_VALUE),1)) INV_RATE,
					#dsn_alias#.IS_ZERO((ACTION_VALUE/#dsn_alias#.IS_ZERO(ACTION_VALUE_2,1)),1) INV_RATE_2,
					ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID) BRANCH_ID,
					ACTION_DETAIL
					,ACC_TYPE_ID
					,SUBSCRIPTION_ID
				FROM
					CARI_ROWS
				WHERE
					OTHER_CASH_ACT_VALUE > 0 AND
					ACTION_TYPE_ID NOT IN (48,49,45,46)
					<cfif bakiye_kontrol gt 0>
						<cfif isdefined("attributes.is_consumer")>
							AND	TO_CONSUMER_ID = #attributes.consumer_id# 
						<cfelseif isdefined("attributes.is_company")>
							AND	TO_CMP_ID = #attributes.company_id#
						<cfelse>
							AND	TO_EMPLOYEE_ID = #attributes.employee_id#
							<cfif isdefined("acc_type_id") and len(acc_type_id)>
								AND ACC_TYPE_ID = #acc_type_id# 
							</cfif>
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_consumer")>
							AND FROM_CONSUMER_ID = #attributes.consumer_id#
						<cfelseif isdefined("attributes.is_company")>
							AND FROM_CMP_ID = #attributes.company_id#
						<cfelse>
							AND FROM_EMPLOYEE_ID = #attributes.employee_id#
							<cfif isdefined("acc_type_id") and len(acc_type_id)>
								AND ACC_TYPE_ID = #acc_type_id# 
							</cfif>
						</cfif>
					</cfif>
					<cfif isDefined("attributes.is_other_money_transfer")>
						AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
					</cfif>
					<cfif isdefined("attributes.is_pay_cheques")>
						AND
						(
							(	
								CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
								AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
							)
							OR
							(	
								CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
								AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
							)
							OR 
							(
								CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
								AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
							)
							OR 
							(
								CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
								AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
							)
							OR 
							(
								CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
								AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
							)
						)
					</cfif>
					<cfif isDefined("attributes.is_project_transfer")>
						<cfif len(project_id_info)>
							AND PROJECT_ID = #project_id_info#
						<cfelse>
							AND PROJECT_ID IS NULL	
						</cfif>
					</cfif>
					<cfif isDefined("attributes.is_acc_type_transfer")>
						<cfif len(acc_type_info)>
							AND ACC_TYPE_ID = #acc_type_info#
						<cfelse>
							AND ACC_TYPE_ID IS NULL	
						</cfif>
					</cfif>
					<cfif isDefined("attributes.is_subscription_transfer")>
						<cfif len(subscription_id_info)>
							AND SUBSCRIPTION_ID = #subscription_id_info#
						<cfelse>
							AND SUBSCRIPTION_ID IS NULL	
						</cfif>
					</cfif>
				ORDER BY
					ISNULL(DUE_DATE,ACTION_DATE)
			</cfquery>
			<cfset row_of_query = 0>
			<!--- <cfset row_of_query_2 = 0> --->
			<cfset ALL_INVOICE = QueryNew("INVOICE_NUMBER,TOTAL_SUB,TOTAL_OTHER_SUB,T_OTHER_MONEY,INVOICE_DATE,ROW_COUNT,DUE_DATE,INV_RATE,ACTION_TYPE_ID,PROJECT_ID,INV_RATE_2,BRANCH_ID,ACTION_DETAIL,ACC_TYPE_ID,SUBSCRIPTION_ID","VarChar,Double,Double,VarChar,Date,integer,Date,Double,integer,integer,Double,integer,VarChar,integer,integer")>
			<cfoutput query="get_invoice">
				<cfscript>
					tarih_inv = CreateODBCDateTime(get_invoice.INVOICE_DATE);
					/*total_pesin = 0;
					en_genel_toplam = 0;
					kalan_pesin = TOTAL - total_pesin;
					en_genel_toplam = en_genel_toplam + total_pesin;
					total_pesin = TOTAL;*/
					
					row_of_query = row_of_query + 1 ;
					QueryAddRow(ALL_INVOICE,1);
					QuerySetCell(ALL_INVOICE,"INVOICE_NUMBER","#INVOICE_NUMBER#",row_of_query);
					QuerySetCell(ALL_INVOICE,"TOTAL_SUB","#TOTAL#",row_of_query);
					QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB","#OTHER_MONEY_VALUE#",row_of_query);
					QuerySetCell(ALL_INVOICE,"T_OTHER_MONEY","#OTHER_MONEY#",row_of_query);
					QuerySetCell(ALL_INVOICE,"INVOICE_DATE","#tarih_inv#",row_of_query);
					QuerySetCell(ALL_INVOICE,"ROW_COUNT","#row_of_query#",row_of_query);
					if(len(DUE_DATE))
						QuerySetCell(ALL_INVOICE,"DUE_DATE","#CreateODBCDateTime(DUE_DATE)#",row_of_query);
					else
						QuerySetCell(ALL_INVOICE,"DUE_DATE","#CreateODBCDateTime(INVOICE_DATE)#",row_of_query);
					QuerySetCell(ALL_INVOICE,"INV_RATE","#INV_RATE#",row_of_query);
					QuerySetCell(ALL_INVOICE,"ACTION_TYPE_ID","#ACTION_TYPE_ID#",row_of_query);
					QuerySetCell(ALL_INVOICE,"PROJECT_ID","#PROJECT_ID#",row_of_query);
					QuerySetCell(ALL_INVOICE,"INV_RATE_2","#INV_RATE_2#",row_of_query);
					QuerySetCell(ALL_INVOICE,"BRANCH_ID","#BRANCH_ID#",row_of_query);
					QuerySetCell(ALL_INVOICE,"ACTION_DETAIL","#ACTION_DETAIL#",row_of_query);
					QuerySetCell(ALL_INVOICE,"ACC_TYPE_ID","#ACC_TYPE_ID#",row_of_query);
					QuerySetCell(ALL_INVOICE,"SUBSCRIPTION_ID","#SUBSCRIPTION_ID#",row_of_query);
				</cfscript>
			</cfoutput>
			<!--- //Hesaplamalar --->
			<cfif GET_REVENUE.recordcount and get_invoice.recordcount>
				<cfset TOPLAM_VALUE = 0>
				<cfset TOPLAM_GUN_TUTARLARI=0>
				<cfset TOPLAM_AGIRLIK=0>
				<cfset total_money=0>
				<cfset total_kur_farki=0>
				<cfset cari_toplam_tutar=0>
				<cfset cari_toplam_islem_tutar=0>
				<cfif GET_REVENUE.recordcount>
					<cfoutput query="GET_REVENUE">
						<cfset TOPLAM_OTHER_VALUE = GET_REVENUE.OTHER_MONEY_VALUE[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
                        <cfset TOPLAM_VALUE = GET_REVENUE.TOTAL[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
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
								INV_RATE_2,
								BRANCH_ID,
								ACTION_DETAIL
								,ACC_TYPE_ID
								,SUBSCRIPTION_ID
							FROM
								ALL_INVOICE
							WHERE
							<cfif isDefined("attributes.is_other_money_transfer")>
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
							<cfset i_index=0>
							<cfloop condition="i_index lt GET_INV_RECORD.recordcount">
								<cfset i_index=i_index+1>
								<cfif len(GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
									<cfset GUN_FARKI = DateDiff("d",GET_INV_RECORD.DUE_DATE[i_index],GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
								<cfelse>
									<cfset GUN_FARKI = DateDiff("d",GET_INV_RECORD.DUE_DATE[i_index],GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow])>
								</cfif>
								<cfif GUN_FARKI eq 0><cfset GUN_FARKI=1></cfif>
                                
								<cfset TOPLAM_OTHER_TEMP = TOPLAM_OTHER_VALUE>
                                <cfset TOPLAM_TEMP = TOPLAM_VALUE>
								
								<cfset TOPLAM_OTHER_VALUE = TOPLAM_OTHER_VALUE - GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]>
                                <cfset TOPLAM_VALUE = TOPLAM_VALUE - GET_INV_RECORD.TOTAL_SUB[i_index]>
                                
								<cfif TOPLAM_VALUE gt 0>
									<cfif isDefined("attributes.is_other_money_transfer")>
										<cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]>
									<cfelse>
										<cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_SUB[i_index]>
									</cfif>
								<cfelse>
									<cfif isDefined("attributes.is_other_money_transfer")>
										<cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]+TOPLAM_OTHER_VALUE>
									<cfelse>
										<cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_SUB[i_index]+TOPLAM_VALUE>
									</cfif>
								</cfif>
								<!--- vade agirlikli ortalama toplam hesabi --->
								<cfset TOPLAM_GUN_TUTARLARI = TOPLAM_GUN_TUTARLARI + GUN_TUTARI><!--- gun tutarlari toplami --->
								<cfset TOPLAM_AGIRLIK = TOPLAM_AGIRLIK + (GUN_TUTARI*GUN_FARKI)><!--- gun agirliklari toplami --->
								<cfif isDefined("attributes.is_other_money_transfer")>
									<cfif TOPLAM_OTHER_VALUE gt 0>
											<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
											<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
										<cfelse>
											<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]-TOPLAM_OTHER_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
											<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",GET_INV_RECORD.TOTAL_SUB[i_index]-TOPLAM_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
											<cfbreak>
										</cfif>
								<CFELSE>
										<cfif TOPLAM_VALUE gt 0>
											<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
											<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
										<cfelse>
											<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]-TOPLAM_OTHER_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
											<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",GET_INV_RECORD.TOTAL_SUB[i_index]-TOPLAM_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
											<cfbreak>
										</cfif>
								</cfif>
							</cfloop>
						</cfif>
					</cfoutput>
				</cfif>
			</cfif>
			<cfif isDefined("attributes.is_other_money_transfer")>
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
							QuerySetCell(OPEN_INVOICE,"ROW_COUNT","#open_rows_#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"DUE_DATE","#DUE_DATE#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"INV_RATE","#INV_RATE#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"ACTION_TYPE_ID","#ACTION_TYPE_ID#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"PROJECT_ID","#PROJECT_ID#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"INV_RATE_2","#INV_RATE_2#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"BRANCH_ID","#BRANCH_ID#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"ACTION_DETAIL","#ACTION_DETAIL#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"ACC_TYPE_ID","#ACC_TYPE_ID#",open_rows_);
							QuerySetCell(OPEN_INVOICE,"SUBSCRIPTION_ID","#SUBSCRIPTION_ID#",open_rows_);
						</cfscript>
					</cfoutput>
				</cfif>
			</cfif>
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
					INV_RATE_2,
					BRANCH_ID,
					ACTION_DETAIL
					,ACC_TYPE_ID
					,SUBSCRIPTION_ID
				FROM
				<cfif isDefined("attributes.is_other_money_transfer")>
					OPEN_INVOICE
				<cfelse>
					ALL_INVOICE
				</cfif>
				WHERE
				<cfif isDefined("attributes.is_other_money_transfer")>
					TOTAL_OTHER_SUB IS NOT NULL AND 
					TOTAL_OTHER_SUB <> 0
				<cfelse>
					TOTAL_SUB IS NOT NULL AND 
					TOTAL_SUB <> 0
				</cfif>
				<cfif isDefined("attributes.is_other_money_transfer")>
					AND T_OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
				</cfif>
				<cfif isDefined("attributes.is_project_transfer")>
					<cfif len(project_id_info)>
						AND PROJECT_ID = #project_id_info#
					<cfelse>
						AND PROJECT_ID IS NULL	
					</cfif>
				</cfif>
				<cfif isDefined("attributes.is_acc_type_transfer")>
					<cfif len(acc_type_info)>
						AND ACC_TYPE_ID = #acc_type_info#
					<cfelse>
						AND ACC_TYPE_ID IS NULL	
					</cfif>
				</cfif>
				<cfif isDefined("attributes.is_subscription_transfer")>
					<cfif len(subscription_id_info)>
						AND SUBSCRIPTION_ID = #subscription_id_info#
					<cfelse>
						AND SUBSCRIPTION_ID IS NULL	
					</cfif>
				</cfif>
				ORDER BY
					DUE_DATE
			</cfquery>
			<cfset acik_fat_toplam_agirlik = 0>
			<cfset acik_fat_toplam_agirlik_inv = 0>
			<cfset acik_fat_toplam = 0>
			<cfset due_day = 0>
			<cfset act_day = 0>
			<cfif GET_INV_RECORD.recordcount>
				<cfoutput query="GET_INV_RECORD">
					<cfif len(GET_INV_RECORD.DUE_DATE)>
						<cfset GUN_FARKI = DateDiff("d",DUE_DATE,islem_tarihi2)>
					<cfelse>
						<cfset GUN_FARKI = DateDiff("d",INVOICE_DATE,islem_tarihi2)>
					</cfif>
					<cfset GUN_FARKI_INV = DateDiff("d",INVOICE_DATE,islem_tarihi2)>
					<cfif GUN_FARKI eq 0><cfset GUN_FARKI=1></cfif>
					<cfif isDefined("attributes.is_other_money_transfer")>
						<cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + ((TOTAL_OTHER_SUB*INV_RATE)*GUN_FARKI)>
						<cfset acik_fat_toplam_agirlik_inv = acik_fat_toplam_agirlik_inv + ((TOTAL_OTHER_SUB*INV_RATE)*GUN_FARKI_INV)>
					<cfelse>
						<cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + (TOTAL_SUB*GUN_FARKI)>
						<cfset acik_fat_toplam_agirlik_inv = acik_fat_toplam_agirlik_inv + (TOTAL_SUB*GUN_FARKI_INV)>
					</cfif>
					<cfif isDefined("attributes.is_other_money_transfer")>
						<cfset acik_fat_toplam = acik_fat_toplam+(TOTAL_OTHER_SUB*INV_RATE)>
						<cfset bakiye_ = TOTAL_OTHER_SUB>
					<cfelse>
						<cfset acik_fat_toplam = acik_fat_toplam+TOTAL_SUB>
						<cfset bakiye_ = TOTAL_SUB/INV_RATE>
					</cfif>
					<cfset money = T_OTHER_MONEY>
					<cfif isdefined("attributes.is_row_info")>
						<cfif isDefined("attributes.is_other_money_transfer")>
							<cfif LAST_COMP_REMAINDER.BAKIYE3 gt 0><cfset borc_alacak = "B"><cfelse><cfset borc_alacak = "A"></cfif>
						<cfelse>
							<cfif LAST_COMP_REMAINDER.BAKIYE gt 0><cfset borc_alacak = "B"><cfelse><cfset borc_alacak = "A"></cfif>
						</cfif>
						<cfif isdefined("attributes.is_branch_transfer") and attributes.is_branch_transfer eq 1>
							<cfset branch_id_info = branch_id>
						<cfelse>
							<cfset branch_id_info = ''>
						</cfif>
						<cfif borc_alacak eq 'A'>
							<cfif isdefined("attributes.is_consumer")>
								<cfset from_consumer_id = GET_COMP_REMAINDER_MAIN.CONSUMER_ID>
								<cfset from_cmp_id = ''>
								<cfset from_employee_id = ''>
								<cfset to_consumer_id = ''>
								<cfset to_cmp_id = ''>
								<cfset to_employee_id = ''>
							<cfelseif isdefined("attributes.is_company")>
								<cfset from_consumer_id = ''>
								<cfset from_cmp_id = GET_COMP_REMAINDER_MAIN.COMPANY_ID>
								<cfset from_employee_id = ''>
								<cfset to_consumer_id = ''>
								<cfset to_cmp_id = ''>
								<cfset to_employee_id = ''>
							<cfelse>
								<cfset from_consumer_id = ''>
								<cfset from_cmp_id = ''>
								<cfset from_employee_id = GET_COMP_REMAINDER_MAIN.EMPLOYEE_ID>
								<cfset to_consumer_id = ''>
								<cfset to_cmp_id = ''>
								<cfset to_employee_id = ''>
							</cfif>
						<cfelse>
							<cfif isdefined("attributes.is_consumer")>
								<cfset to_consumer_id = GET_COMP_REMAINDER_MAIN.CONSUMER_ID>
								<cfset to_cmp_id = ''>
								<cfset to_employee_id = ''>
								<cfset from_consumer_id = ''>
								<cfset from_cmp_id = ''>
								<cfset from_employee_id = ''>
							<cfelseif isdefined("attributes.is_company")>
								<cfset to_consumer_id = ''>
								<cfset to_cmp_id = GET_COMP_REMAINDER_MAIN.COMPANY_ID>
								<cfset to_employee_id = ''>
								<cfset from_consumer_id = ''>
								<cfset from_cmp_id = ''>
								<cfset from_employee_id = ''>
							<cfelse>
								<cfset to_consumer_id = ''>
								<cfset to_cmp_id = ''>
								<cfset to_employee_id = GET_COMP_REMAINDER_MAIN.EMPLOYEE_ID>
								<cfset from_consumer_id = ''>
								<cfset from_cmp_id = ''>
								<cfset from_employee_id = ''>
							</cfif>
						</cfif>
						<cfscript>
							new_rate = 1;
							if (isDefined("attributes.is_other_money_transfer"))
								act_value = abs(wrk_round(TOTAL_OTHER_SUB*INV_RATE,2)); 
							else
								act_value = abs(wrk_round(TOTAL_SUB,2)); 
							
							if(isdefined("rate_#T_OTHER_MONEY#") and isdefined("attributes.check_date_rate"))
							{
								new_rate = evaluate("rate_#T_OTHER_MONEY#");
								if(isdefined("new_rate")) act_value = abs(wrk_round(TOTAL_OTHER_SUB*new_rate,2));
							}
							carici
							(
								action_id : -1,
								action_table : 'CARI_ROWS',
								cari_db : donem_db,
								islem_belge_no : GET_INV_RECORD.INVOICE_NUMBER,
								process_cat : form.process_cat,
								workcube_process_type : 40,
								islem_tutari : act_value,
								action_value2 : iif(money2_aktar eq 1,de('#abs(wrk_round(TOTAL_OTHER_SUB*INV_RATE/INV_RATE_2,2))#'),de('')),
								other_money_value : abs(wrk_round(TOTAL_OTHER_SUB,2)),
								other_money : T_OTHER_MONEY,
								islem_tarihi : islem_tarihi,
								paper_act_date : createodbcdatetime(GET_INV_RECORD.INVOICE_DATE),
								due_date : createodbcdate(date_add('d',wrk_round(-1*GUN_FARKI),islem_tarihi2)),
								from_cmp_id : from_cmp_id,
								from_consumer_id : from_consumer_id,
								from_employee_id : from_employee_id,
								acc_type_id : acc_type_id,
								to_cmp_id : to_cmp_id,
								to_consumer_id : to_consumer_id,
								to_employee_id : to_employee_id,
								islem_detay : '#aciklama#',
								action_detail : GET_INV_RECORD.ACTION_DETAIL,
								action_currency : '#session.ep.money#',
								account_card_type : 10,
								project_id : project_id,
								subscription_id : subscription_id,
								from_branch_id : branch_id_info
							);
						</cfscript>
					</cfif>
				</cfoutput>
				<cfif not isdefined("attributes.is_row_info")>
					<cfif isDefined("attributes.is_other_money_transfer")>
						<cfif LAST_COMP_REMAINDER.BAKIYE3 gt 0><cfset borc_alacak = "B"><cfelse><cfset borc_alacak = "A"></cfif>
					<cfelse>
						<cfif LAST_COMP_REMAINDER.BAKIYE gt 0><cfset borc_alacak = "B"><cfelse><cfset borc_alacak = "A"></cfif>
					</cfif>
					<cfif borc_alacak eq 'A'>
						<cfif isdefined("attributes.is_consumer")>
							<cfset from_consumer_id = attributes.consumer_id>
							<cfset from_cmp_id = ''>
							<cfset from_employee_id = ''>
							<cfset to_consumer_id = ''>
							<cfset to_cmp_id = ''>
							<cfset to_employee_id = ''>
						<cfelseif isdefined("attributes.is_company")>
							<cfset from_consumer_id = ''>
							<cfset from_cmp_id = attributes.company_id>
							<cfset from_employee_id = ''>
							<cfset to_consumer_id = ''>
							<cfset to_cmp_id = ''>
							<cfset to_employee_id = ''>
						<cfelse>
							<cfset from_consumer_id = ''>
							<cfset from_cmp_id = ''>
							<cfset from_employee_id = attributes.employee_id>
							<cfset to_consumer_id = ''>
							<cfset to_cmp_id = ''>
							<cfset to_employee_id = ''>
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_consumer")>
							<cfset to_consumer_id = attributes.consumer_id>
							<cfset to_cmp_id = ''>
							<cfset to_employee_id = ''>
							<cfset from_consumer_id = ''>
							<cfset from_cmp_id = ''>
							<cfset from_employee_id = ''>
						<cfelseif isdefined("attributes.is_company")>
							<cfset to_consumer_id = ''>
							<cfset to_cmp_id = attributes.company_id>
							<cfset to_employee_id = ''>
							<cfset from_consumer_id = ''>
							<cfset from_cmp_id = ''>
							<cfset from_employee_id = ''>
						<cfelse>
							<cfset to_consumer_id = ''>
							<cfset to_cmp_id = ''>
							<cfset to_employee_id = attributes.employee_id>
							<cfset from_consumer_id = ''>
							<cfset from_cmp_id = ''>
							<cfset from_employee_id = ''>
						</cfif>
					</cfif>
					<cfif acik_fat_toplam neq 0><cfset due_day = int(acik_fat_toplam_agirlik/acik_fat_toplam)></cfif>
					<cfif acik_fat_toplam neq 0><cfset act_day = int(acik_fat_toplam_agirlik_inv/acik_fat_toplam)></cfif>
					<cfscript>
						kontrol_devir = 0;
						if(isDefined("attributes.is_project_transfer"))
							project_id_info = LAST_COMP_REMAINDER.PROJECT_ID;
						else
							project_id_info = '';
						if(isDefined("attributes.is_acc_type_transfer"))
							acc_type_info = LAST_COMP_REMAINDER.ACC_TYPE_ID;
						else
							acc_type_info = '';
						if(isDefined("attributes.is_subscription_transfer"))
							subscription_id_info = LAST_COMP_REMAINDER.SUBSCRIPTION_ID;
						else
							subscription_id_info = '';
						if(isdefined('attributes.is_other_money_transfer') and attributes.is_other_money_transfer eq 1)
						{
							if(not isdefined("attributes.check_date_rate") and ((LAST_COMP_REMAINDER.BAKIYE lte 0 and LAST_COMP_REMAINDER.BAKIYE3 gt 0) or (LAST_COMP_REMAINDER.BAKIYE gt 0 and LAST_COMP_REMAINDER.BAKIYE3 lte 0)))//eğer kur farjkları kesilmemişse bakiyeler ters olacağı için 2 tane devir kaydedeceğiz
							{
								kontrol_devir = 1;
								//işlem dövizi dolu sistem dövizi 0
								if(LAST_COMP_REMAINDER.BAKIYE3 gt 0)
								{
									from_cmp_id = '';
									from_consumer_id = '';
									from_employee_id = '';
									if(isdefined("attributes.is_consumer"))
									{
										to_consumer_id = attributes.consumer_id;
										to_cmp_id = '';
										to_employee_id = '';
									}
									else if(isdefined("attributes.is_company"))
									{
										to_consumer_id = '';
										to_cmp_id = attributes.company_id;
										to_employee_id = '';
									}
									else
									{
										to_consumer_id = '';
										to_cmp_id = '';
										to_employee_id = attributes.employee_id;
									}
								}
								else
								{
									if(isdefined("attributes.is_consumer"))
									{
										from_consumer_id = attributes.consumer_id;
										from_consumer_id = '';
										from_employee_id = '';
									}
									else if(isdefined("attributes.is_company"))
									{
										from_consumer_id = '';
										from_cmp_id = attributes.company_id;
										from_employee_id = '';
									}
									else
									{
										from_consumer_id = '';
										from_cmp_id = '';
										from_employee_id = attributes.employee_id;
									}
									to_cmp_id = '';
									to_consumer_id = '';
									to_employee_id = '';
								}
								carici
								(
									action_id : -1,
									action_table : 'CARI_ROWS',
									cari_db : donem_db,
									process_cat : form.process_cat,
									workcube_process_type : 40,
									islem_tutari : 0,
									action_value2 : iif(money2_aktar eq 1,de('#abs(LAST_COMP_REMAINDER.BAKIYE2)#'),de('')),
									other_money_value : iif(isDefined("attributes.is_other_money_transfer"),de('#abs(LAST_COMP_REMAINDER.BAKIYE3)#'),de('#abs(LAST_COMP_REMAINDER.BAKIYE)#')),
									other_money : iif(isDefined("attributes.is_other_money_transfer"),de('#LAST_COMP_REMAINDER.OTHER_MONEY#'),de('#session.ep.money#')),
									islem_tarihi : islem_tarihi,
									due_date : createodbcdate(date_add('d',wrk_round(-1*due_day),islem_tarihi2)),
									paper_act_date : createodbcdate(date_add('d',wrk_round(-1*act_day),islem_tarihi2)),
									from_cmp_id : from_cmp_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									acc_type_id : acc_type_info,
									to_cmp_id : to_cmp_id,
									to_consumer_id : to_consumer_id,
									to_employee_id : to_employee_id,
									islem_detay : '#aciklama#',
									action_currency : '#session.ep.money#',
									account_card_type : 10,
									subscription_id : subscription_id_info,
									project_id : project_id_info
								);
								//işlem dövizi 0 sistem dövizi dolu
								if(LAST_COMP_REMAINDER.BAKIYE neq 0)
								{
									act_value = abs(LAST_COMP_REMAINDER.BAKIYE);
									if(isdefined("rate_#LAST_COMP_REMAINDER.OTHER_MONEY#") and isdefined("attributes.check_date_rate"))
									{
										new_rate = evaluate("rate_#LAST_COMP_REMAINDER.OTHER_MONEY#");
										if(isdefined("new_rate")) act_value = wrk_round(abs(LAST_COMP_REMAINDER.BAKIYE3)*new_rate,2);
									}
									if(LAST_COMP_REMAINDER.BAKIYE gt 0)
									{
										from_cmp_id = '';
										from_consumer_id = '';
										from_employee_id = '';
										if(isdefined("attributes.is_consumer"))
										{
											to_consumer_id = attributes.consumer_id;
											to_cmp_id = '';
											to_employee_id = '';
										}
										else if(isdefined("attributes.is_company"))
										{
											to_consumer_id = '';
											to_cmp_id = attributes.company_id;
											to_employee_id = '';
										}
										else
										{
											to_consumer_id = '';
											to_cmp_id = '';
											to_employee_id = attributes.employee_id;
										}
									}
									else
									{
										if(isdefined("attributes.is_consumer"))
										{
											from_consumer_id = attributes.consumer_id;
											from_consumer_id = '';
											from_employee_id = '';
										}
										else if(isdefined("attributes.is_company"))
										{
											from_consumer_id = '';
											from_cmp_id = attributes.company_id;
											from_employee_id = '';
										}
										else
										{
											from_consumer_id = '';
											from_cmp_id = '';
											from_employee_id = attributes.employee_id;
										}
										to_cmp_id = '';
										to_consumer_id = '';
										to_employee_id = '';
									}
									carici
									(
										action_id : -1,
										action_table : 'CARI_ROWS',
										cari_db : donem_db,
										process_cat : form.process_cat,
										workcube_process_type : 40,
										islem_tutari : act_value,
										action_value2 : iif(money2_aktar eq 1,de('#abs(LAST_COMP_REMAINDER.BAKIYE2)#'),de('')),
										other_money_value : 0,
										other_money : iif(isDefined("attributes.is_other_money_transfer"),de('#LAST_COMP_REMAINDER.OTHER_MONEY#'),de('#session.ep.money#')),
										islem_tarihi : islem_tarihi,
										due_date : createodbcdate(date_add('d',wrk_round(-1*due_day),islem_tarihi2)),
										paper_act_date : createodbcdate(date_add('d',wrk_round(-1*act_day),islem_tarihi2)),
										from_cmp_id : from_cmp_id,
										from_consumer_id : from_consumer_id,
										from_employee_id : from_employee_id,
										acc_type_id : acc_type_info,
										to_cmp_id : to_cmp_id,
										to_consumer_id : to_consumer_id,
										to_employee_id : to_employee_id,
										islem_detay : '#aciklama#',
										action_currency : '#session.ep.money#',
										account_card_type : 10,
										subscription_id : subscription_id_info,
										project_id : project_id_info
									);
								}
							}
						}
						if(kontrol_devir eq 0)
						{ 
							act_value = abs(LAST_COMP_REMAINDER.BAKIYE);
							if(isDefined("attributes.is_other_money_transfer") and attributes.is_other_money_transfer eq 1)
							{
								bakiye_other = abs(LAST_COMP_REMAINDER.BAKIYE3);
								money_other = LAST_COMP_REMAINDER.OTHER_MONEY;
								if(isdefined("rate_#money_other#") and isdefined("attributes.check_date_rate"))
								{
									new_rate = evaluate("rate_#money_other#");
									if(isdefined("new_rate")) act_value = wrk_round(bakiye_other*new_rate,2);
								}
							}
							else
							{
								bakiye_other = abs(LAST_COMP_REMAINDER.BAKIYE);
								money_other = session.ep.money;
							}
							carici
							(
								action_id : -1,
								action_table : 'CARI_ROWS',
								cari_db : donem_db,
								process_cat : form.process_cat,
								workcube_process_type : 40,
								islem_tutari :act_value,
								action_value2 : iif(money2_aktar eq 1,de('#abs(LAST_COMP_REMAINDER.BAKIYE2)#'),de('')),
								other_money_value : bakiye_other,
								other_money : money_other,
								islem_tarihi : islem_tarihi,
								due_date : createodbcdate(date_add('d',wrk_round(-1*due_day),islem_tarihi2)),
								paper_act_date : createodbcdate(date_add('d',wrk_round(-1*act_day),islem_tarihi2)),
								from_cmp_id : from_cmp_id,
								from_consumer_id : from_consumer_id,
								from_employee_id : from_employee_id,
								acc_type_id : acc_type_info,
								to_cmp_id : to_cmp_id,
								to_consumer_id : to_consumer_id,
								to_employee_id : to_employee_id,
								islem_detay : '#aciklama#',
								action_currency : '#session.ep.money#',
								account_card_type : 10,
								subscription_id : subscription_id_info,
								project_id : project_id_info
							);
						}
					</cfscript>
				</cfif>
			</cfif>
		</cfloop>		
	</cfif>
</cfloop>
<br/><br/>Aktarım Tamamlandı.
<cfabort>
