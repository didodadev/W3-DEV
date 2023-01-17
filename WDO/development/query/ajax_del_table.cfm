<cfsetting showdebugoutput="no">
<cfif len(#attributes.column_id#) and len(#attributes.column_info#)>
		<cfquery datasource="#dsn#" name="get_column_name">
			SELECT COLUMN_NAME,TABLE_NAME FROM WRK_COLUMN_INFORMATION WHERE COLUMN_ID=#attributes.column_id#
		</cfquery>
		<cfquery name="get_catalog_name" datasource="#dsn#">
			SELECT DB_NAME,DB_TYPE FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID=(SELECT TABLE_ID FROM WRK_COLUMN_INFORMATION WHERE COLUMN_ID=#attributes.column_id#)
		</cfquery>
		<cfset table_name_sil ="sil"&#get_column_name.COLUMN_NAME#>
	<cfif get_catalog_name.DB_TYPE EQ 3>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT COMP_ID FROM OUR_COMPANY
		</cfquery>
			<cfloop query="get_company">
				<cfset get_catalog_name.DB_NAME = dsn&"_"&COMP_ID>
				<cfquery name="check_database" datasource="#dsn#">
					SELECT name FROM sys.databases WHERE name='#get_catalog_name.DB_NAME#'
				</cfquery>			
					<cfif check_database.recordcount>
							<cflock name="#CREATEUUID()#" timeout="60">
								<cftransaction>
									<cfquery datasource="#get_catalog_name.DB_NAME#" name="find_constaint">
										select	db_name()				as CONSTRAINT_DB_NAME
												,t_obj.name 			as TABLE_NAME
												,user_name(c_obj.uid)   as CONSTRAINT_SCHEMA
												,c_obj.name				as CONSTRAINT_NAME
												,col.name				as COLUMN_NAME
												,col.colid				as ORDINAL_POSITION
												,com.text				as DEFAULT_CLAUSE
											
											from	sysobjects	c_obj
											join 	syscomments	com on 	c_obj.id = com.id
											join 	sysobjects	t_obj on c_obj.parent_obj = t_obj.id  
											join    sysconstraints con on c_obj.id	= con.constid
											join 	syscolumns	col on t_obj.id = col.id and con.colid = col.colid
														
											where
												t_obj.name ='#get_column_name.TABLE_NAME#'and col.name='#get_column_name.COLUMN_NAME#'
									</cfquery>
									<cfquery name="delete_column_in_table" datasource="#get_catalog_name.DB_NAME#">	
										 <cfif find_constaint.recordcount gte 1 >	
											ALTER TABLE #get_column_name.TABLE_NAME#
												DROP CONSTRAINT #find_constaint.CONSTRAINT_NAME#
											ALTER TABLE #get_column_name.TABLE_NAME#
												DROP COLUMN #get_column_name.COLUMN_NAME#
										 <cfelse>
												ALTER TABLE #get_column_name.TABLE_NAME#
													DROP COLUMN #get_column_name.COLUMN_NAME#
										 </cfif>
									</cfquery>
								   <cfif get_catalog_name.DB_NAME is 'workcube_cf_1'>
									   <cfquery name="delete_column_in_column_information" datasource="#get_catalog_name.DB_NAME#">
											DELETE  FROM  #dsn#.WRK_COLUMN_INFORMATION WHERE COLUMN_ID = #attributes.column_id#	
									   </cfquery>
									   <cfquery name="insert_delete_information_in_delete_object_information" datasource="#get_catalog_name.DB_NAME#">
											INSERT INTO #dsn#.WRK_DELETE_OBJECT_INFORMATION 
											(
											TABLE_NAME,
											COLUMN_NAME,
											UPDATE_EMP,
											UPDATE_IP,
											UPDATE_DATE,
											INFORMATION,
											DB_NAME
											)
											VALUES
											(
											'#get_column_name.TABLE_NAME#',
											'#get_column_name.COLUMN_NAME#',
											#session.ep.userid#,
											'#cgi.remote_addr#',
											#now()#,
											'#attributes.column_info#',
											'#get_catalog_name.DB_NAME#'
											) 
									   </cfquery>
								   </cfif>			
								</cftransaction>
							</cflock>	
					</cfif>	
			</cfloop>
	<cfelseif get_catalog_name.DB_TYPE EQ 4	>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT COMP_ID FROM OUR_COMPANY
		</cfquery>
		<cfquery name="get_period" datasource="#dsn#">
			SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID=#get_company.COMP_ID#
		</cfquery>
		<cfloop query="get_company">
			<cfloop query="get_period">
				<cfset get_catalog_name.DB_NAME = dsn&"_"&PERIOD_YEAR&"_"&get_company.COMP_ID>
				<cfquery datasource="#dsn#" name="get_db_name">
					select name from sys.databases where name='#get_catalog_name.DB_NAME#'
				</cfquery>
				<cfif get_db_name.recordcount>
						<cflock name="#CREATEUUID()#" timeout="60">
							<cftransaction>
								<cfquery datasource="#get_catalog_name.DB_NAME#" name="find_constaint">
									select	db_name()				as CONSTRAINT_DB_NAME
											,t_obj.name 			as TABLE_NAME
											,user_name(c_obj.uid)   as CONSTRAINT_SCHEMA
											,c_obj.name				as CONSTRAINT_NAME
											,col.name				as COLUMN_NAME
											,col.colid				as ORDINAL_POSITION
											,com.text				as DEFAULT_CLAUSE
										
										from	sysobjects	c_obj
										join 	syscomments	com on 	c_obj.id = com.id
										join 	sysobjects	t_obj on c_obj.parent_obj = t_obj.id  
										join    sysconstraints con on c_obj.id	= con.constid
										join 	syscolumns	col on t_obj.id = col.id and con.colid = col.colid
													
										where
											t_obj.name ='#get_column_name.TABLE_NAME#'and col.name='#get_column_name.COLUMN_NAME#'
								</cfquery>
							   <cfquery name="delete_column_in_table" datasource="#get_catalog_name.DB_NAME#">
									<cfif find_constaint.recordcount gte 1 >
										ALTER TABLE #get_column_name.TABLE_NAME#
											DROP CONSTRAINT #find_constaint.CONSTRAINT_NAME#
										ALTER TABLE #get_column_name.TABLE_NAME#
											DROP COLUMN #get_column_name.COLUMN_NAME#
									<cfelse>
										ALTER TABLE #get_column_name.TABLE_NAME#
											DROP COLUMN #get_column_name.COLUMN_NAME#		
									</cfif>
							   </cfquery>
							  <cfif get_catalog_name.DB_NAME is 'workcube_cf_2012_1'>
								  <cfquery name="delete_column_in_column_information" datasource="#get_catalog_name.DB_NAME#">
										DELETE  FROM  #dsn#.WRK_COLUMN_INFORMATION WHERE COLUMN_ID = #attributes.column_id#	
								   </cfquery>
								   <cfquery name="insert_delete_information_in_delete_object_information" datasource="#get_catalog_name.DB_NAME#">
										INSERT INTO #dsn#.WRK_DELETE_OBJECT_INFORMATION 
										(
										TABLE_NAME,
										COLUMN_NAME,
										UPDATE_EMP,
										UPDATE_IP,
										UPDATE_DATE,
										INFORMATION,
										DB_NAME
										)
										VALUES
										(
										'#get_column_name.TABLE_NAME#',
										'#get_column_name.COLUMN_NAME#',
										#session.ep.userid#,
										'#cgi.remote_addr#',
										#now()#,
										'#attributes.column_info#',
										'#get_catalog_name.DB_NAME#'
										) 
								   </cfquery>
							  </cfif>
						</cftransaction>		   
					</cflock>	 				   		   
				</cfif> 
			</cfloop>   
		</cfloop>
	<cfelseif get_catalog_name.DB_TYPE EQ 1 or   get_catalog_name.DB_TYPE EQ 2>
		<cflock name="#CREATEUUID()#" timeout="60">
			<cftransaction>		
				<cfquery datasource="#get_catalog_name.DB_NAME#" name="find_constaint">
							select	db_name()				as CONSTRAINT_DB_NAME
									,t_obj.name 			as TABLE_NAME
									,user_name(c_obj.uid)   as CONSTRAINT_SCHEMA
									,c_obj.name				as CONSTRAINT_NAME
									,col.name				as COLUMN_NAME
									,col.colid				as ORDINAL_POSITION
									,com.text				as DEFAULT_CLAUSE
								
								from	sysobjects	c_obj
								join 	syscomments	com on 	c_obj.id = com.id
								join 	sysobjects	t_obj on c_obj.parent_obj = t_obj.id  
								join    sysconstraints con on c_obj.id	= con.constid
								join 	syscolumns	col on t_obj.id = col.id and con.colid = col.colid
											
								where
									t_obj.name ='#get_column_name.TABLE_NAME#'and col.name='#get_column_name.COLUMN_NAME#'
				</cfquery>
				<cfquery name="delete_column_in_table" datasource="#get_catalog_name.DB_NAME#">
						<cfif find_constaint.recordcount gte 1 >
							ALTER TABLE #get_column_name.TABLE_NAME#
								DROP CONSTRAINT #find_constaint.CONSTRAINT_NAME#
							ALTER TABLE #get_column_name.TABLE_NAME#
								DROP COLUMN #get_column_name.COLUMN_NAME#
						<cfelse>
							ALTER TABLE #get_column_name.TABLE_NAME#
								DROP COLUMN #get_column_name.COLUMN_NAME#		
						</cfif>
				</cfquery>
			  
				<cfquery name="delete_column_in_column_information" datasource="#get_catalog_name.DB_NAME#">
					DELETE  FROM  #dsn#.WRK_COLUMN_INFORMATION WHERE COLUMN_ID = #attributes.column_id#	
				</cfquery>
			   
				<cfquery name="insert_delete_information_in_delete_object_information" datasource="#get_catalog_name.DB_NAME#">
					INSERT INTO #dsn#.WRK_DELETE_OBJECT_INFORMATION 
					(
					TABLE_NAME,
					COLUMN_NAME,
					UPDATE_EMP,
					UPDATE_IP,
					UPDATE_DATE,
					INFORMATION,
					DB_NAME
					)
					VALUES
					(
					'#get_column_name.TABLE_NAME#',
					'#get_column_name.COLUMN_NAME#',
					#session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#,
					'#attributes.column_info#',
					'#get_catalog_name.DB_NAME#'
					) 
				</cfquery>
			</cftransaction>
		</cflock>								
	</cfif>
</cfif>
  
<!---   <cfquery name="upd_info" datasource="#dsn#">
   		UPDATE 
			WRK_COLUMN_INFORMATION 
		SET 
			COLUMN_INFO='#attributes.column_info#'
		WHERE 
			COLUMN_ID=#attributes.column_id#
   </cfquery>--->







