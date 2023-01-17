<cfscript>
	cfc = createObject("component","V16.project.cfc.get_work");
	del_workSteps = cfc.delWorkSteps(WORK_ID:attributes.work_id);
</cfscript>
<cfloop from="1" to="#attributes.record_num#" index="i">
    <cfscript>
		if(evaluate('attributes.step_kontrol#i#') == 1) {
			addWorkSteps = cfc.addWorkSteps(
            WORK_ID : attributes.work_id,
			WORK_STEP_DETAIL : attributes["WORK_STEP_DETAIL#i#"],
			work_step_hour: evaluate(attributes["work_step_hour#i#"]),
			work_step_minute : evaluate(attributes["work_step_minute#i#"]),
			completion : iif(isdefined("attributes.completion#i#"),'val(attributes["completion#i#"])',DE("0"))
			); 
		}
    </cfscript>
</cfloop>
<script>
        refresh_box('work_steps','index.cfm?fuseaction=project.workSteps&id=<cfoutput>#attributes.work_id#</cfoutput>','0');
</script>