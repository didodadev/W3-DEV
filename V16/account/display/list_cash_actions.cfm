<cfset attributes.table_name="cash_actions">
<cfif GET_CASH_ACTIONS.recordcount>
  <cfoutput query="GET_CASH_ACTIONS">
    <cfswitch expression = "#GET_CASH_ACTIONS.ACTION_TYPE_ID#">
      <cfcase value=38>
	      <cfset type_="cash.popup_dsp_sale_doviz">
      </cfcase>
      <cfcase value=39>
    	  <cfset type_="cash.popup_dsp_purchase_doviz">
      </cfcase>
    </cfswitch>
    <tr class="color-row">
      <td>#GET_CASH_ACTIONS.currentrow#&nbsp;</td>
      <td> <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type_#&id=#GET_CASH_ACTIONS.action_id#','small');" class="tableyazi">&nbsp;#GET_CASH_ACTIONS.action_type#</a>
	  </td>
      <!--// hangi hesaptan--->
      <td>
        <cfif len(GET_CASH_ACTIONS.cash_action_from_account_id)>
          <cfset account_id = GET_CASH_ACTIONS.cash_action_from_account_id>
          <cfinclude template="../query/get_action_account.cfm">
          #get_action_account.account_name#
        </cfif>
        <cfif len(GET_CASH_ACTIONS.cash_action_from_cash_id)>
          <cfset cash_id = GET_CASH_ACTIONS.cash_action_from_cash_id>
          <cfinclude template="../query/get_action_cash.cfm">
          #get_action_cash.cash_name#
        </cfif>
      </td>
      <!--//hangi hesaba--->
      <td>
        <cfif len(GET_CASH_ACTIONS.cash_action_to_account_id)>
          <cfset account_id = GET_CASH_ACTIONS.cash_action_to_account_id>
          <cfinclude template="../query/get_action_account.cfm">
          #get_action_account.account_name#
        </cfif>
        <cfif len(GET_CASH_ACTIONS.cash_action_to_cash_id)>
          <cfset cash_id = GET_CASH_ACTIONS.cash_action_to_cash_id>
          <cfinclude template="../query/get_action_cash.cfm">
          #get_action_cash.cash_name#
        </cfif>
      </td>
      <cfset currency = GET_CASH_ACTIONS.cash_action_currency_id>
      <cfinclude template="../query/get_action_rate.cfm">
      <td></td>
      <td style="text-align:right;">#TLFormat(GET_CASH_ACTIONS.cash_action_value)#&nbsp;#get_action_rate.money#</td>
      <cfset adate=dateformat(GET_CASH_ACTIONS.action_date,dateformat_style)>
      <td>#adate#</td>
    </tr>
  </cfoutput>
</cfif>
