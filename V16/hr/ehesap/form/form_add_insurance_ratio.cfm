<cfset xfa.add = "ehesap.emptypopup_add_insurance_ratio">
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53186.Sigorta Primi Oranı Ekle"></cfsavecontent>
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_add_ratio" method="post" action="#request.self#?fuseaction=#xfa.add#">
		<cf_box_elements>
			<div class="col col-8 col xs-12" type="column" sort="true" index="1">
				<div class="form-group" id="item-startdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="startdate" validate="#validate_style#">
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-finishdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="finishdate" validate="#validate_style#">
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-12 col-xs-12" type="column" sort="true" index="2">
				<div class="form-group" id="header">
					<label class="hide"></label>
					<label class="col col-4 col-xs-12"></label>
					<label class="col col-2 bold text-center"><cf_get_lang dictionary_id='53187.İşçi Payı'></label>
					<label class="col col-2 bold text-center"><cf_get_lang dictionary_id='53188.İşveren Payı'></label>
					<label class="col col-4 bold"></label>
				</div>
				<div class="form-group" id="item-mom_insurance_premium_worker">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53189.Analık Sigorta Pirimi'></label>
					<div class="col col-2">
						<cfinput name="mom_insurance_premium_worker" type="text" validate="float">
					</div>
					<div class="col col-2">
						<cfinput name="mom_insurance_premium_boss" type="text" validate="float"> 
					</div>
					<label class="col col-4 font-red">(<cf_get_lang dictionary_id='53130.5510 Sayılı Kanun Kapsamında Kaldırıldı'>)</label>
				</div>
				<div class="form-group" id="item-PAT_INS_PREMIUM_WORKER">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59593.Hastalık Sigorta Primi'></label>
					<div class="col col-2">
						<cfinput name="PAT_INS_PREMIUM_WORKER" type="text" validate="float">
					</div>
					<div class="col col-2 ">
						<cfinput name="PAT_INS_PREMIUM_BOSS" type="text" validate="float">
					</div>
					<label class="col col-4  font-red">(<cf_get_lang dictionary_id='53137.5510 Sayılı Kanun ile Genel Sağlık Sigortası'>)</label>
				</div>
				<div class="form-group" id="item-PAT_INS_PREMIUM_WORKER_2">
					<label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='59593.Hastalık Sigorta Primi'></label>
					<div class="col col-2 ">
						<cfinput name="PAT_INS_PREMIUM_WORKER_2" type="text" validate="float">
					</div>
					<div class="col col-2 ">
						<cfinput name="PAT_INS_PREMIUM_BOSS_2" type="text" validate="float">
					</div>
					<label class="col col-4  font-red">(<cf_get_lang dictionary_id='38993.SGK Statüsü'> <cf_get_lang dictionary_id='53192.Aday çırak ve öğrenciler için'>)</label>
				</div>
				<div class="form-group" id="item-death_insurance_premium_worker">
					<label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='53194.Malülük, Yaşlılık, Ölüm Sigorta Pirimi'></label>
					<div class="col col-2 ">
						<cfinput name="death_insurance_premium_worker" type="text" validate="float">
					</div>
					<div class="col col-2 ">
						<cfinput name="death_insurance_premium_boss" type="text" validate="float">
					</div>
					<label class="col col-4  font-red">&nbsp;</label>
				</div>
				<!--Muzaffer Bas Maden Sektörü İçin yeni ücret kuralı sgk prim oranı alanı eklenmiştir-->
					<div class="form-group" id="item-death_insurance_premium_worker_maden">
					<label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='53194.Malülük, Yaşlılık, Ölüm Sigorta Pirimi'></label>
					<div class="col col-2 ">
						<cfinput name="death_insurance_premium_worker_maden" type="text" validate="float">
					</div>
					<div class="col col-2 ">
						<cfinput name="death_insurance_premium_boss_maden" type="text" validate="float">
					</div>
					<label class="col col-4  font-red">(Maden Yeraltı ve Yerüstü Grupları için)</label>
				</div>
				<!--Muzaffer Bit-->
				<div class="form-group" id="item-death_insurance_worker">
					<label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='53196.İşsizlik Sigortası'></label>
					<div class="col col-2 ">
						<cfinput name="death_insurance_worker" type="text" validate="float">
					</div>
					<div class="col col-2 ">
						<cfinput name="death_insurance_boss" type="text" validate="float">
					</div>
					<label class="col col-4  font-red">&nbsp;</label>
				</div>
				<div class="form-group" id="item-SOC_SEC_INSURANCE_WORKER">
					<label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='53198.Sosyal Güvenlik Destekleme Primi'></label>
					<div class="col col-2 ">
						<cfinput name="SOC_SEC_INSURANCE_WORKER" type="text" validate="float">
					</div>
					<div class="col col-2 ">
						<cfinput name="SOC_SEC_INSURANCE_BOSS" type="text" validate="float">
					</div>
					<label class="col col-4  font-red">&nbsp;</label>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
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
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53190.Analık Sigorta Primi Girmelisiniz'> !</cfoutput>"})    
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
		loadPopupBox('form_add_ratio' , '<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
}
</script>
