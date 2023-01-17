<cfif not isdefined("attributes.to_emp_ids")>
	<cfset attributes.to_emp_ids = ''>
</cfif>
<cfif not isdefined("attributes.to_par_ids")>
	<cfset attributes.to_par_ids = ''>
</cfif>
<cfif not len(attributes.to_emp_ids) and not len(attributes.to_par_ids)>
	<script type="text/javascript">
		alert('Lütfen Yetkili Pozisyon Ekleyiniz !');
		history.back();
	</script>
</cfif>
<cfif isdefined("attributes.cc_pos_ids") or isdefined("attributes.to_pos_ids") or isdefined("attributes.to_pos_ids_1")>
	<cfquery name="ADD_PROCESS_TYPE_WORKGROUP" datasource="#dsn#" result="MAX_ID">
		INSERT
		INTO
			PROCESS_TYPE_ROWS_WORKGRUOP
			(
				WORKGROUP_NAME,
				RECORD_EMP, 
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.grup_isim#">,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
	</cfquery>
	<cfif isdefined("attributes.to_pos_ids") and len(attributes.to_pos_ids)>
		<cfloop from="1" to="#listlen(attributes.to_pos_ids, ',')#" index="i">
			<cfquery name="ADD_PRO_POSITIONS" datasource="#dsn#">
				INSERT
				INTO
					PROCESS_TYPE_ROWS_POSID
					(
						WORKGROUP_ID,
						PRO_POSITION_ID
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#listgetat(attributes.to_pos_ids, i, ',')#
					)
			</cfquery>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.cc_pos_ids") and len(attributes.cc_pos_ids)>
		<cfloop from="1" to="#listlen(attributes.cc_pos_ids, ',')#" index="i">
			<cfquery name="ADD_INF_POSITIONS" datasource="#dsn#">
				INSERT
				INTO
					PROCESS_TYPE_ROWS_INFID
					(
						WORKGROUP_ID,
						INF_POSITION_ID
					)
					VALUES
					(
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
						WORKGROUP_ID,
						CAU_POSITION_ID
					)
					VALUES
					(
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
						WORKGROUP_ID,
						PRO_PARTNER_ID
					)
					VALUES
					(
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
						WORKGROUP_ID,
						INF_PARTNER_ID
					)
					VALUES
					(
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
						WORKGROUP_ID,
						CAU_PARTNER_ID
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#listgetat(attributes.cc2_par_ids, i, ',')#
					)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>
<script type="text/javascript">
	<cfif isDefined('attributes.draggable')>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>

