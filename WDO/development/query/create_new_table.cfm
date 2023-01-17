<cfquery datasource="#dsn#" name="insert_object">
INSERT INTO WRK_OBJECT_INFORMATION 
(
	DB_NAME,	
	TABLE_SCHEMA,
	DB_TYPE,
	OBJECT_NAME,
	TABLE_TYPE,
	TABLE_INFO,
	TABLE_INFO_ENG,
	RECORD_IP,
	RECORD_DATE,
	RECORD_EMP,
	TYPE,
	STATUS,
	VERSION	
)
VALUES
(
	'#attributes.database_name#',
	,
	<cfif attributes.database_name is 'workcube_cf'>
		1,	
	<cfelseif	attributes.database_name is 'workcube_cf_product'>
		2,	
	<cfelseif	attributes.database_name is 'workcube_cf_1'>
		3,
	<cfelseif	attributes.database_name is 'workcube_cf_2012_1'>
		4,
	</cfif>
	'#attributes.table_name_#',
	'BASE TABLE',
	'#attributes.table_info#',
	'#attributes.table_info_eng#',
	'#cgi.remote_addr#',
	#now()#,
	#session.ep.userid#,
	1,
	'#attributes.status#',
	'#attributes.version#'
)

	SELECT @@IDENTITY AS MAX_ROWS
</cfquery>

<cfquery datasource="#dsn#" name="get_table_id">
	SELECT OBJECT_ID,DB_TYPE FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#insert_object.MAX_ROWS#
</cfquery>
<cfsavecontent variable="veri">
<cfloop from="0" to="#attributes.record_num#" index="i">
<cfoutput>
<cfif evaluate("attributes.control_#i#") eq 1>
#evaluate("attributes.column_name#i#")# 
<cfset attributes.data_type = evaluate("attributes.data_type#i#")>
<cfset attributes.start = evaluate("attributes.start#i#")>
<cfset attributes.increment = evaluate("attributes.increment#i#")>
<cfset attributes.default_value = evaluate("attributes.default_value#i#")>
<cfset attributes.length=evaluate("attributes.length#i#")>
<cfif isdefined("attributes.is_null#i#")>
<cfset attributes.is_null = evaluate("attributes.is_null#i#")>
</cfif>
<cfif attributes.data_type eq 'nvarchar'>
			<cfif len(evaluate("attributes.length#i#"))>
				<cfif isdefined("attributes.is_null#i#")>
					<cfif len(attributes.default_value)>
						#attributes.data_type#(#attributes.length#) null default '#attributes.default_value#',				
					<cfelse>
						#evaluate("attributes.data_type#i#")#(#evaluate("attributes.length#i#")#) null ,
					</cfif>	
				<cfelse>
					<cfif len(attributes.default_value)>
						#evaluate("attributes.data_type#i#")#(#evaluate("attributes.length#i#")#) not null default('#attributes.default_value#'),				
					<cfelse>
						#evaluate("attributes.data_type#i#")#(#evaluate("attributes.length#i#")#) not null,
					</cfif>	
				</cfif>          
			<cfelse>
				<cfif isdefined("attributes.is_null#i#")>
					<cfif len(attributes.default_value)>
						#evaluate("attributes.data_type#i#")#(50) null default('#attributes.default_value#'),				
					<cfelse>
						#evaluate("attributes.data_type#i#")#(50) null,
					</cfif>	 
				<cfelse>
					<cfif len(attributes.default_value)>
						#evaluate("attributes.data_type#i#")#(50) not null default('#attributes.default_value#'),				
					<cfelse>
						#evaluate("attributes.data_type#i#")#(50) not null,
					</cfif>	 
				</cfif>
			</cfif>			
</cfif>

<cfif attributes.data_type eq 'int'>
	<cfif isdefined("attributes.is_null#i#")>
		<cfif len(attributes.default_value)>
			#attributes.data_type# null default(#attributes.default_value#),
		<cfelse>
			#attributes.data_type# null,
		</cfif>	
	<cfelse>
		<cfif len(attributes.default_value)>
			#attributes.data_type# not null default(#attributes.default_value#),
		<cfelse>
			<cfif len(attributes.start)>
				#attributes.data_type# not null identity(#attributes.start#,#attributes.increment#),	
			<cfelse>
				#attributes.data_type# not null,
			</cfif>	
		</cfif>		
	</cfif>
</cfif>

<cfif attributes.data_type eq 'float'>
	<cfif isdefined("attributes.isnull#i#")>
		<cfif len(attributes.default_value)>
			#attributes.data_type# null default(#attributes.default_value#),
		<cfelse>
			#attributes.data_type# null,
		</cfif>			
	<cfelse>
		<cfif len(attributes.default_value)>
			#attributes.data_type# not null default(#attributes.default_value#),
		<cfelse>
			#attributes.data_type# not null,
		</cfif>
	</cfif>
