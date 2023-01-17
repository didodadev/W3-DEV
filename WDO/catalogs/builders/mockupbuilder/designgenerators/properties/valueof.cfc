<cfcomponent>

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="struct" type="any">
        <cfargument name="eventtype" type="any">
        <cfargument name="defaultcoder" type="any">
        <cfscript>
            code = "";
            if 
            ( 
                isDefined( "arguments.element.listOfPropertyMaps" ) 
                && arrayLen( arguments.element.listOfPropertyMaps ) 
                && arrayFind( arguments.element.listOfPropertyMaps, function( elm ) { return elm.type eq "valueOf"; } ) neq 0 
            )
            {
                propName = arguments.element.listOfPropertyMaps[ arrayFind( arguments.element.listOfPropertyMaps, function( elm ) { return elm.type eq "valueOf"; } ) ].propertyName;

                if ( 
                    arrayFind( arguments.struct.listOfProperties, 
                        function( elm ) { 
                            return elm.label eq propName 
                                && (
                                    ( eventtype eq "add" && elm.isAdd )
                                    || ( eventtype eq "update" && elm.isUpdate )
                                    || ( eventtype eq "list" && ( elm.isList || elm.isSearch ) )
                                );
                        } 
                    ) 
                )
                {
                    code = "dynamic_property_" & arguments.struct.name & "_" & propName;
                }
                else
                {
                    code = defaultcoder();
                }
            }
            else 
            {
                code = defaultcoder();                
            }
            
        </cfscript>
        <cfreturn code>
    </cffunction>

</cfcomponent>