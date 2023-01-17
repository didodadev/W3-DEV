<!--- 
ACTION_TYPE : Hangi sayfadan istek yapıldığını belirtiyor (CONSUMER  Bireysel üye sayfasından,COMPANY Kurumsal üye sayfasından ,EMPLOYEE IK calisan detayi)
BANK_ACTION_ID : Bireysel üye icin CID, kurumsal üye için CPID,calisan icin employee_id

Ornek Kullanimi:
Birseysel uye <cf_get_workcube_bank_account action_type='CONSUMER' action_id="#attributes.cid#">
Kurumsal uye <cf_get_workcube_bank_account action_type='COMPANY' action_id="#attributes.cpid#">
Calisan <cf_get_workcube_bank_account action_type='EMPLOYEE' action_id="#attributes.employee_id#">
 --->
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.action_id" default="">

<cfscript>
	action_url = "&action_type=#attributes.action_type#&action_id=#attributes.action_id#";
	accountRowsUrl = "#request.self#?fuseaction=objects.emptypopup_list_bank_account#action_url#";

	if (isdefined("cid") and len(cid)) // Bireysel uye sayfasi
		addBankAccountsUrl = "#request.self#?fuseaction=objects.popup_form_add_bank_account&cid=#url.cid#";
	else if (isdefined("cpid") and len(cpid)) // Kurumsal uye sayfasi
		addBankAccountsUrl = "#request.self#?fuseaction=objects.popup_form_add_bank_account&cpid=#url.cpid#";
	else if (isdefined("employee_id") and len(employee_id)) // IK calisan detayi
		addBankAccountsUrl = "#request.self#?fuseaction=objects.popup_form_add_bank_account&employee_id=#url.employee_id#";
</cfscript>

<!--- Banka Hesaplari --->
<cf_box
	id="emp_bank_accounts"
	closable="0"
	box_page="#accountRowsUrl#"
	unload_body="1"
	title="#caller.getLang('main',1590)#" 
	add_href="openBoxDraggable('#addBankAccountsUrl#')">
	<!--- add_href_2 parametresi verilince acilan popup'da skıntı oluyor.  --->
	<table>
		<tr id="list_bank_id">
			<td colspan="2"><div id="bank_list"></div></td>
		</tr> 
	</table>
</cf_box>
