<cfsetting showdebugoutput="no">
<cf_date tarih = "attributes.act_date">
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT 
		*,
		ISNULL((
			SELECT
				 TOP 1 RATE2
			FROM
				#dsn_alias#.MONEY_HISTORY
			WHERE
				VALIDATE_DATE <= #attributes.act_date# AND
				PERIOD_ID = #session.ep.period_id# AND
				MONEY = SETUP_MONEY.MONEY
			ORDER BY
				VALIDATE_DATE DESC
		),RATE2) NEW_RATE2
	FROM 
		SETUP_MONEY
	WHERE
		MONEY_STATUS = 1
</cfquery>
<cfscript>
	attributes.kur_say = GET_MONEY_INFO.RECORDCOUNT;
	for(stp_mny=1;stp_mny lte GET_MONEY_INFO.RECORDCOUNT;stp_mny=stp_mny+1)
	{
		'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY_INFO.MONEY[stp_mny];
		'attributes.txt_rate1_#stp_mny#'=GET_MONEY_INFO.RATE1[stp_mny];	
		'attributes.txt_rate2_#stp_mny#'=GET_MONEY_INFO.NEW_RATE2[stp_mny];
	}
	attributes.masraf = 0;
	is_collacted = 1;
</cfscript>
<cfif attributes.type eq 0><!---Tahsil edildi--->
	<cfset form.process_cat = attributes.process_type_info1>
	<cfloop list="#attributes.cheque_id_list#" index="kk">
		<cfquery name="get_cheque_info" datasource="#dsn2#">
			SELECT * FROM CHEQUE WHERE CHEQUE_ID = #kk#
		</cfquery>
		<cfscript>
			attributes.rd_money = "#get_cheque_info.currency_id#;1" ;
			attributes.other_money = get_cheque_info.currency_id ;
			form.cheque_id = get_cheque_info.cheque_id;
			attributes.cheque_no = get_cheque_info.cheque_no;
		</cfscript>
		<cfinclude template="upd_status_cheque_collect.cfm">
	</cfloop>
<cfelseif attributes.type eq 1><!---karşılıksız--->
	<cfset form.process_cat = attributes.process_type_info2>
	<cfloop list="#attributes.cheque_id_list#" index="kk">
		<cfquery name="get_cheque_info" datasource="#dsn2#">
			SELECT * FROM CHEQUE WHERE CHEQUE_ID = #kk#
		</cfquery>
		<cfscript>
			attributes.rd_money = "#get_cheque_info.currency_id#;1" ;
			attributes.other_money = get_cheque_info.currency_id ;
			form.cheque_id = get_cheque_info.cheque_id;
			attributes.extra_status = 2;
			attributes.cheque_id = get_cheque_info.cheque_id;
			attributes.cheque_no = get_cheque_info.cheque_no;
		</cfscript>
		<cfinclude template="upd_status_cheque_karsiliksiz.cfm">
	</cfloop>
