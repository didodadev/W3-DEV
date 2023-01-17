<cfscript>

    appKeyList = arrayFilter( structKeyArray( application.systemParam ), function ( key ) {
        return arrayContains( [ "fusebox" ], key ) eq 0;
    });

    for (key in appKeyList) {
        variables[key] = application.systemParam[key];
    }

    variables.fusebox = structNew();
    if( StructKeyExists(application.systemParam, "fusebox") ){
        for (fbkey in structKeyArray( application.systemParam.fusebox )) {
            variables.fusebox[fbkey] = application.systemParam.fusebox[fbkey];
        }
    }

</cfscript>