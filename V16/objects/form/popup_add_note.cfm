<cfparam name="attributes.modal_id" default="">
<cf_box id="add_note_box" title="#getLang('dictonary_id','Not Ekle',57465)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" closable="1">
	<cfform name="add_note" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_all_note">
		<input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action#</cfoutput>">
		<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
		<input type="hidden" name="action_id_2" id="action_id_2" value="<cfif isdefined("attributes.action_id_2")><cfoutput>#attributes.action_id_2#</cfoutput></cfif>">
		<input type="hidden" name="action_type" id="action_type" value="<cfoutput>#attributes.action_type#</cfoutput>">					  					  					  
		<cf_box_elements>
			<div class="row">
				<div class="form-group">
					<div class="col col-4">
						<label>
							<input type="checkbox" value="1" name="is_special" id="is_special-is"<cfif isdefined('attributes.is_special') and attributes.is_special eq 1>checked</cfif>> 
							<cf_get_lang dictionary_id='57979.Özel Not'>
						</label>
					</div>
					<div class="col col-4">
						<label>
							<input type="checkbox" value="1" name="is_warning" id="is_warning-iw" <cfif isdefined('attributes.is_warning') and attributes.is_warning eq 1>checked</cfif>>
							<cf_get_lang dictionary_id='57425.Uyarı Notu'>
						</label>
					</div>
					<div class="col col-4">	
						<label>
							<input type="checkbox" value="1" name="is_link" id="is_link-il" <cfif isdefined('attributes.is_link') and attributes.is_link eq 1>checked</cfif>>
							<cf_get_lang dictionary_id='42371.Link'>
						</label>
					</div>
				</div>
				<div class="form-group" id="item-alert_date" style="display:none;">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58624.Geçerlilik Tarihi">*</label>
					<div class="col col-6 col-xs-12">
						<div class="input-group">
							<cfoutput>   
								<input type="text" name="alert_date" id="alert_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="yes" message="#alert#" readonly maxlength="10" style="width:120px;" onblur="change_money_info('add_note','alert_date');changeProcessDate();">
								<span class="input-group-addon btnPointer">
									<cf_wrk_date_image date_field="alert_date" call_function="change_money_info">
								</span>
							</cfoutput>
						</div>
					</div>
				</div>
				<div class="form-group">
					<div class="col col-12 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
						<cfinput type="text" style="width:290px;" name="note_head" required="yes" message="#message#" placeholder="#message#" maxlength="250" align="left">
					</div>
				</div>
				<div class="form-group">
					<div class="col col-12 col-xs-12">
						<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarset="Basic"
						basepath="/fckeditor/"
						instancename="note_body"
						valign="top"
						value=""
						width="600"
						height="150">
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<div style="display:none;" id="SHOW_INFO"></div>
			<cf_workcube_buttons type_format="1" is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_note' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
<script>
	$(function(){
		$('#is_warning-iw').click(function(){
			if ($('#is_warning-iw').is(':checked')) $('div#item-alert_date').css('display','');
			else $('div#item-alert_date').css('display','none');
		});
	});
</script>