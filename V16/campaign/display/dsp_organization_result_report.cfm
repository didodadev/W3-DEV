<cfquery name="get_result" datasource="#DSN#">
    SELECT 
        ORGANIZATION_ID, 
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
        ORGANIZATION_RESULT_REPORT 
    WHERE 
        ORGANIZATION_ID = #attributes.ORGANIZATION_ID#
</cfquery>
<script type="text/javascript">
function gizle(id1){
 if(id1.style.display=='')
 	id1.style.display='none';
else
	id1.style.display='';
}
</script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Etkinlik Sonuç Raporu','63733')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="class_result" action="#request.self#?fuseaction=campaign.emptypopup_organization_result_report&organization_id=#url.organization_id#" method="post">
				<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
				<div class="form-group">
					<label class="col col-1 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
					<div class="col col-10 col-xs-12">
						<cfif  get_result.recordcount>
							<input type="text" name="result_head" id="result_head" value="<cfoutput>#get_result.result_head#</cfoutput>" >
						<cfelse>
							<input type="text" name="result_head" id="result_head" value="">
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='46219.Rapor İçeriği'></label>
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
						<input type="hidden" name="organization_id" id="organization_id" value="<cfoutput>#url.organization_id#</cfoutput>">
					</div>
				</div>
			<cf_box_footer>
				<cfif get_result.recordcount><cf_record_info query_name="get_result"></cfif>
				<cf_workcube_buttons type_format="1" is_upd='0'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

