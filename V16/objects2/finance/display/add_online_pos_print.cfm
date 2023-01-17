<cfif not isDefined("attributes.cc_id")>
	<script type="text/javascript">
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_CC_ACTION" datasource="#dsn3#">
	SELECT
		*
	FROM
		CREDIT_CARD_BANK_PAYMENTS
	WHERE
		CREDITCARD_PAYMENT_ID = #attributes.cc_id# AND
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)><!--- işlem bitimindeki --->
		ACTION_FROM_COMPANY_ID = #attributes.company_id#
	<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
		CONSUMER_ID = #attributes.consumer_id#
	<cfelseif isDefined("session.pp")>
		ACTION_FROM_COMPANY_ID = #session.pp.company_id#
	<cfelse>
		CONSUMER_ID = #session.ww.userid#
	</cfif>
</cfquery>
<cfif not GET_CC_ACTION.recordcount>
	<script type="text/javascript">
		alert('Tahsilat Kaydı Bulunamamıştır!');
		<cfif isdefined("attributes.ajax_window")>
			closeframewindow(1,1);
		<cfelse>
			window.close();
		</cfif>
	</script>
<cfelse>
	<cfoutput>
		<table width="100%" height="100%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
		<tr class="color-list">
			<td class="headbold" height="35" width="100%">SANAL POS KREDİ KARTI ÖDEME FORMU</td>
			<!-- sil --><cf_workcube_file_action print='1'><!-- sil -->
		</tr>
		  <tr>
			<td class="color-row" valign="top" colspan="2">
			  <table>
				<cfif len(GET_CC_ACTION.ACTION_FROM_COMPANY_ID)>
					<cfquery name="GET_COMPANY_INFO" datasource="#DSN#">
						SELECT MEMBER_CODE,FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cc_action.action_from_company_id#">
					</cfquery>
					<cfset key_type = GET_CC_ACTION.ACTION_FROM_COMPANY_ID>
				<cfelse>
					<cfquery name="GET_CONSUMER_INFO" datasource="#DSN#">
						SELECT MEMBER_CODE,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cc_action.consumer_id#">
					</cfquery>
					<cfset key_type = GET_CC_ACTION.CONSUMER_ID>
				</cfif>
				<tr height="20">
					<td></td>
					<td class="txtbold"></td>
					<td><b><cf_get_lang_main no='330.Tarih'> :</b>&nbsp;&nbsp;#dateformat(GET_CC_ACTION.STORE_REPORT_DATE,'dd/mm/yyyy')#</td>
				</tr>
				<tr>
					<td></td>
					<td class="txtbold"></td>
					<td><b>Bayi Cari Kodu :</b>
						<cfif len(GET_CC_ACTION.ACTION_FROM_COMPANY_ID)>
							#GET_COMPANY_INFO.MEMBER_CODE#
						<cfelse>
							#GET_CONSUMER_INFO.MEMBER_CODE#
						</cfif>
					</td>
				</tr>
				<cfif len(GET_CC_ACTION.ORDER_ID)>
					<cfquery name="GET_ORDER_INFO" datasource="#DSN3#">
						SELECT ORDER_NUMBER,ORDER_DATE FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cc_action.order_id#">
					</cfquery>
					<tr height="20">
						<td class="txtbold"><cf_get_lang_main no='799.Siparis No'> :</td>
						<td>#GET_ORDER_INFO.ORDER_NUMBER#</td>
						<td></td>
					</tr>
					<tr height="20">
						<td class="txtbold"><cf_get_lang_main no='1704.Sipariş Tarihi'> :</td>
						<td>#dateformat(GET_ORDER_INFO.ORDER_DATE,'dd/mm/yyyy')#</td>
						<td></td>
					</tr>
				</cfif>
				<tr height="20">
					<td class="txtbold"><cf_get_lang no='257.Firma Adı'> :</td>
					<td>
						<cfif len(GET_CC_ACTION.ACTION_FROM_COMPANY_ID)>
							<cfset firma_name = GET_COMPANY_INFO.FULLNAME>
						<cfelse>
							<cfset firma_name = GET_CONSUMER_INFO.CONSUMER_NAME & ' ' & GET_CONSUMER_INFO.CONSUMER_SURNAME>
						</cfif>
						#firma_name#
					</td>
					<td></td>	
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang no='260.Kart Hamili'> :</td>
					<td>#GET_CC_ACTION.CARD_OWNER#</td>
					<td></td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang no='258.Kart Numarası'> :</td>
					<td>
					<cfif len(GET_CC_ACTION.CARD_NO)>
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
						
						<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
						<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
							<!--- anahtarlar decode ediliyor --->
							<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
							<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
							<!--- kart no encode ediliyor --->
							<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:GET_CC_ACTION.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
							<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
						<cfelse>
							<cfset content = '#mid(Decrypt(GET_CC_ACTION.CARD_NO,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(GET_CC_ACTION.CARD_NO,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(GET_CC_ACTION.CARD_NO,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(GET_CC_ACTION.CARD_NO,key_type,"CFMX_COMPAT","Hex")))#'>
						</cfif>
                        #content#
					</cfif>
					</td>
					<td></td>	
				</tr>
				<tr height="20">
					<cfquery name="GET_PAY_METHOD" datasource="#dsn3#">
						SELECT * FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cc_action.payment_type_id#">
					</cfquery>						
					<td class="txtbold"><cf_get_lang_main no='1104.Ödeme Yöntemi'> :</td>
					<td>#GET_PAY_METHOD.CARD_NO#</td>
					<td></td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang_main no='261.Tutar'> :</td>
					<td>#TLFormat(GET_CC_ACTION.sales_credit)# #GET_CC_ACTION.ACTION_CURRENCY_ID#</td>
					<td></td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang_main no='217.Açıklama'> :</td>
					<td>#GET_CC_ACTION.ACTION_DETAIL#</td>
					<td></td>
				</tr>
				<tr height="40">
					<td colspan="3">
						Sanal POS ile Kredi kartımdan çekilen #TLFormat(GET_CC_ACTION.sales_credit)# #GET_CC_ACTION.ACTION_CURRENCY_ID# Tutarının #firma_name# firması adına <cfif isDefined("session.ep")>#session.ep.company#<cfelse>#session_base.our_name#</cfif> 'ye ödemiş bulunduğumu, ilgili firma ile <br/>
						aramda oluşabilecek anlaşmazlıktan dolayı <cfif isDefined("session.ep")>#session.ep.company#<cfelse>#session_base.our_name#</cfif> ‘yi sorumlu tutmayacağımı beyan ve taahhüt ederim.
					</td>
				</tr>
				<tr height="30">
					<td></td>
					<td><b><cf_get_lang no='259.Kredi Kartı Sahibinin İmzası'>: </b></td>
					<td></td>
				</tr>
				<tr height="20"><td colspan="3"></td></tr>
				<tr height="40">
					<td colspan="3">
						2.BÖLÜM 
						(Bu bölüm <cfif isDefined("session.ep")>#session.ep.company#<cfelse>#session_base.our_name#</cfif> 'nin müşterisi olan firma tarafından doldurulacaktır.)<br/>
						Sanal POS ile kredi kartından çekilen #TLFormat(GET_CC_ACTION.sales_credit)# #GET_CC_ACTION.ACTION_CURRENCY_ID# Tutarın <cfif isDefined("session.ep")>#session.ep.company#<cfelse>#session_base.our_name#</cfif> 'nin nezdindeki cari hesabımıza alacak kaydedilmesini,<br/>
						çekilen tutara kredi kartı sahibinin isteği doğrultusunda banka tarafından bloke konur ve <cfif isDefined("session.ep")>#session.ep.company#<cfelse>#session_base.our_name#</cfif> 'nin hesaplarına aktarılmaz <br/>
						ise ; ilgili tutarı her türlü gecikme faizleri ile birlikte <cfif isDefined("session.ep")>#session.ep.company#<cfelse>#session_base.our_name#</cfif> 'nin talep ettiği tarihte nakit olarak <cfif isDefined("session.ep")>#session.ep.company#<cfelse>#session_base.our_name#</cfif> 'ye ödeyeceğimizi<br/>
						beyan ve taahhüt ederiz. 
					</td>
				</tr>
				<tr height="30">
					<td></td>
					<td><b>Müşteri İmzası: </b></td>
					<td><b>Bilgilerin doğruluğunu kabul ve tasdik eden<br/>BAYİ İMZA VE KAŞESİ</b></td>
				</tr>
			  </table>
			</td>
		  </tr>
		</table>
	</cfoutput>
</cfif>
<script type="text/javascript">
<cfif use_https>
	window.defaultStatus="Bu sayfada SSL Kullanılmaktadır."
</cfif>
</script>
