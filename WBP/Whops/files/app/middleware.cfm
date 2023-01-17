<cfif not isdefined("session_base") and isDefined("attributes.wo") and len(attributes.wo)>
    <cflocation  url="#http_site#" addToken="no">
<cfelseif isdefined("session_base") and not(isDefined("attributes.wo") and len(attributes.wo))>
    <cflocation  url="#http_site#/#request.self#?wo=whops.welcome" addToken="no">
</cfif>

<cfset structAppend(variables,application.functions) />
<cfset structAppend(variables,application.GeneralFunctions) />
<cfset structAppend(variables,application.faFunctions) />

<!--- system functions --->
<cfset base = createObject("component","app.component.base") />
<cfset sessions = createObject('component','app.component.sessions') />

<cfif isdefined("attributes.wo") and len(attributes.wo)>
    <cfset getWo = base.getWo(attributes.wo) />
    
    <cfif getWo.recordcount>
        <cfscript>
            application.objects['#attributes.wo#']['WINDOW'] = getWo.WINDOW;
            application.objects['#attributes.wo#']['FILE_PATH'] = getWo.FILE_PATH;
            application.objects['#attributes.wo#']['DICTIONARY_ID'] = getWo.DICTIONARY_ID;
            application.objects['#attributes.wo#']['CONTROLLER_FILE_PATH'] = getWo.CONTROLLER_FILE_PATH;
            application.objects['#attributes.wo#']['MODULE_NO'] = getWo.MODULE_NO;
            application.objects['#attributes.wo#']['IS_LEGACY'] = getWo.IS_LEGACY;
            application.objects['#attributes.wo#']['LICENCE'] = getWo.LICENCE;
            application.objects['#attributes.wo#']['DISPLAY_BEFORE_PATH'] = getWo.DISPLAY_BEFORE_PATH;
            application.objects['#attributes.wo#']['DISPLAY_AFTER_PATH'] = getWo.DISPLAY_AFTER_PATH;
            application.objects['#attributes.wo#']['ACTION_BEFORE_PATH'] = getWo.ACTION_BEFORE_PATH;
            application.objects['#attributes.wo#']['ACTION_AFTER_PATH'] = getWo.ACTION_AFTER_PATH;
            application.objects['#attributes.wo#']['DATA_CFC'] = getWo.DATA_CFC;
            application.objects['#attributes.wo#']['TYPE'] = getWo.TYPE;
            application.objects['#attributes.wo#']['SECURITY'] = getWo.SECURITY;
            application.objects['#attributes.wo#']['XML_PATH'] = getWo.XML_PATH;
        </cfscript>
    </cfif>
</cfif>