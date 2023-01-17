<cfcomponent>

    <cfproperty name="componentprops" type="any" default="">

    <cffunction name="generate" access="public" returntype="any">
        <cfargument name="data" type="any">
        <cfscript>
            this.componentprops = [];
            codes = {};
            for (struct in data) 
            {
                createCode = createCodeGenerate(data=arguments.data, structName=struct.name);
                readCode = readCodeGenerate(data=arguments.data, structName=struct.name);
                updateCode = updateCodeGenerate(data=arguments.data, structName=struct.name);
                readallCode = readAllCodeGenerate(data=arguments.data, structName=struct.name);
                removeCode = removeCodeGenerate(data=arguments.data, structName=struct.name);
                summaryCode = summaryCodeGenerate(data=arguments.data, structName=struct.name);
                chartCode = chartCodeGenerate(data=arguments.data, structName=struct.name);
                //propertyCodeArray = propertyCodeGenerator(data=arguments.data, structName=struct.name);

                cmpcode = createCode & readallCode & readCode & updateCode & removeCode & summaryCode & chartCode;
                codes['#struct.name#'] = cmpcode;
            }
        </cfscript>
        <cfreturn codes>
    </cffunction>

    <cffunction name="createCodeGenerate" access="private" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="structName" type="string">
        <cfscript>
            
            createGenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.CreateBuilder").init(structName=arguments.structName, data=arguments.data);
            createCode = createGenerator.setFunc().setArguments().setCodes().setSqlQuery().generate() & crlf();
        
        </cfscript>
        
        <cfreturn createCode>
    </cffunction>

    <cffunction name="readAllCodeGenerate" access="private" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="structName" type="string">
        <cfscript>
        
            readAllGenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.ReadAllBuilder").init(structName=arguments.structName, data=arguments.data);
            readallCode = readAllGenerator.setFunc().setArguments().setCodes().setSqlQuery().generate() & crlf();
        
        </cfscript>
        <cfreturn readallCode>
    </cffunction>

    <cffunction name="readCodeGenerate" access="private" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="structName" type="string">
        <cfscript>
            
            readGenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.ReadBuilder").init(structName=arguments.structName, data=arguments.data);
            readCode = readGenerator.setFunc().setArguments().setCodes().setSqlQuery().generate() & crlf();

        </cfscript>
        <cfreturn readCode>
    </cffunction>

    <cffunction name="updateCodeGenerate" access="private" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="structName" type="string">
        <cfscript>
        
            updateGenerator = createObject("component",  "WDO.catalogs.builders.componentbuilders.functionbuilders.UpdateBuilder").init(structName=arguments.structName, data=arguments.data);
            updateCode = updateGenerator.setFunc().setArguments().setCodes().setSqlQuery().generate() & crlf();
        
        </cfscript>
        <cfreturn updateCode>
    </cffunction>

    <cffunction name="removeCodeGenerate" access="private" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="structName" type="string">
        <cfscript>
            
            removeGenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.DeleteBuilder").init(structName=arguments.structName, data=arguments.data);
            removeCode = removeGenerator.setFunc().setArguments().setSqlQuery().generate() & crlf();

        </cfscript>
        <cfreturn removeCode>
    </cffunction>

    <cffunction name="summaryCodeGenerate" access="private" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="structName" type="string">
        <cfscript>

            summaryGenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.SummaryBuilder").init(structName=arguments.structName, data=arguments.data);
            summaryCode = summaryGenerator.setFunc().setArguments().setSqlQuery().generate() & crlf();

        </cfscript>
        <cfreturn summaryCode>
    </cffunction>

    <cffunction name="propertyCodeGenerator" access="private" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="structName" type="string">
        <cfscript>

            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            currentStruct = helper.getStruct( arguments.structName, arguments.data );

            propCodes = [];
            propertyGenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.PropertyBuilder");
            for ( prop in currentStruct.listOfProperties ) {
                if (arrayLen(prop.listOfConditions)) continue;
                propCode = propertyGenerator.init(structName=arguments.structName, data=arguments.data).setFunctions(prop.label).setCodes(prop.label).setConditions(prop.label).generate();
                arrayAppend( propCodes, propCode );
                /*
                if ( propertyGenerator.valueContainer neq "" ) {
                    arrayAppend( this.componentprops, propertyGenerator.valueContainer );
                }
                */
            }

            return propCodes;

        </cfscript>
    </cffunction>

    <cffunction name="chartCodeGenerate" access="private" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="structName" type="string">
        <cfscript>

            chartGenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.ChartBuilder").init(structName=arguments.structName, data=arguments.data);
            chartCode = chartGenerator.setFunc().setArguments().setCodes().setSqlQuery().generate();

        </cfscript>
        <cfreturn chartcode>
    </cffunction>

    <!--- local helpers --->
    <cffunction name="crlf" access="private" returntype="string">
        <cfreturn CreateObject("java", "java.lang.System").getProperty("line.separator")>
    </cffunction>

</cfcomponent>