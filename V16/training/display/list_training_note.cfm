<cfsetting showdebugoutput="no">
<cfquery name="get_training_notes" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		TRAINING_NOTES 
	WHERE 
		CLASS_ID = #attributes.CLASS_ID# 
		<cfif isdefined('session.ep')>
			AND EMPLOYEE_ID = #session.ep.userid#
		<cfelseif isdefined('session.pp')>
			AND PARTNER_ID = #session.pp.userid#
		</cfif>
</cfquery>
<table cellspacing="1" cellpadding="2" width="100%" border="0" class="color-row">
	<tr class="color-row">
		<td>
			<cfif not listfindnocase(denied_pages,'training.popup_form_add_training_note')>
				<a onClick="gizle_goster(my_add_note);" style="cursor:pointer;">
					<cf_get_lang_main no='53.Not Ekle'><img src="/images/plus_square.gif" title="<cf_get_lang_main no='53.Not Ekle'>" border="0">
				</a>
			</cfif>
		</td>
	</tr>
	<tr style="display:none;" id="my_add_note" class="color-row">
		<td><cfinclude template="../form/add_training_note.cfm"></td>
	</tr>
	<cfif get_training_notes.recordcount>
		<cfoutput query="get_training_notes">
		<tr class="color-row" height="20">
			<td>
				<a onClick="gizle_goster(my_upd_note#currentrow#);" style="cursor:pointer;"><img src="/images/pod_edit.gif" border="0"></a>
				&nbsp;#note_head#
				<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_training_note&note_id=#note_id#','list');" class="tableyazi"></a>--->
			</td>
		</tr>
		 <tr style="display:none;" id="my_upd_note#currentrow#" class="color-row">
			<td><cfinclude template="../form/upd_training_note.cfm"></td>
		  </tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" height="20">
			<td><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
		</tr>
	</cfif>
</table>
