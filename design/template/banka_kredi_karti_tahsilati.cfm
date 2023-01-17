<!--- Kredi Kartı Tahsilatı --->
<cfquery name="GET_PAYMENT" datasource="#DSN3#">
	SELECT 
    	ACTION_FROM_COMPANY_ID,
        CONSUMER_ID,
        ACTION_TYPE_ID,
        CARD_NO,
        SALES_CREDIT,
        ACTION_DETAIL,
        STORE_REPORT_DATE,
        CREDITCARD_PAYMENT_ID 
    FROM 
    	CREDIT_CARD_BANK_PAYMENTS 
    WHERE 
    	CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfif len(get_payment.action_from_company_id)>
	<cfquery name="GET_MEMBER_INFO" datasource="#DSN3#">
		SELECT
			MEMBER_CODE,
			FULLNAME,
			COMPANY_ADDRESS ADDRESS,
			COUNTY,
			CITY,
			COUNTRY,
			SEMT,
			TAXOFFICE TAX_OFFICE,
			TAXNO TAX_NO
		FROM
			#dsn_alias#.COMPANY
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment.action_from_company_id#">
	</cfquery>
<cfelse>
	<cfquery name="GET_MEMBER_INFO" datasource="#DSN3#">
		SELECT 
			MEMBER_CODE,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			HOMEADDRESS ADDRESS,
			HOME_CITY_ID CITY,
			HOME_COUNTY_ID COUNTY,
			HOME_COUNTRY_ID COUNTRY,
			HOMESEMT SEMT,
			TAX_OFFICE,
			TAX_NO
		FROM 
			#dsn_alias#.CONSUMER
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment.consumer_id#">
	</cfquery>
</cfif>
<style type="text/css">
	<!--
	.style1 {font-size: 2}
	-->
</style>

