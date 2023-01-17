<cfsetting showdebugoutput="no">
<cfset xfa.vote = "myhome.emptypopup_vote_survey">
<cfinclude template="/myhome/query/get_survey.cfm">
<cfif IsDefined("get_survey") and get_survey.recordcount>
	<cfset anket_oyla = 1>
	<cfset attributes.survey_id = get_survey.survey_id>
<cfelse>
	<!--- oyladigi anketlerin sonucu gelir --->
	<cfquery name="GET_SURVEY_RESULT" datasource="#DSN#" maxrows="1">
		SELECT
			SURVEY,
			SURVEY_ID
		FROM
			SURVEY
		WHERE
			SURVEY_ID IN (SELECT SURVEY_ID FROM SURVEY_VOTES WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
			<cfif isdefined("attributes.survey_id") and len(attributes.survey_id)>AND SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"></cfif>
			AND VIEW_DATE_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
			AND VIEW_DATE_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
		ORDER BY
			SURVEY_ID DESC
	</cfquery>

	<cfif get_survey_result.recordcount>
		<cfset anket_goster = 1>
		<cfset attributes.survey_id = get_survey_result.survey_id>
	<cfelseif isdefined("attributes.old_survey_id")>
		<cfset attributes.survey_id = attributes.old_survey_id>
		<cfset anket_goster = 1>
		<cfquery name="GET_SURVEY_RESULT" datasource="#DSN#" maxrows="1">
			SELECT
				SURVEY,
				SURVEY_ID
			FROM
				SURVEY
			WHERE
				SURVEY_ID IN (SELECT SURVEY_ID FROM SURVEY_VOTES WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
				<cfif isdefined("attributes.survey_id") and len(attributes.survey_id)>AND SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"></cfif>
			ORDER BY
				SURVEY_ID DESC
		</cfquery>
    <cfelse>
    	<cfset attributes.survey_id = ''>
	</cfif>
	<cfset anket_oyla = 0>
</cfif>
<cfif isdefined("attributes.survey_id") and len(attributes.survey_id) and anket_oyla neq 1>
    <cfquery name="get_first_survey" datasource="#dsn#" maxrows="1">
        SELECT 
			SURVEY_ID 
		FROM 
			SURVEY 
		WHERE 
			SURVEY_ID < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND
			SURVEY_ID IN (SELECT SURVEY_ID FROM SURVEY_VOTES WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) AND
			VIEW_DATE_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			VIEW_DATE_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
		ORDER BY 
			SURVEY_ID DESC
    </cfquery>
    <cfquery name="get_last_survey" datasource="#dsn#" maxrows="1">
        SELECT 
			SURVEY_ID 
		FROM 
			SURVEY 
		WHERE 
			SURVEY_ID > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND
			SURVEY_ID IN (SELECT SURVEY_ID FROM SURVEY_VOTES WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) AND
			VIEW_DATE_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			VIEW_DATE_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
		ORDER BY 
			SURVEY_ID
    </cfquery>
<cfelse>
	<cfset get_first_survey.recordcount = 0>
	<cfset get_last_survey.recordcount = 0>
</cfif>

<cfif isdefined("anket_oyla") or isdefined("anket_goster")>
	<table align="center" width="100%" height="100%" border="0" cellpadding="1" cellspacing="1">
		<tr id="polls">
			<td>
		<cfif IsDefined("get_survey") and get_survey.recordcount>
		  <cfoutput query="get_survey">
			<table border="0">
				<tr height="22">
					<td class="txtbold" colspan="2">#survey#</td>
				</tr>
				<cfform name="vote_survey" method="post" action="#request.self#?fuseaction=#xfa.vote#">
				<input type="hidden" name="survey_id" id="survey_id" value="#survey_id#">
				<input type="hidden" name="survey_company_id" id="survey_company_id" value="<cfoutput>#session.ep.company_id#</cfoutput>">
			<cfif len(get_survey.detail)>
				<tr>
					<td colspan="2">#get_survey.detail#</td>
				</tr>
			</cfif>
			<cfloop query="get_survey_alts">
				<tr>
					<td width="20"  style="text-align:right;">
						<cfif get_survey.survey_type eq 2>
							<input type="Checkbox" name="answer" id="answer" value="#alt_id#">
						<cfelseif get_survey.survey_type eq 1>
							<input type="radio" name="answer" id="answer" value="#alt_id#">
						</cfif>
					</td>
					<td width="250">#alt#</td>
				</tr>
				</cfloop>
				<tr>
					<td style="text-align:right;" height="35" colspan="2"><input type="image" src="/images/hand.gif" value="<cf_get_lang dictionary_id='30898.Oy Ver'>"></td>
				</tr>
			  </cfform>
			</table>
		  </cfoutput> 
		<cfelse>
			<table border="0" width="100%">
			  	<tr height="22">
					<td class="txtbold" colspan="2"><cfoutput>#get_survey_result.survey#</cfoutput></td>
			  	</tr>
				<cfquery name="GET_SURVEY_VOTES_COUNT" datasource="#DSN#">
					SELECT
						ALT,
						VOTE_COUNT
					FROM
						SURVEY_ALTS
					WHERE
						SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_result.survey_id#"> 
				</cfquery>
				<cfset my_height = ((get_survey_votes_count.recordcount*20)+100)>
                <tr bgcolor="FFFFFF">
					<td>
						<cfoutput query="get_survey_votes_count">
                    <cfif len(alt) GT 30>
                        <cfset 'item_#currentrow#'="#Left(alt,30)#..." ><cfset 'value_#currentrow#'="#vote_count#">
                    <cfelse>
                        <cfset  'item_#currentrow#'="#alt#"> <cfset 'value_#currentrow#'="#vote_count#">
                    </cfif>
                    </cfoutput>
                     <script src="JS/Chart.min.js"></script>
                <canvas id="myChartpoll" style="float:left;max-height:300px;max-width:300px;"></canvas>
				<script>
					var ctx = document.getElementById('myChartpoll');
						var myChartpoll = new Chart(ctx, {
							type: 'pie',
							data: {
								labels: [<cfloop from="1" to="#get_survey_votes_count.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "grafik yuzdesi",
									backgroundColor: [<cfloop from="1" to="#get_survey_votes_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_survey_votes_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				</script>	
					</td>
				</tr>
			</table>
            </cfif>
		</td>
	</tr>
</table>
<cfelse>
	<table align="center" width="100%" height="100%" border="0" cellpadding="1" cellspacing="1" class="color-border">
  		<tr class="color-row" height="20">
			<td background="/images/anket_image.jpg" class="formbold" style="cursor:pointer;" onclick="gizle_goster(polls);" align="center">
				<cfsavecontent variable="pollmessage"><cf_get_lang dictionary_id='58662.anket'></cfsavecontent>
				<cfset upollmessage = ucase(pollmessage)>
				<cfoutput>#upollmessage#</cfoutput>
			</td>
		</tr>
        <tr class="color-row" id="polls" height="25">
            <td colspan="2"><img src="/images/listele.gif" width="7" height="12" align="absmiddle"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
        </tr>
 	</table>
</cfif>
<script type="text/javascript">
function sayfa_getir(survey_id)
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_surveys&old_survey_id=#attributes.survey_id#</cfoutput>&survey_id='+survey_id,'_survey_',1);
}
</script>
