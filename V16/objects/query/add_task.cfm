<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.updForm')>
	<cfset columns = "">
    <cfset values = "">
    <cfset count = attributes.count>
    <cfset taskId = attributes.taskId>
<cfoutput>
	<cfif len(attributes.datasource) and attributes.datasource is not ','>
        <cfset allDsn = attributes.datasource>
    <cfelse>
        <cfset allDsn = DSN>
    </cfif>
    <cfquery datasource="#allDsn#">
        UPDATE #attributes.tableNames# SET 
        <cfloop from="1" to="10" index="i">
			<cfif isdefined("attributes.column#i#") and ListGetAt(Evaluate("attributes.column#i#"),3) neq 'static'>
				<cfset columns = ListGetAt(Evaluate("attributes.column#i#"),1)>
                <cfif ListGetAt(Evaluate("attributes.column#i#"),3) eq "checkbox">
					<cfset values = "" & count & "task" & columns>
				<cfelse>
					<cfset values = "input" & count & "task" & columns>
				</cfif>					
				<cfif listfindnocase("integer,float0,float2,float4",ListGetAt(Evaluate("attributes.column#i#"),4))>
                    <cfset deger_ = Evaluate("attributes.#values#")>
                <cfelseif ListGetAt(Evaluate("attributes.column#i#"),3) eq "checkbox" and isdefined("attributes.c#values#")>
                    <cfset deger_ = 1>
                <cfelseif ListGetAt(Evaluate("attributes.column#i#"),3) eq "checkbox" and not isdefined("attributes.c#values#")>       
                    <cfset deger_ = 0>
                <cfelseif ListGetAt(Evaluate("attributes.column#i#"),4) eq "string">
                    <cfset deger_ = Evaluate("attributes.#values#")>
                <cfelseif ListGetAt(Evaluate("attributes.column#i#"),4) eq "datetime" >
                    <cfset dateTime = Evaluate("attributes.#values#")>
                    <cf_date tarih="dateTime">
                    <cfset deger_ = dateTime> 
                </cfif>
                #columns# = <cfif ListGetAt(Evaluate("attributes.column#i#"),4) eq "string" and ListGetAt(Evaluate("attributes.column#i#"),3) neq "checkbox"><cfqueryparam cfsqltype="cf_sql_varchar" value="#deger_#"><cfelse><cfif len(deger_)>#deger_#<cfelse>NULL</cfif></cfif><cfif isdefined("attributes.column#i+1#")>,</cfif>
            </cfif>
        </cfloop>
    <cfif attributes.userInfos eq 1>
        ,UPDATE_EMP = #session.ep.userid#,
        UPDATE_IP = '#cgi.remote_addr#',
		<cfset dateTime = Now()>
        UPDATE_DATE= #dateTime#
    </cfif>
    where #attributes.key# = #taskId#
    </cfquery>
	<cfloop from="1" to="10" index="i">
		<cfif isdefined("form.column#i#") and listfindnocase("text,textarea",ListGetAt(Evaluate("column#i#"),3))>
			<cfset column_name = #ListGetAt(Evaluate("form.column#i#"),1)#>
			<cfset input_suffix = "input" & form.count & "task" & column_name>
            <cfquery name="get_langs" datasource="#dsn#">
                SELECT LANGUAGE_SHORT FROM SETUP_LANGUAGE WHERE LANGUAGE_SHORT <> '#lang_list#'
            </cfquery>
			<cfset lang_list_ = valuelist(get_langs.language_short)>
	
			<cfloop list="#lang_list_#" index="lang" delimiters=",">
				<cfset inputLangValue = Evaluate('form.#input_suffix#_#lang#')>
				<cfif not inputLangValue is "">
					<cfquery datasource="#dsn#" name="eof">
						SELECT
							*
						FROM 
							SETUP_LANGUAGE_INFO_SETTINGS 
						WHERE
							COMPANY_ID = #session.ep.company_id# AND
            				PERIOD_ID = #session.ep.period_id# AND
                            UNIQUE_COLUMN_ID = #form.taskId# AND
							LANGUAGE = '#lang#' AND
							COLUMN_NAME = '#column_name#' AND
							TABLE_NAME = '#form.tableNames#'					
					</cfquery>
					<cfif eof.recordcount gt 0>
						<cfquery datasource="#dsn#" name="add_">
							UPDATE 
								SETUP_LANGUAGE_INFO_SETTINGS 
							SET
								ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#inputLangValue#">
							WHERE
								COMPANY_ID = #session.ep.company_id# AND
            					PERIOD_ID = #session.ep.period_id# AND
                                UNIQUE_COLUMN_ID = #form.taskId# AND
								LANGUAGE = '#lang#' AND
								COLUMN_NAME = '#column_name#' AND
								TABLE_NAME = '#form.tableNames#'
						</cfquery>
					<cfelse>
						<cfquery datasource="#dsn#" name="add_">
							INSERT INTO
								SETUP_LANGUAGE_INFO_SETTINGS
								(
									COMPANY_ID,
            						PERIOD_ID,
                                    TABLE_NAME,
									COLUMN_NAME,
									LANGUAGE,
									ITEM,
									UNIQUE_COLUMN_ID
								)
								VALUES(
									#session.ep.company_id#,
                                    #session.ep.period_id#,
                                    '#form.tableNames#',
									'#column_name#',
									'#lang#',
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#inputLangValue#">,
									#form.taskId#								
								)
						</cfquery>				
					</cfif>
				</cfif>
			</cfloop>
		
		</cfif>
	</cfloop>
