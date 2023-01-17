<cfparam name="attributes.id" default="">

<link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">

<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfset getSolution = list_wbo.getSolution()>

<cfif len(attributes.id)><cfset event_query = get_event_detail(attributes.id)></cfif>

<cf_box title="Events">
<cfform name="AddFuseactionForm" method="post" type="formControl">
    <cfif isDefined("attributes.fuseact")>
        <input type="hidden" name="formsubmitted" id="formsubmitted" value="1">
        <input type="hidden" name="fuseact" value="<cfoutput>#attributes.fuseact#</cfoutput>">
    </cfif>
    <div class="col col-12 col-xs-12">
        <div class="row formContent">
            <div class="col col-4 col-xs-12">
                <div class="form-group" id="item-">
                    <label class="col col-4 col-xs-12">Head *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfoutput>
                                <input type="text" name="title" id="title" value="#iif(isDefined("event_query"),"event_query.EVENT_TITLE",de(""))#" message="Head alanını sözlükten seçiniz" required>
                                <input type="hidden" name="dictionaryid" id="dictionaryid">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=settings.popup_list_lang_settings&module_name=dev&is_use_send&lang_dictionary_id=AddFuseactionForm.dictionaryid&lang_item_name=AddFuseactionForm.title', 'list'); return false;"></span>
                            </cfoutput>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-">
                    <label class="col col-4 col-xs-12">Solution *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput>
                            <input type="hidden" name="solution" id="solution" value="#iif(isDefined("event_query"),"event_query.EVENT_SOLUTION",de(""))#">
                            <select id="solutionid" name="solutionid" onchange="loadFamilies(this.value,'familyid','moduleid')" message="Solution seçiniz" required #iif(isDefined("event_query"),de('disabled="disabled"'),de(""))#>
                        </cfoutput>
                                <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <cfoutput query="getSolution">
                                <option value="#WRK_SOLUTION_ID#"#iif(isDefined("event_query") and WRK_SOLUTION_ID eq event_query.EVENT_SOLUTIONID,de(' selected="selected"'),de(""))#>#NAME#</option>
                            </cfoutput>
                            </select>
                            <cfif isDefined("event_query")><cfinput type="hidden" name="solutionid" value="#event_query.EVENT_SOLUTIONID#"></cfif>
                    </div>
                </div>
                <div class="form-group" id="item-">
                    <input type="hidden" name="family" id="family">
                    <label class="col col-4 col-xs-12">Family *</label>
                    <div class="col col-8 col-xs-12">
                        <select id="familyid" name="familyid" onchange="loadModules(this.value, 'moduleid')" message="Family seçiniz" required <cfoutput>#iif(isdefined("event_query"),de('disabled="disabled"'),de(""))#</cfoutput>>
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                        </select>
                        <cfif isDefined("event_query")><cfinput type="hidden" name="familyid" value="#event_query.EVENT_FAMILYID#"></cfif>
                    </div>
                </div>
                <div class="form-group" id="item-">
                    <input type="hidden" name="module" id="module">
                    <label class="col col-4 col-xs-12">Module *</label>
                    <div class="col col-8 col-xs-12">
                        <select id="moduleid" name="moduleid" message="Module seçiniz" required <cfoutput>#iif(isDefined("event_query"),de('disabled="disabled"'),de(""))#</cfoutput>>
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                        </select>
                        <cfif isDefined("event_query")><cfinput type="hidden" name="moduleid" value="#event_query.EVENT_MODULEID#"></cfif>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">
                <div class="form-group" id="item-">
                    <label class="col col-4 col-xs-12">Related WO *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfoutput>
                                <input type="text" name="related_wo" id="related_wo" value="#iif(isDefined("event_query"),"event_query.EVENT_FUSEACTION",de(""))#" required <cfoutput>#iif(isDefined("event_query"),de('disabled="disabled"'),de(""))#</cfoutput>>
                                <cfif not isDefined("event_query")>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=AddFuseactionForm.related_wo&is_upd=0&choice=1','list');return false;"></span>
                                <cfelse>
                                    <span class="input-group-addon icon-ellipsis btnPointer"></span>
                                </cfif>
                                <cfif isDefined("event_query")><cfinput type="hidden" name="related_wo" value="#event_query.EVENT_FUSEACTION#"></cfif>
                            </cfoutput>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-">
                    <label class="col col-4 col-xs-12">License *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput>
                        <select id="license" name="license" onchange="showHide($(this));" message="Lisans titpini seçiniz" required>
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <option value="1"#iif(isDefined("event_query") and event_query.EVENT_LICENSE eq "1",de(' selected="selected"'),de(''))#>Standart</option>
                            <option value="1"#iif(isDefined("event_query") and event_query.EVENT_LICENSE eq "2",de(' selected="selected"'),de(''))#>Add-On</option>
                            <option value="1"#iif(isDefined("event_query") and event_query.EVENT_LICENSE eq "3",de(' selected="selected"'),de(''))#>Add-Options</option>
                        </select>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-">
                    <label class="col col-4 col-xs-12">Tool *</label>
                    <div class="col col-8 col-xs-12">
                        <cf_devtool name="tool" onchange="loadTool(this.value)" message="Tool tipini seçiniz" required="1" selected="#iif(isDefined("event_query"),"event_query.EVENT_TOOL",de(""))#" value="#iif(isDefined("event_query"),"event_query.EVENT_TOOL",de(""))#" disabled="#isDefined("event_query")#">
                        <cfif isDefined("event_query")><cfinput type="hidden" name="tool" value="#event_query.EVENT_TOOL#"></cfif>
                    </div>
                </div>
                <div class="form-group" id="item-">
                    <label class="col col-4 col-xs-12">Version *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput>
                            <input type="text" name="version" id="version" value="#iif(isDefined("event_query"),"event_query.EVENT_VERSION",de(""))#" required>
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Statu *</label>
                    <div class="col col-8 col-xs-12">
                    <cfoutput>
                        <select name="status" id="status" message="Statü seçiniz" required>
                            <option value="Analys"#iif( isDefined( "event_query" ) and event_query.EVENT_STATUS eq "Analys", de( ' selected="selected"' ), de( "" ) )#>Analys</option>
                            <option value="Deployment"#iif( isDefined( "event_query" ) and event_query.EVENT_STATUS eq "Deployment", de( ' selected="selected"' ), de( "" ) )#>Deployment</option>
                            <option value="Design"#iif( isDefined( "event_query" ) and event_query.EVENT_STATUS eq "Design", de( ' selected="selected"' ), de( "" ) )#>Design</option>
                            <option value="Development"#iif( isDefined( "event_query" ) and event_query.EVENT_STATUS eq "Development", de( ' selected="selected"' ), de( "" ) )#>Development</option>
                            <option value="Testing"#iif( isDefined( "event_query" ) and event_query.EVENT_STATUS eq "Testing", de( ' selected="selected"' ), de( "" ) )#>Testing</option>
                            <option value="Cancel"#iif( isDefined( "event_query" ) and event_query.EVENT_STATUS eq "Cancel", de( ' selected="selected"' ), de( "" ) )#>Cancel</option>
                        </select>
                    </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Stage *</label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='1' fusepath="dev.workdev" select_value='#iif( isDefined( "event_query" ), "event_query.EVENT_STAGE", de( "0" ) )#'>
                    </div>
                </div>
                <cfoutput>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12" message="Author adını giriniz">Author *</label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput><input type="text" name="author" id="author" value="#iif( isDefined( "event_query" ), "event_query.EVENT_AUTHOR", de( "" ) )#" required></cfoutput>
                        </div>
                    </div>
                </cfoutput>
            </div>
        </div>
        <div class="row mt-4">
            <div class="col col-12 col-xs-12 hidetool" id="code"<cfoutput>#iif(isDefined("event_query")&&event_query.EVENT_TOOL eq "code",de(''),de(' style="display:none;"'))#</cfoutput>>
                <div class="portHeadLight font-green-sharp">CODE</div>
                <div class="col-4 col-xs-12">
                    <div class="form-group" id="item-file_path">
                        <label class="col col-4 col-xs-12">File Path *</label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <cfif isDefined("event_query") and len(event_query.ADD_PATH)>
                                    <input type="text" name="file_path" id="file_path" value="#event_query.ADD_PATH#">
                                <cfelseif isDefined("event_query") and len(event_query.UPDATE_PATH)>
                                    <input type="text" name="file_path" id="file_path" value="#event_query.UPDATE_PATH#">
                                <cfelseif isDefined("event_query") and len(event_query.LIST_PATH)>
                                    <input type="text" name="file_path" id="file_path" value="#event_query.LIST_PATH#">
                                <cfelseif isDefined("event_query") and len(event_query.DASHBOARD_PATH)>
                                    <input type="text" name="file_path" id="file_path" value="#event_query.DASHBOARD_PATH#">
                                <cfelseif isDefined("event_query") and len(event_query.INFO_PATH)>
                                    <input type="text" name="file_path" id="file_path" value="#event_query.INFO_PATH#">
                                <cfelse>
                                    <input type="text" name="file_path" id="file_path" value="">
                                </cfif>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-event_type_choose">
                        <label class="col col-4 col-xs-12">Event Type *</label>
                        <div class="col col-8 col-xs-12">
                            <select name="eventType">
                                <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                <option value="add:<cfoutput>#iif(isDefined("event_query")&&event_query.ADD_ID gt 0,"event_query.ADD_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.ADD_ID gt 0,de(' selected="selected"'),de(""))#</cfoutput>>Add</option>
                                <option value="update:<cfoutput>#iif(isDefined("event_query")&&event_query.UPDATE_ID gt 0,"event_query.UPDATE_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.UPDATE_ID gt 0,de(' selected="selected"'),de(""))#</cfoutput>>Update</option>
                                <option value="list:<cfoutput>#iif(isDefined("event_query")&&event_query.LIST_ID gt 0,"event_query.LIST_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.LIST_ID gt 0,de(' selected="selected"'),de(""))#</cfoutput>>List</option>
                                <option value="dashboard:<cfoutput>#iif(isDefined("event_query")&&event_query.DASHBOARD_ID gt 0,"event_query.DASHBOARD_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.DASHBOARD_ID gt 0,de(' selected="selected"'),de(""))#</cfoutput>>Dashboard</option>
                                <option value="info:<cfoutput>#iif(isDefined("event_query")&&event_query.INFO_ID gt 0,"event_query.INFO_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.INFO_ID gt 0,de(' selected="selected"'),de(""))#</cfoutput>>Info</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-12 col-xs-12 hidetool" id="nocode"<cfoutput>#iif(isDefined("event_query")&& event_query.EVENT_TOOL eq "nocode",de(''),de(' style="display:none;"'))#</cfoutput>>
                <div class="portHeadLight font-green-sharp">NOCODE</div>
                <div class="col col-8 col-xs-12">
                    <div class="form-group" id="item-event_type">
                        <label class="col col-4 col-xs-12">Event Type *</label>
                        <div class="col col-8 col-xs-12 evnt">
                            <label class="mr-3">
                                <input type="checkbox" name="eventType" value="add:<cfoutput>#iif(isDefined("event_query")&& event_query.ADD_ID gt 0, "event_query.ADD_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.ADD_ID gt 0,de(' checked="checked"'),de(''))#</cfoutput>> Add
                            </label>
                            <label class="mr-3">
                                <input type="checkbox" name="eventType" value="upd:<cfoutput>#iif(isDefined("event_query")&&event_query.UPDATE_ID gt 0, "event_query.UPDATE_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.UPDATE_ID gt 0,de(' checked="checked"'),de(""))#</cfoutput>> Update
                            </label>
                            <label class="mr-3">
                                <input type="checkbox" name="eventType" value="list:<cfoutput>#iif(isDefined("event_query")&&event_query.LIST_ID gt 0, "event_query.LIST_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.LIST_ID gt 0,de(' checked="checked"'),de(""))#</cfoutput>> List
                            </label>
                            <label class="mr-3">
                                <input type="checkbox" name="eventType" value="dashboard:<cfoutput>#iif(isDefined("event_query")&&event_query.DASHBOARD_ID gt 0, "event_query.DASHBOARD_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.DASHBOARD_ID gt 0,de(' checked="checked"'),de(""))#</cfoutput>> Dashboard
                            </label>
                            <label class="mr-3">
                                <input type="checkbox" name="eventType" value="info:<cfoutput>#iif(isDefined("event_query")&&event_query.INFO_ID gt 0, "event_query.INFO_ID",de("0"))#</cfoutput>"<cfoutput>#iif(isDefined("event_query")&&event_query.INFO_ID gt 0,de(' checked="checked"'),de(""))#</cfoutput>> Info
                            </label>
                        </div>
                    </div>
                </div>
                <cfif isDefined("event_query")>
                    <div class="col col-4 col-xs-12">
                        <div class="form-group">
                            <div class="col col-12 text-right">
                                <cfif event_query.ADD_ID gt 0>
                                    <button type="button" class="dev-btn" onclick="goFormDetail('Event', '<cfoutput>#request.self#?fuseaction=dev.events&event=upd&fuseact=#event_query.EVENT_FUSEACTION#&event_type=add&version=#event_query.EVENT_VERSION#&id=#event_query.ADD_ID#&woid=#attributes.woid#</cfoutput>')">ADD DESIGNER</button>
                                </cfif>
                                <cfif event_query.UPDATE_ID gt 0>
                                    <button type="button" class="dev-btn" onclick="goFormDetail('Event', '<cfoutput>#request.self#?fuseaction=dev.events&event=upd&fuseact=#event_query.EVENT_FUSEACTION#&event_type=upd&version=#event_query.EVENT_VERSION#&id=#event_query.ADD_ID#&woid=#attributes.woid#</cfoutput>')">UPDATE DESIGNER</button>
                                </cfif>
                                <cfif event_query.LIST_ID gt 0>
                                    <button type="button" class="dev-btn" onclick="goFormDetail('Event', '<cfoutput>#request.self#?fuseaction=dev.events&event=upd&fuseact=#event_query.EVENT_FUSEACTION#&event_type=list&version=#event_query.EVENT_VERSION#&id=#event_query.ADD_ID#&woid=#attributes.woid#</cfoutput>')">LIST DESIGNER</button>
                                </cfif>
                                <cfif event_query.DASHBOARD_ID gt 0>
                                    <button type="button" class="dev-btn" onclick="goFormDetail('Event', '<cfoutput>#request.self#?fuseaction=dev.events&event=upd&fuseact=#event_query.EVENT_FUSEACTION#&event_type=dashboard&version=#event_query.EVENT_VERSION#&id=#event_query.ADD_ID#&woid=#attributes.woid#</cfoutput>')">DASHBOARD DESIGNER</button>
                                </cfif>
                                <button type="button" class="dev-btn" onclick="publish('<cfoutput>#event_query.EVENT_FUSEACTION#</cfoutput>', '<cfoutput>#iif( event_query.ADD_ID, de(event_query.ADD_ID), de(event_query.LIST_ID))#</cfoutput>')">PUBLISH</button>
                            </div>
                        </div>
                    </div>
                </cfif>
            </div>
        </div>
        <div class="row formContent">
            <div class="col col-12">
                <div class="form-group">
                    <div class="col col-12" id="editor_id">
                        <cfmodule template="/fckeditor/fckeditor.cfm"
                        toolbarset="Basic"
                        basepath="/fckeditor/"
                        instancename="description"
                        valign="top"
                        value="#iif( isDefined( "event_query" ), "event_query.EVENT_DESCRIPTION", de( "" ) )#"
                        width="100%"
                        height="180"> 
                    </div>
                </div>
            </div>
        </div>
        <div class="row formContentFooter">
            <div class="col col-12">
                <div class="col col-6">
                    <cfif isdefined("event_query")>
                        <cf_record_info 
                        query_name="event_query"
                        record_emp="record_emp" 
                        record_date="record_date"
                        update_emp="update_emp"
                        update_date="update_date">
                    </cfif> 
                </div> 
                <div class="col col-6 text-right">
                    <input type="submit" name="submit" value="SAVE">
                </div>
            </div>
        </div>
    </div>
</cfform>
</cf_box>