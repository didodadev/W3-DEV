<cfquery name="GET_COMPANY_RIVAL_DETAIL" datasource="#dsn#">
	SELECT 
		RIVAL_ID
	FROM 
		COMPANY_RIVAL_DETAIL
	WHERE
		COMPANY_ID = #attributes.cpid# AND
		RIVAL_ID = #attributes.r_id#
</cfquery>
<cfif get_company_rival_detail.recordcount>
	<cfquery name="UPD_COMPANY_RIVAL_DETAIL" datasource="#dsn#">
		UPDATE
			COMPANY_RIVAL_DETAIL
		SET
			SERVICE_NUMBER = <cfif len(attributes.service_number)>#attributes.service_number#,<cfelse>NULL,</cfif>
			RELATION_LEVEL = <cfif len(attributes.relation_level)>#attributes.relation_level#,<cfelse>NULL,</cfif>
			SPECIAL_INFO = <cfif len(attributes.special_info)>'#attributes.special_info#'<cfelse>NULL</cfif>
		WHERE
			COMPANY_ID = #attributes.cpid# AND
			RIVAL_ID = #attributes.r_id#
	</cfquery>
	<cfquery name="del_apply" datasource="#dsn#">
		DELETE FROM
			COMPANY_RIVAL_OPTION_APPLY 
		WHERE
			RIVAL_ID = #attributes.r_id# AND 
			COMPANY_ID = #attributes.cpid#
	</cfquery>
	<cfif isDefined('attributes.option_applied')>
		<cfloop list="#attributes.option_applied#" index="i">
			<cfquery name="ins_apply" datasource="#dsn#">
				INSERT INTO 
					COMPANY_RIVAL_OPTION_APPLY
				(
					OPTION_ID,
					RIVAL_ID,
					COMPANY_ID
				)
				VALUES
				(
					#i#,
					#attributes.r_id#,
					#attributes.cpid#
				)
			</cfquery>
		</cfloop>
	</cfif>
	<cfquery name="del_activity" datasource="#dsn#">
		DELETE FROM
			COMPANY_RIVAL_ACTIVITY 
		WHERE
			RIVAL_ID = #attributes.r_id# AND 
			COMPANY_ID = #attributes.cpid#
	</cfquery>
	<cfif isDefined('attributes.activity')>
		<cfloop list="#attributes.activity#" index="i">
			<cfquery name="ins_activity" datasource="#dsn#">
				INSERT INTO 
					COMPANY_RIVAL_ACTIVITY
				(
					ACTIVITY_ID,
					RIVAL_ID,
					COMPANY_ID
				)
				VALUES
				(
					#i#,
					#attributes.r_id#,
					#attributes.cpid#
				)
			</cfquery>
		</cfloop>
	</cfif>
<cfelse>
	<cfquery name="ADD_COMPANY_RIVAL_DETAIL" datasource="#dsn#">
		INSERT INTO 
			COMPANY_RIVAL_DETAIL
		(
			COMPANY_ID,
			SERVICE_NUMBER,
			RELATION_LEVEL,
			SPECIAL_INFO, 
			RIVAL_ID
		)
		VALUES
		(
			#attributes.cpid#,
			<cfif len(attributes.service_number)>#attributes.service_number#,<cfelse>NULL,</cfif>
			<cfif len(attributes.relation_level)>#attributes.relation_level#,<cfelse>NULL,</cfif>
			<cfif len(attributes.special_info)>'#attributes.special_info#',<cfelse>NULL,</cfif>
			#attributes.r_id#
		)
	</cfquery>
	<cfquery name="del_apply2" datasource="#dsn#">
		DELETE FROM
			COMPANY_RIVAL_OPTION_APPLY 
		WHERE
			RIVAL_ID = #attributes.r_id# AND 
			COMPANY_ID = #attributes.cpid#
	</cfquery>
	<cfif isDefined('attributes.option_applied')>
		<cfloop list="#attributes.option_applied#" index="i">
			<cfquery name="ins_apply2" datasource="#dsn#">
				INSERT INTO 
					COMPANY_RIVAL_OPTION_APPLY
				(
					OPTION_ID,
					RIVAL_ID,
					COMPANY_ID
				)
				VALUES
				(
					#i#,
					#attributes.r_id#,
					#attributes.cpid#
				)
			</cfquery>
		</cfloop>
	</cfif>
	<cfquery name="del_activity2" datasource="#dsn#">
		DELETE FROM
			COMPANY_RIVAL_ACTIVITY 
		WHERE
			RIVAL_ID = #attributes.r_id# AND 
			COMPANY_ID = #attributes.cpid#
	</cfquery>
	<cfif isDefined('attributes.activity')>
		<cfloop list="#attributes.activity#" index="i">
			<cfquery name="ins_activity2" datasource="#dsn#">
				INSERT INTO 
					COMPANY_RIVAL_ACTIVITY
				(
					ACTIVITY_ID,
					RIVAL_ID,
					COMPANY_ID
				)
				VALUES
				(
					#i#,
					#attributes.r_id#,
					#attributes.cpid#
				)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
