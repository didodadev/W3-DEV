<cf_xml_page_edit fuseact="member.popup_form_add_bank_comp" is_multi_page="1">
<cfif isdefined("form.bank_name")>
	<cfquery name="ADD_BANK" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			COMPANY_BANK
		(
			COMPANY_ID,
			COMPANY_BANK, 
			COMPANY_BANK_CODE, 
			COMPANY_IBAN_CODE, 
			COMPANY_BANK_BRANCH,
			COMPANY_BANK_BRANCH_CODE,
			COMPANY_ACCOUNT_NO,
			COMPANY_ACCOUNT_DEFAULT,
			COMPANY_BANK_MONEY,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
		)
		VALUES
		(
			#FORM.CPID#, 
			'#FORM.BANK_NAME#', 
			'#FORM.BANK_CODE#', 
			'#FORM.IBAN_CODE#', 
			'#FORM.BRANCH_NAME#', 
			'#FORM.BRANCH_CODE#',
			'#FORM.ACCOUNT_NO#', 
			<cfif isdefined("form.default_account")>1<cfelse>0</cfif>,
			'#FORM.ACCOUNT_MONEY#' ,
             #now()#,
             #session.ep.userid#,
            '#cgi.remote_addr#'
		)
	</cfquery>
	<cfif isdefined("form.default_account")>
		<cfquery name="UPD_default_other" datasource="#dsn#">
			UPDATE 
				COMPANY_BANK 
			SET
				COMPANY_ACCOUNT_DEFAULT = 0
			WHERE
				COMPANY_ID = #FORM.CPID# AND
				COMPANY_BANK_ID <> #MAX_ID.IDENTITYCOL#
		</cfquery>
	</cfif>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
<cfquery name="get_bank_names" datasource="#dsn#">
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
		<cfform name="add_account" action="" method="post">
			<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#url.cpid#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang dictionary_id='59009.Aktif Hesap'></td>
				<td><input type="checkbox" name="default_account" id="default_account" value="" checked></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57521.Banka'></td>
				<td><select name="account_bank_id" id="account_bank_id" style="width:220px;" onChange="set_bank_branch(this.value);">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<cfoutput query="get_bank_names">
							<option value="#bank_id#;#bank_code#;#bank_name#">#bank_name#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57521.Banka'>*</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30349.Banka Adı'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="bank_name" message="#message#" readonly required="Yes" style="width:220px;">
					<cfelse>
						<cfinput type="text" name="bank_name" message="#message#" required="Yes" style="width:220px;">
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57453.Şube'></td>
				<td><select name="account_branch_id" id="account_branch_id" style="width:220px;" onChange="set_branch_code(this.value);">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57453.Şube'>*</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="branch_name" message="#message#" readonly required="Yes" style="width:220px;">
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
						<cfinput type="text" name="bank_code" message="#message#" style="width:220px;" readonly>
					<cfelse>
						<cfinput type="text" name="bank_code" message="#message#" style="width:220px;">
					</cfif>					
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='59005.Şube Kodu'></td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='59005.Şube Kodu'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="branch_code" message="#message#" style="width:220px;" readonly>
					<cfelse>
						<cfinput type="text" name="branch_code" message="#message#" style="width:220px;">
					</cfif>					
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58178.Hesap No'>*</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58178.Hesap No'>!</cfsavecontent>
					<cfinput type="Text" name="account_no" required="Yes" message="#message#" style="width:220px;">
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='59007.IBAN Kodu'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='59007.IBAN Kodu'></cfsavecontent>
					<cfinput type="text" name="iban_code" message="#message#" style="width:220px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57489.Para Birimi'></td>
				<td><select name="account_money" id="account_money" style="width:220px;">
						<cfoutput query="get_money">
						<option value="#money#">#money#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td height="35"><cf_workcube_buttons is_upd='0'></td>
			</tr>
		</table>
		</cfform>
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
		document.getElementById('account_branch_id').options[0] = new Option('<cf_get_lang dictionary_id ="57734.Seçiniz">','');
		for(var xx=0;xx<bank_branch_names.recordcount;xx++)
			document.getElementById('account_branch_id').options[xx+1]=new Option(bank_branch_names.BANK_BRANCH_NAME[xx],bank_branch_names.BANK_BRANCH_ID[xx]+';'+bank_branch_names.BRANCH_CODE[xx]+';'+bank_branch_names.BANK_BRANCH_NAME[xx]);
	}
	else
		document.getElementById('account_branch_id').options[0] = new Option('<cf_get_lang dictionary_id ="57734.Seçiniz">','');
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
</script>
