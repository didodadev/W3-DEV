<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="get_process" datasource="#dsn2#">
				SELECT PROCESS_CAT FROM STOCK_FIS WHERE FIS_ID = #attributes.upd_id#"
			</cfquery>
			<cfquery name="del_stock_fis_row" datasource="#dsn2#">
				DELETE FROM STOCK_FIS_ROW WHERE FIS_NUMBER = '#attributes.fis_no#'
			</cfquery>
			<cfquery name="del_stock_fis_row" datasource="#dsn2#">
				DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #attributes.del_id#
			</cfquery>
			<cfquery name="DEL_FIS_NUMBER" datasource="#dsn2#">
				DELETE FROM STOCK_FIS WHERE FIS_NUMBER = '#attributes.fis_no#'
			</cfquery>		
			<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
				DELETE 
				FROM 
					STOCKS_ROW 
				WHERE 
					PROCESS_TYPE=#attributes.fis_type# AND 
					UPD_ID=#attributes.del_id#
			</cfquery>
			<cfquery name="GET_FIS_FILE" datasource="#dsn2#">
				SELECT 
					FILE_NAME,
					FILE_SERVER_ID
				FROM 
					FILE_IMPORTS 
				WHERE 
					FIS_NUMBER = '#attributes.fis_no#'
			</cfquery>
			<cfif FileExists('#upload_folder#store#dir_seperator##GET_FIS_FILE.FILE_NAME#')>
				<cf_del_server_file output_file="store/#get_fis_file.file_name#" output_server="#get_fis_file.file_server_id#">
			</cfif>
			<cfquery name="DEL_FIS_FILE" datasource="#dsn2#">
				DELETE FROM FILE_IMPORTS WHERE FIS_NUMBER = '#attributes.fis_no#'
			</cfquery>	
			<cf_add_log  log_type="-1" action_id=" #attributes.upd_id#" action_name="#attributes.fis_no#" paper_no="#attributes.fis_no#" process_type="#get_process.process_cat#" data_source="#dsn2#">
		</cftransaction>
	</cflock>
<cflocation url="#request.self#?fuseaction=stock.list_purchase&cat=#attributes.fis_type#" addtoken="No">

