<!--- 
	FA-09102013
	kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
	Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
--->
<cf_xml_page_edit fuseact="member.detail_company">
<cfscript>
	getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
	getCCNOKey.dsn = dsn;
	getCCNOKey1 = getCCNOKey.getCCNOKey1();
	getCCNOKey2 = getCCNOKey.getCCNOKey2();
</cfscript>
<cfinclude template="../query/get_credit_card.cfm">
<cfquery name="get_subscription" datasource="#dsn3#">
	SELECT
		SUBSCRIPTION_NO,
		SUBSCRIPTION_HEAD,
		IS_ACTIVE,
		CANCEL_TYPE_ID,
		CANCEL_DATE,
		START_DATE
	FROM
		SUBSCRIPTION_CONTRACT
	WHERE 
		<cfif isdefined('attributes.comp_id')>COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#"><cfelse>CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#"></cfif>
		AND MEMBER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
</cfquery>
<cfsavecontent variable="txt">
	<cfset key_type = '#GET_CREDIT_CARD.MEMBER_ID#'>
    <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
		<!--- anahtarlar decode ediliyor --->
        <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
        <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
        <!--- kart no decode ediliyor --->
        <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:GET_CREDIT_CARD.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
        <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
    <cfelse>
        <cfset content = '#mid(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex")))#'>
    </cfif>
    <cf_get_lang dictionary_id='30364.Kart Numarası'> : <cfoutput>#content#</cfoutput>
</cfsavecontent>
<cf_popup_box title="#txt#">
<cf_medium_list>
	<thead>
        <tr>
            <th colspan="5"><cf_get_lang dictionary_id='30520.SİSTEMLER'></th>
        </tr>
        <tr>
            <th><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='58233.Tanım'></th>
            <th align="center"><cf_get_lang dictionary_id='29522.Sözleşme'></th>
            <th align="center"><cf_get_lang dictionary_id='57748.İptal Tarihi'></th>
            <th><cf_get_lang dictionary_id='57756.Durum'></th>
        </tr>
    </thead>
    <tbody>
		<cfoutput query="get_subscription">
            <tr>
                <td><cfif len(subscription_no)>
                        <cfif len(cancel_type_id)><font style="color:red">#subscription_no#</font><cfelse>#subscription_no#</cfif>
                    </cfif>
                </td>
                <td><cfif len(subscription_head)>
                        <cfif len(cancel_type_id)><font style="color:red">#subscription_head#</font><cfelse>#subscription_head#</cfif>
                    </cfif>
                </td>
                <td align="center">
                    <cfif len(start_date)>
                        <cfif len(cancel_type_id)><font style="color:red">#dateformat(start_date,dateformat_style)#</font><cfelse>#dateformat(start_date,dateformat_style)#</cfif>
                    <cfelse>
                        -
                    </cfif>
                </td>
                <td align="center">
                    <cfif len(cancel_date)>
                        <cfif len(cancel_type_id)><font style="color:red">#dateformat(cancel_date,dateformat_style)#</font><cfelse>#dateformat(cancel_date,dateformat_style)#</cfif>
                    <cfelse>
                        -
                    </cfif>
                </td>
                <td><cfif len(cancel_type_id)>
                        <font style="color:red"><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></font>
                    <cfelse>
                        <cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif>
                    </cfif>
                </td>
            </tr>
        </cfoutput>
    </tbody>
</cf_medium_list>
</cf_popup_box>
