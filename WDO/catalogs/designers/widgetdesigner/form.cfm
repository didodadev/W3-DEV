
<cfparam name="attributes.id" default="">

<link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">

<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfset getSolution = list_wbo.getSolution()>

<cfif len(attributes.id)><cfset widget_query = loadform(attributes.id)></cfif>

<cfif not isdefined("attributes.selfwo")><cf_catalystHeader></cfif>

<cf_box id="wWidget">
    <cfform name="AddFuseactionForm" method="post" type="formControl">
        <cfif isDefined("attributes.fuseact")><input type="hidden" name="fuseact" value="<cfoutput>#attributes.fuseact#</cfoutput>"></cfif>
        <input type="hidden" name="widgetid" value="<cfif isdefined("widget_query")><cfoutput>#widget_query.WIDGETID#</cfoutput></cfif>">
        <cf_box_elements>
            <div class="col col-4 col-xs-12">
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Head *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfoutput>
                                <input type="text" name="title" id="title" value="#iif( isDefined( "widget_query" ), "widget_query.WIDGET_TITLE", de( "" ) )#" message="Head alanını sözlükten seçiniz" required>
                                <input type="hidden" name="dictionary_id"  id="dictionary_id" value="#iif( isDefined( "widget_query" ), "widget_query.WIDGET_TITLE_DICTIONARY_ID", de( "" ) )#">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_list_lang_settings&is_use_send&lang_dictionary_id=AddFuseactionForm.dictionary_id&lang_item_name=AddFuseactionForm.title');return false"></span>
                            </cfoutput>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Friendly Name *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="friendlyName" id="friendlyName" value="#iif( isDefined( "widget_query" ), "widget_query.WIDGET_FRIENDLY_NAME", de( "" ) )#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Solution *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="hidden" name="solution" id="solution" value="#iif( isDefined( "widget_query" ), "widget_query.WIDGETSOLUTION", de( "" ) )#"></cfoutput>
                        <select id="solutionid" name="solutionid" onchange="loadFamilies(this.value,'familyid','moduleno')" message="Solution seçiniz" required >
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <cfoutput query="getSolution">
                                <option value="#WRK_SOLUTION_ID#"#iif( isDefined("widget_query") and WRK_SOLUTION_ID eq widget_query.WIDGETSOLUTIONID, de( 'selected="selected"' ), de( "" ) )#>#NAME#</option>
                            </cfoutput>
                        </select>
                        <cfif isDefined("widget_query")><cfinput type="hidden" name="solutionid" value="#widget_query.WIDGETSOLUTIONID#"></cfif>
                    </div>
                </div>
                <div class="form-group">
                    <input type="hidden" name="family" id="family">
                    <label class="col col-4 col-xs-12">Family *</label>
                    <div class="col col-8 col-xs-12">
                        <select id="familyid" name="familyid" onchange="loadModules(this.value,'moduleno')" message="Family seçiniz" required >
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                        </select>
                        <cfif isDefined("widget_query")><cfinput type="hidden" name="familyid" value="#widget_query.WIDGETFAMILYID#"></cfif>
                    </div>
                </div>
                <div class="form-group">
                    <input type="hidden" name="module" id="module">
                    <label class="col col-4 col-xs-12">Module *</label>
                    <div class="col col-8 col-xs-12">
                        <select id="moduleno" name="moduleno" message="Module seçiniz" required >
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                        </select>
                        <!--- Databasete önceki sistemden kaynaklı olarak MODULEID var iken MODULENO NULL olma ihtimali var, 2 değerde aynı eklenildiği için ID alıyoruz --->
                        <cfif isDefined("widget_query")><cfinput type="hidden" name="moduleno" value="#widget_query.WIDGETMODULEID#"></cfif>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Yayın Alanı *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput>
                            <div class="col col-4 col-xs-12">
                                <label><input type="checkbox" id="is_public" name="is_public" <cfif isdefined('widget_query.is_public') and widget_query.is_public eq 1>checked</cfif>>Public</label>
                                <label><input type="checkbox" id="is_employee" name="is_employee" <cfif isdefined('widget_query.is_employee') and widget_query.is_employee eq 1>checked</cfif>>Employee</label>
                                <label><input type="checkbox" id="is_employee_app" name="is_employee_app" <cfif isdefined('widget_query.is_employee_app') and widget_query.is_employee_app eq 1>checked</cfif>>Career</label>
                            </div>
                            <div class="col col-4 col-xs-12">
                                <label><input type="checkbox" id="is_company" name="is_company" <cfif isdefined('widget_query.is_company') and widget_query.is_company eq 1>checked</cfif>>Company</label>
                                <label><input type="checkbox" id="is_consumer" name="is_consumer" <cfif isdefined('widget_query.is_consumer') and widget_query.is_consumer eq 1>checked</cfif>>Consumer</label>
                            </div>
                            <div class="col col-4 col-xs-12">
                                <label><input type="checkbox" id="is_machines" name="is_machines" <cfif isdefined('widget_query.is_machines') and widget_query.is_machines eq 1>checked</cfif>>Machines </label>
                                <label><input type="checkbox" id="is_livestock" name="is_livestock" <cfif isdefined('widget_query.is_livestock') and widget_query.is_livestock eq 1>checked</cfif>>LiveStock</label>
                            </div>
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Related WO *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfoutput>
                                <input type="text" name="related_wo" id="related_wo" value="#iif( isDefined( "widget_query" ), "widget_query.WIDGET_FUSEACTION", de( "" ) )#" message="İlişkili WO' yu seçiniz" required >
                                <cfif not isdefined("widget_query")>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=AddFuseactionForm.related_wo&is_upd=1&draggable=1&choice=1&only_choice=1');return false;"></span>
                                <cfelse>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=AddFuseactionForm.related_wo&is_upd=1&only_choice=1&draggable=1&choice=1');return false;"></span>
                                </cfif>
                                <!--- <cfif isDefined("widget_query")><cfinput type="hidden" name="related_wo" value="#widget_query.WIDGET_FUSEACTION#"></cfif> --->
                            </cfoutput>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12">License *</label>
                    <div class="col col-8 col-xs-12">
                    <cfoutput>
                        <select id="license" name="license" message="Lisans tipini seçiniz" required>
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <option value="1"#iif( isDefined( "widget_query" ) and widget_query.WIDGET_LICENSE eq "1", de( ' selected="selected"' ), de( "" ) )#>Standart</option>
                            <option value="2"#iif( isDefined( "widget_query" ) and widget_query.WIDGET_LICENSE eq "2", de( ' selected="selected"' ), de( "" ) )#>Add-On</option>
                        </select>
                    </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57630.Type'> *</label>
                    <div class="col col-8 col-xs-12">
                            <cf_devtool name="tool" onchange="loadTool(this.value)" message="Tool tipini seçiniz" required="1" selected="#iif( isDefined( "widget_query" ), "widget_query.WIDGET_TOOL", de( "" ) )#" value="#iif( isDefined( "widget_query" ), "widget_query.WIDGET_TOOL", de( "" ) )#" disabled="#isDefined("widget_query")#">
                            <cfif isDefined("widget_query")><cfinput type="hidden" name="tool" value="#widget_query.WIDGET_TOOL#"></cfif>
                    </div>
                </div>
                <div class="form-group" id="codebox">
                    <label class="col col-4 col-xs-12">File Path</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput>
                            <cfif isDefined("widget_query") and len(widget_query.WIDGET_FILE_PATH)>
                                <div class="input-group">
                                    <input type="text" name="file_path" id="file_path" value="#widget_query.WIDGET_FILE_PATH#">
                                    <a href="https://bitbucket.org/workcube/devcatalyst/src/master/#widget_query.WIDGET_FILE_PATH#" target="_blank" class="input-group-addon"><i class="fa fa-bitbucket"></i></a>
                                </div>
                            <cfelse>
                                <input type="text" name="file_path" id="file_path" value="">
                            </cfif>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group" id="codebox">
                    <label class="col col-4 col-xs-12">XML Path</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput>
                            <cfif isDefined("widget_query") and len(widget_query.xml_path)>
                                <div class="input-group">
                                    <input type="text" name="xml_path" id="xml_path" value="<cfif isDefined("widget_query") and len(widget_query.xml_path)>#widget_query.xml_path#</cfif>">
                                    <a href="https://bitbucket.org/workcube/devcatalyst/src/master/#widget_query.xml_path#" target="_blank" class="input-group-addon"><i class="fa fa-bitbucket"></i></a>
                                </div>
                            <cfelse>
                                <input type="text" name="xml_path" id="xml_path" value="">
                            </cfif>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Event Type *</label>
                    <div class="col col-8 col-xs-12">
                        <select name="eventType">
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <option value="add" <cfif isdefined("widget_query") and widget_query.WIDGET_EVENT_TYPE eq 'add'> selected</cfif>>Add</option>
                            <option value="upd" <cfif isdefined("widget_query") and (widget_query.WIDGET_EVENT_TYPE eq 'upd' or widget_query.WIDGET_EVENT_TYPE eq 'update') > selected</cfif>>Upd</option>
                            <option value="list" <cfif isdefined("widget_query") and widget_query.WIDGET_EVENT_TYPE eq 'list'> selected</cfif>>List</option>
                            <option value="dashboard" <cfif isdefined("widget_query") and widget_query.WIDGET_EVENT_TYPE eq 'dashboard'> selected</cfif>>Dashboard</option>
                            <option value="info" <cfif isdefined("widget_query") and widget_query.WIDGET_EVENT_TYPE eq 'info'> selected</cfif>>Info</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">
                <div class="form-group">
                    <label class="col col-4 col-xs-12" message="Versiyon adını giriniz"> Version*Main-Widget</label>
                    <cfoutput>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="text" name="main_version" id="main_version" value="#iif( isDefined( "widget_query" ), "widget_query.MAIN_VERSION", de( "" ) )#" required>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="text" name="version" id="version" value="#iif( isDefined( "widget_query" ), "widget_query.WIDGET_VERSION", de( "" ) )#" required>
                        </div>
                    </cfoutput>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Statu *</label>
                    <div class="col col-8 col-xs-12">
                    <cfoutput>
                        <select name="status" id="status" message="Statü seçiniz" required>
                            <option value="Analys"#iif( isDefined( "widget_query" ) and widget_query.WIDGET_STATUS eq "Analys", de( ' selected="selected"' ), de( "" ) )#>Analys</option>
                            <option value="Deployment"#iif( isDefined( "widget_query" ) and widget_query.WIDGET_STATUS eq "Deployment", de( ' selected="selected"' ), de( "" ) )#>Deployment</option>
                            <option value="Design"#iif( isDefined( "widget_query" ) and widget_query.WIDGET_STATUS eq "Design", de( ' selected="selected"' ), de( "" ) )#>Design</option>
                            <option value="Development"#iif( isDefined( "widget_query" ) and widget_query.WIDGET_STATUS eq "Development", de( ' selected="selected"' ), de( "" ) )#>Development</option>
                            <option value="Testing"#iif( isDefined( "widget_query" ) and widget_query.WIDGET_STATUS eq "Testing", de( ' selected="selected"' ), de( "" ) )#>Testing</option>
                            <option value="Cancel"#iif( isDefined( "widget_query" ) and widget_query.WIDGET_STATUS eq "Cancel", de( ' selected="selected"' ), de( "" ) )#>Cancel</option>
                        </select>
                    </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Stage *</label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='1' fusepath="dev.workdev" select_value='#iif( isDefined( "widget_query" ), "widget_query.WIDGET_STAGE", de( "0" ) )#'>
                    </div>
                </div>
                <cfoutput>
                <div class="form-group">
                    <label class="col col-4 col-xs-12" message="Author adını giriniz">Author *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="author" id="author" value="#iif( isDefined( "widget_query" ), "widget_query.WIDGET_AUTHOR", de( "" ) )#" required></cfoutput>
                    </div>
                </div>
                </cfoutput>
                <!--- <div class="form-group">
                    <label class="col col-12 col-xs-12"><input type="checkbox" id="is_template_widget" name="is_template_widget" <cfif isdefined("widget_query.is_template_widget") and widget_query.is_template_widget eq 1>checked</cfif>>Template Nesnesi</label>
                </div> --->
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Widget Type *</label>
                    <div class="col col-8 col-xs-12">
                        <select name="widget_type" required>
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <option value="1" <cfif isdefined("widget_query.widget_type") and widget_query.WIDGET_TYPE eq 1> selected</cfif>>Design</option>
                            <option value="2" <cfif isdefined("widget_query.widget_type") and widget_query.WIDGET_TYPE eq 2> selected</cfif>>Configurator</option>
                            <option value="2" <cfif isdefined("widget_query.widget_type") and widget_query.WIDGET_TYPE eq 3> selected</cfif>>General</option>
                            <option value="4" <cfif isdefined("widget_query.widget_type") and widget_query.WIDGET_TYPE eq 4> selected</cfif>> WO Inside</option>
                            <option value="5" <cfif isdefined("widget_query.widget_type") and widget_query.WIDGET_TYPE eq 5> selected</cfif>>Micro Service</option>
                        </select>
                    </div>
                </div>
                <div id="nocode"<cfoutput>#iif(isDefined("widget_query")&&widget_query.WIDGET_TOOL eq "nocode",de(''),de(' style="display:none;"'))#</cfoutput>>
                    <cfif isDefined("widget_query")>
                        <div class="form-group">
                            <button type="button" class="ui-wrk-btn ui-wrk-btn-extra" onclick="goFormDetail('Form', '<cfoutput>#request.self#?fuseaction=dev.widget&event=upd&fuseact=#widget_query.WIDGET_FUSEACTION#&event_type=#widget_query.WIDGET_EVENT_TYPE#&version=#widget_query.WIDGET_VERSION#&id=#widget_query.WIDGETID#&woid=#attributes.woid#</cfoutput>#widget')">DESIGNER</button> 
                        </div>
                    </cfif>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_elements vertical="1">
            <cf_seperator title="Detail" id="event_sep">
            <div class="col col-12 col-xs-12" id="event_sep">
                <div class="form-group">
                    <div class="col col-12 padding-0" id="editor_id">
                        <cfmodule template="/fckeditor/fckeditor.cfm"
                        toolbarset="Basic"
                        basepath="/fckeditor/"
                        instancename="description"
                        valign="top"
                        value="#iif( isDefined( "widget_query" ), "widget_query.WIDGET_DESCRIPTION", de( "" ) )#"
                        width="100%"
                        height="180"> 
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cfif isdefined("widget_query")>
                <cf_record_info 
                query_name="widget_query"
                record_emp="record_emp" 
                record_date="record_date"
                update_emp="update_emp"
                update_date="update_date">
                <cf_workcube_buttons is_upd='1' is_delete='0'>
            <cfelse>
                <cf_workcube_buttons is_upd='0'>
            </cfif> 
        </cf_box_footer>
    </cfform>
</cf_box>