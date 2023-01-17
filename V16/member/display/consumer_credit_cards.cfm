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

<cfform name="form_credit_cards" method="post" action="">
		<table class="ajax_list">
			<cfquery name="GET_CONSUMER_CC" datasource="#DSN#">
				SELECT
					CC.*,
					SC.CARDCAT
				FROM
					CONSUMER_CC CC,
					SETUP_CREDITCARD SC
				WHERE
					CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#"> AND
					<cfif xml_passive_cc eq 1>
						(CC.IS_DEFAULT = 1 OR CC.IS_DEFAULT = 0) AND
					<cfelse>
						CC.IS_DEFAULT = 1 AND
					</cfif>
					CC.CONSUMER_CC_TYPE = SC.CARDCAT_ID
			</cfquery>	 	
			<cfif get_consumer_cc.recordcount>			
				<cfoutput query="get_consumer_cc">
					<tr id="kredi">
						<cfset key_type = '#CONSUMER_ID#'>
                        <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                            <!--- anahtarlar decode ediliyor --->
                            <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                            <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                            <!--- kart no decode ediliyor --->
                            <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:consumer_cc_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                            <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                        <cfelse>
                            <cfset content = '#mid(Decrypt(consumer_cc_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(consumer_cc_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(consumer_cc_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(consumer_cc_number,key_type,"CFMX_COMPAT","Hex")))#'>
                        </cfif>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=member.popup_upd_credit_card&cons_id=#url.cons_id#&ccid=#CONSUMER_CC_ID#&xml_cc_relation_control=#attributes.xml_cc_relation_control#&xml_same_credit_card_control=#xml_same_credit_card_control#&xml_deactivate_other_credit_cards=#xml_deactivate_other_credit_cards#','small','popup_upd_credit_card')" class="tableyazi">
							<cfif IS_DEFAULT eq 0><font style="color:red"></cfif><b>#cardcat#</b>/#content#/<B>#consumer_ex_month# - #consumer_ex_year#</b><cfif IS_DEFAULT eq 0></font></cfif></a>
                        </td>
						<td nowrap style="width:15px">
							<!--- <cfif session.ep.admin and is_credit_card_detail eq 1> --->
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_list_credit_card&cons_id=#attributes.cons_id#&ccid=#CONSUMER_CC_ID#','small','popup_list_credit_card')" class="tableyazi"><img src="/images/update_list.gif" border="0"></a><!--- </cfif> --->
						</td>
					</tr>
				</cfoutput>				
			<cfelse>
				<tr> <!--- id="kredi" style="display:none" --->
					<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>
			</cfif>	
		</table>
</cfform> 

