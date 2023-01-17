﻿<tr style="height:20px" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-list';" class="color-list">
<cfoutput>
	<td style="text-align:right; width:50px"><strong>#t_code#&nbsp;</strong></td>
    <td><strong>#t_baslik#</strong></td>
   	<td style="text-align:right;width:80px;">
    <strong>
       	<cfif isdefined('t_#calc#')>
       		<cfset 't1_#calc#' = evaluate('t_#calc#')>
     	<cfelse>
        	<cfset 't1_#calc#' = 0>
      	</cfif>
        100,00%
   	</strong>
    </td>
    <td style="width:5px" >&nbsp;</td>
    <cfswitch expression="#list_type#" >
       	<cfcase value="1">
            <cfloop from="#sene1#" to="#sene2#" index="ii">
                <td style="text-align:right;width:80px;">
                	<cfif isdefined('t_#calc#_1_#ii#')>
                		<cfset 't1_#calc#_1_#ii#' = evaluate('t_#calc#_1_#ii#')>
                  	<cfelse>
                    	<cfset 't1_#calc#_1_#ii#' = 0>
                  	</cfif>
                    <strong>
                        100,00%
                    </strong>
                </td>
                <td style="width:5px" >&nbsp;</td>
            </cfloop>
       	</cfcase>
      	<cfcase value="2">
         	<cfloop from="#sene1#" to="#sene2#" index="ii">
            	<cfloop from="1" to="#period_say#" index="i">
                	<td style="text-align:right;width:80px;<cfif DayofYear(evaluate('period_flu_#i#_#ii#')) gt DayofYear(period_date_lock) and Year(evaluate('period_flu_#i#_#ii#')) eq Year(period_date_lock)>filter:alpha(Opacity=50,FinishOpacity=40)</cfif>">
                    	<cfif isdefined('t_#calc#_#i#_#ii#')>
                            <cfset 't1_#calc#_#i#_#ii#' = evaluate('t_#calc#_#i#_#ii#')>
                        <cfelse>
                            <cfset 't1_#calc#_#i#_#ii#' = 0>
                        </cfif>
                        <strong>
                            100,00%
                        </strong>
                   	</td>
               	</cfloop>
                <td style="width:5px" >&nbsp;</td>
         	</cfloop>
      	</cfcase>
		<cfcase value="3">
        	<cfloop from="#sene1#" to="#sene2#" index="ii">
                 <cfloop from="1" to="#period_say#" index="i">
                	<td style="text-align:right;width:80px;<cfif DayofYear(evaluate('period_flu_#i#_#ii#')) gt DayofYear(period_date_lock) and Year(evaluate('period_flu_#i#_#ii#')) eq Year(period_date_lock)>filter:alpha(Opacity=50,FinishOpacity=40);</cfif>">
                   		<cfif isdefined('t_#calc#_#i#_#ii#')>
                            <cfset 't1_#calc#_#i#_#ii#' = evaluate('t_#calc#_#i#_#ii#')>
                        <cfelse>
                            <cfset 't1_#calc#_#i#_#ii#' = 0>
                        </cfif>
                        <strong>
                            100,00%
                        </strong>
                   	</td>
               	</cfloop>
                <td style="width:5px" >&nbsp;</td>
           	</cfloop>
      	</cfcase>
 	</cfswitch>
</cfoutput>
</tr>