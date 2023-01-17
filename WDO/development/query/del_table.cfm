<cfquery datasource="#dsn#" name="find_table_name">
	SELECT OBJECT_NAME,DB_NAME,TABLE_INFO,DB_TYPE FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.TABLE_ID#  
</cfquery>

	<cfif find_table_name.DB_TYPE eq 1>
		<cflock name="#CREATEUUID()#" timeout="60">
			<cftransaction>
				<cfquery datasource="#find_table_name.DB_NAME#" name="drop_table">
					DROP TABLE #find_table_name.OBJECT_NAME# 
				</cfquery>
				<cfquery name="delete_table_columns" datasource="#find_table_name.DB_NAME#" >
					DELETE FROM #dsn#.WRK_COLUMN_INFORMATION WHERE TABLE_ID=#attributes.TABLE_ID#
				</cfquery>
				<cfquery name="delete_table_columns" datasource="#find_table_name.DB_NAME#" >
					DELETE FROM #dsn#.WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.TABLE_ID#
				</cfquery>									
				<cfquery name="delete_information" datasource="#find_table_name.DB_NAME#" >
					INSERT INTO 
						#dsn#.WRK_DELETE_OBJECT_INFORMATION 
					 (
						TABLE_NAME,
						UPDATE_EMP,
						UPDATE_IP,
						UPDATE_DATE,
						INFORMATION,
						DB_NAME
					 )
					 VALUES
					 (
						'#find_table_name.OBJECT_NAME#',
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#now()#,
						'#find_table_name.TABLE_INFO#',
						'#find_table_name.DB_NAME#'						
					 )
				</cfquery>
			</cftransaction>
		</cflock>						
	<cfelseif find_table_name.DB_TYPE  eq 2>
		<cflock name="#CREATEUUID()#" timeout="60">
			<cftransaction>
				<cfquery datasource="#find_table_name.DB_NAME#" name="drop_table">
					DROP TABLE #find_table_name.OBJECT_NAME# 
				</cfquery>
				<cfquery name="delete_table_columns" datasource="#find_table_name.DB_NAME#" >
					DELETE FROM #dsn#.WRK_COLUMN_INFORMATION WHERE TABLE_ID=#attributes.TABLE_ID#
				</cfquery>
				<cfquery name="delete_table_columns" datasource="#find_table_name.DB_NAME#" >
					DELETE FROM #dsn#.WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.TABLE_ID#
				</cfquery>									
				<cfquery name="delete_information" datasource="#find_table_name.DB_NAME#" >
					INSERT INTO 
						#dsn#.WRK_DELETE_OBJECT_INFORMATION 
					 (
						TABLE_NAME,
						UPDATE_EMP,
						UPDATE_IP,
						UPDATE_DATE,
						INFORMATION,
						DB_NAME
					 )
					 VALUES
					 (
						'#find_table_name.OBJECT_NAME#',
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#now()#,
						'#find_table_name.TABLE_INFO#',
						'#find_table_name.DB_NAME#'						
					 )
				</cfquery>
			</cftransaction>		
		</cflock>				
	<cfelseif find_table_name.DB_TYPE  eq 3>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT COMP_ID FROM OUR_COMPANY
		</cfquery>
		<cfloop query="get_company">
			<cfset find_table_name.DB_NAME = dsn&"_"&COMP_ID>
			<cfquery datasource="#dsn#" name="get_db_name">
				select name from sys.databases where name='#find_table_name.DB_NAME#'
			</cfquery>
			<cfif get_db_name.recordcount >
				<cfquery name="check_table" datasource="#find_table_name.DB_NAME#">
					SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '#find_table_name.OBJECT_NAME#'  
				</cfquery>
				<cfif check_table.recordcount>
					<cflock name="#CREATEUUID()#" timeout="60">
						<cftransaction>			
							<cfquery datasource="#find_table_name.DB_NAME#" name="drop_table">
								DROP TABLE #find_table_name.OBJECT_NAME# 
							</cfquery>
							<cfif find_table_name.DB_NAME is 'workcube_cf_1'>
								<cfquery datasource="#find_table_name.DB_NAME#" name="delete_table_columns">
									DELETE FROM #dsn#.WRK_COLUMN_INFORMATION WHERE TABLE_ID=#attributes.TABLE_ID#
								</cfquery>
								<cfquery name="delete_table_columns" datasource="#find_table_name.DB_NAME#" >
									DELETE FROM #dsn#.WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.TABLE_ID#
								</cfquery>									
								<cfquery datasource="#find_table_name.DB_NAME#" name="delete_information">
									INSERT INTO 
										#dsn#.WRK_DELETE_OBJECT_INFORMATION 
									 (
										TABLE_NAME,
										UPDATE_EMP,
										UPDATE_IP,
										UPDATE_DATE,
										INFORMATION,
										DB_NAME
									 )
									 VALUES
									 (
										'#find_table_name.OBJECT_NAME#',
										#session.ep.userid#,
										'#cgi.remote_addr#',
										#now()#,
										'#find_table_name.TABLE_INFO#',
										'#find_table_name.DB_NAME#'						
									 )
								</cfquery>
							</cfif>		
						</cftransaction>
					</cflock>
				</cfif>	
			</cfif>	
		</cfloop>
	<cfelseif find_table_name.DB_TYPE  eq 4>
			<cfquery name="get_company" datasource="#dsn#">
				SELECT COMP_ID FROM OUR_COMPANY
			</cfquery>
			<cfloop query="get_company">
				<cfquery name="get_period" datasource="#dsn#">
					SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID=#get_company.COMP_ID#
				</cfquery>
				<cfloop query="get_period">
					<cfset find_table_name.DB_NAME = dsn&"_"&PERIOD_YEAR&"_"&get_company.COMP_ID>
					<cfquery datasource="#dsn#" name="get_db_name">
						select name from sys.databases where name='#find_table_name.DB_NAME#'
					</cfquery>
					
					<cfif get_db_name.recordcount>
						<cfquery name="check_table" datasource="#find_table_name.DB_NAME#">
							SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '#find_table_name.OBJECT_NAME#'  
						</cfquery>
						<cfif check_table.recordcount>
							<cflock name="#CREATEUUID()#" timeout="60">
								<cftransaction>
									<cfquery datasource="#find_table_name.DB_NAME#" name="drop_table">
										DROP TABLE #find_table_name.OBJECT_NAME#
									</cfquery>
									<cfif find_table_name.DB_NAME is 'workcube_cf_2012_1'>
										<cfquery datasource="#find_table_name.DB_NAME#" name="delete_table_columns">
											DELETE FROM #dsn#.WRK_COLUMN_INFORMATION WHERE TABLE_ID=#attributes.TABLE_ID#
										</cfquery>
										<cfquery name="delete_table_columns" datasource="#find_table_name.DB_NAME#" >
											DELETE FROM #dsn#.WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.TABLE_ID#
										</cfquery>									
										<cfquery datasource="#find_table_name.DB_NAME#" name="delete_information">
											INSERT INTO 
												#dsn#.WRK_DELETE_OBJECT_INFORMATION 
											 (
												TABLE_NAME,
												UPDATE_EMP,
												UPDATE_IP,
												UPDATE_DATE,
												INFORMATION,
												DB_NAME
											 )
											 VALUES
											 (
												'#find_table_name.OBJECT_NAME#',
												#session.ep.userid#,
												'#cgi.remote_addr#',
												#now()#,
												'#find_table_name.TABLE_INFO#',
												'#find_table_name.DB_NAME#'						
											 )
										</cfquery>
									</cfif>
								</cftransaction>
							</cflock>			 
						</cfif>	
					</cfif>
				</cfloop>	
			</cfloop> 
	</cfif>
<cflocation addtoken="no" url="#request.self#?fuseaction=dev.list_table">
