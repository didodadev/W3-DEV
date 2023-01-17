<cfinclude template="vars.cfm">

<!--- Read Element --->
<cffunction name="readElement" access="private" returntype="any" output="no">
	<cfargument name="scoID" type="numeric" required="yes">
    <cfargument name="varName" type="string" required="yes">
    <cfargument name="returnRecordCount" type="boolean" required="no" default="false">
    
    <cfif SESSION_IS_GUEST eq true><cfreturn ""></cfif>
    
    <cfquery name="get_value" datasource="#APPLICATION_DB#">
    	SELECT 
        	VAR_VALUE 
		FROM 
        	#TABLE_SCO_DATA# 
		WHERE 
        	SCO_ID = <cfqueryparam value="#arguments.scoID#" cfsqltype="cf_sql_bigint"> AND 
            VAR_NAME = <cfqueryparam value="#arguments.varName#" cfsqltype="cf_sql_varchar"> AND 
            USER_TYPE = <cfqueryparam value="#Evaluate(SESSION_USER_TYPE)#" cfsqltype="cf_sql_integer"> AND
            USER_ID = <cfqueryparam value="#Evaluate(SESSION_USER_ID)#" cfsqltype="cf_sql_integer">
    </cfquery>
    
    <cfif arguments.returnRecordCount eq true>
    	<cfreturn get_value.recordCount>
    <cfelse>
    	<cfset elementValue = "">
		<cfif get_value.recordCount eq 0>
            <cfset initElement(scoID: arguments.scoID, varName: arguments.varName, varValue: elementValue)>
        <cfelse>
            <cfset elementValue = get_value.VAR_VALUE>
        </cfif>
        
        <cfreturn elementValue>
    </cfif>
</cffunction>

<!--- Init Element --->
<cffunction name="initElement" access="private" returntype="any" output="no">
	<cfargument name="scoID" type="numeric" required="yes">
    <cfargument name="varName" type="string" required="yes">
    <cfargument name="varValue" type="string" required="yes">
        
    <cfif SESSION_IS_GUEST eq false and readElement(scoID: arguments.scoID, varName: arguments.varName, returnRecordCount: true) eq 0>
    	<cfset arguments.varValue = checkSpecificDefault(varName: arguments.varName, varValue: arguments.varValue)>
    
    	<cfquery name="set_value" datasource="#APPLICATION_DB#">
            INSERT INTO
                #TABLE_SCO_DATA# 
            	(
                	SCO_ID,
                    VAR_NAME,
                    VAR_VALUE,
                    USER_TYPE,
                    USER_ID,
					RECORD_DATE
                )
                VALUES
                (
	                <cfqueryparam value="#arguments.scoID#" cfsqltype="cf_sql_bigint">,
                    <cfqueryparam value="#arguments.varName#" cfsqltype="cf_sql_varchar">,
                    N'#arguments.varValue#',<!---<cfqueryparam value="#arguments.varValue#" cfsqltype="cf_sql_varchar">,--->
                    <cfqueryparam value="#Evaluate(SESSION_USER_TYPE)#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#Evaluate(SESSION_USER_ID)#" cfsqltype="cf_sql_integer">,
					#NOW()#
                )
        </cfquery>
    </cfif>
</cffunction>

<!--- Write Element --->
<cffunction name="writeElement" access="private" returntype="any" output="no">
	<cfargument name="scoID" type="numeric" required="yes">
    <cfargument name="varName" type="string" required="yes">
    <cfargument name="varValue" type="string" required="yes">
    
    <cfif SESSION_IS_GUEST eq false>
		<cfset arguments.varValue = checkSpecificDefault(varName: arguments.varName, varValue: arguments.varValue)>
        
        <cfif readElement(scoID: arguments.scoID, varName: arguments.varName, returnRecordCount: true) eq 0>
            <cfset initElement(scoID: arguments.scoID, varName: arguments.varName, varValue: arguments.varValue)>
        <cfelse>
            <cfquery name="set_value" datasource="#APPLICATION_DB#">
                UPDATE
                    #TABLE_SCO_DATA# 
                SET
                    VAR_VALUE = N'#arguments.varValue#' <!---<cfqueryparam value="#arguments.varValue#" cfsqltype="cf_sql_varchar">--->
                WHERE
                    SCO_ID = <cfqueryparam value="#arguments.scoID#" cfsqltype="cf_sql_bigint"> AND
                    VAR_NAME = <cfqueryparam value="#arguments.varName#" cfsqltype="cf_sql_varchar"> AND
                    USER_TYPE = <cfqueryparam value="#Evaluate(SESSION_USER_TYPE)#" cfsqltype="cf_sql_integer"> AND
                    USER_ID = <cfqueryparam value="#Evaluate(SESSION_USER_ID)#" cfsqltype="cf_sql_integer">
            </cfquery>
        </cfif>
	</cfif>
