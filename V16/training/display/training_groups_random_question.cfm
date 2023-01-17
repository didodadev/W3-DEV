<cfset tg_cfc = createObject('component','V16.training_management.cfc.training_groups')>
<cfsavecontent variable="button"><cf_get_lang dictionary_id='55829.Kayıtlı Soru Bulunamadı!'></cfsavecontent>
<div class="protein-table training_items">
    <table style="table-layout: fixed;">
        <tbody>
        <div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
            <cf_box>
                <div class="ui-cfmodal-close">×</div>
                <ul class="required_list"></ul>
            </cf_box>
        </div>
            <cfset get_training_group_subjects = tg_cfc.get_training_group_subjects(train_group_id: attributes.train_group_id)>
            <cfif get_training_group_subjects.recordcount>
                <cfloop query="get_training_group_subjects">
                    <cfset get_training_subject_quizs = tg_cfc.get_training_subject_quizs(train_subject_id: get_training_group_subjects.TRAINING_GROUP_SUBJECTS_ID)>
                    <cfif get_training_subject_quizs.recordcount>
                        <cfoutput>
                            <cfloop query="get_training_subject_quizs">
                                <tr>
                                    <td style="word-wrap: break-word;white-space: normal;">
                                        <div class="input-group">
                                            <div class="bold">#question#</div>
                                            <cfset cevap = "">
                                            <cfif ANSWER_NUMBER NEQ 0>
                                                <cfloop from="1" to="#ANSWER_NUMBER#" index="i">
                                                    <cfif evaluate("answer#i#_true") eq 1>
                                                        <cfset cevap = "user_answer_"&i>
                                                    </cfif>
                                                    <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                                                            <input type="radio" name="user_answer" id="user_answer_#i#">
                                                            #evaluate('answer#i#_text')#
                                                        <div class="form-group">
                                                            <cfif len(evaluate("answer"&i&"_photo"))>
                                                                <img src="#file_web_path#training/#evaluate("answer"&i&"_photo")#" border="0">
                                                            </cfif>
                                                        </div>
                                                    </cfif>
                                                </cfloop>
                                                <cfsavecontent  variable="button">
                                                    <cf_workcube_buttons add_function="kontrol(#cevap#)" insert_info="#getLang('','Cevapla','29541')#">
                                                </cfsavecontent>
                                            <cfelse>
                                                <cfsavecontent  variable="button">
                                                    <cf_workcube_buttons add_function="degistir()" insert_info="#getLang('','Değiştir',35651)#">
                                                </cfsavecontent>
                                                <div class="form-group">
                                                    <cf_get_lang dictionary_id='30296.Açık Uçlu Soru'>
                                                </div>
                                            </cfif>
                                            <cfif len(question_info)>
                                                <div class="form-group">
                                                    <cf_get_lang dictionary_id='57556.Bilgi'> : #question_info#
                                                </div>
                                            </cfif>
                                        </div>
                                    </td>
                                </tr>
                            </cfloop>
                        </cfoutput>
                    </cfif>
                </cfloop>
            </cfif>
        </tbody>
    </table>
</div>
<div class="training_items_bottom_btn d-flex flex-end">
    <cfoutput>#button#</cfoutput>
</div>
<script>
   $('.ui-cfmodal-close').click(function(){
        $('.ui-cfmodal__alert').fadeOut();
        $('.ui-cfmodal__alert .required_list').empty();
    });
    function kontrol(cevap){
        var selected = document.querySelector('input[name="user_answer"]:checked');

        if(selected == null){
            $('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i><cf_get_lang dictionary_id='58810.Soru'><cf_get_lang dictionary_id='63101.Cevaplanmamış'></li>');
            $('.ui-cfmodal__alert').fadeIn();
            return false;
        }
        if (cevap.id == selected.id){
            $('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="icon-check" style="background-color:#0f0;"></i><cf_get_lang dictionary_id='46258.Doğru'></li>');
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.list_training_groups&event=randomQuestion&train_group_id=#attributes.train_group_id#</cfoutput>', 'random_question');
            $('.ui-cfmodal__alert').fadeIn();
            return false;
        }
        else{
            $('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="icon-times"></i><cf_get_lang dictionary_id='46058.Yanlış'></li>');
            $('.ui-cfmodal__alert').fadeIn();
            return false;
        }
        return false;
    }

    function degistir(){
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.list_training_groups&event=randomQuestion&train_group_id=#attributes.train_group_id#</cfoutput>', 'random_question');
    }
</script>