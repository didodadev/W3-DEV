<table cellspacing="0" cellpadding="0" width="98%" border="0">
  <tr class="color-border">
	<td>
	<table cellspacing="1" cellpadding="2" width="100%" border="0">
	  <tr class="color-header" height="22">
		<td class="form-title" width="235" style="cursor:pointer;" onClick="gizle_goster(kredi);"><cf_get_lang no='64.Kredi Kartları'></td>
		  <cfoutput>
		  	<cfif not listfindnocase(denied_pages,'member.popup_add_credit_card')>
			  <td class="form-title" align="center" width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_add_credit_card&comp_id=#url.cpid#','small')"><img src="/images/plus_square.gif" border="0"></a></td>
			</cfif>
		  </cfoutput>
		</tr>
		<tr class="color-row" id="kredi">
		  <td colspan="2" height="20">
			<cfquery name="GET_CC_COMPANY" datasource="#dsn#">
				SELECT
					CC.*,
					SC.CARDCAT
				FROM
					COMPANY_CC CC,
					SETUP_CREDITCARD SC
				WHERE
					CC.COMPANY_ID = #attributes.cpid# AND
					CC.COMPANY_CC_TYPE = SC.CARDCAT_ID
			  </cfquery>
			  <cfoutput query="GET_CC_COMPANY">
				<cfset key_type = '#COMPANY_ID#'>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_upd_credit_card&comp_id=#attributes.cpid#&ccid=#COMPANY_CC_ID#','small')" class="tableyazi"><b>#cardcat#</b>/#mid(Decrypt(replace(replace(company_cc_number, "''", "'", "ALL"),'""', '"', 'ALL'),key_type),1,4)#********#mid(Decrypt(replace(replace(company_cc_number, "''", "'", "ALL"),'""', '"', 'ALL'),key_type),Len(Decrypt(replace(replace(company_cc_number, "''", "'", "ALL"),'""', '"', 'ALL'),key_type)) - 3, Len(Decrypt(replace(replace(company_cc_number, "''", "'", "ALL"),'""', '"', 'ALL'),key_type)))#/<b>#company_ex_month# - #company_ex_year#</b></a><br/>
			  </cfoutput>
		  </td>
		</tr>
	</table>
	</td>
  </tr>
</table>
