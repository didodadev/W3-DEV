<cfif not (isdefined("attributes.training_cat_id") and len(attributes.training_cat_id))>
	<script type="text/javascript">
		alert("<cf_get_lang no ='521.Önce Eğitim Üst Kategorisi Seçiniz '>!!");
	</script>
	<cfabort>
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SECTION" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				TRAINING_SEC
			(
				TRAINING_CAT_ID,
				SECTION_NAME,
				SECTION_DETAIL,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				#TRAINING_CAT_ID#,
				'#SECTION_NAME#',
				'#SECTION_DETAIL#',
				#SESSION.EP.USERID#,
				#NOW()#,
				'#CGI.REMOTE_ADDR#'
			)
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
						#MAX_ID.IDENTITYCOL#,
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
						#MAX_ID.IDENTITYCOL#,
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
						#MAX_ID.IDENTITYCOL#,
						#LISTGETAT(I,2,'-')#
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<script>
    window.location.href = '<cfoutput>#request.self#?fuseaction=training_management.definitions&event=upd&training_sec_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>