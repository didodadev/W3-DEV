<cfset attributes.acc_type_id = ''>
<cfif isdefined("attributes.employee_id_new") and listlen(attributes.employee_id_new,'_') eq 2>
	<cfset attributes.acc_type_id = listlast(attributes.employee_id_new,'_')>
	<cfset attributes.employee_id_new = listfirst(attributes.employee_id_new,'_')>
</cfif>
<cfset ch_alias = "CARI_CLOSED.">
<cfinclude template="../../objects/query/get_acc_types.cfm">
<cfquery name="GET_CARI_ROWS" datasource="#DSN2#">
	SELECT 
		*
	FROM 
	(
		<!--- Fatura dışında kısmi kapanmış olan işlemler --->
		SELECT
			CR.ACTION_TABLE,
			CR.CARI_ACTION_ID,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.ACTION_VALUE,
			CR.ACTION_DATE,
			CR.DUE_DATE,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,
			SUM(ISNULL(ICR.CLOSED_AMOUNT,0)) DSP_TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_CLOSED_AMOUNT,0)) DSP_OTHER_CLOSED_AMOUNT,
			<cfif attributes.act_type eq 2>
				SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_CLOSED_AMOUNT,
				SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_CLOSED_AMOUNT,
			<cfelse>
				SUM(ISNULL(ICR.CLOSED_AMOUNT,0)) TOTAL_CLOSED_AMOUNT,
				SUM(ISNULL(ICR.OTHER_CLOSED_AMOUNT,0)) OTHER_CLOSED_AMOUNT,
			</cfif>
			SUM(ISNULL(ICR.PAYMENT_VALUE,0)) TOTAL_PAYMENT_VALUE,
			SUM(ISNULL(ICR.OTHER_PAYMENT_VALUE,0)) OTHER_PAYMENT_VALUE,
			SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_P_ORDER_VALUE,
			SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_P_ORDER_VALUE,
			ICR.OTHER_MONEY I_OTHER_MONEY,
            CR.PROCESS_CAT
		FROM 
			CARI_ROWS CR
            LEFT JOIN CARI_CLOSED_ROW ICR ON CR.ACTION_ID = ICR.ACTION_ID AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID
			,CARI_CLOSED
		WHERE
			CR.ACTION_VALUE > 0 AND
			CR.OTHER_CASH_ACT_VALUE > 0 AND
			CR.ACTION_TABLE <> 'INVOICE' AND
			<cfif not show_rev_paym_actions and attributes.act_type neq 1>
				CR.ACTION_TYPE_ID IN (120,121,122) AND
			</cfif>
			<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
				 #control_acc_type_list# AND 
			</cfif>
			<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
				(TO_CMP_ID =  #attributes.member_id# OR FROM_CMP_ID =  #attributes.member_id#) AND
				CARI_CLOSED.COMPANY_ID = #attributes.member_id#  AND 
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				(TO_CONSUMER_ID =  #attributes.consumer_id# OR FROM_CONSUMER_ID =  #attributes.consumer_id#) AND
				CARI_CLOSED.CONSUMER_ID = #attributes.consumer_id#  AND 
			<cfelse>
				(TO_EMPLOYEE_ID =  #attributes.employee_id_new# OR FROM_EMPLOYEE_ID =  #attributes.employee_id_new#) AND
				CARI_CLOSED.EMPLOYEE_ID = #attributes.employee_id_new#  AND 
			</cfif>
			<cfif len(attributes.acc_type_id)>
				CR.ACC_TYPE_ID = #attributes.acc_type_id# AND
			</cfif>		
			CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID AND				
			<!--- CR.ACTION_ID = ICR.ACTION_ID AND
			CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND ---> <!--- left join alındığı için where koşulundan kaldırıldı --->
			CR.ACTION_TYPE_ID NOT IN (45,46) AND
			((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
			(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
			CR.OTHER_MONEY = ICR.OTHER_MONEY AND	
			<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
				ICR.ACTION_ID IN (SELECT ICRR.ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.COMPANY_ID = #attributes.member_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY)
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				ICR.ACTION_ID IN (SELECT ICRR.ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.CONSUMER_ID = #attributes.consumer_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY)
			<cfelse>
				ICR.ACTION_ID IN (SELECT ICRR.ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.EMPLOYEE_ID = #attributes.employee_id_new# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY)
			</cfif>
			<cfif isdefined("attributes.due_date1") and len(attributes.due_date1)>
				AND (CR.DUE_DATE >= #attributes.due_date1#
				OR CR.DUE_DATE IS NULL)
			</cfif>
			<cfif isdefined("attributes.due_date2") and len(attributes.due_date2)>
				AND (CR.DUE_DATE <= #attributes.due_date2#
				OR CR.DUE_DATE IS NULL)
			</cfif>
			<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date") and isdate(attributes.start_date) and isdate(attributes.finish_date)>
				AND CR.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
			<cfelseif isdefined("attributes.start_date") and isdate(attributes.start_date)>
				AND CR.ACTION_DATE >= #attributes.start_date#
			<cfelseif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
				AND CR.ACTION_DATE <= #attributes.finish_date#
			</cfif>
			<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
				AND CR.OTHER_MONEY = '#attributes.money_type#'
			</cfif>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
				AND CR.PROJECT_ID = #attributes.project_id#
			</cfif>
		GROUP BY
			CR.ACTION_TABLE,
			CR.CARI_ACTION_ID,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.ACTION_VALUE,
			CR.ACTION_DATE,
			CR.DUE_DATE,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,
			ICR.OTHER_MONEY,
            CR.PROCESS_CAT			
		UNION ALL
		<!--- Fatura dışında kapanmamış olan işlemler --->
		SELECT
			CR.ACTION_TABLE,
			CR.CARI_ACTION_ID,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.ACTION_VALUE,
			CR.ACTION_DATE,
			CR.DUE_DATE,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,				
			0 DSP_TOTAL_CLOSED_AMOUNT,
			0 DSP_OTHER_CLOSED_AMOUNT,
			0 TOTAL_CLOSED_AMOUNT,
			0 OTHER_CLOSED_AMOUNT,
			0 TOTAL_PAYMENT_VALUE,
			0 OTHER_PAYMENT_VALUE,
			0 TOTAL_P_ORDER_VALUE,
			0 OTHER_P_ORDER_VALUE,
			'' I_OTHER_MONEY,
            CR.PROCESS_CAT
		FROM 
			CARI_ROWS CR
		WHERE
			CR.ACTION_VALUE > 0 AND
			CR.OTHER_CASH_ACT_VALUE > 0 AND
			CR.ACTION_TABLE <> 'INVOICE' AND
			<cfif not show_rev_paym_actions and attributes.act_type neq 1>
				CR.ACTION_TYPE_ID IN (120,121,122) AND
			</cfif>
			<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
				(TO_CMP_ID =  #attributes.member_id# OR FROM_CMP_ID =  #attributes.member_id#) AND
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				(TO_CONSUMER_ID =  #attributes.consumer_id# OR FROM_CONSUMER_ID =  #attributes.consumer_id#) AND
			<cfelse>
				(TO_EMPLOYEE_ID =  #attributes.employee_id_new# OR FROM_EMPLOYEE_ID =  #attributes.employee_id_new#) AND
			</cfif>
			<cfif len(attributes.acc_type_id)>
				CR.ACC_TYPE_ID = #attributes.acc_type_id# AND
			</cfif>
				CR.ACTION_TYPE_ID NOT IN (45,46) AND
			<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
				CR.CARI_ACTION_ID NOT IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.COMPANY_ID = #attributes.member_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY)
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				CR.CARI_ACTION_ID NOT IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.CONSUMER_ID = #attributes.consumer_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY)
			<cfelse>
				CR.CARI_ACTION_ID NOT IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.EMPLOYEE_ID = #attributes.employee_id_new# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY)
			</cfif>
			<cfif isdefined("attributes.due_date1") and len(attributes.due_date1)>
				AND (CR.DUE_DATE >= #attributes.due_date1#
				OR CR.DUE_DATE IS NULL)
			</cfif>
			<cfif isdefined("attributes.due_date2") and len(attributes.due_date2)>
				AND (CR.DUE_DATE <= #attributes.due_date2#
				OR CR.DUE_DATE IS NULL)
			</cfif>
			<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date") and isdate(attributes.start_date) and isdate(attributes.finish_date)>
				AND CR.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
			<cfelseif isdefined("attributes.start_date") and isdate(attributes.start_date)>
				AND CR.ACTION_DATE >= #attributes.start_date#
			<cfelseif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
				AND CR.ACTION_DATE <= #attributes.finish_date#
			</cfif>
			<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
				AND CR.OTHER_MONEY = '#attributes.money_type#'
			</cfif>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
				AND CR.PROJECT_ID = #attributes.project_id#
			</cfif>	
		UNION ALL
	<!--- Kısmi Kapanmış Satış faturaları --->
	SELECT
		CR.ACTION_TABLE,
		CR.CARI_ACTION_ID,
		CR.ACTION_NAME,
		CR.ACTION_ID,
		CR.PAPER_NO,
		CR.ACTION_TYPE_ID,
		CR.TO_CMP_ID,
		CR.FROM_CMP_ID,
		CR.TO_CONSUMER_ID,
		CR.FROM_CONSUMER_ID,
		CR.TO_EMPLOYEE_ID,
		CR.FROM_EMPLOYEE_ID,
		CR.ACTION_VALUE,
		CR.ACTION_DATE,
		CR.DUE_DATE,
		CR.OTHER_CASH_ACT_VALUE,
		CR.OTHER_MONEY,	
		SUM(ISNULL(ICR.CLOSED_AMOUNT,0)) DSP_TOTAL_CLOSED_AMOUNT,
		SUM(ISNULL(ICR.OTHER_CLOSED_AMOUNT,0)) DSP_OTHER_CLOSED_AMOUNT,
		<cfif attributes.act_type eq 2>
			SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_CLOSED_AMOUNT,
		<cfelse>
			SUM(ISNULL(ICR.CLOSED_AMOUNT,0)) TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_CLOSED_AMOUNT,0)) OTHER_CLOSED_AMOUNT,
		</cfif>			
		SUM(ISNULL(ICR.PAYMENT_VALUE,0)) TOTAL_PAYMENT_VALUE,
		SUM(ISNULL(ICR.OTHER_PAYMENT_VALUE,0)) OTHER_PAYMENT_VALUE,
		SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_P_ORDER_VALUE,
		SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_P_ORDER_VALUE,
		ICR.OTHER_MONEY I_OTHER_MONEY,
        CR.PROCESS_CAT
	FROM 
		INVOICE I,
		CARI_ROWS CR
		LEFT JOIN CARI_CLOSED_ROW ICR ON CR.ACTION_ID = ICR.ACTION_ID AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID ,
		CARI_CLOSED
	WHERE
		CR.ACTION_VALUE > 0 AND
		CR.OTHER_CASH_ACT_VALUE > 0 AND
		CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID AND				
		
		CR.ACTION_TYPE_ID NOT IN (45,46) AND
		((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
		(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
		CR.OTHER_MONEY = ICR.OTHER_MONEY AND
	<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
		(TO_CMP_ID =  #attributes.member_id# OR FROM_CMP_ID =  #attributes.member_id#) AND
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		(TO_CONSUMER_ID =  #attributes.consumer_id# OR FROM_CONSUMER_ID =  #attributes.consumer_id#) AND
	<cfelse>
		(TO_EMPLOYEE_ID =  #attributes.employee_id_new# OR FROM_EMPLOYEE_ID =  #attributes.employee_id_new#) AND
	</cfif>
	<cfif len(attributes.acc_type_id)>
		CR.ACC_TYPE_ID = #attributes.acc_type_id# AND
	</cfif>
	<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
		 #control_acc_type_list# AND
	</cfif>
	<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
		CR.CARI_ACTION_ID IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.COMPANY_ID = #attributes.member_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		CR.CARI_ACTION_ID IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.CONSUMER_ID = #attributes.consumer_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
	<cfelse>
		CR.CARI_ACTION_ID IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.EMPLOYEE_ID = #attributes.employee_id_new# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
	</cfif>
		I.INVOICE_ID = CR.ACTION_ID AND
		I.INVOICE_CAT = CR.ACTION_TYPE_ID AND
		<cfif isdefined("attributes.invoice_type") and len(attributes.invoice_type) and attributes.invoice_type eq 1>	
			(I.PURCHASE_SALES = 1) AND
		<cfelse>
			(I.INVOICE_ID NOT IN(SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE INVOICE_ID IS NOT NULL) OR I.PURCHASE_SALES = 1) AND
		</cfif>
		I.IS_IPTAL = 0
	<cfif isdefined("attributes.due_date1") and len(attributes.due_date1)>
		AND (CR.DUE_DATE >= #attributes.due_date1#
		OR CR.DUE_DATE IS NULL)
	</cfif>
	<cfif isdefined("attributes.due_date2") and len(attributes.due_date2)>
		AND (CR.DUE_DATE <= #attributes.due_date2#
		OR CR.DUE_DATE IS NULL)
	</cfif>
	<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date") and isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND CR.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdefined("attributes.start_date") and isdate(attributes.start_date)>
		AND CR.ACTION_DATE >= #attributes.start_date#
	<cfelseif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		AND CR.ACTION_DATE <= #attributes.finish_date#
	</cfif>
	<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
		AND CR.OTHER_MONEY = '#attributes.money_type#'
	</cfif>
	<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
		AND CR.PROJECT_ID = #attributes.project_id#
	</cfif>
	GROUP BY
		CR.ACTION_TABLE,
		CR.CARI_ACTION_ID,
		CR.ACTION_NAME,
		CR.ACTION_ID,
		CR.PAPER_NO,
		CR.ACTION_TYPE_ID,
		CR.TO_CMP_ID,
		CR.FROM_CMP_ID,
		CR.TO_CONSUMER_ID,
		CR.FROM_CONSUMER_ID,
		CR.TO_EMPLOYEE_ID,
		CR.FROM_EMPLOYEE_ID,
		CR.ACTION_VALUE,
		CR.ACTION_DATE,
		CR.DUE_DATE,
		CR.OTHER_CASH_ACT_VALUE,
		CR.OTHER_MONEY,
		ICR.OTHER_MONEY,
        CR.PROCESS_CAT
	UNION ALL
	<!--- Açık Satış faturaları --->
	SELECT
		CR.ACTION_TABLE,
		CR.CARI_ACTION_ID,
		CR.ACTION_NAME,
		CR.ACTION_ID,
		CR.PAPER_NO,
		CR.ACTION_TYPE_ID,
		CR.TO_CMP_ID,
		CR.FROM_CMP_ID,
		CR.TO_CONSUMER_ID,
		CR.FROM_CONSUMER_ID,
		CR.TO_EMPLOYEE_ID,
		CR.FROM_EMPLOYEE_ID,
		CR.ACTION_VALUE,
		CR.ACTION_DATE,
		CR.DUE_DATE,
		CR.OTHER_CASH_ACT_VALUE,
		CR.OTHER_MONEY,				
		0 DSP_TOTAL_CLOSED_AMOUNT,
		0 DSP_OTHER_CLOSED_AMOUNT,
		0 TOTAL_CLOSED_AMOUNT,
		0 OTHER_CLOSED_AMOUNT,
		0 TOTAL_PAYMENT_VALUE,
		0 OTHER_PAYMENT_VALUE,
		0 TOTAL_P_ORDER_VALUE,
		0 OTHER_P_ORDER_VALUE,			
		'' I_OTHER_MONEY,
        CR.PROCESS_CAT
	FROM 
		INVOICE I,
		CARI_ROWS CR
	WHERE
	<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
		(TO_CMP_ID =  #attributes.member_id# OR FROM_CMP_ID =  #attributes.member_id#) AND
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		(TO_CONSUMER_ID =  #attributes.consumer_id# OR FROM_CONSUMER_ID =  #attributes.consumer_id#) AND
	<cfelse>
		(TO_EMPLOYEE_ID =  #attributes.employee_id_new# OR FROM_EMPLOYEE_ID =  #attributes.employee_id_new#) AND
	</cfif>
	<cfif len(attributes.acc_type_id)>
		CR.ACC_TYPE_ID = #attributes.acc_type_id# AND
	</cfif>
		CR.ACTION_TYPE_ID NOT IN (45,46) AND
	<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
		CR.CARI_ACTION_ID NOT IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.COMPANY_ID = #attributes.member_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		CR.CARI_ACTION_ID NOT IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.CONSUMER_ID = #attributes.consumer_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
	<cfelse>	
		CR.CARI_ACTION_ID NOT IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.EMPLOYEE_ID = #attributes.employee_id_new# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
	</cfif>
		(CR.ACTION_VALUE > 0
		OR (CR.OTHER_CASH_ACT_VALUE > 0)) AND
		I.INVOICE_ID = CR.ACTION_ID AND
		I.INVOICE_CAT = CR.ACTION_TYPE_ID AND
		<cfif isdefined("attributes.invoice_type") and len(attributes.invoice_type) and attributes.invoice_type eq 1>	
			(I.PURCHASE_SALES = 1) AND
		<cfelse>
			(I.INVOICE_ID NOT IN(SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE INVOICE_ID IS NOT NULL) OR I.PURCHASE_SALES = 1) AND
		</cfif>
		I.IS_IPTAL = 0		
	<cfif isdefined("attributes.due_date1") and len(attributes.due_date1)>
		AND (CR.DUE_DATE >= #attributes.due_date1#
		OR CR.DUE_DATE IS NULL)
	</cfif>
	<cfif isdefined("attributes.due_date2") and len(attributes.due_date2)>
		AND (CR.DUE_DATE <= #attributes.due_date2#
		OR CR.DUE_DATE IS NULL)
	</cfif>
	<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date") and isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND CR.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdefined("attributes.start_date") and isdate(attributes.start_date)>
		AND CR.ACTION_DATE >= #attributes.start_date#
	<cfelseif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		AND CR.ACTION_DATE <= #attributes.finish_date#
	</cfif>
	<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
		AND CR.OTHER_MONEY = '#attributes.money_type#'
	</cfif>
	<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
		AND CR.PROJECT_ID = #attributes.project_id#
	</cfif>
	<cfif (isdefined("attributes.invoice_type") and ((len(attributes.invoice_type) and attributes.invoice_type eq 1) or not len(attributes.invoice_type))) or not isdefined("attributes.invoice_type")>	
	UNION ALL
		<!--- Kısmi Kapanmış ve kontrol edilmiş Alış faturaları --->
		SELECT
			CR.ACTION_TABLE,
			CR.CARI_ACTION_ID,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.ACTION_VALUE,
			CR.ACTION_DATE,
			CR.DUE_DATE,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,
			SUM(ISNULL(ICR.CLOSED_AMOUNT,0)) DSP_TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_CLOSED_AMOUNT,0)) DSP_OTHER_CLOSED_AMOUNT,
			<cfif attributes.act_type eq 2>
				SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_CLOSED_AMOUNT,
				SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_CLOSED_AMOUNT,
			<cfelse>
				SUM(ISNULL(ICR.CLOSED_AMOUNT,0)) TOTAL_CLOSED_AMOUNT,
				SUM(ISNULL(ICR.OTHER_CLOSED_AMOUNT,0)) OTHER_CLOSED_AMOUNT,
			</cfif>				
			SUM(ISNULL(ICR.PAYMENT_VALUE,0)) TOTAL_PAYMENT_VALUE,
			SUM(ISNULL(ICR.OTHER_PAYMENT_VALUE,0)) OTHER_PAYMENT_VALUE,
			SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_P_ORDER_VALUE,
			SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_P_ORDER_VALUE,
			ICR.OTHER_MONEY I_OTHER_MONEY,
            CR.PROCESS_CAT
		FROM 
			INVOICE I,
			INVOICE_CONTROL IC,
			CARI_ROWS CR
            LEFT JOIN CARI_CLOSED_ROW ICR ON CR.ACTION_ID = ICR.ACTION_ID AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID 
			,CARI_CLOSED
		WHERE
			CR.ACTION_VALUE > 0 AND
			CR.OTHER_CASH_ACT_VALUE > 0 AND
			CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID AND				
			CR.ACTION_ID = ICR.ACTION_ID AND
			CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND
			CR.ACTION_TYPE_ID NOT IN (45,46) AND
			((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
			(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
			CR.OTHER_MONEY = ICR.OTHER_MONEY AND	
			<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
				(TO_CMP_ID =  #attributes.member_id# OR FROM_CMP_ID =  #attributes.member_id#) AND
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				(TO_CONSUMER_ID =  #attributes.consumer_id# OR FROM_CONSUMER_ID =  #attributes.consumer_id#) AND
			<cfelse>
				(TO_EMPLOYEE_ID =  #attributes.employee_id_new# OR FROM_EMPLOYEE_ID =  #attributes.employee_id_new#) AND
			</cfif>
			<cfif len(attributes.acc_type_id)>
				CR.ACC_TYPE_ID = #attributes.acc_type_id# AND
			</cfif>
			<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
				 #control_acc_type_list# AND
			</cfif>
			<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
				CR.CARI_ACTION_ID IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.COMPANY_ID = #attributes.member_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				CR.CARI_ACTION_ID IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.CONSUMER_ID = #attributes.consumer_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
			<cfelse>
				CR.CARI_ACTION_ID IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.EMPLOYEE_ID = #attributes.employee_id_new# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
			</cfif>
			I.INVOICE_ID = CR.ACTION_ID AND
			I.INVOICE_CAT = CR.ACTION_TYPE_ID AND
			IC.INVOICE_ID = CR.ACTION_ID AND
			IC.IS_CONTROL = 1 AND	
			IC.INVOICE_ID = I.INVOICE_ID AND
			I.IS_IPTAL = 0 AND
			I.PURCHASE_SALES = 0
		<cfif isdefined("attributes.due_date1") and len(attributes.due_date1)>
			AND (CR.DUE_DATE >= #attributes.due_date1#
			OR CR.DUE_DATE IS NULL)
		</cfif>
		<cfif isdefined("attributes.due_date2") and len(attributes.due_date2)>
			AND (CR.DUE_DATE <= #attributes.due_date2#
			OR CR.DUE_DATE IS NULL)
		</cfif>
		<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date") and isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND CR.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdefined("attributes.start_date") and isdate(attributes.start_date)>
			AND CR.ACTION_DATE >= #attributes.start_date#
		<cfelseif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			AND CR.ACTION_DATE <= #attributes.finish_date#
		</cfif>
		<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
			AND CR.OTHER_MONEY = '#attributes.money_type#'
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			AND CR.PROJECT_ID = #attributes.project_id#
		</cfif>
		<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and len(attributes.employee_name)>
			AND IC.RECORD_EMP = #attributes.record_emp_id#
		</cfif>	
		GROUP BY
			CR.ACTION_TABLE,
			CR.CARI_ACTION_ID,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.ACTION_VALUE,
			CR.ACTION_DATE,
			CR.DUE_DATE,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,
			ICR.OTHER_MONEY,
            CR.PROCESS_CAT
		UNION ALL
		<!--- Açık ve kontrol edilmiş Alış faturaları --->
		SELECT
			CR.ACTION_TABLE,
			CR.CARI_ACTION_ID,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.ACTION_VALUE,
			CR.ACTION_DATE,
			CR.DUE_DATE,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,				
			0 DSP_TOTAL_CLOSED_AMOUNT,
			0 DSP_OTHER_CLOSED_AMOUNT,
			0 TOTAL_CLOSED_AMOUNT,
			0 OTHER_CLOSED_AMOUNT,
			0 TOTAL_PAYMENT_VALUE,
			0 OTHER_PAYMENT_VALUE,
			0 TOTAL_P_ORDER_VALUE,
			0 OTHER_P_ORDER_VALUE,
			'' I_OTHER_MONEY,
            CR.PROCESS_CAT
		FROM 
			INVOICE I,
			INVOICE_CONTROL IC,
			CARI_ROWS CR
		WHERE
			<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
				(TO_CMP_ID =  #attributes.member_id# OR FROM_CMP_ID =  #attributes.member_id#) AND
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				(TO_CONSUMER_ID =  #attributes.consumer_id# OR FROM_CONSUMER_ID =  #attributes.consumer_id#) AND
			<cfelse>
				(TO_EMPLOYEE_ID =  #attributes.employee_id_new# OR FROM_EMPLOYEE_ID =  #attributes.employee_id_new#) AND
			</cfif>
			<cfif len(attributes.acc_type_id)>
				CR.ACC_TYPE_ID = #attributes.acc_type_id# AND
			</cfif>
				CR.ACTION_TYPE_ID NOT IN (45,46) AND
			<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
				CR.CARI_ACTION_ID NOT IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.COMPANY_ID = #attributes.member_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				CR.CARI_ACTION_ID NOT IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.CONSUMER_ID = #attributes.consumer_id# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
			<cfelse>
				CR.CARI_ACTION_ID NOT IN (SELECT ICRR.CARI_ACTION_ID FROM CARI_CLOSED_ROW ICRR,CARI_CLOSED IC WHERE ICRR.CLOSED_ID = IC.CLOSED_ID AND IC.EMPLOYEE_ID = #attributes.employee_id_new# AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICRR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICRR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.ACTION_TYPE_ID = ICRR.ACTION_TYPE_ID AND IC.OTHER_MONEY = CR.OTHER_MONEY) AND
			</cfif>
			CR.ACTION_VALUE > 0 AND
			CR.OTHER_CASH_ACT_VALUE > 0 AND
			I.INVOICE_ID = CR.ACTION_ID AND
			I.INVOICE_CAT = CR.ACTION_TYPE_ID AND
			IC.INVOICE_ID = CR.ACTION_ID AND
			IC.IS_CONTROL = 1 AND	
			IC.INVOICE_ID = I.INVOICE_ID AND
			I.IS_IPTAL = 0 AND
			I.PURCHASE_SALES = 0
		<cfif isdefined("attributes.due_date1") and len(attributes.due_date1)>
			AND (CR.DUE_DATE >= #attributes.due_date1#
			OR CR.DUE_DATE IS NULL)
		</cfif>
		<cfif isdefined("attributes.due_date2") and len(attributes.due_date2)>
			AND (CR.DUE_DATE <= #attributes.due_date2#
			OR CR.DUE_DATE IS NULL)
		</cfif>
		<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date") and isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND CR.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdefined("attributes.start_date") and isdate(attributes.start_date)>
			AND CR.ACTION_DATE >= #attributes.start_date#
		<cfelseif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			AND CR.ACTION_DATE <= #attributes.finish_date#
		</cfif>
		<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
			AND CR.OTHER_MONEY = '#attributes.money_type#'
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			AND CR.PROJECT_ID = #attributes.project_id#
		</cfif>
		<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and len(attributes.employee_name)>
			AND IC.RECORD_EMP = #attributes.record_emp_id#
		</cfif>	
	</cfif>	
		)
		MAIN_GET_CLOSED
	<cfif isDefined("attributes.closed_type_info") and attributes.closed_type_info eq 2>
		WHERE
		<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
			ROUND(DSP_OTHER_CLOSED_AMOUNT,2) <> ROUND(OTHER_CASH_ACT_VALUE,2) AND<!--- kısmi kapamaları getirsn diye.. --->
			ROUND(OTHER_CLOSED_AMOUNT,2) <> ROUND(OTHER_CASH_ACT_VALUE,2) AND
			<cfif attributes.act_type eq 2>
				ROUND(OTHER_PAYMENT_VALUE+DSP_OTHER_CLOSED_AMOUNT,2) < ROUND(OTHER_CASH_ACT_VALUE,2) AND
			</cfif>
			((OTHER_CASH_ACT_VALUE-OTHER_CLOSED_AMOUNT) >= 0.01 AND
			(OTHER_CASH_ACT_VALUE-DSP_OTHER_CLOSED_AMOUNT) >= 0.01) or
			((ACTION_VALUE-TOTAL_CLOSED_AMOUNT) > 0.01 AND 
			(ACTION_VALUE-DSP_TOTAL_CLOSED_AMOUNT) > 0.01)
			<cfif attributes.act_type eq 2>
				AND ROUND(OTHER_PAYMENT_VALUE,2) <> ROUND(OTHER_CASH_ACT_VALUE,2)
			<cfelseif attributes.act_type eq 3>
				AND ROUND(OTHER_P_ORDER_VALUE,2) <> ROUND(OTHER_CASH_ACT_VALUE,2)
			</cfif>
		<cfelse>
			ROUND(DSP_TOTAL_CLOSED_AMOUNT,2) <> ROUND(ACTION_VALUE,2) AND
			ROUND(TOTAL_CLOSED_AMOUNT,2) <> ROUND(ACTION_VALUE,2) AND
			<cfif attributes.act_type eq 2>
				ROUND(TOTAL_PAYMENT_VALUE+DSP_TOTAL_CLOSED_AMOUNT,2) < ROUND(ACTION_VALUE,2) AND
			</cfif>
			(ACTION_VALUE-TOTAL_CLOSED_AMOUNT) > 0.01 AND 
			(ACTION_VALUE-DSP_TOTAL_CLOSED_AMOUNT) > 0.01 AND
			OTHER_CASH_ACT_VALUE > 0
			<cfif attributes.act_type eq 2>
				AND ROUND(TOTAL_PAYMENT_VALUE,2) <> ROUND(ACTION_VALUE,2)
			<cfelseif attributes.act_type eq 3>
				AND ROUND(TOTAL_P_ORDER_VALUE,2) <> ROUND(ACTION_VALUE,2)
			</cfif>
		</cfif>
	</cfif>
	ORDER BY DUE_DATE,ACTION_DATE
</cfquery>