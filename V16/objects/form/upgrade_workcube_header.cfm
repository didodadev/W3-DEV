<!--- <cfif attributes.type eq 'paramsettings'>
    <h4><cf_get_lang dictionary_id = "43947.Sistem Parametre Ayarları"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&type=upgradesystem</cfoutput>"><cf_get_lang dictionary_id = "49468.Güncel Sürüme Geçiş Süreci Sayfasına Geri Dön"></a></h4>
<cfelseif attributes.type eq 'cfgitdifflist'>
    <h4><cf_get_lang dictionary_id = "50953.Standart Dosya Geliştirimleri"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&type=paramsettings</cfoutput>"><cf_get_lang dictionary_id = "49963.Sistem Parametre Ayarları Sayfasına Dön"></a></h4>
<cfelseif attributes.type eq 'changerelease' >
    <h4><cf_get_lang dictionary_id = "50954.Güncel Sürüme Geçiş"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&type=cfgitdifflist</cfoutput>"><cf_get_lang dictionary_id = "50241.Standart Dosya Geliştirimleri Sayfasına Dön"></a></h4>
<cfelseif attributes.type eq 'getwrolist'>
    <h4><cf_get_lang dictionary_id = "50978.Güncel WRO sorguları"></h4>
<cfelseif attributes.type eq 'getwolang'>
    <h4><cf_get_lang dictionary_id = "50979.Güncel Obje ve Diller"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&type=dbcompare</cfoutput>">Karşılaştırma Kurulumu Sayfasına Geri Dön</a></h4>
<cfelseif attributes.type eq 'restartworkcube'>
    <h4><cf_get_lang dictionary_id = "51001.Workcube Catalysti yeniden başlatın"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&type=getwolang</cfoutput>">Güncel obje ve diller sayfasına geri dön</a></h4>
</cfif> --->
<cfoutput>
    <ul class="col col-12 upgrade-bread-crumb pdn-l-0 pdn-r-0">
        <cfif attributes.mode eq 1><!--- Master'dan Upgrade sistemine geçiş ---->
            <cfif ListFindNoCase(headerStep["paramsettings"]["show"]["mastertoupg"], attributes.type)><li class="#(attributes.type eq 'paramsettings') ? 'active' : ''# col col-4 col-xs-12">1 - #headerStep["paramsettings"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["cfgitdifflist"]["show"]["mastertoupg"], attributes.type)><li class="#(attributes.type eq 'cfgitdifflist') ? 'active' : ''# col col-4 col-xs-12">2 - #headerStep["cfgitdifflist"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["changerelease"]["show"]["mastertoupg"], attributes.type)><li class="#(attributes.type eq 'changerelease') ? 'active' : ''# col col-4 col-xs-12">3 - #headerStep["changerelease"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["getwrolist"]["show"]["mastertoupg"], attributes.type)><li class="#(attributes.type eq 'getwrolist') ? 'active' : ''# col col-4 col-xs-12">4 - #headerStep["getwrolist"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["getwolang"]["show"]["mastertoupg"], attributes.type)><li class="#(attributes.type eq 'getwolang') ? 'active' : ''# col col-4 col-xs-12">5 - #headerStep["getwolang"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["restartworkcube"]["show"]["mastertoupg"], attributes.type)><li class="#(attributes.type eq 'restartworkcube') ? 'active' : ''# col col-4 col-xs-12">6 - #headerStep["restartworkcube"]["title"]#</li></cfif>
        <cfelse>
            <cfif ListFindNoCase(headerStep["cfgitdifflist"]["show"]["upgtoupg"], attributes.type)><li class="#(attributes.type eq 'cfgitdifflist') ? 'active' : ''# col col-4 col-xs-12">1 - #headerStep["cfgitdifflist"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["changerelease"]["show"]["upgtoupg"], attributes.type)><li class="#(attributes.type eq 'changerelease') ? 'active' : ''# col col-4 col-xs-12">2 - #headerStep["changerelease"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["paramsettings"]["show"]["upgtoupg"], attributes.type)><li class="#(attributes.type eq 'paramsettings') ? 'active' : ''# col col-4 col-xs-12">3 - #headerStep["paramsettings"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["getwrolist"]["show"]["upgtoupg"], attributes.type)><li class="#(attributes.type eq 'getwrolist') ? 'active' : ''# col col-4 col-xs-12">4 - #headerStep["getwrolist"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["getwolang"]["show"]["upgtoupg"], attributes.type)><li class="#(attributes.type eq 'getwolang') ? 'active' : ''# col col-4 col-xs-12">5 - #headerStep["getwolang"]["title"]#</li></cfif>
            <cfif ListFindNoCase(headerStep["restartworkcube"]["show"]["upgtoupg"], attributes.type)><li class="#(attributes.type eq 'restartworkcube') ? 'active' : ''# col col-4 col-xs-12">6 - #headerStep["restartworkcube"]["title"]#</li></cfif>
        </cfif>
    </ul>
</cfoutput>