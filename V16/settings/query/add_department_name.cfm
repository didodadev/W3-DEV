<cfif IsDefined('attributes.department_name')  and len(attributes.department_name)>
<cfquery name="ADD_NAME" datasource="#DSN#">
    INSERT INTO
    	SETUP_DEPARTMENT_NAME
    (
        IS_ACTIVE,
        DEPARTMENT_NAME,
        DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
    VALUES
    (
		<!--- <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif> BURASI, EKLEME FORMUNDA AKTİF CHECK İ EKLENDİĞİNDE AÇILACAK MG 24.06.2011 --->
		1,
        '#attributes.department_name#',
        '#attributes.department_name_detail#',
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
</cfif>

<cfif IsDefined('attributes.form_popup') and attributes.form_popup eq 1>
	<script type="text/javascript">
        wrk_opener_reload();
        window.close();
    </script>
<cfelse>
    <cflocation url="#request.self#?fuseaction=settings.form_add_department_name" addtoken="no">
</cfif>
