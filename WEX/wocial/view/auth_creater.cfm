<cfif isDefined("attributes.state") and len( attributes.state ) and isDefined("attributes.platform") and len( attributes.platform )>
    
    <cfset mainFolder = replaceNoCase(replace( index_folder, '\', '/', 'all' ), 'V16/', '') />
    <cfif fileExists( '#mainFolder#/WEX/wocial/components/providers/#attributes.platform#.cfc' )>
        <cfset providerBuilder = createObject("component","WEX/wocial/components/providers/providerBuilder") />
        <cfset getProvider = providerBuilder.getProvider( attributes.platform, attributes.state ) />
        <cfif len( getProvider.token_url )>
            
            <script>

                window.top.location.href = "<cfoutput>#getProvider.token_url#</cfoutput>"

            </script>
            <!--- <script>

                $.ajax({
                    url: "<cfoutput>#getProvider.token_url#</cfoutput>",
                    dataType: "text/html",
                    method: "get",
                    success: function( response ) {

                    }
                });

            </script> --->

            <!--- <cfhttp url="#getProvider.token_url#" result="response" charset="utf-8"></cfhttp>
            <cfif response.Statuscode eq '200 OK' and structKeyExists(response.ResponseHeader, 'Status_Code') and '200' == response.ResponseHeader[ 'Status_Code' ]>
                <cfoutput>#response.FileContent#</cfoutput>
            <cfelse>
                Sosyal Medya Giris islemleri sirasinda bir sorun olustu!
            </cfif> --->

        <cfelse>
            Access token url olusturulurken bir sorun olustu!
        </cfif>
    <cfelse>
        Talep edilen platformun hizmeti henuz sunulamıyor!
    </cfif>

<cfelseif isDefined("attributes.state") and len( attributes.state ) and isdefined("attributes.code") and len(attributes.code)><!--- facebook --->
    <cfdump var="#attributes#">
</cfif>