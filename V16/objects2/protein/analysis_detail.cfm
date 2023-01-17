<cfset analysisCFC = createObject('component','V16.objects2.protein.data.analysis_data')>
<cfset get_analysis = analysisCFC.GET_ANALYSIS(analysis_id : attributes.analysis_id)>
<cfset get_analysis_questions = analysisCFC.GET_ANALYSIS_QUESTIONS(analysis_id : attributes.analysis_id)>

<cfif isdefined("attributes.is_question_number") and isnumeric(attributes.is_question_number)>
	<cfset question_number = attributes.is_question_number>
<cfelse>
	<cfset question_number = 1>
</cfif>
<cfif isdefined("attributes.is_company_id") and isnumeric(attributes.is_company_id)>
	<cfset is_company_id = attributes.is_company_id>
<cfelse>
	<cfset is_company_id = 1>
</cfif>

<cfset page_url = attributes.param_1>

<cfif isdefined("attributes.param_2") and len(attributes.param_2)>
    <cfset attributes.result_id = attributes.param_2>
    <cfinclude  template="../../../WTO/Print/Preview/analysis_result.cfm">
</cfif>
<cfoutput> 
    <div id="google_translate_element"></div>
    <script type="text/javascript">
        function googleTranslateElementInit() 
        {
            new google.translate.TranslateElement({pageLanguage: 'tr', includedLanguages: 'en,fr,ar,ru,de,es,it,ro',
            layout:google.translate.TranslateElement.InlineLayout.SIMPLE, autoDisplay: false},
            'google_translate_element');
        }
    </script>
    <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>       
    <cfform name="analysis" method="post" novalidate>
        <div class="analysis_item" id="analysis_item">            
            <div class="col-md-12">                             
                <div class="analysis_item_box">
                    <div class="analysis_item_head">
                        <h1>#get_analysis.analysis_head#</h1>
                    </div>
                    <div class="analysis_item_objective">        
                        #get_analysis.analysis_objective#   
                    </div>  
                            
                    <label><cf_get_lang dictionary_id='64665.Anketi Dolduran'> - <cf_get_lang dictionary_id='57570.Name  Last name'>*</label>                
                    <input type="text" class="form-control" name="attendance_name" id="attendance_name" value="" required>  

                    <label><cf_get_lang dictionary_id='55484.E-Mail'>*</label>                
                    <input type="email" class="form-control" name="attendance_mail" id="attendance_mail" value="" required> 

                    <label><cf_get_lang dictionary_id='64666.Çalıştığınız Kurumun Adı'>*</label>
                    <input type="text" class="form-control" name="attendance_company" id="attendance_company" value="">

                    <label><cf_get_lang dictionary_id='35675.Göreviniz'>*</label>
                    <input type="text" class="form-control" name="attendance_job" id="attendance_job" value="">
                    <div class="analysis_item_box_btn d-flex justify-content-end">
                        <a href="javascript://" onclick="switchVisible();"><cf_get_lang dictionary_id='64667.Soruları Görmek İçin Tıklayınız'></a>
                    </div>
                </div>   
            </div>
        </div>   
     
        <input type="hidden" name="analysis_id" id="analysis_id" value="#attributes.analysis_id#">  
        <input type="hidden" name="sum_point" id="sum_point" value="0">
        <input type="hidden" name="is_company_id" id="is_company_id" value="#is_company_id#">
        <div class="analysis_item_questions" id="analysis_item_questions">            
            <div class="col-md-12">
                <div class="analysis_item_box_btn" id="analysis_item_box_btn">
                    <a href="javascript://" onclick="switchVisible();"><cf_get_lang dictionary_id='64668.Geri Dönmek İçin Tıklayınız'></a>
                </div>
                <cfloop query="get_analysis_questions">                                         
                        <div id="question#currentrow#" class="line-content" <cfif currentrow eq 1>style="display:block"<cfelse>style="display:none"</cfif>>
                            <div class="analysis_item_box_question_item">   
                                <div class="analysis_item_box_question_item_head">
                                    #question#
                                </div> 
                                                                                   
                                <cfif answer_number neq 0>
                                    <div class="analysis_item_box_question_item_options required-questions">
                                        <cfset get_question_answers = analysisCFC.GET_QUESTION_ANSWERS(question_id : question_id)>                          
                                        <cfloop query="get_question_answers">  
                                            <cfset temp_answer_point = evaluate('get_question_answers.answer_point')>                                 
                                            <cfswitch expression="#get_analysis_questions.question_type#">
                                                <cfcase value="1">
                                                    <input type="radio" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#" > #answer_text#<br>
                                                </cfcase>
                                                <cfcase value="2">
                                                    <input type="checkbox" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#"> #answer_text#<br>
                                                </cfcase>
                                            </cfswitch> 
                                            <input type="hidden" name="user_answer_#get_analysis_questions.currentrow#_point" id="user_answer_#get_analysis_questions.currentrow#_point" value="#temp_answer_point#">
                                        </cfloop>
                                    </div>
                                <cfelseif get_analysis_questions.answer_number eq 0 or get_analysis_questions.question_type eq 3>
                                    <div class="analysis_item_box_question_item_options">
                                        <input type="hidden" name="open_question" id="open_question" value="1">                            
                                        <textarea name="user_answer_text" class="form-control" id="user_answer_text" cols="45" rows="4" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="En Fazla 1500 Karakter Girebilirsiniz!"></textarea>  
                                    </div>                          
                                </cfif>
                                
                                <div class="analysis_item_box_question_item_info">
                                    <cfif len(question_info)>                            
                                            <cf_get_lang dictionary_id='57556.Bilgi'>: #question_info#                          
                                    </cfif>
                                </div>
                            </div>   
                        </div>                                     
                </cfloop>   
                <ul class="analysis_item_box_numbers" id="pagin"></ul>  
                <div class="display-flex">                   
                    <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/analysis_data:ADD_RESULT" add_function="control()" next_page="#site_language_path#/#page_url#/">
                     <div class="float-right pr-2">
                        <a href="javascript://" class="btn btn-primary btn-1cv3sd"  id="nextPage"><cf_get_lang dictionary_id='58843.İleri'></a>
                    </div>
                </div>
            </div>            
        </div>            
    </cfform>
