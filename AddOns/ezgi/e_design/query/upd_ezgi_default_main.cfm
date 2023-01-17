<cfquery name="get_name_control" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_MAIN_ROW_SETUP WHERE MAIN_ROW_SETUP_NAME = '#attributes.default_type#' AND MAIN_ROW_SETUP_ID <> #attributes.main_id#
</cfquery>
<cfif get_name_control.recordcount>
	<script type="text/javascript">
		alert("Aynı İsimde Default Modül Mevcut Lütfen Düzeltiniz!");
		window.history.go(-1);
	</script>
	<cfabort>
</cfif>
<cftransaction>
    <cfquery name="upd_main_default" datasource="#dsn3#">
    	UPDATE     
        	EZGI_DESIGN_MAIN_ROW_SETUP
		SET                
        	MAIN_ROW_SETUP_CODE = '#attributes.default_code#', 
            MAIN_ROW_SETUP_NAME = '#attributes.default_type#', 
            STATUS = <cfif isdefined('attributes.status')>1<cfelse>0</cfif>, 
            UPDATE_EMP = #session.ep.userid#, 
            UPDATE_DATE = #now()#, 
            UPDATE_IP = '#cgi.remote_addr#'
		WHERE        
        	MAIN_ROW_SETUP_ID = #attributes.main_id#
    </cfquery>
</cftransaction>
<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_default_main&main_id=#attributes.main_id#" addtoken="No">