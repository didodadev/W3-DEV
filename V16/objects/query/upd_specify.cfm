<cfif attributes.operation eq 'upd'>
	<cfquery name="upd_specify" datasource="#dsn3#">  
		UPDATE 
			SERVICE_GUARANTY_NEW
    	SET	
			PROCESS_CAT=#attributes.type#,
			<cfif attributes.type eq 1191>PURCHASE_COMPANY_ID=#attributes.company_id#,<cfelseif #attributes.type# eq 1192>SALE_COMPANY_ID=#attributes.company_id#,</cfif>
			UPDATE_DATE=#NOW()#,
			UPDATE_EMP=#SESSION.EP.USERID#,
			UPDATE_IP='#CGI.REMOTE_ADDR#'	
		WHERE 
			GUARANTY_ID=#attributes.guaranty_id#
	</cfquery>
<cfelseif attributes.operation eq 'del'>
		<cfquery name="del_specify" datasource="#dsn3#">  
		  DELETE FROM
			SERVICE_GUARANTY_NEW
		  WHERE
			GUARANTY_ID = #attributes.guaranty_id#
	</cfquery>
</cfif>
 <cflocation url="#request.self#?fuseaction=objects.serial_no&event=det&product_serial_no=#attributes.serial_no#&seri_stock_id=#attributes.stock_id#&rma_no=" addtoken="no">
