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

<cfif attributes.comp_id eq 1>
    <cfquery name="GET_CREDIT_CARD_HISTORY" datasource="#DSN#">
        SELECT 
        	IS_DEFAULT,
            COMPANY_ID AS MEMBER_ID,
        	COMPANY_CC_TYPE AS CC_TYPE,
            COMPANY_BANK_TYPE AS BANK_TYPE,
            COMPANY_CC_NUMBER AS CC_NUMBER,
            COMPANY_CARD_OWNER AS CARD_OWNER,
            COMPANY_EX_MONTH AS EX_MONTH,
            COMPANY_EX_YEAR AS EX_YEAR,
            RESP_CODE,
            (SELECT CARDCAT FROM SETUP_CREDITCARD WHERE CARDCAT_ID=COMPANY_CC_HISTORY.COMPANY_CC_TYPE) AS CARD_TYPE, 
            COMP_CVS AS CVS,
            ACC_OFF_DAY,
            RECORD_EMP,
            (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME   FROM EMPLOYEES E WHERE E.EMPLOYEE_ID=COMPANY_CC_HISTORY.RECORD_EMP) AS EMPLOYEE_RECORD_NAME,
            RECORD_DATE,
            UPDATE_EMP,
            (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME   FROM EMPLOYEES E WHERE E.EMPLOYEE_ID=COMPANY_CC_HISTORY.UPDATE_EMP) AS EMPLOYEE_UPDATE_NAME,
            UPDATE_DATE,
            (SELECT BANK_NAME FROM SETUP_BANK_TYPES SBT WHERE SBT.BANK_ID=COMPANY_CC_HISTORY.COMPANY_BANK_TYPE) AS BANK_NAME 
         FROM 
         	COMPANY_CC_HISTORY 
         WHERE 
         	COMPANY_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
         ORDER BY 
         	COMPANY_CC_HISTORY_ID   DESC
    </cfquery>
<cfelse>
    <cfquery name="GET_CREDIT_CARD_HISTORY" datasource="#DSN#">
        SELECT
            IS_DEFAULT,
            CONSUMER_ID AS MEMBER_ID,
        	CONSUMER_CC_TYPE AS CC_TYPE,
            CONSUMER_BANK_TYPE AS BANK_TYPE,
            CONSUMER_CC_NUMBER AS CC_NUMBER,
            CONSUMER_CARD_OWNER AS CARD_OWNER,
            CONSUMER_EX_MONTH AS EX_MONTH,
            CONSUMER_EX_YEAR AS EX_YEAR,
            RESP_CODE,
            (SELECT CARDCAT FROM SETUP_CREDITCARD WHERE CARDCAT_ID=CONSUMER_CC_HISTORY.CONSUMER_CC_TYPE) AS CARD_TYPE,
            CONS_CVS AS CVS,
            ACC_OFF_DAY,
            RECORD_EMP,
            (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME   FROM EMPLOYEES E WHERE E.EMPLOYEE_ID=CONSUMER_CC_HISTORY.RECORD_EMP) AS EMPLOYEE_RECORD_NAME,
            RECORD_DATE,
            UPDATE_EMP,
            (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME   FROM EMPLOYEES E WHERE E.EMPLOYEE_ID=CONSUMER_CC_HISTORY.UPDATE_EMP) AS EMPLOYEE_UPDATE_NAME,
            UPDATE_DATE,
            (SELECT BANK_NAME FROM SETUP_BANK_TYPES SBT WHERE SBT.BANK_ID=CONSUMER_CC_HISTORY.CONSUMER_BANK_TYPE) AS BANK_NAME 
        FROM 
        	CONSUMER_CC_HISTORY 
        WHERE 
        	CONSUMER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
         ORDER BY 
         	CONSUMER_CC_HISTORY_ID   DESC     
    </cfquery>	
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57473.Tarihçe"></cfsavecontent>
<cf_popup_box title="#message#">
	<table width="100%">
	<cfif get_credit_card_history.recordcount>
		<cfoutput query="get_credit_card_history">
			<cfset key_type = '#GET_CREDIT_CARD_HISTORY.MEMBER_ID#'>
            <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                <!--- anahtarlar decode ediliyor --->
                <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                <!--- kart no decode ediliyor --->
                <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:cc_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
            <cfelse>
                <cfset content = '#mid(Decrypt(cc_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(cc_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(cc_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(cc_number,key_type,"CFMX_COMPAT","Hex")))#'>
            </cfif>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id ='58515.Aktif/Pasif'></td>
				<td><cfif is_default eq 1><cf_get_lang dictionary_id ='57493.Aktif'><cfelse><cf_get_lang dictionary_id ='57494.Pasif'></cfif></td>
				<td style="width:15%"></td>
				<td class="txtbold"><cf_get_lang dictionary_id='30363.Kart Tipi'></td>
				<td>#card_type#</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57521.Banka'></td>
				<td>#bank_name#</td>
				<td style="width:15px"></td>
				<td class="txtbold"><cf_get_lang dictionary_id='30364.Kart Numarası'></td>
				<td>#content#</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id='30541.Kart Hamili'></td>
				<td>#card_owner#</td>
				<td style="width:15px"></td>
				<td class="txtbold"><cf_get_lang dictionary_id='30365.Son Kullanma Tarihi'></td>
				<td>
					<cfloop from="1" to="12" index="k">
						 <cfif ex_month eq k>#NumberFormat(k,00)#</cfif>
					</cfloop>
					<cf_get_lang dictionary_id='58724.Ay'>
					<cfloop from="#dateFormat(now(),'yyyy')-1#" to="#dateFormat(now(),'yyyy')+10#" index="i">
						<cfif get_credit_card_history.ex_year eq i>#i#</cfif>
					</cfloop>
					<cf_get_lang dictionary_id='58455.Yıl'>
				</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id='30542.CVS No'></td>
				<td>#Left(CVS, 1)#*#Right(CVS, 1)#</td>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id='30721.Hesap Kesim Günü'></td>
				<td>#acc_off_day#</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id ='30701.Dönüş Kodu'></td>
				<td>#resp_code#</td>
				<td colspan="3"></td>
			</tr>
		</cfoutput>      
		<cfelse>
			<tr>
				<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</table>
	<cf_popup_box_footer>
		<cf_record_info query_name="GET_CREDIT_CARD_HISTORY">
	</cf_popup_box_footer>
</cf_popup_box>
