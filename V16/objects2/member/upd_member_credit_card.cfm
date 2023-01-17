<cfsetting showdebugoutput="no">
<cfif isDefined("session.pp.company_id")>
	<cfquery name="GET_CREDIT_CARD" datasource="#dsn#">
		SELECT 
			COMPANY_CC_ID CCID,
			COMPANY_ID MEMBER_ID,
			COMPANY_CC_TYPE CARD_TYPE,
			COMPANY_CC_NUMBER CARD_NO,
			COMPANY_BANK_TYPE BANK_TYPE,
			COMPANY_CARD_OWNER CARD_OWNER,
			COMPANY_EX_MONTH EX_MONTH,
			COMPANY_EX_YEAR EX_YEAR,
			COMP_CVS CVS,
			IS_DEFAULT,
			ACC_OFF_DAY
		FROM 
			COMPANY_CC
		WHERE 
			COMPANY_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ccid#">
	</cfquery>
<cfelse>
	<cfquery name="GET_CREDIT_CARD" datasource="#dsn#">
		SELECT 
			CONSUMER_CC_ID CCID,
			CONSUMER_ID MEMBER_ID,
			CONSUMER_CC_TYPE CARD_TYPE,
			CONSUMER_CC_NUMBER CARD_NO,
			CONSUMER_BANK_TYPE BANK_TYPE,
			CONSUMER_CARD_OWNER CARD_OWNER,
			CONSUMER_EX_MONTH EX_MONTH,
			CONSUMER_EX_YEAR EX_YEAR,
			CONS_CVS CVS,
			IS_DEFAULT,
			ACC_OFF_DAY
		FROM 
			CONSUMER_CC
		WHERE 
			CONSUMER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ccid#">
	</cfquery>
</cfif>
<cfquery name="get_card" datasource="#dsn#">
	SELECT CARDCAT,CARDCAT_ID FROM SETUP_CREDITCARD
