<cfinclude template="../query/check_user_vote.cfm">	
<cfif check_user_vote.recordcount>
	<cfinclude template="../query/get_survey_votes_count.cfm">			
<cfelse>
	<cfinclude template="../query/get_survey.cfm">	
	<cfinclude template="../query/get_survey_alts.cfm">	
</cfif>

<cfif not isdefined("attributes.chart_type")>
	<cfset attributes.chart_type = "pie">
</cfif>
<cfif check_user_vote.recordcount>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td clasS="headbold"><cf_get_lang no='276.Anket Sonuçları'></td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <table cellspacing="0" cellpadding="0">
                <tr class="color-border">
                    <td>
                        <table cellspacing="1" cellpadding="2" width="100%"> 
                            <cfform method="post">
                                <tr class="color-header">
                                    <td>
                                        <table width="100%" class="form-title"> 
                                            <tr>
                                                <td><cf_get_lang no='277.Anket Sonucu'></td>
                                                    <td width="75">
                                                        <select name="chart_type" id="chart_type" style="width:75px;">
                                                            <option value="area" <cfif attributes.chart_type is "area">selected</cfif>>area</option>
                                                            <option value="bar" <cfif attributes.chart_type is "bar">selected</cfif>>bar</option>
                                                            <option value="cone" <cfif attributes.chart_type is "cone">selected</cfif>>cone</option>
                                                            <option value="curve" <cfif attributes.chart_type is "curve">selected</cfif>>curve</option>
                                                            <option value="cylinder" <cfif attributes.chart_type is "cylinder">selected</cfif>>cylinder</option>
                                                            <option value="line" <cfif attributes.chart_type is "line">selected</cfif>>line</option>
                                                            <option value="pie" <cfif attributes.chart_type is "pie">selected</cfif>>pie</option>
                                                            <option value="pyramid" <cfif attributes.chart_type is "pyramid">selected</cfif>>pyramid</option>
                                                            <option value="scatter" <cfif attributes.chart_type is "scatter">selected</cfif>>scatter</option>
                                                            <option value="step" <cfif attributes.chart_type is "step">selected</cfif>>step</option>
                                                        </select>
                                                    </td>
                                                <td width="18"><cf_wrk_search_button></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#FFFFFF">
                                        <cfchart show3d="yes" showlegend="yes" font="ARIAL" format="jpg">
                                            <cfchartseries type="#attributes.chart_type#" paintstyle="light">
                                                <cfoutput query="get_survey_votes_count">
                                                    <cfchartdata item="#alt#" value="#vote_count#">
                                                </cfoutput>
                                            </cfchartseries>
                                        </cfchart>
                                    </td>
                                </tr>
                            </cfform>
                        </table>
                    </td>
                </tr>
            </table>
<br/>
<font color="red">*<cf_get_lang no='279.Bu ankete oy verdiniz'>.</font>
        </td>
    </tr>
</table>
</td>
</tr>
</table>
<cfelse>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='278.Oy Ver'> : <cfoutput>#get_survey.survey#</cfoutput></td>
    </tr>
</table>
	<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" height="35" class="color-border">
  <tr class="color-row">
    <td>
	<table border="0">
	<cfform name="vote_survey" method="POST" action="#request.self#?fuseaction=objects2.popup_add_survey_vote">
	<input type="Hidden" name="survey_id" id="survey_id" value="<cfoutput>#survey_id#</cfoutput>">
	<cfif len(get_survey.detail)>
	  <tr>
	    <td colspan="2"><cfoutput>#get_survey.detail#</cfoutput></td>
	  </tr>
	</cfif>
	<!--- <cfset count = 0>
	<cfoutput query="get_survey_alts">
		<cfif is_true eq 1>
			<cfset count = count + 1>
		</cfif>
	</cfoutput> --->
	<cfoutput query="get_survey_alts">
	  <tr> 
		<td>
		<cfif get_survey.SURVEY_TYPE IS 2>
			<input type="Checkbox" name="answer" id="answer" value="#alt_id#">
		<cfelseif get_survey.SURVEY_TYPE IS 1>
			<input type="radio" name="answer" id="answer" value="#alt_id#">
		</cfif>
		</td>
		<td>#alt#</td>
	  </tr>
	</cfoutput>
	<tr>
		<td colspan="2" align="right" height="35">
			<cf_workcube_buttons is_upd='0' insert_alert='Oy Ver'> 
		</td>
	</tr>
	</cfform>
	</table>
	</td>
   </tr>
 </table>
</cfif>
