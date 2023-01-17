<!---
File: WEX\import\import_country.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 16.09.2021
Controller: -
Description: İl ve ilçelerin dataservis import ekranı

--->
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset GET_COUNTRY = company_cmp.GET_COUNTRY()>
<!--- <cfset GET_CITY = company_cmp.GET_CITY()> --->
<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
	<cf_box title="#getLang('','İl ve İlçe Data Service','63821')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_city" method="post">
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='63422.Data Services'>*</label>
                        <div class="col col-6">
                            <select name="dataservice_type" id="dataservice_type" onchange="show_city(this.value)">
                                <option value="1"><cf_get_lang dictionary_id='59129.İller'></option>
                                <option value="2"><cf_get_lang dictionary_id='59130.İlçeler'></option>
                            </select>
                        </div>
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='58219.Ülke'>*</label>
                        <div class="col col-6">
                            <select name="country_id" id="country_id" tabindex="25" onchange="LoadCity(this.value,'city_id','county_id',0)"> 
								<cfoutput query="get_country">
								    <option value="#country_id#" <cfif is_default eq 1> selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>
                        </div>
					</div>
					<div class="form-group" id ="city_div" style="display:none">
						<label class="col col-6"><cf_get_lang dictionary_id='58608.İl'></label>
                        <div class="col col-6">
						    <select name="city_id" id="city_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            </select>
                        </div>
					</div>
                    <div class="form-group" style="display:none">
                        <select name="county_id" id="county_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        </select>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function="dataservice()">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script>

    var country_ = $("#country_id").val(); 
    LoadCity(country_,'city_id','county_id',0);

    function show_city(this_value){
        if(this_value == 1)
            $("#city_div").hide();
        else
            $("#city_div").show();
    }
    
    function dataservice() {
        var country_ = $("#country_id").val(); 
        get_country_code = wrk_safe_query("mr_get_phone_no","dsn",0,country_);
        if(get_country_code.COUNTRY_CODE == undefined)
        {
            alert("<cf_get_lang dictionary_id='63822.Seçilen Ülkenin Ülke Kodunu Tanımlayınız!'>");
            return false;
        }else{
            if($("#dataservice_type").val() == 1)
            {
                $("#working_div_main").hide();
                $.ajax({
                    url: "V16/settings/cfc/dataservice_control.cfc?method=runWexService",
                    method: "post",
                    dataType: "json",
                    data: {
                        extra_param: get_country_code.COUNTRY_CODE[0]+","+country_,
                        functionName:"importCity", 
                        start_date : "<cfoutput>#now()#</cfoutput>", 
                        finish_date : "<cfoutput>#now()#</cfoutput>"
                    },
                    success: function(e)
                    {
                        $("#working_div_main").hide();
                        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
                        Swal.fire(
                        '<cf_get_lang dictionary_id='61210.İşlem Başarılı'>!',
                        '<cf_get_lang dictionary_id='54060.İmport işlemi tamamlandı'>',
                        'success'
                        );
                        return false;

                    },error: function (objResponse) {
                        console.log(objResponse);
                        return false;
                    }
                });
            }else{
                var city_id = $("#city_id").val(); 
                get_city_plate = wrk_safe_query("hr_get_city","dsn",0,city_id);
                goster(working_div_main);
                if(get_city_plate.PLATE_CODE != undefined){
                    
                    $.ajax({
                        url: "V16/settings/cfc/dataservice_control.cfc?method=runWexService",
                        method: "post",
                        dataType: "json",
                        data: {
                            extra_param: get_country_code.COUNTRY_CODE[0]+","+country_+","+city_id+","+get_city_plate.PLATE_CODE,
                            functionName:"importCounty", 
                            start_date : "<cfoutput>#now()#</cfoutput>", 
                            finish_date : "<cfoutput>#now()#</cfoutput>"
                        },
                        success: function(e)
                        {
                            $("#working_div_main").hide();
                            closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
                            Swal.fire(
                            '<cf_get_lang dictionary_id='61210.İşlem Başarılı'>!',
                            '<cf_get_lang dictionary_id='54060.İmport işlemi tamamlandı'>',
                            'success'
                            );
                            return false;

                        },error: function (objResponse) {
                            console.log(objResponse);
                            return false;
                        }
                    });
                }
                else
                {
                    Swal.fire({
                    icon: 'error',
                    title: 'Oops...',
                    text: '<cf_get_lang dictionary_id='63825.Seçilen İlin Plaka Kodunu Tanımlamalısınız!'>',
                    footer: ''
                    });
                }
            }
                
        }
        return false;
    }
</script>