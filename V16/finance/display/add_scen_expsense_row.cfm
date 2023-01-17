<cfquery name="GET_SCEN_EXPENSE_PERIOD" datasource="#DSN3#">
	SELECT
		SPR.PERIOD_CURRENCY,
		SPR.PERIOD_VALUE,
		SPR.SCEN_EXPENSE_STATUS,
		SPR.PERIOD_DETAIL,
		SPR.START_DATE,
		SP.PERIOD_REPITITION,
		SP.SCENARIO_TYPE_ID,
		SP.PERIOD_ID
	FROM
		SCEN_EXPENSE_PERIOD_ROWS SPR,
		SCEN_EXPENSE_PERIOD SP		
	WHERE
		SP.PERIOD_ID = SPR.PERIOD_ID AND
		SPR.PERIOD_ROW_ID = #attributes.id#
</cfquery>
<cf_popup_box title="#getLang('finance',100)#">
<cfform name="upd_expense" method="post" action="#request.self#?fuseaction=finance.emptypopup_add_scen_scenario_row&id=#attributes.id#">
<input type="hidden" name="period_id" id="period_id" value="<cfoutput>#get_scen_expense_period.period_id#</cfoutput>" />
	<table>
		<tr>
			<td width="80px"><cf_get_lang no='171.Senaryo Tipi'></td>
			<td>
			  <cfif len(get_scen_expense_period.scenario_type_id) and get_scen_expense_period.scenario_type_id neq 0>
				<cfquery name="GET_SETUP_SCENARIO" datasource="#DSN#">
					SELECT
						SCENARIO
					FROM
						SETUP_SCENARIO
					WHERE
						SCENARIO_ID = #get_scen_expense_period.scenario_type_id#
				</cfquery>						
				: <cfoutput>#get_setup_scenario.scenario#</cfoutput>
			  </cfif>
			</td>
		</tr>
		<tr>					  
			<td><cf_get_lang_main  no='217.Açıklama'></td>
			<td>: <cfoutput>#get_scen_expense_period.period_detail#</cfoutput></td>
		</tr>
		<tr>
			<td><cf_get_lang no='96.Tekrar'></td>
			<td>: <cfoutput>#get_scen_expense_period.period_repitition#</cfoutput></td>
		</tr>					  
		<tr>
			<td><cf_get_lang_main no='81.Aktif'>/<cf_get_lang_main no='82.Pasif'></td>
			<td><input type="checkbox" name="scen_expense_status" id="scen_expense_status" <cfif get_scen_expense_period.scen_expense_status eq 1>checked</cfif>></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='330.Tarih'></td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='1080.TArihi Kontrol Ediniz'>!</cfsavecontent>
				<cfinput type="text" name="start_date" value="#dateformat(get_scen_expense_period.start_date,dateformat_style)#" style="width:75px;" required="yes" validate="#validate_style#" maxlength="10" message="#message#">
				<cf_wrk_date_image date_field="start_date">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='261.Tutar'></td>
			<td>
			  <cfsavecontent variable="message"><cf_get_lang_main no='1738.tutar girmelisiniz'></cfsavecontent>
			  <cfinput name="period_value" type="text" required="yes" message="#message#" value="#TLFormat(get_scen_expense_period.PERIOD_VALUE)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:97px;">
			  <cfinclude template="../query/get_money.cfm">
			  <select name="currency" id="currency" style="width:50px;">
				<cfoutput query="get_money">
				  <option value="#money#" <cfif money eq get_scen_expense_period.period_currency>selected</cfif>>#money#</option>
				</cfoutput>
			  </select>
            </td>
			<td></td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_workcube_buttons type_format="1" is_upd='1'
			delete_page_url="#request.self#?fuseaction=finance.emptypopup_del_scen_scenario_row&id=#attributes.id#"
			add_function='unformat_fields()'>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function unformat_fields()
{
	upd_expense.period_value.value = filterNum(upd_expense.period_value.value);
	return true;
}
</script>
