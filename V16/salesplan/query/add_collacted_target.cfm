<cfif isdefined("attributes.is_upd")>
	<cfquery name="ADD_PLAN" datasource="#dsn#">
		UPDATE 
			SALES_QUARTER_PLAN 
		SET 
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
		WHERE 
			QUARTER_PLAN_ID = #attributes.plan_id#
	</cfquery>
	<cfquery name="DEL_ROW" datasource="#dsn#">
		DELETE FROM SALES_QUARTER_PLAN_ROW WHERE PLAN_ID = #attributes.plan_id#
	</cfquery>
	<cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
		SELECT 
			SALES_ZONES_TEAM.LEADER_POSITION_CODE,
			SALES_ZONES_TEAM.TEAM_ID,
			SALES_ZONES.SZ_ID,
			SALES_ZONES_TEAM.TEAM_NAME,
			SALES_ZONES.SZ_NAME
		FROM 
			SALES_ZONES_TEAM,
			SALES_ZONES
		WHERE 
			SALES_ZONES.SZ_ID = SALES_ZONES_TEAM.SALES_ZONES AND 
			SALES_ZONES_TEAM.LEADER_POSITION_CODE IS NOT NULL
		ORDER BY 
			SALES_ZONES_TEAM.TEAM_NAME
	</cfquery>
	<cfoutput query="get_sales_zones_team">
		<cfloop from="1" to="5" index="i">
			<cfset birincideger = i>
			<cfloop from="1" to="3" index="k">
					<cfset ikincideger = k>
					<cfloop from="1" to="3" index="s">
						<cfset ucuncudeger = s>
						<cfset deger_amount_value = evaluate("attributes.quate_target_#get_sales_zones_team.team_id#_#birincideger#_#ikincideger#_#ucuncudeger#")>
						<cfset deger_amount_value = filterNum(deger_amount_value)>
						<cfif len(deger_amount_value)>
							<cfquery name="ADD_PLAN_ROW" datasource="#dsn#">
								INSERT 
								INTO 
									SALES_QUARTER_PLAN_ROW 
									(
										PLAN_YEAR,
										PLAN_ID,
										TEAM_ID,
										PERIOD_ID,
										TYPE_ID,
										CATEGORY_ID,
										ROW_VALUE
									) 
									VALUES
									(
										#attributes.quote_year#,
										#attributes.plan_id#,
										#get_sales_zones_team.team_id#,
										#birincideger#,
										#ikincideger#,
										#ucuncudeger#,
										#deger_amount_value#
									)
							</cfquery>
						</cfif>
				</cfloop>
			</cfloop>
		</cfloop>
	</cfoutput>
<cfelse>
	<cfquery name="ADD_PLAN" datasource="#dsn#" result="MAX_ID">
		INSERT 
		INTO 
			SALES_QUARTER_PLAN 
			(
				PERIOD,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			) 
			VALUES
			(
				#attributes.quote_year#,
				#session.ep.userid#,
				#now()#,
				'#cgi.remote_addr#'
			)
	</cfquery>
	<cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
		SELECT 
			SALES_ZONES_TEAM.LEADER_POSITION_CODE,
			SALES_ZONES_TEAM.TEAM_ID,
			SALES_ZONES.SZ_ID,
			SALES_ZONES_TEAM.TEAM_NAME,
			SALES_ZONES.SZ_NAME
		FROM 
			SALES_ZONES_TEAM,
			SALES_ZONES
		WHERE 
			SALES_ZONES.SZ_ID = SALES_ZONES_TEAM.SALES_ZONES AND 
			SALES_ZONES_TEAM.LEADER_POSITION_CODE IS NOT NULL
		ORDER BY 
			SALES_ZONES_TEAM.TEAM_NAME
	</cfquery>
	<cfoutput query="get_sales_zones_team">
		<cfloop from="1" to="5" index="i">
			<cfset birincideger = i>
			<cfloop from="1" to="3" index="k">
					<cfset ikincideger = k>
					<cfloop from="1" to="3" index="s">
						<cfset ucuncudeger = s>
						<cfset deger_amount_value = evaluate("attributes.quate_target_#get_sales_zones_team.team_id#_#birincideger#_#ikincideger#_#ucuncudeger#")>
						<cfset deger_amount_value = filterNum(deger_amount_value)>
						<cfif len(deger_amount_value)>
							<cfquery name="ADD_PLAN_ROW" datasource="#dsn#">
								INSERT 
								INTO 
									SALES_QUARTER_PLAN_ROW 
									(
										PLAN_YEAR,
										PLAN_ID,
										TEAM_ID,
										PERIOD_ID,
										TYPE_ID,
										CATEGORY_ID,
										ROW_VALUE
									) 
									VALUES
									(
										#attributes.quote_year#,
										#MAX_ID.IDENTITYCOL#,
										#get_sales_zones_team.team_id#,
										#birincideger#,
										#ikincideger#,
										#ucuncudeger#,
										#deger_amount_value#
									)
							</cfquery>
						</cfif>
				</cfloop>
			</cfloop>
		</cfloop>
	</cfoutput>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
