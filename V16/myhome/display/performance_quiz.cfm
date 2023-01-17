<!--- cf_popup_box --->
<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<cfinclude template="../query/get_quiz_chapters.cfm">
<cfif get_quiz_chapters.recordcount>
	<cfoutput query="get_quiz_chapters">
		<cfset answer_number_gelen = get_quiz_chapters.answer_number>
		<cfset attributes.CHAPTER_ID = CHAPTER_ID>
		<cfscript>
			for (i=1; i lte 20; i = i+1)
			{
				"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
				"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
				"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
			}
		</cfscript>
		<!---Bolum basliklarini getirir--->
		<tr>
			<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57995.Bölüm'></cfsavecontent>
            <cf_seperator id="b_#get_quiz_chapters.currentrow#" title="#message# #chapter#">
			<table id="b_#get_quiz_chapters.currentrow#">
				<tr>
					<td class="txtboldblue"><a href="javascript://" onClick="gizle_goster(b_#get_quiz_chapters.currentrow#)"><cf_get_lang dictionary_id='57995.Bölüm'> #get_quiz_chapters.currentrow#: #chapter#</a></td>
				</tr>
				<cfif len(chapter_info)>
					<tr height="20">
						<td>#chapter_info#</td>
					</tr>
				</cfif>
				</tr>
				<tr>
			<td>
			<table id="b_#get_quiz_chapters.currentrow#">
				<cfinclude template="../query/get_quiz_questions.cfm">
				<cfset counter_ = 1>
				<cfif get_quiz_questions.recordcount>
					<cfif get_quiz_chapters.answer_number neq 0>
						<tr class="color-row" >
							<td>
							<table border="0" cellpadding="0" cellspacing="2" style="width:100%">
								<tr class="color-list"> 
									<td style="width:600px;"></td>
									<td class="txtbold" width="30" valign="top" style="text-align:center">GD</td>
									<!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
									<cfloop from="1" to="20" index="i">
										<cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
											<td class="txtbold" style="width:75px;text-align:center">
												#evaluate('answer#i#_text')#<br/>
												<cfif len(evaluate("answer"&i&"_photo"))>
													<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
												</cfif>
												&nbsp;
											</td>
											<cfset counter_ = counter_ + 1>
										</cfif>
									</cfloop>
								</tr>
								<!--- Sorular basliyor --->
								<cfloop query="get_quiz_questions">
								<tr class="color-list">
									<td class="txtbold" valign="top"><cfif get_quiz_info.is_view_question is 1>#get_quiz_questions.currentrow#-#get_quiz_questions.question#<cfelse>D-#get_quiz_questions.currentrow#</cfif></td>
									<cfif get_quiz_questions.open_ended eq 1>
										<td class="txtbold" colspan="#counter_#"><textarea style="width:100%;height:50px" name="gd_opened_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_opened_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="text"  value=""></textarea></td>
									<cfelse>
										<cfif ANSWER_NUMBER_gelen NEQ 0>
											<td class="txtboldblue" style="width:75px;text-align:center">
												<input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);"value="1" autocomplete="off"> 
											</td>
										<cfelse>
											<tr class="color-list">
												<td class="txtbold" style="width:75px;text-align:center">
													<input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);" value="1" autocomplete="off">GD
												</td>
											</tr>
										</cfif>	
										<cfif answer_number_gelen neq 0>
											<cfloop from="1" to="20" index="i">
												<cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
													<td style="text-align:center">
														<input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="Radio" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#" autocomplete="off"><!--- calc_user_point('#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#',#i#,#evaluate('c#i#')#); --->
														<input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- evaluate('get_quiz_chapters.answer'&i&'_point') --->
													</td>
												</cfif>
											</cfloop>
										<cfelse>
											<cfloop from="1" to="20" index="i">
												<cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
													<tr class="color-list">
														<td class="txtbold" style="text-align:center">
															<input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="Radio" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#" autocomplete="off"><!--- calc_user_point('#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#',#i#,#evaluate('get_quiz_questions.answer'&i&'_point')#); --->
															<input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- #evaluate('get_quiz_questions.answer'&i&'_point')# --->
															#evaluate('get_quiz_questions.answer#i#_text')#
															<cfif len(evaluate("answer"&i&"_photo"))>
															<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
															</cfif>
															<br/>
														</td>
														<td></td>
														<td></td>
													</tr>
												</cfif>
											</cfloop>
										</cfif>
										<cfif len(question_info)>
											<tr height="20" class="color-list">
												<td>#get_quiz_questions.question_info#</td>
											</tr>
										</cfif>
									</cfif>
								</tr>
								</cfloop>
							</table>
							</td>
						</tr>
					</cfif>
					<tr>
						<td>
						<table width="100%" border="0">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
							<cfif (attributes.employee_id eq session.ep.userid and get_quiz_chapters.is_emp_exp1 neq 0) or isdefined("attributes.display") or (len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code and get_quiz_chapters.is_chief3_exp1 neq 0) or (len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code and get_quiz_chapters.is_chief1_exp1 neq 0) or (len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF2_CODE eq session.ep.position_code and get_quiz_chapters.is_chief2_exp1 neq 0)><!--- Açıklama alanı çalışan,görüş bildiren,1.ve 2.amir den hangilerine gösterilip gösterilmemesi kontrol edilir. --->
								<cfif (get_quiz_chapters.is_exp1 eq 1) and len(get_quiz_chapters.exp1_name)>
									<tr>
										<td colspan="6" valign="top" nowrap class="txtbold">#get_quiz_chapters.exp1_name#&nbsp;</td>
									</tr>
									<tr>
										<td colspan="6" valign="top" nowrap>
											<textarea name="exp1_#get_quiz_chapters.currentrow#" id="exp1_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
										</td>
									</tr>
								</cfif>
							</cfif>
							<cfif (attributes.employee_id eq session.ep.userid and get_quiz_chapters.is_emp_exp2 neq 0) or isdefined("attributes.display") or (len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code and get_quiz_chapters.is_chief3_exp2 neq 0) or (len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code and get_quiz_chapters.is_chief1_exp2 neq 0) or (len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF2_CODE eq session.ep.position_code and get_quiz_chapters.is_chief2_exp2 neq 0)>
								<cfif (get_quiz_chapters.is_exp2 eq 1) and len(get_quiz_chapters.exp2_name)>
									<tr>
										<td colspan="6" valign="top" nowrap class="txtbold">#get_quiz_chapters.exp2_name#&nbsp;</td>
									</tr>
									<tr>
										<td colspan="6" valign="top" nowrap><textarea name="exp2_#get_quiz_chapters.currentrow#" id="exp2_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
									</tr>
								</cfif>
							</cfif> 
							<cfif (attributes.employee_id eq session.ep.userid and get_quiz_chapters.is_emp_exp3 neq 0) or isdefined("attributes.display") or (len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code and get_quiz_chapters.is_chief3_exp3 neq 0) or (len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code and get_quiz_chapters.is_chief1_exp3 neq 0) or (len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF2_CODE eq session.ep.position_code and get_quiz_chapters.is_chief2_exp3 neq 0)>
								<cfif (get_quiz_chapters.is_exp3 eq 1) and len(get_quiz_chapters.exp3_name)>
									<tr>
										<td colspan="6" valign="top" nowrap class="txtbold">#get_quiz_chapters.exp3_name#&nbsp;</td>
									</tr>
									<tr>
										<td colspan="6" valign="top" nowrap><textarea name="exp3_#get_quiz_chapters.currentrow#" id="exp3_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
									</tr>
								</cfif>
							</cfif> 
							<cfif (attributes.employee_id eq session.ep.userid and get_quiz_chapters.is_emp_exp4 neq 0) or isdefined("attributes.display") or (len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code and get_quiz_chapters.is_chief3_exp4 neq 0) or (len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code and get_quiz_chapters.is_chief1_exp4 neq 0) or (len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF2_CODE eq session.ep.position_code and get_quiz_chapters.is_chief2_exp4 neq 0)>
								<cfif (get_quiz_chapters.is_exp4 eq 1) and len(get_quiz_chapters.exp4_name)>
									<tr>
										<td colspan="6" valign="top" nowrap>#get_quiz_chapters.exp4_name#&nbsp;</td>
									</tr>
									<tr>
										<td colspan="6" valign="top" nowrap><textarea name="exp4_#get_quiz_chapters.currentrow#" id="exp4_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
									</tr>
								</cfif>
							</cfif> 
						</table>
						</td>
					</tr>
				<cfelse>
					<tr>
						<td><cf_get_lang dictionary_id='55829.Kayıtlı Soru Bulunamadı!'></td>
					</tr>
				</cfif>
			</table>
			</td>
		</tr>
        	</table>
            </td>
            </tr>
	</cfoutput>
