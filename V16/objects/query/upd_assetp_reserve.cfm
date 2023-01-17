<cf_date tarih="form.startdate">
<cf_date tarih="form.finishdate">
<cfif isdefined("session.ep.time_zone")>
	<cfset form.startdate = date_add("h", form.event_start_clock-session.ep.time_zone, form.startdate)>
<cfelseif isdefined("session.pp.time_zone")>
	<cfset form.startdate = date_add("h", form.event_start_clock-session.pp.time_zone, form.startdate)>
</cfif>
<cfset form.startdate = date_add("n", form.event_start_minute, form.startdate)>
<cfif isdefined("session.ep.time_zone") and isdefined("form.event_finish_clock")>
	<cfset form.finishdate = date_add("h", form.event_finish_clock-session.ep.time_zone, form.finishdate)>
<cfelseif isdefined("session.pp.time_zone") and isdefined("form.event_finish_clock")>
	<cfset form.finishdate = date_add("h", form.event_finish_clock-session.pp.time_zone, form.finishdate)>
</cfif>
<cfif isdefined("form.event_finish_minute")>
	<cfset form.finishdate = date_add("n", form.event_finish_minute, form.finishdate)>
</cfif>
<cfif isdefined("form.finishdate")>
	<cfquery name="CHECK" datasource="#DSN#">
		SELECT
			*
		FROM
			ASSET_P_RESERVE
		WHERE
			ASSETP_ID = #attributes.ASSETP_ID# AND
			(
				(
					STARTDATE < #FORM.STARTDATE# 
					<cfif isdefined("form.finishdate")>
						AND FINISHDATE >= #FORM.STARTDATE#
					</cfif>
				)
				OR
				(
					STARTDATE = #FORM.STARTDATE#
				)
				OR
				(
					STARTDATE > #FORM.STARTDATE# 
					<cfif isdefined("form.finishdate")>
						AND STARTDATE <= #FORM.FINISHDATE#
					</cfif>
				)
			)
			<cfif isDefined("ASSETP_RESID") and len(ASSETP_RESID)>
			AND ASSETP_RESID <> #ASSETP_RESID#
			</cfif>
	</cfquery>
<cfelse>
	<cfset check.recordcount = 0>	
</cfif>
<cfif not check.recordcount>
	<cfquery name="UPD_ASSETP_RESERVE" datasource="#DSN#">
		UPDATE 
			ASSET_P_RESERVE
		SET
			STARTDATE = <cfif isdefined("attributes.startdate")>#FORM.STARTDATE#<cfelse>NULL</cfif>,
			FINISHDATE = <cfif isdefined("attributes.finishdate")>#FORM.FINISHDATE#<cfelse>NULL</cfif>,
			STAGE_ID = #attributes.process_stage#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
            OUR_COMPANY_ID = #session.ep.company_id#
        WHERE
			ASSETP_RESID = #attributes.ASSETP_RESID#
	</cfquery>
	<cf_workcube_process
			is_upd='1' 
			data_source='#dsn#'
			old_process_line='0'
			process_stage='#attributes.process_stage#'
			record_member='#session.ep.userid#'
			record_date='#now()#'
			action_table='ASSET_P_RESERVE'
			action_column='ASSETP_RESID'
			action_id='#attributes.ASSETP_RESID#'
			action_page=''
			warning_description=''>
<cfelse>
	<script type="text/javascript">
		alert("Bu aralıkta kaynak rezervasyon çakışması var !");
		history.back();
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
	<cfif attributes.draggable eq 1>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