<br/>
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td style="width:10mm;">&nbsp;</td>
		<td style="width:115mm;">
		<table border="0">
			<tr>
				<td align="center">
				<table>
					<tr>
						<td align="center" colspan="2" class="headbold">
						<cfif get_payment.action_type_id eq 241>
							<cf_get_lang_main no='424.Kredi Kartı Tahsilat'>
						<cfelseif get_payment.action_type_id eq 245>
							<cf_get_lang_main no='1755.Kredi Kartı Tahsilat İptal'>
						</cfif>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table border="0" style="width:115mm;">
					<tr style="height:6mm;">
						<td style="width:18mm;"><font size="2"><strong>C/H <cf_get_lang no="256.Kodu"></strong></font></td>
						<td style="width:40mm;">: <font size="2">#GET_MEMBER_INFO.MEMBER_CODE#</font></td>
						<td align="left" nowrap><font size="2"><strong><cf_get_lang_main no='1360.İşlem No'></strong></font></td>
						<td style="width:20mm;">: <font size="2">#GET_PAYMENT.creditcard_payment_id#</font></td>
					</tr>
					<tr>
						<td><font size="2"><strong><cf_get_lang_main no="159.Ünvanı"></strong></font></td>
						<td>: <font size="2"><strong><cfif len(GET_PAYMENT.ACTION_FROM_COMPANY_ID)>#GET_MEMBER_INFO.FULLNAME#<cfelse>#GET_MEMBER_INFO.CONSUMER_NAME# #GET_MEMBER_INFO.CONSUMER_SURNAME#</cfif></strong></font></td>
						<td align="left"><font size="2"><strong><cf_get_lang_main no='330.Tarih'></strong></font></td>
						<td style="width:20mm;">: <font size="2">#DateFormat(GET_PAYMENT.STORE_REPORT_DATE,dateformat_style)#</font></td>
					</tr>
					<tr>
						<td><font size="2"><strong><cf_get_lang_main no='1311.Adres'></strong></font></td>
						<td>: <font size="2">#GET_MEMBER_INFO.ADDRESS#</font></td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>: 
							<cfif len(GET_MEMBER_INFO.COUNTY)>
								<cfquery name="GET_COUNTY_HOME" datasource="#DSN3#">
									SELECT COUNTY_NAME FROM #dsn_alias#.SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_INFO.COUNTY#">
								</cfquery>
							</cfif>
							<cfif len(GET_MEMBER_INFO.CITY)>
								<cfquery name="GET_CITY_HOME" datasource="#DSN3#">
									SELECT CITY_NAME FROM #dsn_alias#.SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_INFO.CITY#">
								</cfquery>				  
							</cfif>
							<font size="2"><cfif len(GET_MEMBER_INFO.COUNTY)>#GET_COUNTY_HOME.COUNTY_NAME#</cfif>&nbsp;&nbsp;<cfif len(GET_MEMBER_INFO.CITY)>#GET_CITY_HOME.CITY_NAME#</cfif></font>
						</td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td></td>
						<td>: 
							<cfif len(GET_MEMBER_INFO.COUNTRY)>
								<cfquery name="GET_COUNTRY_HOME" datasource="#DSN3#">
									SELECT COUNTRY_NAME FROM #dsn_alias#.SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_INFO.COUNTRY#">
								</cfquery>
								<font size="2">#GET_COUNTRY_HOME.COUNTRY_NAME#</font>
							</cfif>
						</td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td><font size="2"><strong><cf_get_lang_main no='1350.Vergi D'></strong></font></td>
						<td>: <font size="2">#GET_MEMBER_INFO.TAX_OFFICE#</font></td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td><font size="2"><strong><cf_get_lang_main no='340.Vergi No'></strong></font></td>
						<td>: <font size="2">#GET_MEMBER_INFO.TAX_NO#</font></td>
						<td colspan="2"></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table border="0" style="width:115mm;">
					<tr align="center" height="30" class="formbold">
						<td style="width:80mm;"><font size="2"><cf_get_lang_main no='217.Açıklama'></font></td>
						<td style="text-align:right;"><font size="2"><cf_get_lang no="283.Meblağ"></font></td>
					</tr>
					<tr height="30" class="formbold">
						<cfif len(GET_PAYMENT.ACTION_FROM_COMPANY_ID)>
							<cfset key_type = GET_PAYMENT.ACTION_FROM_COMPANY_ID>
						<cfelseif len(GET_PAYMENT.CONSUMER_ID)>
							<cfset key_type = GET_PAYMENT.CONSUMER_ID>
						</cfif>
						<td><font size="2">
							<cfif len(GET_PAYMENT.CARD_NO)>
                            	<!--- 
									FA-09102013
									kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
									Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
								--->
								<cfscript>
									getCCNOKey = createObject("component", "settings.cfc.setupCcnoKey");
									getCCNOKey.dsn = dsn;
									getCCNOKey1 = getCCNOKey.getCCNOKey1();
									getCCNOKey2 = getCCNOKey.getCCNOKey2();
								</cfscript>
								
								<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
								<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
									<!--- anahtarlar decode ediliyor --->
									<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
									<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
									<!--- kart no encode ediliyor --->
									<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:GET_PAYMENT.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
									<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
								<cfelse>
									<cfset content = '#mid(Decrypt(GET_PAYMENT.CARD_NO,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(GET_PAYMENT.CARD_NO,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(GET_PAYMENT.CARD_NO,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(GET_PAYMENT.CARD_NO,key_type,"CFMX_COMPAT","Hex")))#'>
								</cfif>
                                #content#<br/>
                            </cfif>
                            </font>#GET_PAYMENT.action_detail#
                        </td>
						<td style="text-align:right;"><font size="2">#TLFormat(GET_PAYMENT.SALES_CREDIT)#</font></td>
					</tr>
					<tr height="30" class="formbold">
						<td style="text-align:right;"><font size="2"><cf_get_lang_main no='80.TOPLAM'></font></td>
						<td style="text-align:right;"><font size="2">#TLFormat(GET_PAYMENT.SALES_CREDIT)#</font></td>
					</tr>
					<tr>
						<td colspan="2" valign="top"><br/>
						<table border="0">
							<tr>
								<td><font size="2"><cf_get_lang no="284.Yukarda açıklaması yapılan toplam"> #TLFormat(GET_PAYMENT.SALES_CREDIT)# #session.ep.money#<br/><cf_get_lang no="375.cari hesabınıza"> <cfif get_payment.action_type_id eq 241><cf_get_lang_main no="176.Alacak"><cfelseif get_payment.action_type_id eq 245><cf_get_lang_main no="175.Borç"></cfif> <cf_get_lang_main no="1478.kaydedildi">.</font></td>
							</tr>
							<tr><td><br/><b><font size="2">#session.ep.company#</font></b></td></tr>
						</table>
					</td>
					</tr>
				
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</cfoutput>
