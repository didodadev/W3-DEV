<cflock name="#CREATEUUID()#" timeout="60">
 	<cftransaction>
        <cfquery name="GET_SCHEDULES" datasource="#DSN#">
            DELETE
            FROM 
                SCHEDULE_SETTINGS 
            WHERE
                SCHEDULE_ID = #attributes.schedule_id#
        </cfquery>
        
        <!--- schedule Silme de sorun olursa --->
        <cftry>
            <cfschedule action="Delete" task="#attributes.schedule_name#">
            <cfcatch type="any">
				<script type="text/javascript">
                	alert("Bulunduğunuz instance'da bu isimle zaman ayarlı bir görev bulunmamaktadır.Lütfen sistem yöneticinize başvurunuz!");
                </script>
          	</cfcatch>    
        </cftry>  
      <cf_add_log  log_type="-1" action_id="#attributes.schedule_id#">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.list_schedule_settings" addtoken="no">
