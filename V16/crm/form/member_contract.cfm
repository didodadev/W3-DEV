<cfinclude template="../query/get_contract.cfm"> 
<table CELLSPACING="0" CELLPADDING="0" WIDTH="98%" BORDER="0">
<tr CLASS="color-border">
  <td>
	<table CELLSPACING="1" CELLPADDING="2" WIDTH="100%" BORDER="0">
	  <tr CLASS="color-header"  HEIGHT="22">
		<td CLASS="form-title" STYLE="cursor:pointer;" onClick="gizle_goster(gizli3);" WIDTH="270"><cf_get_lang_main no='25.anlasmalar'></td>
		<td CLASS="form-title" ALIGN="center"><a href="<cfoutput>#request.self#?fuseaction=contract.add_contract</cfoutput>"><img src="/images/plus_square.gif" border="0"></a></td>
	  </tr>
	  <tr CLASS="color-row" STYLE="display:none;" ID="gizli3">
		<td COLSPAN="2" height="20">
			<cfoutput query="get_contract">
			<img src="/images/tree_1.gif" border="0" align="absmiddle"><a href="#request.self#?fuseaction=contract.detail_contract_form&contract_id=#contract_id#" CLASS="tableyazi">#CONTRACT_HEAD#</a><br/>
			</cfoutput> 
		</td></tr>
	</table>
  </td>
</tr>
</table>
