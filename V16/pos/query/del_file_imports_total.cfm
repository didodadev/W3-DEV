<cf_date tarih = "attributes.start_date">
<cfquery name="get_file_import_total" datasource="#dsn2#">
	SELECT 
		* 
	FROM
		FILE_IMPORTS_TOTAL
	WHERE
		FILE_IMPORTS_TOTAL.DEPARTMENT_ID = #attributes.department_id# AND
		FILE_IMPORTS_TOTAL.DEPARTMENT_LOCATION = #attributes.location_id# AND
		FILE_IMPORTS_TOTAL.PROCESS_DATE =  #attributes.start_date#
</cfquery>
<cfquery name="get_total_sayim" datasource="#dsn2#">
	SELECT
		IS_INITIALIZED
	FROM
		FILE_IMPORTS_TOTAL_SAYIMLAR
	WHERE
		DEPARTMENT_ID = #attributes.department_id# AND
		DEPARTMENT_LOCATION = #attributes.location_id# AND
		PROCESS_DATE =  #attributes.start_date#
</cfquery>
<cfif not get_file_import_total.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='144.Bu tarih ve depoda sayımlar birleştirilmemiştir'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif get_file_import_total.recordcount and get_total_sayim.IS_INITIALIZED eq 0>
<cftransaction>
	<cfquery name="delete_file_imports_total" datasource="#DSN2#">
		DELETE
		FROM
			FILE_IMPORTS_TOTAL
		WHERE
			DEPARTMENT_ID = #attributes.department_id# AND
			DEPARTMENT_LOCATION = #attributes.location_id# AND
			PROCESS_DATE =  #attributes.start_date#
	</cfquery>
	<cfquery name="delete_total_sayim" datasource="#DSN2#">
		DELETE
		FROM
			FILE_IMPORTS_TOTAL_SAYIMLAR
		WHERE
			DEPARTMENT_ID = #attributes.department_id# AND
			DEPARTMENT_LOCATION = #attributes.location_id# AND
			PROCESS_DATE =  #attributes.start_date#
	</cfquery>
	<cfquery name="sayim_belgeleri" datasource="#dsn2#">
		UPDATE 
			FILE_IMPORTS  
		SET 
			IMPORTED=0 
		WHERE 
			DEPARTMENT_ID = #attributes.department_id# AND
			DEPARTMENT_LOCATION = #attributes.location_id# AND
			STARTDATE =  #attributes.start_date# AND
			PROCESS_TYPE = -5
	</cfquery>
</cftransaction>
	<script type="text/javascript">
		alert("<cf_get_lang no ='145.Silme İşlemi Tamamlandı'>!");
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='146.Bu Tarih ve Depoda Sayım Sıfırlama İşlemi Yapıldığı İçin Silme İşlemi Yapılamaz,Öncelikle Sıfırlama İşlemi Silinmelidir'>!");
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
