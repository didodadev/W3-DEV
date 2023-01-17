<cfquery name="GET_EVENT" datasource="#DSN#">
	SELECT 
		*
	FROM 
		EVENT
	WHERE 
		EVENT.EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<cfset is_control = 0>
<cfset ProjectCmp =createObject("component", "V16/project/cfc/projectData")>
<cfset get_project = ProjectCmp.get_projects()>
<cfinclude template="../../agenda/query/get_event_cats.cfm">
<cfif isdefined("session.pp")>
    <cfif get_event.record_par eq session_base.userid><cfset is_control = 1></cfif>
<cfelseif isdefined("session.ep")>
    <cfif get_event.record_emp eq session_base.userid><cfset is_control = 1></cfif>
</cfif>
<cfform enctype="multipart/form-data" method="post" name="eventForm" id="eventForm">
    <div class="ui-scroll">    
        <cfoutput query="get_event">
            <cfinput type="hidden" name="event_id" id="event_id" value="#event_id#">
            <cfinput type="hidden" name="is_control" id="is_control" value="#is_control#">
            <div class="row mb-2">
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="bd-highlight flex-wrap">
                        <div class="pr-2 pb-2 flex-grow-1 bd-highlight font-weight-bold"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></div>
                        <div class="row pr-4 pb-2 bd-highlight"> 
                            <div class="col-4 ">
                                <input type="date" id="startdate" name="startdate"  required="Yes" class="form-control" value="#dateformat(startdate,"yyyy-MM-dd")#">
                            </div>
                            <div class="col-4 ">
                                <select name="event_start_hour" id="event_start_hour" class="form-control">
                                    <cfloop from="0" to="23" index="a" step="1">
                                        <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(finishdate,"MM") eq a >selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                            <div class="col-4">
                                <select name="event_start_minute" id="event_start_minute" class="form-control">
                                    <cfloop from="0" to="55" index="a" step="5">
                                        <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(startdate,"MM") eq a >selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>               
                </div> 
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="bd-highlight flex-wrap">
                        <div class="pr-2 pb-2 flex-grow-1 bd-highlight font-weight-bold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></div>
                        <div class="row pr-4 pb-2 bd-highlight"> 
                            <div class="col-4 ">
                                <input type="date" id="finishdate" name="finishdate"  required="Yes" class="form-control" value="#dateformat(finishdate,'yyyy-MM-dd')#">
                            </div>
                            <div class="col-4 ">
                                <select name="event_finish_hour" id="event_finish_hour" class="form-control">
                                    <cfloop from="0" to="23" index="a" step="1">
                                        <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(finishdate,"MM") eq a >selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                            <div class="col-4">
                                <select name="event_finish_minute" id="event_finish_minute" class="form-control">
                                    <cfloop from="0" to="55" index="a" step="5">
                                        <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(finishdate,"MM") eq a >selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>               
                </div> 
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="bd-highlight flex-wrap">
                        <div class="pr-2 pb-2 flex-grow-1 bd-highlight font-weight-bold"><cf_get_lang dictionary_id='57480.Konu'></div>
                        <div class="pr-4 pb-2 bd-highlight"> <input type="text" class="form-control" name="event_head" id="event_head" value="#event_head#"></div>
                    </div>               
                </div>

                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="bd-highlight flex-wrap">
                        <div class="pr-2 pb-2 flex-grow-1 bd-highlight font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'></div>
                        <div class="pr-4 pb-2 bd-highlight">
                            <select name="eventcat_id" id="eventcat_id" class="form-control">
                                <option value="0" selected><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_event_cats">
                                    <option value="#eventcat_ID#" <cfif get_event_cats.eventcat_id eq eventcat_id>selected</cfif>>#eventcat#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>               
                </div>
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="bd-highlight flex-wrap">
                        <div class="pr-2 pb-2 flex-grow-1 bd-highlight font-weight-bold"><cf_get_lang dictionary_id='57416.Proje'></div>
                        <div class="pr-4 pb-2 bd-highlight">
                            <select class="form-control" id="project_id" name="project_id"  required="Yes">
                                <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop query="get_project">
                                    <option value="#project_id#" <cfif get_project.project_id eq project_id>selected</cfif>>#project_head#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>               
                </div>
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="bd-highlight flex-wrap">
                        <div class="pr-2 pb-2 flex-grow-1 bd-highlight font-weight-bold"><cf_get_lang dictionary_id='55956.Yer'></div>
                        <div class="pr-4 pb-2 bd-highlight">
                            <select name="event_place" id="event_place" class="form-control">
                                <option value="" selected><cf_get_lang_main no ='322.Seçiniz'></option>
                                <option value="1" <cfif event_place_id eq 1> selected </cfif> ><cf_get_lang dictionary_id='48000.Ofis içi'></option>
                                <option value="2" <cfif event_place_id eq 2> selected </cfif>><cf_get_lang dictionary_id='47580.Ofis Dışı'></option>
                                <option value="3" <cfif event_place_id eq 3> selected </cfif>><cf_get_lang dictionary_id='47582.Müşteri Ofisi'></option>
                                <option value="4" <cfif event_place_id eq 4> selected </cfif>><cf_get_lang dictionary_id='30015.Online'></option>
                            </select>
                        </div>
                    </div>               
                </div>
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="bd-highlight flex-wrap">
                        <div class="pr-2 pb-2 flex-grow-1 bd-highlight font-weight-bold"><cf_get_lang dictionary_id='30015.Online'></div>
                        <div class="pr-4 pb-2 bd-highlight">
                            <input type="text" class="form-control" name="online" id="online" value="#ONLINE_MEET_LINK#">
                        </div>
                    </div>               
                </div>
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="bd-highlight flex-wrap">
                        <div class="pr-2 pb-2 flex-grow-1 bd-highlight font-weight-bold"><cf_get_lang dictionary_id='36199.Açıklama'></div>
                        <div class="pr-4 pb-2 bd-highlight"><textarea class="form-control" name="event_detail" id="event_detail" style="height:80px;" class="form-control">#event_detail#</textarea></div>
                    </div>               
                </div>
                
            </div> 
            <div class="row">
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <cfset database_type="MSSQL">
                    <cf_workcube_to_cc 
                        is_update="1" 
                        to_dsp_name="#getLang('','',57590)#" 
                        str_list_param="8,7,1" 
                        action_dsn="#DSN#"
                        str_action_names="EVENT_TO_POS AS TO_EMP,EVENT_TO_PAR AS TO_PAR,EVENT_TO_CON TO_CON,EVENT_TO_GRP AS TO_GRP,EVENT_TO_WRKGROUP AS TO_WRKGROUP ,EVENT_CC_POS AS CC_EMP,EVENT_CC_PAR AS CC_PAR,EVENT_CC_CON AS CC_CON,EVENT_CC_GRP AS CC_GRP,EVENT_CC_WRKGROUP AS CC_WRKGROUP"
                        action_table="EVENT"
                        action_id_name="EVENT_ID"
                        action_id="#attributes.EVENT_ID#"
                        data_type="1"
                        is_detail="1"
                        str_alias_names="">
                </div>
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    <cf_workcube_to_cc 
                    is_update="1" 
                    cc_dsp_name="#getLang('','',58773)#" 
                    form_name="upd_event" 
                    str_list_param="1,7,8" 
                    action_dsn="#DSN#"
                    str_action_names="EVENT_TO_POS AS TO_EMP,EVENT_TO_PAR AS TO_PAR,EVENT_TO_CON TO_CON,EVENT_TO_GRP AS TO_GRP,EVENT_TO_WRKGROUP AS TO_WRKGROUP ,EVENT_CC_POS AS CC_EMP,EVENT_CC_PAR AS CC_PAR,EVENT_CC_CON AS CC_CON,EVENT_CC_GRP AS CC_GRP,EVENT_CC_WRKGROUP AS CC_WRKGROUP"
                    action_table="EVENT"
                    action_id_name="EVENT_ID"
                    action_id="#attributes.EVENT_ID#"
                    data_type="1"
                    is_detail="1"
                    str_alias_names="">
                </div>
            </div>   
        </cfoutput>
    </div>
    <cfif is_control eq 1>
        <div class="draggable-footer">
            <cf_workcube_buttons is_upd="1" data_action="V16/objects2/protein/data/event_data:UPD_EVENT" next_page="javascript:closeBoxDraggable(#attributes.modal_id#)" is_delete="0">
        </div>
    </cfif>
</cfform>

