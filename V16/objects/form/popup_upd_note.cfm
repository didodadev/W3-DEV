<cfset url_str = ''>
<cfif isDefined('attributes.style') and len(attributes.style)><cfset url_str =url_str&'&style=#attributes.style#'></cfif>
<cfif isDefined('attributes.design_id') and len(attributes.design_id)><cfset url_str =url_str&'&design_id=#attributes.design_id#'></cfif>
<cfif isDefined('attributes.is_special') and len(attributes.is_special)><cfset url_str =url_str&'&is_special=#attributes.is_special#'></cfif>
<cfif isDefined('attributes.action_type') and len(attributes.action_type)><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
<cfif isDefined('attributes.is_delete') and len(attributes.is_delete)><cfset url_str =url_str&'&is_delete=#attributes.is_delete#'></cfif>
<cfif isDefined('attributes.action_section') and len(attributes.action_section)><cfset url_str =url_str&'&action_section=#attributes.action_section#'></cfif>
<cfif isDefined('attributes.action_id') and len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfif isDefined('attributes.is_open_det') and len(attributes.is_open_det)><cfset url_str =url_str&'&is_open_det=#attributes.is_open_det#'></cfif>
<cfif isdefined("attributes.period_id") and len(attributes.period_id)><cfset url_str =url_str&'&period_id=#attributes.period_id#'></cfif>
<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)><cfset url_str =url_str&'&action_id_2=#attributes.action_id_2#'></cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfset url_str =url_str&'&company_id=#attributes.company_id#'></cfif>
<cfparam name="attributes.modal_id" default="1">

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
		IS_LINK,
		ALERT_DATE
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
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57467.Not'></cfsavecontent>
<cf_box id="upd_note_box" title="#getLang('dictonary_id','Not',57467)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" closable="1">
	<cfform name="add_note" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_note">
		<cf_box_elements>
			<input type="Hidden" name="note_id" id="note_id" value="<cfoutput>#attributes.note_id#</cfoutput>">	
			<div class="row">
				<div class="form-group">
					<div class="col col-4">
						<label>
							<input type="checkbox" value="1" name="is_special" id="is_special-is" <cfif Len(get_note.is_special) and get_note.is_special> checked</cfif>>
							<cf_get_lang dictionary_id='57979.Özel Not'>
						</label>
					</div>
					<div class="col col-4">
						<label>
							<input type="checkbox" value="1" name="is_warning" id="is_warning-iw" <cfif Len(get_note.is_warning) and get_note.is_warning> checked</cfif>>
							<cf_get_lang dictionary_id='57425.Uyarı'>
						</label>
					</div>
					<div class="col col-4">
						<label>
							<input type="checkbox" value="1" name="is_link" id="is_link-iw" <cfif Len(get_note.is_link) and get_note.is_link> checked</cfif>>
							<cf_get_lang dictionary_id='42371.Link'>
						</label>
					</div>
				</div>
				<div class="form-group" id="item-alert_date" <cfif not Len(get_note.is_warning) or get_note.is_warning eq 0>style="display:none;"</cfif>>
					<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id="58624.Geçerlilik Tarihi">*</label>
					<div class="col col-10 col-xs-12">
						<div class="input-group">
							<cfoutput>   
								<input type="text" name="alert_date" id="alert_date" value="<cfif Len(get_note.is_warning) and get_note.is_warning and len(get_note.alert_date)>#dateformat(get_note.alert_date,dateformat_style)#<cfelse>#dateformat(now(),dateformat_style)#</cfif>" validate="#validate_style#" required="yes" message="#alert#" readonly maxlength="10" onblur="change_money_info('add_note','alert_date');changeProcessDate();">
								<span class="input-group-addon btnPointer">
									<cf_wrk_date_image date_field="alert_date" call_function="change_money_info">
								</span>
							</cfoutput>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'>*</label>
					<div class="col col-10 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
						<cfif len(get_note.is_link) and get_note.is_link eq 1>
							<div class="input-group">
								<cfinput type="text" value="#get_note.note_head#" name="note_head" required="yes" message="#message#" maxlength="250">
								<a class="input-group-addon btnPointer icon-link" target="_blank" <cfif not Find("://",get_note.note_head)>href="https://<cfoutput>#get_note.note_head#</cfoutput>"<cfelse>href="<cfoutput>#get_note.note_head#</cfoutput>"</cfif>></a>
							</div>
						<cfelse>
							<cfinput type="text" value="#get_note.note_head#" name="note_head" required="yes" message="#message#" maxlength="250">
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
					<div class="col col-10 col-xs-12">
						<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarset="Basic"
						basepath="/fckeditor/"
						instancename="note_body"
						valign="top"
						value="#get_note.note_body#"
						width="600"
						height="150">
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<div style="display:none;" id="SHOW_INFO"></div>
			<cf_record_info query_name="get_note"> 
			<cf_workcube_buttons is_upd='1' add_function="control() && #iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_note' , #attributes.modal_id#)"),DE(""))#" type_format="1" is_delete='1' del_function='deleteControl()' delete_alert='#getLang('','Kayıtlı Notu Siliyorsunuz. Emin misiniz?',34188)#'>
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
    
	function deleteControl(){
		document.add_note.action = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_del_note</cfoutput>';
		loadPopupBox('add_note',<cfoutput>#attributes.modal_id#</cfoutput>);
		return false;
    }
	function control(){
		alert("kayıt başarılı");
	}
</script>