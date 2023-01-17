<cfset cmp = createObject("component","V16.hr.cfc.setupComplaints") />
<cfset get_Complaint = cmp.getComplaints(complaint_id:attributes.complaint_id)>
<cfsavecontent  variable="title_"><cf_get_lang dictionary_id='55885.Tedavi Tipleri'>
</cfsavecontent>
<cf_catalystHeader>
<cf_box closable="0" collapsable="0" title="#title_# : #attributes.complaint_id#" add_href="#request.self#?fuseaction=hr.list_complaints&event=add">
    <cfform name="upd_complaint" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_complaints">
    <input name="complaint_id" id="complaint_id" value="<cfoutput>#attributes.complaint_id#</cfoutput>" type="hidden">
    <cf_box_elements vertical="1">
        <div class="col col-6">
            <div class="form-group" id="item-complaint_status">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='57493.Aktif'></label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <input type="Checkbox" name="complaint_status" id="complaint_status" value="1" <cfif get_Complaint.is_default eq 1> checked</cfif>>
                </div>
            </div>
            <div class="form-group" id="item-code">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='58585.kod'></label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfinput type="text" name="code" value="#get_Complaint.code#" maxlength="50">
                </div>
            </div>
            <div class="form-group" id="item-complaint">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='32413.Tanı'></label>
                </div>

                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <cfinput type="Text" name="complaint" id="complaint" value="#get_Complaint.complaint#">
                        <span class="input-group-addon">
                            <cf_language_info 
                                table_name="SETUP_COMPLAINTS" 
                                column_name="COMPLAINT" 
                                column_id_value="#attributes.complaint_id#" 
                                maxlength="500" 
                                datasource="#dsn#" 
                                column_id="COMPLAINT_ID" 
                                control_type="0">
                        </span>
                    </div>						
                </div>				
                   
                
            </div>
            <div class="form-group" id="item-description">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='57629.Açıklama'></label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <textarea name="description" id="description"><cfoutput>#get_Complaint.description#</cfoutput></textarea>
                </div>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cf_record_info query_name="get_Complaint">
        <cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
    </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById("complaint").value == "")
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='32413.Tanı'>!");
		return false;
	}
	return true;
}
</script>
