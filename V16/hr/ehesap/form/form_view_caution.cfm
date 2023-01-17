<cfinclude template="../query/get_caution.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53966.Disiplin Cezası İşlemi"></cfsavecontent>
<cf_popup_box title="#message#">
	 <cfoutput query="get_caution">
		<table  border="0">
			<tr>
				<td width="5"></td>
				<td width="100" class="txtbold"><cf_get_lang dictionary_id='58820.Başlık'></td>
				<td>#caution_head#</td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id='57630.Tip'></td>
				<td>#caution_type#</td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id='58586.İşlem Yapan'></td>
				<td>#get_emp_info(warner,0,0)#</td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id='53515.İşlem Yapılan'></td>
				<td> #employee_name# #employee_surname# </td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td>#dateformat(caution_date,dateformat_style)#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td class="txtbold" valign="top"><cf_get_lang dictionary_id='53403.Kurul'></td>
				<td>
					<cfif isdefined("IS_DISCIPLINE_CENTER")><cf_get_lang dictionary_id='53339.Merkez Displin Kurulu'><br/></cfif>
					<cfif isdefined("IS_DISCIPLINE_BRANCH")><cf_get_lang dictionary_id='53340.Şube Disiplin Kurulu'></cfif>
				</td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold" colspan="2"><cf_get_lang dictionary_id='52990.Gerekçe'></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="2">#caution_detail#</td>
			</tr>
		</table>
	</cfoutput>
</cf_popup_box>
