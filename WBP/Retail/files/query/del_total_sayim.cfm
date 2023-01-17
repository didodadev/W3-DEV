<!--- 
STOCKS_ROW dan kayıtları silerken, sayım tarihinin sonuna kadarki kayıtlar alınır,oyüzden process_date +1 den küçük kayıtlara bakılır,
çünkü sayım bir gün sonu işlemidir AE20060104
 --->
<cf_date tarih = "attributes.process_date">
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="delete_total_sayim" datasource="#DSN2#">
			UPDATE 
				FILE_IMPORTS_TOTAL_SAYIMLAR
			SET 
				IS_INITIALIZED = 0
			WHERE 
				FILE_IMPORTS_TOTAL_SAYIM_ID = #attributes.file_imports_total_sayim_id#
		</cfquery>
		<cfquery name="delete_stok_row" datasource="#dsn2#">
			DELETE
			FROM
				STOCKS_ROW
			WHERE
				UPD_ID = #attributes.file_imports_total_sayim_id# AND
				STORE = #attributes.store# AND
				STORE_LOCATION = #attributes.location_id# AND
				PROCESS_DATE < #DATEADD("d",1,attributes.process_date)# AND
				PROCESS_TYPE = 117
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>