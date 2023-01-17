<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.is_delete') and attributes.is_delete eq 1>
	<cfquery name="upd_query" datasource="#dsn#">
		DELETE 
		FROM
			INSURANCE_RATIO
		WHERE
			INS_RAT_ID = #attributes.INS_RAT_ID#
	</cfquery>
<cfelse>
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	<cfquery name="get_query" datasource="#dsn#">
		SELECT 
			INS_RAT_ID, 
			STARTDATE, 
			FINISHDATE, 
			MOM_INSURANCE_PREMIUM_WORKER, 
			MOM_INSURANCE_PREMIUM_BOSS, 
			PAT_INS_PREMIUM_WORKER, 
			PAT_INS_PREMIUM_BOSS,
			PAT_INS_PREMIUM_WORKER_2, 
			PAT_INS_PREMIUM_BOSS_2, 
			DEATH_INSURANCE_PREMIUM_WORKER, 
			DEATH_INSURANCE_PREMIUM_BOSS, 
			DEATH_INSURANCE_WORKER, 
			DEATH_INSURANCE_BOSS, 
			SOC_SEC_INSURANCE_WORKER, 
			SOC_SEC_INSURANCE_BOSS, 
			RECORD_IP, 
			RECORD_EMP, 
			RECORD_DATE, 
			UPDATE_EMP, 
			UPDATE_DATE, 
			UPDATE_IP 
		FROM 
			INSURANCE_RATIO 
		WHERE 
			STARTDATE < #DATEADD("d",1,attributes.finishdate)#  
		AND 
			FINISHDATE > #DATEADD("d",-1,attributes.startdate)# AND INS_RAT_ID <> #attributes.INS_RAT_ID#
	</cfquery>
	<cfif get_query.recordcount>
			<script type="text/javascript">
				alert('Varolan tarihe tekrar tanım giremezsiniz!');
				<cfif not isdefined("attributes.draggable")>
					history.back();
				<cfelseif isdefined("attributes.draggable")>
					$('#ratios_box .catalyst-refresh').click();
					closeBoxDraggable( 'upd_ratio_box' );
				</cfif>
			</script>
			<cfabort>
	</cfif>
	<cfquery name="upd_query" datasource="#dsn#">
		UPDATE
			INSURANCE_RATIO
		SET
			STARTDATE = #attributes.STARTDATE#,
			FINISHDATE = #attributes.FINISHDATE#,
			MOM_INSURANCE_PREMIUM_WORKER = #MOM_INSURANCE_PREMIUM_WORKER#,
			MOM_INSURANCE_PREMIUM_BOSS = #MOM_INSURANCE_PREMIUM_BOSS#,
			PAT_INS_PREMIUM_WORKER = #PAT_INS_PREMIUM_WORKER#,
			PAT_INS_PREMIUM_BOSS = #PAT_INS_PREMIUM_BOSS#,
			PAT_INS_PREMIUM_WORKER_2 = #PAT_INS_PREMIUM_WORKER_2#,
			PAT_INS_PREMIUM_BOSS_2 = #PAT_INS_PREMIUM_BOSS_2#,
			DEATH_INSURANCE_PREMIUM_WORKER = #DEATH_INSURANCE_PREMIUM_WORKER#,
			DEATH_INSURANCE_PREMIUM_BOSS = #DEATH_INSURANCE_PREMIUM_BOSS#,
			DEATH_INSURANCE_WORKER = #DEATH_INSURANCE_WORKER#,
			DEATH_INSURANCE_BOSS = #DEATH_INSURANCE_BOSS#,
			SOC_SEC_INSURANCE_WORKER = #SOC_SEC_INSURANCE_WORKER#,
			SOC_SEC_INSURANCE_BOSS = #SOC_SEC_INSURANCE_BOSS#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #NOW()#
			<!--- Muzaffer bas: ücret kuralları vergi dilimleri için yapıldı--->
			,DEATH_INSURANCE_PREMIUM_WORKER_MADEN =<cfif len(attributes.death_insurance_premium_worker_maden)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.death_insurance_premium_worker_maden#"><cfelse>NULL</cfif>
			,DEATH_INSURANCE_PREMIUM_BOSS_MADEN =<cfif len(attributes.death_insurance_premium_boss_maden)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.death_insurance_premium_boss_maden#"><cfelse>NULL</cfif>
			<!--- Muzaffer bit: ücret kuralları vergi dilimleri için yapıldı--->
		WHERE
			INS_RAT_ID = #attributes.INS_RAT_ID#
	</cfquery>
	<cfset attributes.actionId = attributes.ins_rat_id>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.personal_payment</cfoutput>";

	<cfelseif isdefined("attributes.draggable")>
		$('#ratios_box .catalyst-refresh').click();
		closeBoxDraggable( 'upd_ratio_box' );
	</cfif>
</script>