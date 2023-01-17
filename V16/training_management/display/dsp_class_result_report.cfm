<cfquery name="get_result" datasource="#DSN#">
    SELECT 
        CLASS_ID, 
        RESULT_HEAD, 
        RESULT_DETAIL, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE, 
        RECORD_PAR, 
        UPDATE_PAR 
    FROM 
        TRAINING_CLASS_RESULT_REPORT 
    WHERE 
        CLASS_ID = #attributes.CLASS_ID#
</cfquery>
<script type="text/javascript">
function gizle(id1){
 if(id1.style.display=='')
 	id1.style.display='none';
else
	id1.style.display='';
}
</script>
<cfsavecontent variable="img_">
	<cfif  get_result.recordcount and get_module_user(47)>
		<cfoutput>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_result&action=print&id=#url.class_id#&module=training_management&trail=1','page');return false;"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_result&action=mail&id=#url.class_id#&module=training_management&caption=class_result.class_head&trail=1','page')"><img src="/images/mail.gif" title="<cf_get_lang_main no='63.Mail Gönder'>" border="0"></a>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_result&action=pdf&id=#url.class_id#&module=training_management&trail=1','page')"><img src="/images/pdf.gif" title="<cf_get_lang_main no='66.PDF dönüştür'>" border="0"></a>
		</cfoutput>
	</cfif>
</cfsavecontent>
<cf_popup_box title="#getLang('training_management',37)#" right_images="#img_#">
	<cfform name="class_result" action="#request.self#?fuseaction=training_management.emptypopup_class_result_report&class_id=#url.class_id#" method="post">
		<div class="row">
			<div class="form-group">
				<label class="col col-1 col-xs-12"><cf_get_lang_main no='68.Başlık'></label>
				<div class="col col-10 col-xs-12">
					<cfif  get_result.recordcount>
						<input type="text" name="class_head" id="class_head" value="<cfoutput>#get_result.result_head#</cfoutput>" >
					<cfelse>
						<input type="text" name="class_head" id="class_head" value="">
					</cfif>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-12 col-xs-12"><cf_get_lang no='12.Rapor İçeriği'></label>
				<div class="col col-12 col-xs-12">
					<cfset tr_topic = get_result.RESULT_DETAIL>
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="WRKContent"
						basePath="/fckeditor/"
						instanceName="RESULT"
						valign="top"
						value="#tr_topic#"
						width="495"
						height="280">
					<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#url.class_id#</cfoutput>">
				</div>
			</div>
		</div>
		<div class="row formContentFooter">
			<cfif get_result.recordcount><cf_record_info query_name="get_result"></cfif>
			<cf_workcube_buttons type_format="1" is_upd='0'>
		</div>
	</cfform>
</cf_popup_box>

