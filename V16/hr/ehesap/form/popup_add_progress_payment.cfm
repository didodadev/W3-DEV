<cfquery name="get_company" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="add_progress_payment" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_progress_pay">
        <cf_box_elements>
                <div class="row" type="row">
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfinclude template="../query/get_all_branches.cfm">
                                <select name="branch_id" id="branch_id">
                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <cfoutput query="get_all_branches">
                                        <cfif len(COMPANY_ID)><option value="#branch_id#-#COMPANY_ID#">#BRANCH_NAME#</option></cfif>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-related_company">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53701.İlgili Şirket'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="related_company" id="related_company"  value="" maxlength="150">
                            </div>
                        </div>
                        <div class="form-group" id="item-emp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                    <input type="text" name="emp_name" id="emp_name" value="<cfif isdefined("attributes.employee_id")><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=add_progress_payment.employee_id&field_emp_name=add_progress_payment.emp_name</cfoutput>')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                    <cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="startdate" id="startdate" >
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finishdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Aaln"> : <cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
                                    <cfinput validate="#validate_style#" required="yes" message="#message#" type="text" name="finishdate" id="finishdate" >
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-IS_KIDEM_PAY">
                            <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id ='53797.Kıdem Ücreti Ödendi'></span></label>
                            <label class="col col-8 col-xs-12">
                                <input type="checkbox" value="1" name="IS_KIDEM_PAY" id="IS_KIDEM_PAY"><cf_get_lang dictionary_id ='53797.Kıdem Ücreti Ödendi'>
                            </label>
                        </div>
                        <div class="form-group" id="item-KIDEM_AMOUNT">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53798.Kıdem Ücreti Tutarı'></label>
                            <div class="col col-8 col-xs-12">
                                <input value="" type="text" name="KIDEM_AMOUNT" id="KIDEM_AMOUNT"  onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-worked_day">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53529.Çalışılan Gün Sayısı'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='53529.Çalışılan Gün Sayısı'></cfsavecontent>
                                <cfinput type="text" name="worked_day" id="worked_day"  value="" validate="integer" message="#message#" maxlength="5">
                            </div>
                        </div>
                        <div class="form-group" id="item-USED_OFFTIME">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53799.Kullanılan İzin Gün Say'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57477.Hatalı Veri"> : <cf_get_lang dictionary_id ='53799.Kullanılan İzin Gün Sayısı'></cfsavecontent>
                                <cfinput type="text" name="USED_OFFTIME" id="USED_OFFTIME"  value="" validate="integer" message="#message#" maxlength="5">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail" style="width:150px;height:80px;"></textarea>
                            </div>
                        </div>
                    </div>    
                </div>
        </cf_box_elements>
		<cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='UnformatFields()'>
        </cf_box_footer>
</cfform>
</cf_box>
</div>


<script type="text/javascript">
function isNumber(inputStr) 
{
	for (var i = 0; i < inputStr.length; i++) 
	{
		var oneChar = inputStr.substring(i, i + 1)
		if (oneChar < "0" ||  oneChar > "9") {
			return false;
	  }
}
	return true;
}

function UnformatFields()
{
	var x = (500 - document.getElementById('detail').value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id ='53801.Açıklama Alanı 500 Karakter Olmalıdır'>!");
		return false;
	}

	if(document.getElementById('branch_id').value == '')
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57453.Şube'>");
		return false;
	}
	if(document.getElementById('employee_id').value=='')
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
		return false;
	}
	if(document.getElementById('startdate').value=='' && document.getElementById('finishdate').value=='')
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> - <cf_get_lang dictionary_id ='57700.Bitiş Tarihi'>");
		return false;
	}
	
	if(date_check(add_progress_payment.startdate,add_progress_payment.finishdate,'Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır')!=1)
	{
		return false;
	}
	document.getElementById('KIDEM_AMOUNT').value= filterNum(document.getElementById('KIDEM_AMOUNT').value);
	return true;
}
</script>
