<cfset xfa.del = "ehesap.emptypopup_del_insurance_ratio">
<cfset xfa.upd = "ehesap.emptypopup_upd_insurance_ratio">
<cfparam name="attributes.modal_id" default="">
<cfset attributes.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#>
<cfinclude template="../query/get_insurance_ratio.cfm">
<cfsavecontent variable="images"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_add_insurance_ratio" title="<cf_get_lang dictionary_id='53057.Sigorta Prim Oranı Ekle'>"><i class="fa fa-plus"></i></a></cfsavecontent>
<cf_box title="#getLang('','Sigorta Primi Oranı',62932)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_upd_ratio" method="post" action="#request.self#?fuseaction=#xfa.upd#">
        <input type="hidden" name="ins_rat_id" id="ins_rat_id" value="<cfoutput>#attributes.ins_rat_id#</cfoutput>">
        <input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delRatio">
        <input type="hidden" name="is_delete" id="is_delete" value="0">
        <cf_box_elements>
            <div class="col col-8 col xs-12" type="column" sort="true" index="1">
                <div class="form-group" id="item-startdate">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" value="#dateformat(get_insurance_ratio.startdate,dateformat_style)#" name="startdate" validate="#validate_style#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-finishdate">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" value="#dateformat(get_insurance_ratio.finishdate,dateformat_style)#" name="finishdate" validate="#validate_style#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-12 col-xs-12" type="column" sort="true" index="2">
                <div class="form-group" id="header">
                    <label class="col col-4 col-xs-12"></label>
                    <label class="col col-2 bold text-center"><cf_get_lang dictionary_id='53187.İşçi Payı'></label>
                    <label class="col col-2 bold text-center"><cf_get_lang dictionary_id='53188.İşveren Payı'></label>
                    <label class="col col-4 bold"></label>
                </div>
                <div class="form-group" id="item-mom_insurance_premium_worker">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53189.Analık Sigorta Pirimi'></label>
                    <div class="col col-2">
                        <cfinput name="mom_insurance_premium_worker" value="#get_insurance_ratio.mom_insurance_premium_worker#" type="text" validate="float">
                    </div>
                    <div class="col col-2">
                        <cfinput name="mom_insurance_premium_boss" value="#get_insurance_ratio.mom_insurance_premium_boss#" type="text" validate="float">
                    </div>
                    <label class="col col-4 font-red">(<cf_get_lang dictionary_id='53130.5510 Sayılı Kanun Kapsamında Kaldırıldı'>)</label>
                </div>
                <div class="form-group" id="item-PAT_INS_PREMIUM_WORKER">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59593.Hastalık Sigorta Primi'></label>
                    <div class="col col-2">
                        <cfinput name="PAT_INS_PREMIUM_WORKER" value="#get_insurance_ratio.PAT_INS_PREMIUM_WORKER#" type="text" validate="float">
                    </div>
                    <div class="col col-2">
                        <cfinput name="PAT_INS_PREMIUM_BOSS" value="#get_insurance_ratio.PAT_INS_PREMIUM_BOSS#" type="text" validate="float">
                    </div>
                    <label class="col col-4 font-red">(<cf_get_lang dictionary_id='53137.5510 Sayılı Kanun ile Genel Sağlık Sigortası'>)</label>
                </div>
                <div class="form-group" id="item-PAT_INS_PREMIUM_WORKER_2">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59593.Hastalık Sigorta Pirimi'></label>
                    <div class="col col-2">
                        <cfinput name="PAT_INS_PREMIUM_WORKER_2" value="#get_insurance_ratio.PAT_INS_PREMIUM_WORKER_2#" type="text" validate="float">
                    </div>
                    <div class="col col-2">
                        <cfinput name="PAT_INS_PREMIUM_BOSS_2" value="#get_insurance_ratio.PAT_INS_PREMIUM_BOSS_2#" type="text" validate="float">
                    </div>
                    <label class="col col-4 font-red">(<cf_get_lang dictionary_id='38993.SGK Statüsü'> <cf_get_lang dictionary_id='53192.Aday çırak ve öğrenciler için'>)</label>
                </div>
                <div class="form-group" id="item-death_insurance_premium_worker">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53194.Malülük, Yaşlılık, Ölüm Sigorta Pirimi'></label>
                    <div class="col col-2">
                        <cfinput name="death_insurance_premium_worker" value="#get_insurance_ratio.death_insurance_premium_worker#" type="text" validate="float">
                    </div>
                    <div class="col col-2">
                        <cfinput name="death_insurance_premium_boss" value="#get_insurance_ratio.death_insurance_premium_boss#" type="text" validate="float">
                    </div>
                    <label class="col col-4 font-red">&nbsp;</label>
                </div>
                  <!--- Muzaffer bas: ücret kuralları vergi dilimleri için yapıldı--->
                <div class="form-group" id="item-death_insurance_premium_worker_maden">
					<label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='53194.Malülük, Yaşlılık, Ölüm Sigorta Pirimi'></label>
					<div class="col col-2 ">
						<cfinput name="death_insurance_premium_worker_maden" type="text" validate="float" value="#get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER_MADEN#">
					</div>
					<div class="col col-2 ">
						<cfinput name="death_insurance_premium_boss_maden" type="text" validate="float" value="#get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS_MADEN#">
					</div>
					<label class="col col-4  font-red">(Maden Yeraltı ve Yerüstü Grupları için)</label>
				</div>
                 <!--- Muzaffer bit: ücret kuralları vergi dilimleri için yapıldı--->
                <div class="form-group" id="item-death_insurance_worker">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53196.İşsizlik Sigortası'></label>
                    <div class="col col-2">
                        <cfinput name="death_insurance_worker" value="#get_insurance_ratio.death_insurance_worker#" type="text" validate="float">
                    </div>
                    <div class="col col-2">
                        <cfinput name="death_insurance_boss" value="#get_insurance_ratio.death_insurance_boss#" type="text" validate="float">
                    </div>
                    <label class="col col-4 font-red">&nbsp;</label>
                </div>
                <div class="form-group" id="item-SOC_SEC_INSURANCE_WORKER">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53198.Sosyal Güvenlik Destekleme Pirimi'></label>
                    <div class="col col-2">
                        <cfinput name="SOC_SEC_INSURANCE_WORKER" value="#get_insurance_ratio.SOC_SEC_INSURANCE_WORKER#" type="text" validate="float">
                    </div>
                    <div class="col col-2">
                        <cfinput name="SOC_SEC_INSURANCE_BOSS" value="#get_insurance_ratio.SOC_SEC_INSURANCE_BOSS#" type="text" validate="float">
                    </div>
                    <label class="col col-4 font-red">&nbsp;</label>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-9 col-xs-12">
                <cf_record_info query_name="get_insurance_ratio">
            </div>
            <div class="col col-3 col-xs-12">
                <cf_workcube_buttons is_upd='1' add_function='kontrol()' del_function='del()' delete_alert='#getLang('','Kayıtlı Sigorta Prim Oranlarını Siliyorsunuz Emin misiniz',54015)#'>
            </div>
        </cf_box_footer>
        <div id="show_user_message_cont"></div>
    </cfform>
