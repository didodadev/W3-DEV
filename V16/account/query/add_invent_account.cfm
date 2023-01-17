<cfif isdefined("t")>
	<cfswitch expression="#URL.T#">
		<cfcase value="1">
			<cfset FIELD_NAME = "INVENTORY_RE_ACCOUNT_CODE">
			<cfset FIELD_VALUE = attributes.account_code>
		</cfcase>
		<cfcase value="2">
			<cfset FIELD_NAME = "INVENTORIES_ACCOUNT_CODE">
			<cfset FIELD_VALUE = attributes.account_id_invent>
		</cfcase>
		<cfcase value="3">
			<cfset FIELD_NAME = "INVENTORY_EXP_ACC_CODE">
			<cfset FIELD_VALUE = attributes.account_id_exp>
		</cfcase>
		<cfcase value="4">
			<cfset FIELD_NAME = "INVENTORY_SALE_COST_ACC_CODE">
			<cfset FIELD_VALUE = attributes.account_id_cost>
		</cfcase>
		<cfcase value="5">
			<cfset FIELD_NAME = "INVENTORY_ACCOUNT_CODE">
			<cfset FIELD_VALUE = attributes.ACCOUNT_ID>
		</cfcase>
	</cfswitch>
<cfelse>
			<cfset FIELD_NAME = "INVENTORY_ACCOUNT_CODE">
			<cfset FIELD_VALUE = attributes.ACCOUNT_ID>
</cfif>
	<cfquery name="GET_ACCOUNT" datasource="#DSN3#">
		SELECT
			INVENTORY_DEF_ID AS ID,
			INVENTORY_RE_ACCOUNT_CODE AS CODE
		FROM
			SETUP_INVENTORY_DEFINITION
		WHERE
			#FIELD_NAME# IS NOT NULL
	</cfquery>
	<cfif GET_ACCOUNT.recordcount >
		<cfquery name="UPD_ACC_CODE" datasource="#DSN3#">
			UPDATE
				SETUP_INVENTORY_DEFINITION
			SET
				<cfif LEN(FIELD_VALUE)>
					#FIELD_NAME#='#FIELD_VALUE#'
				<cfelse>
					#FIELD_NAME#=NULL
				</cfif>
			WHERE
				INVENTORY_DEF_ID=#GET_ACCOUNT.ID#
		</cfquery>
		<cflocation url="#request.self#?fuseaction=account.form_add_invent" addtoken="no">
	</cfif> 
	<cfquery name="add_invent_account" datasource="#dsn3#">
		INSERT INTO
			SETUP_INVENTORY_DEFINITION
					(
						#FIELD_NAME#,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
		VALUES
					(
						<cfif LEN(FIELD_VALUE)>'#FIELD_VALUE#',<cfelse>NULL,</cfif>
						#NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#'
					)
	</cfquery>
<!------<cfabort>------->
<cflocation url="#request.self#?fuseaction=account.form_add_invent" addtoken="no">
