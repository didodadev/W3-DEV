<cf_xml_page_edit fuseact="objects.popup_form_add_target">
<cfif isdefined('attributes.fbx') and attributes.fbx eq 'myhome'>
    <cfset attributes.target_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.target_id,accountKey:session.ep.userid)>
    <cfif len(attributes.position_code)>
    	<cfset attributes.position_code = contentEncryptingandDecodingAES(isEncode:0,content:attributes.position_code,accountKey:session.ep.userid)>
    </cfif>
</cfif>
<cfquery name="GET_POSITION" datasource="#DSN#">
	SELECT
		DEPARTMENT.DEPARTMENT_HEAD,
		EMPLOYEE_POSITIONS.DEPARTMENT_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_CAT_ID,
		EMPLOYEE_POSITIONS.USER_GROUP_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_EMAIL,
        EMPLOYEES.EMPLOYEE_ID,
		SETUP_POSITION_CAT.POSITION_CAT,
		BRANCH.BRANCH_NAME
	FROM
		EMPLOYEE_POSITIONS,
		EMPLOYEES,
		DEPARTMENT,
		SETUP_POSITION_CAT,
		BRANCH
	WHERE
		SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		<cfif isDefined("attributes.position_code") and len(attributes.position_code)>
            AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
        </cfif>
        <cfif isDefined("attributes.employee_id") and len(attributes.employee_id)>
            AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
        </cfif>
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>
<cfinclude template = "../query/get_target.cfm">
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1
</cfquery>

