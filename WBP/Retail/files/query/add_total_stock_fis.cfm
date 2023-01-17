<cfsetting showdebugoutput="no">
<cfset is_total_fis = 1>
<cfset all_loop_count = 0>
<cfif not(isdefined("attributes.del_file_id") and len(attributes.del_file_id))>
	<cfloop list="#attributes.file_id_list#" index="kk">
		<cfquery name="upd_main" datasource="#dsn2#">
			UPDATE
				FILE_IMPORTS_TOTAL_SAYIMLAR
			SET
				IS_TOTAL_STOCK_FIS = 1
			WHERE
				FILE_IMPORTS_TOTAL_SAYIM_ID = #kk#
		</cfquery>
		<cfquery name="get_rows" datasource="#dsn2#">
			SELECT 
				FT.FIS_ID,
				FT.FILE_IMPORTS_TOTAL_ID ,
				FT.PROCESS_DATE
			FROM 
				FILE_IMPORTS_TOTAL FT,
				FILE_IMPORTS_TOTAL_SAYIMLAR FTS
			WHERE 
				FT.PROCESS_DATE = FTS.PROCESS_DATE AND
				FT.DEPARTMENT_ID = FTS.DEPARTMENT_ID AND
				FT.DEPARTMENT_LOCATION = FTS.DEPARTMENT_LOCATION AND
				ISNULL(FT.IS_ALL,0) = 1 AND
				ISNULL(FTS.IS_ALL,0) = 1 AND
				FTS.FILE_IMPORTS_TOTAL_SAYIM_ID = #kk# AND
				FT.FIS_ID IS NULL
		</cfquery>
		<cfset loop_count = ceiling(get_rows.recordcount/200)>
		<cfset attributes.file_import_total_all = ''>
		<cfloop from="1" to="#loop_count#" index="kkk">
			<cfquery name="get_rows_last" dbtype="query" maxrows="200">
				SELECT 
					FILE_IMPORTS_TOTAL_ID
				FROM 
					get_rows
				<cfif isdefined("attributes.file_import_total_all") and len(attributes.file_import_total_all)>
					WHERE 
						FILE_IMPORTS_TOTAL_ID NOT IN(#attributes.file_import_total_all#)
				</cfif>
			</cfquery>
			<cfset attributes.file_import_total = valuelist(get_rows_last.FILE_IMPORTS_TOTAL_ID)>
			<cfset attributes.file_import_total_all = listappend(attributes.file_import_total_all,attributes.file_import_total)>
			<cfset attributes.islem_tarihi = dateformat(get_rows.process_date,'dd/mm/yyyy')>
			<cfinclude template="../../pos/query/add_file_import_total_sayim.cfm">
		</cfloop>
	</cfloop>
	<cfif isdefined("all_loop_count") and all_loop_count gt 0>
		<script type="text/javascript">
			alert("<cfoutput>#all_loop_count#</cfoutput> Adet Stok Fişi Oluşturuldu !");
		</script>
	<cfelse>
		<script type="text/javascript">
			alert("Stok Fişi Oluşturulacak Belge Bulunamadı !");
		</script>
	</cfif>
<cfelse>
	<cflock timeout="60">
		<cftransaction>	
			<cfquery name="upd_main" datasource="#dsn2#">
				UPDATE
					FILE_IMPORTS_TOTAL_SAYIMLAR
				SET
					IS_TOTAL_STOCK_FIS = 0
				WHERE
					FILE_IMPORTS_TOTAL_SAYIM_ID = #attributes.del_file_id#
			</cfquery>	
			<cfquery name="get_rows" datasource="#dsn2#">
				SELECT DISTINCT
					FT.FIS_ID,
					FT.FIS_PROCESS_TYPE
				FROM 
					FILE_IMPORTS_TOTAL FT,
					FILE_IMPORTS_TOTAL_SAYIMLAR FTS
				WHERE 
					FT.PROCESS_DATE = FTS.PROCESS_DATE AND
					FT.DEPARTMENT_ID = FTS.DEPARTMENT_ID AND
					FT.DEPARTMENT_LOCATION = FTS.DEPARTMENT_LOCATION AND
					FTS.FILE_IMPORTS_TOTAL_SAYIM_ID = #attributes.del_file_id# AND
					FT.FIS_ID IS NOT NULL
			</cfquery>
			<cfoutput query="get_rows">
				<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
					DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#get_rows.FIS_PROCESS_TYPE# AND UPD_ID=#get_rows.FIS_ID#
				</cfquery>
				<cfquery name="del_stock_fis_row" datasource="#dsn2#">
					DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #get_rows.FIS_ID#
				</cfquery>
				<cfquery name="del_stock_fis_row" datasource="#dsn2#">
					DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #get_rows.FIS_ID#
				</cfquery>
				<cfquery name="DEL_FIS_NUMBER" datasource="#dsn2#">
					DELETE FROM STOCK_FIS WHERE FIS_ID = #get_rows.FIS_ID#
				</cfquery>
				<cfquery name="DEL_FILE_IMPORTS_TOTAL" datasource="#dsn2#"> 
					UPDATE 
						FILE_IMPORTS_TOTAL 
					SET 
						FIS_ID=NULL,
						FIS_PROCESS_TYPE= NULL 
					WHERE 
						FIS_ID=#get_rows.FIS_ID# 
						AND FIS_PROCESS_TYPE=#get_rows.FIS_PROCESS_TYPE#
				</cfquery>
			</cfoutput>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		alert("Belgeye Ait Stok Fişleri Silindi !");
	</script>
</cfif>
<script type="text/javascript">
	window.location.reload();
</script>
<cfabort>