<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: 			            Developer	: Halit Yurttaş		
Analys Date : 00/00/0000			Dev Date	: 20/06/2018		
Description :
	Take component information from given path that primarly aim parse 'Utility' components. Please you be mind to use another components!
----------------------------------------------------------------------->
<cfcomponent>
    <!--- Get the components list (like array) from path --->
    <cffunction name="getList" access="public" return="array">
        <cfargument name="path" type="string" default="" hint="Path of listing component directory">
        <cfscript>
            directory = directoryList(path, false, "path", "*.cfc", "", "file");
        </cfscript>
        <cfreturn directory>
    </cffunction>

    <!--- Only get the file names from given array of paths --->
    <cffunction name="getNames" access="public" return="array">
        <cfargument name="items" type="array" default="#[]#" hint="File path array to file names array">
        <cfscript>
            elements = ArrayMap(items, function(item) {
                return GetFileFromPath(item);
            });
        </cfscript>
        <cfreturn elements>
    </cffunction>
    
    <!--- Read and get the file content as string --->
    <cffunction name="getContent" access="public" return="string">
        <cfargument name="path" type="string" default="" hint="Path of read file">
        <cfscript>
            componentContent = trim(FileRead(path, 'utf-8'));
        </cfscript>
        <cfreturn componentContent>
    </cffunction>
    
    <!--- Parse component file description and others --->
    <cffunction name="getDescription" access="public" return="any">
        <cfargument name="path" type="string" default="" hint="Path of read file">
        <cfscript>
            result = {};
            componentContent = trim(FileRead(path, 'utf-8'));
            if (Left(componentContent, 4) eq "<!--") {
                dateMatches = ReFindNoCase("Dev Date(\s)*:(\s)*\d{1,2}[/\.]\d{1,2}[/\.]\d{2,4}", componentContent, 1, true, "one");
                if (ArrayLen(dateMatches.match) > 0)
                {
                    onlyDateMatches = ReFindNoCase("\d{1,2}[/\.]\d{1,2}[/\.]\d{2,4}", dateMatches.match[1], 1, true, "one");
                    result.devdate = onlyDateMatches.match[1];
                }
                descriptionLine = ReFindNoCase("Description\s*:", componentContent, 1, true, "one");
                if (ArrayLen(descriptionLine.match) > 0)
                {
                    matchDescription = descriptionLine.match[1];
                    strFromDescription =  right(componentContent, len(componentContent) - descriptionLine.pos[1] - descriptionLine.len[1]);
                    linesFromDescription = listToArray(strFromDescription, "#chr(13)##chr(10)#", false, true);
                    strDescription = "";
                    for (line in linesFromDescription) 
                    {
                        if (
                            (ReFindNoCase( "(Parameters|Patameters)\s*:", trim(line)) > 0)
                            or
                            (ReFindNoCase( "Used\s*:", trim(line)) > 0)
                            or
                            (ReFindNoCase( "--->*", trim(line)) > 0)
                            or
                            (ReFindNoCase( "Syntax\s*:", trim(line)) > 0)
                        )
                        {
                            break;
                        }

                        strDescription = strDescription & line & "#chr(13)##chr(10)#";
                    }
                    result.description = strDescription;
                }
               
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

    <!--- Parse component file detail as function names, params etc. --->
    <cffunction name="getDetail" access="public" return="any">
        <cfargument name="path" type="string" default="" hint="Path of read file">
        <cfscript>
            result = {};
            componentContent = trim(FileRead(path, 'utf-8'));
            posCfcomponentTag = reFindNoCase("\<cfcomponent\>", componentContent);
            if (len(posCfcomponentTag) > 0) {
                strFromCfcomponentTag = replace(replace(right(componentContent, len(componentContent) - posCfcomponentTag + 1), "<cfcomponent>", ""), "</cfcomponent>", "");
                listOfFunctions = listToArray(strFromCfcomponentTag, "</cffunction>", false, true);
                paramsOfFunctions = structNew();
                for (func in listOfFunctions)
                {
                    if (trim(func) is "") break;
                    
                    funcLineMatch = reFindNoCase("\<cffunction.*\>", func, 1, true, "one");
                    funcName = reFindNoCase('name\s*=\s*\"[\w\d]+\"', funcLineMatch.match[1], 1, true, "one").match[1];
                    funcName = replace(funcName, '"', "", "all"); 
                    funcNameParts = listToArray(funcName, "=", false, false);
                    funcName = funcNameParts[2];
                    paramsOfFunctions[funcName] = structNew();
                    
                    paramLineMatches = reFindNoCase('\<cfargument[\w\s\d\"\=]*\>', func, 1, true, "all");
                    for (pline in paramLineMatches)
                    {
                        if (pline.len[1] == 0) continue;
                        
                        pmatch = pline.match[1];
                        
                        // argument name
                        pName = reFindNoCase('name\s*=\s*\"[\w\d_]+\"', pmatch, 1, true, "one").match[1];
                        pName = replace(pName, '"', "", "all");
                        pNameParts = listToArray(pName, "=", false, false);
                        pName = pNameParts[2];
                        paramsOfFunctions['#funcName#']['#pName#'] = structNew();

                        // argument type
                        pTypeRe = reFindNoCase('type\s*=\s*\"[\w\d]+\"', pmatch, 1, true, "one");
                        if (ArrayLen(pTypeRe.match) > 0 and pTypeRe.match[1] != "")
                        {
                            pType = pTypeRe.match[1];
                            pType = replace(pType, '"', "", "all");
                            pTypeParts = listToArray(pType, "=", false, false);

                            paramsOfFunctions['#funcName#']['#pName#']['type'] = pTypeParts[2];
                        }
                        else 
                        {
                            paramsOfFunctions['#funcName#']['#pName#']['type'] = "any";
                        }

                        // required
                        pRequiredRe = reFindNoCase('required\s*\"[\w\d]+\"', pmatch, 1, true, "one");
                        if (ArrayLen(pRequiredRe.match) > 0 and pRequiredRe.match[1] != "")
                        {
                            pRequired = pRequiredRe.match[1];
                            pRequired = replace(pRequired, '"', "", "all");
                            pRequiredParts = listToArray(pRequired, "=", false, false);

                            paramsOfFunctions['#funcName#']['#pName#']['required'] = pRequiredParts[2];
                        }
                        else 
                        {
                            paramsOfFunctions['#funcName#']['#pName#']['required'] = "no";                            
                        }

                        // hint
                        pHintRe = reFindNoCase('hint\s*=\s*\"[\w\d\s]+\"', pmatch, 1, true, "one");
                        if (ArrayLen(pHintRe.match) > 0 and pHintRe.match[1] != "")
                        {
                            pHint = pHintRe.match[1];
                            pHint = replace(pHint, '"', "", "all");
                            pHintParts = listToArray(pHint, "=", false, false);

                            paramsOfFunctions['#funcName#']['#pName#']['hint'] = pHintParts[2];
                        }
                        else
                        {
                            paramsOfFunctions['#funcName#']['#pName#']['hint'] = "";
                        }
                    }

                    result.funcs = paramsOfFunctions;
                }
            }
        </cfscript>
        <cfreturn result>
    </cffunction>
</cfcomponent>