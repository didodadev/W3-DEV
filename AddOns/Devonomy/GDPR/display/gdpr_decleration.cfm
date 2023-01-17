
<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
       
        <cfset comp = createObject("component","AddOns.Devonomy.GDPR.cfc.gdpr_decleration")/>
        <cfset Data_Decleration_ = comp.Data_Decleration_()/>   
        <cfif isdefined("attributes.gdpr_decleration_id") and len(attributes.gdpr_decleration_id)>
            <cfset Get_Decleraion = comp.Get_Decleraion(gdpr_decleration_id:attributes.gdpr_decleration_id)/>   
        </cfif>
        <cfif isdefined("attributes.gdpr_decleration_id") and len(attributes.gdpr_decleration_id)>
            <cfset decleration_id =attributes.gdpr_decleration_id>
        <cfelseif isdefined("Data_Decleration_.gdpr_decleration_id")>
            <cfset decleration_id =Data_Decleration_.gdpr_decleration_id>
        <cfelse>
            <cfset decleration_id =null>
        </cfif>
        <cfif isdefined("Data_Decleration_.recordcount")>
            <cfset GET_APPROVE = comp.GET_APPROVE(gdpr_decleration_id:decleration_id)/> 
        </cfif>
        <cf_box title="#getLang('','Aydınlatma Metni','61743')#">
            <cfform method="post" name="add_cdpr_decleration">
            <cf_box_elements vertical="1">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <cfif isdefined("attributes.gdpr_decleration_id") and len(attributes.gdpr_decleration_id)>
                        <cf_duxi name="gdpr_decleration_id" type="hidden" value="#attributes.gdpr_decleration_id#">
                    <cfelseif isdefined("Data_Decleration_.gdpr_decleration_id")>
                        <cf_duxi name="gdpr_decleration_id" type="hidden" value="#Data_Decleration_.gdpr_decleration_id#">
                    </cfif>
                    <cfparam name="tr_topic" default="">
                    <div class="form-group" id="item-editor">
                        <cfif isdefined("attributes.gdpr_decleration_id") and len(attributes.gdpr_decleration_id)>
                            <label style="display:none!important;"><cf_get_lang dictionary_id='57771.Detay'></label>	
                                <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="Basic"
                                    basepath="/fckeditor/"
                                    instancename="GDPR_DECLERATION_TEXT"
                                    valign="top"
                                    value="#Get_Decleraion.GDPR_DECLERATION_TEXT#"
                                    width="600"
                                    height="180">
                            <cfelseif isdefined("Data_Decleration_.GDPR_DECLERATION_TEXT") and len(Data_Decleration_.GDPR_DECLERATION_TEXT)>
                           
                            <label style="display:none!important;"><cf_get_lang dictionary_id='57771.Detay'></label>	
                            <cfmodule
                                template="/fckeditor/fckeditor.cfm"
                                toolbarset="Basic"
                                basepath="/fckeditor/"
                                instancename="GDPR_DECLERATION_TEXT"
                                valign="top"
                                value="#Data_Decleration_.GDPR_DECLERATION_TEXT#"
                                width="600"
                                height="180">
                               
                            <cfelse>
                                <label style="display:none!important;"><cf_get_lang dictionary_id='57771.Detay'></label>	
                                    <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="Basic"
                                    basepath="/fckeditor/"
                                    instancename="GDPR_DECLERATION_TEXT"
                                    valign="top"
                                    value=""
                                    width="600"
                                    height="180">
                            </cfif>
                    </div>
                </div>
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
                    <cfif isdefined("attributes.gdpr_decleration_id") and len(attributes.gdpr_decleration_id)>
                        <cf_duxi name="author"  required="yes" type="text" id="author" label="58183" hint="yazan*" value="#Get_Decleraion.author#">
                    <cfelseif isdefined("Data_Decleration_.author") and len(Data_Decleration_.author)>
                        <cf_duxi name="author"  required="yes" type="text" id="author" label="58183" hint="yazan*" value="#Data_Decleration_.author#">
                    <cfelse>
                        <cf_duxi name="author"  required="yes" type="text" id="author" label="58183" hint="yazan*" data="">
                    </cfif>
                </div>
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="3" sort="true">
                    <cfif isdefined("attributes.gdpr_decleration_id") and len(attributes.gdpr_decleration_id)>
                        <cf_duxi name="decleration_date" type="text" id="decleration_date" data_control="date"   hint="yayın tarihi*" label="38512" required="yes" data="Get_Decleraion.DECLERATION_DATE" readonly="true">
                    <cfelseif isdefined("Data_Decleration_.decleration_date") and len(Data_Decleration_.decleration_date)>
                        <cf_duxi name="decleration_date" type="text" id="decleration_date" data_control="date"   hint="yayın tarihi*" label="38512" required="yes" data="Data_Decleration_.DECLERATION_DATE" readonly="true">
                    <cfelse>
                        <cf_duxi name="decleration_date" type="text" data_control="date" data="" hint="yayın tarihi*" label="38512" required="yes"> 
                    </cfif>
                </div>
                <cfif isdefined("Data_Decleration_.recordcount")>
                   
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="4" sort="true">
                            <div class="form-group" id="item-approve_people">
                                <div class="col col-7 col-xs-12"><cf_get_lang dictionary_id='30976.Formu'><cf_get_lang dictionary_id='33302.onaylayan'><cf_get_lang dictionary_id='53770.Kişi Sayısı'></div>
                                <div class="col col-5 col-xs-12">
                                    <cfoutput>#GET_APPROVE.recordcount#</cfoutput>
                                </div>
                            </div>
                        </div>
                    
                </cfif>
            </cf_box_elements>

           
                <cf_box_footer>
                    <cfif isdefined("Data_Decleration_.gdpr_decleration_id")>
                        <div class="col col-6 col-xs-12">
                            <cfoutput>
                                <cf_record_info query_name="Data_Decleration_" record_emp="RECORD_EMP" udate_emp="UPDATE_EMP">
                            </cfoutput>
                        </div>
                        <cfif  GET_APPROVE.recordcount>
                            <cf_workcube_buttons is_upd='1' is_insert='0'  is_delete="0">
                        <cfelse>
                        <div class="col col-6 col-xs-12">
                            <cf_workcube_buttons is_upd='1' is_delete="0"
                            data_action ="/AddOns/Devonomy/GDPR/cfc/gdpr_decleration:ADD_GDPR_DECLERATION"
                            next_page="#request.self#?fuseaction=#attributes.fuseaction#&event=upd&gdpr_decleration_id="
                            add_function="gdpr()"
                            >
                        </div>
                    </cfif>
                    <cfelse>
                        <cf_workcube_buttons
                        data_action ="/AddOns/Devonomy/GDPR/cfc/gdpr_decleration:ADD_GDPR_DECLERATION"
                        next_page="#request.self#?fuseaction=#attributes.fuseaction#&event=upd&gdpr_decleration_id="
                        add_function="gdpr()"
                        >
                    </cfif>
                </cf_box_footer>
           
        </cfform>
        </cf_box>
    </div>
    <script>
 
        $(function() {
             
            
            // attr() method applied here
            $('#gdpr_update').prop('disabled', true);
        });
       
        function gdpr()
        {
            // data.append('CKEDITOR_'+CKEDITOR.instances['GDPR_DECLERATION_TEXT'].name,CKEDITOR.instances[CKEDITOR.instances['GDPR_DECLERATION_TEXT'].name].getData());
            document.getElementById('GDPR_DECLERATION_TEXT').value = CKEDITOR.instances.GDPR_DECLERATION_TEXT.getData();
          
        }
        </script>