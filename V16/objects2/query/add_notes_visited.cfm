<cfif isdefined('attributes.workgroup_id') and len(attributes.workgroup_id)>
	<cfquery name="GET_EMPS" datasource="#DSN#">
        SELECT 
            EMPLOYEE_POSITIONS.EMPLOYEE_ID
        FROM 
            EMPLOYEE_POSITIONS,
            WORKGROUP_EMP_PAR
        WHERE 
            EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
            EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
            EMPLOYEE_POSITIONS.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
            WORKGROUP_EMP_PAR.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
      </cfquery>
      <cfif get_emps.recordcount>
          <cfloop query="get_emps">
            <cfquery name="ADD_NOTES_VISITED" datasource="#DSN#">
                INSERT INTO 
                    VISITING_NOTES
                        (
                            NOTE_GIVEN,
                            NOTE_TAKEN_TYPE,
                            NOTE_TAKEN_ID,
                            DETAIL,
                            TEL,
                            EMAIL,
                            RECORD_EMP,
                            RECORD_PAR,
                            RECORD_CON,
                            RECORD_DATE,
                            RECORD_IP,
                            IS_HOMEPAGE,
                            IS_INTERNET
                        )
                    VALUES
                        (
                            <cfif isdefined("attributes.member") and len(attributes.member)>'#ATTRIBUTES.MEMBER#',<cfelse>NULL,</cfif>
                            1,
                            #get_emps.employee_id#,
                            <cfif len(attributes.DETAIL)>'#ATTRIBUTES.DETAIL#',<cfelse>NULL,</cfif>
                            '#ATTRIBUTES.TEL#',
                            '#ATTRIBUTES.EMAIL#',
                            <cfif isdefined("session.ep.userid") and len(session.ep.userid)>#SESSION.EP.USERID#,<cfelse>NULL,</cfif>
                            <cfif isdefined("session.pp.userid") and len(session.pp.userid)>#SESSION.PP.USERID#,<cfelse>NULL,</cfif>
                            <cfif isdefined("session.ww.userid") and len(session.ww.userid)>#SESSION.WW.USERID#,<cfelse>NULL,</cfif>
                            #NOW()#,
                            '#cgi.remote_addr#',
                            1,
                            1
                        )
            </cfquery>
          </cfloop>
      </cfif>
<cfelse>
    <cfquery name="ADD_NOTES_VISITED" datasource="#DSN#">
        INSERT INTO 
            VISITING_NOTES
                (
                    NOTE_GIVEN,
                    NOTE_TAKEN_TYPE,
                    NOTE_TAKEN_ID,
                    DETAIL,
                    TEL,
                    EMAIL,
                    RECORD_EMP,
                    RECORD_PAR,
                    RECORD_CON,
                    RECORD_DATE,
                    RECORD_IP,
                    IS_HOMEPAGE,
                    IS_INTERNET
                )
            VALUES
                (
                    <cfif isdefined("attributes.member") and len(attributes.member)>'#attributes.member#',<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.member_visited_type") and len(attributes.member_visited_type)>#attributes.member_visited_type#,<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.member_visited_id") and len(attributes.member_visited_id)>#attributes.member_visited_id#,<cfelse>NULL,</cfif>
                    <cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
                    '#attributes.tel#',
                    '#attributes.email#',
                    <cfif isdefined("session.ep.userid") and len(session.ep.userid)>#session.ep.userid#,<cfelse>null,</cfif>
                    <cfif isdefined("session.pp.userid") and len(session.pp.userid)>#session.pp.userid#,<cfelse>null,</cfif>
                    <cfif isdefined("session.ww.userid") and len(session.ww.userid)>#session.ww.userid#,<cfelse>null,</cfif>
                    #now()#,
                    '#cgi.remote_addr#',
                    1,
                    1
                )
    </cfquery>
</cfif>
<script type="text/javascript">
	alert('Mesajınız danışmanımıza iletilmiştir, en kısa sürede tarafınıza geri dönüş yapılacaktır.');
	window.close();
</script>