<cfelse>
	<tr>
		<td><cf_get_lang dictionary_id='55830.Kayıtlı Bölüm Bulunamadı!'></td>
	</tr>
</cfif>

<script type="text/javascript">
function radio_degistir(ilk,son)
{
x = eval("document.add_perform.user_answer_" + ilk + "_" + son + ".length");
for (i=0; i < x; i++)
{
eval("document.add_perform.user_answer_" + ilk + "_" + son)[i].checked = false;
}
}
function radio_degistir_2(ilk,son)
{
eval("document.add_perform.gd_" + ilk + "_" + son).checked = false;
}

function check_expl() //* Sürec onay asamasindaysa ve isaretlenmemis soru varsa bu fonksiyon cagrilir..Senay 20061013
{ 
<cfoutput query="get_quiz_chapters">
<cfset attributes.CHAPTER_ID = CHAPTER_ID>
<cfinclude template="../query/get_quiz_questions.cfm">
<cfif get_quiz_questions.RecordCount and get_quiz_chapters.ANSWER_NUMBER>
<cfloop query="get_quiz_questions">
var kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=0;
if(document.add_perform.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#.checked == false)
{
for(var i=0;i<#get_quiz_chapters.answer_number#;i++)
{
if(document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#[i]!=undefined && document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#[i].checked == true)
{
kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=1;
break;
}else  kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=0;
}
}else kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=1;
if(kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#==0)
{
alert("<cf_get_lang dictionary_id='31739.İşaretlemediğiniz Sorular Var'>!");
return false;					  
}
</cfloop>          
</cfif>
</cfoutput>
return true;
}
</script>
