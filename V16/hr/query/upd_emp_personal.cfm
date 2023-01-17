<cf_date tarih ="attributes.military_delay_date">
<cf_date tarih ="attributes.military_finishdate">

<cfquery name="DETAIL_EXISTS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_DETAIL_ID
	FROM 
		EMPLOYEES_DETAIL 
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<cfif detail_exists.recordcount>
	<cfquery name="UPD_EMP_DET" datasource="#DSN#">
		UPDATE
			EMPLOYEES_DETAIL
		SET
			USE_CIGARETTE = <cfif isdefined('attributes.use_cigarette') and len(attributes.use_cigarette)><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.use_cigarette#'><cfelse>NULL</cfif>,
			MARTYR_RELATIVE = <cfif isdefined('attributes.martyr_relative') and len(attributes.martyr_relative)><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.martyr_relative#'><cfelse>NULL</cfif>,
			IDENTYCARD_NO = <cfif len(attributes.identycard_no) and len(attributes.identycard_no)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.identycard_no#'><cfelse>NULL</cfif>,
			DEFECTED_PROBABILITY = <cfif isdefined("attributes.defected_probability") and len(attributes.defected_probability)> <cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.defected_probability#'><cfelse>NULL</cfif>,
			ILLNESS_PROBABILITY = <cfif isdefined("attributes.illness_probability") and len(attributes.illness_probability)><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.illness_probability#'><cfelse>NULL</cfif>,
			ILLNESS_DETAIL = <cfif isdefined("attributes.illness_detail") and len(attributes.illness_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.illness_detail#'><cfelse>NULL</cfif>,
			IDENTYCARD_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value='#attributes.identycard_cat#'>, 
		<cfif isdefined("attributes.defected") and attributes.defected eq 1>
			DEFECTED = <cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.defected#'>,
			DEFECTED_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value='#attributes.defected_level#'>,
		<cfelse>
			DEFECTED = 0,
			DEFECTED_LEVEL = 0,
		</cfif>
			SUIT_PROBABILITY = <cfif isDefined("attributes.suit_probability") and len(attributes.suit_probability)><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.suit_probability#'><cfelse>NULL</cfif>,
			SUIT_DETAIL = <cfif isDefined("attributes.suit_detail") and len(attributes.suit_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.suit_detail#'><cfelse>NULL</cfif>,
			SENTENCED = <cfif isdefined("attributes.sentenced")><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.sentenced#'><cfelse> NULL</cfif>,
			SENTENCED_SIX_MONTH = <cfif isdefined("attributes.sentenced_six_month")><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.sentenced_six_month#'><cfelse>NULL</cfif>,
			TERROR_WRONGED = <cfif isdefined("attributes.terror_wronged") and len(attributes.terror_wronged)><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.terror_wronged#'><cfelse>NULL</cfif>,
			MILITARY_STATUS = <cfif isdefined("attributes.military_status")><cfqueryparam cfsqltype="cf_sql_integer" value='#attributes.military_status#'><cfelse>NULL</cfif>,
			MILITARY_DELAY_REASON = <cfif isDefined("attributes.military_delay_reason") and len(attributes.military_delay_reason) and isdefined("attributes.military_status") and attributes.military_status eq 4> <cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.military_delay_reason#'><cfelse>NULL</cfif>,
			MILITARY_DELAY_DATE = <cfif isDefined("attributes.military_delay_date") and len(attributes.military_delay_date) and isdefined("attributes.military_status") and attributes.military_status eq 4><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.military_delay_date#"><cfelse>NULL</cfif>,
			MILITARY_FINISHDATE = <cfif isdefined("attributes.military_finishdate") and len(attributes.military_finishdate) and isdefined("attributes.military_status") and attributes.military_status eq 1><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.military_finishdate#"><cfelse>NULL</cfif>,
			MILITARY_EXEMPT_DETAIL = <cfif isdefined('attributes.military_exempt_detail') and len(attributes.military_exempt_detail) and isdefined("attributes.military_status") and attributes.military_status eq 2><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.military_exempt_detail#'><cfelse>NULL</cfif>,
			MILITARY_MONTH = <cfif isdefined('attributes.military_month') and len(attributes.military_month) and isdefined("attributes.military_status") and attributes.military_status eq 1><cfqueryparam cfsqltype="cf_sql_integer" value='#attributes.military_month#'><cfelse>NULL</cfif>,
			MILITARY_RANK = <cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and isdefined("attributes.military_rank") and len(attributes.military_rank)><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.military_rank#'><cfelse>NULL</cfif>,
			CLUB=<cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.club#'>,
			UPDATE_DATE = #now()#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value='#session.ep.userid#'>
		WHERE
			EMPLOYEE_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value='#detail_exists.employee_detail_id#'>
	</cfquery>
<cfelse>
	<cfquery name="ADD_EMP_DET" datasource="#DSN#">
		INSERT INTO
			EMPLOYEES_DETAIL
		(
			EMPLOYEE_ID,
			USE_CIGARETTE,
			MARTYR_RELATIVE,
			IDENTYCARD_NO,
			PARTNER_COMPANY, 
			PARTNER_POSITION, 
			DEFECTED_PROBABILITY,
			ILLNESS_PROBABILITY,
			SENTENCED,
			SENTENCED_SIX_MONTH,
			ILLNESS_DETAIL,
			IDENTYCARD_CAT, 
			DEFECTED,
			DEFECTED_LEVEL, 
			SUIT_PROBABILITY,
			SUIT_DETAIL,
			MILITARY_DELAY_REASON,
			TERROR_WRONGED,
			MILITARY_DELAY_DATE,
			MILITARY_STATUS,
			MILITARY_FINISHDATE,
			MILITARY_MONTH,
			MILITARY_EXEMPT_DETAIL,
			MILITARY_RANK,
			CLUB,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
		)
		VALUES
		(
			#attributes.employee_id#, 
			<cfif isdefined('attributes.use_cigarette')><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.use_cigarette#'><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.martyr_relative')><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.martyr_relative#'><cfelse>NULL</cfif>,
			<cfif len(attributes.identycard_no)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.identycard_no#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.partner_company") and len(attributes.partner_company)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.partner_company#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.partner_position") and len(attributes.partner_position)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.partner_position#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.defected_probability")> <cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.defected_probability#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.illness_probability")><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.illness_probability#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.sentenced")><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.sentenced#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.sentenced_six_month")><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.sentenced_six_month#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.illness_detail") and len(attributes.illness_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.illness_detail#'><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value='#attributes.identycard_cat#'>, 
			<cfif isdefined('attributes.defected')><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.defected#'><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.defected_level')><cfqueryparam cfsqltype="cf_sql_integer" value='#attributes.defected_level#'><cfelse>0</cfif>,
			<cfif isdefined("attributes.suit_probability")><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.suit_probability#'><cfelse>NULL</cfif>,
			<cfif len(attributes.suit_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.suit_detail#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.military_delay_reason") and len(attributes.military_delay_reason) and isdefined("attributes.military_status") and attributes.military_status eq 4><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.military_delay_reason#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.terror_wronged")>#attributes.terror_wronged#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.military_delay_date") and len(attributes.military_delay_date) and isdefined("attributes.military_status") and attributes.military_status eq 4><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.military_delay_date#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.military_status')>#attributes.military_status#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.military_finishdate") and len(attributes.military_finishdate) and isdefined("attributes.military_status") and attributes.military_status eq 1><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.military_finishdate#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.military_month") and len(attributes.military_month) and isdefined("attributes.military_status") and attributes.military_status eq 1><cfqueryparam cfsqltype="cf_sql_integer" value='#attributes.military_month#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.military_exempt_detail") and len(attributes.military_exempt_detail) and isdefined("attributes.military_status") and attributes.military_status eq 2><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.military_exempt_detail#'><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.military_rank") and len(attributes.military_rank)><cfqueryparam cfsqltype="cf_sql_bit" value='#attributes.military_rank#'><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.club#'>,
			#now()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>,
			<cfqueryparam cfsqltype="cf_sql_integer" value='#session.ep.userid#'>
		)	
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' ); alert("<cfoutput><cf_get_lang dictionary_id='58890.Kaydedildi'></cfoutput>");</cfif>
</script>
