<cfsetting showdebugoutput="no">
<cfquery name="upd_status" datasource="#dsn3#">
	UPDATE 
		PRODUCTION_ORDERS 
	SET 
		STATUS = #attributes.status#,
		<cfif isdefined("attributes.stock_reserved")>
			IS_STOCK_RESERVED = #attributes.stock_reserved#,
		</cfif>	
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_EMP = #session.ep.userid#				
	WHERE 
		P_ORDER_ID = #attributes.upd#
</cfquery>
<cfif isdefined("attributes.status") or isdefined("attributes.stock_reserved")>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1927.Güncellendi'>!");
	</script>
</cfif>	

