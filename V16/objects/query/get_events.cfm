<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfif isdefined("session.agenda_userid")>
	<!--- Baskasinda --->
	<cfif session.agenda_user_type is "p">
		<!--- par --->
		<cfquery name="get_groups" datasource="#dsn#">
			SELECT GROUP_ID FROM USERS WHERE PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%">
		</cfquery>
		<cfquery name="get_workgroups" datasource="#dsn#">
			SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#">
		</cfquery>
	<cfelseif session.agenda_user_type is "e">
		<!--- emp --->
		<cfquery name="get_groups" datasource="#dsn#">
			SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_position_code#,%">
		</cfquery>
		<cfquery name="get_workgroups" datasource="#dsn#">
			SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_position_code#">
		</cfquery>
	</cfif>
<cfelse>
	<!--- kendinde --->
	<cfquery name="get_groups" datasource="#dsn#">
		SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.position_code#,%">
	</cfquery>
	<cfquery name="get_workgroups" datasource="#dsn#">
		SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
</cfif>
<cfset groups = valuelist(get_groups.group_id)>
<cfset workgroups = valuelist(get_workgroups.workgroup_id)>
<!--- Default Olarak Uye Alanının Doldurulmasini Saglar  --->
<cfif isdefined('attributes.company_id') and len(attributes.company_id) and attributes.member_type eq 'partner'>
	<cfquery name="get_related_partners" datasource="#dsn#">
		SELECT * FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.company_id#
	</cfquery>
	<cfset partner_id_list = ValueList(get_related_partners.partner_id)>
