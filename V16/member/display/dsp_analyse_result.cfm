<cfquery name="RESULT_DETAIL" datasource="#dsn#">
	SELECT ANALYSIS_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = #attributes.analysis_id# ORDER BY USER_POINT DESC
</cfquery>
<script src="JS/Chart.min.js"></script>
<cfinclude template="../query/get_analysis.cfm">
<cfinclude template="../query/get_analysis_questions.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30625.Katılım'></cfsavecontent>
<cf_catalystHeader>

<cf_box title="#message# #GET_ANALYSIS.ANALYSIS_HEAD# - #ListValueCount("1,1,1,1,111","1")#">
		<table width="98%" align="center">
			<tr>
				<td class="txtbold" height="22" colspan="2"><cf_get_lang dictionary_id ='30625.Katılım'>: <cfoutput>#RESULT_DETAIL.RecordCount#</cfoutput></td>
            </tr>

            <cfoutput query="get_analysis_questions">
            <tr>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58810.Soru'></cfsavecontent>
                	<cf_seperator id="soru_#currentrow#" header="#message# #currentrow# : #question#" is_closed="1">
                	<table id="soru_#currentrow#" style="display:none">
                        <cfinclude template="../query/get_analysis_questions_result.cfm">
                        <cfif ANSWER_NUMBER NEQ 0>
                        <cfset attributes.question_id = question_id>
                        <cfinclude template="../query/get_question_answers.cfm">
                        <tr class="nohover">
                            <td width="300"> 
                  
                                 <cfloop query="get_question_answers">
                                        <cfif len(answer_text)>
                                            <cfset 'item_#currentrow#'='#answer_text#'>
                                            <cfset 'value_#currentrow#'="#ListValueCount(ValueList(GET_ANALYSIS_QUESTIONS_RESULT.QUESTION_USER_ANSWERS), row)#">
                                        </cfif>	
                                    </cfloop>
                                    <canvas id="myChart_#currentrow#" style="height:100%;"></canvas>
                                    
                                    <script>
                                        var ctx = document.getElementById('myChart_#currentrow#');
                                        var myChart = new Chart(ctx, {
                                            type: 'bar',
                                            data: {
                                                    labels: [<cfloop query="get_question_answers"><cfif len(answer_text) > "#trim(answer_text)#",</cfif></cfloop>],
                                                    datasets: [{
                                                    label: "<cf_get_lang dictionary_id ='38309.Is Sayisi'>",
                                                    backgroundColor: [<cfloop query="get_question_answers">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                    data: [<cfloop query="get_question_answers">"#ListValueCount(ValueList(GET_ANALYSIS_QUESTIONS_RESULT.QUESTION_USER_ANSWERS), row)#",</cfloop>],
                                                        }]
                                                    },
                                            options: {}
                                        });
                                    </script> 
                            </td>
                            <td valign="top">
                                <cfloop query="get_question_answers">
                                    <cfif len(answer_text)>
                                        #answer_text# : #ListValueCount(ValueList(GET_ANALYSIS_QUESTIONS_RESULT.QUESTION_USER_ANSWERS), row)#<br/><br/>
                                    </cfif>	
                                </cfloop> 
                            </td>
                        </tr>
                    </table>
				</td>
			</tr>
				<cfelse>
				<tr>
					<td colspan="2">&nbsp;<cf_get_lang dictionary_id='30296.Açık Uçlu Soru'><br/></td>
				</tr>
				</cfif>
        </cfoutput>
		</table>
</cf_box>
