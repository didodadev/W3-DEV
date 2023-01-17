<cfquery name="get_progress_pay" datasource="#dsn#">
	SELECT 
		EPP.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEE_PROGRESS_PAYMENT EPP,
		EMPLOYEES E
	WHERE 
		E.EMPLOYEE_ID = EPP.RECORD_EMP AND
		EPP.PROGRESS_ID=#attributes.progress_id#
</cfquery>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_add_progress_payment"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cfform name="upd_progress_payment" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_progress_pay">
            <input type="hidden" name="progress_id" id="progress_id" value="<cfoutput>#get_progress_pay.progress_id#</cfoutput>">
            <input type="hidden" name="event_type" id="event_type" value="<cfoutput>#attributes.event#</cfoutput>">

            <cf_box_elements>
                <div class="row" type="row">
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfinclude template="../query/get_all_branches.cfm">
                                <select name="branch_id" id="branch_id" style="width:150px;">
                                    <cfoutput query="get_all_branches">
                                    <cfif len(COMPANY_ID)>
                                    <option value="#branch_id#-#COMPANY_ID#" <cfif get_progress_pay.branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
                                    </cfif>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-related_company">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53701.İlgili Şirket'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="related_company" id="related_company" style="width:150px;" value="<cfoutput>#get_progress_pay.related_company#</cfoutput>" maxlength="150">
                            </div>
                        </div>
                        <div class="form-group" id="item-emp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_progress_pay.employee_id#</cfoutput>">
									<input type="text" name="emp_name" id="emp_name" value="<cfoutput>#get_emp_info(get_progress_pay.employee_id,0,0)#</cfoutput>" style="width:150px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=upd_progress_payment.employee_id&field_emp_name=upd_progress_payment.emp_name</cfoutput>')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="alert"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput validate="#validate_style#" required="Yes" message="#alert#" type="text" name="startdate" id="startdate"  value="#dateformat(get_progress_pay.startdate,dateformat_style)#"style="width:150px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finishdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="alert"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput validate="#validate_style#" required="Yes" message="#alert#" type="text" name="finishdate" id="finishdate"  value="#dateformat(get_progress_pay.finishdate,dateformat_style)#"style="width:150px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-IS_KIDEM_PAY">
                            <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id ='53797.Kıdem Ücreti Ödendi'></span></label>
                            <label class="col col-8 col-xs-12">
                                <input type="checkbox" value="1" name="IS_KIDEM_PAY" id="IS_KIDEM_PAY" <cfif get_progress_pay.IS_KIDEM_PAY eq 1>checked</cfif>><cf_get_lang dictionary_id ='53797.Kıdem Ücreti Ödendi'>
                            </label>
                        </div>
                        <div class="form-group" id="item-KIDEM_AMOUNT">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53798.Kıdem Ücreti Tutarı'></label>
                            <div class="col col-8 col-xs-12">
                                <input value="<cfoutput>#tlformat(get_progress_pay.KIDEM_AMOUNT)#</cfoutput>" type="text" name="KIDEM_AMOUNT" id="KIDEM_AMOUNT" style="width:150px;" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-worked_day">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53529.Çalışılan Gün Sayısı'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53534.Çalışılan Gün Sayısı Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="worked_day" id="worked_day" style="width:150px;" value="#get_progress_pay.worked_day#" validate="integer" message="#message#" maxlength="5">
                            </div>
                        </div>
                        <div class="form-group" id="item-USED_OFFTIME">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53799.Kullanılan İzin Gün Say'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='53800.Kullanılan İzin Gün Sayısı Hatalı'>!</cfsavecontent>
								<cfinput type="text" name="USED_OFFTIME" id="USED_OFFTIME" style="width:150px;" value="#get_progress_pay.USED_OFFTIME#" validate="integer" message="#message#" maxlength="5">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail" style="width:150px;height:80px;"><cfoutput>#get_progress_pay.PROGRESS_DETAIL#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>    
                </div>
            </cf_box_elements>

            <cf_box_footer>
                <div class="col col-6">
                    <cf_record_info query_name="get_progress_pay">
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_progress_pay&progress_id=#attributes.progress_id#' add_function='UnformatFields()'>
                </div>
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
	x = (500 -document.getElementById('detail').value.length);
	if ( x < 0 )
	{
		alert ("<cf_get_lang dictionary_id ='53801.Açıklama Alanı 500 Karakter Olmalıdır'>!");
		return false;
	}
	
	document.getElementById('KIDEM_AMOUNT').value= filterNum(document.getElementById('KIDEM_AMOUNT').value);
}
</script>
