<cfquery name="get_general_offtime" dbtype="query">
	SELECT        
    	OFFTIME_NAME, START_DATE, FINISH_DATE, IS_HALFOFFTIME
  	FROM            
     	get_general_offtime_table
   	WHERE   
     	START_DATE >= '#DateFormat(test_gun,'MM/DD/YYYY')#' AND
     	FINISH_DATE <= '#DateFormat(test_gun,'MM/DD/YYYY')#'
</cfquery>
<cfif get_general_offtime.recordcount>
 	<cfif get_general_offtime.IS_HALFOFFTIME eq 1>
        <cfset tatil = 1>
  	<cfelse>
        <cfset tatil = 2>
 	</cfif>
 <cfelse>
    <cfset tatil = 0>    
</cfif>