<cfinclude template="get_view_question.cfm">
<cf_popup_box title="#getLang('training',26)#"><!---Soru- Alıştırma--->
	<cfif not isdefined("attributes.gelen")>
		<!--- Birinci Kısım --->
            <form name="make_quiz" id="make_quiz" action="" method="post">
                <input type="hidden" name="gelen" id="gelen" value="1">
                    <cfoutput query="VIEW_QUESTION">
                        <table>
                            <tr>
                                <td class="txtbold"><cf_get_lang_main no='1398.Soru'></td>
                                <td>: #question#</td>
                            </tr>
                            <cfif ANSWER_NUMBER NEQ 0>
                              <cfset right_number = 0>
                                  <cfloop from="1" to="#answer_number#" index="i">
                                        <cfif evaluate("answer#i#_true") eq 1>
                                            <cfset right_number = right_number + 1>
                                        </cfif>
                                  </cfloop>
                                <cfloop from="1" to="20" index="i">
                                    <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                                        <tr>
                                            <td colspan="2">
                                                <cfswitch expression="#right_number#">
                                                    <cfcase value="1">
                                                        <input type="Radio" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
                                                    </cfcase>
                                                    <cfdefaultcase>
                                                        <input type="checkbox" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
                                                    </cfdefaultcase>
                                                </cfswitch>
                                                <cfif len(evaluate("answer"&i&"_photo"))>
                                                    <img src="#file_web_path#training/#evaluate("answer"&i&"_photo")#" border="0">
                                                </cfif>					
                                                #evaluate("answer"&i&"_text")#
                                            </td>
                                        </tr>
                                    </cfif>
                                </cfloop>
                            <cfelse>
                                <input type="Hidden" name="open_question" id="open_question" value="1">
                                <tr>
                                    <td colspan="2"><textarea name="user_answer" id="user_answer" cols="50" rows="4"></textarea></td>
                                </tr>
                            </cfif>
                       </table>
                       <cf_popup_box_footer>
                           <cfsavecontent variable="message"><cf_get_lang_main no='1744.Cevapla'></cfsavecontent>
                           <cf_workcube_buttons is_upd='0' insert_info='#message#'>
                       </cf_popup_box_footer>
                        <input type="Hidden" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="">
                    </cfoutput>			
            </form>
        <!--- Birinci Kısım Bitti --->
    <cfelse>
		<cfset xfa.upd = "#request.self#?fuseaction=training_management.emptypopup_upd_question">
        <cfinclude template="../query/get_question.cfm">
        <script type="text/javascript">
            function goster(number)
            {
            /*sayı seçilenin 1 eksiği geliyor*/
            if (number!=0)
                {
                    for (i=0;i<=number;i++)
                    {
                        eleman = eval('answer'+i);
                        eleman.style.display = "";
                    }
                    for (i=number+1;i<=19;i++)
                    {
                        eleman = eval('answer'+i);
                        eleman.style.display = "none";
                    }
                }
            else
                {
                    for (i=0;i<=19;i++)
                    {
                        eleman = eval('answer'+i);
                        eleman.style.display = "none";
                    }
                }
            }
        </script>
        <cfinclude template="../query/get_training_sec_names.cfm">
        <cfform name="upd_question" method="post" action="">
            <input type="Hidden" name="question_id" id="question_id" value="<cfoutput>#attributes.question_id#</cfoutput>">
            <cfif isdefined("attributes.popup")>
                <input type="Hidden" name="popup" id="popup" value="1">
            </cfif>
                <input name="answer_number" id="answer_number" type="hidden">
                <table>
                    <tr>
                        <td class="txtbold"><cf_get_lang_main no='1398.Soru'></td>
                    </tr>
                    <tr>
                        <td><cfoutput>#get_question.question#</cfoutput></td>                 
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
                    </tr>
                    <tr>
                        <td><cfoutput>#get_question.question_info#</cfoutput></td>                 
                    </tr>
                    <cfloop from="0" to="#evaluate(get_question.answer_number-1)#" index="i">
                        <tr id="answer<cfoutput>#i#</cfoutput>">
                            <td>
                                <input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="<cfoutput>#evaluate("get_question.answer"&i+1&"_true")#</cfoutput>">
                                <table>
                                    <tr>
                                        <td class="txtbold"><cf_get_lang_main no='1985.Şık'><cfoutput>#evaluate(i+1)#: #evaluate("get_question.answer"&i+1&"_text")#</cfoutput></td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <cfif len(evaluate("get_question.answer"&i+1&"_photo"))>
                                                <img src="<cfoutput>#file_web_path#training/#evaluate("get_question.answer"&i+1&"_photo")#</cfoutput>" border="0"><br/>
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input type="radio" name="answer<cfoutput>#i#</cfoutput>_true" id="answer<cfoutput>#i#</cfoutput>_true" value="1" <cfif evaluate("get_question.answer"&i+1&"_true") eq 1>checked</cfif> disabled>
                                            <cf_get_lang no='57.Doğru'>
                                            <input type="radio" name="answer<cfoutput>#i#</cfoutput>_true" id="answer<cfoutput>#i#</cfoutput>_true" value="0" <cfif evaluate("get_question.answer"&i+1&"_true") eq 0>checked</cfif> disabled>
                                            <cf_get_lang no='58.Yanlış'>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </cfloop>
                </table>
                <cf_popup_box_footer><input type="button" value="<cf_get_lang_main no='141.Kapat'>" onClick="self.close();" style="width:65px; float:right;"></cf_popup_box_footer>
		</cfform>
		<script type="text/javascript">
            <cfif evaluate(get_question.answer_number) neq 0>
                upd_question.answer_number.value = <cfoutput>#evaluate(get_question.answer_number-1)#</cfoutput>;
            </cfif>
        </script>
    </cfif>
</cf_popup_box>

