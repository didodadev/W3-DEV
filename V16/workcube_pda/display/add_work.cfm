<cfquery name="ADD_WORK" datasource="#dsn#">
	INSERT INTO
		PRO_WORKS
			(
			WORK_HEAD,
			WORK_DETAIL,
			TARGET_START,
			TARGET_FINISH
			)
		VALUES
			(
			'#FORM.WORK_HEAD#',
			'#FORM.WORK_DETAIL#',
			#attributes.WORK_H_START#,
			#attributes.WORK_H_FINISH#
			)
</cfquery>
