<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_rule" action="#request.self#?fuseaction=rule.welcome" method="post">
	<input type="hidden" name="is_from_rule" id="is_from_rule" value="1">
	<table>
        <tr>
          <td nowrap="nowrap"><cfinput type="text" name="keyword" id="keyword" style="width:140px;" value="#attributes.keyword#" maxlength="255"><cf_wrk_search_button is_excel='0'></td>
          <td><a href="javascript://" onClick="gizle_goster(search_menu_new)"><img src="/images/find.gif" border="0" align="absmiddle" title="<cf_get_lang_main no ='492.Detaylı Arama'>"></a></td>
        </tr>
	</table>
</cfform>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