</cfif>

<cfif attributes.data_type eq 'datetime'>
	<cfif isdefined("attributes.is_null#i#")>
		<cfif len(attributes.default_value)>
			#attributes.data_type# null default(#attributes.default_value#),	
		<cfelse>
			#attributes.data_type# null,
		</cfif>
	<cfelse>
		<cfif len(attributes.default_value)>
			#attributes.data_type# not null default(#attributes.default_value#),
		<cfelse>
			#attributes.data_type# not null,
		</cfif>
	</cfif>
</cfif>

<cfif attributes.data_type eq 'date'>
	<cfif isdefined("attributes.is_null#i#")>
		<cfif len(attributes.default_value)>
			#attributes.data_type# null default(#attributes.default_value#),
		<cfelse>
			#attributes.data_type# null,
		</cfif>
	<cfelse>
		<cfif len(attributes.default_value)>
			#attributes.data_type# not null default(#attributes.default_value#),
		<cfelse>
			#attributes.data_type# not null,
		</cfif>	
	</cfif>
</cfif>

<cfif attributes.data_type eq 'decimal'>
	<cfif len(evaluate("attributes.length#i#"))>
		<cfif isdefined ("attributes.is_null#i#")>
			<cfif len(attributes.default_value)>
			#attributes.data_type#(#evaluate("attributes.length#i#")#) null default(#attributes.default_value#),	
			<cfelse>
			#attributes.data_type#(#evaluate("attributes.length#i#")#) null,
			</cfif>
		<cfelse>
			<cfif len(attributes.default_value)>
			#attributes.data_type#(#evaluate("attributes.length#i#")#) not null default(#attributes.default_value#),	
			<cfelse>
			#attributes.data_type#(#evaluate("attributes.length#i#")#) not null,
			</cfif> 
		</cfif>
	<cfelse>	
		<cfif isdefined ("attributes.is_null#i#")>
			<cfif len(attributes.default_value)>
			#attributes.data_type#(18,0) null default(#attributes.default_value#),	
			<cfelse>
			#attributes.data_type#(18,0) null,
			</cfif>
		<cfelse>
			<cfif len(attributes.default_value)>
			#attributes.data_type#(18,0) not null default(#attributes.default_value#),	
			<cfelse>
			#attributes.data_type#(18,0) not null,
			</cfif> 
		</cfif>
	</cfif>
</cfif>

<cfif attributes.data_type eq 'bit'>
	<cfif isdefined("attributes.is_null#i#")>
		<cfif len(attributes.default_value)>
			#attributes.data_type# null default(#attributes.default_value#),	
		<cfelse>
			#attributes.data_type# null,
		</cfif>
	<cfelse>
		<cfif len(attributes.default_value)>
			#attributes.data_type# not null default(#attributes.default_value#),
		<cfelse>
			#attributes.data_type# not null,
		</cfif>
	</cfif>
</cfif>

<cfif attributes.data_type eq 'ntext'>
	<cfif isdefined("attributes.is_null#i#")>
		<cfif len(attributes.default_value)>
			#attributes.data_type# null default(#attributes.default_value#),	
		<cfelse>
			#attributes.data_type# null,
		</cfif>
	<cfelse>
		<cfif len(attributes.default_value)>
			#attributes.data_type# not null default(#attributes.default_value#),
		<cfelse>
			#attributes.data_type# not null,
		</cfif>
	</cfif>
</cfif>
	<cfquery datasource="#dsn#" name="insert_column_">
		INSERT INTO WRK_COLUMN_INFORMATION 
		(
			 COLUMN_NAME,
			 TABLE_NAME,
			 COLUMN_DEFAULT,
			 IS_NULL,
			 DATA_TYPE,
			 MAXIMUM_LENGTH,
			 COLUMN_INFO,
			 COLUMN_INFO_ENG,
			 SEED_VALUE,
			 INCREMENT_VALUE,
			 TABLE_ID,
			 UPDATE_IP,
			 UPDATE_DATE,
			 UPDATE_EMP
		)
		VALUES
		(
			 '#evaluate("attributes.column_name#i#")#',
			 '#attributes.table_name_#',
			 <cfif len(attributes.default_value)>
			 	'#attributes.default_value#',
			 <cfelse>
				  null,
			 </cfif>
			 <cfif isdefined("attributes.is_null#i#")>	 
				 'YES',
			 <cfelse>
			 	'NO',
			 </cfif>
			 	'#attributes.data_type#',
			 <cfif len(evaluate("attributes.length#i#"))>
			 	#evaluate("attributes.length#i#")#,
			 <cfelse>
				 NULL,
			 </cfif>
			 	<cfqueryparam cfsqltype="cf_sql_char" value="#evaluate("attributes.column_info#i#")#">,
			 	<cfqueryparam cfsqltype="cf_sql_char" value="#evaluate("attributes.column_info_eng#i#")#">,				
			  <cfif len(attributes.start)>
			  	#attributes.start#,
			 	 #attributes.increment#,
			  <cfelse>
			 	 null,
			 	 null,
			  </cfif>
			   #get_table_id.OBJECT_ID#,
			  '#cgi.remote_addr#',
			   #now()#,
			   #session.ep.userid#
		)	
	</cfquery>
