<!---
    File:AddOns\Devonomy\GDPR\display\gdpr_approve.cfm
    Date: 2022-01-06
    Description:Gdpr Aydınlatma Metni onaylama Sayfasıdır
--->
<cfparam  name="modal_id" default="">
<cfparam  name="attributes.action_type" default="DATA_OFFICER_ID">
<cfparam  name="attributes.action_type_id" default="">
<cfset comp = createObject("component","AddOns.Devonomy.GDPR.cfc.gdpr_decleration")/>
<cfset Data_Decleration = comp.Data_Decleration()/> 
<cfset data_officer = comp.data_officer()/> 
<cfif data_officer.recordcount>
    <cfset get_content = comp.GetContent(ACTION_TYPE: attributes.action_type)/> 
    <cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>
    
</cfif>

<cfif Data_Decleration.recordcount>
    <cfset MAX_DECLERATION = comp.MAX_DECLERATION()/>
    <cfset Data_Decleration_ = comp.Data_Decleration_()/>
    <cfif isdefined ("attributes.version_id") and len(attributes.version_id)> 
    <cfset GET_GDPR = comp.GET_GDPR(employee_id: attributes.employee_id,GDPR_DECLERATION_ID:attributes.version_id)/>
    <cfset version_id= attributes.version_id>
    </cfif>

    <cfif isdefined("attributes.welcome") and attributes.welcome is  1 >
        <cfset emp_id= attributes.employee_id>
        <cfelse>
            <cfset emp_id=session.ep.userid>
        </cfif>
    <cfset list_approve = comp.list_approve(employee_id: emp_id,GDPR_DECLERATION_ID:MAX_DECLERATION.max)/>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
       
        <cf_box title="#getLang('','Kişisel Veri Aydınlatma Metni','64696')#" popup_box="1">
            <cfform method="post" name="gdpr_approve" action="#request.self#?fuseaction=gdpr.approve">
                <cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="1" style="padding-left:15px;padding-right:15px;" type="column" sort="true">
                        <div class="font-lg font-red-intense" style="font-size: 25px;">
                            <i class="fa fa-user-circle-o"></i>
                            <cf_get_lang dictionary_id='61745.GDPReady'>
                        </div>
                        <hr class="margin-bottom-20" style="border-color: #ffffff5c;">
                        <cfif data_officer.recordcount>
                            <cfloop query="get_content">
                                <cfset	gdpr_data = comp.get_data_officer()>
                                <cfset GET_EMPS = comp.GET_EMPS(WORKGROUP_ID : get_content.ACTION_TYPE_ID)>
                                <cfset get_committee= comp.get_committee(data_officer_id:gdpr_data.data_officer_id)>
                                <cfoutput>
                                <cf_seperator header="#CONT_HEAD#" id="#content_id#_" is_closed="1" >
                                    <div id="#content_id#_" style="padding-left:15px;padding-right:15px;" >
                                        #get_content.cont_body#
                                    </div>
                                </cfoutput>
                                <hr class="margin-bottom-20 margin-top-20" style=" border-color: #ffffff5c; ">
                            </cfloop>
                            <cfif get_content.recordcount>
                                <cf_seperator header="#getLang('','Veri Sorumlusu','61749')# - #getLang('','Kurul','31744')#" id="basic_officer">
                                <div class="form-group" style="padding-left:15px;padding-right:15px;margin: 5px 0px 5px 0;" id="basic_officer">
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12" >
                                        <cfoutput query="gdpr_data">
                                            <div class="form-group ui-list-text bold"> 
                                                #DATA_OFFICER_NAME#
                                            </div>
                                        </cfoutput>
                                    </div>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" >
                                        <div style="padding-left:15px;padding-right:15px;margin: 5px 0px 5px 0;" id="officer" class="ui-list-text">
                                            <cfoutput query="get_committee">
                                                <cfif len(EMPLOYEE_ID)>
                                                    <div class="form-group ui-list-text">        
                                                        #get_emp_info(EMPLOYEE_ID,0,0)#
                                                    </div>
                                                <cfelseif len(CONSUMER_ID)>
                                                    <div class=" form-group  ui-list-text">                            
                                                        <span class="name">#get_cons_info(CONSUMER_ID,1,0)#</span>
                                                    </div>
                                                <cfelseif len(PARTNER_ID)>
                                                    <div class=" form-group ui-list-text">      
                                                       <span class="name">#get_cons_info(PARTNER_ID,1,0)#</span>
                                                    </div>
                                                </cfif>
                                            </cfoutput>
                                        </div>
                                    </div>
                                </div>
                                <hr class="margin-bottom-20 margin-top-20" style=" border-color: #ffffff5c; ">
                            </cfif>
                        </cfif>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="2" style="padding-left:15px;padding-right:15px;" type="column" sort="true">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
                            <div class="form-group" id="item-gdpr_decleration_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33675.versiyon no'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined ("attributes.version_id") and len(attributes.version_id)> 
                                        <cfoutput>#GET_GDPR.GDPR_DECLERATION_ID#</cfoutput>
                                    <cfelse>
                                        <cfoutput>#Data_Decleration_.GDPR_DECLERATION_ID#</cfoutput>
                                    </cfif>
                                
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" style="padding-left:15px;padding-right:15px;" type="column" sort="true">
                            <div class="form-group" id="item-DECLERATION_DATE">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50647.Versiyon Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined ("attributes.version_id") and len(attributes.version_id)> 
                                        <cfoutput> #dateformat(GET_GDPR.DECLERATION_DATE,dateformat_style)#</cfoutput>
                                    <cfelse>
                                        <cfoutput>#dateformat(Data_Decleration_.DECLERATION_DATE,dateformat_style)#</cfoutput>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="3" type="column" sort="true">
                            <cfif isdefined ("attributes.version_id") and len(attributes.version_id)>
                                <div class="form-group" id="item-DECLERATION_DATE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33302.onaylayan'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfoutput>#get_emp_info(GET_GDPR.APPROVE_EMP_ID,0,0)#</cfoutput>
                                    </div>
                                </div>
                            <cfelseif list_approve.recordcount>
                                <div class="form-group" id="item-DECLERATION_DATE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33302.onaylayan'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfoutput>#get_emp_info(list_approve.APPROVE_EMP_ID,0,0)#</cfoutput>
                                    </div>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="3" type="column" sort="true" style="padding-left:15px;padding-right:15px;">
                        <div class="form-group">
                            <label class="col col-12 col-xs12">
                                <cfif isdefined ("attributes.version_id") and len(attributes.version_id)> 
                                    <cfoutput><cfoutput>#GET_GDPR.GDPR_DECLERATION_TEXT#</cfoutput></cfoutput>
                                <cfelse>
                                    <p><cfoutput>#Data_Decleration_.GDPR_DECLERATION_TEXT#</cfoutput></p>
                                </cfif>
                            </label>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="ui-form-list-btn">
                            <cfif isdefined ("attributes.version_id") and len(attributes.version_id)> 
                                <a href="javascript://" style="float:right;color:red!important;font-size: 14px;" ><cf_get_lang dictionary_id='65016.Kşisel Verileri Koruma Kanunu"na uygun olarak Kişisel verilerimin Aydınlatma Metnine Uygun olarak işlenmesini onayladım'>.<cf_get_lang dictionary_id='55839.Onay Tarihi'>: <cfoutput>#Dateformat(GET_GDPR.GDPR_APPROVE_DATE,dateformat_style)#-#timeformat(GET_GDPR.GDPR_APPROVE_DATE,timeformat_style)#</cfoutput></a>
                            <cfelseif list_approve.recordcount>
                                <a href="javascript://" style="float:right;color:red!important;font-size: 14px;" ><cf_get_lang dictionary_id='65016.Kşisel Verileri Koruma Kanunu"na uygun olarak Kişisel verilerimin Aydınlatma Metnine Uygun olarak işlenmesini onayladım'>.<cf_get_lang dictionary_id='55839.Onay Tarihi'>: <cfoutput>#Dateformat(list_approve.GDPR_APPROVE_DATE,dateformat_style)#-#timeformat(list_approve.GDPR_APPROVE_DATE,timeformat_style)#</cfoutput></a>
                            <cfelse>
                                <cfif isdefined("attributes.welcome") and attributes.welcome is  1 >
                                    <a href="javascript://"  class="ui-ripple-btn btn-success" style="float:right;text-decoration:none!important;" onclick="CreateApproveEmp()"><cf_get_lang dictionary_id='58475.Onayla'></a>
                                <cfelse>
                                    <a href="javascript://"  class="ui-ripple-btn btn-success" style="float:right;text-decoration:none!important;" onclick="CreateApproveEmp()"><cf_get_lang dictionary_id='64699.Kişisel verilerin işlenmesi için onay veriyorum'></a>
                                </cfif>
                            </cfif>
                        </div>
                    </div>
                </cf_box_elements>
            </cfform>
        </cf_box>
    </div>

<script>

        function CreateApproveEmp() {
            
            if( confirm( "<cf_get_lang dictionary_id='65021.Kişisel Verileri Koruma Kanunu''na Uygun Olarak Kişisel Verilerimin Aydınlatma Metnine Uygun Olarak işlenmesini onaylayacaksınız. Bu İşlem Geri Alınamaz Emin misiniz'>!")) {
                $.ajax({ 
                type:'POST',  
                url:'AddOns/Devonomy/GDPR/cfc/gdpr_decleration.cfc?method=ADD_APPROVE',
                data: { 
                    
                    gdpr_decleration_id :  <cfoutput>#MAX_DECLERATION.max#</cfoutput>,
                    APPROVE_EMP_ID : <cfoutput>#session.ep.userid#</cfoutput>,
                    EMPLOYEE_ID : <cfoutput>#emp_id#</cfoutput>
                    
                },
                success: function (returnData) {
                    
                    location.href = document.referrer;
                    return true;
                },
                error: function () 
                {
                    console.log('CODE:8 please, try again..');
                    return false; 
                }
            }); 
            return false;        	        
        }
    }

        
</script>
</cfif>
