<cfscript>
	CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.get_req_supplier_rival");
	get_operation=CreateCompenent.getOperation();
</cfscript>
<cfform name="add_note" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_all_critic">
	<cf_popup_box title="#getLang('textile',15)#">
		<input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action#</cfoutput>">
		<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
		<input type="hidden" name="action_id_2" id="action_id_2" value="<cfif isdefined("attributes.action_id_2")><cfoutput>#attributes.action_id_2#</cfoutput></cfif>">
		<input type="hidden" name="action_type" id="action_type" value="<cfoutput>#attributes.action_type#</cfoutput>">					  					  					  
		<table>
			<tr>
				<td>&nbsp;</td>
				<td>
					<input type="checkbox" value="1" name="is_special" id="is_special-is" style="margin-left:-3px;" <cfif isdefined('attributes.is_special') and attributes.is_special eq 1>checked</cfif>> <label for="is_special-is"><cf_get_lang_main no='567.Özel Not'></label> 
					<input type="checkbox" value="1" name="is_warning" id="is_warning-iw" <cfif isdefined('attributes.is_warning') and attributes.is_special eq 1>checked</cfif>> <label for="is_warning-iw"><cf_get_lang_main no='13.Uyarı Notu'></label>
				</td>
			</tr>
			<tr>
				<td width="75"><cf_get_lang_main no='68.konu'> *</td>
				<td style="text-align:left">
					<!---<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="text" style="width:290px;" name="note_head" required="yes" message="#message#" maxlength="75" align="left">
					--->
					<input type="hidden" style="width:290px;" name="note_head" required="yes" maxlength="75" align="left">
					<select style="width:70px;" name="operation">
						<option value="">Operasyon Seçiniz</option>
						<cfoutput query="get_operation"><option value="#operation_type_id#" >#OPERATION_TYPE#</option></cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top">Kritik</td>
				<td valign="bottom">
					<div class="colspan=2">
						<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarset="Basic"
							basepath="/fckeditor/"
							instancename="note_body"
							valign="top"
							value=""
							width="750"
							height="250">
					</div>	
					<!---<textarea name="note_body" id="note_body" style="width:290px;" rows="10"></textarea>--->
				</td>
			</tr>
		</table>
				<cf_workcube_buttons is_upd='0' add_function='notkaydet()'>
			<!---<button type="button" onclick="notkaydet()" class="btn btn-primary">Kaydet</button>--->
	</cf_popup_box>
</cfform>
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
	}
</script>
