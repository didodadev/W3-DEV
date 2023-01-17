<!--- Banka ve objects2 modüllerinde kullanılan ortak kredi kartı no görüntüleme sayfasıdır AE&SM --->
<cfsetting showdebugoutput="no"><!--- Objects2 den ajax ile çağrılıyor debug açmayınız --->
<!--- 
	FA-09102013
	kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
	Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
--->
<cfscript>
	getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
	getCCNOKey.dsn = dsn;
	getCCNOKey1 = getCCNOKey.getCCNOKey1();
	getCCNOKey2 = getCCNOKey.getCCNOKey2();
</cfscript>

<cfif isDefined("attributes.ivr_info") and attributes.ivr_info eq 1 and isDefined("session.ep") and isdefined("attributes.consumer_id")><!--- objects2 sipariş sonlandırda ivr den kart bilgisi almak için --->
	<cfquery name="GET_CARD_INFO" datasource="#dsn#" maxrows="1">
		SELECT
			CONSUMER_ID	MEMBER_ID,
			0 MEMBER_CC_TYPE,
			CONSUMER_CC_NUMBER MEMBER_CC_NUMBER,
			''	MEMBER_CARD_OWNER,
			'' MEMBER_EX_MONTH,
			'' MEMBER_EX_YEAR,
			CONSUMER_CC_CVV MEMBER_CVS
		FROM
			CALL_ENTEGRASYON
		WHERE
			CONSUMER_ID = #attributes.consumer_id# AND
			IS_ACTIVE = 1 AND
			RECORD_DATE BETWEEN #DATEADD('n',-30,now())# AND #now()# AND
			CONSUMER_CC_NUMBER IS NOT NULL
		ORDER BY
			ID DESC
	</cfquery>
<cfelseif isdefined("attributes.consumer_cc_id") or isdefined("attributes.company_cc_id")>
	<cfif isdefined("attributes.consumer_cc_id") and len(attributes.consumer_cc_id)>	
		<cfquery name="GET_CARD_INFO" datasource="#dsn#">
			SELECT
				CONSUMER_ID	MEMBER_ID,
				CONSUMER_CC_TYPE MEMBER_CC_TYPE,
				CONSUMER_CC_NUMBER MEMBER_CC_NUMBER,
				CONSUMER_CARD_OWNER	MEMBER_CARD_OWNER,
				CONSUMER_EX_MONTH MEMBER_EX_MONTH,
				CONSUMER_EX_YEAR MEMBER_EX_YEAR,
				CONS_CVS MEMBER_CVS
			FROM
				CONSUMER_CC
			WHERE
				CONSUMER_CC_ID = #attributes.consumer_cc_id#
		</cfquery>
	<cfelseif isdefined("attributes.company_cc_id") and len(attributes.company_cc_id)>
		<cfquery name="GET_CARD_INFO" datasource="#dsn#">
			SELECT
				COMPANY_ID	MEMBER_ID,
				COMPANY_CC_TYPE MEMBER_CC_TYPE,
				COMPANY_CC_NUMBER MEMBER_CC_NUMBER,
				COMPANY_CARD_OWNER	MEMBER_CARD_OWNER,
				COMPANY_EX_MONTH MEMBER_EX_MONTH,
				COMPANY_EX_YEAR MEMBER_EX_YEAR,
				COMP_CVS MEMBER_CVS
			FROM
				COMPANY_CC
			WHERE
				COMPANY_CC_ID = #attributes.company_cc_id#
		</cfquery>	
	<cfelse>
		<cfset GET_CARD_INFO.recordcount = 0>
	</cfif>
<cfelse>
	<cfset GET_CARD_INFO.recordcount = 0>
	<cfquery name="GET_CARD_DSP" datasource="#dsn3#">
		SELECT ACTION_FROM_COMPANY_ID,CONSUMER_ID,CARD_NO FROM CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #attributes.cc_number_id#
	</cfquery>
	<cfif len(GET_CARD_DSP.ACTION_FROM_COMPANY_ID)>
		<cfset key_type = GET_CARD_DSP.ACTION_FROM_COMPANY_ID>
	<cfelseif len(GET_CARD_DSP.CONSUMER_ID)>
		<cfset key_type = GET_CARD_DSP.CONSUMER_ID>
	</cfif>
	<cf_popup_box title="#getLang('bank',193)# :">
		<table cellspacing="1" cellpadding="2" width="100%">
			<tr>
				<td>
					<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
					<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                        <!--- anahtarlar decode ediliyor --->
                        <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                        <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                        <!--- kart no encode ediliyor --->
                         <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:GET_CARD_DSP.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                         <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                    <cfelse>
                        <cfset content = '#mid(Decrypt(GET_CARD_DSP.CARD_NO,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(GET_CARD_DSP.CARD_NO,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(GET_CARD_DSP.CARD_NO,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(GET_CARD_DSP.CARD_NO,key_type,"CFMX_COMPAT","Hex")))#'>
                    </cfif>
					<cfoutput>
						<font size="+1">
							#content#
						</font>
					</cfoutput>
				</td>
			</tr>
		</table>
	</cf_popup_box>
