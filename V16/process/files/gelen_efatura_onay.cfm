<cfquery name="upd_inv" datasource="#attributes.data_source#">
	UPDATE 
		#caller.dsn2_alias#.EINVOICE_RECEIVING_DETAIL 
	SET 
		IS_APPROVE = 1,
		UPDATE_EMP =  #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#
	WHERE 
		RECEIVING_DETAIL_ID = #attributes.action_id#
</cfquery>
