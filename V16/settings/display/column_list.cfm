<cfoutput>
<form target="query_analyzer_window" action="#request.self#?fuseaction=dev.emptypopup_get_query_results" method="post" name="qry_form" id="qry_form">
	<input type="hidden" name="qu_ery_st_ring" id="qu_ery_st_ring" value="SELECT TOP #session.ep.maxrows# * FROM #attributes.database_name#.#attributes.table_name#">
	<input type="hidden" name="da_ta_sou_rce" id="da_ta_sou_rce" value="workcube_db_admin">
</form>
<script language="JavaScript" type="text/javascript">
	function send_form(){
		windowopen('','wide','query_analyzer_window');
		document.qry_form.submit();
	}
</script>
</cfoutput>
<table width="100%" border="0" cellspacing="1" cellpadding="5" bgcolor="#000000">
 <tr class="color-header">
  <td colspan="3" align="left" valign="middle"><a href="javascript://" onClick="send_form();"><img src="/images/query_analyzer2.gif" border="0" title="Query Analyzer"></a>&nbsp;<strong><cf_get_lang no ='1587.Tablo'> :</strong> <cfoutput>#attributes.table_name#</cfoutput></td>
 </tr>
 <tr class="color-header">
  <td class="form-title" width="30%"><cf_get_lang no ='1075.Kolon'></td>
  <td class="form-title" width="18%"><cf_get_lang no ='1627.Tipi'></td>
  <td class="form-title" width="52%"><cf_get_lang_main no ='217.Açıklama'></td>
 </tr>
<cfoutput query="column_list">
 <tr onMouseOver="this.bgColor='ffff33';" onMouseOut="this.bgColor='F1F0FF';" bgcolor="F1F0FF">
  <td>#name#</td>
  <td>#type_name#<cfif type_name is "nvarchar" or type_name is "varchar" or type_name is "char" or type_name is "numeric"> (#type_length#)</cfif></td>
  <td>#col_description#</td>
 </tr>
</cfoutput>
</table>
