<cfset attributes.maxrows = 10>
<cfinclude template="../query/my_sett.cfm">
<cfif my_sett.is_kural_popup eq 1>
	<script type="text/javascript">		
		$(function(){
			myPopup('uyariModal','<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_dsp_kural')		
		})
	</script>
</cfif>

<cfset GET_LICENCE = createObject("component", "WMO.functions")>
<cfset GET_LICENCE_INFO = GET_LICENCE.GET_USER_LICENCE()>

<cfif GET_LICENCE_INFO.recordcount>
	<cfset GET_USER_LICENCE_RESULT = GET_LICENCE.GET_USER_LICENCE_RESULT(session.ep.userid)>
    <cfif not GET_USER_LICENCE_RESULT.recordcount>
    	<cfset attributes.passLicence = 0>
		<script type="text/javascript">		
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_dsp_kural&licence=1','','ui-draggable-box-large');		
        </script>
	<cfelse>
    	<cfset attributes.passLicence = 1>
    </cfif>
<cfelse>
	<cfset attributes.passLicence = 1>
</cfif>

<div class="row">
	<div class="col col-12">
		<cfif (my_sett.myhome_quick_menu_page eq 1) and not isdefined("is_portal")>
        <cfif session.ep.menu_id neq 0>
            <cfinclude template="myhome_quick_menu_ozel.cfm">
        <cfelse>
            <cfinclude template="myhome_quick_menu_page.cfm">
        </cfif>	
        <cfelse>
            <cfinclude template="myhome_standart.cfm">
        </cfif>
    </div>
</div>


<cfscript>
	if(not isDefined('attributes.start_response_date'))
		attributes.start_response_date = date_add('d',-3,now());
	if(not isDefined('attributes.finish_response_date'))
		attributes.finish_response_date = date_add('h',23,now());
</cfscript>
<cfquery name="GET_POSITION_CODE" datasource="#DSN#">
	SELECT 
		POSITION_CODE,
		PARENT_ID,
		RESPONSE_ID
	FROM 
		PAGE_WARNINGS 
	WHERE
		ISNULL(IS_CONFIRM,1)=1 AND
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
		IS_ACTIVE = 1 AND
		LAST_RESPONSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#"> AND 
		LAST_RESPONSE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">	
	GROUP BY
		PARENT_ID,
		POSITION_CODE,
		RESPONSE_ID
</cfquery>
<cfset parent_ids = ''>
<cfloop query="get_position_code">
	<cfif len(get_position_code.parent_id)>
		<cfquery name="GET_MAX_RESPONSE_ID" datasource="#DSN#">
			SELECT 
				MAX(RESPONSE_ID) MAX_RESPONSE_ID
			FROM 
				PAGE_WARNINGS 
			WHERE
				PARENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_code.parent_id#">
		</cfquery>
		<cfif RESPONSE_ID eq get_max_response_id.max_response_id>
			<cfset parent_ids = parent_ids & parent_id & ','>
		</cfif>
	</cfif>
