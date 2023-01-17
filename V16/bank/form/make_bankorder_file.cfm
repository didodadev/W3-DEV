<!---
    File: make_bankorder_file.cfm
    Folder: V16\bank\form\
	Controller: 
    Author:
    Date:
    Description:
		Banka talimatlarndan havale oluşturulammşlar için dosya oluşturur ve bankaya iletilir,
		sonrasnda bankanın vereceği dosya ile sisteme bunlar havale olarak kaydedilir.
    History:
        
    To Do:

--->

<cf_xml_page_edit fuseact ="bank.popup_make_bankorder_file">
<cfif isDefined("checked_value")>
	<cfquery name="get_accounts" datasource="#DSN#">
		SELECT
			*
		FROM
			SETUP_BANK_TYPES SB,
			OUR_COMPANY_BANK_RELATION ORR
		WHERE
			EXPORT_TYPE IS NOT NULL
			AND SB.BANK_ID = ORR.BANK_ID
			AND ORR.OUR_COMPANY_ID = #session.ep.company_id#
			AND BANK_CODE IS NOT NULL
			AND BANK_BRANCH_CODE IS NOT NULL
			AND BANK_ACCOUNT_CODE IS NOT NULL
			AND BANK_CODE <> ''
			AND BANK_BRANCH_CODE <> ''
			AND BANK_ACCOUNT_CODE <> ''
		ORDER BY
			BANK_NAME
	</cfquery>
	<cf_popup_box title="TOS(Toplu Ödeme Sistemleri) Dosya Oluşturma">
		<cfform name="open_prov_file" method="post" action="#request.self#?fuseaction=bank.emptypopup_make_bankorder_file#xml_str#">
			<cfinput type="hidden" name="checked_value" value="#checked_value#">
			<table>
				<tr>
					<td>Banka*</td>
					<td>
						<select name="bank_type_id" id="bank_type_id" style="width:160px;">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfoutput query="get_accounts">
								<option value="#bank_id#;#bank_name#;#export_type#;#bank_code#;#bank_branch_code#;#bank_account_code#">#bank_name# - #bank_account_code#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1439.Ödeme Tarihi'> *</td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='494.Tarih Girmelisiniz'>!</cfsavecontent>
						<cfinput required="yes" value="#dateformat(now(),dateformat_style)#"message="#message#" type="text" name="paym_date" style="width:90px;" validate="#validate_style#" maxlength="10">
						<cf_wrk_date_image date_field="paym_date">
					</td>
				</tr>
				<cfif is_encrypt_file eq 1><!--- xml den şifreleme yapılsn --->
					<tr>
						<td><cf_get_lang no ='257.Anahtar '>*</td>
						<td><input name="key_type" id="key_type" type="password" autocomplete="off" style="width:110px;"></td>
					</tr>
				</cfif>
			</table>
			<cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
		</cfform>
	</cf_popup_box>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='56367.Talimat Seçmelisiniz'>");
		window.close();
	</script>
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		<cfif is_encrypt_file eq 1>//xml den şifreleme yapılsn
			if(autopayment_import_file.key_type.value == "")
			{
				alert("<cf_get_lang dictionary_id='48964.Anahtar Giriniz'>!");
				return false;
			}
		</cfif>
		if(document.getElementById('bank_type_id').value == "")
		{
			alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz'>!")
			return false;
		}
	}
</script>