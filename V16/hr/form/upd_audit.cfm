<cfquery name="BRANCHES" datasource="#dsn#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfinclude template="../query/get_audit.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','İşyeri Denetim İşlemleri','47129')#" popup_box="1">
        <cfform name="upd_audit" action="#request.self#?fuseaction=hr.emptypopup_upd_audit" method="post" >
            <input type="hidden" name="audit_id" id="audit_id" value="<cfoutput>#attributes.audit_id#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-AUDIT_BRANCH_ID">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55230.Denetlenen Şube">*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="AUDIT_BRANCH_ID" id="AUDIT_BRANCH_ID" style="width:400px;" onChange="showDepartment(this.value)">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="branches">
                                    <option value="#BRANCH_ID#" <cfif branches.BRANCH_ID eq get_audit.AUDIT_BRANCH_ID>selected</cfif>>#branch_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-department">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="59307.Denetlenen Departman">*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="DEPARTMENT_PLACE">
                                <select name="department" id="department" style="width:400px;">
                                    <option value=""><cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'></option>
                                    <cfif len(get_audit.AUDIT_BRANCH_ID)>
                                        <cfquery name="get_departmant" datasource="#dsn#">
                                            SELECT * FROM DEPARTMENT WHERE BRANCH_ID = #get_audit.AUDIT_BRANCH_ID# ORDER BY DEPARTMENT_HEAD
                                        </cfquery>
                                        <cfoutput query="get_departmant">
                                            <option value="#DEPARTMENT_ID#"<cfif DEPARTMENT_ID eq get_audit.AUDIT_DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-AUDITOR">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55231.Denetleyen"><cf_get_lang dictionary_id="55757.Adı Soyadı">*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="53168.Ad Soyad Girmelisiniz"></cfsavecontent>
                                <cfinput type="text" name="AUDITOR" value="#get_audit.AUDITOR#" required="yes" message="#message#" maxlength="100" style="width:130px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-AUDITOR_POSITION">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55588.Denetleyen Pozisyonu"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="36952.Denetleyen Girmelisiniz"></cfsavecontent>
                                <cfinput type="text" name="AUDITOR_POSITION" value="#get_audit.AUDITOR_POSITION#" required="yes" message="#message#" maxlength="100" style="width:130px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-AUDIT_DATE">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                    <cfinput name="AUDIT_DATE" type="text" value="#dateformat(get_audit.AUDIT_DATE,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" style="width:130px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="AUDIT_DATE"></span>
                                </div>
                            </div>
                        </div>
                       
                        <div class="form-group" id="item-AUDIT_RECHECK_DATE">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55786.Eksik Giderilme Tarihi"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id ="55799.Eksik Giderme Tarihi"></cfsavecontent>
                                    <cfif len(get_audit.AUDIT_RECHECK_DATE)>
                                        <cfinput name="AUDIT_RECHECK_DATE" type="text" value="#dateformat(get_audit.AUDIT_RECHECK_DATE,dateformat_style)#" validate="#validate_style#" message="#message1#" style="width:130px;">
                                    <cfelse>
                                        <cfinput name="AUDIT_RECHECK_DATE" type="text" value="" validate="#validate_style#" message="#message1#" style="width:130px;">
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="AUDIT_RECHECK_DATE"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-AUDIT_TYPE">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55589.Denetim Tipi">*</label>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <input type="radio" name="AUDIT_TYPE" id="AUDIT_TYPE" value="1" <cfif get_audit.AUDIT_TYPE is 1>checked</cfif>><cf_get_lang dictionary_id='58561.İç'>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <input type="radio" name="AUDIT_TYPE" id="AUDIT_TYPE" value="0" <cfif get_audit.AUDIT_TYPE is 0>checked</cfif>><cf_get_lang dictionary_id='58562.Dış'>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-caution_to">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55815.Para Cezası"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinclude template="../query/get_moneys.cfm">
                                    <cfinput type="text" name="punishment_money" onkeyup="return(FormatCurrency(this,event));" value="#TLFormat(get_audit.punishment_money)#">
                                    <span class="input-group-addon width">
                                        <select name="punishment_money_type" id="punishment_money_type" style="width:50px;">
                                            <cfoutput query="GET_MONEYS">
                                                <option value="#money_id#" <cfif get_moneys.money_id eq get_audit.punishment_money_type>selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-TERM_DATE">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput validate="#validate_style#" type="text" name="TERM_DATE" style="width:130px;" value="#dateformat(get_audit.term_date,dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="TERM_DATE"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-AUDIT_MISSINGS">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55835.Görülen Eksikler"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea type="text" name="AUDIT_MISSINGS" id="AUDIT_MISSINGS" style="width:400px;height:40px;"><cfoutput>#get_audit.AUDIT_MISSINGS#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-AUDIT_DETAIL">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea type="text" name="AUDIT_DETAIL" id="AUDIT_DETAIL" style="width:400px;height:40px;"><cfoutput>#get_audit.AUDIT_DETAIL#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-AUDIT_RESULT">
                            <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57684.Sonuç'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea type="text" name="AUDIT_RESULT" id="AUDIT_RESULT" style="width:400px;height:40px;"><cfoutput>#get_audit.AUDIT_RESULT#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>    
                <cf_box_footer>
                    <div class="col col-6">
                        <cf_record_info query_name="get_audit">
                    </div>
                    <div class="col col-6">
                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_audit&audit_id=#attributes.audit_id#'>
                    </div>
                </cf_box_footer>  
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		UnformatFields();
		x = document.upd_audit.AUDIT_BRANCH_ID.selectedIndex;
		if (document.upd_audit.AUDIT_BRANCH_ID[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='30126.Şube Seçiniz'>");
			return false;
		}		
	}
	function UnformatFields()
	{
		upd_audit.punishment_money.value = filterNum(upd_audit.punishment_money.value);
	}
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('AUDIT_BRANCH_ID').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
</script>
