<!--- Bilgi verilecekler listesinden kayıt siliniyor.. --->
<cfquery name="UPD_CLASS_INFORM" datasource="#DSN#">
	DELETE FROM
		TRAINING_CLASS_INFORM
	WHERE
		<cfif url.inf_type eq 'inf_employee'>
		EMP_ID = #url.del_id#
		<cfelseif url.inf_type eq 'inf_partner'>
		PAR_ID = #url.del_id#
		<cfelseif url.inf_type eq 'inf_consumer'>
		CON_ID =  #url.del_id#
		<cfelseif url.inf_type eq 'inf_group'> 
		GRP_ID = #url.del_id#
		</cfif>
		AND CLASS_ID = #url.inf_class_id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
