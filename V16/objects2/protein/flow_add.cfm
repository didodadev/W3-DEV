<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset get_opportunity = opportunitiesCFC.GET_OPPORTUNITY(opp_id : attributes.opp_id)>

<cfif isdefined('session.pp.userid')>
  <cfset GET_MAILFROM = opportunitiesCFC.GET_MAILFROM()>
    <cfif GET_MAILFROM.RECORDCOUNT>
        <cfset cc_mails = "#GET_MAILFROM.COMPANY_PARTNER_NAME# #GET_MAILFROM.COMPANY_PARTNER_SURNAME#<#GET_MAILFROM.COMPANY_PARTNER_EMAIL#>">
        <cfset cc_mails_name = '#GET_MAILFROM.COMPANY_PARTNER_NAME# #GET_MAILFROM.COMPANY_PARTNER_SURNAME#'>
        <cfset cc_mails_id = GET_MAILFROM.PARTNER_ID>
    </cfif>
<cfelse>
	<cfset cc_mails = ''>
    <cfset cc_mails_name = ''>
    <cfset cc_mails_id = ''>
</cfif>
<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset cmp = createObject('component','V16.member.cfc.member_company')>
<cfset GET_EMPS.recordcount = 0>
<cfset get_part.recorcount = 0>
<cfset emp_list="">
<cfset consumer_list="">
<cfset GET_EMPS = getComponent.GET_POSITIONS(our_cid : session_base.our_company_id)>
<cfset get_part = cmp.GET_HIER_PARTNER(cpid : session_base.company_id, GET_PARTNER:1)>
<cfset get_parts_cons = cmp.GET_HIER_PARTNER(cpid : get_opportunity.PARTNER_ID, GET_PARTNER:1)>
<cfif len(get_opportunity.CONSUMER_ID)>
    <cfset get_cons = cmp.GET_HIER_PARTNER(cpid : get_opportunity.CONSUMER_ID, GET_PARTNER:1)>
    <cfset consumer_list="#valuelist(get_cons.CONSUMER_ID)#">
</cfif>
<cfset partner_id_list = "#valuelist(get_part.partner_id)#">
<cfif len(get_opportunity.partner_id)>
    <cfset partner_id_list = partner_id_list&","&"#valuelist(get_parts_cons.PARTNER_ID)#">
</cfif>
<cfset emp_list="#valuelist(GET_EMPS.EMPLOYEE_ID)#">
<cfif isdefined("attributes.pursuit_template_id") and len(attributes.pursuit_template_id)>
    <cfset get_pursuit_templates = opportunitiesCFC.GET_PURSUIT_TEMPLATES(pursuit_template_id : attributes.pursuit_template_id)>
