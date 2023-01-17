<cfcomponent>

    <cffunction name="add_customer_help" access="remote" returntype="any" returnFormat="JSON">
        <cfargument name="partner_id" default="">
        <cfargument name="company_id" default="">
        <cfargument name="consumer_id" default="">
        <cfargument name="app_cat" default="">
        <cfargument name="interaction_cat" default="">
        <cfargument name="interaction_date" default="">
        <cfargument name="subject" default="">
        <cfargument name="process_stage" default="">
        <cfargument name="detail" default="">
        <cfargument name="applicant_name" default="">
        <cfargument name="applicant_mail" default="">
        <cfargument name="is_reply_mail">
        <cfargument name="is_reply">
        <cfargument name="tel_code">
        <cfargument name="tel_no">
        <cfargument name="record_emp">
        <cfargument name="record_date">
        <cfargument name="record_ip">

        <cfobject type="component" name="datalayer" component="WEX.helpdesk.components.data">
        <cfset response = datalayer.insert({
            partner_id: arguments.partner_id,
            company_id: arguments.company_id,
            consumer_id: arguments.consumer_id,
            app_cat: arguments.app_cat,
            interaction_cat: arguments.interaction_cat,
            interaction_date: arguments.interaction_date,
            subject: arguments.subject,
            process_stage: arguments.process_stage,
            detail: arguments.detail,
            applicant_name: arguments.applicant_name,
            applicant_mail: arguments.applicant_mail,
            is_reply_mail: arguments.is_reply_mail,
            is_reply: arguments.is_reply,
            tel_code: arguments.tel_code,
            tel_no: arguments.tel_no,
            record_emp: arguments.record_emp,
            record_date: arguments.record_date,
            record_ip: arguments.record_ip
        }) />
        
        <cfreturn replace(serializeJson(response),'//','')>

    </cffunction>

</cfcomponent>