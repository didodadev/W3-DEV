<cfparam name="attributes.domain" default="">
<cfparam name="attributes.ipNo" default="">
<cfparam name="attributes.password" default="">
<cfparam name="attributes.sms_control" default="0">
<cfset wex_authorization = CreateObject('component','V16.objects.cfc.wex_authorization')>
<cfif isdefined("attributes.is_del")>
    <cfset response = wex_authorization.delete(auth_id   :   '#attributes.auth_id#')>
<cfelse>
    <cfset response = wex_authorization.update(
        auth_id         :   #attributes.auth_id#,
        subscription_id :   #iif(isdefined("attributes.subscription_id"),attributes.subscription_id,DE(""))#,
        counter_id      :   #iif(isdefined("attributes.counter_id"),attributes.counter_id,DE(""))#,
        company_id      :   #iif(isdefined("attributes.company_id"),attributes.company_id,DE(""))#,
        domain          :   attributes.domain,
        ipNo            :   attributes.ipNo,
		password		:	attributes.password,
        is_sms		    :	#iif(isdefined("attributes.sms_control"),attributes.sms_control,DE(0))#
    )>
</cfif>

<cfif response.status eq false>
    <script>
        alert("<cfoutput>#response.message#</cfoutput>");
    </script>
<cfelse>
    <script>
        alert("<cfoutput>#response.message#</cfoutput>");
        window.opener.location.reload();
        window.close();
    </script>
</cfif>