<cfif isdefined('par_ids') and len(par_ids)>
	<cfloop list="#par_ids#" index="par_id">
		<cfquery name="GET_CLASS_INFORM" datasource="#DSN#">
			SELECT PAR_ID FROM TRAINING_CLASS_INFORM WHERE CLASS_ID = #attributes.class_id# AND PAR_ID = #par_id#
		</cfquery>
		<cfif not get_class_inform.recordcount>
			<cfquery name="ADD_CLASS_INFORM" datasource="#DSN#">
				INSERT INTO
					TRAINING_CLASS_INFORM
				(
					CLASS_ID,
					PAR_ID		
				)
				VALUES
				(
					#attributes.class_id#,
					#par_id#
				)
			</cfquery>
		</cfif>
	</cfloop>
<cfelseif isdefined('con_ids') and len(con_ids)>
	<cfloop list="#con_ids#" index="con_id">
		<cfquery name="GET_CLASS_INFORM" datasource="#DSN#">
			SELECT CON_ID FROM TRAINING_CLASS_INFORM WHERE CLASS_ID = #attributes.class_id# AND CON_ID = #con_id#
		</cfquery>
		<cfif not get_class_inform.recordcount>
			<cfquery name="ADD_CLASS_INFORM" datasource="#DSN#">
				INSERT INTO
					TRAINING_CLASS_INFORM
				(
					CLASS_ID,
					CON_ID		
				)
				VALUES
				(
					#attributes.class_id#,
					#con_id#
				)
			</cfquery>
		</cfif>
	</cfloop>
<cfelseif isdefined('emp_ids') and len(emp_ids)>
	<cfloop list="#emp_ids#" index="emp_id">
		<cfquery name="GET_CLASS_INFORM" datasource="#DSN#">
			SELECT EMP_ID FROM TRAINING_CLASS_INFORM WHERE CLASS_ID = #attributes.class_id# AND EMP_ID = #emp_id#
		</cfquery>
		<cfif not get_class_inform.recordcount>
			<cfquery name="ADD_CLASS_INFORM" datasource="#DSN#">
				INSERT INTO
					TRAINING_CLASS_INFORM
				(
					CLASS_ID,
					EMP_ID		
				)
				VALUES
				(
					#attributes.class_id#,
					#emp_id#
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
