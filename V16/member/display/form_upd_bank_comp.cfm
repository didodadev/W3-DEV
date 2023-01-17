<cf_xml_page_edit fuseact="member.popup_form_add_bank_comp" is_multi_page="1">
<cfif isdefined("form.bank_name")>
	<cfquery name="UPD_BANK" datasource="#DSN#">
		UPDATE 
			COMPANY_BANK 
		SET 
			COMPANY_BANK = '#form.bank_name#',
			COMPANY_BANK_CODE = '#form.bank_code#',
			COMPANY_IBAN_CODE = '#form.iban_code#',
			COMPANY_BANK_BRANCH = '#form.branch_name#',
			COMPANY_BANK_BRANCH_CODE = '#form.branch_code#',
			COMPANY_ACCOUNT_NO = '#form.account_no#',
			COMPANY_ACCOUNT_DEFAULT = <cfif isDefined("form.default_account")>1<cfelse>0</cfif>,
			COMPANY_BANK_MONEY = '#form.account_money#',
            UPDATE_DATE = #now()#,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_IP = '#cgi.remote_addr#'
		WHERE 
			COMPANY_BANK_ID = #form.bid#
	</cfquery>
	<cfif isdefined("form.default_account")>
		<cfquery name="UPD_default_other" datasource="#DSN#">
			UPDATE 
				COMPANY_BANK 
			SET
				COMPANY_ACCOUNT_DEFAULT = 0
			WHERE
				COMPANY_ID = #form.cpid# AND
				COMPANY_BANK_ID <> #form.bid#
		</cfquery>
	</cfif>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
<cfquery name="get_bank_names" datasource="#dsn#">
	SELECT BANK_ID, BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfinclude template="../query/get_bank.cfm">
<cfinclude template="../query/get_money.cfm">
<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
	<tr class="color-list"> 
		<td class="headbold" height="35"><cf_get_lang dictionary_id='30407.Banka Hesabı Güncelle'></td>
	</tr>
	<tr class="color-row" valign="top"> 
		<td>
		<table>
		<cfform name="add_account" action="" method="post">
			<cfoutput>
			<input type="hidden" name="cpid" id="cpid" value="#url.cpid#">
			<input type="hidden" name="bid" id="bid" value="#url.bid#">
			</cfoutput>
			<tr>
				<td width="100"><cf_get_lang dictionary_id='59009.Aktif Hesap'></td>
				<td><input type="checkbox" name="default_account" id="default_account" value="" <cfif get_bank.company_account_default neq 0>checked</cfif>></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57521.Banka'></td>
				<td><select name="account_bank_id" id="account_bank_id" style="width:220px;" onChange="set_bank_branch(this.value);">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<cfoutput query="get_bank_names">
							<option value="#bank_id#;#bank_code#;#bank_name#" <cfif bank_name eq get_bank.COMPANY_BANK>selected</cfif>>#bank_name#</option>
						</cfoutput>
					</select>
				</td>                      
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57521.Banka'>*</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30349.Banka Adı'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="bank_name" value="#get_bank.company_bank#" readonly message="#message#" required="Yes" style="width:220px;">
					<cfelse>
						<cfinput type="text" name="bank_name" value="#get_bank.company_bank#" message="#message#" required="Yes" style="width:220px;">
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57453.Şube'></td>
				<td>
					<cfif isdefined("get_bank") and get_bank.recordcount>
						<cfquery name="get_bank_branch" datasource="#dsn#">
							SELECT 
								BB.BANK_BRANCH_ID, 
								BB.BANK_BRANCH_NAME, 
								BB.BRANCH_CODE 
							FROM 
								#dsn3_alias#.BANK_BRANCH BB,
								SETUP_BANK_TYPES SB
							WHERE 
								BB.BANK_ID = SB.BANK_ID
								AND SB.BANK_NAME = '#get_bank.company_bank#'
						</cfquery>
					</cfif>
					<select name="account_branch_id" id="account_branch_id" style="width:220px;" onChange="set_branch_code(this.value);">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<cfif isdefined("get_bank_branch")>
							<cfoutput query="get_bank_branch">
								<option value="#bank_branch_id#;#branch_code#;#bank_branch_name#" <cfif bank_branch_name eq get_bank.company_bank_branch>selected</cfif>>#bank_branch_name#</option>
							</cfoutput>
						</cfif>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57453.Şube'>*</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="branch_name" value="#get_bank.company_bank_branch#" readonly message="#message#" required="Yes" style="width:220px;">
					<cfelse>
						<cfinput type="text" name="branch_name" value="#get_bank.company_bank_branch#" message="#message#" required="Yes" style="width:220px;">
					</cfif>
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='59006.Banka Kodu'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='59006.Banka Kodu'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="bank_code" message="#message#" value="#get_bank.company_bank_code#" style="width:220px;" readonly>
					<cfelse>
						<cfinput type="text" name="bank_code" message="#message#" value="#get_bank.company_bank_code#" style="width:220px;">
					</cfif>										
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='59005.Şube Kodu'></td>
				<td>
					<cfsavecontent variable="message">><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='59005.Şube Kodu'>!</cfsavecontent>
					<cfif isdefined("is_change_code") and is_change_code eq 0>
						<cfinput type="text" name="branch_code" message="#message#" value="#get_bank.company_bank_branch_code#" style="width:220px;" readonly>
					<cfelse>
						<cfinput type="text" name="branch_code" message="#message#" value="#get_bank.company_bank_branch_code#" style="width:220px;">
					</cfif>	
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='58178.Hesap No'>*</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58178.Hesap No'>!</cfsavecontent>
					<cfinput type="text" name="account_no" required="Yes" message="#message#" value="#get_bank.company_account_no#" style="width:220px;">
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='59007.IBAN Kodu'></td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='59007.IBAN Kodu'></cfsavecontent>
					<cfinput type="text" name="iban_code" message="#message#" value="#get_bank.company_iban_code#" style="width:220px;">
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='57489.Para Birimi'></td>
				<td>
                	<select name="account_money" id="account_money" style="width:220px;">
						<cfoutput query="get_money"> 
                            <option value="#money#" <cfif get_bank.company_bank_money is money>selected</cfif>>#money#</option>
                        </cfoutput> 
					</select>
				</td>
			</tr>
			<tr> 
				<td>&nbsp;</td>
				<td height="35"><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=member.form_del_bank_comp_popup&bid=#url.bid#'></td>
			</tr>
            <tr>
            	<td colspan="2"><cf_record_info query_name="get_bank"></td>
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
	document.add_account.branch_name.value = "";
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
	var bank_branch_names = wrk_safe_query("mr_bank_branch_name","dsn3",0,bank_id_);
	
	var option_count = document.getElementById('account_branch_id').options.length; 
	for(x=option_count;x>=0;x--)
		document.getElementById('account_branch_id').options[x] = null;
	
	if(bank_branch_names.recordcount != 0)
	{	
		document.getElementById('account_branch_id').options[0] = new Option('Seçiniz','');
		for(var xx=0;xx<bank_branch_names.recordcount;xx++)
			document.getElementById('account_branch_id').options[xx+1]=new Option(bank_branch_names.BANK_BRANCH_NAME[xx],bank_branch_names.BANK_BRANCH_ID[xx]+';'+bank_branch_names.BRANCH_CODE[xx]+';'+bank_branch_names.BANK_BRANCH_NAME[xx]);
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
</script>
