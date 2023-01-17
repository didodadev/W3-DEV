<cffile action="read" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_table.csv" variable="dosya" charset="iso-8859-9">
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="kontrol_table" datasource="#dsn#">
			SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_OBJECT_INFORMATION'
		</cfquery>
		
		<cfquery name="kontrol_eski_table" datasource="#dsn#">
			SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='_WRK_OBJECT_INFORMATION'
		</cfquery>
		
		<cfif kontrol_eski_table.recordcount>
			<cfquery name="drop_old_table"  datasource="#dsn#">
				DROP TABLE _WRK_OBJECT_INFORMATION
			</cfquery>
		</cfif>
		
		<cfif kontrol_table.recordcount>
			<cfquery name="change_name" datasource="#dsn#">
				sp_RENAME 'WRK_OBJECT_INFORMATION', '_WRK_OBJECT_INFORMATION'
				CREATE TABLE [WRK_OBJECT_INFORMATION](
					[OBJECT_ID] [int] IDENTITY(1,1) NOT NULL,
					[DB_NAME] [nvarchar](50) NULL,
					[DB_TYPE] [int] NULL,
					[TABLE_SCHEMA] [nvarchar](50) NULL,
					[OBJECT_NAME] [nvarchar](50) NULL,
					[TABLE_TYPE] [nvarchar](50) NULL,
					[TABLE_INFO] [nvarchar](300) NULL,
					[UPDATE_IP] [nvarchar](50) NULL,
					[UPDATE_DATE] [datetime] NULL,
					[UPDATE_EMP] [int] NULL,
					[RECORD_EMP] [int] NULL,
					[RECORD_DATE] [datetime] NULL,
					[RECORD_IP] [nvarchar](50) NULL,
					[TYPE] [bit] NULL,
					[STATUS] [nvarchar](20) NULL,
					[VERSION] [nvarchar](20) NULL,
					[NOTE] [nvarchar](500) NULL,
					[TABLE_INFO_ENG] [nvarchar](300) NULL
				) 
			</cfquery>
		<cfelse>
			<cfquery name="change_name" datasource="#dsn#">
				CREATE TABLE [WRK_OBJECT_INFORMATION](
					[OBJECT_ID] [int] IDENTITY(1,1) NOT NULL,
					[DB_NAME] [nvarchar](50) NULL,
					[DB_TYPE] [int] NULL,
					[TABLE_SCHEMA] [nvarchar](50) NULL,
					[OBJECT_NAME] [nvarchar](50) NULL,
					[TABLE_TYPE] [nvarchar](50) NULL,
					[TABLE_INFO] [nvarchar](300) NULL,
					[UPDATE_IP] [nvarchar](50) NULL,
					[UPDATE_DATE] [datetime] NULL,
					[UPDATE_EMP] [int] NULL,
					[RECORD_EMP] [int] NULL,
					[RECORD_DATE] [datetime] NULL,
					[RECORD_IP] [nvarchar](50) NULL,
					[TYPE] [bit] NULL,
					[STATUS] [nvarchar](20) NULL,
					[VERSION] [nvarchar](20) NULL,
					[NOTE] [nvarchar](500) NULL,
					[TABLE_INFO_ENG] [nvarchar](300) NULL
				) 
			</cfquery>
			
		</cfif>
		<cfscript>
			CRLF = Chr(13) & Chr(10);// satır atlama karakteri
			dosya = Replace(dosya,';;','; ;','all');
			dosya = Replace(dosya,';;','; ;','all');
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
			counter = 0;
			liste = "";
		</cfscript>
		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cfset error_flag = 0>
				<cfscript>
				counter = counter + 1;
				//table_catalog
				table_catalog = Listgetat(dosya[i],j,";");
				table_catalog =trim(table_catalog);
				j=j+1;
				//table_schema
				table_schema = Listgetat(dosya[i],j,";");
				table_schema = trim(table_schema);
				j=j+1;
				//table_name
				table_name = Listgetat(dosya[i],j,";");
				table_name =trim(table_name);
				j=j+1;
				//table_type
				table_type = Listgetat(dosya[i],j,";");
				table_type =trim(table_type);
				j=j+1;
				</cfscript>
				<cfif len(table_name) and len(table_catalog) and len(table_type) and len(table_schema) and error_flag neq 1>
					<cfquery name="insert_table" datasource="#dsn#">
						INSERT INTO 
							WRK_OBJECT_INFORMATION
						(
							DB_NAME,
							TABLE_SCHEMA,
							OBJECT_NAME,
							TABLE_TYPE,
							DB_TYPE	
						)
						VALUES
						(
							'#table_catalog#',
							'#table_schema#',
							'#table_name#',
							'#table_type#',
							<cfif table_catalog is dsn>
							 1
							<cfelseif table_catalog is dsn3 >
							 3								
 							<cfelseif table_catalog is dsn1 >
							 2
							<cfelseif table_catalog is dsn2>
							 4	
							</cfif>
						)
					</cfquery>
				</cfif>
		</cfloop>
		<cfquery datasource="#dsn#" name="upd_tables">
			UPDATE 
				WRK_OBJECT_INFORMATION 
			SET 
				RECORD_IP=OI1.RECORD_IP,
				RECORD_DATE=OI1.RECORD_DATE,
				RECORD_EMP=OI1.RECORD_EMP,
				UPDATE_IP=OI1.UPDATE_IP,
				UPDATE_DATE=OI1.UPDATE_DATE,
				UPDATE_EMP=OI1.UPDATE_EMP,
				VERSION=OI1.VERSION,
				TYPE=1,
				TABLE_INFO=OI1.TABLE_INFO,
				TABLE_INFO_ENG=OI1.TABLE_INFO_ENG,
				STATUS=OI1.STATUS
			FROM 
				WRK_OBJECT_INFORMATION OI JOIN _WRK_OBJECT_INFORMATION OI1 ON OI.OBJECT_NAME=OI1.OBJECT_NAME AND OI.DB_NAME=OI1.DB_NAME
		</cfquery>
		<cfquery datasource="#dsn#" name="upd_passive_table" >
			UPDATE 
				WRK_OBJECT_INFORMATION
			SET
				TYPE = 0
			WHERE 
				OBJECT_NAME LIKE '[_]%'			
		</cfquery>
		
		<cffile action="read" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_column.csv" variable="dosya" charset="iso-8859-9">
		<cfquery datasource="#dsn#" name="kontrol_kolon">
			SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_COLUMN_INFORMATION'
		</cfquery>
		
		<cfquery datasource="#dsn#" name="kontrol_eski_kolon">
			SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='_WRK_COLUMN_INFORMATION'
		</cfquery>
		
		<cfif kontrol_eski_kolon.recordcount>
			<cfquery datasource="#dsn#" name="drop_old_kolon">
				DROP TABLE _WRK_COLUMN_INFORMATION
			</cfquery>
		</cfif>
		
		<cfif kontrol_kolon.recordcount>
			<cfquery datasource="#dsn#" name="change_name">
				sp_RENAME 'WRK_COLUMN_INFORMATION', '_WRK_COLUMN_INFORMATION'
					CREATE TABLE [WRK_COLUMN_INFORMATION](
						[COLUMN_ID] [int] IDENTITY(1,1) NOT NULL,
						[COLUMN_NAME] [nvarchar](50) NULL,
						[TABLE_NAME] [nvarchar](50) NULL,
						[COLUMN_DEFAULT] [nvarchar](50) NULL,
						[IS_NULL] [nvarchar](50) NULL,
						[DATA_TYPE] [nvarchar](50) NULL,
						[MAXIMUM_LENGTH] [nvarchar](50) NULL,
						[TABLE_ID] [int] NULL,
						[COLUMN_INFO] [nvarchar](300) NULL,
						[SEED_VALUE] [int] NULL,
						[INCREMENT_VALUE] [int] NULL,
						[UPDATE_IP] [nvarchar](50) NULL,
						[UPDATE_DATE] [datetime] NULL,
						[UPDATE_EMP] [int] NULL,
						[RECORD_IP] [nvarchar](50) NULL,
						[RECORD_DATE] [datetime] NULL,
						[RECORD_EMP] [int] NULL,
						[COLUMN_INFO_ENG] [nvarchar](300) NULL
				) 
			</cfquery>
		<cfelse>
			<cfquery datasource="#dsn#" name="change_name">
					CREATE TABLE [WRK_COLUMN_INFORMATION](
					[COLUMN_ID] [int] IDENTITY(1,1) NOT NULL,
					[COLUMN_NAME] [nvarchar](50) NULL,
					[TABLE_NAME] [nvarchar](50) NULL,
					[COLUMN_DEFAULT] [nvarchar](50) NULL,
					[IS_NULL] [nvarchar](50) NULL,
					[DATA_TYPE] [nvarchar](50) NULL,
					[MAXIMUM_LENGTH] [nvarchar](50) NULL,
					[TABLE_ID] [int] NULL,
					[COLUMN_INFO] [nvarchar](300) NULL,
					[SEED_VALUE] [int] NULL,
					[INCREMENT_VALUE] [int] NULL,
					[UPDATE_IP] [nvarchar](50) NULL,
					[UPDATE_DATE] [datetime] NULL,
					[UPDATE_EMP] [int] NULL,
					[RECORD_IP] [nvarchar](50) NULL,
					[RECORD_DATE] [datetime] NULL,
					[RECORD_EMP] [int] NULL,
					[COLUMN_INFO_ENG] [nvarchar](300) NULL
				)  
			</cfquery>
		</cfif>
		
		<cfscript>
			CRLF = Chr(13) & Chr(10);// satır atlama karakteri
			dosya = Replace(dosya,';;','; ;','all');
			dosya = Replace(dosya,';;','; ;','all');
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
			counter = 0;
			liste = "";
		</cfscript>
		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cfset error_flag = 0>
				<cfscript>
				counter = counter + 1;
				
				//table_name
				table_name = Listgetat(dosya[i],j,";");
				table_name =trim(table_name);
				j=j+1;
				//column_name
				column_name = Listgetat(dosya[i],j,";");
				column_name =trim(column_name);
				j=j+1;
				//data_type
				data_type = Listgetat(dosya[i],j,";");
				data_type =trim(data_type);
				j=j+1;
				//character_maximum_length
				character_maximum_length = Listgetat(dosya[i],j,";");
				character_maximum_length =trim(character_maximum_length);
				j=j+1;
				//is_nullable
				is_nullable = Listgetat(dosya[i],j,";");
				is_nullable =trim(is_nullable);
				j=j+1;
				//is_identity
				is_identity = Listgetat(dosya[i],j,";");
				is_identity =trim(is_identity);
				j=j+1;
				
				//increment
				increment = Listgetat(dosya[i],j,";");
				increment =trim(increment);
				j=j+1;
				
				//seed
				seed = Listgetat(dosya[i],j,";");
				seed =trim(seed);
				j=j+1;
				</cfscript>
				<cfquery name="insert_column" datasource="#dsn#">
					INSERT INTO 
						WRK_COLUMN_INFORMATION
						(
							TABLE_NAME,
							COLUMN_NAME,
							DATA_TYPE,
							MAXIMUM_LENGTH,
							IS_NULL,
							SEED_VALUE,
							INCREMENT_VALUE
						)
						VALUES
						(
							'#table_name#',
							'#column_name#',
							'#data_type#',
							'#character_maximum_length#',
							'#is_nullable#',
							<cfif is_identity eq 1 >
								#seed#,
								#increment#
							<cfelse>
								null,
								null
							</cfif>
						)
				</cfquery>
		</cfloop>
		
		<cfquery datasource="#dsn#" name="upd_tables">
			UPDATE 
				WRK_COLUMN_INFORMATION 
			SET 
				RECORD_IP=OI1.RECORD_IP,
				RECORD_DATE=OI1.RECORD_DATE,
				RECORD_EMP=OI1.RECORD_EMP,
				UPDATE_IP=OI1.UPDATE_IP,
				UPDATE_DATE=OI1.UPDATE_DATE,
				UPDATE_EMP=OI1.UPDATE_EMP,
				COLUMN_INFO=OI1.COLUMN_INFO,
				COLUMN_INFO_ENG=OI1.COLUMN_INFO_ENG
			FROM 
				WRK_COLUMN_INFORMATION OI JOIN _WRK_COLUMN_INFORMATION OI1 ON OI.TABLE_NAME=OI1.TABLE_NAME AND OI.COLUMN_NAME=OI1.COLUMN_NAME
		</cfquery>
		
		<cfquery datasource="#DSN#" name="upd_table_id">
			UPDATE 
				WRK_COLUMN_INFORMATION 
			SET 
				TABLE_ID = OI.OBJECT_ID
			FROM 
				WRK_COLUMN_INFORMATION CI JOIN WRK_OBJECT_INFORMATION OI on OI.OBJECT_NAME=CI.TABLE_NAME			
		</cfquery>	
	</cftransaction>	
</cflock>	
<cflocation url="#request.self#?fuseaction=settings.import_export_table_column" addtoken="no">