</cffunction>

<!--- Init SCO --->
<cffunction name="initSCO" access="private" returntype="any" output="no">
	<cfargument name="scoID" type="numeric" required="yes">
    
    <cfquery name="get_version" datasource="#APPLICATION_DB#">
    	SELECT VERSION FROM #TABLE_SCO# WHERE SCO_ID = <cfqueryparam value="#arguments.scoID#" cfsqltype="cf_sql_bigint">
    </cfquery>
    
    <cfquery name="get_vars" datasource="#APPLICATION_DB#">
    	SELECT VAR_NAME, VAR_VALUE FROM #TABLE_SCO_DATA# WHERE SCO_ID = <cfqueryparam value="#arguments.scoID#" cfsqltype="cf_sql_bigint"> AND USER_TYPE = <cfqueryparam value="#Evaluate(SESSION_USER_TYPE)#" cfsqltype="cf_sql_integer"> AND USER_ID = <cfqueryparam value="#Evaluate(SESSION_USER_ID)#" cfsqltype="cf_sql_integer">
    </cfquery>
    
    <cfquery name="get_objectives" datasource="#APPLICATION_DB#">
    	SELECT OBJ_NAME FROM #TABLE_SCO_OBJ# WHERE SCO_ID = <cfqueryparam value="#arguments.scoID#" cfsqltype="cf_sql_bigint"> ORDER BY OBJ_ID
    </cfquery>
    
    <cfset initCache = "var cache = new Object(); ">
    
    <cfif get_vars.recordCount eq 0>
    	<cfset userIDVarName = getVarName(tag: "userID", version: get_version.VERSION)>
	    <cfset usernameVarName = getVarName(tag: "username", version: get_version.VERSION)>
        <cfset objVarName = getVarName(tag: "objectives", version: get_version.VERSION)>
		<cfset objCountVarName = getVarName(tag: "objectiveCount", version: get_version.VERSION)>
    
	    <cfset initElement(scoID: arguments.scoID, varName: PARAM_NAME_VERSION, varValue: get_version.VERSION)>
        <cfset initElement(scoID: arguments.scoID, varName: PARAM_NAME_USER_TYPE, varValue: Evaluate(SESSION_USER_TYPE))>
   	 	<cfset initElement(scoID: arguments.scoID, varName: userIDVarName, varValue: Evaluate(SESSION_USER_ID))>
        <cfset initElement(scoID: arguments.scoID, varName: usernameVarName, varValue: '#Evaluate(SESSION_USER_NAME)# #Evaluate(SESSION_USER_SURNAME)#')>
        <cfif get_objectives.recordCount neq 0>
			<cfset initElement(scoID: arguments.scoID, varName: objCountVarName, varValue: get_objectives.recordCount)>
            <cfset initCache = "#initCache#cache['#objCountVarName#'] = '#get_objectives.recordCount#'; ">
            <cfloop query="get_objectives">
            	<cfset initElement(scoID: arguments.scoID, varName: "#objVarName#.#get_objectives.currentRow - 1#.id", varValue: get_objectives.OBJ_NAME)>
                <cfset initCache = "#initCache#cache['#objVarName#.#get_objectives.currentRow - 1#.id'] = '#get_objectives.OBJ_NAME#'; ">
            </cfloop>
		</cfif>
        
        <cfset initCache = "#initCache#cache['#PARAM_NAME_VERSION#'] = '#get_version.VERSION#'; ">
        <cfset initCache = "#initCache#cache['#PARAM_NAME_USER_TYPE#'] = '#Evaluate(SESSION_USER_TYPE)#'; ">
        <cfset initCache = "#initCache#cache['#userIDVarName#'] = '#Evaluate(SESSION_USER_ID)#'; ">
        <cfset initCache = "#initCache#cache['#usernameVarName#'] = '#Evaluate(SESSION_USER_NAME)# #Evaluate(SESSION_USER_SURNAME)#'; ">
    </cfif>
    
    <cfloop query="get_vars">
    	<cfset initCache = "#initCache#cache['#get_vars.VAR_NAME#'] = '#get_vars.VAR_VALUE#'; ">
    </cfloop>
    
    <cfreturn initCache>
</cffunction>

