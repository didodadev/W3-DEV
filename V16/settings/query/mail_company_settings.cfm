<cfset ADD_MAIL_CONTENT = createObject("component", "V16.settings.cfc.mail_company_settings")>
<cfif isDefined("attributes.is_monday")>
    <cfset monday = 1>
<cfelse>
    <cfset monday = 0>
</cfif>
<cfif isDefined("attributes.is_tuesday")>
    <cfset tuesday = 1>
<cfelse>
    <cfset tuesday = 0>
</cfif>
<cfif isDefined("attributes.is_wednesday")>
    <cfset wednesday = 1>
<cfelse>
    <cfset wednesday = 0>
</cfif>
<cfif isDefined("attributes.is_thursday")>
    <cfset thursday = 1>
<cfelse>
    <cfset thursday = 0>
</cfif>
<cfif isDefined("attributes.is_friday")>
    <cfset friday = 1>
<cfelse>
    <cfset friday = 0>
</cfif>
<cfif isDefined("attributes.is_saturday")>
    <cfset saturday = 1>
<cfelse>
    <cfset saturday = 0>
</cfif>
<cfif isDefined("attributes.is_sunday")>
    <cfset sunday = 1>
<cfelse>
    <cfset sunday = 0>
</cfif>
<cfset Insert = ADD_MAIL_CONTENT.InsertMailContent(
    delivery_name : attributes.delivery_name,
    subject : attributes.subject,
    sender_email : attributes.sender_email,
    seen_name : attributes.seen_name,
    return_address : attributes.return_address,
    template_name : attributes.template_name,
    mail_list : attributes.mail_list,
    startdate : attributes.startdate,
    str_first_hour : attributes.str_first_hour,
    str_first_minute : attributes.str_first_minute,
    str_second_hour : attributes.str_second_hour,
    str_second_minute : attributes.str_second_minute,
    is_monday : "#monday#",
    is_tuesday : "#tuesday#",
    is_wednesday : "#wednesday#",
    is_thursday : "#thursday#",
    is_friday : "#friday#",
    is_saturday : "#saturday#",
    is_sunday : "#sunday#",
    finishdate : attributes.finishdate,
    fns_hour : attributes.fns_hour,
    fns_minute : attributes.fns_minute
)/>
<script type="text/javascript">
    <cfoutput>
        window.location.href = 'index.cfm?fuseaction=settings.list_mail_companies'
    </cfoutput>
</script>