</cfif>
</cfoutput>
</cfloop>
</cfsavecontent>


<cfset veri=trim(tostring(veri))>
<cfset kont=left(tostring(veri),len(veri)-1)>

<cfif get_table_id.DB_TYPE  eq 1 or get_table_id.DB_TYPE  eq 2>
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfquery datasource="#attributes.database_name#" name="create_table_">
				CREATE TABLE #attributes.table_name_#
				(
			#REReplace(kont,"''","'","ALL")#			  
				)
			</cfquery>
		</cftransaction>
	</cflock>		
<cfelseif get_table_id.DB_TYPE  eq 3>

		<cfquery name="get_company" datasource="#dsn#">
			SELECT COMP_ID FROM OUR_COMPANY
		</cfquery>
		
		<cfloop query="get_company">		
			<cfset attributes.database_name = dsn&"_"&COMP_ID>
			<cfquery name="check_database" datasource="#dsn#">
				SELECT NAME FROM sys.databases where name = '#attributes.database_name#'
			</cfquery>
			<cflock name="#CREATEUUID()#" timeout="60">
				<cftransaction>
					<cfif check_database.recordcount>
						<cfquery name="check_table" datasource="#attributes.database_name#">
							SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='#attributes.table_name_#'
						</cfquery>
							<cfif not check_table.recordcount>
								<cftry>										
									<cfquery datasource="#attributes.database_name#" name="create_table_">
										CREATE TABLE #attributes.table_name_#
										(
									#REReplace(kont,"''","'","ALL")#			  
										)
									</cfquery>
								<cfcatch>
									<cfif attributes.database_name is 'workcube_cf_1'>
										<cfquery name="delete_object_information" datasource="#attributes.database_name#">
											DELETE FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID = #insert_object.MAX_ROWS#
										</cfquery>
										<cfquery name="delete_column_information" datasource="#attributes.database_name#">
											DELETE FROM WRK_COLUMN_INFORMATION WHERE TABLE_ID = #insert_object.MAX_ROWS#
										</cfquery>
									</cfif>
								</cfcatch>
								</cftry>	
							</cfif>	
					</cfif>
		 		</cftransaction>
			</cflock>		
		</cfloop>
<cfelseif get_table_id.DB_TYPE  eq 4>
			<cfquery name="get_company" datasource="#dsn#">
				SELECT COMP_ID FROM OUR_COMPANY
			</cfquery>
			<cfquery name="get_period" datasource="#dsn#">
				SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID=#get_company.COMP_ID#
			</cfquery>
		<cfloop query="get_company">
			<cfloop query="get_period">
				<cfset attributes.database_name = dsn&"_"&PERIOD_YEAR&"_"&get_company.COMP_ID >	
				<cfquery datasource="#dsn#" name="get_db_name">
					select name from sys.databases where name='#attributes.database_name#'
				</cfquery>
					<cfif get_db_name.recordcount>
						<cfquery name="check_table" datasource="#attributes.database_name#">
							SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '#attributes.table_name_#'
						</cfquery>
							<cfif not check_table.recordcount>
								<cftry>	
									<cfquery datasource="#attributes.database_name#" name="create_table_">
										CREATE TABLE #attributes.table_name_#
										(
									#REReplace(kont,"''","'","ALL")#			  
										)
									</cfquery>
								<cfcatch>
									<cfif attributes.database_name is 'workcube_cf_2012_1'>
										<cfquery name="delete_object_information" datasource="#attributes.database_name#">
											DELETE FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID = #insert_object.MAX_ROWS#
										</cfquery>
										<cfquery name="delete_column_information" datasource="#attributes.database_name#">
											DELETE FROM WRK_COLUMN_INFORMATION WHERE TABLE_ID = #insert_object.MAX_ROWS#
										</cfquery>
									</cfif>	
								</cfcatch>	
								</cftry>
							</cfif>
					</cfif>
			</cfloop>
		</cfloop>
</cfif>
<cflocation addtoken="no" url="http://ep.workcube/index.cfm?fuseaction=dev.form_upd_table&TABLE_ID=#insert_object.MAX_ROWS#">

