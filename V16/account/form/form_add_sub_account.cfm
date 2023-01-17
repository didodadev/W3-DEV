<cfset xfa.add = "account.add_sub_account">
<cfif isdefined('attributes.account_id')>
	<cfinclude template="../query/get_account.cfm">
</cfif>
<cfif isdefined('attributes.acc_code')>
	<cfset t_value = ListLast(attributes.acc_code,".")>
	<cfset acc_main = Mid(attributes.acc_code,1,len(attributes.acc_code)-len(t_value)-1)>
	<cfquery name="account" datasource="#DSN2#">
		SELECT 
				* 
		FROM 
			ACCOUNT_PLAN 
		WHERE 
			ACCOUNT_CODE = '#ACC_MAIN#'
	</cfquery>
	<cfif account.recordcount>
		<cfset attributes.account_id = -1>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no='178.Muhasebe Hesabınız Yanlış !'>");
			my_link_str = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&keyword=";
			window.location.href = my_link_str;
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfset t_value="">
</cfif>
<cf_popup_box title="#getLang('account',53)#">
	<cfif isdefined('attributes.no_ref')>
		<cfset q_str="no_ref=#attributes.no_ref#">
	<cfelse>
		<cfset q_str="">
	</cfif>
	<cfform name="add_account" action="#request.self#?fuseaction=#xfa.add#&#q_str#" method="post">
	<input type="Hidden" name="account_id" id="account_id" value="<cfoutput>#attributes.account_id#</cfoutput>">
		<table>
			<tr>
				<td width="100"><cf_get_lang no='182.Üst Hesap'></td>
				<td><cfoutput>#account.account_code# : #account.account_name#</cfoutput></td>
			</tr>
			<input type="Hidden" name="account_code" id="account_code" value="<cfoutput>#account.account_code#</cfoutput>">
			<tr>
				<td><cf_get_lang no='190.Alt Hesap Kodu'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='190. Alt Hesap Kodu'> *</cfsavecontent>
					<cfoutput>#account.account_code#</cfoutput>.
					<cfinput type="text" name="sub_account_code"  style="width:100px;" value="#t_value#" required="Yes" message="#message#">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='198.Alt Hesap Adı'> *</td>
				<td>
					<cfsavecontent variable="message1"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='198.Hesap Adı'></cfsavecontent>
					<cfinput type="Text" name="sub_account_name" style="width:100%;" required="Yes" message="#message1#">
				</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	var temp_str = document.add_account.sub_account_code.value;
	if ((temp_str.indexOf(',') >= 0) || (temp_str.indexOf('.') >= 0))
	{
		alert("<cf_get_lang dictionary_id='33809.Girdiğiniz Hesap Kodu Geçerli Değil'>!");
		return false;			
	}
	if (trim(document.add_account.sub_account_code.value)=='')
	{
		alert("<cf_get_lang dictionary_id='32394.Alt Hesap Kodu Girmelisiniz'>!");
		return false;
	}
	return true;
}
</script>
