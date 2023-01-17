<cfif not len(attributes.work_id) or not isnumeric(attributes.work_id)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1531.Böyle Kayıt Bulunmamaktadır!'>");
		history.back(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="UPD_WORK" datasource="#DSN#">
	SELECT 
		PW.TARGET_START,
		PW.TARGET_FINISH,
		PW.PROJECT_ID,
		PW.WORK_CURRENCY_ID,
		PW.WORK_PRIORITY_ID,
		PW.WORK_CAT_ID,
		PW.RELATED_WORK_ID,
		PW.WORK_HEAD,
		PW.PROJECT_EMP_ID,
		PW.OUTSRC_CMP_ID,
		PW.OUTSRC_PARTNER_ID,
		PW.WORK_STATUS,
		PW.RECORD_AUTHOR,
		PW.RECORD_PAR,
		PW.RECORD_DATE,
		PW.WORK_ID
	FROM 
		PRO_WORKS AS PW
	WHERE 
		PW.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
		<!--- <cfif isdefined('attributes.id') and len(attributes.id)>
			AND
			(
				PW.PROJECT_ID IN
					(
					SELECT PROJECT_ID FROM PRO_PROJECTS
					WHERE
							PRO_PROJECTS.OUTSRC_PARTNER_ID = #session.pp.userid# OR
							PRO_PROJECTS.OUTSRC_CMP_ID = #session.pp.company_id# OR
							PRO_PROJECTS.COMPANY_ID = #session.pp.company_id# OR
							PRO_PROJECTS.UPDATE_PAR = #session.pp.userid# OR
							PRO_PROJECTS.RECORD_PAR = #session.pp.userid#
					)
				OR ( PW.PROJECT_ID = 0 AND (PW.COMPANY_ID=#session.pp.company_id# OR PW.OUTSRC_CMP_ID = #session.pp.company_id# OR PW.RECORD_PAR = #session.pp.userid#) )
			)
		</cfif> --->
</cfquery>

<cfquery name="GET_LAST_REC" datasource="#DSN#">
	SELECT
		MAX(HISTORY_ID) AS HIS_ID
	FROM
		PRO_WORKS_HISTORY
	WHERE
		WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
</cfquery>
<cfset hist_id=get_last_rec.his_id>
<cfif len(hist_id)>
	<cfquery name="GET_HIST_DETAIL" datasource="#DSN#">
		SELECT
			PRO_WORKS_HISTORY.WORK_PRIORITY_ID
		FROM
			PRO_WORKS_HISTORY,
			SETUP_PRIORITY
		WHERE
			PRO_WORKS_HISTORY.WORK_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID AND
			PRO_WORKS_HISTORY.HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hist_id#">
	</cfquery>
</cfif>
