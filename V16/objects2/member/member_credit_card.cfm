<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfsetting showdebugoutput="no">
<cfif isdefined('session.ww.userid')>
	<cfquery name="get_member_cc" datasource="#dsn#">
		SELECT 
			CONSUMER_CC_ID CCID,
			CONSUMER_ID MEMBER_ID,
			CONSUMER_CC_TYPE CARD_TYPE,
			CONSUMER_CC_NUMBER CARD_NO,
			CONSUMER_BANK_TYPE BANK_TYPE,
			CONSUMER_CARD_OWNER CARD_OWNER,
			CONSUMER_EX_MONTH EX_MONTH,
			CONSUMER_EX_YEAR EX_YEAR,
			SC.CARDCAT
		FROM 
			CONSUMER_CC CC,
			SETUP_CREDITCARD SC
		WHERE 
			CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			CC.CONSUMER_CC_TYPE = SC.CARDCAT_ID
	</cfquery>
<cfelse>
	<cfquery name="get_member_cc" datasource="#dsn#">
		SELECT 
			COMPANY_CC_ID CCID,
			COMPANY_ID MEMBER_ID,
			COMPANY_CC_TYPE CARD_TYPE,
			COMPANY_CC_NUMBER CARD_NO,
			COMPANY_BANK_TYPE BANK_TYPE,
			COMPANY_CARD_OWNER CARD_OWNER,
			COMPANY_EX_MONTH EX_MONTH,
			COMPANY_EX_YEAR EX_YEAR,
			SC.CARDCAT
		FROM 
			COMPANY_CC CC,
			SETUP_CREDITCARD SC
		WHERE 
			CC.COMPANY_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
			CC.COMPANY_CC_TYPE = SC.CARDCAT_ID
	</cfquery>
</cfif>
<table cellspacing="1" cellpadding="2" border="0" width="95%" align="center">
	 <tr height="35">
		<td colspan="3" class="formbold">
			<a onClick="gizle_goster(my_add_cc);" style="cursor:pointer;"><img src="/images/pod_add.gif" border="0"></a>
			<b>Yeni Kredi Kartı eklemek için tiklayiniz...<b>
		</td>
	</tr>
	<tr style="display:none;" id="my_add_cc">
		<td colspan="3">
			<cfinclude template="add_member_credit_card.cfm">
		</td>
	</tr>
	<cfif get_member_cc.recordcount>
		<cfset bank_name_list = ''>
		<cfoutput query="get_member_cc">
			<cfif len(card_type)>
				<cfset bank_name_list = listappend(bank_name_list,bank_type,',')>
			</cfif>
			<cfset bank_name_list = listsort(bank_name_list,"numeric","ASC",",")>
		</cfoutput>
		<cfif listlen(bank_name_list)>
			<cfquery name="get_bank_type" datasource="#dsn#">
				SELECT BANK_NAME,BANK_ID FROM SETUP_BANK_TYPES WHERE BANK_ID IN (#bank_name_list#) 
			</cfquery>
			<cfset bank_name_list = listsort(listdeleteduplicates(valuelist(get_bank_type.bank_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_member_cc">
			<tr>
				<td width="3%" class="txtbold">#currentrow# -</td>
				<td width="10%" class="formbold">Kard No</td>
				<td>:<cfset key_type = '#member_id#'>
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
                        <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:get_member_cc.card_no,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                        <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                    <cfelse>
                        <cfset content = '#mid(Decrypt(get_member_cc.card_no,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_member_cc.card_no,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_member_cc.card_no,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_member_cc.card_no,key_type,"CFMX_COMPAT","Hex")))#'>
                    </cfif>
                    #content#
				</td>
			</tr>
			<tr>
				<td></td>
				<td class="formbold">Banka</td>
				<td>: #get_bank_type.bank_name[listfind(bank_name_list,bank_type,',')]#</td>
			</tr>
			<tr>
				<td></td>
				<td class="formbold">Kart Tipi</td>
				<td>: <cfif len(card_type)>#cardcat#</cfif></td>
			</tr>
			<tr height="30">
				<td colspan="3" class="formbold">
					<a onClick="gizle_goster(my_upd_cc#ccid#);" style="cursor:pointer;"><img src="/images/pod_edit.gif" border="0"></a>
					<b> Kredi kartı bilgilerini değiştirmek için tiklayiniz... <b>
				</td>
			</tr>
			<tr style="display:none;" id="my_upd_cc#ccid#">
				<td colspan="3">
					<cfinclude template="upd_member_credit_card.cfm">
				</td>
			</tr>
			<cfif get_member_cc.recordcount neq currentrow>
				<tr>
					<td colspan="3"><hr style="height:0.1px;" color="CCCCCC"></td>
				</tr>
			</cfif>
		</cfoutput>
	</cfif>
</table>