</cfif>
<!--- //Default Olarak Uye Alanının Doldurulmasini Saglar  --->
<cfquery name="get_event" datasource="#dsn#">
	SELECT
		1 TYPE,
		EVENT.EVENT_ID,
		'' EVENT_ROW_ID,
		EVENT.EVENT_HEAD,
		EVENT.RECORD_EMP,
		EVENT.EVENT_TO_POS,
		EVENT.EVENT_TO_CON,
		EVENT.EVENT_TO_PAR,
		EVENT.STARTDATE,
		EVENT.FINISHDATE,
		EVENT.EVENTCAT_ID,
		EVENT.PROJECT_ID,
		EVENT_CAT.EVENTCAT
	FROM
		EVENT,
		EVENT_CAT
	WHERE
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID
		AND EVENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfif isdefined("attributes.event_cat") and len(attributes.event_cat)>
			AND EVENT.EVENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_cat#"></cfif>
		<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date") and len(attributes.start_date) and len(attributes.finish_date)>
			AND STARTDATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> 
			AND FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.finish_date)#">
		<cfelseif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		<cfelseif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			AND FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.finish_date)#">
		</cfif>
		<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
			AND
			(
				<cfloop list="#partner_id_list#" index="par_id">
					 EVENT_TO_PAR LIKE '%,#par_id#,%' <cfif par_id neq listlast(partner_id_list,',')>OR</cfif> 
				</cfloop>
			)
		<cfelseif len(attributes.company) and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
			AND EVENT_TO_CON LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.consumer_id#,%">
		</cfif>
		AND 
		(
		<cfif isDefined("session.agenda_userid")>
			<!--- Baskasinda --->
			<cfif SESSION.AGENDA_USER_TYPE IS "P">
			<!--- PAR --->
			(
				(
					EVENT.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR
					EVENT.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#">
				)
			)
			OR EVENT.EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%">
			OR EVENT.EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%">
			<cfloop list="#GRPS#" INDEX="GRP_I">
				OR EVENT.EVENT_TO_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop list="#GRPS#" INDEX="GRP_I">
				OR EVENT.EVENT_CC_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
			   OR EVENT.EVENT_TO_WRKGROUP LIKE '%,#WRK#,%'
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
			  OR EVENT.EVENT_CC_WRKGROUP LIKE '%,#WRK#,%'
			</cfloop>

			<cfelseif SESSION.AGENDA_USER_TYPE IS "E">
			<!--- EMP --->
			(
				(
					EVENT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR
					EVENT.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#">
				)
			)
			OR EVENT.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_position_code#,%">
			OR EVENT.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_position_code#,%">
			OR EVENT.VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_position_code#">
			<cfloop list="#grps#" INDEX="grp_i">
				OR EVENT.EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grp_i#,%">
			</cfloop>
			<cfloop list="#grps#" INDEX="grp_i">
				OR EVENT.EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grp_i#,%">
			</cfloop>
			<cfloop list="#wrkgroups#" index="wrk">
			   OR EVENT.EVENT_TO_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#wrk#,%">
			</cfloop>
			<cfloop list="#wrkgroups#" index="wrk">
			  OR EVENT.EVENT_CC_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#wrk#,%">
			</cfloop>
			</cfif>
		<cfelse>
			<!--- KENDINDE --->
			EVENT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			OR EVENT.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			OR EVENT.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">
			OR EVENT.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">
			OR EVENT.VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
			<cfloop list="#groups#" INDEX="grp_i">
				OR EVENT.EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grp_i#,%">
			</cfloop>
			<cfloop list="#groups#" INDEX="grp_i">
				OR EVENT.EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grp_i#,%">
			</cfloop>
			<cfloop list="#workgroups#" index="wrk">
			   OR EVENT.EVENT_TO_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#wrk#,%">
			</cfloop>
			<cfloop list="#workgroups#" index="wrk">
			  OR EVENT.EVENT_CC_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#wrk#,%">
			</cfloop>
		</cfif>
		OR EVENT.VIEW_TO_ALL = 1
		)
	<cfif (isdefined("attributes.project_id") and not len(attributes.project_id) or not isdefined("attributes.project_id"))>	
	<!--- unionda fbs 20090923 calisiliyor silmeyin...--->
	UNION ALL
	SELECT
		2 TYPE,
		EVENT_PLAN.EVENT_PLAN_ID EVENT_ID,
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID EVENT_ROW_ID,
		EVENT_PLAN.EVENT_PLAN_HEAD EVENT_HEAD,
		EVENT_PLAN.RECORD_EMP RECORD_EMP,
		'' EVENT_TO_POS,
		CAST(CONSUMER_ID  AS NVARCHAR(1000))  AS EVENT_TO_CON,
		CAST(PARTNER_ID  AS NVARCHAR(1000))  AS EVENT_TO_PAR,
		EVENT_PLAN_ROW.START_DATE,
		EVENT_PLAN_ROW.FINISH_DATE,
		EVENT_PLAN_ROW.WARNING_ID EVENTCAT_ID,
		0 PROJECT_ID,
		'' EVENTCAT
	FROM
		EVENT_PLAN,
		EVENT_PLAN_ROW
	WHERE 
		EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
		EVENT_PLAN_ROW.IS_ACTIVE = 1 AND
		EVENT_PLAN.EVENT_PLAN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		<cfif isdefined("attributes.event_cat") and len(attributes.event_cat)>AND EVENT_PLAN_ROW.WARNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_cat#"></cfif>
		<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date") and len(attributes.start_date) and len(attributes.finish_date)>
			AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> 
			AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.finish_date)#">
		<cfelseif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		<cfelseif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.finish_date)#">
		</cfif>
		<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
			AND EVENT_PLAN_ROW.PARTNER_ID IN (#partner_id_list#)
		<cfelseif len(attributes.company) and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
			AND EVENT_PLAN_ROW.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_id#">
		</cfif>
		AND
		(
			EVENT_PLAN.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			OR EVENT_PLAN.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			<!--- OR EVENT.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">
			OR EVENT.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">
			OR EVENT.VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> --->
		OR EVENT_PLAN.VIEW_TO_ALL = 1
		)
	</cfif>
	ORDER BY
		STARTDATE DESC
</cfquery>
