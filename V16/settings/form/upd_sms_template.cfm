<!---SMS ŞABLONLARINI GETİR--->
<cfquery name="GET_TEMPLATE" datasource="#DSN#">
	SELECT 
		*
	FROM
		SMS_TEMPLATE
	WHERE 
		SMS_TEMPLATE_ID= #attributes.SMS_TEMPLATE_ID#
</cfquery>
<cf_catalystHeader>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfif not (fusebox.fuseaction contains 'popup')>
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cf_box title="#getLang('','SMS Şablonları','43726')#" collapsable="0" resize="0">
				<cfinclude template="../display/sms_templates_name.cfm">
			</cf_box>
		</div>
	</cfif> 
	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='36168.SMS Şablonu'><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
		<cf_box title="#title#" add_href="#request.self#?fuseaction=settings.form_add_sms_template" is_blank="0">
			<cfform name="upd_sms_template" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_sms_template">
				<input type="hidden" name="sms_template_id" id="sms_template_id" value="<cfoutput>#attributes.sms_template_id#</cfoutput>">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="row" sort="true">
						<div class="form-group" id="item-is_active">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><input type="checkbox" name="is_active" id="is_active" value="1" <cfif GET_TEMPLATE.IS_ACTIVE eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label></div>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><input type="checkbox" name="is_change" id="is_change" value="1" <cfif GET_TEMPLATE.IS_CHANGE eq 1>checked</cfif>><cf_get_lang dictionary_id='58507.Düzenlenebilir'></label></div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><label><input type="checkbox" name="is_edit_send_date" id="is_edit_send_date" value="1" <cfif GET_TEMPLATE.IS_EDIT_SEND_DATE eq 1>checked</cfif>><cf_get_lang dictionary_id='43727.Gönderim Zamanı Ayarlanabilir'></label></div>
						</div>
						<div class="form-group" id="item-template_name">
							<label class="col col-3 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1097.Şablon Adı'>*</label>
							<div class="col col-9 col-md-8 col-sm-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='58509.Şablon Adı'> </cfsavecontent>
								<cfinput type="text" name="template_name" value="#GET_TEMPLATE.SMS_TEMPLATE_NAME#" maxlength="50" required="Yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-fuseaction_name">
							<label class="col col-3 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='159.Fuseaction'><a style="cursor:pointer" onclick="gonder();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='36269.Fuseaction Ekle'>"></i></a></label>
							<div class="col col-9 col-md-8 col-sm-8 col-xs-12"> 
								<textarea name="fuseaction_name" id="fuseaction_name" style="width:250px;height:75px;" ><cfif len(GET_TEMPLATE.SMS_FUSEACTION)><cfoutput>#GET_TEMPLATE.SMS_FUSEACTION#</cfoutput></cfif></textarea>
							</div>
						</div>
						<div class="form-group" id="item-sms_template">
							<cfoutput>#wrk_form_sms_template(sms_body:'#GET_TEMPLATE.SMS_TEMPLATE_BODY#',is_table:0)#</cfoutput>
						</div>    
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="GET_TEMPLATE">
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_sms_template&sms_template_id=#attributes.sms_template_id#'>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
</div>


	
<script type="text/javascript">

function gonder()
{
	windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=upd_sms_template.fuseaction_name&is_upd=1</cfoutput>','list');
}
</script>
