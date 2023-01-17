<cfset table="bank_actions">
<cfif get_actions.recordcount>
  <cfoutput query="get_actions">
    <cfswitch expression = "get_actions.action_type_id">
      <cfcase value=23>
	      <cfset type="virman">
      </cfcase>
      <cfcase value=21>
    	  <cfset type="invest_money">
      </cfcase>
      <cfcase value=22>
	      <cfset type="get_money">
      </cfcase>
    </cfswitch>
    <tr class="color-row">
      <td>#get_actions.currentrow#&nbsp;</td>
      <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_upd_#type#&id=#get_actions.action_id#','small');" class="tableyazi">&nbsp;#get_actions.action_type#</a></td>
      <!--// hangi hesaptan--->
      <td>
        <cfif len(get_actions.action_from_account_id)>
          <cfset account_id = get_actions.action_from_account_id>
          <cfinclude template="../query/get_action_account.cfm">
          #get_action_account.account_name#
        </cfif>
        <cfif len(get_actions.action_from_cash_id)>
          <cfset cash_id = get_actions.action_from_cash_id>
          <cfinclude template="../query/get_action_cash.cfm">
          #get_action_cash.cash_name#
        </cfif>
      </td>
      <!--//hangi hesaba--->
      <td>
        <cfif len(get_actions.action_to_account_id)>
          <cfset account_id = get_actions.action_to_account_id>
          <cfinclude template="../query/get_action_account.cfm">
          #get_action_account.account_name#
        </cfif>
        <cfif len(get_actions.action_to_cash_id)>
          <cfset cash_id = get_actions.action_to_cash_id>
          <cfinclude template="../query/get_action_cash.cfm">
          #get_action_cash.cash_name#
        </cfif>
      </td>
      <cfset currency = get_actions.action_currency_id>
      <cfinclude template="../query/get_action_rate.cfm">
      <td></td>
      <td style="text-align:right;";">#TLFormat(get_actions.action_value)#&nbsp;#get_action_rate.money#</td>
      <cfset adate=dateformat(get_actions.action_date,dateformat_style)>
      <td>#adate#</td>
    </tr>
  </cfoutput>
</cfif>
