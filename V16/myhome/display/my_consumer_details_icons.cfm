<cfform action="#request.self#?fuseaction=myhome.my_consumer_details&cid=#attributes.cid#" method="post">
	<table cellpadding="0" cellspacing="0" border="0" style="text-align:right;">
		<tr>
			<td><input type="hidden" name="cid" id="cid" value="<cfoutput>#attributes.cid#</cfoutput>">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</td>
			<td><cf_wrk_search_button></td>
			<td><cfoutput><a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#attributes.cid#" class="tableyazi"><img src="/images/properties.gif" title="<cf_get_lang dictionary_id='57771.Detay'>" border="0" align="absmiddle"></a></cfoutput></td>
			<td><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#attributes.cid#','page','popup_list_comp_extre');"><img src="/images/extre_cari.gif" title="Hesap Ektresi" border="0" align="absmiddle"></cfoutput></a></td>
		</tr>
	</table>
</cfform>
