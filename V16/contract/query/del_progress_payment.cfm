<cfquery name="getInvoice" datasource="#dsn2#">
	SELECT INVOICE_ID,INVOICE_NUMBER FROM INVOICE WHERE PROGRESS_ID = #attributes.progress_id# AND FROM_PROGRESS = 1
</cfquery>
<cfif getInvoice.recordcount>
	<script type="text/javascript">
		<cfoutput>
			alert("Hakedişten eklenen fatura bulunmaktadır.\n Lütfen #getInvoice.invoice_number# nolu faturayı siliniz!");
			history.back();	
		</cfoutput>
	</script>
	<cfabort>
</cfif>
<cfquery name="getCariActions" datasource="#dsn2#">
	SELECT ACTION_ID,PROCESS_CAT FROM CARI_ACTIONS WHERE PROGRESS_ID = #attributes.progress_id# AND FROM_PROGRESS = 1
</cfquery>

<cfif getCariActions.recordcount>
	<cfloop query="getCariActions">
		<cfquery name="get_process_type" datasource="#dsn3#">
			SELECT 
				PROCESS_TYPE
			 FROM 
				SETUP_PROCESS_CAT 
			WHERE 
				PROCESS_CAT_ID = #getCariActions.process_cat#
		</cfquery>
	
		<cfscript>
			cari_sil(action_id:getCariActions.action_id,process_type:get_process_type.process_type);
			muhasebe_sil(action_id:getCariActions.action_id,process_type:get_process_type.process_type);
			butce_sil(action_id:getCariActions.action_id,process_type:get_process_type.process_type);
		</cfscript>	
		<cfquery name="DEL_CARI_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM CARI_ACTION_MONEY WHERE ACTION_ID = #getCariActions.action_id#
		</cfquery>
		<cfquery name="DEL_FROM_CARI_ACTIONS" datasource="#dsn2#">
			DELETE FROM CARI_ACTIONS WHERE ACTION_ID = #getCariActions.action_id#
		</cfquery>
	</cfloop>
</cfif>

<cfquery name="updProgressReceipt" datasource="#dsn2#">
	UPDATE 
		CARI_ACTIONS 
	SET 
		PROGRESS_ID = NULL
	WHERE 
		PROGRESS_ID = #attributes.progress_id#
</cfquery>
<cfquery name="updProgressInvoice" datasource="#dsn2#">
	UPDATE
		INVOICE
	SET
		PROGRESS_ID = NULL
	WHERE
		PROGRESS_ID = #attributes.progress_id#
</cfquery>

<cfquery name="del_progress" datasource="#dsn3#">
	DELETE FROM PROGRESS_PAYMENT WHERE PROGRESS_ID = #attributes.progress_id#
</cfquery>

<script type="text/javascript">
	try{wrk_opener_reload();} catch(e){};
	window.close();
</script>
