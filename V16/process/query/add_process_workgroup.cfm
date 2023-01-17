<cfif isdefined("attributes.cc_pos_ids") or isdefined("attributes.to_pos_ids") or isdefined("attributes.cc2_pos_ids")>
	<cfquery name="add_process_type_workgroup" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			PROCESS_TYPE_ROWS_WORKGRUOP
			(
				PROCESS_ROW_ID
			)
			VALUES
			(
				#attributes.process_row_id#
			)
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
						#MAX_ID.IDENTITYCOL#,
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
						#MAX_ID.IDENTITYCOL#,
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
						#MAX_ID.IDENTITYCOL#,
						#listgetat(attributes.cc2_pos_ids, i, ',')#
					)
			</cfquery>
		</cfloop>
	</cfif>
	<!--- partnerlar --->
	<cfif isdefined("attributes.to_par_ids") and len(attributes.to_par_ids)>
		<cfloop from="1" to="#listlen(attributes.to_par_ids, ',')#" index="i">
			<cfquery name="add_pro_partner" datasource="#dsn#">
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
						#MAX_ID.IDENTITYCOL#,
						#listgetat(attributes.to_par_ids, i, ',')#
					)
			</cfquery>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.cc_par_ids") and len(attributes.cc_par_ids)>
		<cfloop from="1" to="#listlen(attributes.cc_par_ids, ',')#" index="i">
			<cfquery name="add_inf_partner" datasource="#dsn#">
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
						#MAX_ID.IDENTITYCOL#,
						#listgetat(attributes.cc_par_ids, i, ',')#
					)
			</cfquery>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.cc2_par_ids") and len(attributes.cc2_par_ids)>
		<cfloop from="1" to="#listlen(attributes.cc2_par_ids, ',')#" index="i">
			<cfquery name="add_cau_partner" datasource="#dsn#">
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
						#MAX_ID.IDENTITYCOL#,
						#listgetat(attributes.cc2_par_ids, i, ',')#
					)
			</cfquery>
		</cfloop>
	</cfif>
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
