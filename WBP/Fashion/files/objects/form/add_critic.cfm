<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
	SELECT 
	TST.*, PRI.PRIORITY
	FROM 
		TEXTILE_SAMPLE_REQUEST AS TST
		LEFT JOIN #dsn#.SETUP_PRIORITY PRI ON PRI.PRIORITY_ID = TST.REQ_TYPE_ID
	WHERE 
	TST.REQ_ID = #ACTION_ID#
</cfquery>
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_req_supplier_rival");
	get_operation=CreateCompenent.getOperation();
</cfscript>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id='60068.Kritik'><cf_get_lang dictionary_id='57582.Ekle'>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" popup_box="1"  collapsable="1" resize="0" scroll="0">
		<cfform name="add_note" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_all_critic">
			<input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action#</cfoutput>">
			<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
			<input type="hidden" name="action_id_2" id="action_id_2" value="<cfif isdefined("attributes.action_id_2")><cfoutput>#attributes.action_id_2#</cfoutput></cfif>">
			<input type="hidden" name="action_type" id="action_type" value="<cfoutput>#attributes.action_type#</cfoutput>">	
			<cf_box_elements verticable="1">
				<div class="col col-4 col-md-4 col-sm-12 col-xs-12 column" id="column-1">
					<div class="form-group">
						<div class="col col-6 col-xs-12">
							<input type="checkbox" value="1" name="is_special" id="is_special-is" style="margin-left:-3px;" <cfif isdefined('attributes.is_special') and attributes.is_special eq 1>checked</cfif>> <label for="is_special-is"><cf_get_lang_main no='567.Özel Not'></label> 
						</div>
						<div class="col col-6 col-xs-12">
							<input type="checkbox" value="1" name="is_warning" id="is_warning-iw" <cfif isdefined('attributes.is_warning') and attributes.is_special eq 1>checked</cfif>> <label for="is_warning-iw"><cf_get_lang_main no='13.Uyarı Notu'></label>
						</div>
					</div>
			
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
						<input type="hidden" style="width:290px;" name="note_head" required="yes" maxlength="75" align="left">
						<div class="col col-8 col-xs-12">
						<select style="width:70px;" name="operation">
							<option value=""><cf_get_lang dictionary_id='29419.Operasyon'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_operation"><option value="#operation_code#" >#OPERATION_TYPE# - #GET_OPPORTUNITY.PRIORITY#</option></cfoutput>
						</select>
					</div>
					</div>
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_seperator title="#getLang('','','60068')#" id="detail_seperator">
					<div id="detail_seperator">
						<div class="col col-12">
							<div class="form-group" id="item-editor">
								<label style="display:none!important"><cf_get_lang dictionary_id='60068.Kritik'></label>
								<cfmodule
									template="/fckeditor/fckeditor.cfm"
									toolbarset="Basic"
									basepath="/fckeditor/"
									instancename="note_body"
									valign="top"
									value=""
									width="1000"
									height="250">
							</div>
						</div>	
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='notkaydet()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
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
