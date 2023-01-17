<!--- <cfset attributes.quiz_id = 7> --->
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
  <cf_seperator id="b_#get_quiz_chapters.currentrow#" title="Bölüm #get_quiz_chapters.currentrow#: #chapter#">
        <cfif len(chapter_info)>
        <table>
          <tr height="20">
            <td> #chapter_info# </td>
          </tr>
        </table>
        </cfif>
  <cfinclude template="../query/get_quiz_questions.cfm">
  <cfif get_quiz_questions.recordcount>
   <cfif get_quiz_chapters.answer_number neq 0><!--- not listfind(chapter_not_gd,attributes.CHAPTER_ID,',') --->
      <table id="b_#get_quiz_chapters.currentrow#">
	    <tr>
		  <td></td>
		   <td class="txtbold" width="30">GD</td>
          <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
            <cfloop from="1" to="20" index="i">
              <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                <td class="txtbold" align="center">
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <!--- <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0"> --->
					<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0"  image_link="1">
                  </cfif>
                  #evaluate('answer#i#_text')# &nbsp;</td>
              </cfif>
            </cfloop>
        </tr>
        <!--- Sorular basliyor --->
        <cfloop query="get_quiz_questions">
          <tr>
            <td class="txtbold"><cfif get_quiz_info.is_view_question is 1>#get_quiz_questions.question#<cfelse>D-#get_quiz_questions.currentrow#</cfif><!--- - #get_quiz_questions.question# ---> </td>
            <cfif ANSWER_NUMBER_gelen NEQ 0>
			<td class="txtbold" width="25">
				<input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);"value="1" autocomplete="off"> 
			</td>
			<cfelse>
			<tr>
				<td class="txtbold">
					<input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);" value="1" autocomplete="off">GD
				</td>
			</tr>
			</cfif>
          <cfif answer_number_gelen neq 0>
            <cfloop from="1" to="20" index="i">
			  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
                <td align="center">
                  <input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="Radio" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#" autocomplete="off"><!--- calc_user_point('#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#',#i#,#evaluate('c#i#')#); --->
                  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- evaluate('get_quiz_chapters.answer'&i&'_point') --->
                </td>
              </cfif>
            </cfloop>
          </tr>
          <cfelse>
          </tr>
          <cfloop from="1" to="20" index="i">
            <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
		   <!---  <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))> --->
              <tr>
			  	<!--- <td class="txtboldblue"><input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1"></td> --->
                <td class="txtbold">
                  <input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="Radio" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#" autocomplete="off"><!--- calc_user_point('#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#',#i#,#evaluate('get_quiz_questions.answer'&i&'_point')#); --->
                  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- #evaluate('get_quiz_questions.answer'&i&'_point')# --->
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <!--- <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
					<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0"  image_link="1">
                  </cfif>
                  #evaluate('get_quiz_questions.answer#i#_text')#<br/>
                </td>
				<td></td>
          		<td></td>
              </tr>
            </cfif>
          </cfloop>
          </cfif>
          <cfif len(question_info)>
            <tr height="20">
              <td>#get_quiz_questions.question_info#</td>
            </tr>
          </cfif>
        </cfloop>
      </table>
  </cfif><!--- //<cfif not listfind(chapter_not_gd,attributes.CHAPTER_ID,',')> --->
      <table width="100%" border="0">
	  <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
	<cfif (attributes.employee_id eq session.ep.userid and get_quiz_chapters.is_emp_exp1 neq 1) or (len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code and get_quiz_chapters.is_chief3_exp1 neq 1) or (len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code and get_quiz_chapters.is_chief1_exp1 neq 1) or (len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF2_CODE eq session.ep.position_code and get_quiz_chapters.is_chief2_exp1 neq 1) or (session.ep.userid neq attributes.employee_id and session.ep.position_code neq get_standbys.CHIEF1_CODE and session.ep.position_code neq get_standbys.CHIEF3_CODE and session.ep.position_code neq get_standbys.CHIEF2_CODE)><!--- Açıklama alanı çalışan,görüş bildiren,1.ve 2.amir den hangilerine gösterilip gösterilmemesi kontrol edilir. --->
		<cfif (get_quiz_chapters.is_exp1 eq 1) and len(get_quiz_chapters.exp1_name)>
		<tr>
			<td colspan="6" valign="top" nowrap>#get_quiz_chapters.exp1_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" valign="top" nowrap><textarea name="exp1_#get_quiz_chapters.currentrow#" id="exp1_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
		</tr>
		</cfif>
	</cfif>
	<cfif (attributes.employee_id eq session.ep.userid and get_quiz_chapters.is_emp_exp2 neq 1) or (len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code and get_quiz_chapters.is_chief3_exp2 neq 1) or (len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code and get_quiz_chapters.is_chief1_exp2 neq 1) or (len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF2_CODE eq session.ep.position_code and get_quiz_chapters.is_chief2_exp2 neq 1) or (session.ep.userid neq attributes.employee_id and session.ep.position_code neq get_standbys.CHIEF1_CODE and session.ep.position_code neq get_standbys.CHIEF3_CODE and session.ep.position_code neq get_standbys.CHIEF2_CODE)>
		<cfif (get_quiz_chapters.is_exp2 eq 1) and len(get_quiz_chapters.exp2_name)>
		<tr>
			<td colspan="6" valign="top" nowrap>#get_quiz_chapters.exp2_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" valign="top" nowrap><textarea name="exp2_#get_quiz_chapters.currentrow#" id="exp2_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
		</tr>
		</cfif>
	 </cfif>
	 <cfif (attributes.employee_id eq session.ep.userid and get_quiz_chapters.is_emp_exp3 neq 1) or (len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code and get_quiz_chapters.is_chief3_exp3 neq 1) or (len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code and get_quiz_chapters.is_chief1_exp3 neq 1) or (len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF2_CODE eq session.ep.position_code and get_quiz_chapters.is_chief2_exp3 neq 1) or (session.ep.userid neq attributes.employee_id and session.ep.position_code neq get_standbys.CHIEF1_CODE and session.ep.position_code neq get_standbys.CHIEF3_CODE and session.ep.position_code neq get_standbys.CHIEF2_CODE)>
		<cfif (get_quiz_chapters.is_exp3 eq 1) and len(get_quiz_chapters.exp3_name)>
		<tr>
			<td colspan="6" valign="top" nowrap>#get_quiz_chapters.exp3_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" valign="top" nowrap><textarea name="exp3_#get_quiz_chapters.currentrow#" id="exp3_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
		</tr>
		</cfif>
	 </cfif>
	 <cfif (attributes.employee_id eq session.ep.userid and get_quiz_chapters.is_emp_exp4 neq 1) or (len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code and get_quiz_chapters.is_chief3_exp4 neq 1) or (len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code and get_quiz_chapters.is_chief1_exp4 neq 1) or (len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF2_CODE eq session.ep.position_code and get_quiz_chapters.is_chief2_exp4 neq 1) or (session.ep.userid neq attributes.employee_id and session.ep.position_code neq get_standbys.CHIEF1_CODE and session.ep.position_code neq get_standbys.CHIEF3_CODE and session.ep.position_code neq get_standbys.CHIEF2_CODE)>
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
  <cfelse>
  <table>
  <tr height="20">
    <td><cf_get_lang dictionary_id='55829.Kayıtlı Soru Bulunamadı!'></td>
  </tr>
  </table>
