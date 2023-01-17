<cfsetting showdebugoutput="no">
<cfquery name="getSetupPeriod" datasource="#dsn#" maxrows="1">
	SELECT PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
</cfquery>
<cfset dsn2_alias_ = '#dsn#_#getSetupPeriod.period_year#_#session.ep.company_id#'>
<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfquery name="get_sub_pay_plan_1" datasource="#dsn3#">
	SELECT
		SUM(ARA_TOTAL) AS SON_TOTAL,
        CREDITCARD_PAYMENT_ID
	FROM
	(
	SELECT
			TOTAL AS ARA_TOTAL,
            CREDITCARD_PAYMENT_ID
	FROM
		(	SELECT 
				I.NETTOTAL TOTAL,
				SPR.INVOICE_ID,
                ISNULL(I.CREDITCARD_PAYMENT_ID,0) CREDITCARD_PAYMENT_ID
			FROM 
				SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
				#dsn2_alias_#.INVOICE I,
				SUBSCRIPTION_CONTRACT SC
			WHERE 
				SPR.INVOICE_ID = I.INVOICE_ID AND
				SC.SUBSCRIPTION_ID = SPR.SUBSCRIPTION_ID AND
				SC.MEMBER_CC_ID = (
								CASE WHEN (SC.INVOICE_COMPANY_ID IS NOT NULL) 
								  THEN
									(
									SELECT 
										CC.COMPANY_CC_ID 
									FROM 
										#dsn_alias#.COMPANY_CC AS CC
									WHERE 
										SC.MEMBER_CC_ID = CC.COMPANY_CC_ID AND
										CC.IS_DEFAULT = 1 AND
										COMPANY_ID = SC.INVOICE_COMPANY_ID
										<cfif listlen(attributes.bank_id_list)>
											AND COMPANY_BANK_TYPE IN (#listsort(attributes.bank_id_list,'numeric')#)
										</cfif>
										<cfif isdefined("attributes.card_type_list") and listlen(attributes.card_type_list)>
											AND COMPANY_CC_TYPE IN (#listsort(attributes.card_type_list,'numeric')#)
										</cfif>
										<cfif isdefined("attributes.error_codes") and listlen(attributes.error_codes)>
											AND
											(
											<cfloop from="1" to="#listlen(attributes.error_codes)#" index="kk">
												<cfset err_code = listgetat(attributes.error_codes,kk)>
												<cfif err_code eq -1>
													RESP_CODE IS NULL OR RESP_CODE = '' OR RESP_CODE = ' '
												<cfelse>
													RESP_CODE = '#err_code#'
												</cfif>
												<cfif kk neq listlen(attributes.error_codes)>OR</cfif>
											</cfloop>
											)
										</cfif>	
									)
								  ELSE
									(
									SELECT 
										CC.CONSUMER_CC_ID 
									FROM 
										#dsn_alias#.CONSUMER_CC AS CC
									WHERE 
										SC.MEMBER_CC_ID = CC.CONSUMER_CC_ID AND
										CC.IS_DEFAULT = 1 AND
										CONSUMER_ID = SC.INVOICE_CONSUMER_ID
										<cfif listlen(attributes.bank_id_list)>
											AND CONSUMER_BANK_TYPE IN (#listsort(attributes.bank_id_list,'numeric')#)
										</cfif>
										<cfif isdefined("attributes.card_type_list") and listlen(attributes.card_type_list)>
											AND CONSUMER_CC_TYPE IN (#listsort(attributes.card_type_list,'numeric')#)
										</cfif>
										<cfif isdefined("attributes.error_codes") and listlen(attributes.error_codes)>
											AND
											(
											<cfloop from="1" to="#listlen(attributes.error_codes)#" index="kk">
												<cfset err_code = listgetat(attributes.error_codes,kk)>
												<cfif err_code eq -1>
													RESP_CODE IS NULL OR RESP_CODE = '' OR RESP_CODE = ' '
												<cfelse>
													RESP_CODE = '#err_code#'
												</cfif>
												<cfif kk neq listlen(attributes.error_codes)>OR</cfif>
											</cfloop>
											)
										</cfif>	
									)
								  END
								 ) 
								 AND SPR.SUBSCRIPTION_PAYMENT_ROW_ID = (
													SELECT 
														MAX(SPR2.SUBSCRIPTION_PAYMENT_ROW_ID)
													FROM 
														SUBSCRIPTION_PAYMENT_PLAN_ROW SPR2 
													WHERE 
														SPR.INVOICE_ID = SPR2.INVOICE_ID AND
														SPR2.IS_BILLED = 1 AND
														SPR2.IS_ACTIVE = 1 AND
														SPR2.IS_PAID = 0 AND 
														SPR2.INVOICE_ID IS NOT NULL AND
														SPR2.PERIOD_ID = #getSetupPeriod.period_id# AND
														SPR2.CARD_PAYMETHOD_ID IN (#listsort(pay_met_list,'numeric')#)
														<cfif len(attributes.start_date)>
															AND SPR2.PAYMENT_DATE >= #attributes.start_date#
														</cfif>
														<cfif len(attributes.finish_date)>
															AND SPR2.PAYMENT_DATE <= #attributes.finish_date#
														</cfif>
													) AND
				I.NETTOTAL <> 0 AND
                I.INVOICE_CAT <> 57 AND <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
				SPR.IS_BILLED = 1 AND 
				SPR.IS_ACTIVE = 1 AND
				SPR.IS_PAID = 0 AND 
                SPR.IS_COLLECTED_PROVISION = 0 AND
				SPR.INVOICE_ID IS NOT NULL AND 
				SPR.PERIOD_ID = #getSetupPeriod.period_id# AND
				SPR.CARD_PAYMETHOD_ID IN (#listsort(pay_met_list,'numeric')#) 
				<cfif len(attributes.start_date)>
					AND SPR.PAYMENT_DATE >= #attributes.start_date#
				</cfif>
				<cfif len(attributes.finish_date)>
					AND SPR.PAYMENT_DATE <= #attributes.finish_date#
				</cfif>
		) AS VERILER
	) AS TOTALS
    GROUP BY 
    	CREDITCARD_PAYMENT_ID
</cfquery>
<cfquery name="get_sub_pay_plan" dbtype="query">
	SELECT SUM(SON_TOTAL) SON_TOTAL FROM get_sub_pay_plan_1
</cfquery>
<cfset kontrol_invoice = 0>
<cfoutput query="get_sub_pay_plan_1">
	<cfif get_sub_pay_plan_1.CREDITCARD_PAYMENT_ID neq 0><cfset kontrol_invoice = 1></cfif>
</cfoutput>

<cfquery name="get_other_pos" datasource="#dsn3#">
	SELECT 
		SUM(VOLUME) VOLUME
	FROM 
		POS_OPERATION
	WHERE
		PERIOD_ID = #getSetupPeriod.period_id#
		AND ','+PAY_METHOD_IDS+',' LIKE '#pay_met_list#'
		AND IS_ACTIVE = 1
		<cfif len(attributes.start_date)>
			AND START_DATE = #attributes.start_date#
		</cfif>
		<cfif len(attributes.finish_date)>
			AND FINISH_DATE = #attributes.finish_date#
		</cfif>
		<cfif isdefined("attributes.pos_operation_id")>
			AND POS_OPERATION_ID <> #attributes.pos_operation_id#
		</cfif>
</cfquery>
<cfif kontrol_invoice eq 1>
<div class="form-group">
	<label class="col col-12"><cf_get_lang dictionary_id='56611.Tahsil Edilmiş Faturalar Bulunmaktadır'>. <cf_get_lang dictionary_id='64987.Lütfen Kontrol Ediniz'>!</label>
</div>
</cfif>
<div class="form-group" id="item-ava_total">
	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64986.Geçirilebilecek Tutar'> (TL)</label>
	<div class="col col-8 col-xs-12">
		<cfif len(get_sub_pay_plan.son_total)>
                <input type="text" name="ava_total" id="ava_total" class="moneybox"  value="<cfoutput>#TLFormat(get_sub_pay_plan.son_total)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,3));" readonly> 
            <cfelse>
                <input type="text" name="ava_total" id="ava_total" class="moneybox"  value="0" onkeyup="return(FormatCurrency(this,event,2));" readonly> 
            </cfif>                                     
	</div> 
</div>
<cfif get_other_pos.recordcount and len(get_other_pos.volume)>
	<div class="form-group" id="item-other_volume_total">
	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64988.Diğer Kural Toplamı'></label>
	<div class="col col-8 col-xs-12">
		<input type="text" name="other_volume_total" id="other_volume_total" class="moneybox"  value="<cfoutput>#TLFormat(get_other_pos.volume)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,3));" readonly>                                     
	</div> 
</div>
</cfif>
<cfabort>