</cfif>
<cfif GET_CARD_INFO.recordcount>
	<cfset key_type = GET_CARD_INFO.MEMBER_ID>
    <!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
	<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
        <!--- anahtarlar decode ediliyor --->
        <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
        <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
        <!--- kart no encode ediliyor --->
         <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:GET_CARD_INFO.MEMBER_CC_NUMBER,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
         <cfset new_card_no = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
    <cfelse>
    	<cfset content = '#Decrypt(GET_CARD_INFO.MEMBER_CC_NUMBER,key_type,"CFMX_COMPAT","Hex")#'>
        <cfset new_card_no = '#mid(Decrypt(GET_CARD_INFO.MEMBER_CC_NUMBER,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(GET_CARD_INFO.MEMBER_CC_NUMBER,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(GET_CARD_INFO.MEMBER_CC_NUMBER,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(GET_CARD_INFO.MEMBER_CC_NUMBER,key_type,"CFMX_COMPAT","Hex")))#'>
    </cfif>
	<cfoutput>
		<input type="hidden" name="ajax_card_no" id="ajax_card_no" value="#content#">
		<input type="hidden" name="ajax_card_no_dsp" id="ajax_card_no_dsp" value="#new_card_no#">
		<input type="hidden" name="ajax_card_owner" id="ajax_card_owner" value="#GET_CARD_INFO.MEMBER_CARD_OWNER#">
		<input type="hidden" name="ajax_ex_month" id="ajax_ex_month" value="#GET_CARD_INFO.MEMBER_EX_MONTH#">
		<input type="hidden" name="ajax_ex_year" id="ajax_ex_year" value="#GET_CARD_INFO.MEMBER_EX_YEAR#">
		<input type="hidden" name="ajax_cvv" id="ajax_cvv" value="#GET_CARD_INFO.MEMBER_CVS#">
		<input type="hidden" name="ajax_cvv_dsp" id="ajax_cvv_dsp" value="#Left(GET_CARD_INFO.MEMBER_CVS,1)#*#Right(GET_CARD_INFO.MEMBER_CVS,1)#">
	</cfoutput>
	<script type="text/javascript">
		function function_load()
		{
			if(document.getElementById('ajax_cvv_dsp'))
			{
				<cfif isdefined("attributes.limit_info")>
					if(document.getElementById('lim_dsp_card_no') != undefined)
					{
						document.getElementById('lim_dsp_card_no').value = document.getElementById('ajax_card_no_dsp').value;
						document.getElementById('lim_card_no').value = document.getElementById('ajax_card_no').value;
					}
					else
					{
						document.getElementById('lim_card_no').value = document.getElementById('ajax_card_no_dsp').value;
					}
					if(document.getElementById('lim_dsp_cvv_no') != undefined)
					{
						document.getElementById('lim_dsp_cvv_no').value = document.getElementById('ajax_cvv_dsp').value;
						document.getElementById('lim_cvv_no').value = document.getElementById('ajax_cvv').value;
					}
					else
					{
						document.getElementById('lim_cvv_no').value = document.getElementById('ajax_cvv_dsp').value;
					}
					document.getElementById('lim_card_owner').value = document.getElementById('ajax_card_owner').value;
					document.getElementById('lim_exp_month').value = document.getElementById('ajax_ex_month').value;
					document.getElementById('lim_exp_year').value = document.getElementById('ajax_ex_year').value;
				<cfelse>
					if(document.getElementById('dsp_card_no') != undefined)
					{
						document.getElementById('dsp_card_no').value = document.getElementById('ajax_card_no_dsp').value;
						document.getElementById('card_no').value = document.getElementById('ajax_card_no').value;
					}
					else
					{
						document.getElementById('card_no').value = document.getElementById('ajax_card_no_dsp').value;
					}
					if(document.getElementById('dsp_cvv_no') != undefined)
					{
						document.getElementById('dsp_cvv_no').value = document.getElementById('ajax_cvv_dsp').value;
						document.getElementById('cvv_no').value = document.getElementById('ajax_cvv').value;
					}
					else
					{
						document.getElementById('cvv_no').value = document.getElementById('ajax_cvv_dsp').value;
					}
					document.getElementById('card_owner').value = document.getElementById('ajax_card_owner').value;
					document.getElementById('exp_month').value = document.getElementById('ajax_ex_month').value;
					document.getElementById('exp_year').value = document.getElementById('ajax_ex_year').value;
				</cfif>
			}
			else
				setTimeout('function_load()',10);
		}
		function_load();
	</script>
</cfif>
