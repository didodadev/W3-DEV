<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_visited_notes.cfm">
<cfsavecontent variable="Notlar"><cf_get_lang dictionary_id='57422.notlar'></cfsavecontent>
<cf_flat_list>
	<tbody>
		<cfif detail_notes_visited.recordcount>
			<cfoutput query="detail_notes_visited">
				<tr id="notes_#currentrow#">
					<td class="iconL"><a href="javascript://"  onClick="gizle_goster(NOTES_DETAIL#currentrow#);connectAjax(#currentrow#,#v_note_id#);"><i class="fa fa-caret-right"></i></a></td>
					<td>  
						<cfif (session.ep.userid) eq (record_emp)>
							<cfset _font_color_ =''>
						<cfelse>
							<cfset _font_color_ ='FF6633'>
						</cfif>
						<font color="#_font_color_#">&nbsp;&nbsp;#left(detail, 25)#...-</font>
						<cfif len(note_taken_id)><font color="#_font_color_#">#get_emp_info(note_taken_id,0,0)#</font></cfif>
					</td>
					<cfsavecontent variable="delete_note"><cf_get_lang dictionary_id ='31968.Kayıtlı Notu Siliyorsunuz Emin misiniz'></cfsavecontent>
					<td class="text-center"><a style="cursor:pointer" onClick="if(confirm('#delete_note#')){AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_del_visiting_notes&note_id=#v_note_id#','notes_ajax',1,'Siliniyor...');gizle(notes_#currentrow#);gizle(NOTES_DETAIL#currentrow#);}else return false;"><i class="fa fa-minus"></i></a></td>
				</tr>
				<tr class="nohover" id="NOTES_DETAIL#currentrow#" style="display:none;">
					<td colspan="3"><div id="show_notes_detail#currentrow#"></div></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>
<script type="text/javascript">
function connectAjax(row_id,v_note_id)
{
	var bb = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_notes_visited&satir_id="+row_id+"&id="+v_note_id+"";
	AjaxPageLoad(bb,'show_notes_detail'+row_id+'',0);
}
</script>
