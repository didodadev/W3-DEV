<cfif not isdefined("attributes.just_actions")>
	<cfquery name="GET_FILE" datasource="#DSN2#">
		SELECT
			INVOICE_ID,
			FILE_NAME,
			FILE_NAME_2,
			FILE_SERVER_ID,
			IS_MUHASEBE
		FROM
			FILE_IMPORTS
		WHERE
		<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)><!--- import edilmişse fatura da silinir --->
			INVOICE_ID = #attributes.invoice_id#
		<cfelseif isdefined("attributes.i_id") and len(attributes.i_id)>
			I_ID = #attributes.i_id#			
		</cfif>			
	</cfquery>
	<cfif get_file.recordcount>
		<cfset attributes.upload_folder = "#upload_folder#store#dir_seperator#">
		<cftry>
			<!--- schedule vb sorunlari yuzunden direkt siliniyor
			<cf_del_server_file output_file="#get_file.file_name#" output_server="#get_file.file_server_id#"><br /> --->
			<cffile action="delete" file="#attributes.upload_folder##dir_seperator##get_file.file_name#">
			<cfcatch type="any">
				<script type="text/javascript">
					alert("Eski Dosya Bulunamadı ama Veritabanından Silindi!");
				</script>
			</cfcatch>
		</cftry>
		
		<cfif len(get_file.file_name_2)>
			<cfset attributes.upload_folder = "#upload_folder#store#dir_seperator#">
			<cftry>
				<cffile action="delete" file="#attributes.upload_folder##dir_seperator##get_file.file_name_2#">
				<cfcatch type="any">
					<script type="text/javascript">
						alert("Eski Dosya Bulunamadı ama Veritabanından Silindi!");
					</script>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<script type="text/javascript">
			alert("Eski Dosya Bulunamadı ama Veritabanından Silindi!");
		</script>
	</cfif>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>
				<cfquery name="DEL_INVOICE_ROW_POS" datasource="#DSN2#">
					DELETE FROM INVOICE_ROW_POS	WHERE INVOICE_ID = #attributes.invoice_id#
				</cfquery>
				<cfquery name="DEL_INVOICE_ROW_POS_PROBLEM" datasource="#DSN2#">
					DELETE FROM INVOICE_ROW_POS_PROBLEM WHERE INVOICE_ID = #attributes.invoice_id#
				</cfquery>
				<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
					DELETE FROM STOCKS_ROW WHERE UPD_ID = #attributes.invoice_id# AND PROCESS_TYPE = 67
				</cfquery>
				<cfquery name="DEL_INVOICE" datasource="#DSN2#">
					DELETE FROM INVOICE	WHERE INVOICE_ID = #attributes.invoice_id#
				</cfquery>
			</cfif>
			<cfquery name="DEL_FILE_IMPORTS" datasource="#DSN2#">
				DELETE FROM
					FILE_IMPORTS
				WHERE
				<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>
					INVOICE_ID = #attributes.invoice_id#
				<cfelseif isdefined("attributes.i_id") and len(attributes.i_id)>
					I_ID = #attributes.i_id#
				</cfif>
			</cfquery>
			<cfif get_file.is_muhasebe is '1' and len(get_file.invoice_id)>
				<cfset muhasebe_silindi = muhasebe_sil(action_id:attributes.invoice_id, process_type:67)>
			</cfif>
		</cftransaction>
	</cflock>
<cfelse>
	<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>
			<cfquery name="DEL_INVOICE_ROW_POS_PROBLEM" datasource="#DSN2#">
				DELETE FROM INVOICE_ROW_POS_PROBLEM WHERE INVOICE_ID = #attributes.invoice_id#
			</cfquery>
			<cfquery name="DEL_INVOICE_ROW_POS" datasource="#DSN2#">
				DELETE FROM INVOICE_ROW_POS	WHERE INVOICE_ID = #attributes.invoice_id#
			</cfquery>
			<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
				DELETE FROM STOCKS_ROW WHERE UPD_ID = #attributes.invoice_id# AND PROCESS_TYPE = 67
			</cfquery>
			<cfquery name="DEL_INVOICE" datasource="#DSN2#">
				DELETE FROM INVOICE	WHERE INVOICE_ID = #attributes.invoice_id#
			</cfquery>
			<cfquery name="UPD_FILE_IMPORTS" datasource="#DSN2#">
				UPDATE 
					FILE_IMPORTS 
				SET
					INVOICE_ID = NULL,
					PROBLEMS_COUNT = NULL,
					PRODUCT_COUNT = NULL,
					IMPORTED = 0,
					IS_MUHASEBE = 0
				WHERE 
					INVOICE_ID = #attributes.invoice_id#
			</cfquery>
			<cfset muhasebe_silindi = muhasebe_sil(action_id:attributes.invoice_id, process_type:67)>
		</cfif>
	</cftransaction>
	</cflock>
</cfif>
<cfif not isDefined("Schedules")><!--- Schedule Yazilirken Kullanilmayacak --->
	<script type="text/javascript">
		<cfif not isDefined("DONTSTOP")>
			wrk_opener_reload();
			window.close();
		</cfif>
	</script>
</cfif>