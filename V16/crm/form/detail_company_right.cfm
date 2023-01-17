<cfif get_module_user(16)>
	<cfinclude template="company_finance.cfm">
</cfif>
<cfinclude template="member_team.cfm"><br/> 
<!--- Notlar --->
<cf_get_workcube_note action_section='COMPANY_ID' action_id='#attributes.cpid#'><br/>
<!--- Varlıklar --->
<cf_get_workcube_asset asset_cat_id="-9" module_id='4' action_section='COMPANY_ID' action_id='#attributes.cpid#'><br/>
<cfif get_module_user(11)>
	<cfinclude template="company_sales_qoutes.cfm"><br/>
</cfif>
<cfif get_module_user(17)>
	<cfinclude template="member_contract.cfm"><br/>
</cfif>
<cfif get_module_user(16)> 
	<cfinclude template="company_bank_accounts.cfm"><br/>
	<cfinclude template="company_credit_cards.cfm"><br/>
</cfif>
<!--- Abonelikler --->
<cfif get_module_user(11) and session.ep.our_company_info.subscription_contract eq 1>
	<table cellSpacing="0" cellpadding="0" width="98%" border="0">
	  <tr class="color-border">
		<td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
		  <tr class="color-header"  height="22">
			<td class="form-title" width="270" style="cursor:pointer;" onclick="gizle_goster(abonelik);"><cf_get_lang no='373.Abonelikler'></td>
			<td class="form-title" align="center"><a href="<cfoutput>#request.self#?fuseaction=sales.list_subscription_contract&event=add</cfoutput>"><img src="/images/plus_square.gif" title="<cf_get_lang no='374.Abonelik Ekle'>" border="0"></a></td>
		  </tr>
		  <tr class="color-row" style="display:none;" id="abonelik">
		  	  <td colspan="2">
			  <table>
			  <cfquery name="GET_SUBSCRIPTIONS" datasource="#DSN3#">
				SELECT 
					SC.SUBSCRIPTION_ID,
					SC.START_DATE,
					SC.SUBSCRIPTION_NO
				FROM 
					SUBSCRIPTION_CONTRACT AS SC
				WHERE 
					SC.COMPANY_ID =#attributes.cpid#
			  </cfquery>
			  <cfif get_subscriptions.recordcount>
				<cfoutput query="get_subscriptions">
				  <tr class="color-row">
				  <td colspan="2" height="20"><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#" class="tableyazi">#subscription_no# : <cfif len(start_date)>#dateformat(start_date,dateformat_style)#</cfif></a></td>
				</cfoutput>
			  <cfelse>
				<td colspan="2" height="20"><cf_get_lang_main no ='72.Kayıt Yok'> !</td>
			  </cfif>  
		  	  	</tr>
			  </table>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
	</table>
	<br/>
</cfif>

<cfinclude template="member_analys.cfm"><br/>
<!--- 200050704 silmeyin gerekebilir <cfinclude template="partner_relation.cfm"> --->
