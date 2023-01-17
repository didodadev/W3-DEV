<cfinclude template="vars.cfm">
<!--- scorm içerik paketi silme
<cfoutput>#attributes.scoid#</cfoutput>
<cfset attributes.scoid = 6>
<cfquery name="deleted_course" datasource="#APPLICATION_DB#">
	SELECT * FROM #TABLE_SCO# WHERE SCO_ID = #attributes.scoid#
</cfquery>
<cfoutput>
<!---#deleted_course.sco_dir#--->
<br/>


<cfset CurrentDirectory="#expandPath('/')##deleted_course.sco_dir#">  
	<cfoutput>  
	<b>Current Directory:</b> #CurrentDirectory#  
	   <br />  
</cfoutput>  
 
<cfif DirectoryExists(CurrentDirectory)>  
YES#CurrentDirectory#  
<!---<cfdirectory action="delete" directory="#CurrentDirectory#">--->
   <i>Directory deleted!</i>  
<cfelse> 
NO 
 <cfoutput>  
       #CurrentDirectory# Directory not exists!  
    </cfoutput>  
</cfif> 



</cfoutput>
<cfabort>--->
<cfquery name="delete_course" datasource="#APPLICATION_DB#">
	DELETE FROM #TABLE_SCO# WHERE SCO_ID = #attributes.scoid#;
	DELETE FROM #TABLE_SCO_DATA# WHERE SCO_ID = #attributes.scoid#;
	DELETE FROM #TABLE_SCO_OBJ# WHERE SCO_ID = #attributes.scoid#;
</cfquery> 
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
