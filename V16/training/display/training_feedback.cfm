
<cfset get_feedback = createObject("component","V16.training.cfc.training_feedback").get_feedback(content_id:attributes.cntid)>

<div class="protein-table training_items">
    <cfform name="training_feedback" method="post" action="V16/training/cfc/training_feedback.cfc?method=save_feedback">
        <cfinput type="hidden" name="content_id" id="content_id" value="#attributes.cntid#">
        <div class="input-group">
            <cfif get_feedback.IS_REPEAT eq 1>
                <div class="form-group">
                    <label class="margin-bottom-10" style="color:red;font-size:initial"><cf_get_lang dictionary_id='65481.Bu konuyu tekrar çalışmalısın!'></label>
                </div>
            </cfif>
            <div class="form-group">
                <div class="checkbox checbox-switch" style="text-align: left!important;">
                    <label class="checking">
                        <input type="checkbox" name="is_studying" id="is_studying" value="1" <cfif get_feedback.IS_STUDY eq 1>checked</cfif>>
                        <span></span>
                        <label class="bold margin-left-5" style="font-size:initial"><cf_get_lang dictionary_id='53069.Üzerinde çalışıyorum'></label>
                    </label>
                </div>
            </div>
            <div class="form-group margin top-5">
                <div class="checkbox checbox-switch" style="text-align: left!important;">
                    <label class="checking">
                        <input type="checkbox" name="is_readed" id="is_readed" value="1" <cfif get_feedback.IS_READED eq 1>checked</cfif>>
                        <span></span>
                        <label class="bold margin-left-5" style="font-size:initial"><cf_get_lang dictionary_id='41788.Anladım'></label>
                    </label>
                </div>
            </div>
        </div>
        <cf_workcube_buttons extraButton="1"  extraButtonText="#getLang('','Kaydet','59031')#"  extraFunction="save_check()" update_status="0">
    </cfform>
</div>

<script>
   function save_check() {
	    loadPopupBox('training_feedback','quality_box');
   }
</script>