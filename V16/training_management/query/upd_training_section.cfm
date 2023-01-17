<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_section" datasource="#dsn#">
			UPDATE
				TRAINING_SEC
			SET
				TRAINING_CAT_ID = #TRAINING_CAT_ID#,
				SECTION_NAME = '#SECTION_NAME#',
				SECTION_DETAIL = '#SECTION_DETAIL#',
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_DATE = #NOW()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#'
			WHERE
				TRAINING_SEC_ID = #FORM.TRAINING_SEC_ID#
		</cfquery>

		<cfquery name="DEL_SEC_TRAINERS" datasource="#DSN#">
			DELETE FROM
				TRAINING_SEC_TRAINER
			WHERE
				TRAINING_SEC_ID = #form.training_sec_id#
		</cfquery>
	
		<cfloop list="#FORM.TRAINERS#" index="i" delimiters=",">
			<cfif i contains "emp">
				<cfquery name="ADD_CLASS" datasource="#DSN#">
					INSERT INTO
						TRAINING_SEC_TRAINER
					(
						TRAINING_SEC_ID,
						EMP_ID
					)
					VALUES
					(
						#FORM.TRAINING_SEC_ID#,
						#LISTGETAT(I,2,'-')#
					)
				</cfquery>
			<cfelseif i contains "par">
				<cfquery name="ADD_CLASS" datasource="#DSN#">
					INSERT INTO
						TRAINING_SEC_TRAINER
					(
						TRAINING_SEC_ID,
						PAR_ID,
						COMP_ID
					)
					VALUES
					(
						#FORM.TRAINING_SEC_ID#,
						#LISTGETAT(I,2,'-')#,
						#LISTGETAT(I,3,'-')#
					)
				</cfquery>
			<cfelseif i contains "grp">
				<cfquery name="ADD_CLASS" datasource="#DSN#">
					INSERT INTO
						TRAINING_SEC_TRAINER
					(
						TRAINING_SEC_ID,
						GRP_ID
					)
					VALUES
					(
						#FORM.TRAINING_SEC_ID#,
						#LISTGETAT(I,2,'-')#
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<script>
        window.location.href = '<cfoutput>#request.self#?fuseaction=training_management.definitions&event=upd&training_sec_id=#FORM.TRAINING_SEC_ID#</cfoutput>';
</script>
