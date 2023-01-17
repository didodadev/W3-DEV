<cfsavecontent  variable="title"><cf_get_lang dictionary_id='65257.Watalogy hizmetleri'></cfsavecontent>
<cfset getComponent = createObject('component','V16.objects.cfc.upgrade_notes')>
<cfset get_release_version = getComponent.GET_RELEASE_VERSION()>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset get_our_cmp = company_cmp.GET_OUR_COMPANY_NAME(comp_id : session.ep.company_id)>
<cfparam  name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#title#" popup_box="1">
        <div class="ui-info-text">
            <p class="bold"><cf_get_lang dictionary_id='29502.Subscription No'>:<cfoutput>#get_release_version.workcube_id#</cfoutput></p>
        </div>
        <div id="form-elements" class="form-elements">
            <p style="color:#23c966">
                <cf_get_lang dictionary_id='65259.Watalogy Pazaryeri entegrasyon hizmetlerini başlatmak için aşağıdaki formu doldurun.'><br>
                <cf_get_lang dictionary_id='65260.Workcube Watalogy onay kodunuz otomatik olarak şirket akış parametrelerinize işlenecektir.'>
            </p>
            <cfform name="add_service" novalidate>
                <cfinput type="hidden" name="subscription_no" id="subscription_no" value="#get_release_version.workcube_id#">
                <cfinput type="hidden" name="worknet_id" id="worknet_id" value="#attributes.worknet_id#">
                <cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
                <cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group margin-top-10">
                        <label class="col col-2 col-md-2 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57571.Title'></label>
                        <div class="col col-10 col-md-10 col-sm-10 col-xs-12"><cfinput type="text" name="title" id="title" value="#session.ep.company#" readonly></div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group margin-top-10">
                        <label class="col col-2 col-md-2 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58762.Tax Office'></label>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfinput type="text" name="tax_office" id="tax_office" value="#get_our_cmp.tax_office#" readonly></div>
                        <label class="col col-2 col-md-2 col-sm-3 col-xs-12 text-center"><cf_get_lang dictionary_id='57752.TIN'></label>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfinput type="text" name="tax_no" id="tax_no" value="#get_our_cmp.tax_no#" readonly></div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group margin-top-10">
                        <label class="col col-2 col-md-2 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='30325.Authorized Name'>*</label>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12"> <input type="text" name="name" id="name" required></div>
                        <label class="col col-2 col-md-2 col-sm-3 col-xs-12 text-center"><cf_get_lang dictionary_id='58726.Last Name'>*</label>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="text" name="surname" id="surname" required></div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group margin-top-10">
                        <label class="col col-2 col-md-2 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='32494.E-mail'>*</label>
                        <div class="col col-10 col-md-10 col-sm-10 col-xs-12"><cfinput type="text" name="mail" id="mail"></div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group margin-top-10">
                        <label class="col col-2 col-md-2 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='61819.Land Phone'></label>
                        <div class="col col-2 col-md-2 col-sm-3 col-xs-12"><input type="text" name="phone_code" id="phone_code" required></div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="phone" id="phone" required></div>
    
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group margin-top-10">
                        <label class="col col-2 col-md-2 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='44600.Mobile No.'>*</label>
                        <div class="col col-2 col-md-2 col-sm-3 col-xs-12"><input type="text" name="mobile_code" id="mobile_code" required></div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="mobile_phone" id="mobile_phone" required></div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group margin-top-10 flex-end">
                        <label class="col col-10 col-md-10 col-sm-10 col-xs-12 pull-right">
                            <cf_get_lang dictionary_id='59918.I accept the terms of the contract.'>(<cf_get_lang dictionary_id='30366.Watalogy'>)
                            <input type="checkbox" name="is_accepted" id="is_accepted" value="1">
                        </label>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group margin-top-10 flex-end">
                        <a class="col col-10 col-md-10 col-sm-10 col-xs-12 pull-right" href="javascript://" onclick="openContract()" style="color:#ff0000">>><cf_get_lang dictionary_id='61815.Click to read the contract'></a>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div>
                        <cf_workcube_buttons is_cancel="1" class="pull-right" add_function="openBlog()" cancel_function="closeBoxDraggable('#attributes.modal_id#')" insert_info="#getLang('','Sevisi aç','65316')#" data_action ="V16/member/cfc/member_company:start_watalogy" next_page="#request.self#?fuseaction=watalogy.marketplace&event=det&wid=#attributes.WORKNET_ID#&wrkid=">
                    </div>
                </cf_box_footer>
            </cfform>
        </div>
        <div id="start-services-blog" style="color:#23c966" class="hide watalogy-services-blog">
            <p class="text-center"><cf_get_lang dictionary_id='65322.Watalogy Servisleri açılıyor'>.</p>
            <p class="text-center"><cf_get_lang dictionary_id='64471.Lütfen Bekleyiniz'>!</p>
        </div>
        <div id="open-services-blog" class="hide watalogy-services-blog">
            <p class="text-center"><cf_get_lang dictionary_id='63801.Watalogy Code'>: <span id="comp-watalogy-code"></span>. </p>
            <p class="text-center"><cf_get_lang dictionary_id='65320.Kodunuz şirket akış parametrelerine eklendi'>. </p>
            <p class="text-center"><cf_get_lang dictionary_id='65321.Pazaryeri entegrasyonlarına başlayabilirsiniz'>.</p>
            <div class="ui-form-list-btn" style="justify-content:center;border:0">
                <div>
                    <a href="<cfoutput>#request.self#?fuseaction=watalogy.marketplace&event=det&wid=#attributes.WORKNET_ID#&wrkid=</cfoutput>" id="start-btn" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='63838.Başla'></a>
                </div>                
            </div>
        </div>        
    </cf_box>
</div>
<script>
    function openBlog(){
        if (($('input#mobile_phone').val().length<1 || $('#mobile_code').val().length<1 || $('#mail').val().length<1 || $('#name').val().length<1 || $('#surname').val().length<1 )) {
		    alert("<cf_get_lang dictionary_id='29781.Lütfen zorunlu alanları doldurunuz'>");
			return false;
	    }
        if($('#is_accepted').prop("checked") == false){
            alert("<cf_get_lang dictionary_id='30594.Missing field'>:<cf_get_lang dictionary_id='61698.I accept the contract.'>!");
            return false;
        }
        $("#start-services-blog").removeClass("hide");
		$("#open-services-blog,#form-elements").addClass("hide");
    }
    function openService(code,id) {
        setTimeout(function(){
            $("#open-services-blog").removeClass("hide");
		    $("#start-services-blog,form-elements").addClass("hide");
            $('#comp-watalogy-code').text(code);
            $('#start-btn').attr('href', '<cfoutput>#request.self#?fuseaction=watalogy.marketplace&event=det&wid=#attributes.WORKNET_ID#&wrkid=</cfoutput>'+id);
            } ,4000
        );
    }
</script>