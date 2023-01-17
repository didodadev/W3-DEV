<cf_form_box title="#getLang('account',145)#">	<!--- Sabit Kiymet Tanimlari --->
	<cfform name="invent_re_account" action="#request.self#?fuseaction=account.add_invent_account&t=1" method="post">
		<cfquery name="GET_ACCOUNT" datasource="#DSN3#">
			SELECT 
				SI.INVENTORY_RE_ACCOUNT_CODE 
			FROM 
				SETUP_INVENTORY_DEFINITION SI 
			WHERE
				SI.INVENTORY_RE_ACCOUNT_CODE IS NOT NULL
		</cfquery>
		<cfif GET_ACCOUNT.recordcount>
			<cfquery name="GET_NAME" datasource="#DSN2#">
				SELECT 
					ACCOUNT_NAME 
				FROM 
					ACCOUNT_PLAN 
				WHERE 
					ACCOUNT_CODE 
				LIKE 
					'#GET_ACCOUNT.INVENTORY_RE_ACCOUNT_CODE#'
			</cfquery>
			<cfset CODE = GET_ACCOUNT.INVENTORY_RE_ACCOUNT_CODE>
			<cfset NAME = GET_NAME.ACCOUNT_NAME>
		<cfelse>
			<cfset CODE="">
			<cfset NAME="">
		</cfif>
		<table>
			<tr>
				<td width="150"><cf_get_lang no='151.Yeniden Değerleme Hesabı'></td>
				<td>
					<cf_wrk_account_codes form_name='invent_re_account' search_from_name='1' account_code="account_code" account_name='account_name'>
					<input type="hidden" name="account_code" id="account_code" style="width:150px;" value="<cfoutput>#CODE#</cfoutput>">
					<input type="text" name="account_name" id="account_name" value="<cfoutput>#NAME#</cfoutput>" style="width:150px;" onkeyup="get_wrk_acc_code_1();">
					<a href="javascript://"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=invent_re_account.account_code&field_name=invent_re_account.account_name</cfoutput>','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> 
				</td>
			</tr>
		</table>	
		<cf_form_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_form_box_footer>
	</cfform>
</cf_form_box>
<br />
<cf_form_box>
	<cfform name="invent_re_account" action="#request.self#?fuseaction=account.add_invent_account&t=1" method="post">
		<cfquery name="GET_ACCOUNT_" datasource="#DSN3#">
			SELECT 
				SI.INVENTORY_ACCOUNT_CODE AS CODE 
			FROM 
				SETUP_INVENTORY_DEFINITION SI 
			WHERE 
				SI.INVENTORY_ACCOUNT_CODE IS NOT NULL
		</cfquery>
		<cfif GET_ACCOUNT_.RECORDCOUNT>
			<cfquery name="GET_NAME_" datasource="#DSN2#">
				SELECT 
					ACCOUNT_NAME 
				FROM 
					ACCOUNT_PLAN 
				WHERE 
					ACCOUNT_CODE 
				LIKE
					'#GET_ACCOUNT_.CODE#'
			</cfquery>
			<cfset CODE_ = GET_ACCOUNT_.CODE>
			<cfset NAME_ = GET_NAME_.ACCOUNT_NAME>
		<cfelse>
			<cfset CODE_="">
			<cfset NAME_="">
		</cfif>
		<table>
			<tr>
				<td width="150" height="26"><cf_get_lang no='152.Sabit Kıymetler Hesabı'></td>
				<td>
					<cf_wrk_account_codes form_name='invent_re_account' search_from_name='1' account_code="account_id" account_name='account_name' is_multi_no='2'>
					<input type="hidden" name="account_id" id="account_id" value="<cfoutput>#CODE_#</cfoutput>" style="width:150px;">
					<input type="text" name="account_name" id="account_name" value="<cfoutput>#NAME_#</cfoutput>" style="width:150px;" onkeyup="get_wrk_acc_code_1();">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=invent_account.account_id&field_name=invent_account.account_name</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='152.Sabit Kıymetler Hesabı'>"  align="absmiddle" border="0"></a> 
				</td>
			</tr>
		</table>
		<cf_form_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_form_box_footer>
	</cfform>
</cf_form_box>
<br />
<cf_form_box>
	<cfform name="invents_account" action="#request.self#?fuseaction=account.add_invent_account&T=2" method="post">
		<cfquery name="GET_ACCOUNT_INVENT" datasource="#DSN3#">
			SELECT 
				SI.INVENTORIES_ACCOUNT_CODE AS CODE 
			FROM 
				SETUP_INVENTORY_DEFINITION SI 
			WHERE 
				SI.INVENTORIES_ACCOUNT_CODE IS NOT NULL
		</cfquery>
		<cfif GET_ACCOUNT_.RECORDCOUNT>
			<cfquery name="GET_NAME_INVENT" datasource="#DSN2#">
				SELECT 
					ACCOUNT_NAME 
				FROM 
					ACCOUNT_PLAN 
				WHERE 
					ACCOUNT_CODE 
				LIKE
					'#GET_ACCOUNT_INVENT.CODE#'
			</cfquery>
			<cfset CODE_INVENT = GET_ACCOUNT_INVENT.CODE>
			<cfset NAME_INVENT = GET_NAME_INVENT.ACCOUNT_NAME>
		<cfelse>
			<cfset CODE_INVENT="">
			<cfset NAME_INVENT="">
		</cfif>	 	
		<table>
			<tr>
				<td width="150"><cf_get_lang no='153.Amortismanlar Hesabı'></td>
				<td>
					<cf_wrk_account_codes form_name='invent_re_account' search_from_name='1' account_code="account_id_invent" account_name='account_name_invent' is_multi_no='3'>
					<input type="hidden" name="account_id_invent" id="account_id_invent" value="<cfoutput>#CODE_INVENT#</cfoutput>" style="width:150px;">
					<input type="text" name="account_name_invent" id="account_name_invent" value="<cfoutput>#NAME_INVENT#</cfoutput>" style="width:150px;" onkeyup="get_wrk_acc_code_1();">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=invents_account.account_id_invent&field_name=invents_account.account_name_invent</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='153.Amortismanlar Hesabı'>"  align="absmiddle" border="0"></a>
				</td>
			</tr>
		</table>
		<cf_form_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_form_box_footer>
	</cfform>
