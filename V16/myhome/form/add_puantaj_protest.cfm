<cfsavecontent variable="message"><cf_get_lang dictionary_id='31442.Bordro İtirazı Ekle'></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="add_protest" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_puantaj_protest" onsubmit="">		
	<table>
		<cfoutput>
			<tr class="txtbold">
				<input type="hidden" name="salary_mon" id="salary_mon" value="<cfoutput>#attributes.sal_mon#</cfoutput>">
				<input type="hidden" name="salary_year" id="salary_year" value="<cfoutput>#attributes.sal_year#</cfoutput>">
				<input type="hidden" name="employee_puantaj_id" id="employee_puantaj_id" value="<cfoutput>#attributes.emp_puantaj_id#</cfoutput>">
				<input type="hidden" name="puantaj_id" id="puantaj_id" value="<cfoutput>#attributes.puantaj_id#</cfoutput>">
				<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
				<cfset ay=ListGetAt(ay_list(),attributes.sal_mon,',')>
				<td><cf_get_lang dictionary_id='57576.Çalışan'></td>
				<td>#session.ep.name#&nbsp;#session.ep.surname#</td>
			</tr>
			<tr class="txtbold">
				<td><cf_get_lang dictionary_id='31444.Bordro'></td>
				<td>#ay#/#attributes.sal_year#</td> 
			</tr>
		</cfoutput>
		<tr>
			<td valign="top"><cf_get_lang dictionary_id='31443.İtiraz Nedeni'></td>
			<td>
				<textarea name="detail" id="detail" style="width:250px;height:100px;"></textarea>
			</td>
		</tr>
	</table>
	<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_popup_box_footer>
</cfform>	
</cf_popup_box>