</cfquery>
<cfquery name="get_bank_type" datasource="#dsn#">
	SELECT BANK_NAME,BANK_ID FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfform method="post" name="upd_credit_card#get_credit_card.ccid#" action="#request.self#?fuseaction=objects2.emptypopup_add_member_credit_card">
	<input type="hidden" name="is_upd" id="is_upd" value="">
	<input type="hidden" name="is_del" id="is_del" value="">
	<input type="hidden" name="ccid" id="ccid" value="<cfoutput>#get_credit_card.ccid#</cfoutput>">
	<cfif isdefined('session.pp.company_id')>
		<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
		<input type="hidden" name="member_type" id="member_type" value="partner">
	<cfelse>
		<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.ww.userid#</cfoutput>">
		<input type="hidden" name="member_type" id="member_type" value="consumer">
	</cfif>
	<table>
		<tr>
			<td><cf_get_lang_main no ='81.Aktif'></td>
			<td><input type="checkbox" name="default_card" id="default_card" <cfif GET_CREDIT_CARD.IS_DEFAULT eq 1>checked</cfif>></td>
		</tr>
		<tr> 
			<td width="100">Kart Tipi</td>
			<td> 
				<select name="card_type" id="card_type" style="width:200px;">
					<option value="0"><cf_get_lang_main no ='322.Seiniz'>
					<cfoutput query="get_card">
						<option value="#CARDCAT_ID#" <cfif get_card.CARDCAT_ID eq GET_CREDIT_CARD.CARD_TYPE>selected</cfif>>#CARDCAT#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr> 
			<td width="100"><cf_get_lang_main no ='109.Banka'></td>
			<td>
				<select name="bank_type" id="bank_type" style="width:200px;">
					<option value=""><cf_get_lang_main no ='322.Seiniz'>
					<cfoutput query="get_bank_type">
						<option value="#BANK_ID#" <cfif get_bank_type.BANK_ID eq GET_CREDIT_CARD.BANK_TYPE>selected</cfif>>#BANK_NAME#</option>
					</cfoutput>
				</select> 
			</td>
		</tr>
		<tr> 
			<td>Kart Numarasi</td>
			<td>
				<cfsavecontent variable="message">Geçerli Bir Kredi Kartı Numarası Giriniz !</cfsavecontent>
				<cfset key_type = '#GET_CREDIT_CARD.MEMBER_ID#'>
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
					<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:GET_CREDIT_CARD.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
					<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
				<cfelse>
					<cfset content = '#mid(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex")))#'>
				</cfif>
                
				<cfinput type="Text" name="card_no" validate="creditcard" required="Yes" style="width:200px;" message="#message#" value="#content#" onKeyUp="isNumber(this);" maxlength="16">
			</td>
		</tr>
		<tr>
			<td>Kart Hamili</td>
			<td>
				<input type="Text" name="card_owner" id="card_owner" maxlength="50" value="<cfoutput>#GET_CREDIT_CARD.CARD_OWNER#</cfoutput>" style="width:200px;">
			</td>
		</tr>
		<tr>
			<td>Son Kullanma Tarihi</td>
			<td>
				<select name="month" id="month" style="width:70px;">
					<cfloop from="1" to="12" index="k">
						<cfoutput>
							<option value="#k#"<cfif GET_CREDIT_CARD.EX_MONTH eq k> selected </cfif>>#k#</option>
						</cfoutput> 
					</cfloop>
				</select>
				Ay&nbsp;&nbsp;&nbsp;
				<select name="year" id="year" style="width:80px;">
					<cfloop from="#dateFormat(now(),'yyyy')#" to="#dateFormat(now(),'yyyy')+10#" index="i">
						<cfoutput>
							<option value="#i#" <cfif GET_CREDIT_CARD.EX_YEAR eq i> selected </cfif>>#i#</option>
						</cfoutput>
					</cfloop>
				</select>
				Yil
			</td>
		</tr>
		<tr> 
			<td>CVV No</td>
			<td> 
				<cfsavecontent variable="message">CVV No Giriniz!</cfsavecontent>
				<cfif len(GET_CREDIT_CARD.CVS)>
					<cfinput type="text" name="CVS" validate="integer" message="#message#" value="#Left(GET_CREDIT_CARD.CVS, 1)#*#Right(GET_CREDIT_CARD.CVS, 1)#" onKeyUp="isNumber(this);" style="width:200px;" maxlength="3">
				<cfelse>
					<cfinput type="text" name="CVS" validate="integer" message="#message#" value=""  style="width:200px;" onKeyUp="isNumber(this);" maxlength="3">
				</cfif>
			</td>
		</tr>
		 <tr>
			<td>Hesap Kesim Günü</td>
			<td>
				<cfif len(GET_CREDIT_CARD.ACC_OFF_DAY)>
					<cfinput type="text" name="acc_off_date" value="#GET_CREDIT_CARD.ACC_OFF_DAY#" validate="integer" message="Hesap Kesim Günü Girmelisiniz !" onKeyUp="isNumber(this);" style="width:70px;">
				<cfelse>
					<cfinput type="text" name="acc_off_date" validate="integer" message="Hesap Kesim Günü Girmelisiniz !" onKeyUp="isNumber(this);" style="width:70px;">
				</cfif>
			</td>
		  </tr>
		<tr>
			<td></td>
			<td height="35">
				<cfif isdefined('session.pp.company_id')>
					<cf_workcube_buttons 
							is_cancel=0
							is_upd='1'
							is_delete=1
							add_function='cc_controls#get_credit_card.ccid#(1)'
							delete_page_url='#request.self#?fuseaction=objects2.emptypopup_add_member_credit_card&ccid=#get_credit_card.ccid#&member_type=partner'
							>
				<cfelse>
					<cf_workcube_buttons 
							is_cancel=0
							is_upd='1'
							is_delete=1
							add_function='cc_controls#get_credit_card.ccid#(1)'
							delete_page_url='#request.self#?fuseaction=objects2.emptypopup_add_member_credit_card&ccid=#get_credit_card.ccid#'
							>
				</cfif>
			</td>
		</tr>
	</table>
</cfform>
<script type="text/javascript">
	function cc_controls<cfoutput>#get_credit_card.ccid#</cfoutput>(type)
	{
		if(type == 1)
		{
			document.upd_credit_card<cfoutput>#get_credit_card.ccid#</cfoutput>.is_upd.value = 1;
		}
		else
		{
			document.upd_credit_card<cfoutput>#get_credit_card.ccid#</cfoutput>.is_del.value = 1;
		}
		
		if(document.upd_credit_card<cfoutput>#get_credit_card.ccid#</cfoutput>.card_type.value == 0)
		{
			alert("Lütfen Kredi Kartı Tipi Seçiniz !");
			return false;
		}
		if(document.upd_credit_card<cfoutput>#get_credit_card.ccid#</cfoutput>.card_no.value == '')
		{
			alert("Geçerli Bir Kredi Kartı Numarası Giriniz !");
			return false;
		}
		if(document.upd_credit_card<cfoutput>#get_credit_card.ccid#</cfoutput>.CVS.value == '')
		{
			alert("CVV No Giriniz!");
			return false;
		}
		d = new Date();
		if((document.upd_credit_card<cfoutput>#get_credit_card.ccid#</cfoutput>.year.value < d.getYear() && document.upd_credit_card<cfoutput>#get_credit_card.ccid#</cfoutput>.month.selectedIndex < d.getMonth()) || (document.upd_credit_card<cfoutput>#get_credit_card.ccid#</cfoutput>.year.value == d.getYear() && document.upd_credit_card<cfoutput>#get_credit_card.ccid#</cfoutput>.month.selectedIndex < d.getMonth()))
		{
			alert("Geçerlilik Tarihi Bu Dönemden Küçük Olamaz!");
			return false;
		}
		return true;
	}
</script>
