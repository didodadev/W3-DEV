<cfsetting showdebugoutput="no">
<cf_date tarih="attributes.action_date">
<cfset form.active_period = session.ep.period_id>
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1
</cfquery>
<cfscript>
	is_from_makeage = 1;
	currency_mult_other = 1;
	currency_multiplier = "";
	attributes.kur_say = GET_MONEY_INFO.RECORDCOUNT;
</cfscript>
<cfif len(attributes.closeIdList)>
	<cfloop list="#attributes.closeIdList#" index="i">
		<cfquery name="get_pay_order" datasource="#dsn2#">
			SELECT * FROM CARI_CLOSED WHERE CLOSED_ID = #i# AND ISNULL(IS_BANK_ORDER,0) = 0
		</cfquery>
		<cfif get_pay_order.recordcount>
			<cfquery name="upd_closed" datasource="#dsn2#">
				UPDATE CARI_CLOSED SET IS_BANK_ORDER = 1 WHERE CLOSED_ID = #i#
			</cfquery>
			<cfquery name="get_pay_order_row" datasource="#dsn2#">
				SELECT * FROM CARI_CLOSED_ROW WHERE CLOSED_ID = #i#
			</cfquery>
			<cfscript>
				attributes.order_id = i;
				attributes.order_row_id = valuelist(get_pay_order_row.closed_row_id);
				attributes.money_type = get_pay_order.OTHER_MONEY;
				for(stp_mny=1;stp_mny lte GET_MONEY_INFO.RECORDCOUNT;stp_mny=stp_mny+1)
				{
					get_money_rate=cfquery(datasource:"#dsn2#", 
											sqlstring:"
											SELECT 
												TOP 1 RATE1,RATE2
											FROM 
												#dsn_alias#.MONEY_HISTORY
											WHERE
												VALIDATE_DATE <= #CREATEODBCDATE(attributes.action_date)# AND 
												MONEY='#GET_MONEY_INFO.MONEY[stp_mny]#' 
											ORDER BY 
												VALIDATE_DATE DESC");
					if(get_money_rate.recordcount)
					{
						rate1 = get_money_rate.RATE1;
						rate2 = get_money_rate.RATE2;
					}
					else
					{
						rate1 = GET_MONEY_INFO.RATE1[stp_mny];
						rate2 = GET_MONEY_INFO.RATE2[stp_mny];
					}
					'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY_INFO.MONEY[stp_mny];
					'attributes.txt_rate1_#stp_mny#'=rate1;	
					'attributes.txt_rate2_#stp_mny#'=rate2;
					if(attributes.currency_id eq GET_MONEY_INFO.MONEY[stp_mny])
						currency_mult_acc = (rate2/rate1);
					if(attributes.money_type eq GET_MONEY_INFO.MONEY[stp_mny])
						currency_mult_other = (rate2/rate1);
					if(GET_MONEY_INFO.MONEY[stp_mny] eq session.ep.money2)
						currency_multiplier = (rate2/rate1);
				}
				attributes.company_id = get_pay_order.COMPANY_ID;
				attributes.consumer_id = get_pay_order.CONSUMER_ID;
				attributes.project_name = get_pay_order.PROJECT_ID;
				attributes.project_id = get_pay_order.PROJECT_ID;
				attributes.employee_id = get_pay_order.EMPLOYEE_ID&"_"&get_pay_order.ACC_TYPE_ID;
				attributes.ACTION_DATE = attributes.action_date;
				attributes.PAYMENT_DATE = attributes.payment_date;
				if(attributes.currency_id eq session.ep.money)
				{
					attributes.ORDER_AMOUNT = abs(wrk_round(get_pay_order.P_ORDER_DIFF_AMOUNT_VALUE*currency_mult_other));
					attributes.OTHER_CASH_ACT_VALUE = abs(get_pay_order.P_ORDER_DIFF_AMOUNT_VALUE);
					attributes.system_amount = abs(wrk_round(get_pay_order.P_ORDER_DIFF_AMOUNT_VALUE*currency_mult_other));
				}
				else
				{
					attributes.ORDER_AMOUNT =  abs(wrk_round(get_pay_order.P_ORDER_DIFF_AMOUNT_VALUE*currency_mult_other/currency_mult_acc));
					attributes.system_amount = abs(wrk_round(get_pay_order.P_ORDER_DIFF_AMOUNT_VALUE*currency_mult_other));
					attributes.OTHER_CASH_ACT_VALUE = abs(get_pay_order.P_ORDER_DIFF_AMOUNT_VALUE);
				}
			</cfscript>
			<cfinclude template="../../bank/query/add_assign_order.cfm">
		</cfif>
	</cfloop>
	<script type="text/javascript">
		<cfoutput>
			alert('Toplam #ListLen(attributes.closeIdList,',')# Adet Banka Talimatı Kaydedildi!');
		</cfoutput>
	</script>
</cfif>
<cfabort>
