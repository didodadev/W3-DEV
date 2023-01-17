<cfset getAccessToken = getData.getAccessToken() />
<cfif getAccessToken.recordcount>
    <div class="col col-12">
        <cf_box scroll="0">
            <cf_box_elements>
                <div class="col col-12">
                    <cfoutput query="getAccessToken">
                        <cfif not EXPIRED_STATUS>
                            <cfset getPlatform = getData.getPlatform( platform_id: PLATFORM_ID ) />
                            <cfset getProvider = providerBuilder.getProvider( getPlatform.PLATFORM_PROVIDER_NAME ) />
                            <!--- <div class="col col-4"><i class="fa fa-1-3x #PLATFORM_ICON#"></i> Erişim anahtarını doğrulamalısınız! <a href = "javascript://" onclick="windowopen('#getProvider.token_url#', 'list')">Şimdi Doğrulayın!</a></div> --->
                            <div class="col col-4"><i class="fa fa-1-3x #PLATFORM_ICON#"></i> Erişim anahtarını doğrulamalısınız! <a href = "javascript://" onclick="windowopen('#request.self#?fuseaction=wocial.popup_auth_creater&platform=#getPlatform.PLATFORM_PROVIDER_NAME#', 'list')">Şimdi Doğrulayın!</a></div>
                        <cfelse>
                            <div class="col col-2"><i class="fa fa-1-3x #PLATFORM_ICON#"></i></div>
                        </cfif>
                    </cfoutput>
                </div>
            </cf_box_elements>
        </cf_box>
    </div>
</cfif>