<!--- Check Specific Default --->
<cffunction name="checkSpecificDefault" access="private" returntype="any" output="no">
	<cfargument name="varName" returntype="string" required="yes">
    <cfargument name="varValue" returntype="string" required="yes">
    
    <!-- Check defaults for specific variables if possible --->
	<cfif len(arguments.varName) gte 7 and right(arguments.varName, 7) eq "._count" and len(arguments.varValue) eq 0>
        <cfset arguments.varValue = "0">
    </cfif>
    
    <cfreturn arguments.varValue>
</cffunction>

<!--- Get Element Name Depending The Version --->
<cffunction name="getVarName" access="private" returntype="any" output="no">
	<cfargument name="tag" returntype="string" required="yes">
    <cfargument name="version" returntype="string" required="yes">
    
    <cfif arguments.version is "1.3">
    	<cfswitch expression="#arguments.tag#">
	        <cfcase value="userID"><cfreturn "cmi.learner_id"></cfcase>
        	<cfcase value="username"><cfreturn "cmi.learner_name"></cfcase>
            <cfcase value="sessionTime"><cfreturn "cmi.session_time"></cfcase>
            <cfcase value="totalTime"><cfreturn "cmi.total_time"></cfcase>
            <cfcase value="score"><cfreturn "cmi.score.raw"></cfcase>
            <cfcase value="completionStatus"><cfreturn "cmi.completion_status"></cfcase>
            <cfcase value="successStatus"><cfreturn "cmi.success_status"></cfcase>
            <cfcase value="progress"><cfreturn "cmi.progress_measure"></cfcase>
            <cfcase value="objectives"><cfreturn "cmi.objectives"></cfcase>
            <cfcase value="objectiveCount"><cfreturn "cmi.objectives._count"></cfcase>
            <cfcase value="comments"><cfreturn "cmi.comments_from_learner"></cfcase>
            <cfcase value="commentCount"><cfreturn "cmi.comments_from_learner._count"></cfcase>
            <cfcase value="entry"><cfreturn "cmi.entry"></cfcase>
        </cfswitch>
   	<cfelse>
    	<cfswitch expression="#arguments.tag#">
	        <cfcase value="userID"><cfreturn "cmi.core.student_id"></cfcase>
        	<cfcase value="username"><cfreturn "cmi.core.student_name"></cfcase>
          	<cfcase value="sessionTime"><cfreturn "cmi.core.session_time"></cfcase>
         	<cfcase value="totalTime"><cfreturn "cmi.core.total_time"></cfcase>
            <cfcase value="score"><cfreturn "cmi.core.score.raw"></cfcase>
            <cfcase value="completionStatus"><cfreturn "cmi.core.lesson_status"></cfcase>
            <cfcase value="successStatus"><cfreturn "cmi.core.lesson_status"></cfcase>
            <cfcase value="progress"><cfreturn "cmi.progress_measure"></cfcase>
            <cfcase value="objectives"><cfreturn "cmi.objectives"></cfcase>
            <cfcase value="objectiveCount"><cfreturn "cmi.objectives._count"></cfcase>
            <cfcase value="comments"><cfreturn "cmi.comments"></cfcase>
            <cfcase value="entry"><cfreturn "cmi.core.entry"></cfcase>
        </cfswitch>
    </cfif>
</cffunction>

