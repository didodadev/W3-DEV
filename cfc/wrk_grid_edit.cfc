<cfcomponent output="no">
	<cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
        getlang = functions.getlang;
	</cfscript>
<cfinclude template="../fbx_workcube_funcs.cfm">
<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction name="CreateGrid" access="remote" returntype="struct">
	<cfargument name="page" type="numeric" required="yes">
	<cfargument name="pageSize" type="numeric" required="yes">
	<cfargument name="gridsortcolumn" type="string" default="">
	<cfargument name="gridsortdirection" type="string">
	<cfargument name="grid_data_source" type="string" required="no" default="">
    <cfargument name="grid_table_name" type="string" required="no" default="">
    <cfargument name="grid_u_id" type="string" required="no" default="">
	<cfargument name="grid_search_areas" type="string" required="no" default="">
	<cfargument name="grid_keyword" type="string" required="no" default="">
    <cfargument name="grid_sort_column" type="string" required="no" default="">
	<cfif ARGUMENTS.gridsortdirection EQ ""><cfset ARGUMENTS.gridsortdirection = "ASC"></cfif>
	<cfquery name="get_data_type" datasource="#arguments.grid_data_source#">
		SELECT DISTINCT
			SAC.IS_IDENTITY,
			SAC.MAX_LENGTH,
			ISC.DATA_TYPE,
			ISC.COLUMN_NAME
		FROM
			INFORMATION_SCHEMA.COLUMNS ISC,
			SYS.all_columns SAC,
			SYS.tables ST,
			sys.schemas sch
		WHERE
			ISC.TABLE_NAME = '#arguments.grid_table_name#' AND
			SAC.name = ISC.COLUMN_NAME AND
			SAC.object_id = ST.object_id AND
			ST.name = ISC.TABLE_NAME
			and st.schema_Id = sch.schema_Id
			and ISC.table_schema = sch.name
			and table_schema ='#arguments.grid_data_source#'
	</cfquery>
	<cfquery name="user" datasource="#arguments.grid_data_source#">
		SELECT
			<cfoutput query="get_data_type">
				<cfset address_ = "&t_name=#arguments.grid_table_name#">
				<cfset address_ = "#address_#&c_name=#COLUMN_NAME#">
				<cfset address_ = "#address_#&c_id=#arguments.grid_u_id#">
				<cfset address_ = "#address_#&d_alias=#arguments.grid_data_source#">
				<cfset address_ = "#address_#&maxlength=#MAX_LENGTH#">
				<cfset address_ = "#address_#&c_type=0">
				<cfset address_ = "#address_#&input_type=text">
				<cfset address_ = "#address_#&c_id_value=">
				#dsn#.Get_Dynamic_Language(#arguments.grid_u_id#,'#session.ep.language#','#arguments.grid_table_name#','#COLUMN_NAME#',NULL,NULL,#COLUMN_NAME#) AS #COLUMN_NAME#,
				<cfif DATA_TYPE is 'nvarchar' or DATA_TYPE is 'ntext'>
					'<a href=javascript:// onclick=openBoxDraggable("index.cfm?fuseaction=objects.popup_ajax_list_language_info#address_#' + CAST(#arguments.grid_u_id# AS nvarchar) + '");><i class="catalyst-book-open"></i></a>' AS #COLUMN_NAME#_WRK_GRID_ML,
				</cfif>
			</cfoutput>
			ROW_NUMBER() OVER (ORDER BY <cfif ARGUMENTS.grid_sort_column neq "" and ARGUMENTS.gridsortcolumn eq "">#ARGUMENTS.grid_sort_column#<cfelse>#ARGUMENTS.gridsortcolumn#</cfif> #ARGUMENTS.gridsortdirection#) AS WRK_GRID_ROW_NO
		FROM 
			#arguments.grid_table_name#
		<cfif len(arguments.grid_search_areas) and len(arguments.grid_keyword)>
		WHERE
			<cfif listlen(arguments.grid_search_areas) gt 1>
				<cfset count_ = 0>
				(
				<cfloop list="#arguments.grid_search_areas#" index="ccc">
					<cfset count_ = count_ + 1>
					#ccc# LIKE N'%#arguments.grid_keyword#%' <cfif count_ neq listlen(arguments.grid_search_areas)>OR</cfif>
				</cfloop>
				)
			<cfelse>
				#arguments.grid_search_areas# LIKE N'%#arguments.grid_keyword#%'
			</cfif>
		</cfif>	
		ORDER BY
			<cfif ARGUMENTS.grid_sort_column neq "" and ARGUMENTS.gridsortcolumn eq "">
				#ARGUMENTS.grid_sort_column#
            <cfelse>
                #ARGUMENTS.gridsortcolumn#
            </cfif>
            #ARGUMENTS.gridsortdirection#
	</cfquery>
	<cfreturn QueryConvertForGrid(user, ARGUMENTS.page, ARGUMENTS.pageSize)>
</cffunction>
<cffunction name="CreateQuery" access="remote" returntype="query">
	<cfargument name="grid_data_source" type="string" required="no" default="">
    <cfargument name="grid_table_name" type="string" required="no" default="">
    <cfargument name="grid_sort_column" type="string" required="no" default="">
	<cfquery name="user" datasource="#arguments.grid_data_source#">
		SELECT 
			*
		FROM 
			#arguments.grid_table_name#
		ORDER BY
			#ARGUMENTS.grid_sort_column# ASC
	</cfquery>
	<cfreturn user>
</cffunction>
<cffunction name="EditGrid" access="remote" returntype = "any" returnFormat="json">
    
	<cfset gridrow = deserializeJson(arguments.gridrowjson)>
	<cfset arguments.gridrow = gridrow>
	<cfset arguments.gridchanged = gridrow>
    <cfset var colname =""/>
    <cfset var value =""/>
	<cftry>
	   <cfswitch expression="#arguments.gridaction#">
			<!---Update--->
			<cfcase value="U">
				<cfset var collist =StructKeyList(arguments.gridchanged)/>		
				<cfloop from="1" to="#listlen(collist)#" index="i">
					<cfset var colname = listgetAt(collist,i)/>
    				<cfset var value = StructFind(arguments.gridchanged,colname)/>				
					<cfquery name="get_data_type" datasource="#arguments.grid_data_source#">
						SELECT  DISTINCT
							SAC.IS_IDENTITY,
							ISC.DATA_TYPE,
							ISC.COLUMN_NAME,
							ISC.CHARACTER_MAXIMUM_LENGTH
						FROM
							INFORMATION_SCHEMA.COLUMNS ISC,
							SYS.all_columns SAC,
							SYS.tables ST
						WHERE
							ISC.TABLE_NAME = '#arguments.grid_table_name#' AND
							(
							ISC.COLUMN_NAME = '#colname#' OR
							ISC.COLUMN_NAME = 'UPDATE_EMP' OR
							ISC.COLUMN_NAME = 'UPDATE_DATE' OR
							ISC.COLUMN_NAME = 'UPDATE_IP'
							)
							AND
							SAC.name = ISC.COLUMN_NAME AND
							SAC.object_id = ST.object_id AND
							ST.name = ISC.TABLE_NAME
					</cfquery>
					<cfquery name="updEmp" datasource="#arguments.grid_data_source#">
						UPDATE 
							#arguments.grid_table_name# 
						SET  
							<cfoutput query="get_data_type">
								<cfif COLUMN_NAME is colname and DATA_TYPE is 'bit'>
									#COLUMN_NAME# = <cfif listfind('YES,Y,y,yes,1',value)>1<cfelse>0</cfif><cfif currentrow neq get_data_type.recordcount>,</cfif>
								<cfelseif COLUMN_NAME is colname and DATA_TYPE is 'nvarchar' and len(CHARACTER_MAXIMUM_LENGTH)>
									#colname# = <cfqueryparam value="#left(value,CHARACTER_MAXIMUM_LENGTH)#" /><cfif currentrow neq get_data_type.recordcount>,</cfif>
								<cfelseif COLUMN_NAME is colname  and DATA_TYPE is 'float'>
									#colname# = <cfqueryparam value="#FILTERNUM(value,4)#"  cfsqltype="cf_sql_float"/><cfif currentrow neq get_data_type.recordcount>,</cfif>
								<cfelseif COLUMN_NAME is colname>
									#colname# = <cfqueryparam value="#value#"/><cfif currentrow neq get_data_type.recordcount>,</cfif>
								<cfelseif COLUMN_NAME is 'UPDATE_DATE'>
									UPDATE_DATE = #now()#<cfif currentrow neq get_data_type.recordcount>,</cfif>
								<cfelseif COLUMN_NAME is 'UPDATE_EMP'>
									UPDATE_EMP = #arguments.grid_user_id#<cfif currentrow neq get_data_type.recordcount>,</cfif>
								<cfelseif COLUMN_NAME is 'UPDATE_IP'>
									UPDATE_IP = '#cgi.REMOTE_ADDR#'<cfif currentrow neq get_data_type.recordcount>,</cfif>
								</cfif>								
							</cfoutput>
						WHERE
							#arguments.grid_u_id# = #evaluate('arguments.#arguments.grid_u_id#')#
					</cfquery>
				</cfloop>
				<cfset returnData =1> 				
			</cfcase>
			<!---Delete--->
			<cfcase value="D">
				<cfquery name="deleteEmp" datasource="#arguments.grid_data_source#">
					DELETE 
						FROM 
							#arguments.grid_table_name#
						WHERE
							#arguments.grid_u_id# = #evaluate('#arguments.grid_u_id#')#
				</cfquery>
					<cfset returnData =1> 		
			</cfcase>
			<!---insert --->
		   <cfcase value="I">
			  <cfquery name="get_data_type" datasource="#arguments.grid_data_source#">
					SELECT  DISTINCT
						SAC.IS_IDENTITY,
						ISC.DATA_TYPE,
						ISC.COLUMN_NAME,
                        ISC.CHARACTER_MAXIMUM_LENGTH
					FROM
						INFORMATION_SCHEMA.COLUMNS ISC,
						SYS.all_columns SAC,
						SYS.tables ST,
						sys.schemas sch
					WHERE
						ISC.TABLE_NAME = '#arguments.grid_table_name#' AND
						SAC.name = ISC.COLUMN_NAME AND
						SAC.object_id = ST.object_id AND
						ST.name = ISC.TABLE_NAME
						and st.schema_Id = sch.schema_Id
						and ISC.table_schema = sch.name
						and table_schema ='#arguments.grid_data_source#'
				</cfquery>
				
				<cfset name_list = "">
				<cfset type_list = "">
                <cfset character_max_length_list = "">
				<cfoutput query="get_data_type">
					<cfif isdefined("arguments.gridrow.#COLUMN_NAME#") and IS_IDENTITY eq 0 and DATA_TYPE is 'nvarchar' and len(CHARACTER_MAXIMUM_LENGTH)>
						<cfset name_list = listappend(name_list,COLUMN_NAME)>
						<cfset type_list = listappend(type_list,DATA_TYPE)>
						<cfset character_max_length_list = listappend(character_max_length_list,CHARACTER_MAXIMUM_LENGTH)>
					<cfelseif COLUMN_NAME is 'RECORD_EMP'>
						<cfset name_list = listappend(name_list,'RECORD_EMP')>
						<cfset type_list = listappend(type_list,'int')>
                        <cfset character_max_length_list = listappend(character_max_length_list,'x')>
					<cfelseif COLUMN_NAME is 'PARAM_DATA_TYPE'>
						<cfset name_list = listappend(name_list,'PARAM_DATA_TYPE')>
						<cfset type_list = listappend(type_list,'int')>
                        <cfset character_max_length_list = listappend(character_max_length_list,'x')>
					<cfelseif COLUMN_NAME is 'RECORD_IP'>
						<cfset name_list = listappend(name_list,'RECORD_IP')>
						<cfset type_list = listappend(type_list,'nvarchar')>
                        <cfset character_max_length_list = listappend(character_max_length_list,'x')>
					<cfelseif COLUMN_NAME is 'RECORD_DATE'>
						<cfset name_list = listappend(name_list,'RECORD_DATE')>
						<cfset type_list = listappend(type_list,'datetime')>
                        <cfset character_max_length_list = listappend(character_max_length_list,'x')>
					 <cfelseif isdefined("arguments.gridrow.#COLUMN_NAME#") and (DATA_TYPE is 'int' or DATA_TYPE is 'float' or DATA_TYPE is 'bit') and IS_IDENTITY eq 0>
						<cfset name_list = listappend(name_list,COLUMN_NAME)>
						<cfset type_list = listappend(type_list,DATA_TYPE)>
						<cfset character_max_length_list = listappend(character_max_length_list,'x')>
					<cfelseif IS_IDENTITY eq 0>
                        <cfset character_max_length_list = listappend(character_max_length_list,'x')>
					</cfif>
				</cfoutput>
			   <cfquery name="insertEmp" datasource="#arguments.grid_data_source#" result="query_result">
					INSERT INTO #arguments.grid_table_name#
					(
						<cfloop from="1" to="#listlen(name_list)#" index="ccc">
							<cfset name_ = listgetat(name_list,ccc)>
							#name_#<cfif listlen(name_list) neq ccc>,</cfif>
						</cfloop>
					)
					VALUES
					(
						<cfloop from="1" to="#listlen(name_list)#" index="ccc">
							<cfset name_ = listgetat(name_list,ccc)>
							<cfset type_ = listgetat(type_list,ccc)>
							
                            <cfset character_max_length_ = listgetat(character_max_length_list,ccc)>
							<cfif type_ is 'bit'>
								<cfif listfind('YES,Y,y,yes,1',evaluate("arguments.gridrow.#name_#"))>1<cfelse>0</cfif><cfif listlen(name_list) neq ccc>,</cfif>
							<cfelseif type_ is 'float'>
								'#filternum(evaluate('arguments.gridrow.#name_#'))#'<cfif listlen(name_list) neq ccc>,</cfif>
							<cfelseif name_ is 'RECORD_EMP'>
								#arguments.grid_user_id#<cfif listlen(name_list) neq ccc>,</cfif>
							<cfelseif name_ is 'PARAM_DATA_TYPE'>
								#arguments.grid_type_#<cfif listlen(name_list) neq ccc>,</cfif>
							<cfelseif name_ is 'RECORD_DATE'>
								#now()#<cfif listlen(name_list) neq ccc>,</cfif>
							<cfelseif name_ is 'RECORD_IP'>
								'#cgi.REMOTE_ADDR#'<cfif listlen(name_list) neq ccc>,</cfif>
							<cfelseif name_ is 'UPDATE_DATE'>
								NULL<cfif listlen(name_list) neq ccc>,</cfif>
                            <cfelseif name_ is 'UPDATE_EMP'>
								NULL<cfif listlen(name_list) neq ccc>,</cfif>
                            <cfelseif name_ is 'UPDATE_IP'>
								NULL<cfif listlen(name_list) neq ccc>,</cfif>
							<cfelse>
                            	<cfif not character_max_length_ is 'x' and character_max_length_ neq -1>
                                	'#left(evaluate("arguments.gridrow.#name_#"),character_max_length_)#'
                                <cfelse>
									'#evaluate('arguments.gridrow.#name_#')#'
                                </cfif>
                                <cfif listlen(name_list) neq ccc>,</cfif>
							</cfif>
						</cfloop>
					) 
			   </cfquery>
			   <cfif query_result.identitycol>
			   		<cfset returnData = #query_result.identitycol#> 	
			   <cfelse>
					<cfset returnData = 0>
			   </cfif>  

           </cfcase>
	  </cfswitch>
	<cfcatch type="any">
    <cfdump var="#cfcatch#">
	</cfcatch>
    <!---<cfreturn return_value_>--->
	</cftry>
	<cfreturn Replace(SerializeJSON(returnData),'//','')>
</cffunction>
<cffunction name="GET_EMP_INFO_" access="remote" returntype = "any">
	<cfargument name="emp_id" default="">
	<cfquery name="GET_EMP_INFO_" datasource="#dsn#">
		SELECT
			EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID
		FROM
			EMPLOYEES		
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#len(arguments.emp_id) ? arguments.emp_id : 0#">
	</cfquery>
	<cfreturn GET_EMP_INFO_>
</cffunction>
</cfcomponent>
