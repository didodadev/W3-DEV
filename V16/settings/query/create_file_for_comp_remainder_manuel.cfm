<cfflush interval="100">
<cfquery name="get_period" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #listfirst(attributes.period,';')#
</cfquery>
<cfset aciklama = '#get_period.PERIOD_YEAR+1# DEVIR ISLEMI'>
<cfif isdefined("attributes.is_cheque_voucher_transfer") and attributes.is_cheque_voucher_transfer eq 1>
	<cfset attributes.is_pay_cheques = 1>
</cfif>
<cfif isdefined("attributes.is_consumer")>	<!--- bireysel uye --->
	<cfquery name="get_demand" datasource="#donem_db#">
		SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE 
		CARI_ACTION_ID IN
		(
			SELECT 
				CARI_ACTION_ID
			FROM
				CARI_ROWS 
			WHERE 
				ACTION_TYPE_ID=40 
				AND ACTION_ID= -1
				AND (TO_CONSUMER_ID IS NOT NULL OR FROM_CONSUMER_ID IS NOT NULL) 
				<cfif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')>
					AND ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) = #attributes.consumer_id#
				</cfif>
				<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
					AND ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) IN(SELECT C.CONSUMER_ID FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_CAT_ID IN(#attributes.member_cat#))
				</cfif>
		)
		OR
		(
			CARI_ACTION_ID = 0
			AND CLOSED_ID IN
			(
				SELECT 
					CLOSED_ID 
				FROM 
					CARI_CLOSED 
				WHERE 
					CONSUMER_ID IS NOT NULL
					<cfif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')>
						AND CONSUMER_ID = #attributes.consumer_id#
					</cfif>
					<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
						AND CONSUMER_ID IN(SELECT C.CONSUMER_ID FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_CAT_ID IN(#attributes.member_cat#))
					</cfif>
			)
		)
	</cfquery>
	<cfif get_demand.recordcount>
		<cfquery name="del_demand" datasource="#donem_db#">
			DELETE FROM CARI_CLOSED WHERE CLOSED_ID IN(#valuelist(get_demand.closed_id)#)
		</cfquery>
		<cfquery name="del_demand_row" datasource="#donem_db#">
			DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ID IN(#valuelist(get_demand.closed_id)#)
		</cfquery>
	</cfif>
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
			<cfif isDefined("attributes.is_acc_type_transfer")>,ACC_TYPE_ID</cfif>
			<cfif isDefined("attributes.is_subscription_transfer")>,SUBSCRIPTION_ID</cfif>
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
	<cfquery name="get_demand" datasource="#donem_db#">
		SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE CARI_ACTION_ID IN
		(
			SELECT 
				CARI_ACTION_ID
			FROM
				CARI_ROWS 
			WHERE 
				ACTION_TYPE_ID=40 
				AND ACTION_ID= -1 
				AND (TO_CMP_ID IS NOT NULL OR FROM_CMP_ID IS NOT NULL)
				<cfif (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner')>
					AND ISNULL(TO_CMP_ID,FROM_CMP_ID) = #attributes.company_id#
				</cfif>
				<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
					AND ISNULL(TO_CMP_ID,FROM_CMP_ID) IN(SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANYCAT_ID IN(#attributes.member_cat#))
				</cfif>
		)
		OR
		(
			CARI_ACTION_ID = 0
			AND CLOSED_ID IN
			(
				SELECT 
					CLOSED_ID 
				FROM 
					CARI_CLOSED 
				WHERE 
					COMPANY_ID IS NOT NULL
					<cfif (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner')>
						AND COMPANY_ID = #attributes.company_id#
					</cfif>
					<cfif isdefined("attributes.member_cat") and len(attributes.member_cat)>
						AND COMPANY_ID IN(SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANYCAT_ID IN(#attributes.member_cat#))
					</cfif>
			)
		)
	</cfquery>
	<cfif get_demand.recordcount>
		<cfquery name="del_demand" datasource="#donem_db#">
			DELETE FROM CARI_CLOSED WHERE CLOSED_ID IN(#valuelist(get_demand.closed_id)#)
		</cfquery>
		<cfquery name="del_demand_row" datasource="#donem_db#">
			DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ID IN(#valuelist(get_demand.closed_id)#)
		</cfquery>
	</cfif>
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
	<cfquery name="get_demand" datasource="#donem_db#">
		SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE CARI_ACTION_ID IN
		(
			SELECT 
				CARI_ACTION_ID
			FROM
				CARI_ROWS 
			WHERE 
				ACTION_TYPE_ID=40 
				AND ACTION_ID= -1 
				AND (TO_EMPLOYEE_ID IS NOT NULL OR FROM_EMPLOYEE_ID IS NOT NULL)
				<cfif (isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee')>
					AND ISNULL(TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID) = #attributes.employee_id#
				</cfif>
		)
		OR
		(
			CARI_ACTION_ID = 0
			AND CLOSED_ID IN
			(
				SELECT 
					CLOSED_ID 
				FROM 
					CARI_CLOSED 
				WHERE 
					EMPLOYEE_ID IS NOT NULL
					<cfif (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner')>
						AND EMPLOYEE_ID = #attributes.company_id#
					</cfif>
			)
		)
	</cfquery>
	<cfif get_demand.recordcount>
		<cfquery name="del_demand" datasource="#donem_db#">
			DELETE FROM CARI_CLOSED WHERE CLOSED_ID IN(#valuelist(get_demand.closed_id)#)
		</cfquery>
		<cfquery name="del_demand_row" datasource="#donem_db#">
			DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ID IN(#valuelist(get_demand.closed_id)#)
		</cfquery>
	</cfif>
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
	<cfquery name="get_open_actions" datasource="#donem_eski#">
		SELECT
			*
		FROM 
		(
			SELECT
				CR.PROJECT_ID,
				CR.SUBSCRIPTION_ID,
				CR.ACTION_DETAIL,
				CR.ACTION_DATE,
				CR.ACTION_TABLE,
				CR.ACTION_ID,
				CR.ACTION_TYPE_ID,
				CR.ACTION_CURRENCY_ID,
				CR.PAPER_NO,
				CR.TO_CMP_ID,
				CR.FROM_CMP_ID,
				CR.TO_CONSUMER_ID,
				CR.FROM_CONSUMER_ID,
				CR.FROM_EMPLOYEE_ID,
				CR.TO_EMPLOYEE_ID,
				ISNULL(CR.ACC_TYPE_ID,0) ACC_TYPE_ID,
				ISNULL(CR.FROM_BRANCH_ID,CR.TO_BRANCH_ID) BRANCH_ID,
				CR.ACTION_VALUE CR_ACTION_VALUE,
				CR.ACTION_VALUE NEW_VALUE,
				ISNULL(CR.ACTION_VALUE_2,0) AS NEW_VALUE_2,
				CR.OTHER_CASH_ACT_VALUE NEW_OTHER_VALUE,
				CR.ACTION_CURRENCY_2,
				CR.DUE_DATE,
				CR.OTHER_MONEY,		
				0 TOTAL_CLOSED_AMOUNT,
				CASE WHEN (ACTION_TABLE = 'INVOICE' OR ACTION_TABLE = 'EXPENSE_ITEM_PLANS') THEN 0 ELSE CR.CARI_ACTION_ID END AS CARI_ACTION_ID
			FROM 
				CARI_ROWS CR
			WHERE
				<cfif isdefined("attributes.is_consumer")>
					ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) = #attributes.consumer_id# AND
				<cfelseif isdefined("attributes.is_company")>
					ISNULL(TO_CMP_ID,FROM_CMP_ID) = #attributes.company_id# AND
				<cfelse>
					ISNULL(TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID) = #attributes.employee_id# AND
					CR.ACC_TYPE_ID = #acc_type_id# AND
				</cfif>
				CR.ACTION_TYPE_ID NOT IN (48,49,45,46) AND
				CR.ACTION_ID NOT IN (
                        SELECT 
                            ICR.ACTION_ID 
                        FROM 
                            CARI_CLOSED_ROW ICR,
                            CARI_CLOSED IC
                        WHERE 
                            ICR.CLOSED_ID = IC.CLOSED_ID 
                            AND ICR.CLOSED_AMOUNT IS NOT NULL
                            AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
                            AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
                            AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
                            AND CR.OTHER_MONEY = ICR.OTHER_MONEY	
                            <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                                AND IC.COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                            <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                AND IC.CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                            <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                                AND IC.EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                            </cfif>
                        )
				<cfif isDefined("attributes.is_project_transfer")>
					<cfif len(project_id_info)>
						AND PROJECT_ID = #project_id_info#
					<cfelse>
						AND PROJECT_ID IS NULL	
					</cfif>
				</cfif>
				<cfif isDefined("attributes.is_acc_type_transfer")>
					<cfif len(acc_type_info)>
						AND  CR.ACC_TYPE_ID = #acc_type_info#
					<cfelse>
						AND  CR.ACC_TYPE_ID IS NULL	
					</cfif>
				</cfif>
				<cfif isDefined("attributes.is_subscription_transfer")>
					<cfif len(subscription_id_info)>
						AND SUBSCRIPTION_ID = #subscription_id_info#
					<cfelse>
						AND SUBSCRIPTION_ID IS NULL	
					</cfif>
				</cfif>
				<cfif isdefined("attributes.is_pay_cheques")>
					AND
					(
						(	
							CR.ACTION_TABLE = 'CHEQUE' 
							AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
						)
						OR
						(	
							CR.ACTION_TABLE = 'CHEQUE' 
							AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
						)
						OR 
						(
							CR.ACTION_TABLE = 'VOUCHER' 
							AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
						)
						OR 
						(
							CR.ACTION_TABLE = 'VOUCHER' 
							AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
						)
						OR 
						(
							CR.ACTION_TABLE <> 'CHEQUE' 
							AND CR.ACTION_TABLE <> 'VOUCHER' 
						)
					)
				</cfif>
			UNION ALL
				SELECT
					CR.PROJECT_ID,
					CR.SUBSCRIPTION_ID,
					CR.ACTION_DETAIL,
					CR.ACTION_DATE,
					CR.ACTION_TABLE,
					CR.ACTION_ID,
					CR.ACTION_TYPE_ID,
					CR.ACTION_CURRENCY_ID,
					CR.PAPER_NO,
					CR.TO_CMP_ID,
					CR.FROM_CMP_ID,
					CR.TO_CONSUMER_ID,
					CR.FROM_CONSUMER_ID,
					CR.FROM_EMPLOYEE_ID,
					CR.TO_EMPLOYEE_ID,
					ISNULL(CR.ACC_TYPE_ID,0) ACC_TYPE_ID,
					ISNULL(CR.FROM_BRANCH_ID,CR.TO_BRANCH_ID) BRANCH_ID,
					CR.ACTION_VALUE CR_ACTION_VALUE,
					CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2) NEW_VALUE,
					ISNULL(CR.ACTION_VALUE_2*((CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2))/CR.ACTION_VALUE),0) NEW_VALUE_2,
					CR.OTHER_CASH_ACT_VALUE-ROUND(SUM(ICR.OTHER_CLOSED_AMOUNT),2) NEW_OTHER_VALUE,
					CR.ACTION_CURRENCY_2,
					CR.DUE_DATE,
					CR.OTHER_MONEY,		
					ROUND(SUM(ICR.CLOSED_AMOUNT),2) TOTAL_CLOSED_AMOUNT,
					CASE WHEN (ACTION_TABLE = 'INVOICE' OR ACTION_TABLE = 'EXPENSE_ITEM_PLANS') THEN 0 ELSE CR.CARI_ACTION_ID END AS CARI_ACTION_ID
				FROM 
					CARI_ROWS CR
					LEFT JOIN CARI_CLOSED_ROW ICR ON CR.ACTION_ID = ICR.ACTION_ID AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID,
					CARI_CLOSED
				WHERE		
					<cfif isdefined("attributes.is_consumer")>
						ISNULL(TO_CONSUMER_ID,FROM_CONSUMER_ID) = #attributes.consumer_id# AND
					<cfelseif isdefined("attributes.is_company")>
						ISNULL(TO_CMP_ID,FROM_CMP_ID) = #attributes.company_id# AND
					<cfelse>
						ISNULL(TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID) = #attributes.employee_id# AND
						CR.ACC_TYPE_ID = #acc_type_id# AND
					</cfif>
					CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID AND				
					CR.ACTION_TYPE_ID NOT IN (48,49,45,46) AND 
					ICR.CLOSED_AMOUNT IS NOT NULL AND
					((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
					(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
					CR.OTHER_MONEY = ICR.OTHER_MONEY	
					<cfif isDefined("attributes.is_project_transfer")>
						<cfif len(project_id_info)>
							AND CR.PROJECT_ID = #project_id_info#
						<cfelse>
							AND CR.PROJECT_ID IS NULL	
						</cfif>
					</cfif>
					<cfif isDefined("attributes.is_acc_type_transfer")>
						<cfif len(acc_type_info)>
							AND  CR.ACC_TYPE_ID = #acc_type_info#
						<cfelse>
							AND  CR.ACC_TYPE_ID IS NULL	
						</cfif>
					</cfif>
					<cfif isDefined("attributes.is_subscription_transfer")>
						<cfif len(subscription_id_info)>
							AND SUBSCRIPTION_ID = #subscription_id_info#
						<cfelse>
							AND SUBSCRIPTION_ID IS NULL	
						</cfif>
					</cfif>
					<cfif isdefined("attributes.is_pay_cheques")>
						AND
						(
							(	
								CR.ACTION_TABLE = 'CHEQUE' 
								AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
							)
							OR
							(	
								CR.ACTION_TABLE = 'CHEQUE' 
								AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < #islem_tarihi#)
							)
							OR 
							(
								CR.ACTION_TABLE = 'VOUCHER' 
								AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
							)
							OR 
							(
								CR.ACTION_TABLE = 'VOUCHER' 
								AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #islem_tarihi#)
							)
							OR 
							(
								CR.ACTION_TABLE <> 'CHEQUE' 
								AND CR.ACTION_TABLE <> 'VOUCHER' 
							)
						)
					</cfif>
				GROUP BY
					CR.PROJECT_ID,
					CR.SUBSCRIPTION_ID,
					CR.ACTION_DETAIL,
					CR.ACTION_DATE,
					CR.ACTION_TABLE,
					CR.ACTION_ID,
					CR.ACTION_TYPE_ID,
					CR.ACTION_CURRENCY_ID,
					CR.PAPER_NO,
					CR.TO_CMP_ID,
					CR.FROM_CMP_ID,
					CR.TO_CONSUMER_ID,
					CR.FROM_CONSUMER_ID,
					ISNULL(CR.ACC_TYPE_ID,0),
					CR.TO_EMPLOYEE_ID,
					CR.FROM_EMPLOYEE_ID,
					ISNULL(CR.FROM_BRANCH_ID,CR.TO_BRANCH_ID),
					CR.ACTION_VALUE,
					CR.DUE_DATE,
					CR.OTHER_CASH_ACT_VALUE,
					CR.OTHER_MONEY,
					CR.ACTION_VALUE_2,
					CR.ACTION_CURRENCY_2,
					CASE WHEN (ACTION_TABLE = 'INVOICE' OR ACTION_TABLE = 'EXPENSE_ITEM_PLANS') THEN 0 ELSE CR.CARI_ACTION_ID END
		)T1
		WHERE
			ROUND(TOTAL_CLOSED_AMOUNT,2) <> ROUND(CR_ACTION_VALUE,2)
			AND (ROUND(CR_ACTION_VALUE,2) - ROUND(TOTAL_CLOSED_AMOUNT,2)) > 0.001
	</cfquery>
	<cfoutput query="get_open_actions">
		<cfscript>
			project_id_info = get_open_actions.PROJECT_ID;
			if(isdefined("rate_#get_open_actions.OTHER_MONEY#"))
			{
				new_rate = evaluate("rate_#get_open_actions.OTHER_MONEY#");
			}
			act_value = get_open_actions.NEW_VALUE;
			if(isdefined("new_rate")) act_value = wrk_round(get_open_actions.NEW_OTHER_VALUE*new_rate,2);		
			carici
			(
				action_id : -1,
				action_table : 'CARI_ROWS',
				cari_db : donem_db,
				process_cat : form.process_cat,
				workcube_process_type : 40,
				islem_tutari :act_value,
				islem_belge_no : get_open_actions.PAPER_NO,
				action_value2 : iif(money2_aktar eq 1,de('#abs(get_open_actions.NEW_VALUE_2)#'),de('')),
				other_money_value : get_open_actions.NEW_OTHER_VALUE,
				paper_act_date : createodbcdate(get_open_actions.ACTION_DATE),
				other_money : get_open_actions.OTHER_MONEY,
				islem_tarihi : islem_tarihi,
				due_date : createodbcdatetime(get_open_actions.DUE_DATE),
				from_cmp_id : get_open_actions.from_cmp_id,
				from_consumer_id : get_open_actions.from_consumer_id,
				from_employee_id : get_open_actions.from_employee_id,
				acc_type_id : get_open_actions.acc_type_id,
				to_cmp_id : get_open_actions.to_cmp_id,
				to_consumer_id : get_open_actions.to_consumer_id,
				to_employee_id : get_open_actions.to_employee_id,
				action_detail : get_open_actions.ACTION_DETAIL,
				islem_detay : '#aciklama#',
				action_currency : '#session.ep.money#',
				account_card_type : 10,
				project_id : project_id_info,
				subscription_id : get_open_actions.subscription_id,
				from_branch_id : get_open_actions.branch_id
			);
		</cfscript>
		<cfif isdefined("attributes.is_demand_transfer")><!--- Talep ve emirler aktarılsın seçilmişse açık talep ve emirler yeni döneme aktarılacak --->
			<cfquery name="get_payment" datasource="#donem_eski#">
				SELECT 
					(ISNULL(PAYMENT_VALUE,0)-ABS(ISNULL(CLOSED_AMOUNT,0))) PAY_VALUE,
					(ISNULL(OTHER_PAYMENT_VALUE,0)-ISNULL(OTHER_CLOSED_AMOUNT,0)) OTHER_PAY_VALUE,
					(ISNULL(P_ORDER_VALUE,0)-ABS(ISNULL(CLOSED_AMOUNT,0))) P_ORDER_VALUE,
					(ISNULL(OTHER_P_ORDER_VALUE,0)-ISNULL(OTHER_CLOSED_AMOUNT,0)) OTHER_P_ORDER_VALUE,
					CC.PROCESS_STAGE,
					CC.COMPANY_ID,
					CC.CONSUMER_ID,
					CC.EMPLOYEE_ID,
					CC.PROJECT_ID,
					CC.OTHER_MONEY,
					CC.ACTION_DETAIL,
					CC.PAPER_ACTION_DATE,
					CC.PAPER_DUE_DATE,
					CC.PAYMETHOD_ID,
					CC.RECORD_EMP,
					CC.RECORD_DATE,
					CC.RECORD_IP,
					CR.OTHER_MONEY ROW_MONEY,
					CR.DUE_DATE ROW_DUEDATE
				FROM 
					CARI_CLOSED_ROW CR,
					CARI_CLOSED CC 
				WHERE
					CR.CLOSED_ID = CC.CLOSED_ID
					AND CR.ACTION_ID = #get_open_actions.ACTION_ID#
					AND CR.ACTION_TYPE_ID = #get_open_actions.ACTION_TYPE_ID#
					AND CR.OTHER_MONEY = '#get_open_actions.OTHER_MONEY#'
					<cfif get_open_actions.ACTION_TABLE is 'INVOICE' or get_open_actions.ACTION_TABLE is 'EXPENSE_ITEM_PLANS'>
						AND CR.DUE_DATE = #createodbcdatetime(get_open_actions.DUE_DATE)#
					<cfelse>
						AND CR.CARI_ACTION_ID = #get_open_actions.CARI_ACTION_ID#
					</cfif>
					<cfif isdefined("attributes.is_consumer")>
						AND CC.CONSUMER_ID = #attributes.consumer_id# 
					<cfelseif isdefined("attributes.is_company")>
						AND CC.COMPANY_ID = #attributes.company_id# 
					<cfelse>
						AND CC.EMPLOYEE_ID = #attributes.employee_id# 
					</cfif>
					AND ((ISNULL(IS_DEMAND,0) = 1 AND ISNULL(IS_ORDER,0) = 0 AND ISNULL(IS_CLOSED,0) = 0) OR (ISNULL(IS_DEMAND,0) = 0 AND ISNULL(IS_ORDER,0) = 1 AND ISNULL(IS_CLOSED,0) = 0) OR (ISNULL(IS_DEMAND,0) = 1 AND ISNULL(IS_ORDER,0) = 1 AND ISNULL(IS_CLOSED,0) = 0))
			</cfquery>
			<cfif get_payment.recordcount>
				<cfquery name="add_closed" datasource="#donem_db#" result="GET_MAX_CLOSED">
					INSERT INTO
						CARI_CLOSED
					(
						PROCESS_STAGE,
						COMPANY_ID,
						CONSUMER_ID,
						EMPLOYEE_ID,
						PROJECT_ID,
						OTHER_MONEY,
						IS_CLOSED,							
						DEBT_AMOUNT_VALUE,
						CLAIM_AMOUNT_VALUE,
						DIFFERENCE_AMOUNT_VALUE,
						IS_DEMAND,
						PAYMENT_DEBT_AMOUNT_VALUE,
						PAYMENT_CLAIM_AMOUNT_VALUE,
						PAYMENT_DIFF_AMOUNT_VALUE,
						IS_ORDER,
						P_ORDER_DEBT_AMOUNT_VALUE,
						P_ORDER_CLAIM_AMOUNT_VALUE,
						P_ORDER_DIFF_AMOUNT_VALUE,
						ACTION_DETAIL,
						PAPER_ACTION_DATE,
						PAPER_DUE_DATE,
						PAYMETHOD_ID,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						#get_payment.PROCESS_STAGE#,
						<cfif len(get_payment.COMPANY_ID)>#get_payment.COMPANY_ID#<cfelse>NULL</cfif>,
						<cfif len(get_payment.CONSUMER_ID)>#get_payment.CONSUMER_ID#<cfelse>NULL</cfif>,
						<cfif len(get_payment.EMPLOYEE_ID)>#get_payment.EMPLOYEE_ID#<cfelse>NULL</cfif>,
						<cfif len(get_payment.PROJECT_ID)>#get_payment.PROJECT_ID#<cfelse>NULL</cfif>,
						'#get_payment.OTHER_MONEY#',
						0,
						0,
						0,
						0,
						<cfif get_payment.OTHER_PAY_VALUE gt 0>
							1,
							<cfif len(get_open_actions.to_cmp_id)>
								#get_payment.OTHER_PAY_VALUE#,
								0,
								-1*#get_payment.OTHER_PAY_VALUE#,
							<cfelse>
								0,
								#get_payment.OTHER_PAY_VALUE#,
								#get_payment.OTHER_PAY_VALUE#,
							</cfif>
						<cfelse>
							NULL,
							NULL,
							NULL,
							NULL,	
						</cfif>
						<cfif get_payment.OTHER_P_ORDER_VALUE gt 0>
							1,
							<cfif len(get_open_actions.to_cmp_id)>
								#get_payment.OTHER_P_ORDER_VALUE#,
								0,
								-1*#get_payment.OTHER_P_ORDER_VALUE#,
							<cfelse>
								0,
								#get_payment.OTHER_P_ORDER_VALUE#,
								#get_payment.OTHER_P_ORDER_VALUE#,
							</cfif>
						<cfelse>
							NULL,
							NULL,
							NULL,
							NULL,
						</cfif>
						<cfif len(get_payment.ACTION_DETAIL)>'#get_payment.ACTION_DETAIL#'<cfelse>NULL</cfif>,
						#createodbcdatetime(get_payment.PAPER_ACTION_DATE)#,
						#createodbcdatetime(get_payment.PAPER_DUE_DATE)#,
						<cfif len(get_payment.PAYMETHOD_ID)>#get_payment.PAYMETHOD_ID#<cfelse>NULL</cfif>,
						#get_payment.RECORD_EMP#,
						#createodbcdatetime(get_payment.RECORD_DATE)#,
						'#get_payment.RECORD_IP#'
					)
				</cfquery>
				<cfset GET_MAX_CLOSED.CLOSED_ID = GET_MAX_CLOSED.IDENTITYCOL>
				<cfloop query="get_payment">
					<cfquery name="add_closed_row" datasource="#donem_db#">
						INSERT INTO
							CARI_CLOSED_ROW
						(
							CLOSED_ID,
							CARI_ACTION_ID,
							ACTION_ID,
							ACTION_TYPE_ID,
							ACTION_VALUE,
							CLOSED_AMOUNT,
							OTHER_CLOSED_AMOUNT,
							PAYMENT_VALUE,
							OTHER_PAYMENT_VALUE,
							P_ORDER_VALUE,
							OTHER_P_ORDER_VALUE,							
							OTHER_MONEY,
							DUE_DATE
						)
						VALUES
						(
							#get_max_closed.closed_id#,
							#max_cari_action_id#,
							-1,
							40,
							#get_open_actions.NEW_VALUE#,
							0,
							0,
							<cfif isdefined("attributes.check_date_rate") and isdefined("rate_#get_payment.ROW_MONEY#")>
								#wrk_round(get_payment.OTHER_PAY_VALUE*evaluate("rate_#get_payment.ROW_MONEY#"),4)#,
							<cfelse>
								#wrk_round(get_payment.PAY_VALUE,4)#,
							</cfif>
							#get_payment.OTHER_PAY_VALUE#,
                            <cfif get_payment.OTHER_P_ORDER_VALUE gt 0>
								<cfif isdefined("attributes.check_date_rate") and isdefined("rate_#get_payment.ROW_MONEY#")>
                                    #wrk_round(get_payment.OTHER_P_ORDER_VALUE*evaluate("rate_#get_payment.ROW_MONEY#"),4)#,
                                <cfelse>
                                    #wrk_round(get_payment.P_ORDER_VALUE,4)#,
                                </cfif>
                            <cfelse>
                            	NULL,
                            </cfif>
							#get_payment.OTHER_P_ORDER_VALUE#,
							'#get_payment.ROW_MONEY#',
							#createodbcdatetime(get_payment.ROW_DUEDATE)#
						)
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
	</cfoutput>
</cfloop>
<cfif isdefined("attributes.is_demand_transfer")><!--- Talep ve emirler aktarılsın seçilmişse yazışmalardan gelen açık talep ve emirler yeni döneme aktarılacak --->
	<cfquery name="get_payment" datasource="#donem_eski#">
		SELECT 
			(ISNULL(PAYMENT_VALUE,0)-ABS(ISNULL(CLOSED_AMOUNT,0))) PAY_VALUE,
			(ISNULL(OTHER_PAYMENT_VALUE,0)-ISNULL(OTHER_CLOSED_AMOUNT,0)) OTHER_PAY_VALUE,
			(ISNULL(P_ORDER_VALUE,0)-ABS(ISNULL(CLOSED_AMOUNT,0))) P_ORDER_VALUE,
			(ISNULL(OTHER_P_ORDER_VALUE,0)-ISNULL(OTHER_CLOSED_AMOUNT,0)) OTHER_P_ORDER_VALUE,
			CC.PROCESS_STAGE,
			CC.COMPANY_ID,
			CC.CONSUMER_ID,
			CC.EMPLOYEE_ID,
			CC.PROJECT_ID,
			CC.OTHER_MONEY,
			CC.ACTION_DETAIL,
			CC.PAPER_ACTION_DATE,
			CC.PAPER_DUE_DATE,
			CC.PAYMETHOD_ID,
			CC.RECORD_EMP,
			CC.RECORD_DATE,
			CC.RECORD_IP,
			CR.OTHER_MONEY ROW_MONEY,
			CR.DUE_DATE ROW_DUEDATE
		FROM 
			CARI_CLOSED_ROW CR,
			CARI_CLOSED CC 
		WHERE
			CR.CLOSED_ID = CC.CLOSED_ID
			AND CR.ACTION_ID = 0
			AND ((ISNULL(IS_DEMAND,0) = 1 AND ISNULL(IS_ORDER,0) = 0 AND ISNULL(IS_CLOSED,0) = 0) OR (ISNULL(IS_DEMAND,0) = 0 AND ISNULL(IS_ORDER,0) = 1 AND ISNULL(IS_CLOSED,0) = 0) OR (ISNULL(IS_DEMAND,0) = 1 AND ISNULL(IS_ORDER,0) = 1 AND ISNULL(IS_CLOSED,0) = 0))
			<cfif isdefined("attributes.is_consumer")>
				AND CC.CONSUMER_ID IS NOT NULL
			<cfelseif isdefined("attributes.is_company")>
				AND CC.COMPANY_ID IS NOT NULL
			<cfelse>
				AND CC.EMPLOYEE_ID IS NOT NULL
			</cfif>
			<cfif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company) and member_type is 'consumer')>
				AND CC.CONSUMER_ID = #attributes.consumer_id#
			</cfif>
			<cfif (isdefined('attributes.company_id') and  len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company) and member_type is 'partner')>
				AND CC.COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif (isdefined('attributes.employee_id') and  len(attributes.employee_id) and isdefined("attributes.company") and len(attributes.company) and member_type is 'employee')>
				AND CC.EMPLOYEE_ID = #attributes.employee_id#
			</cfif>
	</cfquery>
	<cfoutput query="get_payment">
		<cfquery name="add_closed" datasource="#donem_db#" result="GET_MAX_CLOSED">
			INSERT INTO
				CARI_CLOSED
			(
				PROCESS_STAGE,
				COMPANY_ID,
				CONSUMER_ID,
				EMPLOYEE_ID,
				PROJECT_ID,
				OTHER_MONEY,
				IS_CLOSED,							
				DEBT_AMOUNT_VALUE,
				CLAIM_AMOUNT_VALUE,
				DIFFERENCE_AMOUNT_VALUE,
				IS_DEMAND,
				PAYMENT_DEBT_AMOUNT_VALUE,
				PAYMENT_CLAIM_AMOUNT_VALUE,
				PAYMENT_DIFF_AMOUNT_VALUE,
				IS_ORDER,
				P_ORDER_DEBT_AMOUNT_VALUE,
				P_ORDER_CLAIM_AMOUNT_VALUE,
				P_ORDER_DIFF_AMOUNT_VALUE,
				ACTION_DETAIL,
				PAPER_ACTION_DATE,
				PAPER_DUE_DATE,
				PAYMETHOD_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				#get_payment.PROCESS_STAGE#,
				<cfif len(get_payment.COMPANY_ID)>#get_payment.COMPANY_ID#<cfelse>NULL</cfif>,
				<cfif len(get_payment.CONSUMER_ID)>#get_payment.CONSUMER_ID#<cfelse>NULL</cfif>,
				<cfif len(get_payment.EMPLOYEE_ID)>#get_payment.EMPLOYEE_ID#<cfelse>NULL</cfif>,
				<cfif len(get_payment.PROJECT_ID)>#get_payment.PROJECT_ID#<cfelse>NULL</cfif>,
				'#get_payment.OTHER_MONEY#',
				0,
				0,
				0,
				0,
				<cfif get_payment.OTHER_PAY_VALUE gt 0>
					1,
					<cfif len(get_open_actions.to_cmp_id)>
						#get_payment.OTHER_PAY_VALUE#,
						0,
						-1*#get_payment.OTHER_PAY_VALUE#,
					<cfelse>
						0,
						#get_payment.OTHER_PAY_VALUE#,
						#get_payment.OTHER_PAY_VALUE#,
					</cfif>
				<cfelse>
					NULL,
					NULL,
					NULL,
					NULL,	
				</cfif>
				<cfif get_payment.OTHER_P_ORDER_VALUE gt 0>
					1,
					<cfif len(get_open_actions.to_cmp_id)>
						#get_payment.OTHER_P_ORDER_VALUE#,
						0,
						-1*#get_payment.OTHER_P_ORDER_VALUE#,
					<cfelse>
						0,
						#get_payment.OTHER_P_ORDER_VALUE#,
						#get_payment.OTHER_P_ORDER_VALUE#,
					</cfif>
				<cfelse>
					NULL,
					NULL,
					NULL,
					NULL,
				</cfif>
				<cfif len(get_payment.ACTION_DETAIL)>'#get_payment.ACTION_DETAIL#'<cfelse>NULL</cfif>,
				#createodbcdatetime(get_payment.PAPER_ACTION_DATE)#,
				#createodbcdatetime(get_payment.PAPER_DUE_DATE)#,
				<cfif len(get_payment.PAYMETHOD_ID)>#get_payment.PAYMETHOD_ID#<cfelse>NULL</cfif>,
				#get_payment.RECORD_EMP#,
				#createodbcdatetime(get_payment.RECORD_DATE)#,
				'#get_payment.RECORD_IP#'
			)
		</cfquery>
		<cfset GET_MAX_CLOSED.CLOSED_ID = GET_MAX_CLOSED.IDENTITYCOL>
		<cfquery name="add_closed_row" datasource="#donem_db#">
			INSERT INTO
				CARI_CLOSED_ROW
			(
				CLOSED_ID,
				CARI_ACTION_ID,
				ACTION_ID,
				ACTION_TYPE_ID,
				ACTION_VALUE,
				CLOSED_AMOUNT,
				OTHER_CLOSED_AMOUNT,
				PAYMENT_VALUE,
				OTHER_PAYMENT_VALUE,
				P_ORDER_VALUE,
				OTHER_P_ORDER_VALUE,							
				OTHER_MONEY,
				DUE_DATE
			)
			VALUES
			(
				#get_max_closed.closed_id#,
				0,
				0,
				0,
				0,
				0,
				0,
				<cfif isdefined("attributes.check_date_rate") and isdefined("rate_#get_payment.ROW_MONEY#")>
					#wrk_round(get_payment.OTHER_PAY_VALUE*evaluate("rate_#get_payment.ROW_MONEY#"),4)#,
				<cfelse>
					#wrk_round(get_payment.PAY_VALUE,4)#,
				</cfif>
				#get_payment.OTHER_PAY_VALUE#,
                <cfif get_payment.OTHER_P_ORDER_VALUE gt 0>
					<cfif isdefined("attributes.check_date_rate") and isdefined("rate_#get_payment.ROW_MONEY#")>
                        #wrk_round(get_payment.OTHER_P_ORDER_VALUE*evaluate("rate_#get_payment.ROW_MONEY#"),4)#,
                    <cfelse>
                        #wrk_round(get_payment.P_ORDER_VALUE,4)#,
                    </cfif>
                <cfelse>
                	NULL,
                </cfif>
				#get_payment.OTHER_P_ORDER_VALUE#,
				'#get_payment.ROW_MONEY#',
				#createodbcdatetime(get_payment.ROW_DUEDATE)#
			)
		</cfquery>
	</cfoutput>
</cfif>
<br/><br/>Aktarım Tamamlandı.
<cfabort>