</cfloop>
<cfset kontrol_izin = 0>
<cfset kontrol_avans = 0>
<cfset kontrol_ajanda = 0>
<cfif isdefined("x_select_izin") and x_select_izin eq 1>
	<cfquery name="get_all_positions" datasource="#dsn#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
	</cfquery>
	<cfset pos_id_list = valuelist(get_all_positions.position_code)>
	<cfquery name="GET_IZIN" datasource="#DSN#">
		SELECT 
			OFFTIME_ID
		FROM 
			OFFTIME
		WHERE
			VALID IS NULL AND
			(
				(
					VALIDATOR_POSITION_CODE_1 IN (#pos_id_list#) AND 
					VALID_1 IS NULL
				)
			OR
				(
				VALIDATOR_POSITION_CODE_2 IN (#pos_id_list#) AND 
				VALID_2 IS NULL AND
				VALID_EMPLOYEE_ID_1 IS NOT NULL AND 
				VALID_1 = 1
				)
			)
			AND(IS_PLAN <> 1 OR IS_PLAN IS NULL)
			<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
				AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
				AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
			</cfif>
	</cfquery>
	<cfif get_izin.recordcount>
		<cfset kontrol_izin = 1>
	</cfif>
</cfif>
<cfif isdefined("x_select_avans") and x_select_avans eq 1>
	<cfquery name="get_avans" datasource="#dsn#">
		SELECT 
			ID
		FROM 
			CORRESPONDENCE_PAYMENT
		WHERE
			((VALIDATOR_POSITION_CODE_1 = #session.ep.position_code# AND VALID_1 IS NULL)OR
			(VALIDATOR_POSITION_CODE_2 = #session.ep.position_code# AND VALID_2 IS NULL AND
			VALID_EMPLOYEE_ID_1 IS NOT NULL AND VALID_1=1)) AND 
			STATUS IS NULL
			<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
				AND DUEDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
				AND DUEDATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
			</cfif>
		
		UNION ALL
		
		SELECT
			SPGR_ID
		FROM
			SALARYPARAM_GET_REQUESTS
		WHERE 
			((VALIDATOR_POSITION_CODE_1 = #session.ep.position_code# AND VALID_1 IS NULL)OR
			(VALIDATOR_POSITION_CODE_2 = #session.ep.position_code# AND VALID_2 IS NULL AND
			VALID_EMPLOYEE_ID_1 IS NOT NULL AND VALID_1=1))	
			AND IS_VALID IS NULL
			<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
				AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
				AND RECORD_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
			</cfif>
	</cfquery>
	<cfif get_avans.recordcount>
		<cfset kontrol_avans = 1>
	</cfif>
</cfif>
<cfif isdefined("x_select_ajanda") and x_select_ajanda eq 1>
	<cfquery name="get_ajanda" datasource="#dsn#">
		SELECT
			EVENT_ID
		FROM
			EVENT
		WHERE 
			VALIDATOR_POSITION_CODE = #session.ep.position_code# AND 
			VALID IS NULL
			<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
				AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
				AND STARTDATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
			</cfif>
	</cfquery>
	<cfif get_ajanda.recordcount>
		<cfset kontrol_ajanda = 1>
	</cfif>
</cfif>
<cfquery name="GET_DEN_WARNING_PAGE" datasource="#dsn#"> <!--- uyarı popup' ının sayfa yetkisi verilmediğinde sonsuz döngüye girmesinden dolayı konuldu.--->
    SELECT 
        EPD.IS_VIEW,
        EPD.DENIED_PAGE	
    FROM
        EMPLOYEE_POSITIONS_DENIED AS EPD,
        EMPLOYEE_POSITIONS AS EP
    WHERE
    	EPD.DENIED_PAGE LIKE '%myhome.popup_list_warning%' AND
        EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
        EPD.DENIED_TYPE <> 1 AND
        EPD.IS_VIEW = 1 AND
        EPD.MODULE_ID = 0 AND
        ( 
            EPD.POSITION_CODE = EP.POSITION_CODE OR
            EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
            EPD.USER_GROUP_ID = EP.USER_GROUP_ID
        )
</cfquery>
<!---
<cfif attributes.passLicence>
	<cfif (len(parent_ids) or kontrol_izin eq 1 or kontrol_avans eq 1 or kontrol_ajanda eq 1) and not get_den_warning_page.recordcount>
        <cfoutput>
			<script type="text/javascript"> 
                window.open('#request.self#?fuseaction=myhome.popup_list_warning','Warnings','resizable=yes,scrollbars=yes,width=1000,height=500,left=50,top=150');
            </script>
        </cfoutput>
    </cfif>
</cfif>
--->
<!---<cfif len(parent_ids) or kontrol_izin eq 1 or kontrol_avans eq 1 or kontrol_ajanda eq 1>
	<cfoutput>
		<script type="text/javascript">
			window.open('#request.self#?fuseaction=myhome.popup_list_warning','Warnings','resizable=yes,scrollbars=yes,width=1000,height=500,left=50,top=150');
		</script>
	</cfoutput>
</cfif>--->
