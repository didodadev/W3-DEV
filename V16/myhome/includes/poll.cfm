<cfsetting showdebugoutput="no">
<cfset xfa.vote = "myhome.emptypopup_vote_survey">
<cfinclude template="../query/get_survey.cfm">
<cfset kayit_yok = 1>
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
        	SURVEY_STATUS = 1 AND
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
		<table width="100%">
			<cfif get_first_survey.recordcount or get_last_survey.recordcount>
			<tr height="20">
				<td style="text-align:right;">
					<cfoutput>
                        <cfif get_first_survey.recordcount>
                            <a href="javascript://" onclick="sayfa_getir('<cfoutput>#get_first_survey.survey_id#</cfoutput>');"><img src="/images/previous20.gif" alt="Bir Önceki Anket"></a>
                        </cfif>
                        <cfif get_last_survey.recordcount>
                            <a href="javascript://" onclick="sayfa_getir('<cfoutput>#get_last_survey.survey_id#</cfoutput>');"><img src="/images/next20.gif" alt="Bir Sonraki Anket"></a>
                        </cfif> 
                    </cfoutput>                       
				</td>       				  
			</tr>
			</cfif>
			<tr id="polls">
				<td>
					<cfif isDefined('attributes.survey_id') and len(attributes.survey_id)>
						<cfquery name="getsurv" datasource="#dsn#">
							SELECT SURVEY FROM  SURVEY WHERE SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
						</cfquery>
					</cfif>
                	<cfform name="vote_survey" method="post" action="#request.self#?fuseaction=#xfa.vote#">
						<cfif IsDefined("get_survey") and get_survey.recordcount>
                            <cfset kayit_yok = 0>
                            <cfoutput query="get_survey">
								<div class="ui-scroll">
									<cf_flat_list>
										<thead>
											<tr height="22">
												<td class="text-bold" style="border-top:none!important" colspan="2">#getsurv.survey#</td>
											</tr>
										</thead>
										<input type="hidden" name="survey_id" id="survey_id" value="#survey_id#">
										<input type="hidden" name="survey_company_id" id="survey_company_id" value="<cfoutput>#session.ep.company_id#</cfoutput>">
										<cfif len(get_survey.detail)>
											<tbody>
												<tr>
													<td colspan="2">#get_survey.detail#</td>
												</tr>
											</tbody>
										</cfif>
										<tbody>
											<cfloop query="get_survey_alts">
												<tr id="row_#alt_id#">
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
										</tbody>
										<tfoot>
											<tr>
												<td class="text-right" colspan="2"><input type="image" src="/images/icons_valid.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='30898.Oy Ver'>" title="<cf_get_lang dictionary_id='30898.Oy Ver'>" value="<cf_get_lang dictionary_id='30898.Oy Ver'>"> <cf_get_lang dictionary_id='30898.Oy Ver'> </td>
											</tr>
										</tfoot>
									</cf_flat_list>
								</div>
							</cfoutput> 
						<cfelseif get_survey_result.recordcount>
                            <cfset kayit_yok = 0>
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
								
							<canvas id="myChartpolls" style="float:left;max-height:300px;max-width:300px;"></canvas>
							<script>
								var ctx = document.getElementById('myChartpolls').getContext('2d');
									var myChartpolls = new Chart(ctx, {
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
                        <cfelse>
                            <table class="ajax_list">
                                <tr>
                                    <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                                </tr>
                            </table>
                        </cfif>
                    </cfform>
				</td>
			</tr>
		</tbody>
	</table>
</cfif>
<cfif get_generator_survey.recordcount>
	<table class="ajax_list">
		<thead>
			<tr>
				<th>Değerlendirme Anketleri</th>
			</tr>
		</thead>
		<cfoutput query="get_generator_survey">
		<tr>
			<td>
			<cfif IS_UPDATE eq 0>
				<cfset survey_main_id_ = contentEncryptingandDecodingAES(isEncode:1,content:survey_main_id,accountKey:session.ep.userid)>
				<cfset a_type_id = contentEncryptingandDecodingAES(isEncode:1,content:14,accountKey:session.ep.userid)>
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&fbx=myhome&survey_id=#survey_main_id_#&action_type_id=#a_type_id#&is_popup=1','page')">#SURVEY_MAIN_HEAD#</a>
			<cfelse>
				<cfset survey_main_id_ = contentEncryptingandDecodingAES(isEncode:1,content:survey_main_id,accountKey:session.ep.userid)>
				<cfset result_id_ = contentEncryptingandDecodingAES(isEncode:1,content:IS_UPDATE,accountKey:session.ep.userid)>
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&fbx=myhome&survey_id=#survey_main_id_#&result_id=#result_id_#&is_popup=1','page')">#SURVEY_MAIN_HEAD#</a>
			</cfif>
			</td>
		</tr>
		</cfoutput>
	</table>
</cfif>
<script type="text/javascript">
function sayfa_getir(survey_id)
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_surveys&old_survey_id=#attributes.survey_id#</cfoutput>&survey_id='+survey_id,'body_poll_now',1);
}
</script>