<cfset pageHead = "#getLang('','Hedefler',57964)# : #attributes.target_id#">
<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="upd_target" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_target" onsubmit="return deger_kontrol();">
                <input type="hidden" name="per_id" id="per_id" value="<cfif len(get_target.per_id)><cfoutput>#get_target.per_id#</cfoutput></cfif>">
                <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput><cfif isDefined("attributes.employee_id") and len(attributes.employee_id)>#attributes.employee_id#<cfelse>#get_position.employee_id#</cfif></cfoutput>">
                <input type="Hidden" name="target_id" id="target_id" value="<cfoutput>#attributes.target_id#</cfoutput>">
                <input type="hidden" name="counter" id="counter" value="">
                <input type="hidden" name="xml_is_show_add_info_input" id="xml_is_show_add_info_input" value="<cfoutput>#xml_is_show_add_info#</cfoutput>" />
                
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="startdate" id="startdate" value="#dateformat(get_target.startdate,dateformat_style)#" required="yes" validate="#validate_style#" message="#getLang('','Başlangıç Tarihi Girmelisiniz',57738)# !">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finishdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş'>*</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(get_target.finishdate,dateformat_style)#" required="yes" validate="#validate_style#" message="#getLang('','Bitiş Tarihi Giriniz',58491)# !">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-targetcat_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <select name="targetcat_id" id="targetcat_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfinclude template="../query/get_target_cats.cfm">
                                    <cfoutput query="get_target_cats">
                                        <option value="#targetcat_id#" <cfif get_target.targetcat_id eq targetcat_id>selected</cfif>>#targetcat_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        
                        <cfif xml_is_show_add_info eq 1>
                            <div class="form-group" id="item-target_number">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33533.Rakam'></label>
                                <div class="col col-2 col-xs-12">
                                    <cfinput type="text" name="target_number" id="target_number" value="#TLFormat(get_target.target_number)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                </div>
                                <div class="col col-4 col-xs-12">
                                    <select name="calculation_type" id="calculation_type">
                                        <option value="1" <cfif get_target.calculation_type eq 1>selected </cfif>> + (<cf_get_lang dictionary_id='33534.Artış Hedefi'>)</option>
                                        <option value="2" <cfif get_target.calculation_type eq 2>selected </cfif>>- ((<cf_get_lang dictionary_id='33535.Düşüş Hedefi'>)</option>
                                        <option value="3" <cfif get_target.calculation_type eq 3>selected </cfif>>+% (<cf_get_lang dictionary_id='33537.Yüzde Artış Hedefi'>)</option>
                                        <option value="4" <cfif get_target.calculation_type eq 4>selected </cfif>> -% (<cf_get_lang dictionary_id='33536.Yüzde Düşüş Hedefi'>)</option>
                                        <option value="5" <cfif get_target.calculation_type eq 5>selected </cfif>> = (<cf_get_lang dictionary_id='33541.Hedeflenen Rakam'>)</option>
                                    </select>
                                </div>
                            </div> 
                         </cfif>
                            <div class="form-group" id="item-target_weight">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29784.Ağırlık'>*</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <cfsavecontent variable="message2"><cf_get_lang dictionary_id='33698.Hedef Ağırlığı Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="text" name="target_weight" id="target_weight" class="moneybox" value="#TLFormat(get_target.target_weight)#" onkeyup="return(formatcurrency(this,event));" required="yes" maxlength="3" message="#message2#">
                                </div>
                            </div>
                            <cfif xml_is_show_add_info eq 1>
                            <div class="form-group" id="item-suggested_budget">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33538.Ayrılan Bütçe'></label>
                                <div class="col col-6 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="suggested_budget" id="suggested_budget" value="#TLFormat(get_target.suggested_budget)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                        <span class="input-group-addon width">
                                            <select name="money_type" id="money_type">
                                                <cfoutput query="get_money">
                                                    <option value="#money#" <cfif get_money.money eq get_target.target_money>selected</cfif>>#money#</option>
                                                </cfoutput>
                                            </select>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <cfif xml_is_show_add_info eq 1>
                            <div class="form-group" id="item-other_date1">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33691.Ara Görüşme Tarihi 1'></label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="messaget"><cf_get_lang dictionary_id ='58492.Tarihi Kontrol Ediniz'></cfsavecontent>
                                        <cfinput type="text" name="other_date1" id="other_date1" validate="#validate_style#" value="#dateformat(get_target.other_date1,dateformat_style)#" maxlength="10" message="#messaget#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="other_date1"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-other_date2">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33692.Ara Görüşme Tarihi 2'></label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="other_date2" id="other_date2" validate="#validate_style#" value="#dateformat(get_target.other_date2,dateformat_style)#" maxlength="10" message="#messaget#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="other_date2"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-target_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57951.Hedef'>*</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cftextarea type="text" name="target_head" id="target_head" required="yes" message="#getLang('','Hedef Girmelisiniz',33542)# !" style="width:140px;height:45px;" maxlength="300"><cfoutput>#get_target.target_head#</cfoutput></cftextarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-target_emp">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33540.Hedef Veren'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cfif session.ep.userid eq get_target.target_emp>
                                    <div class="input-group">
                                </cfif>
                                    <input type="hidden" name="target_emp_id" id="target_emp_id"  value="<cfoutput>#get_target.target_emp#</cfoutput>">
                                    <input type="text" name="target_emp" id="target_emp" value="<cfoutput>#get_emp_info(get_target.target_emp,0,0)#</cfoutput>" readonly>
                                    <cfif session.ep.userid eq get_target.target_emp>
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=upd_target.target_emp&field_emp_id2=upd_target.target_emp_id</cfoutput>');" title="<cf_get_lang dictionary_id='32436.Markalar'>"></span>
                                    </cfif>
                                <cfif session.ep.userid eq get_target.target_emp>
                                    </div>
                                </cfif>
                            </div>
                        </div>
                        
                        <div class="form-group" id="item-target_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <textarea name="target_detail" id="target_detail" style="width:140px;height:45px;"><cfoutput>#get_target.target_detail#</cfoutput></textarea>
                            </div>
                        </div>
                        <cfoutput>
                            <div class="form-group" id="item-target_detail">
                                
                            </div>
                        </cfoutput>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6 col-md-6">
                        <cf_record_info query_name="get_target">
                    </div>
                    <div class="col col-6">
                         <cfif not isdefined("attributes.per_id")><!---hedef yetkinlik performans sisteminden günceleme icin geldiginde per_id geliyor--->
                            <cfif xml_upd_target eq 1 or session.ep.userid eq get_target.target_emp>
                                <cf_workcube_buttons is_upd='1'  
                                delete_page_url='#request.self#?fuseaction=objects.del_target&target_id=#get_target.target_id#&head=#get_target.target_head#&cat=#get_target_cats.targetcat_id#' 
                                delete_alert='#getLang('','Kaydı Siliyorsunuz.Emin misiniz?',33700)#' 
                                add_function='check()'>
                          </cfif>	
                        <cfelse>
                            <cf_get_lang dictionary_id='33699.Performans Formu Onaylandığı İçin Güncelleme Yapamazsınız'>!	
                        </cfif>
                    </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
<script type="text/javascript">
	function check()
	{
		if(document.getElementById('targetcat_id').value == '')
		{
			alert("<cf_get_lang dictionary_id='32972.Önce Kategori Seçiniz'>");
			return false;	
		}
		if ((document.getElementById('startdate').value != "") && (document.getElementById('finishdate').value != ""))
		if (! date_check(upd_target.startdate, upd_target.finishdate, "<cfoutput>#getLang('objects',1317)#</cfoutput>!"))
			return false;
	}
	
	function deger_kontrol()
	{
		if (document.getElementById('xml_is_show_add_info_input').value == 1){
			document.getElementById('target_number').value = filterNum(document.getElementById('target_number').value);
			if (document.getElementById('suggested_budget').value != "")
				document.getElementById('suggested_budget').value = filterNum(document.getElementById('suggested_budget').value);
		}	
		document.getElementById('target_weight').value = filterNum(document.getElementById('target_weight').value);
		return true;
	}
</script>
