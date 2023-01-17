<cfif isdefined('chng_master_alt_plan') and len(chng_master_alt_plan)>
	<cfquery name="GET_NEW_INFO" datasource="#dsn3#">
       	SELECT     
           	EMAP.MASTER_PLAN_ID, 
            EMAP.PROCESS_ID, 
            EMAP.MASTER_ALT_PLAN_ID
		FROM         
          	EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN
           	EZGI_MASTER_PLAN_SABLON AS EMPS ON EMAP.PROCESS_ID = EMPS.PROCESS_ID
		WHERE     
           	EMAP.MASTER_ALT_PLAN_ID = #chng_master_alt_plan#
    </cfquery>
	<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_master_sub_plan_manual&master_plan_id=#GET_NEW_INFO.MASTER_PLAN_ID#&master_alt_plan_id=#GET_NEW_INFO.MASTER_ALT_PLAN_ID#&islem_id=#GET_NEW_INFO.PROCESS_ID#" addtoken="No">
<cfelse>
	<script language="javascript">
        	alert ('<cf_get_lang_main no='3461.Alt Plan Seçip Tekrar Deneyin'>');
		history.back();
	</script>
</cfif>