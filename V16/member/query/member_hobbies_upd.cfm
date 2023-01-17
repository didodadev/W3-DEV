<cfquery name="DEL_CONSUMER_HOBBY" datasource="#dsn#"> 
	DELETE FROM CONSUMER_HOBBY WHERE CONSUMER_ID = #attributes.consumer_id#
</cfquery>
<cfoutput>
<cfif isDefined('attributes.hobby')>
	<cfloop from="1" to="#Listlen(attributes.hobby)#" index="i"> 
		<cfset liste = ListGetAt(form.hobby,i)>
		<cfquery name="add_emp_hobbies" datasource="#dsn#"> 
			INSERT INTO CONSUMER_HOBBY
			(
				CONSUMER_ID,
				HOBBY_ID
			)
			VALUES
			(
				#attributes.consumer_id#,
				#liste#
			)
		</cfquery> 
	</cfloop>
</cfif>
</cfoutput>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>
