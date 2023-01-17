<cfquery name="get_history" datasource="#dsn3#">
	SELECT
		POS_OPERATION_HISTORY.*,
        POS_OPERATION_HISTORY.RECORD_DATE AS UPDATE_DATE1,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS UPDATE_NAME 
	FROM
		POS_OPERATION_HISTORY WITH (NOLOCK)
        LEFT JOIN #dsn_alias#.EMPLOYEES E ON POS_OPERATION_HISTORY.RECORD_EMP = E.EMPLOYEE_ID
	WHERE
		POS_OPERATION_ID = #attributes.act_id#
	ORDER BY
		RECORD_DATE DESC
</cfquery>

    <cfif get_history.recordcount>
		<cfquery name="get_bank_names" datasource="#DSN#">
			SELECT BANK_ID,BANK_CODE,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
		</cfquery>
		<cfquery name="getSetupPeriod" datasource="#dsn#">
			SELECT PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# ORDER BY RECORD_DATE DESC
		</cfquery>
		<cfquery name="GET_POS_ALL" datasource="#DSN3#">
			SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE POS_TYPE IS NOT NULL AND IS_ACTIVE = 1 ORDER BY (SELECT ACCOUNT_NAME FROM ACCOUNTS WHERE ACCOUNT_ID = BANK_ACCOUNT),LEFT(CARD_NO,3),ISNULL(NUMBER_OF_INSTALMENT,0)
		</cfquery>
        <cfset temp_ = 0>
		<cfoutput query="get_history">
        <cfset temp_ = temp_ +1>
         <cf_seperator id="history_#temp_#" header="#dateformat(record_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date1),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
        <table id="history_#temp_#" style="display:none;">
			<cfset pos_id = get_history.POS_ID>
			<cfquery name="getPaymentInstalment" datasource="#dsn3#">
				SELECT NUMBER_OF_INSTALMENT FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #pos_id#
			</cfquery>
			<cfquery name="PAYMENT_TYPE_ALL" datasource="#DSN3#">
				SELECT 
					PAYMENT_TYPE_ID,
					CARD_NO 
				FROM 
					CREDITCARD_PAYMENT_TYPE 
				WHERE 
					IS_ACTIVE = 1 AND
					<cfif len(getPaymentInstalment.NUMBER_OF_INSTALMENT)>
						NUMBER_OF_INSTALMENT = #getPaymentInstalment.NUMBER_OF_INSTALMENT#
					<cfelse>
						NUMBER_OF_INSTALMENT IS NULL
					</cfif>
			</cfquery>
			<cfset bank_ids = get_history.BANK_IDS>
			<cfset pay_method_ = get_history.PAY_METHOD_IDS>
			<cfset volume = get_history.VOLUME>
			<cfset active = get_history.IS_ACTIVE>
			<cfset period_id_ = get_history.PERIOD_ID>
			<cfset start_date = get_history.START_DATE>
			<cfset finish_date = get_history.FINISH_DATE>
			<cfset error_code = get_history.ERROR_CODES>
			<cfset pos_operation_name = get_history.POS_OPERATION_NAME>
            <tr>
            	<td valign="top" class="txtboldblue" ><cf_get_lang dictionary_id='58233.Tanım'></td>
                <td colspan="3">
                	#pos_operation_name#
                </td>
            </tr>
			<tr>
				<td valign="top" class="txtboldblue"><cf_get_lang dictionary_id='57493.Aktif'> / <cf_get_lang dictionary_id='57494.Pasif'></td>
				<td valign="top">
					<cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif>
				</td>
				<td valign="top" class="txtboldblue"><cf_get_lang dictionary_id='48679.Hata Kodları'></td>
				<td valign="top">#error_code#</td>
			</tr>
			<tr valign="top">
				<td valign="top" width="120" class="txtboldblue"><cf_get_lang dictionary_id='57679.POS'></td>
				<td valign="top">
					<cfloop query="get_pos_all">
						<cfif pos_id eq PAYMENT_TYPE_ID>
							#CARD_NO#<br/>
						</cfif>
					</cfloop>
				</td>
				<td valign="top" class="txtboldblue"><cf_get_lang dictionary_id='58472.Dönem'></td>
				<td valign="top">
					<cfloop query="getSetupPeriod">
						<cfif period_id_ eq period_id>#period_year#</cfif>
					</cfloop>
				</td>
			</tr>
			<tr valign="top">
				<td valign="top" class="txtboldblue"><cf_get_lang dictionary_id='48680.Ödeme Planı Tarihi'></td>
				<td><cfif len(start_date)>#dateformat(start_date,dateformat_style)#</cfif> <cfif len(start_date) and len(finish_date)>/</cfif> <cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id='48682.Geçirilecek Hacim'> *</td>
				<td>#tlformat(volume)#</td>
			</tr>
			<tr>
				<td valign="top" width="120" class="txtboldblue"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
				<td valign="top">
					<cfloop query="payment_type_all">
						<cfif listfind(pay_method_,payment_type_id)>
							#card_no#<br/>
						</cfif>
					</cfloop>
				</td>
				<td valign="top" class="txtboldblue"><cf_get_lang dictionary_id='48948.Kart Bankası'></td>
				<td valign="top">
					<cfloop query="get_bank_names">
						<cfif listfind(bank_ids,bank_id)>
							#bank_name#<br/>
						</cfif>
					</cfloop>
				</td>
			</tr>
			<tr>
				<td colspan="6" class="txtbold" valign="top">
					<cfif len(get_history.record_emp)><cf_get_lang dictionary_id='57483.Kayıt'>: #get_emp_info(get_history.record_emp,0,0)# - #dateformat(dateadd('h',session.ep.time_zone,get_history.record_date),dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,get_history.record_date),timeformat_style)#</cfif>
				</td>
			</tr>
			<tr>
				<td colspan="6"><hr></td>
			</tr>
         </table>
		</cfoutput>
    <cfelse>
   		<table>
            <tr height="20">
                <td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
            </tr>
        </table>
    </cfif>

