<cfset get_project_detail = createObject('component','V16.project.cfc.get_project_detail')>
<cfset GET_ACTION_WORKGROUP = get_project_detail.GET_ACTION_WORKGROUP(action_field : 'subscription', action_id : attributes.subscription_id)>
<cfif len(GET_ACTION_WORKGROUP.WORKGROUP_ID)>
    <cfset GET_EMPS = get_project_detail.GET_EMPS(WORKGROUP_ID : GET_ACTION_WORKGROUP.WORKGROUP_ID)>
<cfelse>
    <cfset GET_EMPS.recordcount = 0>
</cfif>

<cfif GET_EMPS.recordcount>
    <cfoutput query="GET_EMPS">

        <cfset this_role_id = role_id>
        <cfif len(this_role_id)>
            <cfset GET_ROLES = get_project_detail.GET_ROLES(PROJECT_ROLES_ID:this_role_id)>
        </cfif>

        <cfif len(EMPLOYEE_ID)>

            <cfset employee_photo = get_project_detail.EMPLOYEE_PHOTO(employee_id:EMPLOYEE_ID)>
            <cfif len(employee_photo.photo)>
                <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
            <cfelseif employee_photo.sex eq 1>
                <cfset emp_photo ="/images/male.jpg">
            <cfelse>
                <cfset emp_photo ="/images/female.jpg">
            </cfif>
            <img src='#emp_photo#' class="rounded-circle float-left mr-4" height="50" width="50"/>
            <p class="mb-1 project-color-g">#get_emp_info(EMPLOYEE_ID,0,0)# <cfif len(this_role_id)>/ #get_roles.PROJECT_ROLES#</cfif></p>
            <cfif len(employee_photo.employee_email)><a href="mailto:#employee_photo.employee_email#" class="none-decoration"><i class="far fa-envelope mr-2" title="#employee_photo.employee_email#"></i></a></cfif>

        <cfelseif len(CONSUMER_ID)>
            
            <cfset employee_photo = get_project_detail.CONSUMER_PHOTO(consumer_id:CONSUMER_ID)>
            <cfif len(employee_photo.picture)>
                <cfset emp_photo ="../../documents/member/consumer/#employee_photo.picture#">
            <cfelseif employee_photo.sex eq 1>
                <cfset emp_photo ="/images/male.jpg">
            <cfelse>
                <cfset emp_photo ="/images/female.jpg">
            </cfif>
            <img src='#emp_photo#' class="rounded-circle float-left mr-4" height="50" width="50"/>
            <p class="mb-1 project-color-g">#get_cons_info(CONSUMER_ID,1,0)# <cfif len(this_role_id)>/ #get_roles.PROJECT_ROLES#</cfif></p>
            <cfif len(employee_photo.consumer_email)><a href="mailto:#employee_photo.consumer_email#" class="none-decoration"><i class="far fa-envelope mr-2" title="#employee_photo.consumer_email#"></i></a></cfif>

        <cfelseif len(PARTNER_ID)>

            <cfset employee_photo = get_project_detail.PARTNER_PHOTO(partner_id:PARTNER_ID)>
            <cfif len(employee_photo.photo)>
                <cfset emp_photo ="../../documents/member/#employee_photo.PHOTO#">
            <cfelseif employee_photo.sex eq 1>
                <cfset emp_photo ="/images/male.jpg">
            <cfelse>
                <cfset emp_photo ="/images/female.jpg">
            </cfif>
            <img src='#emp_photo#' class="rounded-circle float-left mr-4" height="50" width="50"/>
            <cfset GET_COMPANY_PARTNER = get_project_detail.GET_COMPANY_PARTNER(PARTNER_ID :PARTNER_ID)>
            <cfset member_name_ = '#GET_COMPANY_PARTNER.COMPANY_PARTNER_NAME# #GET_COMPANY_PARTNER.COMPANY_PARTNER_SURNAME#-#GET_COMPANY_PARTNER.NICKNAME#'>
            <p class="mb-1 project-color-g">#member_name_# <cfif len(this_role_id)>/ #get_roles.PROJECT_ROLES#</cfif></p>
            <cfif len(employee_photo.COMPANY_PARTNER_EMAIL)><a href="mailto:#employee_photo.COMPANY_PARTNER_EMAIL#" class="none-decoration"><span><i class="far fa-envelope mr-2" title="#employee_photo.COMPANY_PARTNER_EMAIL#"></i></span></a></cfif>

        </cfif>
    </cfoutput>
<cfelse>
    <p><cf_get_lang dictionary_id='57484.Kayıt Yok'></p>
</cfif>

<!--- <a href="##" class="none-decoration">
    <i class="far fa-user mr-2"></i>
</a>
<a href="##" class="none-decoration">
    <i class="far fa-comment-dots mr-2"></i>
</a>
<a href="##" class="none-decoration">
    <i class="far fa-calendar-alt mr-2"></i> 
</a> --->