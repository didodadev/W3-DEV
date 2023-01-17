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
 <cfsavecontent variable="message"><cf_get_lang dictionary_id="57995.Bölüm"></cfsavecontent>
  <cf_seperator title="#message# #get_quiz_chapters.currentrow#: #chapter#" id="bolumler_">
  <table id="bolumler_">
	<cfif len(chapter_info)>
	  <tr height="20">
		<td> #chapter_info#</td>
	  </tr>
	</cfif>
  </table>
  <cfinclude template="../query/get_quiz_questions.cfm">
  <cfif get_quiz_questions.RecordCount>
  <cfset counter_ = 1>
      <table>
        <tr>
           <td width="300"></td>
		   <td class="formbold" width="500">GD</td>
          <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
          <cfif get_quiz_chapters.answer_number neq 0>
            <cfloop from="1" to="20" index="i">
              <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                <td class="txtbold" align="center" width="75">
                  <cfif len(evaluate("answer"&i&"_photo"))>
					<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0"  image_link="1">
                  </cfif>
                  #evaluate('answer#i#_text')#&nbsp;</td>
				  <cfset counter_ = counter_ + 1>
              </cfif>
            </cfloop>
          </cfif>
        </tr>
        <!--- Sorular basliyor --->
        <cfloop query="get_quiz_questions">
          <tr>
            <td class="txtbold">#get_quiz_questions.currentrow# - #get_quiz_questions.question#</td>
           
			<cfif get_quiz_questions.open_ended eq 1>
				<td class="txtbold" colspan="#counter_#"><textarea style="width:300px;height:50px" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="text"  value=""></textarea></td>
			<cfelse>
				 <td class="txtbold">
					<input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1">
				</td>
				<cfif get_quiz_chapters.answer_number neq 0>
				<cfloop from="1" to="20" index="i">
				  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
					<td align="center" width="75">
					  <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#"><!--- calc_user_point('#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#',#i#,#evaluate('c#i#')#); --->
					  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- evaluate('get_quiz_chapters.answer'&i&'_point') --->
					</td>
				  </cfif>
				</cfloop>
				</tr>
				<cfelse>
				</tr>
				<cfloop from="1" to="20" index="i">
				<cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
				  <tr>
					<td width="75">
					  <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#">
					  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('get_quiz_questions.answer'&i&'_point')#">
					  <cfif len(evaluate("answer"&i&"_photo"))>
						<!--- <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
						<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0"  image_link="1">
					  </cfif>
					  #evaluate('get_quiz_questions.answer#i#_text')#<br/>
					</td>
					<td class="txtbold"><!--- <input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1"> ---></td>
				  </tr>
				</cfif>
				</cfloop>
				</cfif>
			</cfif>
          <cfif len(question_info)>
            <tr height="20">
              <td colspan="5">#get_quiz_questions.question_info# </td>
            </tr>
          </cfif>
        </cfloop>
      </table>
      <table>
     <!---    <tr>
			<td class="txtbold" width="40">Açıklama</td>
			<td class="txtbold"><textarea name="expl_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2"></textarea></td>
          </tr> --->
		  <cfloop from="1" to="4" index="j">
			<cfif len(evaluate('exp#j#_name')) and evaluate('is_exp#j#') eq 1>
				<tr>
					<td class="txtbold" width="120">#evaluate('exp#j#_name')# &nbsp;</td>
					<td class="txtbold"><textarea name="exp#j#_#get_quiz_chapters.currentrow#" id="exp#j#_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2"></textarea></td>
				</tr>
			</cfif>
		</cfloop> 
      </table>
  <cfelse>
  <table>
	  <tr>
		<td><cf_get_lang dictionary_id ='55829.Kayıtlı Soru Bulunamadı'>!</td>
	  </tr>
  </table>
</cfif>
<!--- </table>  --->
</cfoutput>
<cfelse>
	<table>
		<tr>
		  <td><cf_get_lang dictionary_id ='55830.Kayıtlı Bölüm Bulunamadı'>!</td>
		</tr>
	</table>
</cfif>
