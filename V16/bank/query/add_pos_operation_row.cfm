<!--- otomatik sanal pos islemi devam ederken cekim yapılacak ödeme plan satırları olusturulamaz.---> 
<cfif not isdefined("is_from_schedule")><cfset is_from_schedule = 0></cfif>
<cfquery name="getPosOperationRow" datasource="#dsn3#">
	SELECT IS_FLAG FROM POS_OPERATION WITH (NOLOCK) WHERE IS_FLAG = 1 AND POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfif getPosOperationRow.recordcount and is_from_schedule eq 0>
	<script type="text/javascript">
		alert('Şu Anda tahsilat işlemi gerçekleşmektedir. Bu İşlemi Daha Sonra Yapmalısınız!');
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="getPosOperation" datasource="#dsn3#">
	SELECT 
    	POS_OPERATION_ID, 
        POS_ID, 
        PAY_METHOD_IDS, 
        BANK_IDS, 
        VOLUME, 
        IS_ACTIVE, 
        PERIOD_ID, 
        START_DATE, 
        FINISH_DATE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        ERROR_CODES, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        POS_OPERATION_NAME, 
        IS_FLAG,
		CARD_TYPE
    FROM 
    	POS_OPERATION 
    	WITH (NOLOCK) 
    WHERE 
    	IS_ACTIVE = 1 AND POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfif getPosOperation.recordcount>
	<cfquery name="getSetupPeriod" datasource="#dsn3#">
		SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WITH (NOLOCK) WHERE PERIOD_ID = #getPosOperation.period_id#
	</cfquery>
	<cfset dsn2_alias_ = '#dsn#_#getSetupPeriod.period_year#_#session.ep.company_id#'>
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
                                AND PO.POS_OPERATION_ID = #getPosOperation.pos_operation_id#
                                AND SPPR.INVOICE_ID = SPPR2.INVOICE_ID
                                AND SPPR.PERIOD_ID = SPPR2.PERIOD_ID
                            )
    </cfquery>
	<cfquery name="delOperationRow" datasource="#dsn3#">
		DELETE FROM POS_OPERATION_ROW WHERE POS_OPERATION_ID = #getPosOperation.pos_operation_id#
	</cfquery>	
	<!--- vadesi gelmis, ödenmemis, faturalanmıs ödeme plan satırları. --->
	<cfquery name="getSubsPaymentRow" datasource="#dsn3#">
		SELECT
			SPR.SUBSCRIPTION_PAYMENT_ROW_ID AS SPR_ID,
			I.NETTOTAL AS N_TOTAL,
			I.INVOICE_ID AS I_ID,
            SPR.PERIOD_ID
		FROM 
			SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
			#dsn2_alias_#.INVOICE I WITH (NOLOCK),
			SUBSCRIPTION_CONTRACT SC WITH (NOLOCK)
		WHERE 
			SPR.SUBSCRIPTION_PAYMENT_ROW_ID = (
										SELECT 
											MAX(SPR2.SUBSCRIPTION_PAYMENT_ROW_ID)
										FROM 
											SUBSCRIPTION_PAYMENT_PLAN_ROW SPR2  WITH (NOLOCK)
										WHERE 
											SPR.INVOICE_ID = SPR2.INVOICE_ID AND
											SPR2.IS_BILLED = 1 AND
											SPR2.IS_ACTIVE = 1 AND
											SPR2.IS_PAID = 0 AND 
            								--SPR2.IS_GROUP_INVOICE = 0 AND
											SPR2.INVOICE_ID IS NOT NULL AND
                                            SPR2.IS_COLLECTED_PROVISION = 0 AND
                                            --SC.SUBSCRIPTION_ID = SPR2.SUBSCRIPTION_ID AND
											SPR2.PERIOD_ID = #getPosOperation.period_id# AND
                                            SPR2.SUBSCRIPTION_PAYMENT_ROW_ID NOT IN (SELECT POR.SUBSCRIPTION_PAYMENT_ROW_ID FROM POS_OPERATION_ROW POR WITH (NOLOCK)) AND
											SPR2.CARD_PAYMETHOD_ID IN (#listsort(getPosOperation.PAY_METHOD_IDS,'numeric')#)
											<cfif len(getPosOperation.start_date)>
												AND SPR2.PAYMENT_DATE >= #createodbcdatetime(getPosOperation.start_date)#
											</cfif>
											<cfif len(getPosOperation.finish_date)>
												AND SPR2.PAYMENT_DATE <= #createodbcdatetime(getPosOperation.finish_date)#
											</cfif>
										) AND
			SPR.SUBSCRIPTION_PAYMENT_ROW_ID NOT IN (SELECT POR.SUBSCRIPTION_PAYMENT_ROW_ID FROM POS_OPERATION_ROW POR WITH (NOLOCK)) AND
			SPR.INVOICE_ID = I.INVOICE_ID AND
			SC.SUBSCRIPTION_ID = SPR.SUBSCRIPTION_ID AND
			SC.MEMBER_CC_ID = (
							CASE WHEN (SC.INVOICE_COMPANY_ID IS NOT NULL) 
					  THEN
						(
						SELECT 
							CC.COMPANY_CC_ID 
						FROM 
							#dsn_alias#.COMPANY_CC AS CC WITH (NOLOCK)
						WHERE 
							SC.MEMBER_CC_ID = CC.COMPANY_CC_ID AND
                            CC.IS_DEFAULT = 1 AND
							COMPANY_ID = SC.INVOICE_COMPANY_ID
							<cfif listlen(getPosOperation.bank_ids)>
								AND COMPANY_BANK_TYPE IN (#listsort(getPosOperation.bank_ids,'numeric')#)
							</cfif>
							<cfif listlen(getPosOperation.card_type)>
								AND COMPANY_CC_TYPE IN (#listsort(getPosOperation.card_type,'numeric')#)
							</cfif>
							<cfif listlen(getPosOperation.error_codes)>
								AND
								(
								<cfloop from="1" to="#listlen(getPosOperation.error_codes)#" index="kk">
									<cfset err_code = listgetat(getPosOperation.error_codes,kk)>
									<cfif err_code eq -1>
										RESP_CODE IS NULL OR RESP_CODE = '' OR RESP_CODE = ' '
									<cfelse>
										RESP_CODE = '#err_code#'
									</cfif>
									<cfif kk neq listlen(getPosOperation.error_codes)>OR</cfif>
								</cfloop>
								)
							</cfif>	
						)
					  ELSE
						(
						SELECT 
							CC.CONSUMER_CC_ID 
						FROM 
							#dsn_alias#.CONSUMER_CC AS CC WITH (NOLOCK)
						WHERE 
							SC.MEMBER_CC_ID = CC.CONSUMER_CC_ID AND
                            CC.IS_DEFAULT = 1 AND
							CONSUMER_ID = SC.INVOICE_CONSUMER_ID 
							<cfif listlen(getPosOperation.bank_ids)>
								AND CONSUMER_BANK_TYPE IN (#listsort(getPosOperation.bank_ids,'numeric')#)
							</cfif>		
							<cfif listlen(getPosOperation.card_type)>
								AND CONSUMER_CC_TYPE IN (#listsort(getPosOperation.card_type,'numeric')#)
							</cfif>
							<cfif listlen(getPosOperation.error_codes)>
								AND
								(
								<cfloop from="1" to="#listlen(getPosOperation.error_codes)#" index="kk">
									<cfset err_code = listgetat(getPosOperation.error_codes,kk)>
									<cfif err_code eq -1>
										RESP_CODE IS NULL OR RESP_CODE = '' OR RESP_CODE = ' '
									<cfelse>
										RESP_CODE = '#err_code#'
									</cfif>
									<cfif kk neq listlen(getPosOperation.error_codes)>OR</cfif>
								</cfloop>
								)
							</cfif>							
						)
					  END
						  ) AND
			I.NETTOTAL <> 0 AND
            I.INVOICE_CAT <> 57 AND <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
			SPR.PERIOD_ID = #getPosOperation.period_id# AND
            SPR.IS_COLLECTED_PROVISION = 0 AND
          	--SPR.IS_GROUP_INVOICE = 0 AND
			SPR.IS_BILLED = 1 AND
			SPR.IS_ACTIVE = 1 AND
			SPR.IS_PAID = 0 AND 
			SPR.INVOICE_ID IS NOT NULL AND
			SPR.CARD_PAYMETHOD_ID IN (#listsort(getPosOperation.PAY_METHOD_IDS,'numeric')#)
			<cfif len(getPosOperation.start_date)>
				AND SPR.PAYMENT_DATE >= #createodbcdatetime(getPosOperation.start_date)#
			</cfif>
			<cfif len(getPosOperation.finish_date)>
				AND SPR.PAYMENT_DATE <= #createodbcdatetime(getPosOperation.finish_date)#
			</cfif>
		ORDER BY
			I.INVOICE_DATE
	</cfquery>
    
	<!--- Otomatik sanal pos cekimi yapilacak satirlar yaziliyor belirtilmis hacme gore. --->
	<cfset _sonTotal_ = 0>
	<cfif getSubsPaymentRow.recordcount>
		<cfloop query="getSubsPaymentRow">
			<cfset _sonTotal_ = wrk_round(_sonTotal_+getSubsPaymentRow.n_total,2)>
			<cfif getPosOperation.volume gte _sonTotal_>
				<cfquery name="addPosOperationRow" datasource="#dsn3#">
					INSERT INTO
						POS_OPERATION_ROW
						(
							POS_OPERATION_ID,
							SUBSCRIPTION_PAYMENT_ROW_ID,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES
						(
							#getPosOperation.pos_operation_id#,
							#getSubsPaymentRow.SPR_ID#,
							#now()#,
							#session.ep.userid#,
							'#CGI.REMOTE_ADDR#'
						)
				</cfquery>
				<!--- kaydedildikten sonra toplu provizyon seceneği işaretlenecek --->
				<cfquery name="updSubsCollectedProv" datasource="#dsn3#">
					UPDATE 
                    	SUBSCRIPTION_PAYMENT_PLAN_ROW
                    SET 
                        IS_COLLECTED_PROVISION = 1,
                        UPDATE_DATE = #now()#,
                        UPDATE_IP = '#cgi.remote_addr#',
                        UPDATE_EMP = #session.ep.userid#
                   WHERE 
                   		PERIOD_ID = #getSubsPaymentRow.period_id# 
                        AND INVOICE_ID = #getSubsPaymentRow.I_ID#
				</cfquery>
				<!--- kaydedildikten sonra toplu provizyon seceneği işaretlenecek --->
			</cfif>
		</cfloop>
	</cfif>
</cfif>
<cfif is_from_schedule eq 0>
    <cfquery name="_getPosOperationRow_" datasource="#dsn3#">
        SELECT COUNT(POS_OPERATION_ROW_ID) SAYI FROM POS_OPERATION_ROW WITH (NOLOCK) WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
    </cfquery>
	<script type="text/javascript">
            alert('<cf_get_lang dictionary_id='64984.Kural dahilindeki'>  <cfoutput>#_getPosOperationRow_.sayi#</cfoutput> <cf_get_lang dictionary_id='64985.sanal pos satırı oluşturulmuştur'>!');
            opener.location.reload();
            window.close();
    </script>
</cfif>

