<!---
    File :          graph/argumentbuilder.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          02.09.2019
    Description :   Grafik sorguları için dinamik argumanlar oluşturur. Bir arguman ön tanımlı veya filtreden gelebilir.
    Notes :         Bir grafik arguman değeri boş ise grafik değeri için filtre alanına input eklenir
--->
<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate">
        <cfargument name="filterFunc" type="function">

        <cfscript>
            helper = createObject( "component", "WDO.catalogs.builders.componentbuilders.querybuilders.helper" );
            currentStruct = helper.getStruct( this.data.listOfArguments[1].struct, this.domain );

            argarray = arrayNew(1);

            for (elm in this.data.listOfArguments ) {
                currentElement = arrayFilter( currentStruct.listOfElements, function( el ) {
                    return el.label eq elm.label;
                })[1];
                
                graphMethodArg = elm.graphMethodArg;

                if ( currentElement.filterAsRange eq 1 and len(elm.graphMethodArg) eq 0 ) {
                
                    graphMethodArg = filterFunc(elm.label & "_min", elm);
                    
                    arrayAppend(argarray, { label: graphMethodArg, dataType: currentElement.devDBField.fieldType, equality: "greaterequal", dbField: currentElement.devDBField.scheme & '.' & currentElement.devDBField.table & '.' & currentElement.devDBField.field, isEval: 1 });

                    graphMethodArg = filterFunc(elm.label & "_max", elm);

                    arrayAppend(argarray, { label: graphMethodArg, dataType: currentElement.devDBField.fieldType, equality: "lessequal", dbField: currentElement.devDBField.scheme & '.' & currentElement.devDBField.table & '.' & currentElement.devDBField.field, isEval: 1 });
                
                } else {
                    
                    isEval = 0;
                    if ( len(elm.graphMethodArg) eq 0 ) {
                        graphMethodArg = "attributes." & filterFunc(elm.label, elm) & '?:""';
                        isEval = 1;
                    }

                    arrayAppend(argarray, { label: graphMethodArg, dataType: currentElement.devDBField.fieldType, equality: elm.graphMethod, dbField: currentElement.devDBField.scheme & '.' & currentElement.devDBField.table & '.' & currentElement.devDBField.field, isEval: isEval });
                }
                
            }

            return argarray;
        </cfscript>
    </cffunction>

</cfcomponent>