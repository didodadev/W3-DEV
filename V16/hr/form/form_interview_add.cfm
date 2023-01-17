
<cfquery name="GET_QUIZS" datasource="#DSN#">
  SELECT
    QUIZ_ID,
	QUIZ_HEAD
  FROM 
     EMPLOYEE_QUIZ
  WHERE
      IS_INTERVIEW = 1
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_QUIZS.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.period_id" default=#DateFormat(Now(),"yyyy")#>

<cfscript>
url_string = '';

if (isdefined('attributes.maxrows')) url_string = '#url_string#&maxrows=#attributes.maxrows#';

</cfscript>

<cf_popup_box title="#getLang('hr',1971)#">
	<cfform action="#request.self#?fuseaction=hr.popup_add_emp_interview_quiz" method="post" name="search">
		<cfif isDefined("attributes.position_id")>
        	<input type="hidden" name="position_id" id="position_id" value="<cfoutput>#attributes.position_id#</cfoutput>">
        <cfelseif isDefined("attributes.EMPLOYEE_ID")>
        	<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
        </cfif>
        <cf_medium_list>
        	<thead>
            	<th colspan="2"><cf_get_lang dictionary_id='29764.Form'></th>
            </thead>
            <tbody>
			<cfoutput query="GET_QUIZS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                	<td width="20"><input type="radio" name="quiz_id" id="quiz_id" value="#quiz_id#" <cfif isdefined("attributes.quiz_id") and (attributes.quiz_id eq quiz_id)>checked</cfif>></td>
                	<td>#QUIZ_HEAD#</td>
                </tr>
			</cfoutput>
            </tbody>
        </cf_medium_list>
        <cfif isdefined("attributes.quiz_id")>
        	<input type="hidden" name="c_quiz_id" id="c_quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
        </cfif>
		<cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <tr>
      <td><cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="hr.pos_req_types#url_string#"> </td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57492.toplam'>:#GET_QUIZS.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif><br/>

