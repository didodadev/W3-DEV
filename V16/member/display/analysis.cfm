<cfinclude template="../query/get_analysis.cfm">
<cfinclude template="../query/get_analysis_questions.cfm">
<cfquery name="get_result_control" datasource="#dsn#">
	SELECT TOP 1 RESULT_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = #analysis_id#
</cfquery>
<cfset grand_total_point = 0>
<cf_catalystHeader>

	
	<cfif not listfindnocase(denied_pages,'member.popup_form_upd_analysis')>
		<cfinclude template="../form/upd_analysis.cfm">
	</cfif>
	<div class="col col-12 col-xs-12">
		<div class="row form-group" type="row">
			<cfsavecontent variable="txt">
				<cfif not get_result_control.recordcount>
					<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=member.list_analysis&event=addSub&analysis_id=<cfoutput>#analysis_id#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='30301.Yeni Soru Ekle'>"></i></a>
				</cfif>
				</cfsavecontent>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="58087.Sorular"></cfsavecontent>
				<cf_box title="#message#" add_href="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=addSub&analysis_id=#analysis_id#');">
					<cfif get_analysis_questions.recordcount>
						<cfoutput query="get_analysis_questions">
						<cfif QUESTION_TYPE eq 1><!---20131028--->
							<cfsavecontent variable="questiontype"><cf_get_lang dictionary_id="30178.Tek Cevaplı"></cfsavecontent>
						<cfelseif QUESTION_TYPE eq 2>
							<cfsavecontent variable="questiontype"><cf_get_lang dictionary_id="30398.Çok Cevaplı"></cfsavecontent>
						<cfelseif QUESTION_TYPE eq 3>
							<cfsavecontent variable="questiontype"><cf_get_lang dictionary_id="30296.Açık Uçlu Soru"></cfsavecontent>
						</cfif>
						<cf_seperator id="question#currentrow#_1" header="#question#"  is_closed="1" style="text-align:left;"><!---20131028--->
						<cf_ajax_list id="question#currentrow#_1" style="display:none; margin-bottom:10px;" width="100%">	
							<tr>
								<td colspan="3" style="text-align:right;">
									<cfif not listfindnocase(denied_pages,'member.popup_form_upd_question')>
										<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=updSub&analysis_id=#analysis_id#&question_id=#question_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									</cfif>
										<cfif not get_result_control.recordcount><!--- analiz formu doldurulmus ise silinemez--->
										<cfif not listfindnocase(denied_pages,'member.emptypopup_del_question')>
											<cfsavecontent variable="del_rec"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
											<a href="##" onClick="javascript:if (confirm('#del_rec#')) windowopen('#request.self#?fuseaction=member.emptypopup_del_question&analysis_id=#analysis_id#&question_id=#question_id#','small','emptypopup_del_question'); else return;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
										</cfif>
									</cfif> 
								</td>
							</tr>
							<cfif answer_number neq 0>
								<!--- şıklar ayrı tabloya taşındı--->
								<cfset attributes.question_id = question_id>
								<cfset total_point = 0>
								<cfinclude template="../query/get_question_answers.cfm">
								<cfloop query="get_question_answers">
									<cfif len(evaluate("answer_photo")) or len(evaluate("answer_text"))>
										<tr>
											<td width="20">
												P:&nbsp#ANSWER_POINT#&nbsp&nbsp
											</td>
											<td width="15" >
												<cfif get_analysis_questions.question_type eq 1>
													<input type="radio" name="user_answer_#QUESTION_ID#" id="user_answer_#QUESTION_ID#">
													<cfif #ANSWER_POINT# GT total_point>
														<cfset total_point= #ANSWER_POINT#>
													</cfif>
												<cfelseif get_analysis_questions.question_type eq 2>
													<input type="checkbox" name="user_answer_#QUESTION_ID#" id="user_answer_#QUESTION_ID#">
													<cfset total_point =  total_point + #ANSWER_POINT#>
												<cfelse>
													<cfset total_point =  total_point + #ANSWER_POINT#>
												</cfif>
												<cfif len(evaluate("answer_photo"))>
													<cf_get_server_file output_file="member/#evaluate("answer_photo")#" output_server="#evaluate("answer_photo_server_id")#" output_type="0" image_width="38" image_height="35" image_link="1">
												</cfif>
											</td>
											<td>
												#evaluate('answer_text')#
												<cfif len(evaluate('answer_product_id'))>
													<cfset product_id = evaluate('answer_product_id')>
													<cfinclude template="../query/get_product_name.cfm">
													<cfif get_product_name.recordcount>
														(#get_product_name.product_name#)
													</cfif>
												</cfif>
											</td>
										</tr>
									</cfif>
								</cfloop>
							</cfif>
							<cfset grand_total_point =  grand_total_point + isdefined("total_point")?total_point:0>
							<cfset attributes.grand_total_point = #grand_total_point#>
							<cfif len(question_info)>
								<tr>
									<td class="txtbold"><cf_get_lang dictionary_id='57556.Bilgi'>: #question_info# </td>
								</tr>
							</cfif>
						</cf_ajax_list>
						</cfoutput>
					<cfelse>
						<table>
							<tr>
								<td><cf_get_lang dictionary_id='57484.Kayıt Yok!'></td>
							</tr>
						</table>
					</cfif>
					<div class="ui-info-bottom">
						<p>
							<b>Toplam Puan: &nbsp</b>
							<input type="hidden" value="<cfoutput>#grand_total_point#</cfoutput>" id="grand_total_point" name="grand_total_point">
							<cfoutput>#grand_total_point#</cfoutput>
						</p>
					</div>
				</cf_box>
		</div>
	</div>
	
<script type="text/javascript">
	$(function(){
		$('#grand_total_point1').val($('#grand_total_point').val()) ;
	});
</script>