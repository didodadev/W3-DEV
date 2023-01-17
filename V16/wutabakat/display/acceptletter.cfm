<cfif isdefined("attributes.type") and isnumeric(attributes.type) and isdefined("attributes.cspid") and isnumeric(attributes.cspid) and isdefined("attributes.uuid") and len(attributes.uuid) and isdefined("attributes.capyval") and isnumeric(attributes.capyval) and isdefined("attributes.mmxid") and isnumeric(attributes.mmxid) and isdefined("attributes.ocid") and isnumeric(attributes.ocid) and isdefined("attributes.pid") and isnumeric(attributes.pid) and isdefined("attributes.isbxbsam") and isnumeric(attributes.isbxbsam)>
<script type="text/javascript" src="/JS/js_functions_all.js"></script>
<link rel="stylesheet" type="text/css" href="/JS/js_calender/css/jscal2.css">
<link rel="stylesheet" type="text/css" href="/JS/js_calender/css/border-radius.css">
<script type="text/javascript" src="/JS/js_calender/js/jscal2.js"></script>
<script type="text/javascript" src="index.cfm?fuseaction=home.emptypopup_calender_functions"></script>
<script type="text/javascript" src="index.cfm?fuseaction=home.emptypopup_special_functions&this_fuseact=myhome.welcome"></script>
<script type="text/javascript" src="/JS/js_functions_money_tr.js"></script>
<script type="text/javascript" src="/JS/js_functions.js"></script>
<script type="text/javascript" src="/JS/ajax.js"></script>
<script type="text/javascript" src="/JS/autocomplete.js"></script>
<script type="text/javascript" src="fckeditor/ckeditor.js"></script>
<link rel="stylesheet" href="/css/assets/template/w3_legacy.css" type="text/css" id="page_css">
<link rel="stylesheet" href="/css/assets/template/catalyst/catalyst.css" type="text/css">
<link rel="stylesheet" href="/css/assets/icons/simple-line/simple-line-icons.css" type="text/css">
<link rel="stylesheet" href="/css/assets/icons/icon-Set/icon-Set.css" type="text/css">
<link rel="stylesheet" href="/css/assets/icons/fontello/fontello.css" type="text/css">            
<link rel="stylesheet" href="/css/assets/template/gui_custom.css" type="text/css">
<script type="text/javascript" src="/JS/jquery.json-2.4.min.js"></script>
<cfscript>
	functions = CreateObject("component","WMO.functions");
	wrk_round = functions.wrk_round;
	filterNum = functions.filterNum;
	TLFORMAT = functions.TLFORMAT;
