<cfsetting showdebugoutput="no">
<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif isdefined("attributes.pos_operation_id")>
	<cfquery name="add_history" datasource="#dsn3#">
		INSERT INTO
			POS_OPERATION_HISTORY
		(
			POS_OPERATION_ID,
			POS_OPERATION_NAME,
			POS_ID,
			PAY_METHOD_IDS,
			BANK_IDS,
			VOLUME,
			IS_ACTIVE,
			PERIOD_ID,
			START_DATE,
			FINISH_DATE,
			ERROR_CODES,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		SELECT
			POS_OPERATION_ID,
            POS_OPERATION_NAME,
			POS_ID,
			PAY_METHOD_IDS,
			BANK_IDS,
			VOLUME,
			IS_ACTIVE,
			PERIOD_ID,
			START_DATE,
			FINISH_DATE,
			ERROR_CODES,
			#now()#,
			#session.ep.userid#,
			'#CGI.REMOTE_ADDR#'
		FROM
			POS_OPERATION
		WHERE
			POS_OPERATION_ID = #attributes.pos_operation_id#
	</cfquery>
	<cfquery name="upd_rule_pos" datasource="#dsn3#">
		UPDATE
			POS_OPERATION
		SET
			POS_ID = #attributes.pos#,
            POS_OPERATION_NAME = '#attributes.pos_operation_name#',
			PAY_METHOD_IDS = '#attributes.pay_method#',
			BANK_IDS = <cfif isdefined("attributes.bank_names") and len(attributes.bank_names)>'#attributes.bank_names#'<cfelse>NULL</cfif>,
			VOLUME = #attributes.ava_vol#,
			IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			PERIOD_ID = #attributes.period_id#,
			START_DATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
			FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
			ERROR_CODES = <cfif isdefined("attributes.error_codes") and len(attributes.error_codes)>'#attributes.error_codes#'<cfelse>NULL</cfif>,
			CARD_TYPE = <cfif isdefined("attributes.card_type") and len(attributes.card_type)>'#attributes.card_type#'<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			POS_OPERATION_ID = #attributes.pos_operation_id#
	</cfquery>
	<!--- eski operation satirlari siliniyor. --->
    <cfquery name="upd_rows" datasource="#dsn3#">
    	UPDATE
        	SUBSCRIPTION_PAYMENT_PLAN_ROW
        SET
        	IS_COLLECTED_PROVISION = 0,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_EMP = #session.ep.userid#
        WHERE
        	IS_COLLECTED_PROVISION = 1 AND
            IS_PAID = 0 AND
        	INVOICE_ID IN(
                            SELECT
                                SPPR2.INVOICE_ID
                            FROM
                                SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR,
                                SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR2,
                                POS_OPERATION_ROW PO
                            WHERE
                                SPPR.SUBSCRIPTION_PAYMENT_ROW_ID = PO.SUBSCRIPTION_PAYMENT_ROW_ID
                                AND PO.POS_OPERATION_ID = #attributes.pos_operation_id#
                                AND SPPR.INVOICE_ID = SPPR2.INVOICE_ID
                                AND SPPR.PERIOD_ID = SPPR2.PERIOD_ID
                            )
    </cfquery>
	<cfquery name="delOperationRow" datasource="#dsn3#">
		DELETE FROM POS_OPERATION_ROW WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
	</cfquery>	
<cfelse>
	<cfquery name="add_rule_pos" datasource="#dsn3#" result="MAX_ID">
		INSERT INTO
			POS_OPERATION
			(
				POS_ID,
                POS_OPERATION_NAME,
				PAY_METHOD_IDS,
				BANK_IDS,
				VOLUME,
				IS_ACTIVE,
				PERIOD_ID,
				START_DATE,
				FINISH_DATE,
				ERROR_CODES,
				CARD_TYPE,
				IS_FLAG,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#attributes.pos#,
                '#attributes.pos_operation_name#',
				'#attributes.pay_method#',
				<cfif isdefined("attributes.bank_names") and len(attributes.bank_names)>'#attributes.bank_names#'<cfelse>NULL</cfif>,
				#attributes.ava_vol#,
				1,
				#attributes.period_id#,
				<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.error_codes") and len(attributes.error_codes)>'#attributes.error_codes#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.card_type") and len(attributes.card_type)>'#attributes.card_type#'<cfelse>NULL</cfif>,
				0,
				#now()#,
				#session.ep.userid#,
				'#CGI.REMOTE_ADDR#'
			)
	</cfquery>
	<cfset attributes.pos_operation_id = MAX_ID.IDENTITYCOL>
</cfif>
<script language="JavaScript">
	window.location.href="<cfoutput>#request.self#?fuseaction=bank.list_pos_operation&event=upd&pos_operation_id=#attributes.pos_operation_id#</cfoutput>";
</script>

