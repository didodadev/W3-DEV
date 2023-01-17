<cfsetting showdebugoutput="no">
<cfquery name="getPaymentInstalment" datasource="#dsn3#">
	SELECT ISNULL(NUMBER_OF_INSTALMENT,0) NUMBER_OF_INSTALMENT FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #attributes.payMethodId_#
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
			ISNULL(NUMBER_OF_INSTALMENT,0) = #getPaymentInstalment.NUMBER_OF_INSTALMENT#
		<cfelse>
			NUMBER_OF_INSTALMENT IS NULL
		</cfif>
</cfquery>
<div class="form-group" id="item-pay_method">
	<label class="col col-4 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'> *</label>
	<div class="col col-8 col-xs-12">
		<select name="pay_method" id="pay_method" multiple="multiple" style="width:250px;">
			<cfoutput query="payment_type_all">
				<option value="#payment_type_id#">#card_no#</option>
			</cfoutput>
		</select>                                     
	</div> 
</div>
<cfabort>

