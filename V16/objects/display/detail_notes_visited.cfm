<cfsetting showdebugoutput="no">
<cfquery name="DETAIL_NOTES_VISITED" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		VISITING_NOTES 
	WHERE	
		V_NOTE_ID = #attributes.id#
</cfquery>
<cfoutput>
	<div style="overflow:auto;border:1;" >
		<cf_flat_list id="notes_#attributes.id#">
			<tr>
				<td><cf_get_lang dictionary_id='32493.Not Bırakan'></td>
				<td><cfif len(#detail_notes_visited.record_emp#)>#get_emp_info(detail_notes_visited.record_emp,0,0)#<cfelse>#detail_notes_visited.note_given#</cfif></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57499.Telefon'></td>
				<td>#detail_notes_visited.tel#</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='32508.E-Mail'></td>
				<td>#detail_notes_visited.email#</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="2">
					#detail_notes_visited.detail#
				</td>
			</tr>
			<tr>
				<td colspan="2"><cf_get_lang dictionary_id='57483.Kayıt'> :
					<cfif isdefined("detail_notes_visited.record_emp") and len(detail_notes_visited.record_emp)>
						#get_emp_info(detail_notes_visited.record_emp,0,0)#
					<cfelseif isdefined("detail_notes_visited.record_par") and len(detail_notes_visited.record_par)>
						#get_par_info(detail_notes_visited.record_par,0,-1,0)#
					<cfelseif isdefined("detail_notes_visited.record_con") and len(detail_notes_visited.record_con)>
						#get_cons_info(detail_notes_visited.record_con,0,0)#
					</cfif>
						#dateformat(detail_notes_visited.record_date,dateformat_style)#
				</td>
			</tr>
			
		</cf_flat_list>
		<cfif not isdefined (attributes.satir_id)>
			<div class="ui-info-bottom flex-end">
				<cfset employee_id = get_emp_info(detail_notes_visited.record_emp,0,0)>
				<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_nott&employee_id=#detail_notes_visited.record_emp#','','ui-draggable-box-small');" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id="60719.Cevap ver"></a>
			</div>
		</cfif>
	</div>
</cfoutput>

