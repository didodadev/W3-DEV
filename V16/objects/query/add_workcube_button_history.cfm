<cfsetting showdebugoutput="no">
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfloop from="1" to="#listlen(attributes.history_table_list)#" index="kk">
	<cfset dsn_info = listgetat(attributes.history_datasource_list,kk)>
	<cfquery name="add_hist" datasource="#evaluate("attributes.#dsn_info#")#">
	<cfif listgetat(attributes.history_table_list,kk) is 'CARI_CLOSED'>
	    SET IDENTITY_INSERT [CARI_CLOSED_HISTORY] OFF 
	</cfif>
		INSERT INTO
			#listgetat(attributes.history_table_list,kk)#_HISTORY
		SELECT
			<cfif len(attributes.is_wrkId) and attributes.is_wrkId eq 1>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
			</cfif>
			<cfif len(attributes.history_act_type)>
				#history_act_type#,
			</cfif>
			*
		FROM
			#listgetat(attributes.history_table_list,kk)#
		WHERE
			#attributes.history_identy#	= #attributes.history_action_id#
			<cfif isdefined("attributes.history_act_type") and len(attributes.history_act_type) and attributes.history_act_type eq 1 and listgetat(attributes.history_table_list,kk) is 'CARI_CLOSED_ROW'>
				AND ISNULL(CLOSED_AMOUNT,0)<>0
			<cfelseif isdefined("attributes.history_act_type") and len(attributes.history_act_type) and attributes.history_act_type eq 2 and listgetat(attributes.history_table_list,kk) is 'CARI_CLOSED_ROW'>
				AND ISNULL(PAYMENT_VALUE,0)<>0
			<cfelseif isdefined("attributes.history_act_type") and len(attributes.history_act_type) and attributes.history_act_type eq 3 and listgetat(attributes.history_table_list,kk) is 'CARI_CLOSED_ROW'>
				AND ISNULL(P_ORDER_VALUE,0)<>0
			</cfif>
	<cfif listgetat(attributes.history_table_list,kk) is 'CARI_CLOSED'>
		SET IDENTITY_INSERT [CARI_CLOSED_HISTORY] ON
	</cfif>
	</cfquery>
</cfloop>
<script type="text/javascript">
	disableAction(1);
</script>
