<cfif listlen(attributes.action_id)>
	<cfset barcode_row = Listlen(attributes.action_id)>
 	<cfloop from="1" to="#barcode_row#" index="i" step="1">
		<cfquery name="del_spool" datasource="#dsn3#">
			DELETE FROM 
            	EZGI_PDA_PRINT_SPOOL
			WHERE        
            	EZGI_PRINT_ID =  #ListGetAt(ListGetAt(attributes.action_id,i,','),1,'_')# 
       	</cfquery>
  	</cfloop>
</cfif>
<script type="text/javascript">
	alert('<cf_get_lang_main no='3191.Havuz Silme ��lemi Tamamlanm��t�r !'>');
	wrk_opener_reload();
	window.close();
</script>