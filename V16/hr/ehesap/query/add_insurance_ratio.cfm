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
     	FINISHDATE > #DATEADD("d",-1,attributes.startdate)# 
</cfquery>
<cfif get_query.recordcount>
		<script type="text/javascript">
			alert('Varolan tarihe tekrar tanım giremezsiniz!');
			<cfif not isdefined("attributes.draggable")>
				history.back();
			<cfelseif isdefined("attributes.draggable")>
				$('#ratios_box .catalyst-refresh').click();
				closeBoxDraggable( 'add_ratio_box' );
			</cfif>
		</script>
		<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>

	<cfquery name="add_query" datasource="#dsn#">
		INSERT INTO
			INSURANCE_RATIO
			(
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
			RECORD_EMP
			<!--- Muzaffer bas: ücret kuralları vergi dilimleri için yapıldı--->
			,DEATH_INSURANCE_PREMIUM_WORKER_MADEN 
			,DEATH_INSURANCE_PREMIUM_BOSS_MADEN 
		    <!--- Muzaffer bit: ücret kuralları vergi dilimleri için yapıldı--->
			)
		VALUES
			(
			#attributes.STARTDATE#,
			#attributes.FINISHDATE#,
			#MOM_INSURANCE_PREMIUM_WORKER#,
			#MOM_INSURANCE_PREMIUM_BOSS#,
			#PAT_INS_PREMIUM_WORKER#,
			#PAT_INS_PREMIUM_BOSS#,
			#PAT_INS_PREMIUM_WORKER_2#,
			#PAT_INS_PREMIUM_BOSS_2#,
			#DEATH_INSURANCE_PREMIUM_WORKER#,
			#DEATH_INSURANCE_PREMIUM_BOSS#,
			#DEATH_INSURANCE_WORKER#,
			#DEATH_INSURANCE_BOSS#,
			#SOC_SEC_INSURANCE_WORKER#,
			#SOC_SEC_INSURANCE_BOSS#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#,
			<!--- Muzaffer bas: ücret kuralları vergi dilimleri için yapıldı--->
			<cfif len(attributes.death_insurance_premium_worker_maden)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.death_insurance_premium_worker_maden#"><cfelse>NULL</cfif>,
			<cfif len(attributes.death_insurance_premium_boss_maden)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.death_insurance_premium_boss_maden#"><cfelse>NULL</cfif>
			<!--- Muzaffer bit: ücret kuralları vergi dilimleri için yapıldı--->
			)
	</cfquery>
	
	<cfquery name="get_max" datasource="#dsn#">
		SELECT
			MAX(INS_RAT_ID) AS ID
		FROM
			INSURANCE_RATIO
	</cfquery>

	</cftransaction>
</cflock>
<cfset attributes.actionId = get_max.ID>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelseif isdefined("attributes.draggable")>
		$('#ratios_box .catalyst-refresh').click();
		closeBoxDraggable( 'add_ratio_box' );
	</cfif>
</script>
<!--- <cflocation url="#request.self#?fuseaction=hr.form_upd_insurance_ratio&ins_rat_id=#get_max.id#" addtoken="no"> --->
