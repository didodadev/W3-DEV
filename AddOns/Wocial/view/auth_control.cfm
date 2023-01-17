<cfinclude template="../wocial_app.cfm">

<!--- facebook --->
<cfif isdefined("attributes.code") and len(attributes.code) and isDefined("attributes.state") and len(attributes.state)>
    
    <cfset providerProperties = createObject("component", "AddOns/Wocial/Component/providers/providerProperties") />
    <cfset providerInfo = providerProperties.getProviderData( platform: 'facebook' ) />

    <cfset facebookBuilder = createObject('component', 'AddOns/Wocial/Component/oauth2Builders/facebook').init(
        client_id: providerInfo["clientId"],
        client_secret: providerInfo["clientSecret"],
        redirect_uri: providerInfo["redirect_uri"]
    ) />
    <cfset accessToken = facebookBuilder.makeAccessTokenRequest(code: attributes.code) />
    
    <cfif accessToken.success>

        <cfset getPlatform = getData.getPlatform( provider_name: 'facebook' ) />
        <cfset tokenData = deserializeJSON(accessToken.content) />
        
        <cfset expiredDate = helper.calcExpiresDate( expires_sec: tokenData.expires_in ) />

        <cfset setData.setAccessToken(
            access_token: tokenData.access_token,
            state: attributes.state,
            platform_id: getPlatform.PLATFORM_ID,
            expiredDate: expiredDate
        ) />

        <script>
            window.opener.location.reload();
            window.close();
        </script>

    <cfelse>

        <cfset error =  { error_code: 'WER-1000', error_message: 'Servis bağlatısı reddedildi!' } />
        <cfdump var = "#error#" abort>

    </cfif>

<cfelse>
    <cfset error =  { error_code: attributes.error_code, error_message: attributes.error_message } />
    <cfdump var = "#error#" abort>
</cfif>