<!--- Add SCO --->
<cffunction name="addContent" access="private" returntype="any" output="no">
	<cfargument name="data" type="any" required="yes">
    <cfargument name="classID" type="any" required="yes">

	
    <!-- Upload file -->
    <cffile action="upload" fileField="form.uploadedContent" destination="#UPLOAD_DIR_LONG#" nameconflict="overwrite" result="uploadResult">
                        
    <!-- Create random folder name for uploaded content -->       
    <cfset contentDir = CreateUUID()>
    <cfdirectory action="create" directory="#UPLOAD_DIR_LONG##contentDir#">
	
	<!-- Unzip uploaded file into new folder -->
    <!---
	<cfif IsDefined("unzip")>
        <cfzip action="unzip" destination="#UPLOAD_DIR_LONG##contentDir#\" file="#uploadResult.serverDirectory#\#uploadResult.serverFile#" overwrite="yes"> 

        <!-- Delete zip file -->
        <cffile action="delete" file="#uploadResult.serverDirectory#\#uploadResult.serverFile#">
    </cfif>
	--->
	
	<cfzip action="unzip" destination="#UPLOAD_DIR_LONG##contentDir#\" file="#uploadResult.serverDirectory#\#uploadResult.serverFile#" overwrite="yes"> 
	<!-- Delete zip file -->
	<cffile action="delete" file="#uploadResult.serverDirectory#\#uploadResult.serverFile#">
	
    <!-- Detect manifest file -->
    <cfdirectory action="list" recurse="yes" name="manifestDir" directory="#UPLOAD_DIR_LONG##contentDir#" filter="imsmanifest.xml">
    <cfset manifestPath = "#UPLOAD_DIR_LONG##right(manifestDir.directory[1], len(manifestDir.directory[1]) - len(UPLOAD_DIR_LONG))#\imsmanifest.xml">
    <!-- Get content informations -->
    <cfset xmlFile = xmlParse(manifestPath, false)>
    <cfset contentTitle = xmlFile.manifest.organizations.organization.title.xmlText>
    <cfset contentVersion = right(xmlFile.manifest.xmlAttributes['xmlns:adlcp'], 4)>
    <cfset contentVersion = replace(contentVersion, "v", "")>
    <cfset contentVersion = replace(contentVersion, "p", ".")>
    <!---<cfset contentStartPath = "#UPLOAD_DIR_LONG##right(manifestDir.directory[1], len(manifestDir.directory[1]) - len(expandPath(UPLOAD_DIR_SHORT)))#\">--->
	<cfset contentStartPath = "#UPLOAD_DIR_SHORT##right(manifestDir.directory[1], len(manifestDir.directory[1]) - len(expandPath(UPLOAD_DIR_SHORT)))#\">
	       
    <cfset count = 1>
    <cfloop condition="count lte StructCount(xmlFile.manifest.resources)">       
    	<cfset res = xmlFile.manifest.resources.resource[count]>
        <cftry>
			<cfif res.xmlAttributes['adlcp:scormType'] is "sco">
                <cfset contentStartPath = "#contentStartPath##replaceList(res.xmlAttributes.href, '/', '\')#">
                <cfbreak>
            </cfif>
            
            <cfcatch></cfcatch>
        </cftry>
        <cfset count = count + 1>
    </cfloop>
    
    <!-- Add content info to the db -->
    <cfquery name="add_content" datasource="#APPLICATION_DB#" result="addContentResult">
    	INSERT INTO
        	#TABLE_SCO#
            (
            	CLASS_ID,
            	NAME,
                VERSION,
                SCO_DIR,
                START_FILE,
                MANIFEST_FILE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
            )
            VALUES
            (
            	<cfqueryparam value="#arguments.classID#" cfsqltype="cf_sql_integer">,
            	<cfqueryparam value="#contentTitle#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#contentVersion#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#UPLOAD_DIR_SHORT##contentDir#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#contentStartPath#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#manifestPath#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#cgi.REMOTE_ADDR#" cfsqltype="cf_sql_varchar">
            )
    </cfquery>
    
    <!-- Get objectives -->
    <cftry>
    	<cfset objectives = xmlSearch(xmlFile, "//imsss:objective")>
        <cfloop from="1" to="#arrayLen(objectives)#" index="i">
            <cfquery name="insert_objective" datasource="#APPLICATION_DB#">
                INSERT INTO
                    #TABLE_SCO_OBJ#
                    (
                        SCO_ID,
                        OBJ_NAME,
                        OBJ_HREF
                    )
                    VALUES
                    (
                        <cfqueryparam value="#addContentResult.identityCol#" cfsqltype="cf_sql_bigint">,
                        <cfqueryparam value="#objectives[i].xmlAttributes.objectiveID#" cfsqltype="cf_sql_varchar">,
                        ''
                    )
            </cfquery>
        </cfloop>
    
    	<cfcatch><!-- nothing --></cfcatch>
    </cftry>
    
    <cfreturn true>
</cffunction>

<!--- Transform Time --->
<cffunction name="transformTime" access="private" returntype="any" output="no">
	<cfargument name="time" type="string" required="yes">
    
    <cfif find(":", arguments.time) eq 0>
    	<cfset arguments.time = lCase(arguments.time)>
		<cfset arguments.time = replaceList(arguments.time, "pt", "")>
        
		<cfif find("h", arguments.time) eq 0><cfset arguments.time = "0h#arguments.time#"></cfif>
        <cfset arguments.time = replaceList(arguments.time, "h", ":")>
        <cfif find("m", arguments.time) eq 0><cfset arguments.time = "0m#arguments.time#"></cfif>
        <cfset arguments.time = replaceList(arguments.time, "m", ":")>
        <cfset arguments.time = replaceList(arguments.time, "s", "")>
    </cfif>
    
    <cfreturn arguments.time>
</cffunction>
