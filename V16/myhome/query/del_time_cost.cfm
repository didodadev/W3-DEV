<cfquery name="del_time_cost" datasource="#dsn#">
  DELETE FROM TIME_COST WHERE TIME_COST_ID = #TIME_COST_ID# 
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.TIME_COST_ID#" action_name="ZAMAN HARCAMASI">
<cfif isdefined("attributes.is_popup")>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
<cfelse>
	<script>    
		window.location.href='<cfoutput>#request.self#?fuseaction=myhome.mytime_management&event=list</cfoutput>';
	</script>
</cfif>