</cfif>
<cfset get_pursuit_template = opportunitiesCFC.GET_PURSUIT_TEMPLATES()>
<cfform name="add_offer_meet" method="post">
    <input type="hidden" name="is_add" id="is_add" value="1" />
    <input type="hidden" name="email" id="email" value="" />
    <input type="hidden" name="opp_id" id="opp_id" value="<cfoutput>#contentEncryptingandDecodingAES(isEncode:0,content:opp_id,accountKey:'wrk')#</cfoutput>">
    <cfoutput>
    
    <div class="row justify-content-end mb-3">
        <div class="col-md-8 col-lg-6 col-xl-4">
            <select class="form-control" name="pursuit_template_id" id="pursuit_template_id" onchange="control2();" >
                <option value="-1"><cf_get_lang dictionary_id='41012.Şablon Seçiniz'></option>
                <cfloop query="get_pursuit_template">
                    <option value="#template_id#"<cfif isDefined("attributes.pursuit_template_id") and (attributes.pursuit_template_id eq template_id)> selected</cfif>>#template_head#</option>
                </cfloop>
            </select>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-md-12">
            <label class="font-weight-bold">Başlık</label>
            <input type="text" class="form-control" name="opp_head" id="opp_head" value="">
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57771.Detail'></label>
            <textarea class="form-control" name="plus_content" id="plus_content"></textarea>          
        </div>
    </div>

    <div class="row mt-3">
        <div class="col-md-8 col-lg-6 col-xl-4">
            <label for="from"><cf_get_lang dictionary_id='57924.To'></label>
            
            <div class="input-group">
                <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.contact_id') and Len(attributes.contact_id)>#attributes.contact_id#</cfif>">
                <input type="hidden" name="employee_names" id="employee_names" value="">
                <input type="text" class="form-control" name="employee_emails" id="employee_emails"  value="<cfif isdefined('attributes.contact_mail') and Len(attributes.contact_mail)>#attributes.contact_mail#</cfif>">
                <cfsavecontent  variable="title"><cf_get_lang dictionary_id='63125.Muhataplar'></cfsavecontent>
                <div class="input-group-append">
                    <span class="input-group-text icon-ellipsis" onclick="openBoxDraggable('widgetloader?widget_load=mailList&isbox=1&style=maxi&title=#title#&emp_list=#emp_list#&partner_id_list=#partner_id_list#&consumer_list=#consumer_list#&mail_id=add_offer_meet.employee_emails&names=add_offer_meet.employee_names');"></span>
                </div>
            </div>
        </div>
        <div class="col-md-8 col-lg-6 col-xl-4">
            <label for="from"><cf_get_lang dictionary_id='32774.CC'></label>
            <div class="input-group">
                <div class="input-group">
                    <input type="hidden" name="employee_id1" id="employee_id1" value="#cc_mails_id#">
                    <input type="hidden" name="employee_names1" id="employee_names1" value="#cc_mails_name#">
                    <input type="text" class="form-control" name="employee_emails1" id="employee_emails1"  value="#cc_mails#">
                    <div class="input-group-append">
                        <span class="input-group-text btnPointer icon-ellipsis" onclick="openBoxDraggable('widgetloader?widget_load=mailList&isbox=1&style=maxi&title=#title#&emp_list=#emp_list#&partner_id_list=#partner_id_list#&consumer_list=#consumer_list#&mail_id=add_offer_meet.employee_emails1&names=add_offer_meet.employee_names1');"></span>
                    </div>
                </div> 
            </div>
        </div>
    </div>
    <hr>
    <div class="row">
        <div class="col-md-12">            
            <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/opportunities_data:ADD_OFFER_PLUS" next_page="#site_language_path#/opportunitiesDetail?opp_id=">
        </div>
    </div>
    </cfoutput>
</cfform>
<cfset get_pursuit.TEMPLATE_CONTENT = isdefined("attributes.pursuit_template_id") and len(attributes.pursuit_template_id)?opportunitiesCFC.GET_PURSUIT_TEMPLATES(pursuit_template_id : attributes.pursuit_template_id).TEMPLATE_CONTENT:"">
<script>
    function control2(){
        window.location.href = "<cfoutput>#site_language_path#/opportunitiesDetail?opp_id=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.opp_id,accountKey:"wrk")#</cfoutput>&pursuit_template_id="+$('#pursuit_template_id').val();
    }    
	function control()
	{
		document.add_offer_meet.clicked.value='&email=true';
		document.add_offer_meet.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=sales.emptypopup_add_opp_plus" + document.add_offer_meet.clicked.value;
		var aaa = document.add_offer_meet.employee_emails.value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.add_offer_meet.clicked.value == '&email=true'))
		{ 
			alert("<cf_get_lang dictionary_id='58484.Lütfen geçerli bir e-mail adresi giriniz'>");
			document.add_offer_meet.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=sales.emptypopup_add_opp_plus";
			return false;
		}			  
		return true;
	}
    <cfset attributes.pursuit_template_id = -1>
	<cfif isDefined("attributes.pursuit_templates")>
		<cfset attributes.pursuit_template_id = attributes.pursuit_templates>
	</cfif>
	document.all.plus_content.value = '<cfoutput>#get_pursuit.TEMPLATE_CONTENT#</cfoutput>';
    ClassicEditor
        .create(document.querySelector('#plus_content'))
        .catch(error => {
            console.error(error);
        });
</script>