</cfif>
<!--- </table>  --->
</cfoutput>
<cfelse>
<table>
<tr height="20">
  <td><cf_get_lang dictionary_id='55830.Kayıtlı Bölüm Bulunamadı!'></td>
</tr>
</table>
</cfif>

<!---<script type="text/javascript">
/*calc_user_point();*/
 
/*function check_expl()
{
<cfoutput query="get_quiz_chapters">
  <cfset attributes.CHAPTER_ID = CHAPTER_ID>
  <cfinclude template="../query/get_quiz_questions.cfm">
  <cfif get_quiz_questions.recordcount and get_quiz_chapters.answer_number>
        <cfloop query="get_quiz_questions">
		if(document.add_perform.expl_#get_quiz_chapters.currentrow#.value == '' && document.add_perform.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#.checked == false)
		{
			var kontrol=0;
			for(var i=0;i<#get_quiz_chapters.answer_number#;i++)
			{
				if 	(document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#[i].checked == true)
					kontrol=1;			  
			}
		}
		if 	(kontrol==1)
			{
			alert('Bölüm #get_quiz_chapters.currentrow# için açıklama girmelisiniz !');
			return false;					  
			}
        </cfloop>
  </cfif>
</cfoutput>
}*/
</script>--->

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
				alert("<cf_get_lang dictionary_id='31739.İşaretlemediğiniz Sorular Var !'>");
				return false;					  
			}
        </cfloop>          
  </cfif>
</cfoutput>
return true;
}
</script>