</cf_form_box>
<br />
<!----AMORTISMAN GIDERLERI HESABI KAYDI EKLEME FORMU----->
<cf_form_box>
	<cfform name="invent_expense" action="#request.self#?fuseaction=account.add_invent_account&T=3" method="post">
		<cfquery name="GET_ACCOUNT_EXP" datasource="#DSN3#">
			SELECT 
				SI.INVENTORY_EXP_ACC_CODE AS CODE 
			FROM 
				SETUP_INVENTORY_DEFINITION SI 
			WHERE 
				SI.INVENTORY_EXP_ACC_CODE IS NOT NULL
		</cfquery>
		<cfif GET_ACCOUNT_.RECORDCOUNT>
			<cfquery name="GET_NAME_INVENT" datasource="#DSN2#">
				SELECT 
					ACCOUNT_NAME 
				FROM 
					ACCOUNT_PLAN 
				WHERE 
					ACCOUNT_CODE 
				LIKE
					'#GET_ACCOUNT_EXP.CODE#'
			</cfquery>
			<cfset CODE_EXP = GET_ACCOUNT_INVENT.CODE>
			<cfset NAME_EXP = GET_NAME_INVENT.ACCOUNT_NAME>
		<cfelse>
			<cfset CODE_EXP="">
			<cfset NAME_EXP="">
		</cfif>
		<table>
			<tr>
				<td width="150"><cf_get_lang no='164.Amortisman Giderleri Hesabı'></td>
				<td>
					<cf_wrk_account_codes form_name='invent_re_account' search_from_name='1' account_code="account_id_exp" account_name='account_name_exp' is_multi_no='4'>
					<input type="hidden" name="account_id_exp" id="account_id_exp" value="<cfoutput>#CODE_EXP#</cfoutput>" style="width:150px;">
					<input type="text" name="account_name_exp" id="account_name_exp" value="<cfoutput>#NAME_EXP#</cfoutput>" style="width:150px;" onkeyup="get_wrk_acc_code_1();">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=invent_expense.account_id_exp&field_name=invent_expense.account_name_exp</cfoutput>','list')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
				</td>
			</tr>
		</table>	
		<cf_form_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_form_box_footer>
	</cfform>
</cf_form_box>
<br />
<cf_form_box>
	<cfform name="invent_sale_cost" action="#request.self#?fuseaction=account.add_invent_account&T=4" method="post">
		<cfquery name="GET_ACCOUNT_COST" datasource="#DSN3#">
			SELECT 
				SI.INVENTORY_SALE_COST_ACC_CODE AS CODE 
			FROM 
				SETUP_INVENTORY_DEFINITION SI 
			WHERE 
				SI.INVENTORY_SALE_COST_ACC_CODE IS NOT NULL
		</cfquery>
		<cfif GET_ACCOUNT_.RECORDCOUNT>
			<cfquery name="GET_NAME_INVENT" datasource="#DSN2#">
				SELECT 
					ACCOUNT_NAME 
				FROM 
					ACCOUNT_PLAN 
				WHERE 
					ACCOUNT_CODE 
				LIKE
					'#GET_ACCOUNT_COST.CODE#'
			</cfquery>
			<cfset CODE_COST = GET_ACCOUNT_INVENT.CODE>
			<cfset NAME_COST = GET_NAME_INVENT.ACCOUNT_NAME>
		<cfelse>
			<cfset CODE_COST="">
			<cfset NAME_COST="">
		</cfif>
		<table>
			<tr>
				<td width="150"><cf_get_lang no='168.Demirbaş Satış Maliyeti Hesabı'></td>
				<td>
					<cf_wrk_account_codes form_name='invent_re_account' search_from_name='1' account_code="account_id_cost" account_name='account_name_cost' is_multi_no='5'>
					<input type="hidden" name="account_id_cost" id="account_id_cost" value="<cfoutput>#CODE_COST#</cfoutput>" style="width:150px;">
					<input type="text" name="account_name_cost" id="account_name_cost" value="<cfoutput>#NAME_COST#</cfoutput>" style="width:150px;" onkeyup="get_wrk_acc_code_1();">
					<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=invent_sale_cost.account_id_cost&field_name=invent_sale_cost.account_name_cost</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='168.Demirbaş Satış Maliyeti Hesabı'>" align="absmiddle" border="0"></a>
				</td>
			</tr>
		</table>	
		<cf_form_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_form_box_footer>
	</cfform>
</cf_form_box>
