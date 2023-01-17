<cfquery name="get_in_out_puantaj_group" datasource="#DSN#">
	SELECT EMPLOYEE_ID, PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE PUANTAJ_GROUP_IDS LIKE '%#attributes.group_id#%'
</cfquery>
<cfquery name="get_prog_parameters" datasource="#DSN#">
	SELECT PARAMETER_NAME, GROUP_IDS FROM SETUP_PROGRAM_PARAMETERS WHERE GROUP_IDS LIKE '%#attributes.group_id#%'
</cfquery>
<cfquery name="get_offtime_limits" datasource="#DSN#">
	SELECT LIMIT_ID, PUANTAJ_GROUP_IDS FROM SETUP_OFFTIME_LIMIT WHERE PUANTAJ_GROUP_IDS LIKE '%#attributes.group_id#%'
</cfquery>
<cfif get_in_out_puantaj_group.recordcount or get_prog_parameters.recordcount or get_offtime_limits.recordcount>
	<cfif get_in_out_puantaj_group.recordcount>
    	<script type="text/javascript">
            alert("Bu Çalışan Grubuna Ait Çalışan Bulunduğundan Bu Grubu Silemezsiniz!");
        </script>
   	</cfif>
	<cfif get_prog_parameters.recordcount>
        <script type="text/javascript">
            alert("Bu Çalışan Grubunun Seçili Olduğu Program Akış Parametresi Bulunduğundan Bu Grubu Silemezsiniz!");
        </script>
    </cfif>
    <cfif get_offtime_limits.recordcount>
        <script type="text/javascript">
            alert("Bu Çalışan Grubunun Seçili Olduğu İzin Süresi Bulunduğundan Bu Grubu Silemezsiniz!");
        </script>
    </cfif>
    <script type="text/javascript">
    	history.back();
	</script>
    <cfabort>
<cfelse>
    <cfquery name="del_puantaj_group" datasource="#DSN#">
        DELETE FROM EMPLOYEES_PUANTAJ_GROUP WHERE GROUP_ID = #attributes.group_id#
    </cfquery>
</cfif>
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>
          wrk_opener_reload();
          window.close();
      <cfelse>
          closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
          location.reload();
      </cfif>
  </script>