<cfelseif attributes.type eq 2><!--- ödendi --->
	<cfset form.process_cat = attributes.process_type_info3>
	<cfloop list="#attributes.cheque_id_list#" index="kk">
		<cfquery name="get_cheque_info" datasource="#dsn2#">
			SELECT * FROM CHEQUE WHERE CHEQUE_ID = #kk#
		</cfquery>
		<cfquery name="get_history_info" datasource="#dsn2#" maxrows="1">
			SELECT 
				C.CHEQUE_VALUE AS ACTION_VALUE,
				C.CHEQUE_PAYROLL_ID AS FIRST_PAYROLL_ID,
				C.CURRENCY_ID,
				C.OTHER_MONEY_VALUE,
				C.OTHER_MONEY_VALUE2,
				CH.OTHER_MONEY_VALUE AS HISTORY_OTHER_MONEY_VALUE,
				CH.OTHER_MONEY AS HISTORY_OTHER_MONEY,
				CH.OTHER_MONEY_VALUE2 AS HISTORY_OTHER_MONEY_VALUE2,
				CH.OTHER_MONEY2 AS HISTORY_OTHER_MONEY2,
				CH.PAYROLL_ID,
				CH.DETAIL,
				(
					SELECT
						MAX(ISNULL(ACT_DATE,RECORD_DATE))
					FROM
						CHEQUE_HISTORY
					WHERE
						CHEQUE_ID = C.CHEQUE_ID
				)MAX_ACT_DATE
			FROM
				CHEQUE_HISTORY CH,
				CHEQUE C
			WHERE
				C.CHEQUE_ID = CH.CHEQUE_ID
				AND CH.CHEQUE_ID = #kk#
			ORDER BY
				HISTORY_ID DESC 
		</cfquery>
		<cfif len(get_history_info.first_payroll_id)>
			<cfquery name="get_payroll_no" datasource="#dsn2#">
				SELECT PAYROLL_NO FROM PAYROLL WHERE ACTION_ID = #get_history_info.first_payroll_id#
			</cfquery>
			<cfif get_payroll_no.PAYROLL_NO neq -1>
				<cfquery name="get_first_rate" datasource="#dsn2#">
					SELECT RATE2,RATE1,MONEY_TYPE FROM PAYROLL_MONEY WHERE ACTION_ID = #get_history_info.first_payroll_id# AND IS_SELECTED=1
				</cfquery>
			<cfelse>
				<cfquery name="get_first_rate" datasource="#dsn2#">
					SELECT RATE2,RATE1,MONEY_TYPE FROM CHEQUE_MONEY WHERE ACTION_ID = #kk# AND IS_SELECTED=1
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="get_first_rate" datasource="#dsn2#">
				SELECT RATE2,RATE1,MONEY_TYPE FROM CHEQUE_MONEY WHERE ACTION_ID = #kk# AND IS_SELECTED=1
			</cfquery>
		</cfif>
		<cfif get_first_rate.recordcount eq 0>
			<cfquery name="get_first_rate" datasource="#dsn2#">
				SELECT RATE2,RATE1,MONEY AS MONEY_TYPE FROM SETUP_MONEY WHERE MONEY = '#GET_HISTORY_INFO.CURRENCY_ID#'
			</cfquery>
		</cfif>
		<cfif len(get_history_info.payroll_id)>
			<cfquery name="get_last_rate" datasource="#dsn2#">
				SELECT RATE2,RATE1,MONEY_TYPE FROM PAYROLL_MONEY WHERE ACTION_ID = #get_history_info.payroll_id# AND IS_SELECTED=1
			</cfquery>
		<cfelse>
			<cfquery name="get_last_rate" datasource="#dsn2#">
				SELECT RATE2,RATE1,MONEY_TYPE FROM CHEQUE_MONEY WHERE ACTION_ID = #kk# AND IS_SELECTED=1
			</cfquery>
		</cfif>
		<cfif get_last_rate.recordcount eq 0>
			<cfquery name="get_last_rate" datasource="#dsn2#">
				SELECT RATE2,RATE1,MONEY_TYPE FROM CHEQUE_MONEY WHERE ACTION_ID = #kk# AND IS_SELECTED=1
			</cfquery>
		</cfif>
		<cfif get_last_rate.recordcount eq 0>
			<cfquery name="get_last_rate" datasource="#dsn2#">
				SELECT RATE2,RATE1,MONEY AS MONEY_TYPE FROM SETUP_MONEY WHERE MONEY = '#GET_HISTORY_INFO.CURRENCY_ID#'
			</cfquery>
		</cfif>
		<cfset first_value = wrk_round(GET_HISTORY_INFO.OTHER_MONEY_VALUE/ get_first_rate.rate2)>
		<cfset last_value = wrk_round(GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE/ get_last_rate.rate2)>
		<cfif GET_HISTORY_INFO.CURRENCY_ID eq get_last_rate.MONEY_TYPE>
			<cfset diff_value = 0>
		<cfelse>
			<cfset diff_value = last_value - first_value>
		</cfif>
		<cfscript>
			attributes.rd_money = "#get_cheque_info.currency_id#;1" ;
			attributes.other_money = get_cheque_info.currency_id ;
			form.cheque_id = get_cheque_info.cheque_id;
			attributes.extra_status = 2;
			attributes.cheque_id = get_cheque_info.cheque_id;
			if(get_history_info.history_other_money != '')
				attributes.system_currency_value_diff = GET_HISTORY_INFO.OTHER_MONEY_VALUE-GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE;
			else
				attributes.system_currency_value_diff = '';
			if(get_history_info.history_other_money2 != '')
				attributes.system_currency_value_diff2 = GET_HISTORY_INFO.OTHER_MONEY_VALUE2-GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE2;
			else
				attributes.system_currency_value_diff2 = '';
			attributes.other_currency_value_diff = diff_value;
			attributes.system_currency_value = GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE;
			attributes.cheque_no = get_cheque_info.cheque_no;
		</cfscript>
		<cfinclude template="upd_status_cheque_payment.cfm">
	</cfloop>
</cfif>
<script type="text/javascript">document.list_cheques.submit();</script>
<cfabort>

