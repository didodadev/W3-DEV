<!--- masraf değeri girilmişse bank_actions'a kayıt atilir ya da guncellenir --->
<cfif isdefined("attributes.id") and isdefined("is_upd_action")>
	<cfquery name="get_bank_actions" datasource="#dsn2#">
		SELECT ACTION_ID FROM BANK_ACTIONS WHERE VOUCHER_PAYROLL_ID = #attributes.id#
	</cfquery>
<cfelse>
	<cfset get_bank_actions.recordcount = 0>
</cfif>
<cfif get_bank_actions.recordcount>
	<cfquery name="UPD_BANK_PAYMENT" datasource="#dsn2#">
		UPDATE 
			BANK_ACTIONS 
		SET
			PROCESS_CAT = #attributes.process_cat#,
			ACTION_TYPE = #sql_unicode()#'BANKA MASRAF FİŞİ',
			ACTION_TYPE_ID = #process_type#,
			ACTION_DETAIL = <cfif len(attributes.action_detail)>#sql_unicode()#'#attributes.action_detail#'<cfelse>#sql_unicode()#'BANKA MASRAF FİŞİ'</cfif>,
			ACTION_VALUE = #attributes.masraf#,
			BANK_ACTION_KDVSIZ_VALUE = #attributes.masraf#,
			ACTION_CURRENCY_ID = #sql_unicode()#'#attributes.masraf_currency#',
			ACTION_DATE = #attributes.PAYROLL_REVENUE_DATE#,
			OTHER_CASH_ACT_VALUE = #(attributes.masraf*masraf_curr_multiplier)/dovizli_islem_multiplier#,
			OTHER_MONEY = <cfif len(rd_money)>'#rd_money#'<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = #sql_unicode()#'#cgi.REMOTE_ADDR#',
			FROM_BRANCH_ID = #branch_id_info#,
			IS_ACCOUNT = <cfif is_account eq 1>1,<cfelse>0,</cfif>
			IS_ACCOUNT_TYPE = 13,
			PAPER_NO = #sql_unicode()#'#attributes.payroll_no#',
			ACTION_FROM_ACCOUNT_ID = #attributes.account_id#,
			SYSTEM_ACTION_VALUE = #attributes.masraf*masraf_curr_multiplier#,
			SYSTEM_CURRENCY_ID = #sql_unicode()#'#session.ep.money#'
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2 = #wrk_round((attributes.masraf*masraf_curr_multiplier)/currency_multiplier,4)#
				,ACTION_CURRENCY_ID_2 = #sql_unicode()#'#session.ep.money2#'
			</cfif>
		WHERE
			VOUCHER_PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#dsn2#">
		SELECT ACTION_ID AS ACT_ID FROM BANK_ACTIONS WHERE VOUCHER_PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfquery>
	<cfset workcube_old_process_type = 25> 
<cfelse>
	<cfquery name="ADD_BANK_PAYMENT" datasource="#DSN2#">
		INSERT INTO
			BANK_ACTIONS
			(
				PROCESS_CAT,
				ACTION_TYPE,
				ACTION_TYPE_ID,
				ACTION_DETAIL,
				ACTION_VALUE,
				BANK_ACTION_KDVSIZ_VALUE,
				ACTION_CURRENCY_ID,
				ACTION_DATE,
				OTHER_CASH_ACT_VALUE,
				OTHER_MONEY,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				PAPER_NO,
				ACTION_FROM_ACCOUNT_ID,
				VOUCHER_PAYROLL_ID,
				FROM_BRANCH_ID,
				SYSTEM_ACTION_VALUE,
				SYSTEM_CURRENCY_ID
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>
			)
			VALUES
			(
				#attributes.process_cat#,
				#sql_unicode()#'BANKA MASRAF FİŞİ',
				#process_type#,
				<cfif len(attributes.action_detail)>#sql_unicode()#'#attributes.action_detail#'<cfelse>#sql_unicode()#'BANKA MASRAF FİŞİ'</cfif>,
				#attributes.masraf#,
				#attributes.masraf#,
				#sql_unicode()#'#attributes.masraf_currency#',
				#attributes.PAYROLL_REVENUE_DATE#,
				#(attributes.masraf*masraf_curr_multiplier)/dovizli_islem_multiplier#,
				<cfif len(rd_money)>'#rd_money#'<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				#sql_unicode()#'#cgi.REMOTE_ADDR#',
				<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
				#sql_unicode()#'#attributes.payroll_no#',
				#attributes.account_id#,
				<cfif isdefined("attributes.id") and isdefined("is_upd_action")>#attributes.id#<cfelse>#get_bordro_id.P_ID#</cfif>,
				#branch_id_info#,
				#attributes.masraf*masraf_curr_multiplier#,
				#sql_unicode()#'#session.ep.money#'
				<cfif len(session.ep.money2)>
					,#wrk_round((attributes.masraf*masraf_curr_multiplier)/currency_multiplier,4)#
					,#sql_unicode()#'#session.ep.money2#'
				</cfif>
			)
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#dsn2#">
		SELECT MAX(ACTION_ID) AS ACT_ID FROM BANK_ACTIONS
	</cfquery>
	<cfset workcube_old_process_type = 0>
</cfif>
