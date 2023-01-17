<cfcomponent>

    <cffunction name="getSchemaInfo" access="public" returntype="any">
        <cfargument name="schemaName" type="string" required="true">

        <cfset response = StructNew() />

        <cfscript>
            if( Find('_', arguments.schemaName) ){
                parsUnderline = ListToArray(arguments.schemaName, '_');
                parsUnderlineCount = ArrayLen(parsUnderline);
                
                if( isNumeric( parsUnderline[ parsUnderlineCount ] ) ){

                    if( isNumeric( parsUnderline[ parsUnderlineCount - 1 ] ) and len(parsUnderline[ parsUnderlineCount - 1 ]) gte 4 ) response = { type: 'period' };
                    else response = { type: 'company' };

                }else if( parsUnderline[ parsUnderlineCount ] == 'product' ) response = { type: 'product' };
                else response = { type: 'main' };

            }else response = { type: 'main' };
        </cfscript>

        <cfreturn response>

    </cffunction>

</cfcomponent>