<script type="text/javascript">
    function del(){
        document.form_upd_ratio.is_delete.value=1;
        AjaxFormSubmit('form_upd_ratio','show_user_message_cont',1,'Siliniyor!','Silindi!');
        <cfif isdefined("attributes.draggable")>
            loadPopupBox('form_upd_ratio' , '<cfoutput>#attributes.modal_id#</cfoutput>');
        </cfif>
    }
    function kontrol()
    {
        if(!$("#startdate").val().length)
        {
            alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='57738.Başlama Tarihi Girmelisiniz'> !</cfoutput>"})    
            return false;
        }
        if(!$("#finishdate").val().length)
        {
            alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'> !</cfoutput>"})    
            return false;
        }
        if(!$("#mom_insurance_premium_worker").val().length || !$("#mom_insurance_premium_boss").val().length )
        {
            alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53190.Analık Sigorta Pirimi girmelisiniz'> !</cfoutput>"})    
            return false;
        }
        if(!$("#PAT_INS_PREMIUM_WORKER").val().length || !$("#PAT_INS_PREMIUM_BOSS").val().length )
        {
            alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53193.Hastalık Sigorta Pirimi girmelisiniz'> !</cfoutput>"})    
            return false;
        }
        if(!$("#PAT_INS_PREMIUM_WORKER_2").val().length || !$("#PAT_INS_PREMIUM_BOSS_2").val().length )
        {
            alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53193.Hastalık Sigorta Pirimi girmelisiniz'> !</cfoutput>"})    
            return false;
        }
        if(!$("#death_insurance_premium_worker").val().length || !$("#death_insurance_premium_boss").val().length )
        {
            alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53195.Malülük, Yaşlılık, Ölüm Sigorta Primi girmelisiniz'> !</cfoutput>"})    
            return false;
        }
        if(!$("#death_insurance_worker").val().length || !$("#death_insurance_boss").val().length )
        {
            alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53197.İşsizlik Sigortası girmelisiniz'> !</cfoutput>"})    
            return false;
        }
        if(!$("#SOC_SEC_INSURANCE_WORKER").val().length || !$("#SOC_SEC_INSURANCE_BOSS").val().length )
        {
            alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53185.Sosyal Güvenlik Destekleme Pirimi girmelisiniz'> !</cfoutput>"})    
            return false;
        }	
        /* return true; */
        <cfif isdefined("attributes.draggable")>
            loadPopupBox('form_upd_ratio' , '<cfoutput>#attributes.modal_id#</cfoutput>');
        </cfif>
    }
</script>