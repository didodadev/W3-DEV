<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
    <cfform name="form_add" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_our_comp_hours">
        <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-OUR_COMPANY_ID">
                    <cfinclude template="../../../settings/query/get_our_companies.cfm">
                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="57574.Şirket"></label>
                    <div class="col col-7 col-xs-12">
                        <select name="OUR_COMPANY_ID" id="OUR_COMPANY_ID" style="width:345px;">
                            <cfoutput query="OUR_COMPANY">
                                <option value="#COMP_ID#">#COMPANY_NAME#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-ssk_monthly_work_hours">
                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="53870.SGK Aylık Çalışma Saati"></label>
                    <div class="col col-7 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55142.Aylık Çalışma Saati"></cfsavecontent>
                        <cfinput type="text" name="ssk_monthly_work_hours" value="" validate="float" message="#message#" required="yes" style="width:85px;">
                    </div>
                </div>
                <div class="form-group" id="item-daily_work_hours">
                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="53896.Hafta içi Günlük Çalışma Saati"></label>
                    <div class="col col-7 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="53896.Hafta içi Günlük Çalışma Saati"></cfsavecontent>
                        <cfinput type="text" name="daily_work_hours" value="" validate="float" message="#message#" required="yes" style="width:75px;">
                    </div>
                </div>
                <div class="form-group" id="item-SSK_WORK_HOURS">
                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="53930.SGK Mesai Saati"></label>
                    <div class="col col-7 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55376.Günlük Çalışma Saati"></cfsavecontent>
                        <cfinput type="text" name="SSK_WORK_HOURS" value="" validate="float" message="#message#" required="yes" style="width:85px;">
                    </div>
                </div>
                <div class="form-group" id="item-SATURDAY_WORK_HOURS">
                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="53918.Cumartesi Çalışma Saati"></label>
                    <div class="col col-7 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="53918.Cumartesi Çalışma Saati"></cfsavecontent>
                        <cfinput type="text" name="SATURDAY_WORK_HOURS" value="" validate="float" message="#message#" required="yes" style="width:75px;">
                    </div>
                </div>
                <div class="form-group" id="item-weekly_offday">
                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="29516.Haftalık Tatil Günü"></label>
                    <div class="col col-7 col-xs-12">
                        <select name="weekly_offday" id="weekly_offday" style="width:85px;">
                            <option value="2"><cf_get_lang dictionary_id="57604.Pazartesi"></option>
                            <option value="3"><cf_get_lang dictionary_id="57605.Salı"></option>
                            <option value="4"><cf_get_lang dictionary_id="57606.Çarşamba"></option>
                            <option value="5"><cf_get_lang dictionary_id="57607.Perşembe"></option>
                            <option value="6"><cf_get_lang dictionary_id="57608.Cuma"></option>
                            <option value="7"><cf_get_lang dictionary_id="57609.Cumartesi"></option>
                            <option value="1" selected="selected"><cf_get_lang dictionary_id="57610.Pazar"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-saturday_off">
                <div class="col col-5 col-xs-12"></div>
                    <div class="col col-7 col-xs-12">
                        <label><input type="checkbox" name="saturday_off" id="saturday_off" value="1"> <cf_get_lang dictionary_id="53915.Cumartesi Ek Hafta Tatili Sayılsın"></label>
                    </div>
                </div>
               <div class="form-group" id="item-hours">
                    <label class="col col-12 bold"><cf_get_lang dictionary_id='53415.Çalışma Saatleri'></label>
                </div>
                <div class="form-group" id="item-start_hour">
                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53066.Başlama saati'></label>
                    <div class="col col-7 col-xs-12">
                        <div class="input-group">
                            <select name="start_hour" id="start_hour">
                                <cfloop from="0" to="24" index="i">
                                    <cfoutput>
                                        <option value="#i#">#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                            <span class="input-group-addon no-bg"></span>
                            <select name="start_min" id="start_min">
                                <option value="00">00</option>
                                <option value="05">05</option>
                                <option value="10">10</option>
                                <option value="15">15</option>
                                <option value="20">20</option>
                                <option value="25">25</option>
                                <option value="30">30</option>
                                <option value="35">35</option>
                                <option value="40">40</option>
                                <option value="45">45</option>
                                <option value="50">50</option>
                                <option value="55">55</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-end_hour">
                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53067.Bitiş saati'></label>
                    <div class="col col-7 col-xs-12">
                        <div class="input-group">
                            <select name="end_hour" id="end_hour">
                                <cfloop from="0" to="24" index="i">
                                    <cfoutput>
                                        <option value="#i#">#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                            <span class="input-group-addon no-bg"></span>
                            <select name="end_min" id="end_min">
                                <option value="00">00</option>
                                <option value="05">05</option>
                                <option value="10">10</option>
                                <option value="15">15</option>
                                <option value="20">20</option>
                                <option value="25">25</option>
                                <option value="30">30</option>
                                <option value="35">35</option>
                                <option value="40">40</option>
                                <option value="45">45</option>
                                <option value="50">50</option>
                                <option value="55">55</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function=unformat_fields()>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function unformat_fields()
	{
		document.form_add.ssk_monthly_work_hours.value=filterNum(document.form_add.ssk_monthly_work_hours.value);
		document.form_add.daily_work_hours.value=filterNum(document.form_add.daily_work_hours.value);
		document.form_add.SSK_WORK_HOURS.value=filterNum(document.form_add.SSK_WORK_HOURS.value);
		document.form_add.SATURDAY_WORK_HOURS.value=filterNum(document.form_add.SATURDAY_WORK_HOURS.value);
	}
</script>

