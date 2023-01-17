<table cellpadding="0" cellspacing="0" border="0" width="135" height="100%">
	<tr>
	<cfinclude template="../../objects/display/tree_back.cfm">
		<td <cfoutput>#td_back#</cfoutput>>
	    <cfoutput>
      	<table cellpadding="0" cellspacing="0" border="0" width="135" clasS="txt">
        	<tr>
				<td class="txtbold" colspan="2" height="20">&nbsp;&nbsp;<cf_get_lang no='15.alan yonetimi'></td>
        	</tr>
        	<tr>
          		<td width="20" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
          		<td width="115"><a class="tableyazi" href="#request.self#?fuseaction=store.list_departments"><cf_get_lang no='16.depolar'></a></td>
        	</tr>
        	<tr>
          		<td width="20" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
				<td><a class="tableyazi" href="#request.self#?fuseaction=store.list_shelves"><cf_get_lang_main no='2147.raflar'></a></td>
        	</tr>
        	<tr>
          		<td width="20" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
          		<td><a class="tableyazi" href="#request.self#?fuseaction=store.list_category_place"><cf_get_lang no='159.Kategori Alanı'></a></td>
        	</tr>		
		</table>
		</cfoutput>
		</td>
	</tr>
</table>
