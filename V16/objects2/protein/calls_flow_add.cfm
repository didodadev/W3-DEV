<cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
<cfset get_service_detail = getComponent.GET_SERVICE_DETAIL(service_id: attributes.id)>
<cfset get_service_plus = getComponent.get_service_plus(service_id : attributes.id)>
<cfset get_module_temp = getComponent.get_module_temp()>
<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset getCmp = createObject('component','V16.project.cfc.get_project_detail')>
<cfset cmp = createObject('component','V16.member.cfc.member_company')>
<cfset get_projects.recordcount = 0>
<cfset GET_EMPS.recordcount = 0>
<cfset get_part.recorcount = 0>
<cfset emp_list="">
<cfset consumer_list="">
<cfset get_part = cmp.GET_HIER_PARTNER(cpid : session_base.company_id, GET_PARTNER:1)>
<cfset partner_id_list = "#valuelist(get_part.partner_id)#">
<cfif len( get_service_detail.project_id)>
    <cfset get_acts = getCmp.GET_PROJECT_WORKGROUP(project_id : get_service_detail.project_id)>
    <cfif get_acts.recordcount>
        <cfset get_projects = getCmp.GET_EMPS(WORKGROUP_ID : get_acts.WORKGROUP_ID)>
        <cfif get_projects.recordcount gt 0>
            <cfset partner_id_list = partner_id_list&","&"#valuelist(get_projects.PARTNER_ID)#">
            <cfset consumer_list="#valuelist(get_projects.CONSUMER_ID)#">
        </cfif>
    </cfif>
</cfif>
<cfif len( get_service_detail.subscription_id)>
    <cfset GET_ACTION_WORKGROUP = getCmp.GET_ACTION_WORKGROUP(action_field : "subscription", action_id : get_service_detail.subscription_id)>
    <cfif len(GET_ACTION_WORKGROUP.WORKGROUP_ID)>
        <cfset GET_EMPS = getCmp.GET_EMPS(WORKGROUP_ID : GET_ACTION_WORKGROUP.WORKGROUP_ID)>
        <cfset emp_list="#valuelist(GET_EMPS.EMPLOYEE_ID)#">
        <cfif get_projects.recordcount gt 0> 
            <cfset emp_list=emp_list&","&"#valuelist(get_projects.EMPLOYEE_ID)#">
        </cfif>
    </cfif>
</cfif>
<cfform name="add_service_meet" method="post">
    <input type="hidden" name="is_add" id="is_add" value="1" />
	<input type="hidden" name="commethod_id" id="commethod_id" value="0">
    <input type="hidden" name="email" id="email" value="" />
    <input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.id#</cfoutput>">
    <cfinput type="hidden" name="site_language_path" id="site_language_path" value="#site_language_path#">
    <cfoutput>    
        <div class="row justify-content-end mb-3">
            <div class="col-md-8 col-lg-6 col-xl-4">
                <select class="form-control" name="template_id" id="template_id" onchange="control2();" >
                    <option value="-1"><cf_get_lang dictionary_id='41012.Şablon Seçiniz'></option>
                    <cfloop query="get_module_temp">
                        <option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#template_head#</option>
                    </cfloop>
                </select>
            </div>
        </div>
        <div class="row mb-3">
            <div class="col-md-12">
                <label class="font-weight-bold"><cf_get_lang dictionary_id='57480.Konu'></label>
                <input type="text" class="form-control" name="header" id="header" value="" required>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <label class="font-weight-bold"><cf_get_lang dictionary_id='57771.Detail'></label>
                <textarea class="form-control" name="plus_content" id="plus_content"></textarea>          
            </div>
        </div>
        <cfsavecontent  variable="title"><cf_get_lang dictionary_id='32440.Email List'></cfsavecontent>
        <div class="row mt-3">
            <div class="col-md-8 col-lg-6 col-xl-4">
                <label for="from"><cf_get_lang dictionary_id='57924.To'></label>    
                <input type="hidden" name="partner_emails" id="partner_emails" value="">
                <input type="hidden" name="employee_id" id="employee_id" value="">
                <input type="hidden" name="partner_id" id="partner_id" value="">
                <input type="hidden" name="consumer_id" id="consumer_id" value="">            
                <div class="input-group">                    
                    <input type="text" class="form-control" name="partner_names" id="partner_names" value="">
                    <div class="input-group-append">
                        <span class="input-group-text icon-ellipsis" onclick="openBoxDraggable('widgetloader?widget_load=mailList&isbox=1&style=maxi&title=#title#&emp_list=#emp_list#&partner_id_list=#partner_id_list#&consumer_list=#consumer_list#&employee_ids=add_service_meet.employee_id&partner_ids=add_service_meet.partner_id&consumer_ids=add_service_meet.consumer_id&mail_id=add_service_meet.partner_emails&names=add_service_meet.partner_names');"></span>
                    </div>
                </div>
            </div>
            <div class="col-md-8 col-lg-6 col-xl-4">
                <label for="from"><cf_get_lang dictionary_id='58773.CC'></label>
                <input type="hidden" name="partner_emails_cc" id="partner_emails_cc" value="">
                <input type="hidden" name="employee_id" id="employee_id_cc" value="">
                <input type="hidden" name="partner_id" id="partner_id_cc" value="">
                <input type="hidden" name="consumer_id" id="consumer_id_cc" value="">
                <div class="input-group">                    
                    <input type="text" class="form-control" name="partner_names_cc" id="partner_names_cc" value="">
                    <div class="input-group-append">
                        <span class="input-group-text icon-ellipsis" onclick="openBoxDraggable('widgetloader?widget_load=mailList&isbox=1&style=maxi&title=#title#&emp_list=#emp_list#&partner_id_list=#partner_id_list#&consumer_list=#consumer_list#&mail_id=add_service_meet.partner_emails_cc&names=add_service_meet.partner_names_cc');"></span>
                    </div>
                </div>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-md-12">       
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='49310.Kaydet ve Mail Gönder'></cfsavecontent>
                <cfsavecontent variable="warning"><cf_get_lang dictionary_id='45686.Are you sure you want to save?'></cfsavecontent>
                <cf_workcube_buttons is_insert='1' data_action="/V16/callcenter/cfc/call_center:add_service_plus" next_page="#site_language_path#/callDet?id=" class="btn btn-primary">   
                <cf_workcube_buttons extraButton="1" extraButtonText="#message#" extraAlert="#warning#" extraFunction="control()" extraButtonType="submit" update_status="0" class="btn btn-save mr-2">   
            </div>
        </div>
    </cfoutput>
</cfform>
<script type="text/javascript"> 
    function control2(){
        window.location.href = "<cfoutput>#site_language_path#/callDet?id=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.id,accountKey:"wrk")#</cfoutput>&template_id="+$('#template_id').val();
    }
    function control()
	{	
        $('#email').val(1);
    }
    <cfif isdefined("attributes.template_id")>
        <cfset get_template_selected = getComponent.GET_TEMPLATE_SELECTED(template_id: attributes.template_id)>
		document.getElementById('plus_content').value = '<cfoutput>#get_template_selected.TEMPLATE_CONTENT#</cfoutput>';	
	</cfif>
    ClassicEditor
        .create( document.querySelector( '#plus_content' ) )
        .then( editor => {
            console.log( 'Editor was initialized', editor );
            myEditor = editor;
            $('.ck.ck-editor__editable_inline>:last-child').css('height','400px');
        } )
        .catch( err => {
            console.error( err.stack );
        } );
</script>


