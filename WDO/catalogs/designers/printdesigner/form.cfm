<cfparam name="attributes.id" default="">

<cfinclude template="model.cfm">

<link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">

<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfset getSolution = list_wbo.getSolution()>

<cfif len(attributes.id)>
<cfset print_query = getPrint(attributes.id)>
</cfif>

<cfform name="AddFuseactionForm" method="post" type="formControl">

    <cfif isDefined( "attributes.fuseact" )>
        <input type="hidden" name="formsubmitted" id="formsubmitted" value="1">
        <input type="hidden" name="fuseact" value="<cfoutput>#attributes.fuseact#</cfoutput>">
        <input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>">
    </cfif>

    <div class="col col-12 mt-3">
        <div class="portBox portBottom mb-3 animated fadeInUp faster">
            <div class="portHeadLight font-green-sharp">
                <span>Print</span>
            </div>
            <div class="portBoxBodyStandart">
                <div class="col col-12 uniqueRow">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-4 col-xs-12" type="column" index="" sort="true">
                                <div class="form-group" id="item-head">
                                    <label class="col col-4 col-xs-12">Head *</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                        <cfoutput>
                                            <input type="text" name="print_head" id="print_head" value="#iif(isDefined("print_query"),"print_query.PRINT_HEAD",de(""))#" message="Head alanını sözlükten seçiniz" required>
                                            <input type="hidden" name="dictionaryid" id="dictionaryid">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=settings.popup_list_lang_settings&module_name=dev&is_use_send&lang_dictionary_id=AddFuseactionForm.dictionaryid&lang_item_name=AddFuseactionForm.print_head', 'list'); return false;"></span>
                                        </cfoutput>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-solution">
                                    <label class="col col-4 col-xs-12">Solution *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfoutput>
                                            <input type="hidden" name="solution" id="solution" value="#iif(isDefined("print_query"),"print_query.PRINT_SOLUTION",de(""))#">
                                            <select id="solutionid" name="solutionid" onchange="loadFamilies(this.value,'familyid','moduleid')" message="Solution seçiniz" required #iif(isDefined("print_query"),de('disabled="disabled"'),de(""))#>
                                        </cfoutput>
                                                <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                            <cfoutput query="getSolution">
                                                <option value="#WRK_SOLUTION_ID#"#iif(isDefined("print_query") and WRK_SOLUTION_ID eq print_query.PRINT_SOLUTIONID,de(' selected="selected"'),de(""))#>#NAME#</option>
                                            </cfoutput>
                                            </select>
                                            <cfif isDefined("print_query")><cfinput type="hidden" name="solutionid" value="#print_query.PRINT_SOLUTIONID#"></cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-xs-12" type="column" index="" sort="true">
                                <div class="form-group" id="item-related_wo">
                                    <label class="col col-4 col-xs-12">Related WO *</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfoutput>
                                                <input type="text" name="related_wo" id="related_wo" value="#iif(isDefined("print_query"),"print_query.PRINT_FUSEACTION",de(""))#" required <cfoutput>#iif(isDefined("print_query"),de('disabled="disabled"'),de(""))#</cfoutput>>
                                                <cfif not isDefined("print_query")>
                                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=AddFuseactionForm.related_wo&is_upd=0&choice=1','list');return false;"></span>
                                                <cfelse>
                                                    <span class="input-group-addon icon-ellipsis btnPointer"></span>
                                                </cfif>
                                                <cfif isDefined("print_query")><cfinput type="hidden" name="related_wo" value="#print_query.PRINT_FUSEACTION#"></cfif>
                                            </cfoutput>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-family">
                                    <cfoutput>
                                    <label class="col col-4 col-xs-12">Family *</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="hidden" name="family" id="family" value="#iif(isDefined("print_query"), "print_query.PRINT_FAMILY", de(""))#">
                                        <select id="familyid" name="familyid" onchange="loadModules(this.value, 'moduleid')" message="Family seçiniz" required #iif(isdefined("print_query"),de('disabled="disabled"'),de(""))#>
                                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                        </select>
                                        <cfif isDefined("print_query")><cfinput type="hidden" name="familyid" value="#print_query.PRINT_FAMILYID#"></cfif>
                                    </div>
                                    </cfoutput>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="" sort="true">
                                <div class="form-group" id="item-">
                                    <label class="col col-4 col-xs-12">&nbsp;</label>
                                    <div class="col col-8 col-xs-12">
                                        &nbsp;
                                    </div>
                                </div>
                                <div class="form-group" id="item-module">
                                    <cfoutput>
                                    <label class="col col-4 col-xs-12">Module *</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="hidden" name="module" id="module" value="#iif(isDefined("print_query"), "print_query.PRINT_MODULE", de(""))#">
                                        <select id="moduleid" name="moduleid" message="Module seçiniz" required #iif(isDefined("print_query"),de('disabled="disabled"'),de(""))#>
                                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                        </select>
                                        <cfif isDefined("print_query")><cfinput type="hidden" name="moduleid" value="#print_query.PRINT_MODULEID#"></cfif>
                                    </div>
                                    </cfoutput>
                                </div>
                            </div>
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
                                    value="#iif( isDefined( "print_query" ), "print_query.PRINT_DESCRIPTION", de( "" ) )#"
                                    width="100%"
                                    height="180"> 
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row formContentFooter">
                        <div class="col col-12">
                            <div class="col col-6">
                                <cfif isdefined("print_query")>
                                    <cf_record_info 
                                    query_name="print_query"
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
            </div>
        </div>
    </div>

</cfform>
<cfinclude template="formengine.cfm">