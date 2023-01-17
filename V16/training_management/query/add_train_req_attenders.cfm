<cfif IsDefined("attributes.employee_ids") and len(attributes.employee_ids)>
	<cfloop list="#attributes.employee_ids#" index="employee" delimiters=",">
		<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#dsn#">
			SELECT
				EMP_ID
			FROM
				TRAINING_CLASS_ATTENDER
			WHERE
				CLASS_ID=#attributes.CLASS_ID#
				AND EMP_ID=#listgetat(employee,1,'-')#
		</cfquery>
		<cfif not GET_CLASS_POTENTIAL_ATTENDER.RECORDCOUNT>
			<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#dsn#">
				INSERT INTO
					TRAINING_CLASS_ATTENDER
					(
					CLASS_ID,
					EMP_ID		
					)
				VALUES
					(
					#attributes.CLASS_ID#,
					#listgetat(employee,1,'-')#
					)
			</cfquery>
		</cfif>
			<cfquery name="UPD_REQ_ROWS" datasource="#dsn#">
				UPDATE
					TRAINING_REQUEST_ROWS
				SET
					IS_VALID=1,
					VALID_EMP=#listgetat(employee,1,'-')#,
					VALID_DATE=#NOW()#
				WHERE 
					REQUEST_ROW_ID=#listgetat(employee,2,'-')#
			</cfquery>
	</cfloop>
</cfif>
<script type="text/javascript">
	<cfif isDefined("attributes.draggable")>
        closeBoxDraggable('train_request_box');
    <cfelse>
        wrk_opener_reload();
        self.close();
    </cfif>
</script>