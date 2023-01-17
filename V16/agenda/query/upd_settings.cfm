<cfif member_type is "employee">
	<cfquery name="GET_AGENDA_OPEN" datasource="#DSN#">
		SELECT 
			AGENDA 
		FROM 
			MY_SETTINGS 
		WHERE 
			EMPLOYEE_ID = #attributes.member_id#
	</cfquery>
<cfelseif member_type is "partner">
	<cfquery name="GET_AGENDA_OPEN" datasource="#DSN#">
		SELECT 
			IS_AGENDA_OPEN, 
			TIME_ZONE 
		FROM 
			COMPANY_PARTNER 
		WHERE 
			PARTNER_ID = #attributes.member_id#
	</cfquery>
</cfif>
<!--- partner a kopyalaninca uyarlanacak --->
<cfif member_type is "employee">
	<cfif member_id eq session.ep.userid>
    	<!--- kendi ajandasina dondü session varsa temizle --->
   		<cfif isdefined("session.agenda_userid")>
			<cfset deleted = structdelete(session,"agenda_userid")>
			<cfset deleted = structdelete(session,"agenda_user_type")>
			<cfset deleted = structdelete(session,"agenda_position_code")>
    	</cfif>
    	<cfif isdefined("time_zone")>
			<cfquery name="UPD_AGENDA_STATUS" datasource="#DSN#">
				UPDATE 
					EMPLOYEES
				SET
					IS_AGENDA_OPEN = <cfif isDefined("IS_AGENDA_OPEN")>1<cfelse>0</cfif>
				WHERE 
					EMPLOYEE_ID = #session.ep.userid#
		 	</cfquery>
			<cfquery name="UPD_SETTINGS" datasource="#DSN#">
				UPDATE 
					MY_SETTINGS 
				SET 
					EVENTCAT_ID = <cfif len(attributes.eventcat_id)>#attributes.eventcat_id#<cfelse>NULL</cfif>,
					AGENDA = <cfif isDefined("attributes.is_agenda_open")>1<cfelse>0</cfif>,
					TIME_ZONE = #time_zone# 
				WHERE 
					EMPLOYEE_ID = #session.ep.userid#
			</cfquery>

			<cfscript>
				upd_workcube_session(time_zone : TIME_ZONE);
				session.ep.time_zone = TIME_ZONE;
			</cfscript>
		
		</cfif>
    <cfelse>
		<!--- baskasinin ajandasina gecti --->
		<!--- BK 120 gune siline degistirdim. MY_SETTINGS tablosundaki degere bakmali 20080812 <cfif get_agenda_open.is_agenda_open eq 1> --->
		<cfif get_agenda_open.agenda eq 1>
			<cfset session.agenda_user_type = "e">
            <!--- Yeni hali --->
			<cfset attributes.employee_id = member_id><!--- Anlamsiz kisiler getiriyordu diye degistirdim. M.E.Y 20120814 --->
            <cfset attributes.position_code = "">
            
            <!--- Eski hali --->
			<!---<cfset attributes.position_code = member_id><!--- pozisyona gore bakmali, cunku ziyaret planinda pozisyon seciliyor --->
			<cfset attributes.employee_id = "">--->
			<cfinclude template="get_position.cfm">
			<cfset session.agenda_userid = get_position.employee_id>
			<cfset session.agenda_position_code = get_position.position_code>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no='30.Bu kullanıcının ajandası kapalı !'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
<cfelseif member_type is "partner">
	<cfif get_agenda_open.is_agenda_open eq 1>
    	<cfset session.agenda_userid = member_id>
	    <cfset session.agenda_user_type = "p">
    	<cfif isdefined("session.agenda_position_code")>
			<cfset deleted = structdelete(session,"agenda_position_code")>
		</cfif>
	<cfelseif get_agenda_open.is_agenda_open eq 0>
    	<script type="text/javascript">
			alert("<cf_get_lang no='30.Bu kullanıcının ajandası kapalı !'>");
			history.back();
		</script>
	    <cfabort>
	</cfif>
</cfif>
<cflocation url="#request.self#?fuseaction=agenda.form_settings" addtoken="No">