</cfoutput>
</cfif>
<cfif isdefined('form.saveForm')>
	<cfif len(form.datasource)>
        <cfset allDsn = form.datasource>
    <cfelse>
        <cfset allDsn = DSN>
    </cfif>
	<cfset columns = "">
    <cfset values = "">
    <cfloop from="1" to="10" index="i">
        <cfif isdefined("form.column#i#") and ListGetAt(Evaluate("form.column#i#"),3) neq 'static'>
		   <cfset columns = '#columns#,'& ListGetAt(Evaluate("form.column#i#"),1)>
           <cfif ListGetAt(Evaluate("form.column#i#"),4) eq "string">
                <cfoutput><cfset values = '#values#,'&"task"&#ListGetAt(Evaluate("form.column#i#"),1)# ></cfoutput>
           </cfif>
        </cfif>
     </cfloop>
     <cfquery datasource="#allDsn#" name="addTask">
	 <cfoutput>
         INSERT INTO #form.tableNames# 
         (
           #Right(columns,Len(columns)-1)#
            <cfif form.userInfos eq 1>
				,RECORD_EMP,
                RECORD_IP,
                RECORD_DATE
			</cfif>
         )
         VALUES
         (
             <cfloop from="1" to="10" index="i">
               <cfif isdefined("form.column#i#") and ListGetAt(Evaluate("form.column#i#"),3) neq 'static'>
               		<cfif ListGetAt(Evaluate("form.column#i#"),4) eq "string" AND ListGetAt(Evaluate("form.column#i#"),3) eq "checkbox">
							<cfset values = "task"&#ListGetAt(Evaluate("form.column#i#"),1)# >
                            <cfif isdefined("form.#values#")>1<cfelse>0</cfif><cfif isdefined("form.column#i+1#")>,</cfif>
                    <cfelseif ListGetAt(Evaluate("form.column#i#"),4) eq "string">
                            <cfset values = "task"&#ListGetAt(Evaluate("form.column#i#"),1)#>
                            '#Evaluate("form.#values#")#'<cfif isdefined("form.column#i+1#")>,</cfif>
                   <cfelseif listfindnocase("integer,float0,float2,float4",ListGetAt(Evaluate("form.column#i#"),4))>
                            <cfset values = "task"&#ListGetAt(Evaluate("form.column#i#"),1)#>
                            <cfif len(Evaluate("form.#values#"))>#Evaluate("form.#values#")#<cfelse>NULL</cfif><cfif isdefined("form.column#i+1#")>,</cfif>
                   <cfelseif ListGetAt(Evaluate("form.column#i#"),4) eq "datetime" >
                            <cfset values = "task"&#ListGetAt(Evaluate("form.column#i#"),1)# >
                            <cfset dateTime = Evaluate("form.#values#")>
                            <cfif len(dateTime)>
								<cf_date tarih="dateTime">#dateTime#<cfif isdefined("form.column#i+1#")>,</cfif>
							<cfelse>
								NULL<cfif isdefined("form.column#i+1#")>,</cfif>
							</cfif> 
				   </cfif>
               </cfif>
            </cfloop>   
            <cfif form.userInfos eq 1>
				,#session.ep.userid#,
                '#cgi.remote_addr#',
                <cfset dateTime = Now()>
                #dateTime#
			</cfif>
         )
	 </cfoutput>
</cfquery>
<cfelseif isdefined("url.is_delete") AND isdefined("url.tableName") AND isdefined("url.key")>
    <cfif len(url.datasource) and url.datasource is not ','>
        <cfset allDsn = url.datasource>
    <cfelse>
        <cfset allDsn = DSN>
    </cfif>
	<cfquery name="delLang" datasource="#dsn#">
		DELETE FROM 
			SETUP_LANGUAGE_INFO_SETTINGS
		WHERE
			COMPANY_ID = #session.ep.company_id# AND
            PERIOD_ID = #session.ep.period_id# AND
            UNIQUE_COLUMN_ID = #url.is_delete# AND
			TABLE_NAME = '#url.tableName#'		
	</cfquery>
		
    <cfquery name="delTask" datasource="#allDsn#">
        DELETE
        FROM
            #url.tableName#
        WHERE
            #url.key# = #url.is_delete#		
	</cfquery>
</cfif>
