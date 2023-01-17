
<cfparam name="attributes.domain" default="">
<cfparam name="attributes.ipNo" default="">
<cfparam name="attributes.password" default="">
<cfparam name="attributes.sms_control" default="0">
<cfset wex_authorization = CreateObject('component','V16.objects.cfc.wex_authorization')>
<cfset response = wex_authorization.insert(
        wex_id          :   #iif(isdefined("attributes.wex_id"),attributes.wex_id,DE(""))#,
        subscription_id :   #iif(isdefined("attributes.subscription_id"),attributes.subscription_id,DE(""))#,
        counter_id      :   #iif(isdefined("attributes.counter_id"),attributes.counter_id,DE(""))#,
        company_id      :   #iif(isdefined("attributes.company_id"),attributes.company_id,DE(""))#,
        domain          :   attributes.domain,
        ipNo            :   attributes.ipNo,
		password		:	attributes.password,
        is_sms		    :	#iif(isdefined("attributes.sms_control"),attributes.sms_control,DE(0))#
)>

<cfif response.status eq false>
    <script>
        alert("Bir hata oluştu!");
    </script>
<cfelse>
    <script>
        alert("Kayıt başarıyla oluşturuldu!");
        window.close();
    </script>
</cfif>