<!---
    File :          AddOns\Yazilimsa\Protein\reactor\manifest.cfc
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          06.08.2020
    Description :   Protein Siteleri İçin Dinmaik Manifest.json üretir
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get" access="remote" returntype="string" returnFormat="JSON">
        <cfset MAIN = createObject('component','cfc.SYSTEM.MAIN')>
        <cfset GET_SITE = MAIN.GET_SITE()>
        <cfset PRIMARY_DATA = deserializeJSON(GET_SITE.PRIMARY_DATA)>

        <cfset mainfest = structNew() />

        <cfset manifest = {
            "name": "#PRIMARY_DATA.TITLE#",
            "short_name": "#PRIMARY_DATA.TITLE#",
            "description": "#PRIMARY_DATA.META_DESCRIPTION#",
            "theme_color": "##FFFFFF",
            "background_color": "##FFFFFF",
            "start_url": "/",
            "display": "standalone"
        } />
        <cfset manifest["icons"] = [
            {
                "src": "/src/includes/manifest/2_favicon_36x36.png",
                "sizes": "36x36",
                "type": "image/png"
            },
            {
                "src": "/src/includes/manifest/2_favicon_48x48.png",
                "sizes": "48x48",
                "type": "image/png"
            },
            {
                "src": "/src/includes/manifest/2_favicon_72x72.png",
                "sizes": "72x72",
                "type": "image/png"
            },
            {
                "src": "/src/includes/manifest/2_favicon_96x96.png",
                "sizes": "96x96",
                "type": "image/png"
            },
            {
                "src": "/src/includes/manifest/2_favicon_144x144.png",
                "sizes": "144x144",
                "type": "image/png"
            },
            {
                "src": "/src/includes/manifest/2_favicon_192x192.png",
                "sizes": "192x192",
                "type": "image/png"
            }
        ] />
 
        <cfreturn replace(serializeJSON(manifest),"//","")>
    </cffunction>
</cfcomponent>