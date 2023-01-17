<cfcomponent>

    <cffunction name="generate" access="public" returntype="any">
        <cfargument name="element" type="any">
        <cfargument name="domainstruct" type="any">
        <cfargument name="eventtype" type="any">
        <cfscript>

            currentElement = domainstruct.listOfElements[ arrayFind( domainstruct.listOfElements, function( elm ) {
                return elm.label eq element.label;
            } ) ];

            prefix = "";
            if ( isDefined( "currentElement.listOfPropertyMaps" ) and arrayLen( currentelement.listOfPropertyMaps ) neq 0 )
            {
                if ( arrayFind( currentElement.listOfPropertyMaps, function( elm ) {
                    return elm.type eq "displayFor";
                } ) ) {
                    
                    prefixArray = [];
                    
                    for ( prop in arrayFilter( currentElement.listOfPropertyMaps, function( elm ) {
                        return arrayFind( domainstruct.listOfProperties, function( itm ) {
                            return itm.label eq elm.propertyName && (
                                    ( eventtype eq "add" && itm.isAdd )
                                    || ( eventtype eq "update" && itm.isUpdate )
                                    || ( eventtype eq "list" && ( itm.isList || itm.isSearch ) )
                                );
                        } );
                    } ) ) 
                    {
                        if ( prop.type eq "displayFor" ) {
                            
                            arrayAppend( prefixArray, 'isDefined("attributes.' & prop.propertyName & '") and attributes.' & prop.propertyName );
                        }
                    }
                    if (arrayLen( prefixArray ))
                        prefix = " and " & arrayToList( preFixArray, " and " );
                }
            }
        </cfscript>
        <cfreturn prefix>
    </cffunction>

</cfcomponent>