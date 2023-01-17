<!--- 
    Author : Uğur Hamurpet
    Date : 31/08/2020
    Desc : Add new or update release note row form
--->

<cfset api_key = "201118kSm20">
<cfset session_ep_language = "#session.ep.language#">
<cfhttp url="https://networg.workcube.com/web_services/webserviceforrelease.cfc?method=GET_UPGRADE_NOTES" result="response" charset="utf-8">
    <cfhttpparam name="api_key" type="formfield" value="#api_key#">
    <cfhttpparam name="session_ep_language" type="formfield" value="#session_ep_language#">
    <cfhttpparam name="status" type="formfield" value="">
    <cfhttpparam name="record_number" type="formfield" value="10">
</cfhttp>

<cfset release_info = DeserializeJSON(Replace(response.filecontent,"//",""))> 

<cfif IsDefined("attributes.note_row_id") and len(attributes.note_row_id)>
    <cfset get_release_note_row = createObject('component','V16.objects.cfc.release_note_row').select(note_row_id:attributes.note_row_id) />
    <cfset attributes.task_id = len(get_release_note_row.TASK_ID) ? get_release_note_row.TASK_ID : '' />
    <cfset attributes.hook_id = len(get_release_note_row.HOOKID) ? get_release_note_row.HOOKID : ''  />
</cfif>

<cf_box title="#getLang('','',61189)#" collapsable="0" closable="1" draggable="1">
    <cfform name = "release_note_row" action = "" method = "post">
        <cfif IsDefined("attributes.note_row_id") and len(attributes.note_row_id)><cfinput name = "note_row_id" type = "hidden" value="#attributes.note_row_id#"></cfif>
        <cfif IsDefined("attributes.task_id") and len(attributes.task_id)><cfinput name = "task_id" type = "hidden" value="#attributes.task_id#"></cfif>
        <cfif IsDefined("attributes.hook_id") and len(attributes.hook_id)><cfinput name = "hook_id" type = "hidden" value="#attributes.hook_id#"></cfif>
        <div class="row">
            <div class="col col-12 pdn-r-0">
                <div class="form-group">
                    <div class="col col-3 col-xs-12 pdn-l-0 pdn-r-0">
                        <label class="col col-12">Release*</label>
                        <div class="col col-12">
                            <select name="release_no" id="release_no" onchange="setPatch(this)" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfset relese_no = iif(isDefined("get_release_note_row"), "get_release_note_row.RELEASE_NO", DE(''))>
                                <cfif isdefined('release_info.recordcnt') and len(release_info.recordcnt)>
                                    <cfoutput>
                                        <cfloop index = "i" from = "1" to = "#release_info.recordcnt#">
                                            <option value="#release_info.RELEASE[i].RELEASE#" <cfoutput>#iif(relese_no eq release_info.RELEASE[i].RELEASE,de('selected'),de(''))#</cfoutput> data-patch_info='#release_info.RELEASE[i].PATCH_INFO#'>#release_info.RELEASE[i].RELEASE#</option>
                                        </cfloop>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="col col-3 col-xs-12 pdn-l-0 pdn-r-0">
                        <label class="col col-12">Patch No</label>
                        <div class="col col-12">
                            <select name="patch_no" id="patch_no">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            </select>
                        </div>
                    </div>
                    <div class="col col-3 col-xs-12 pdn-l-0 pdn-r-0">
                        <label class="col col-12">Type*</label>
                        <div class="col col-12">
                            <select name="note_row_type" id="note_row_type" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="Feature" <cfoutput>#iif((isDefined("get_release_note_row") and get_release_note_row.note_row_type eq 'Feature'),de('selected'),de(''))#</cfoutput>>Feature</option>
                                <option value="Hotfix" <cfoutput>#iif((isDefined("get_release_note_row") and get_release_note_row.note_row_type eq 'Hotfix'),de('selected'),de(''))#</cfoutput>>Hotfix</option>
                            </select>
                        </div>
                    </div>
                    <div class="col col-3 col-xs-12 pdn-l-0 pdn-r-0">
                        <label class="col col-12" style="height:12px;"></label>
                        <label class="col col-12"><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="note_row_status" value="1" <cfoutput>#iif((isDefined("get_release_note_row") and get_release_note_row.note_row_status),de('checked'),de(''))#</cfoutput>></label>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col col-12 pdn-r-0">
                <div class="form-group">
                    <label class="col col-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
                    <div class="col col-12">
                        <textarea name="note_row_title" id="note_row_title" style="height:30px;"><cfoutput>#iif(isDefined("get_release_note_row"),"get_release_note_row.note_row_title",de(''))#</cfoutput></textarea>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col col-12 pdn-r-0">
                <div class="form-group">
                    <div class="col col-12">
                        <cfmodule
                            template="/fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="note_row_detail"
                            valign="top"
                            value="#iif(isDefined("get_release_note_row"),'get_release_note_row.note_row_detail',de(''))#"
                            width="100%"
                            height="100">
                    </div>
                </div>
            </div>
        </div>
        <div class="row formContentFooter">
            <div class="col col-6">
                <cfif IsDefined("attributes.note_row_id") and len(attributes.note_row_id)>
                    <cf_record_info query_name="get_release_note_row">
                </cfif>
            </div>
            <div class="col col-6">
                <cfif IsDefined("attributes.note_row_id") and len(attributes.note_row_id)><cf_workcube_buttons is_upd="1" add_function="kontrol()"><cfelse><cf_workcube_buttons add_function="kontrol()"></cfif>
            </div>	  
        </div>
    </cfform>

    <script>
        <cfif IsDefined("attributes.note_row_id") and len(attributes.note_row_id)>
            setPatch(document.getElementById('release_no'), '', "<cfoutput>#iif(isDefined("get_release_note_row"),'get_release_note_row.patch_no',de(''))#</cfoutput>");
        <cfelse>
            setPatch(document.getElementById('release_no'), 0);
        </cfif>

        function setPatch( element, index, patchSelectedValue ) {
            var elem = (typeof element.selectedIndex === "undefined" ? window.event.srcElement : element);
            if( elem.value != '' ){
                var patchInfo = element.options[ (typeof index != "undefined" && index != '') ? index : elem.selectedIndex ].getAttribute('data-patch_info');
                document.getElementById('patch_no').innerHTML = "<option value=''><cf_get_lang dictionary_id='57734.Seçiniz'></option>";
                if( patchInfo != '' ) JSON.parse(patchInfo).forEach((el) => {$("<option>").val(el.patch_no).text(el.patch_no).appendTo($("#patch_no"))});
                if( typeof patchSelectedValue != 'undefined' && patchSelectedValue != '' ) document.getElementById('patch_no').value = patchSelectedValue;
            }
        }

        function kontrol(){
            if(document.getElementById("release_no").value == "")
            {
                alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : Release No!");
                return false;
            }
            if(document.getElementById("note_row_type").value == "")
            {
                alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : Type!");
                return false;
            }
            if($.trim(decodeURIComponent(CKEDITOR.instances['note_row_detail'].getData())) == ""){
                alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : Release Detail!");
                return false;
            }
            return true;
        }

    </script>

</cf_box>