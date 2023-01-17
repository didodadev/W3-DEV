<cf_get_lang_set module_name="ehesap">
<cfquery name="get_healty" datasource="#dsn#">
	SELECT 
    	ERH.DOC_ID, 
        ERH.EMP_ID, 
        ERH.ILL_NAME, 
        ERH.ILL_SURNAME, 
        ERH.ILL_BIRTHDATE, 
        ERH.ILL_BIRTHPLACE, 
        ERH.ILL_RELATIVE, 
        ERH.ARRANGEMENT_DATE, 
        ERH.ADDRESS, 
        ERH.BRANCH_ID, 
        ERH.TC_IDENTY_NO, 
        ERH.IN_OUT_ID, 
        ERH.DOCUMENT_NO, 
        ERH.DETAIL, 
        ERH.UPDATE_EMP, 
        ERH.UPDATE_DATE, 
        ERH.UPDATE_IP, 
        ERH.RECORD_EMP,
        ERH.RECORD_DATE, 
        ERH.RECORD_IP, 
        ERH.ILL_SEX ,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        B.BRANCH_NAME,		
        B.SSK_OFFICE,
        B.SSK_NO
    FROM  
	    EMPLOYEES_RELATIVE_HEALTY ERH
        LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = ERH.EMP_ID
        LEFT JOIN BRANCH B ON B.BRANCH_ID = ERH.BRANCH_ID
    WHERE 
    	DOC_ID = #attributes.DOC_ID#
</cfquery>

<cf_catalystHeader>
<cfform name="ssk_fee" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_emp_relative_healty_upd">
<input type="hidden" name="doc_id" id="doc_id" value="<cfoutput>#attributes.doc_id#</cfoutput>">
 <div class="row">
    <div class="col col-12 uniqueRow">
        <div class="row formContent">
            <div class="row" type="row">
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-emp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57576.Çalışan'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_healty.EMP_ID#</cfoutput>">
                                <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#get_healty.IN_OUT_ID#</cfoutput>">
                                <input type="text" name="emp_name" id="emp_name" style="width:150px;" value="<cfoutput>#get_healty.EMPLOYEE_NAME# #get_healty.EMPLOYEE_SURNAME#</cfoutput>" readonly>
                            	<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=ssk_fee.in_out_id&field_emp_name=ssk_fee.emp_name&field_emp_id=ssk_fee.employee_id','list');"></span>
                            	<span class="input-group-addon  icon-pluss" onClick="javascript:if(document.ssk_fee.employee_id.value!=''){windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_name=popup_ssk_healty_print.ill_name&field_surname=popup_ssk_healty_print.ill_surname&field_relative=popup_ssk_healty_print.ill_relative&field_birth_date=popup_ssk_healty_print.BIRTH_DATE&field_birth_place=popup_ssk_healty_print.BIRTH_PLACE&field_tc_identy_no=popup_ssk_healty_print.TC_IDENTY_NO&employee_id='+document.ssk_fee.employee_id.value,'list');}else {alert('Çalışan seçiniz');return false;}"   title="<cfoutput>#getlang('ehesap',1002)#</cfoutput>"></span>
                            </div>
                        </div>
                    </div>
                    <cfif len(get_healty.BRANCH_ID)>
                        <div class="form-group" id="item-BRANCH_NAME">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput>#get_healty.BRANCH_NAME#-#get_healty.SSK_OFFICE#-#get_healty.SSK_NO#</cfoutput>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-ill_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57897.Adı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ill_name" id="ill_name" style="width:150px;"  value="<cfoutput>#get_healty.ill_name#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_surname">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58550.Soyadı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ill_surname" id="ill_surname" style="width:150px;"  value="<cfoutput>#get_healty.ill_surname#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_relative">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53143.Yakınlığı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ill_relative" id="ill_relative" style="width:150px;"  value="<cfoutput>#get_healty.ill_relative#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_sex">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                        <div class="col col-8 col-xs-12">
                            <label><input type="radio" name="ill_sex" id="ill_sex" value="1" <cfif get_healty.ill_sex eq 1>checked</cfif>><cf_get_lang dictionary_id='58959.Erkek'></label>
                            <label><input type="radio" name="ill_sex" id="ill_sex" value="0" <cfif get_healty.ill_sex neq 1>checked</cfif>><cf_get_lang dictionary_id='58958.Kadın'></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-BIRTH_PLACE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="BIRTH_PLACE" id="BIRTH_PLACE" style="width:150px;"  value="<cfoutput>#get_healty.ILL_BIRTHPLACE#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-BIRTH_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54111.Doğum Tarihi Alanı Hatalı'></cfsavecontent>
            					<cfinput validate="#validate_style#" type="text" name="BIRTH_DATE" id="BIRTH_DATE" value="#dateformat(get_healty.ILL_BIRTHDATE,dateformat_style)#" style="width:150px;" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="BIRTH_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-TC_IDENTY_NO">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58025.TC Kimlik No'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_duxi type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO" value="#get_healty.TC_IDENTY_NO#" hint="TC Kimlik No" gdpr="2"  required="yes" maxlength="11" data_control="isnumber">
                        </div>
                    </div>
                    <div class="form-group" id="item-ARRANGEMENT_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53947.Düzenleme Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<cfsavecontent variable="messafe"><cf_get_lang dictionary_id ='53947.Düzenleme Tarihi'></cfsavecontent>
           	 					<cfinput validate="#validate_style#" type="text" name="ARRANGEMENT_DATE" id="ARRANGEMENT_DATE" value="#dateformat(get_healty.ARRANGEMENT_DATE,dateformat_style)#" style="width:150px;" message="#messafe#" required="yes">
                    			<span class="input-group-addon"><cf_wrk_date_image date_field="ARRANGEMENT_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57771.Detay'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail" style="width:150px;height:60px;"><cfoutput>#get_healty.DETAIL#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-document_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="document_no" id="document_no" style="width:150px;" value="#get_healty.DOCUMENT_NO#"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-6">
                    <cf_record_info query_name="get_healty">
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_emp_relative_healty_del&doc_id=#attributes.doc_id#'>
                </div>
            </div>
        </div>
    </div>
</div>
    </cfform>
<script type="text/javascript">
function kontrol()
{
	if (document.getElementById('emp_name').value == "")
	{
		alert("<cf_get_lang dictionary_id ='53774.Çalışan Seçiniz'>!");
		return false;
	}
	if (document.getElementById('ill_name').value == "")
	{
		alert("<cf_get_lang dictionary_id ='31540.Vizite Alacak Kişinin Adını Giriniz'>!");
		return false;
	}
	if (document.getElementById('ill_surname').value == "")
	{
		alert("<cf_get_lang dictionary_id ='53943.Vizite Alacak Kişinin Soyadını Giriniz'>!");
		return false;
	}
	if (document.getElementById('ill_relative').value == "")
	{
		alert("<cf_get_lang dictionary_id ='53944.Vizite Alacak Kişinin Yakınlığını Giriniz'>!");
		return false;
	}
	if (document.getElementById('TC_IDENTY_NO').value == "")
	{
		alert("<cf_get_lang dictionary_id ='53945.TC Kimlik Numarası Girmelisiniz'>!");
		return false;
	}
	return true;
}
</script>