</cfoutput>

<script>
    function control(){
        var x = 0, y=0;
        var z = $('.required-questions').length;
        $('input[type=radio]:checked,input[type=checkbox]:checked').each(function( index ) {
            x = x + parseInt($( this ).val()) ;
            y++;
        });
        if(y<z){
            alert('<cf_get_lang dictionary_id='64669.Lütfen soruların hepsini cevaplayın'>!');
            return false;
        }
        $('#sum_point').val(x);  
    }	

    //Soruları Göster
    function switchVisible() {
            if($('#attendance_name').val() == ""|| $('#attendance_mail').val() == ""||$('#attendance_job').val() == ""||$('#attendance_job').val() == ""){
                alert("<cf_get_lang dictionary_id='64670.Lütfen tüm alanları doldurunuz'>!");
                return false;
            }                
            if (document.getElementById('analysis_item')) {

                if (document.getElementById('analysis_item').style.display == 'none') {
                    document.getElementById('analysis_item').style.display = 'block';
                    document.getElementById('analysis_item_questions').style.display = 'none';
                }
                else {
                    document.getElementById('analysis_item').style.display = 'none';
                    document.getElementById('analysis_item_questions').style.display = 'block';
                }
            }
        document.location.hash = "";
        document.location.hash = "working_div_main";
    }      
    
    //Pagination
    pageSize = <cfoutput>#question_number#</cfoutput>;
    incremSlide = 5;
    startPage = 0;
    numberPage = 0;

    var pageCount =  $(".line-content").length / pageSize;
    var totalSlidepPage = Math.floor(pageCount / incremSlide);
        
    for(var i = 0 ; i<pageCount;i++){
        $("#pagin").append('<li><a class="notranslate">'+(i+1)+'</a></li> ');
        if(i>pageSize+3){
        $("#pagin li").eq(i).hide();
        }
    }

    var prev = $("<li/>").addClass("prev").html("<").click(function(){
    startPage-=5;
    incremSlide-=5;
    numberPage--;
    slide();
    });

    prev.hide();

    var next = $("<li/>").addClass("next").html(">").click(function(){
    startPage+=5;
    incremSlide+=5;
    numberPage++;
    slide();
    });

    $("#pagin").prepend(prev).append(next);

    $("#pagin li").first().find("a").addClass("current");

    slide = function(sens){
    $("#pagin li").hide();
    
    for(t=startPage;t<incremSlide;t++){
        $("#pagin li").eq(t+1).show();
    }
    if(startPage == 0){
        next.show();
        prev.hide();
    }else if(numberPage == totalSlidepPage ){
        next.hide();
        prev.show();
    }else{
        next.show();
        prev.show();
    }
    
        
    }

    showPage = function(page) {
        $(".line-content").hide();
        $(".line-content").each(function(n) {
            if (n >= pageSize * (page - 1) && n < pageSize * page)
                $(this).show();
        });        
    }
        
    showPage(1);
    $("#pagin li a").eq(0).addClass("current");

    $("#pagin li a").click(function() {
        $("#pagin li a").removeClass("current");
        $(this).addClass("current");
        showPage(parseInt($(this).text()));
        document.location.hash = "";
        document.location.hash = "working_div_main";
        var x = parseInt($(".current").text());
        var pageLength = $('#pagin li').length - $('#pagin li.next').length - $('#pagin li.prev').length;
        if(x == pageLength){ $("#nextPage").addClass("prevPage");$("#nextPage").text("<cf_get_lang dictionary_id='57432.Geri'>");}
        else{ $("#nextPage").removeClass("prevPage"); $("#nextPage").text("<cf_get_lang dictionary_id='58843.İleri'>");}
    });
    $("#nextPage").click(function() {
        var x = parseInt($(".current").text());
        var pageLength = $('#pagin li').length - $('#pagin li.next').length - $('#pagin li.prev').length;
        if(x != pageLength){
            showPage( x+1);
            $('#pagin li a').eq(x).addClass("current");
            $('#pagin li a').eq(x-1).removeClass("current");            
            $(this).text("<cf_get_lang dictionary_id='58843.İleri'>");
            $(this).removeClass("prevPage");            
            if(parseInt($(".current").text()) == pageLength){
                $(this).addClass("prevPage");
                $(this).text("<cf_get_lang dictionary_id='57432.Geri'>");     
            }
        }
        else{
            $(this).text("<cf_get_lang dictionary_id='58843.İleri'>"); 
            $(this).removeClass("prevPage");
            showPage( x-1);
            $('#pagin li a').eq(x-2).addClass("current");
            $('#pagin li a').eq(x-1).removeClass("current");            
        }
        document.location.hash = "";
        document.location.hash = "working_div_main";
    });
       
</script>