</cfscript>
<style type="text/css">
	body {
	margin:0 0 0 0;
	scrollbar-face-color:#a7caed;
	scrollbar-highlight-color:#f1f0ff; 
	scrollbar-shadow-color:#6699cc;
	scrollbar-3dlight-color:#FFFFFF;
	scrollbar-arrow-color:#000000;
	SCROLLBAR-TRACK-COLOR:#f1f0ff;
	scrollbar-darkshadow-color:#f1f0ff;
}
/*General*/
table,div{font-size:11px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;color :#333333;}
</style>
<cfquery name="get_comp_addr" datasource="#dsn#">
	SELECT 
		NICK_NAME,
		COMPANY_NAME,
		ADDRESS,
		TEL_CODE,
		TEL,
		FAX,
		WEB,
		EMAIL,
		ASSET_FILE_NAME2 
	FROM 
		OUR_COMPANY 
	WHERE
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ocid#">
</cfquery>
<cfquery name="GETPERIOD" datasource="#dsn#">
	SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.pid# AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ocid#">
</cfquery>
<cfif getperiod.recordcount gt 0>
<cfset dsn2 = dsn &"_"&getperiod.period_year&"_"&attributes.ocid>
<cfif len(get_comp_addr.ASSET_FILE_NAME2)>
	<cfset attributes.mail_logo = "/documents/settings/"&get_comp_addr.ASSET_FILE_NAME2>
<cfelse>
	<cfset attributes.mail_logo = "/documents/templates/info_mail/logobig.gif">
</cfif> 
<table cellpadding="0" cellspacing="0" align="center" width="800" style="margin-left:50px;">
	<tr><td height="40"></td></tr>
	<tr>
		<td align="center" height="90"><img border="0" src="<cfoutput>#attributes.mail_logo#</cfoutput>"/></td>
	</tr>
</table>

<cfquery name="GETCARILETTER" datasource="#dsn2#">
	SELECT 
		CARI_LETTER.IS_CH, 
		CARI_LETTER.IS_CR, 
		CARI_LETTER.IS_BA, 
		CARI_LETTER.IS_BS,
		CARI_LETTER_ROW.COMPANY_ID,
		CARI_LETTER_ROW.CARI_STATUS,
		CARI_LETTER_ROW.IS_CH_AMOUNT,
		CARI_LETTER_ROW.IS_CR_AMOUNT,
		CARI_LETTER_ROW.IS_BA_TOTAL,
		CARI_LETTER_ROW.IS_BA_AMOUNT,
		CARI_LETTER_ROW.IS_BS_TOTAL,
		CARI_LETTER_ROW.IS_BS_AMOUNT
	FROM 
		CARI_LETTER,
		CARI_LETTER_ROW  
	WHERE 
		CARI_LETTER.CARI_LETTER_ID = <cfqueryparam value="#attributes.mmxid#"  cfsqltype="cf_sql_integer"> AND 
		CARI_LETTER.CARI_LETTER_ID = CARI_LETTER_ROW.CARI_LETTER_ID AND 
		CARI_LETTER_ROW.COMPANY_ID = <cfqueryparam value="#attributes.cspid#"  cfsqltype="cf_sql_integer"> AND 
		UNIQUE_ID = <cfqueryparam value="#attributes.uuid#"  cfsqltype="cf_sql_varchar">
</cfquery>
<cfif getcariletter.recordcount gt 0>
	<cfif isdefined("attributes.issubmit")>
		<cfif attributes.capyval eq 1395798571 or attributes.capyval eq 1395798570>
		<cfquery name="UPDLETTER" datasource="#dsn2#">
			UPDATE 
				CARI_LETTER_ROW
			SET
				<!--- Mutabakat --->
				<cfif getcariletter.is_ch eq 1>
					ACCEPT_AMOUNT =  <cfif isdefined("attributes.is_ch_amount") and len(attributes.is_ch_amount)>#filternum(attributes.is_ch_amount)#<cfelse>0</cfif>,
				</cfif>
				<!--- Cari Hatırlatma --->
				<cfif getcariletter.is_cr eq 1>
					ACCEPT_AMOUNT =  <cfif isdefined("attributes.is_cr_amount") and len(attributes.is_cr_amount)>#filternum(attributes.is_cr_amount)#<cfelse>0</cfif>,
				</cfif>
				<!--- BA --->
				<cfif getcariletter.is_ba eq 1>
					ACCEPT_TOTAL = <cfif isdefined("attributes.is_ba_total") and len(attributes.is_ba_total)>#filternum(attributes.is_ba_total)#<cfelse>0</cfif>,
					ACCEPT_AMOUNT = <cfif isdefined("attributes.is_ba_amount") and len(attributes.is_ba_amount)>#filternum(attributes.is_ba_amount)#<cfelse>0</cfif>,
				</cfif>
				<!--- BS --->
				<cfif getcariletter.is_bs eq 1>
					ACCEPT_TOTAL = <cfif isdefined("attributes.is_bs_total") and len(attributes.is_bs_total)>#filternum(attributes.is_bs_total)#<cfelse>0</cfif>,
					ACCEPT_AMOUNT = <cfif isdefined("attributes.is_bs_amount") and len(attributes.is_bs_amount)>#filternum(attributes.is_bs_amount)#<cfelse>0</cfif>,
				</cfif>
				
				ACCEPT_NAME = <cfqueryparam value="#attributes.namesurname#" cfsqltype="cf_sql_varchar">,
				ACCEPT_DETAIL = <cfqueryparam value="#attributes.detail#" cfsqltype="cf_sql_varchar">,
				ACCEPT_TYPE = 2,
				ACCEPT_STATUS = <cfif attributes.capyval eq 1395798571>1</cfif><cfif attributes.capyval eq 1395798570>0</cfif>,
				
				
				ACCEPT_USER = -1,
				ACCEPT_DATE = #now()#,
				ACCEPT_IP = '#cgi.remote_addr#'
			WHERE 
				CARI_LETTER_ID = <cfqueryparam value="#attributes.mmxid#"  cfsqltype="cf_sql_integer"> AND 
				COMPANY_ID = <cfqueryparam value="#attributes.cspid#"  cfsqltype="cf_sql_integer"> AND 
				UNIQUE_ID = <cfqueryparam value="#attributes.uuid#"  cfsqltype="cf_sql_varchar">
		</cfquery>
		<table cellpadding="0" cellspacing="0" align="center" width="800" style="margin-left:50px;border:1px solid #E5E5E5">
			<tr>
				<td height="30">&nbsp;</td>
			</tr>
			<tr>
				<td width="30">&nbsp;</td>
				<td colspan="2"><b>Talebiniz kayıt altına alınmıştır. Teşekkür ederiz....</b></td>
			</tr>
			<tr>
				<td height="30">&nbsp;</td>
			</tr>
		</table>
		</cfif>
	<cfelse>
		<cfset recorddatevalue = dateadd("h",0,now())>
		<cfoutput>
			<cfif attributes.capyval eq 1395798571>
				<cfset action_ = "#fusebox.server_machine_list#/wex.cfm/wutabakat?type=10345&cspid=#attributes.cspid#&uuid=#attributes.uuid#&capyval=1395798571&mmxid=#attributes.mmxid#&ocid=#attributes.ocid#&pid=#attributes.pid#&isbxbsam=0">
			<cfelseif attributes.capyval eq 1395798570>
				<cfset action_ = "#fusebox.server_machine_list#/wex.cfm/wutabakat?type=10345&cspid=#attributes.cspid#&uuid=#attributes.uuid#&capyval=1395798570&mmxid=#attributes.mmxid#&ocid=#attributes.ocid#&pid=#attributes.pid#&isbxbsam=0">
			</cfif>
		</cfoutput>
		<form name="submitform" method="post" action="#action_#">
		<input type="hidden" name="issubmit" value="true" />
		<input type="hidden" name="type" value="<cfoutput>#attributes.type#</cfoutput>" />
		<input type="hidden" name="cspid" value="<cfoutput>#attributes.cspid#</cfoutput>" />
		<input type="hidden" name="uuid" value="<cfoutput>#attributes.uuid#</cfoutput>" />
		<input type="hidden" name="capyval" value="<cfoutput>#attributes.capyval#</cfoutput>" />
		<input type="hidden" name="mmxid" value="<cfoutput>#attributes.mmxid#</cfoutput>" />
		<input type="hidden" name="ocid" value="<cfoutput>#attributes.ocid#</cfoutput>" />
		<input type="hidden" name="pid" value="<cfoutput>#attributes.pid#</cfoutput>" />
		<input type="hidden" name="isbxbsam" value="<cfoutput>#attributes.isbxbsam#</cfoutput>" />
		<table cellpadding="0" cellspacing="0" align="center" width="800" style="margin-left:50px;border:1px solid #E5E5E5">
			<tr>
				<td height="30">&nbsp;</td>
			</tr>
			<tr>
				<td width="30">&nbsp;</td>
				<td colspan="2"><b>Sayın yetkili. Tarafınıza gönderilen mutabakat mektubundaki miktarı <cfif attributes.capyval eq 1395798571>onayladınız</cfif><cfif attributes.capyval eq 1395798570>red ettiniz</cfif>. Lütfen aşağıdaki bilgileri doldurarak tarafımıza gönderiniz...</b></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<cfif getcariletter.is_ch eq 1>
				<tr>
					<td>&nbsp;</td>
					<td style="font-weight:bold;">Tutar</td>
					<td align="center" nowrap><input style="width:150px;" type="text" name="is_ch_amount" id="is_ch_amount" value="<cfoutput>#tlformat(getcariletter.is_ch_amount)#</cfoutput>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> TL (<cfif getcariletter.cari_status eq 1>Borç</cfif><cfif getcariletter.cari_status eq 0>Alacak</cfif>)</td>
				</tr>
			</cfif>
			<cfif getcariletter.is_cr eq 1>
				<tr>
					<td>&nbsp;</td>
					<td style="font-weight:bold;">Tutar</td>
					<td align="center" nowrap><input style="width:150px;" type="text" name="is_cr_amount" id="is_cr_amount" value="<cfoutput>#tlformat(getcariletter.is_cr_amount)#</cfoutput>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> TL (<cfif getcariletter.cari_status eq 1>B</cfif><cfif getcariletter.cari_status eq 0>A</cfif>)</td>
				</tr>
			</cfif>
			<cfif getcariletter.is_ba eq 1>	
				<tr>
					<td>&nbsp;</td>
					<td style="font-weight:bold;">Miktar</td>
					<td align="center" nowrap><input style="width:80px;" type="text" name="is_ba_total" id="is_ba_total" value="<cfoutput>#getcariletter.is_ba_total#</cfoutput>" onKeyUp="isNumber(this);" class="moneybox"></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td style="font-weight:bold;">Tutar</td>
					<td align="center" nowrap><input style="width:150px;" type="text" name="is_ba_amount" id="is_ba_amount" value="<cfoutput>#tlformat(getcariletter.is_ba_amount)#</cfoutput>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> TL</td>
				</tr>
			</cfif>
			<cfif getcariletter.is_bs eq 1>	
				<tr>
					<td>&nbsp;</td>
					<td style="font-weight:bold;">Miktar</td>
					<td align="center" nowrap><input style="width:80px;" type="text" name="is_bs_total" id="is_bs_total" value="<cfoutput>#getcariletter.is_bs_total#</cfoutput>" onKeyUp="isNumber(this);" class="moneybox"></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td style="font-weight:bold;">Tutar</td>
					<td align="center" nowrap><input style="width:150px;" type="text" name="is_bs_amount" id="is_bs_amount" value="<cfoutput>#tlformat(getcariletter.is_bs_amount)#</cfoutput>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> TL</td>
				</tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>&nbsp;</td>
				<td style="font-weight:bold;">Yetkili İsim Soyisim</td>
				<td><input type="text" name="namesurname" style="width:400px;"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>&nbsp;</td>
				<td style="font-weight:bold;">Açıklama</td>
				<td><textarea name="detail" style="width:400px;height:100px;"></textarea></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td><input type="submit" name="save" value="Bakiye Gönder" onclick='return AcceptConfirm()'/></td>
			</tr>
			<tr>
				<td height="30">&nbsp;</td>
			</tr>
		</table>
		</form>
		<script language="javascript">
			function AcceptConfirm()
			{
				<cfif getcariletter.is_ch eq 1>
					if(document.submitform.is_ch_amount.value=="")
					{
						alert("Lütfen Tutar Giriniz!");
						return false;
					}
				</cfif>
				<cfif getcariletter.is_cr eq 1>
					if(document.submitform.is_cr_amount.value=="")
					{
						alert("Lütfen Tutar Giriniz!");
						return false;
					}
				</cfif>
				<cfif getcariletter.is_ba eq 1>
					if(document.submitform.is_ba_total.value=="")
					{
						alert("Lütfen Miktar Giriniz!");
						return false;
					}
					if(document.submitform.is_ba_amount.value=="")
					{
						alert("Lütfen Tutar Giriniz!");
						return false;
					}
				</cfif>
				<cfif getcariletter.is_bs eq 1>
					if(document.submitform.is_bs_total.value=="")
					{
						alert("Lütfen Miktar Giriniz!");
						return false;
					}
					if(document.submitform.is_bs_amount.value=="")
					{
						alert("Lütfen Tutar Giriniz Giriniz!");
						return false;
					}
				</cfif>
				if(document.submitform.namesurname.value=="")
				{
					alert("Lütfen Yetkili İsim Soyisim Giriniz!");
					return false;
				}
				if(confirm("Bakiyeyi Tarafımıza Göndermek İstediğinizden Emin misiniz?")) 
				{
					return true;
				} 
				else 
				{
					return false;
				}
			}
		</script>
	</cfif>
</cfif>
<table cellpadding="0" cellspacing="0" align="center" width="800" style="margin-left:50px;">
	<tr><td height="20"></td></tr>
	<tr>
		<td colspan="2" class="unbold" style="font-size:13px;">
		<cfoutput>
			#get_comp_addr.company_name#<br>
			#get_comp_addr.address#<br>
			Tel: #get_comp_addr.tel_code# #get_comp_addr.tel# Fax: #get_comp_addr.tel_code# #get_comp_addr.fax#<br>
			<a href="mailto:#get_comp_addr.web#">#get_comp_addr.web#</a>
		</cfoutput>
		<br /><br />
		</td>
	</tr>
</table>
</cfif>
</cfif>