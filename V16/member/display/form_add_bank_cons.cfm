<cf_xml_page_edit fuseact="member.popup_form_add_bank_cons" is_multi_page="1">
<cfquery name="GET_BANK_NAMES" datasource="#DSN#">
	SELECT BANK_ID, BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfinclude template="../query/get_money.cfm">
<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
	<tr class="color-list">
		<td class="headbold" height="35"><cf_get_lang dictionary_id='59010.Banka Hesabı Ekle'></td>
	</tr>
	<tr class="color-row" valign="top">
		<td>
		<table>
		<cfform name="add_account" action="#request.self#?fuseaction=member.emptypopup_add_bank_account" method="post">
		<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#url.cid#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang dictionary_id='59009.Aktif Hesap'></td>
				<td><input type="checkbox" name="default_account" id="default_account" value="1" checked></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57521.Banka'> *</td>
				<td>
					<select name="account_bank_id" id="account_bank_id" style="width:220px;" onChange="set_bank_branch(this.value);">
                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                        <cfoutput query="get_bank_names">
                            <option value="#bank_id#;#bank_code#;#bank_name#">#bank_name#</option>
                        </cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57521.Banka'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30349.Banka Adı'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="bank_name" message="#message#" required="Yes" style="width:220px;" readonly>
					<cfelse>
						<cfinput type="text" name="bank_name" message="#message#" required="Yes" style="width:220px;">
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57453.Şube'> *</td>
				<td>
					<select name="account_branch_id" id="account_branch_id" style="width:220px;" onChange="set_branch_code(this.value);">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57453.Şube'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="branch_name" message="#message#" required="Yes" style="width:220px;" readonly>
					<cfelse>
						<cfinput type="text" name="branch_name" message="#message#" required="Yes" style="width:220px;">
					</cfif>
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='59006.Banka Kodu'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='59006.Banka Kodu'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="bank_code" message="#message#" onKeyUp="isNumber(this);" style="width:220px;" readonly>
					<cfelse>
						<cfinput type="text" name="bank_code" message="#message#" onKeyUp="isNumber(this);" style="width:220px;">
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='59005.Şube Kodu'></td>
				<td>
					<cfsavecontent variable="message">><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='59005.Şube Kodu'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="branch_code" message="#message#" onKeyUp="isNumber(this);" style="width:220px;" readonly>
					<cfelse>
						<cfinput type="text" name="branch_code" message="#message#" onKeyUp="isNumber(this);" style="width:220px;">
					</cfif>					
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58178.Hesap No'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58178.Hesap No'>!</cfsavecontent>
					<cfinput type="text" name="account_no" required="Yes" message="#message#" onKeyUp="isNumber(this);" style="width:220px;">
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='59007.IBAN Kodu'><cfif xml_iban_required> *</cfif></td>
				<td>
					<!--- BK Eski Hali 6 aya silinsin 20100615
					<cfif len(xml_iban_maxlength)>
						<cfinput type="text" name="iban_code" maxlength="#xml_iban_maxlength#" onBlur="isIBAN(this);" style="width:220px;">
					<cfelse>
						<cfinput type="text" name="iban_code" onBlur="isIBAN(this);" style="width:220px;">
					</cfif> --->
					<cf_wrkIbanCode fieldId='iban_code' iban_maxlength="#xml_iban_maxlength#" iban_required="#xml_iban_required#" width_info='220'>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57489.Para Birimi'></td>
				<td>
					<select name="money" id="money" style="width:220px;">
						<cfoutput query="get_money">
                            <option value="#money#">#money#</option>
                        </cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td height="35"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
			</tr>
		</cfform>   
		</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
function set_bank_branch(xyz)
{
	document.add_account.branch_code.value = "";
	if(xyz.split(';')[2]!= undefined)
		document.add_account.bank_name.value = xyz.split(';')[2];
	else
	{
		document.add_account.bank_name.value = "";
		document.add_account.branch_name.value = "";
	}
		
	if(xyz.split(';')[1]!= undefined)
		document.add_account.bank_code.value = xyz.split(';')[1];
	else
		document.add_account.bank_code.value = "";
	
	var bank_id_ = xyz.split(';')[0];
	var bank_branch_names = wrk_safe_query('mr_bank_branch_name','dsn3',0,bank_id_);


	var option_count = document.getElementById('account_branch_id').options.length; 
	for(x=option_count;x>=0;x--)
		document.getElementById('account_branch_id').options[x] = null;
	
	if(bank_branch_names.recordcount != 0)
	{	
		document.getElementById('account_branch_id').options[0] = new Option('Seçiniz','');
		for(var xx=0;xx<bank_branch_names.recordcount;xx++)
			document.getElementById('account_branch_id').options[xx+1]=new Option(bank_branch_names.BRANCH_CODE[xx]+'-'+bank_branch_names.BANK_BRANCH_NAME[xx],bank_branch_names.BANK_BRANCH_ID[xx]+';'+bank_branch_names.BRANCH_CODE[xx]+';'+bank_branch_names.BANK_BRANCH_NAME[xx]);
	}
	else
		document.getElementById('account_branch_id').options[0] = new Option('Seçiniz','');
}

function set_branch_code(abc)
{
	if(abc.split(';')[1]!= undefined)
		document.add_account.branch_code.value = abc.split(';')[1];
	else
		document.add_account.branch_code.value = "";
	
	if(abc.split(';')[2]!= undefined)
		document.add_account.branch_name.value = abc.split(';')[2];
	else
		document.add_account.branch_name.value = "";
}
function kontrol()
{
	if (document.add_account.account_bank_id.value =='')
	{	
		alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz!'>");
		return false;
	}
	
	if (document.add_account.branch_name.value =='')
	{	
		alert("<cf_get_lang dictionary_id='58579.Şube Seçiniz!'>");
		return false;
	}
	
	if (document.add_account.account_no.value =='')
	{	
		alert("<cf_get_lang dictionary_id='29396.Hesap Numarası Giriniz!'>");
		return false;
	}
	
	<cfif xml_iban_required>
		if(document.add_account.iban_code.value == '')
		{
		   alert("<cf_get_lang dictionary_id='30176.IBAN Code Değerini Giriniz!'>");
		   return false;
		}
		if(!isIBAN(document.add_account.iban_code)) return false;
	</cfif>
	
}
</script>
