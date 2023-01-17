<cfsetting showdebugoutput="no">
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

<table class="ajax_list">
    <tbody>
        <cfform name="form_credit_cards" method="post" action="">
            <cfquery name="GET_CC_COMPANY" datasource="#DSN#">
                SELECT
                    CC.*,
                    SC.CARDCAT
                FROM
                    COMPANY_CC CC,
                    SETUP_CREDITCARD SC
                WHERE
                    CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
                    <cfif xml_passive_cc eq 1>
                        (CC.IS_DEFAULT = 1 OR CC.IS_DEFAULT = 0) AND
                    <cfelse>
                        CC.IS_DEFAULT = 1 AND
                    </cfif>
                    CC.COMPANY_CC_TYPE = SC.CARDCAT_ID
            </cfquery>
            <cfif get_cc_company.recordcount>
                <cfoutput query="get_cc_company">
                    <tr>
                        <cfset key_type = '#COMPANY_ID#'>
						<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                            <!--- anahtarlar decode ediliyor --->
                            <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                            <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                            <!--- kart no decode ediliyor --->
                            <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:company_cc_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                            <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                        <cfelse>
                            <cfset content = '#mid(Decrypt(company_cc_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(company_cc_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(company_cc_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(company_cc_number,key_type,"CFMX_COMPAT","Hex")))#'>
                        </cfif>
                        <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_list_credit_card&comp_id=#attributes.cpid#&ccid=#company_cc_id#','small','popup_list_credit_card')" class="tableyazi">
							<cfif IS_DEFAULT eq 0><font style="color:red"></cfif><b>#cardcat#</b>/#content#/<b>#company_ex_month# - #company_ex_year#</b><cfif IS_DEFAULT eq 0></font></cfif></a>
                        </td>
                        <td style="width:15px"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.popup_upd_credit_card&comp_id=#attributes.cpid#&ccid=#company_cc_id#&xml_cc_relation_control=#attributes.xml_cc_relation_control#&xml_same_credit_card_control=#xml_same_credit_card_control#&xml_deactivate_other_credit_cards=#xml_deactivate_other_credit_cards#')" class="tableyazi"><i class="fa fa-pencil" border="0"></i></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                </tr>
            </cfif>
        </cfform>
    </tbody>	
</table> 

