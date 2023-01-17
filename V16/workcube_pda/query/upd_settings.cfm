<cfif member_type is "employee">
  <cfquery name="GET_AGENDA_OPEN" datasource="#dsn#">
	  SELECT 
		  IS_AGENDA_OPEN 
	  FROM 
		  EMPLOYEES 
	  WHERE 
		  EMPLOYEE_ID = #attributes.MEMBER_ID#
  </cfquery>
  <cfelseif member_type is "partner">
  <cfquery name="GET_AGENDA_OPEN" datasource="#dsn#">
	  SELECT 
		  IS_AGENDA_OPEN, 
		  TIME_ZONE 
	  FROM 
		  COMPANY_PARTNER 
	  WHERE 
	  	  PARTNER_ID = #attributes.MEMBER_ID#
  </cfquery>
</cfif>
<!--- partner a kopyalanınca uyarlanacak --->
<cfif member_type is "employee">
  <cfif member_id eq session.pda.userid>
    <!--- kendi ajandasına döndü session varsa temizle --->
    <cfif isdefined("session.agenda_userid")>
      <cfset deleted = structdelete(session,"agenda_userid")>
      <cfset deleted = structdelete(session,"agenda_user_type")>
      <cfset deleted = structdelete(session,"agenda_position_code")>
    </cfif>
    <cfif isdefined("time_zone")>
      <cfquery name="UPD_AGENDA_STATUS" datasource="#dsn#">
			UPDATE 
				EMPLOYEES SET
				<cfif isDefined("IS_AGENDA_OPEN")>
				IS_AGENDA_OPEN = 1
				<cfelse>
				IS_AGENDA_OPEN = 0
				</cfif>
			WHERE 
				EMPLOYEE_ID = #SESSION.PDA.USERID#
      </cfquery>
      <cfquery name="UPD_SETTINGS" datasource="#dsn#">
			UPDATE 
				MY_SETTINGS 
			SET 
				TIME_ZONE = #TIME_ZONE# 
			WHERE 
				EMPLOYEE_ID = #SESSION.PDA.USERID#
      </cfquery>

		<cfscript>
			upd_workcube_session(time_zone : TIME_ZONE);
			session.pda.time_zone = TIME_ZONE;
		</cfscript>
		
</cfif>
    <cfelse>
    <!--- başkasının ajandasına geçti --->
    <cfif get_agenda_open.is_agenda_open eq 1>
      <cfset session.agenda_userid = attributes.member_id>
      <cfset session.agenda_user_type = "e">
      <cfset attributes.POSITION_CODE = "">
      <cfset attributes.employee_id = member_id>
      <cfinclude template="get_position.cfm">
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

