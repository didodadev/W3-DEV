<cfquery name="del_cau" datasource="#dsn#">
	DELETE FROM PROCESS_TYPE_ROWS_CAUID WHERE PROCESS_ROW_ID = #attributes.process_row_id# AND WORKGROUP_ID = #attributes.workgroup_id#
</cfquery>
<cfquery name="del_inf" datasource="#dsn#">
	DELETE FROM PROCESS_TYPE_ROWS_INFID WHERE PROCESS_ROW_ID = #attributes.process_row_id# AND WORKGROUP_ID = #attributes.workgroup_id#
</cfquery>
<cfquery name="del_pos" datasource="#dsn#">
	DELETE FROM PROCESS_TYPE_ROWS_POSID WHERE PROCESS_ROW_ID = #attributes.process_row_id# AND WORKGROUP_ID = #attributes.workgroup_id#
</cfquery>

<cfif isdefined("attributes.to_pos_ids") and len(attributes.to_pos_ids)>
	<cfloop from="1" to="#listlen(attributes.to_pos_ids, ',')#" index="i">
		<cfquery name="add_pro_positions" datasource="#dsn#">
			INSERT INTO
				PROCESS_TYPE_ROWS_POSID
			(
				PROCESS_ROW_ID,
				WORKGROUP_ID,
				PRO_POSITION_ID
			)
			VALUES
			(
				#attributes.process_row_id#,
				#attributes.workgroup_id#,
				#listgetat(attributes.to_pos_ids, i, ',')#
			)
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined("attributes.cc_pos_ids") and len(attributes.cc_pos_ids)>
	<cfloop from="1" to="#listlen(attributes.cc_pos_ids, ',')#" index="i">
		<cfquery name="add_inf_positions" datasource="#dsn#">
			INSERT INTO
				PROCESS_TYPE_ROWS_INFID
			(
				PROCESS_ROW_ID,
				WORKGROUP_ID,
				INF_POSITION_ID
			)
			VALUES
			(
				#attributes.process_row_id#,
				#attributes.workgroup_id#,
				#listgetat(attributes.cc_pos_ids, i, ',')#
			)
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined("attributes.cc2_pos_ids") and len(attributes.cc2_pos_ids)>
	<cfloop from="1" to="#listlen(attributes.cc2_pos_ids, ',')#" index="i">
		<cfquery name="add_cau_positions" datasource="#dsn#">
			INSERT INTO
				PROCESS_TYPE_ROWS_CAUID
				(
					PROCESS_ROW_ID,
					WORKGROUP_ID,
					CAU_POSITION_ID
				)
				VALUES
				(
					#attributes.process_row_id#,
					#attributes.workgroup_id#,
					#listgetat(attributes.cc2_pos_ids, i, ',')#
				)
		</cfquery>
	</cfloop>
</cfif>

<!--- partnerler kaydediliyor --->
<cfif isdefined("attributes.to_par_ids") and len(attributes.to_par_ids)>
	<cfloop from="1" to="#listlen(attributes.to_par_ids, ',')#" index="i">
		<cfquery name="add_pro_partners" datasource="#dsn#">
			INSERT INTO
				PROCESS_TYPE_ROWS_POSID
			(
				PROCESS_ROW_ID,
				WORKGROUP_ID,
				PRO_PARTNER_ID
			)
			VALUES
			(
				#attributes.process_row_id#,
				#attributes.workgroup_id#,
				#listgetat(attributes.to_par_ids, i, ',')#
			)
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined("attributes.cc_par_ids") and len(attributes.cc_par_ids)>
	<cfloop from="1" to="#listlen(attributes.cc_par_ids, ',')#" index="i">
		<cfquery name="add_inf_partners" datasource="#dsn#">
			INSERT INTO
				PROCESS_TYPE_ROWS_INFID
			(
				PROCESS_ROW_ID,
				WORKGROUP_ID,
				INF_PARTNER_ID
			)
			VALUES
			(
				#attributes.process_row_id#,
				#attributes.workgroup_id#,
				#listgetat(attributes.cc_par_ids, i, ',')#
			)
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined("attributes.cc2_par_ids") and len(attributes.cc2_par_ids)>
	<cfloop from="1" to="#listlen(attributes.cc2_par_ids, ',')#" index="i">
		<cfquery name="add_cau_partners" datasource="#dsn#">
			INSERT INTO
				PROCESS_TYPE_ROWS_CAUID
			(
				PROCESS_ROW_ID,
				WORKGROUP_ID,
				CAU_PARTNER_ID
			)
			VALUES
			(
				#attributes.process_row_id#,
				#attributes.workgroup_id#,
				#listgetat(attributes.cc2_par_ids, i, ',')#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfquery name="upd_process_type_rows" datasource="#dsn#">
	UPDATE
		PROCESS_TYPE_ROWS
	SET
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_EMP = #session.ep.userid#
	WHERE
		PROCESS_ROW_ID = #attributes.process_row_id#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
</script>
