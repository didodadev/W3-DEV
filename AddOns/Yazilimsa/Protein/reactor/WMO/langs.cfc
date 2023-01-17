<cfcomponent>
	<cfsetting requesttimeout="2000">
    <cffunction name="langSet" access="remote" returntype="struct">
    	<cfargument name="datasource" default="#dsn#" cachedWithin="#createTimeSpan( 1, 0, 0, 0 )#">
        <cfset langs = langsAll(arguments.datasource)>
    	<cfquery name="GET_LANGS" datasource="#arguments.datasource#">
        	SELECT
                DICTIONARY_ID,
            	ITEM_ID,
                MODULE_ID,
                <cfoutput>
                    <cfloop index="indLang" from="1" to="#listlen(langs,',')#">
                    	ITEM_#UCase(listGetAt(langs,indLang,','))#
                        <cfif indLang neq listlen(langs,',')>
                        	,
                        </cfif>
                    </cfloop>
                </cfoutput>
            FROM
            	SETUP_LANGUAGE_TR
        </cfquery>
        <cflock scope="APPLICATION" type="EXCLUSIVE" timeout="20">
			<cfscript>
                application.langArray = structNew();
				application.langArrayAll = structNew();
                for(i=1;i<=GET_LANGS.recordcount;i++)
                {
					strList = '';
					for(k=1;k<=listLen(langs,',');k++)
					{
						name = '#UCase(listgetat(langs,k,','))#';
						if(len(strList))
							strList = strList & '█' & evaluate('GET_LANGS.ITEM_#name#[i]');
						else
							strList = evaluate('GET_LANGS.ITEM_#name#[i]');
						
						application.langArray[GET_LANGS.MODULE_ID[i]][GET_LANGS.ITEM_ID[i]] = strList;
						application.langArrayAll[GET_LANGS.DICTIONARY_ID[i]] = strList;
					}
                }
            </cfscript>
        </cflock>
		<cfreturn application.langArray>
    </cffunction>
    <cffunction name="langsAll" access="remote" returntype="string">
    	<cfargument name="datasource" default="#dsn#">
		<cfquery name="GET_LANGS_ALL" datasource="#arguments.datasource#">
        	SELECT
            	LANGUAGE_SHORT
			FROM
            	SETUP_LANGUAGE
			WHERE
            	IS_ACTIVE = 1
			ORDER BY
            	LANGUAGE_ID
        </cfquery>
        <cfset application.langsAllList = valuelist(GET_LANGS_ALL.LANGUAGE_SHORT)>
        <cfreturn application.langsAllList>
    </cffunction>
</cfcomponent>
