<cfcomponent>
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="stck" type="any">
        <cfargument name="precodeCallback" type="function">
        <cfscript>
            if (arguments.element.devValue.value eq "")
            {
                return "''";
            }
            else
            {
                generator = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(arguments.element.devValue.type);
                code = generator.generate(arguments.element.devValue, arguments.stck.name & "_" & arguments.element.label & "_value_");
                if ( isDefined( "arguments.precodeCallback" ) ) {
                    arguments.precodeCallback(code);
                }
                if (arguments.element.dataCompute eq "CONCAT" and len(arguments.element.formula)) 
                {
                    formulaArray = listToArray(arguments.element.formula);
                    formulaMappedArray = arrayNew(1);
                    for (formulaElement in formulaArray) {
                        currentElementFilter = arrayFilter( stck.listOfElements, function(item) {
                            return item.label eq formulaElement;
                        });
                        if ( arrayLen( currentElementFilter ) ) {
                            currentElement = currentElementFilter[1];
                            if (currentElement.devValue.value eq "") continue;
                            arrayAppend( formulaMappedArray, arguments.stck.name & "_" & currentElement.label & "_value_" & (currentElement.devValue.name?:"")); 
                        }
                    }
                    return arrayToList( formulaMappedArray, ' & " " & ' );
                }
                else 
                {
                    return arguments.stck.name & "_" & arguments.element.label & "_value_" & (arguments.element.devValue.name?:"");
                }
            }
        </cfscript>
    </cffunction>
</cfcomponent>