<cf_catalystHeader>
<cfform name="upd_salary" action="#request.self#?fuseaction=ehesap.emptypopup_add_setup_salary" method="post">
<div class="row">
    <div class="col col-12 uniqueRow">
        <div class="row formContent"> 
            <div class="row" type="row">
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-salary_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53556.Maaş Türü"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="salary_type" id="salary_type" style="width:175px;">
                                <option value="0"><cf_get_lang dictionary_id="53560.Planlanan Maaş"></option>
                                <option value="1"><cf_get_lang dictionary_id="53562.Gerçek Maaş"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-method_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53508.Zam Metodu'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="method_id" id="method_id" style="width:175px;">
                                <option value="0"><cf_get_lang dictionary_id='53509.Önceki Ay Maaşını Baz Al'></option>
                                <option value="1"><cf_get_lang dictionary_id='53510.Ay Maaşını Baz Al'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-sal_mon">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53346.Takvim'></label>
                        <div class="col col-8 col-xs-12">
                        	<div class="input-group">
                                <select name="sal_mon" id="sal_mon">
                                    <cfloop from="1" to="12" index="i">
                                    <cfoutput>
                                        <option value="#i#">#listgetat(ay_list(),i,',')#</option>
                                    </cfoutput>
                                    </cfloop>
                                </select>
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53350.ve sonrasında'>%</span>
                                <span class="input-group-addon no-bg"></span>
                                <span><cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik veri"> : <cf_get_lang dictionary_id='53135.Yüzde'></cfsavecontent>
								<cfinput type="text" name="percent" id="percent" validate="float" style="width:50px;" maxlength="5" message="#message#" value="0" onkeyup="return(FormatCurrency(this,event,1));"></span>
                                <span class="input-group-addon no-bg">
                                	<select name="status" id="status">
                                        <option value="1"><cf_get_lang dictionary_id='57582.Ekle'></option>
                                        <option value="-1"><cf_get_lang dictionary_id='53354.Çıkar'></option>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-work_start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53348.İşe giriş tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik veri"> : <cf_get_lang dictionary_id='53348.İşe giriş tarihi'></cfsavecontent>
                                <cfinput validate="#validate_style#" type="text" name="work_start_date" id="work_start_date" value="" style="width:150px;" maxlength="10" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="work_start_date"></span> <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53352.den önce olanlar'></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-work_finish_date">
                        <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='53348.İşe giriş tarihi'></span></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik veri"> : <cf_get_lang dictionary_id='53348.İşe giriş tarihi'></cfsavecontent>
								<cfinput validate="#validate_style#" type="text" name="work_finish_date" id="work_finish_date" value="" style="width:150px;" maxlength="10" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="work_finish_date"></span> <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53353.den sonra olanlar'></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-control_finishdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53569.Çıkış Kontrol"></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" value="1" name="control_finishdate" id="control_finishdate" checked>
							<cf_get_lang dictionary_id="53574.Çıkış Tarihi Olmayan Çalışanlar">
                        </label>
                    </div>
                    <div class="form-group" id="item-change_all">
                    	<label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id="53569.Çıkış Kontrol"></span></label>
                    	<label class="col col-8 col-xs-12">
                            <input type="checkbox" value="1" name="change_all" id="change_all" checked>
							<cf_get_lang dictionary_id='53351.Sadece Etkilensin Olanlar'>
                        </label>
                    </div>
                    <div class="form-group" id="item-sal_year">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53482.Yıllar'></label>
                    	<div class="col col-8 col-xs-12">
                            <cfloop from="#year(now())#" to="#year(now())+2#" index="i">
								<cfoutput>
                                <label><input type="checkbox" name="sal_year" id="sal_year" value="#i#"></label>
                                <label>#i#</label>
								</cfoutput>
                            </cfloop>
                        </div>
                    </div>
                    <div class="form-group" id="item-our_company_id">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirketler'></label>
                    	<div class="col col-8 col-xs-12">
                            <cf_multiselect_check
                            name="our_company_id"
                            option_name="NICK_NAME"
                            option_value="COMP_ID"
                            width="175"
                            table_name="OUR_COMPANY">
                        </div>
                    </div>
                    <div class="form-group" id="item-POSITION_CAT_ID">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                    	<div class="col col-8 col-xs-12">
                            <cf_multiselect_check
                            name="POSITION_CAT_ID"
                            option_name="POSITION_CAT"
                            option_value="POSITION_CAT_ID"
                            width="175"
                            table_name="SETUP_POSITION_CAT">
                        </div>
                    </div>
                    <div class="form-group" id="item-position_code">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
                    	<div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<input type="hidden" name="position_code" id="position_code" value="">
								<input type="text" name="employee" id="employee" value="" style="width:175px;" readonly>
                    			<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_code=upd_salary.position_code&field_emp_name=upd_salary.employee</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>
                </div>    
            </div>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function="form_chk()">
                </div>
            </div>
        </div>
    </div>
</div>
</cfform>
<script type="text/javascript">
function form_chk()
	{
	/*ŞİRKET SEÇİLMELİ*/
	if(document.getElementById('our_company_id').value=='')
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57574.Şirket'>");
		return false;
	}

	/*YIL SEÇİLMELİ*/
	flag = 0;
	for (i=0;i <document.getElementsByName('sal_year').length;i++)
		if (upd_salary.sal_year[i].checked)
			flag = 1;
	if (!flag)
	{
		alert("<cf_get_lang dictionary_id ='54035.En az bir yıl seçmelisiniz'> !");
		return false;
	}
		document.getElementById('percent').value = filterNum(document.getElementById('percent').value,1);
		return true;
	}

</script>

