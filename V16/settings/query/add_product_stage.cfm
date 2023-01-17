<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
        <cfquery name="INSPRO_STAGE" datasource="#DSN3#">
            INSERT INTO 
                PRODUCT_STAGE
            (
                PRODUCT_STAGE
                <cfif len(detail)>,PRODUCT_STAGE_DETAIL</cfif>,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP
            ) 
            VALUES 
            (
                '#product_stage#'
                <cfif len(detail)>,'#DETAIL#'</cfif>,
                '#cgi.remote_addr#',
                #now()#,
                #session.ep.userid#
            )
        </cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_pro_stage" addtoken="no">
