<cfif isdefined("attributes.is_home") and not isdefined("attributes.contentcat_id")> 
	<cfquery name="GET_CAT" datasource="#DSN#">
		SELECT 
			CONTENTCAT,
			CONTENTCAT_ID 
		FROM 
			CONTENT_CAT 
		WHERE 
			IS_RULE = 1 AND 
        <cfif isDefined('session.ep.userid')>
        	LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
		<cfelse>
        	LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pda.language#">        
        </cfif>
	</cfquery>
	<cfif get_cat.recordcount>
		<cfset attributes.contentcat_id = get_cat.contentcat_id>
	</cfif>
</cfif>

<cfquery name="GET_LIT_NAMES" datasource="#DSN#">
	SELECT
		CONTENTCAT,
		CONTENTCAT_ID 
	FROM
		CONTENT_CAT
	WHERE		
	<cfif isDefined('session.ep.userid')>
		LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	<cfelse>
		LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pda.language#">        
	</cfif>
	ORDER BY
		CONTENTCAT ASC
</cfquery>
<cfquery name="GET_CHAPTER" datasource="#DSN#">
	SELECT * FROM CONTENT_CHAPTER
</cfquery>
<cfoutput query="get_lit_names">
    <ul class="box_menus">
        <li>             
            <cfif isDefined('session.ep.userid')>
                <a href="#request.self#?fuseaction=rule.view_category&contentcat_id=#contentcat_id#"><b>#contentcat#</b></a>
            <cfelse>
                <a href="#request.self#?fuseaction=#attributes.fuseaction#&contentcat_id=#contentcat_id#"><b>#contentcat#</b></a>                
            </cfif>
            <cfquery name="GET_CHAPTER_" dbtype="query">
                SELECT CHAPTER_ID,CONTENTCAT_ID,CHAPTER,HIERARCHY FROM GET_CHAPTER WHERE CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_lit_names.contentcat_id#"> ORDER BY CHAPTER ASC
            </cfquery>
            <ul>
                <cfloop query="get_chapter_">
                    <li>
                    <cfif isDefined('session.ep.userid')>
                        <a href="#request.self#?fuseaction=rule.view_chapter&chapter_id=#chapter_id#&contentcat_id=#contentcat_id#">
                    <cfelse>
                        <a href="#request.self#?fuseaction=#attributes.fuseaction#&chapter_id=#chapter_id#&contentcat_id=#contentcat_id#">                
                    </cfif>	
                        <cfif listlen(hierarchy) is 1>
                            <cfif hierarchy eq get_chapter.hierarchy>#chapter#<cfelse>#chapter#</cfif>
                        <cfelseif listlen(hierarchy) is 2>
                            <cfif hierarchy eq get_chapter.hierarchy>#chapter#<cfelse>#chapter#</cfif>
                        <cfelseif listlen(hierarchy) is 3>
                            <cfif hierarchy eq get_chapter.hierarchy>#chapter#<cfelse>#chapter#</cfif>
                        <cfelseif listlen(hierarchy) is 4>
                            <cfif hierarchy eq get_chapter.hierarchy>#chapter#<cfelse>#chapter#</cfif>
                        </cfif>
                        </a>
                    </li>
                </cfloop>
            </ul>
        </li>
    </ul>
</cfoutput>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>