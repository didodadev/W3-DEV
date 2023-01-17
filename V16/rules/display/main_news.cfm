<cfinclude template="../query/get_homepage_news.cfm">
<table width="98%" border="0" align="center">
	<tr>
		<td valign="top" id="search_menu_new" style="display:none;">
			<cfinclude template="list_main_news.cfm">	
		</td>
	</tr>
</table>

<cfoutput query="GET_HOMEPAGE_NEWS">
<table width="99%" border="0" align="center">
<cfform name="list_main_cont" action="" method="post"><!--- #request.self#?fuseaction=rule.list_rule --->
	<tr>
		<td height="25" class="headbold">#cont_head#</td>
	</tr>
	<cfif is_dsp_summary eq 0>
	<tr>
		<td>#CONT_SUMMARY#</td>
	</tr>
	</cfif>
	<tr>
		<td><img src="images/arrow.gif"> <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#CONTENT_ID#"><cf_get_lang_main no='714.Devam'></a>
	</td>
  </tr>
   <tr><td colspan="2" height="11" background="../../images/content_sptr.gif"></td></tr>
  </cfform>
</table>
</cfoutput>
