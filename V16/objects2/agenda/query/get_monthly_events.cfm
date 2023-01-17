<cfif isdefined('attributes.is_partner_event') and attributes.is_partner_event eq 1>
	<cfquery name="GET_PARTNERS" datasource="#DSN#">
		SELECT
			PARTNER_ID
		FROM
			COMPANY_PARTNER
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfquery>
</cfif>

<cfif isdefined("session.agenda_userid")>
<!--- başkasında --->
	<cfif session.agenda_user_type is "p">
		<!--- par --->
		<cfquery name="GET_GRPS" datasource="#DSN#">
			SELECT
				GROUP_ID
			FROM
				USERS
			WHERE
				PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%">
		</cfquery>
	<cfelseif session.agenda_user_type is "e">
		<!--- emp --->
		<cfquery name="GET_GRPS" datasource="#DSN#">
			SELECT
				GROUP_ID
			FROM
				USERS
			WHERE
				POSITIONS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_position_code#,%">
		</cfquery>
	</cfif>
<cfelseif isdefined('session.pp.userid')>
	<!--- kendinde --->
	<cfquery name="GET_GRPS" datasource="#DSN#">
		SELECT
			GROUP_ID
		FROM
			USERS
		WHERE
			PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.userid#,%">
	</cfquery>
</cfif>
<cfset grps = valuelist(get_grps.group_id)>
<cfquery name="GET_MONTHLY_EVENTS" datasource="#DSN#">
	SELECT 
		EVENT_ID,
		STARTDATE,
		FINISHDATE,
		EVENTCAT,
		VALID,
		VALIDATOR_POSITION_CODE,
		EVENT.RECORD_EMP,
		EVENT.UPDATE_EMP,
		RECORD_PAR,
		UPDATE_PAR,
		EVENT_HEAD
	FROM 
		EVENT,
		EVENT_CAT
	WHERE
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND
		(
			(
				(STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#">) AND
				(STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("M",1,attributes.to_day)#">)
			)
			OR
			(
				(FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#">) AND
				(FINISHDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("M",1,attributes.to_day)#">)
			)
		) 
		AND 
		(
			<cfif isDefined("session.agenda_userid")>
				<!--- BAŞKASİNDA --->
				<cfif session.agenda_user_type is "P">
					<!--- PAR --->
					(
						(
							RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR
							UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#">
						)
						AND EVENT_CAT.EVENT_CAT.EVENTCAT_ID <> 1
					)
					OR EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%">
					OR EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%">
					<cfloop list="#grps#" index="grp_i">
						OR EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grp_i#,%">
					</cfloop>
					<cfloop list="#grps#" index="grp_i">
						OR EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grp_i#,%">
					</cfloop>
				<cfelseif session.agenda_user_type is "E">
					<!--- EMP --->
					(
						(
							RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR
							UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#">
						)
						AND EVENT_CAT.EVENTCAT_ID <> 1
					)
					OR EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_position_code#,%">
					OR EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_position_code#,%">
					OR VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_position_code#">
					<cfloop list="#grps#" index="grp_i">
						OR EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grp_i#,%">
					</cfloop>
					<cfloop list="#grps#" index="grp_i">
						OR EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grp_i#,%">
					</cfloop>
				</cfif>
			<cfelse>
			<!--- KENDINDE --->
				<cfif isdefined('attributes.is_partner_event') and attributes.is_partner_event eq 1>
					RECORD_PAR IN (#ValueList(get_partners.partner_id,',')#) OR
					UPDATE_PAR IN (#ValueList(get_partners.partner_id,',')#) OR
					<cfloop query="get_partners">
						EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#partner_id#,%">  OR
						EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#partner_id#,%">  OR
					</cfloop>
					VALIDATOR_PAR IN (#ValueList(get_partners.partner_id,',')#)
				<cfelse>	
					RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
					UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
					EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.userid#,%"> OR
					EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.userid#,%"> OR
					VALIDATOR_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
				</cfif>
				<cfloop LIST="#GRPS#" INDEX="GRP_I">
					OR
					EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
				</cfloop>
				<cfloop LIST="#GRPS#" INDEX="GRP_I">
					OR
					EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
				</cfloop>
			</cfif>
		)
</cfquery>
