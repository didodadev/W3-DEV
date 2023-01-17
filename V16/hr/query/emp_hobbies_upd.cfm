<cfquery name="DEL_EMPLOYEES_HOBBY" datasource="#dsn#"> 
	DELETE FROM EMPLOYEES_HOBBY WHERE EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<cfoutput>
	<cfif isDefined('attributes.hobby')>
		<cfloop from="1" to="#Listlen(attributes.hobby)#" index="i"> 
			<cfset liste = ListGetAt(attributes.hobby,i)>
			<cfquery name="add_emp_hobbies" datasource="#dsn#"> 
				INSERT INTO EMPLOYEES_HOBBY
				(
					EMPLOYEE_ID,
					HOBBY_ID
				)
				VALUES
				(
					#attributes.employee_id#,
					#liste#
				)
			</cfquery> 
		</cfloop>
	</cfif>
</cfoutput>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>
