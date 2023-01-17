<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: 			            Developer	: Halit Yurttaş		
Analys Date : 00/00/0000			Dev Date	: 25/06/2018		
Description :
	Take custom tag information from given file name that only parse from 'CustomTags' folder. Please extends another custom tags folder if you want it
----------------------------------------------------------------------->
<cfcomponent>
    <!--- Get custom tags file list (like array) from CustomTags folder --->
    <cffunction name="getList" access="public" return="array">
        <cfscript>
            directory = directoryList(ExpandPath( "./" ) & "\CustomTags\", false, "path", "*.cfc|*.cfm", "", "file");
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
            componentContent = trim(FileRead(ExpandPath( "./" ) & "\CustomTags\" & path, 'utf-8'));
        </cfscript>
        <cfreturn componentContent>
    </cffunction>

    <!--- Parse custom tag file content as string --->
    <cffunction name="getDescription" access="public" return="string">
        <cfargument name="path" type="string" default="" hint="Path of read file">
        <cfscript>
            result = {};
            componentContent = trim(FileRead(path, 'utf-8'));
            if (Left(trim(componentContent), 4) eq "<!--") {
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
                else
                {
                    result.description = "";
                }
            }
            else
            {
                result.description = "";
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

    <!--- Parse parameters from given custom tag file content as object --->
    <cffunction name="getDetail" access="public" return="any">
        <cfargument name="path" type="string" default="" hint="Path of read file">
        <cfscript>
            result = {};
            componentContent = trim(FileRead(ExpandPath( "./" ) & "\CustomTags\" & path, 'utf-8'));
            
            //find parameters
            paramMatches = reFindNoCase('\<cfparam[\w\s\d\"\=\.\_]*\>', componentContent, 1, true, "all");
            listOfParam = [];
            for (i=1;i<=arrayLen(paramMatches);i++)
            {
                pLine = paramMatches[i];

                if (pLine.len[1] == 0) continue;

                pMathch = pLine.match[1];

                // parameter name
                pName = reFindNoCase('name\s*=\s*\"[\w\d\._]+\"', pMathch, 1, true, "one").match[1];
                pName = replace(pName, '"', "", "all");
                pNameParts = listToArray(pName, "=", false, false);
                pName = pNameParts[2];
                pName = replace(pName, "attributes.", "", "all");
                listOfParam[arrayLen(listOfParam) + 1] = pName;

            }
            result.params = listOfParam;
            
            //find attributes
            attribMatches = reFindNoCase('attributes\.[\w\d\_\.]+', componentContent, 1, true, "all");
            listOfAttrib = [];
            for (i=1;i<=arrayLen(attribMatches);i++)
            {
                pLine = attribMatches[i];

                if (pLine.len[1] == 0) continue;

                pMathch = pLine.match[1];
                pName = replace(pMathch, "attributes.", "", "all");
                
                if (ArrayContains(listOfAttrib, pName)) continue;

                listOfAttrib[arrayLen(listOfAttrib) + 1] = pName;
            }

            result.attrs = listOfAttrib;

        </cfscript>
        <cfreturn result>
    </cffunction>
</cfcomponent>