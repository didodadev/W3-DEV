<cfif isDefined("attributes.from_update")>
	<cfif attributes.from_update eq 1>
		<cfscript>
			attributes.startdate  = attributes.startingdate;
			attributes.finishdate = attributes.finishingdate;
		</cfscript>
		<cf_date tarih="attributes.startdate">
		<cf_date tarih="attributes.finishdate">
	</cfif>
	<cfelse>
		<cf_date tarih="attributes.startdate">
		<cf_date tarih="attributes.finishdate">
</cfif>
<cfscript>
	attributes.startdate  = date_add('h',start_clock, attributes.startdate);
	attributes.finishdate = date_add('h',finish_clock, attributes.finishdate);
</cfscript>
<cfif not isDefined("attributes.status") or (isDefined("attributes.status") and (attributes.status eq 2))>
	<cfif isDefined("attributes.status")>
		<cfquery name="RESEARCH_MAX_RES_STEP" datasource="#DSN#">
			SELECT
				MAX(RESERVE_STEP) MAX_RESERVE_STEP
			FROM
				LIBRARY_ASSET_RESERVE
			WHERE
				LIBRARY_ASSET_ID = #attributes.lib_asset_id# AND
				STATUS = 2
		</cfquery>
		<cfscript>
			if(len(research_max_res_step.max_reserve_step))
				max_reserve_step = research_max_res_step.max_reserve_step + 1;
			else
				max_reserve_step = 1;
		</cfscript>					
	</cfif>	
	
	<cfquery name="ADD_LIB_ASSET_RESERVE" datasource="#DSN#">
		INSERT INTO
			LIBRARY_ASSET_RESERVE
		(
			LIBRARY_ASSET_ID,
			EMP_ID,
			STARTDATE,
			FINISHDATE,
			RECORD_EMP,
			RECORDDATE,
			RECORD_IP,
			STATUS,
			RESERVE_STEP
		)
		VALUES
		(
			#attributes.lib_asset_id#,
			#attributes.member_id#,
			#attributes.startdate#,
			#attributes.finishdate#,
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#',
		<cfif isDefined("attributes.status")>
			2,			
			#max_reserve_step# 
		<cfelse>
			0,
			0
		</cfif>
		)
	</cfquery>
	<script type="text/javascript">
		<cfif not isDefined('attributes.draggable')>
			wrk_opener_reload();
			window.close();
		<cfelse>
			location.href = document.referrer;
		</cfif>
	</script>
	
<cfelseif attributes.status eq 3>
	<cfif not isDefined("attributes.fromlist")>		
		<cfquery name="UPD_RES_LIB_ASSET" datasource="#DSN#">
			UPDATE
				LIBRARY_ASSET_RESERVE
			SET
				STARTDATE  = #attributes.startdate#,
				FINISHDATE = #attributes.finishdate#				
			WHERE
				LIBRARY_RESERVE_ID = #attributes.reserve_id#
		</cfquery>
	<cfelse>
		<cfquery name="MAKE_FINISH_LIB_RESERVATION" datasource="#DSN#">
			UPDATE
				LIBRARY_ASSET_RESERVE
			SET
				STARTDATE  = #attributes.startdate#,
				FINISHDATE  = #attributes.finishdate#,
				RESERVE_STEP = 0,
				STATUS = 0
			WHERE
				LIBRARY_RESERVE_ID = #attributes.reserve_id#
		</cfquery>		
	</cfif>		
	
	<script type="text/javascript">
		<cfif not isDefined('attributes.draggable')>
			wrk_opener_reload();
			window.close();
		<cfelse>
			location.href = document.referrer;
		</cfif>
	</script>
</cfif>

<script type="text/javascript">
		location.href = document.referrer;
</script>