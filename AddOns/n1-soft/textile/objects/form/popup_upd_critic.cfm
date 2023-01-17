<cfscript>
	CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.get_req_supplier_rival");
		get_operation=CreateCompenent.getOperation();
</cfscript>
<cfquery name="GET_NOTE" datasource="#DSN#">
	SELECT 
		IS_SPECIAL,
		IS_WARNING,
		NOTE_HEAD,
		NOTE_BODY,
		RECORD_EMP,
		RECORD_PAR,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_PAR,
		ACTION_ID
	FROM
		NOTES
	WHERE 
		NOTE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.note_id#"> AND
		(
		IS_SPECIAL = 0
	<cfif isDefined('session.ep')>
		OR ( IS_SPECIAL = 1 AND (RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) )
	<cfelseif isDefined('session.pp')>
		OR ( IS_SPECIAL = 1 AND (RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">) )
	</cfif>
		)
</cfquery>
<cf_popup_box title="#getLang('textile',15)#">
	<cfform name="add_note" method="post" action="#request.self#?fuseaction=textile.emptypopup_upd_critic">
		<input type="Hidden" name="note_id" id="note_id" value="<cfoutput>#attributes.note_id#</cfoutput>">
		<input type="Hidden" name="action_id" id="action_id" value="<cfoutput>#GET_NOTE.action_id#</cfoutput>">			
		<table border="0">
			<tr>
				<td>&nbsp;</td>
				<td>
					<input type="checkbox" value="1" name="is_special" id="is_special-is" <cfif Len(get_note.is_special) and get_note.is_special> checked</cfif>> <label for="is_special-is"><cf_get_lang_main no='567.Özel Not'></label> 
					<input type="checkbox" value="1" name="is_warning" id="is_warning-iw" <cfif Len(get_note.is_warning) and get_note.is_warning> checked</cfif>> <label for="is_warning-iw"><cf_get_lang_main no='13.Uyarı'></label>
				</td>
			</tr>
			<tr>
				<td width="75"><cf_get_lang_main no='68.Başlık'>*</td>
				
					<td style="text-align:left">
					<!---<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="text" style="width:290px;" name="note_head" required="yes" message="#message#" maxlength="75" align="left">
					--->
	
							<input type="hidden" style="width:290px;" name="note_head" value="<cfoutput>#get_note.note_head#</cfoutput>" required="yes" maxlength="75" align="left">
							<select style="width:70px;" name="operation">
								<option value="">Operasyon Seçiniz</option>
								<cfoutput query="get_operation"><option value="#operation_type_id#" <cfif operation_type eq get_note.note_head>selected</cfif>>#OPERATION_TYPE#</option></cfoutput>
							</select>
					<!---<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="text"  value="#get_note.note_head#" name="note_head" required="yes" message="#message#" maxlength="75">--->
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='55.Not'></td>
				<td>
					<!---<textarea name="note_body" id="note_body" style="width:250px; height:100px;" rows="5"><cfoutput>#get_note.note_body#</cfoutput></textarea>--->
					<div class="colspan=2">
						<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarset="Basic"
							basepath="/fckeditor/"
							instancename="note_body"
							valign="top"
							value="<cfoutput>#get_note.note_body#</cfoutput>"
							width="750"
							height="250">
					</div>
				</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_note"> 
				<!---<button type="button" onclick="notkaydet();" class="btn btn-primary">Güncelle</button>--->
			   <cf_workcube_buttons is_upd='1' type_format="1" add_function='notkaydet()' is_delete='1' delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_note&note_id=#attributes.note_id#' delete_alert='Kayıtlı Not Siliyorsunuz! Emin misiniz?'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script>
	function notkaydet()
	{
		if(document.all.operation.value=="")
		{
			alert('Operasyon Seçiniz!');
			return false;
		}
		obj=document.all.operation;
		document.all.note_head.value=obj.options[obj.selectedIndex].text;
		document.add_note.submit();
		return true;
	}
</script>