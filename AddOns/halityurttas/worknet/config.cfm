<cfscript>
    
    addonPath = 'AddOns/halityurttas/worknet';
    addonViewsPath = addonPath & '/views';
    addonQueriesPath = addonPath & '/queries';
    addonComponentsPath = addonPath & '/components';
    
    addonNS = "addons.halityurttas.worknet";

    objectResolver = createObject("component", "#addonNS#.system.objectResolver").init();
</cfscript>