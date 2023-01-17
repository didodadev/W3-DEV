<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset GET_COUNTRY = company_cmp.GET_COUNTRY()>
<cfform  name="careerForm" id="careerForm" enctype="multipart/form-data" class="px-4">
    <div class="row">
        <div class="col-md-12">	
            <div class="form-group row">
                <label class="col-sm-3 col-form-label"><cf_get_lang dictionary_id='63785.Adınız'> *</label>
                <div class="col-sm-9">
                    <input class="form-control" type="text" required name="careerName" id="careerName">
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-3 col-form-label"><cf_get_lang dictionary_id='35630.Soyadınız'> *</label>
                <div class="col-sm-9 ">
                    <input class="form-control" type="text" required name="careerSurname" id="careerSurname">
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-3 col-form-label"><cf_get_lang dictionary_id='64178.İkamet Ettiğiniz Ülke'> *</label>
                <div class="col-sm-9 ">
                    <select class="form-control" name="country_id" id="country_id" onchange="LoadCity(this.value,'city_id','county_id',0)"> 
                        <cfoutput query="get_country">
                            <option value="#country_id#" <cfif is_default eq 1> selected</cfif>>#country_name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group row" >
                <label class="col-sm-3 col-form-label"><cf_get_lang dictionary_id='64175.İkamet Ettiğiniz İl'> *</label>
                <div class="col-sm-9 ">
                    <select name="city_id" class="form-control" id="city_id"  onchange="LoadCounty(this.value,'county_id')">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    </select>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-3 col-form-label"><cf_get_lang dictionary_id='64179.İkamet Ettiğiniz İlçe'> *</label>
                <div class="col-sm-9 ">
                    <select name="county_id" class="form-control" id="county_id">
                        <option value="89"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    </select>
                </div>
            </div>

            <div class="form-group row">
                <label  class="col-sm-3 col-form-label"><cf_get_lang dictionary_id='58813.Cep Telefonu'> *</label>
                <div class="col-sm-9 row pr-0">
                    <div class="col-5 ">
                        <input class="form-control" type="tel" maxlength="3" placeholder="(5**)" name="careerPhoneCode" required id="careerPhoneCode">
                    </div>
                    <div class="col-7 p-0">
                        <input class="form-control" type="tel" maxlength="7" placeholder="*** ** **" name="careerPhone" required id="careerPhone">
                    </div>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-3 col-form-label"><cf_get_lang dictionary_id='55484.E-Mail'> *</label>
                <div class="col-sm-9">
                    <input class="form-control" type="mail" required name="careerMail">
                </div>
            </div>                      
            <div class="form-group row">
                <label class="col-sm-3 col-form-label"><cf_get_lang dictionary_id='64176.CV Yükle'> *</label>
                <div class="col-sm-9">
                    <input class="form-control" type="file" name="careerCV" id="careerCV" accept=".pdf" style="padding:3px 0px 0px 8px;">
                    <span><cf_get_lang dictionary_id='64183.Yalnızca pdf formatında dosya yükleyebilirsiniz'>!</span>
                </div>
            </div>
            <div class="form-group row">
                <div class="col 12">
                    <span class="text-danger" id="careerFormMessage"></span>   
                    <button type="button" id ="careereventSend" class="btn btn-primary float-right"><cf_get_lang dictionary_id='64585.Gönder'></button>
                </div>
            </div>
        </div>
        
    </div>
</cfform>
<script>
var country_ = $("#country_id").val(); 
    LoadCity(country_,'city_id','county_id',0);
</script>

<script>

	$(function() {

        var Sevent = 9362;
        var inputType = "";
        var pageCounter = false;

        function formControl(formName){

            var answer = true;

            $("form[name = "+formName+"] input").each(function(){
                var inputType = $(this).attr("type");
                if(inputType == "text" || inputType == "mail" || inputType == "tel"){ 
                    if($.trim($(this).val()) == '') answer = false;
                }else if(inputType == "file"){
                    var file = $(this).val().split('\\').pop();
                    if(!file) answer = false;
                }
            });

            $("form[name = "+formName+"] select").each(function(){
                if($.trim($(this).val()) == '') answer = false;
            });

            careerCV = document.getElementById('careerCV');
            if(careerCV.files.length > 0) cvSize = careerCV.files[0].size;
            if(cvSize > 2097152){
                $("#careerFormMessage").html("<cf_get_lang dictionary_id='64182.Özgeçmişinizin Boyutu Max 2 Mb olmalıdır'>");
                    answer = false;
            }
            return answer;
        }

         $("button#careereventSend").on("click",function() {

            $("form#careerForm").submit();

         });

        $("form#careerForm").submit(function() {
            var formElement = $("form[name = careerForm]");
            if(formControl("careerForm")){

				var form = formElement[0];
				var url = "/cfc/workcube_support.cfc?method=CAREER_REQUEST";
				
				var data = new FormData(form);
                data.append("event",Sevent);
                data.append("careerCV",$("#careerCV")[0].files[0]);

                AjaxControlPostDataJson(url,data,function(response) { 
                    if(response.STATUS){
                        alert(response.SUCCESS_MESSAGE);
                        location.reload();
                    }
                });

			}else{
                $("#careerFormMessage").html("<cf_get_lang dictionary_id='64181.Lütfen * ile işaretli olan alanları boş bırakmayınız!'>");
            }
			return false;
            
        });

       
	});
</script>