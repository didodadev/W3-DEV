﻿<tr style="height:20px" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-list';" class="color-list">
<cfoutput>
	<td style="text-align:right; width:50px"><strong>#t_code#&nbsp;</strong></td>
    <td><strong>#t_baslik#</strong></td>
   	<td style="text-align:right; width:80px">
    <strong>
       	<cfif isdefined('t_#calc#') and isdefined('t1_gelr1') and evaluate('t_#calc#') neq 0 and t1_gelr1 neq 0>
           	<cfset 't2_#calc#' = evaluate('t_#calc#')>
            #Tlformat(evaluate('t_#calc#')/t1_gelr1*100,2)#%
        <cfelse>
        	<cfset 't2_#calc#' = 0>
        	0,00%&nbsp;
   		</cfif>
   	</strong>
    </td>
    <td style="width:5px" >&nbsp;</td>
    <cfswitch expression="#list_type#" >
       	<cfcase value="1">
            <cfloop from="#sene1#" to="#sene2#" index="ii">
                <td style="width:80px; text-align:right">
                    <strong>
                         <cfif isdefined('t_#calc#_1_#ii#') and isdefined('t1_gelr1_1_#ii#') and evaluate('t1_gelr1_1_#ii#') neq 0 and evaluate('t_#calc#_1_#ii#') neq 0>
							<cfset 't2_#calc#_1_#ii#' = evaluate('t_#calc#_1_#ii#')>
                            #Tlformat(evaluate('t_#calc#_1_#ii#')/evaluate('t1_gelr1_1_#ii#')*100,2)#%
                        <cfelse>
                            <cfset 't2_#calc#_1_#ii#' = 0>
                            0,00%&nbsp;
                        </cfif>
                    </strong>
                </td>
                <td style="width:5px" >&nbsp;</td>
            </cfloop>
       	</cfcase>
      	<cfcase value="2">
         	<cfloop from="#sene1#" to="#sene2#" index="ii">
            	<cfloop from="1" to="#period_say#" index="i">
                	<td style="text-align:right;width:80px;<cfif DayofYear(evaluate('period_flu_#i#_#ii#')) gt DayofYear(period_date_lock) and Year(evaluate('period_flu_#i#_#ii#')) eq Year(period_date_lock)>filter:alpha(Opacity=50,FinishOpacity=40);</cfif>">
                        <strong>
                            <cfif isdefined('t_#calc#_#i#_#ii#') and isdefined('t1_gelr1_#i#_#ii#') and evaluate('t1_gelr1_#i#_#ii#') neq 0 and evaluate('t_#calc#_#i#_#ii#') neq 0>
								<cfset 't2_#calc#_#i#_#ii#' = evaluate('t_#calc#_#i#_#ii#')>
                                #Tlformat(evaluate('t_#calc#_#i#_#ii#')/evaluate('t1_gelr1_#i#_#ii#')*100,2)#%
                            <cfelse>
                                <cfset 't2_#calc#_#i#_#ii#' = 0>
                                0,00%&nbsp;
                            </cfif>
                        </strong>
                   	</td>
               	</cfloop>
                <td style="width:5px" >&nbsp;</td>
         	</cfloop>
      	</cfcase>
		<cfcase value="3">
        	<cfloop from="#sene1#" to="#sene2#" index="ii">
                 <cfloop from="1" to="#period_say#" index="i">
                	<td  style="text-align:right;width:80px;<cfif DayofYear(evaluate('period_flu_#i#_#ii#')) gt DayofYear(period_date_lock) and Year(evaluate('period_flu_#i#_#ii#')) eq Year(period_date_lock)>filter:alpha(Opacity=50,FinishOpacity=40);</cfif>">
                        <strong>
                            <cfif isdefined('t_#calc#_#i#_#ii#') and isdefined('t1_gelr1_#i#_#ii#') and evaluate('t1_gelr1_#i#_#ii#') neq 0 and evaluate('t_#calc#_#i#_#ii#') neq 0>
								<cfset 't2_#calc#_#i#_#ii#' = evaluate('t_#calc#_#i#_#ii#')>
                                #Tlformat(evaluate('t_#calc#_#i#_#ii#')/evaluate('t1_gelr1_#i#_#ii#')*100,2)#%
                            <cfelse>
                                <cfset 't2_#calc#_#i#_#ii#' = 0>
                                0,00%&nbsp;
                            </cfif>
                        </strong>
                   	</td>
               	</cfloop>
                <td style="width:5px" >&nbsp;</td>
           	</cfloop>
      	</cfcase>
 	</cfswitch>
</cfoutput>
</tr>