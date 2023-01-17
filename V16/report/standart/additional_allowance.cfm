
<!---
File: additional_allowance.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:25.09.2019
Controller: -
Description: Ek Ödenekler Raporudur.
--->
<cfset bu_ay_basi = CreateDate(year(now()),month(now()),1)>
<cfset bu_ay_sonu = DaysInMonth(bu_ay_basi)>
<cfparam name = "attributes.position_id" default="">
<cfparam name = "attributes.start_mon" default="">
<cfparam name = "attributes.finish_mon" default="">
<cfparam name = "attributes.period_year" default="#session.ep.period_year#">
<cfparam name = "attributes.odkes_id_0" default="">
<cfparam name = "attributes.comment_pay_0" default="">
<cfparam name = "attributes.inout_statue" default="2">
<cfparam name = "attributes.function_unit" default="">
<cfparam name = "attributes.title_id" default="">
<cfparam name = "attributes.branch_id" default="">
<cfparam name = "attributes.duty_type" default="">
<cfparam name = "attributes.collor_type" default="">
<cfparam name = "attributes.maxrows" default=20>
<cfparam name = "attributes.is_excel" default="0">
<cfparam name = "attributes.totalrecords" default="">
<cfparam name = "attributes.page" default=1>
<cfparam name = "attributes.startdate" default="#date_add("m",-1,bu_ay_basi)#">
<cfparam name = "attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfset position = createObject('component','V16.hr.cfc.wage_scale')><!--- Pozisyon Tipi Component--->
<cfset periods = createObject('component','V16.objects.cfc.periods')><!--- Period yılları Component --->
<cfset get_component = createObject('component','V16.report.cfc.additional_allowance')><!--- Ek Ödenekler Component--->
<cfset get_func_units = createObject('component','V16.hr.cfc.get_functions')><!--- Fonksiyonlar  Component --->
<cfset cmp_title = createObject("component","V16.hr.cfc.get_titles")><!--- Ünvanlar Component --->
<cfset get_func_units.dsn = dsn><!--- Dsn ataması --->
<cfset cmp_title.dsn = dsn><!--- Dsn ataması --->
<cfset get_func = get_func_units.get_function()><!--- Fonksiyonlar --->
<cfset get_branch = get_component.get_branch()><!--- Şubeler --->
<cfset period_years = periods.get_period_year()><!--- Periyotlar --->
<cfset titles = cmp_title.get_title()><!--- Ünvanlar --->
<cfif isdefined("attributes.is_submit")>
    <cfset get_add_all = get_component.GET_ADDITIONAL_ALLOWANGE(
                                    position_id : len(attributes.position_id) ? "#attributes.position_id#" : "",<!--- Pozisyon Tipi --->
                                    start_mon :  len(attributes.start_mon) ? "#attributes.start_mon#" : "",<!--- Başlangıç Ayı --->
                                    finish_mon :  len(attributes.finish_mon) ? "#attributes.finish_mon#" : "",<!--- Bitiş Ayı --->
                                    period_year :  len(attributes.period_year) ? "#attributes.period_year#" : "",<!--- Dönem --->
                                    odkes_id_0 :  len(attributes.odkes_id_0) ? "#attributes.odkes_id_0#" : "",<!--- Ödeme Yöntemi ID --->
                                    comment_pay_0 :  len(attributes.comment_pay_0) ? "#attributes.comment_pay_0#" : "",<!--- Ödeneme Yöntemi İsmi --->
                                    inout_statue :  len(attributes.inout_statue) ? "#attributes.inout_statue#" : "",<!--- Çalışma Durumu --->
                                    function_unit :  len(attributes.function_unit) ? "#attributes.function_unit#" : "",<!--- Fonksiyon --->
                                    title_id :  len(attributes.title_id) ? "#attributes.title_id#" : "",<!--- Ünvan --->
                                    branch_id :  len(attributes.branch_id) ? "#attributes.branch_id#" : "",<!--- Şube --->
                                    duty_type :  len(attributes.duty_type) ? "#attributes.duty_type#" : "",<!--- Görev Tipi --->
                                    collor_type :  len(attributes.collor_type) ? "#attributes.collor_type#" : "",<!---  Yaka Tipi --->
                                    startdate :  len(attributes.startdate) ? "#attributes.startdate#" : "",<!--- Başlangıç Tarihi --->
                                    finishdate :  len(attributes.finishdate) ? "#attributes.finishdate#" : ""<!--- Bitiş Tarihi --->
                        )>
    <cfset get_comment_pay = get_component.GET_COMMENT_PAY(comment_pay_0 :  len(attributes.comment_pay_0) ? "#attributes.comment_pay_0#" : "")>
    <cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfsavecontent variable = "title"><cf_get_lang dictionary_id="54763.Ek Ödenek Raporu"></cfsavecontent>
<cfset get_position_cat = position.GET_POSITION_CAT()>
<cfform name="search_scale" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-12 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="position_id">
                                                <option value = ""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                                <cfoutput query = "get_position_cat">
                                                    <option value = "#position_cat_id#" <cfif attributes.position_id eq position_cat_id>selected</cfif>>#position_cat#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='54054.Yaka Tipi'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="collor_type">
                                                <option value = ""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                                <option value="1"<cfif attributes.collor_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='54055.Mavi Yaka'></option>
                                                <option value="2"<cfif attributes.collor_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='54056.Beyaz Yaka'></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="branch_id">
                                                <option value = ""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                                <cfoutput query = "get_branch">
                                                    <option value="#branch_id#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="duty_type">
                                                <option value = ""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                                <option value="2" <cfif attributes.duty_type eq 2>selected</cfif>><cf_get_lang dictionary_id = '57576.Çalışan'></option>
                                                <option value="1" <cfif attributes.duty_type eq 1>selected</cfif>><cf_get_lang dictionary_id = "53140.İşveren Vekili"></option>
                                                <option value="0" <cfif attributes.duty_type eq 0>selected</cfif>><cf_get_lang dictionary_id = '53550.İşveren'></option>
                                                <option value="3" <cfif attributes.duty_type eq 3>selected</cfif>><cf_get_lang dictionary_id = "53152.Sendikalı"></option>
                                                <option value="4" <cfif attributes.duty_type eq 4>selected</cfif>><cf_get_lang dictionary_id = "48067.Sözleşmeli"></option>
                                                <option value="5" <cfif attributes.duty_type eq 5>selected</cfif>><cf_get_lang dictionary_id = "53169.Kapsam Dışı"></option>
                                                <option value="6" <cfif attributes.duty_type eq 6>selected</cfif>><cf_get_lang dictionary_id = "53182.Kısmi İstihdam"></option>
                                                <option value="7" <cfif attributes.duty_type eq 7>selected</cfif>><cf_get_lang dictionary_id = "53199.Taşeron"></option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="function_unit">
                                                <option value = ""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                                <cfoutput query = "get_func">
                                                    <option value="#unit_id#" <cfif attributes.function_unit eq unit_id>selected</cfif>>#unit_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="title_id" id="title_id" style="width:125px;">
                                                <option value = ""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                                <cfoutput query="titles">
                                                    <option value="#title_id#" <cfif attributes.title_id EQ title_id>selected</cfif>>#title#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='55539.Çalışma Durumu'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="inout_statue" id="inout_statue">
                                                <option value="3"<cfif attributes.inout_statue eq 3> selected</cfif>><cf_get_lang dictionary_id='29518.Girişler ve Çıkışlar'></option>
                                                <option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
                                                <option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
                                                <option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='39083.Aktif Çalışanlar'></option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-6 col-md-6 col-xs-6"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                        <label class="col col-6 col-md-6 col-xs-6"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                        <div class="col col-6 col-md-6 col-xs-6"> 
                                            <div class="input-group">   
                                                <input type="text" name="startdate" id="startdate" value="<cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput>">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                            </div>
                                        </div>   
                                        <div class="col col-6 col-md-6 col-xs-6"> 
                                            <div class="input-group">   
                                                <input type="text" name="finishdate" id="finishdate" value="<cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput>">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                            </div>
                                        </div>   
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='53290.Ödenek Türü'>*</label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="input-group">
                                                <cfoutput>
                                                    <input type="hidden" value="#attributes.odkes_id_0#" name="odkes_id_0" id="odkes_id_0" />
                                                    <input type="text" name="comment_pay_0" id="comment_pay_0" value="#attributes.comment_pay_0#" readonly >
                                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_list_odenek','medium');"></span>
                                                </cfoutput>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
                                        <div class="col col-4 col-md-4 col-xs-4">
                                            <select name="period_years" id="period_years">
                                                <cfoutput query = "period_years">
                                                    <option value="#period_year#"<cfif attributes.period_year eq period_year> selected</cfif>>#period_year#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                        <div class="col col-4 col-md-4 col-xs-4">
                                            <select name="start_mon" id="start_mon">
                                                <cfloop from="1" to="12" index="i">
                                                    <cfoutput>
                                                    <option value="#i#" <cfif len(attributes.start_mon) eq i>selected<cfelseif month(now()) gt 1 and i eq month(now())-1>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                                    </cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>
                                        <div class="col col-4 col-md-4 col-xs-4">
                                            <select name="finish_mon" id="finish_mon">
                                                <cfloop from="1" to="12" index="i">
                                                    <cfoutput>
                                                    <option value="#i#" <cfif len(attributes.finish_mon) eq i>selected<cfelseif month(now()) gt 1 and i eq month(now())-1>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                                    </cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="is_submit" id="is_submit" value="1" type="hidden">
							<cf_wrk_report_search_button button_type='1' is_excel='1'>
						</div>
					</div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cf_report_list>
    <cfif isdefined('attributes.is_submit')>
        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset type_ = 1>
            <cfset attributes.startrow=1>
            <cfset attributes.maxrows=get_add_all.recordcount>		
        <cfelse>
            <cfset type_ = 0>
        </cfif>
        <thead>
            <tr> 
                <th width="25"><cf_get_lang dictionary_id='58577.Sira'></th>
                <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                <th><cf_get_lang_main dictionary_id='57572.Departman'></th>
                <th><cf_get_lang_main dictionary_id='58455.Yıl'></th>
                <th><cf_get_lang_main dictionary_id='58724.Ay'></th>
                <th><cf_get_lang dictionary_id='53290.Ödenek Türü'></th>
                <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                <th>
                    <cf_get_lang dictionary_id='57141.Seçim'>
                </th>
                <th><cf_get_lang dictionary_id='52570.Listeden Çıkar'></th>
            </tr>
        </thead>
        <tbody>
            <cfform name="submit_payment" method="post" action="#request.self#?fuseaction=report.emptypopup_additional_allowance_report">
                <cfif get_add_all.recordcount>
                    <cfoutput query = "get_add_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr id="#employee_id#"> 
                            <td width="25">#currentrow#</td>
                            <td>
                                <cfif isdefined("FINISH_DATE") and len(FINISH_DATE)>
                                    <font color="red">
                                        #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
                                    </font>
                                <cfelse>
                                    #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
                                </cfif>
                            </td>
                            <td>#DEPARTMENT_HEAD#</td>
                            <td>#attributes.period_year#</td>
                            <td>#listgetat(ay_list(),attributes.start_mon,',')#</td>
                            <td>#attributes.comment_pay_0#</td>
                            <td>#TlFormat(get_comment_pay.amount_pay,2)# #get_comment_pay.money# </td>
                            <td style="text-align:center; width:25px">
                                <input type="checkbox" id="check_list" name = "check_list" value = "#in_out_id#">
                            </td>
                            <td style="text-align:center; width:35px"><i class="fa fa-minus" onClick="del_row('#employee_id#')"></i></td>
                        </tr>
                    </cfoutput>
                    <tfoot>
                        <tr height="40" class="nohover">
                            <td colspan="7" align="right" style="text-align:right;"><cf_get_lang dictionary_id = "38750.Tümünü Seç"> :</td>
                            <td align="right"> <input type="checkbox" id="check_all" name = "check_all" value = "#in_out_id#"></td>
                            <td align="right" >
                                <cfoutput>
                                    <input type = "hidden" name = "payment_submit" value = "1">
                                    <input type = "hidden" name = "comment_pay_0" value = "#attributes.comment_pay_0#">
                                    <input type = "hidden" name = "odkes_id_0" value = "#attributes.odkes_id_0#">
                                    <input type = "hidden" name = "period_years" value = "#attributes.period_year#">
                                    <input type = "hidden" name = "start_mon" value = "#attributes.start_mon#">
                                    <input type = "hidden" name = "finish_mon" value = "#attributes.finish_mon#">
                                    <input type = "hidden" name = "position_id" value = "#attributes.position_id#">
                                    <input type = "hidden" name = "collor_type" value = "#attributes.collor_type#">
                                    <input type = "hidden" name = "branch_id" value = "#attributes.branch_id#">
                                    <input type = "hidden" name = "duty_type" value = "#attributes.duty_type#">
                                    <input type = "hidden" name = "function_unit" value = "#attributes.function_unit#">
                                    <input type = "hidden" name = "title_id" value = "#attributes.title_id#">
                                    <input type = "hidden" name = "inout_statue" value = "#attributes.inout_statue#">                                    
                                    <input name="is_submit" id="is_submit" value="1" type="hidden">
                                </cfoutput>
				                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58587.Devam Etmek Istediğinizden Eminmisiniz'></cfsavecontent>
                                <cf_workcube_buttons is_upd='0' insert_alert="#message#">
                            </td>
                        </tr>
                        <!-- sil -->
                    </tfoot>
                <cfelse>
                    <tr>
                        <td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                    </tr>
                </cfif>
            </cfform>
        </tbody>
    <cfelse>
        <tbody>
            <tr>
                <td colspan="4"><!-- sil --><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<!-- sil --></td>
            </tr>
        </tbody>
    </cfif>
</cf_report_list>
<cfset adres="#attributes.fuseaction#&is_submit=1">
<cfif isdefined("attributes.position_id") and len(attributes.position_id)>
    <cfset adres="#adres#&position_id=#attributes.position_id#">
</cfif>
<cfif isdefined("attributes.start_mon") and len(attributes.start_mon)>
    <cfset adres="#adres#&start_mon=#attributes.start_mon#">
</cfif>
<cfif isdefined("attributes.finish_mon") and len(attributes.finish_mon)>
    <cfset adres="#adres#&finish_mon=#attributes.finish_mon#">
</cfif>
<cfif isdefined("attributes.period_year") and len(attributes.period_year)>
    <cfset adres="#adres#&period_year=#attributes.period_year#">
</cfif>
<cfif isdefined("attributes.odkes_id_0") and len(attributes.odkes_id_0)>
    <cfset adres="#adres#&odkes_id_0=#attributes.odkes_id_0#">
</cfif>
<cfif isdefined("attributes.comment_pay_0") and len(attributes.comment_pay_0)>
    <cfset adres="#adres#&comment_pay_0=#attributes.comment_pay_0#">
</cfif>
<cfif isdefined("attributes.inout_statue") and len(attributes.inout_statue)>
    <cfset adres="#adres#&inout_statue=#attributes.inout_statue#">
</cfif>
<cfif isdefined("attributes.function_unit") and len(attributes.function_unit)>
    <cfset adres="#adres#&function_unit=#attributes.function_unit#">
</cfif>
<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
    <cfset adres="#adres#&title_id=#attributes.title_id#">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
    <cfset adres="#adres#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
    <cfset adres="#adres#&duty_type=#attributes.duty_type#">
</cfif>
<cfif isdefined("attributes.collor_type") and len(attributes.collor_type)>
    <cfset adres="#adres#&collor_type=#attributes.collor_type#">
</cfif>
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
    <cfset adres="#adres#&startdate=#attributes.startdate#">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
    <cfset adres="#adres#&finishdate=#attributes.finishdate#">
</cfif>
<cfif isdefined("get_add_all.recordcount") and get_add_all.recordcount gt attributes.maxrows>
    <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#get_add_all.recordcount#" 
        startrow="#attributes.startrow#"
        adres="#adres#">
</cfif>
<script type="text/javascript">
    //Ek Ödenek Ekleme Popup standart kullanım
    function add_row(is_damga,is_issizlik,ssk,tax,is_kidem,show,comment_pay,period_pay,method_pay,term,start_sal_mon,end_sal_mon,amount_pay,calc_days,from_salary,row_id_,ehesap,ayni_yardim,ssk_exemption_rate,tax_exemption_rate,tax_exemption_value,money,odkes_id,ssk_exemption_type)
	{
        document.getElementById('odkes_id_0').value = odkes_id;
        document.getElementById('comment_pay_0').value=comment_pay;
    }
    function del_row(emp_id)//Satır silme fonksiyonu
    {
        $( "[id = '"+emp_id+"']" ).each(function( index ) {
            $( this ).remove();
        });
    }
    
    $('#check_all').click(function(event) {   
        if(this.checked) {
            // Iterate each checkbox
            $(':checkbox').each(function() {
                this.checked = true;                        
            });
        } else {
            $(':checkbox').each(function() {
                this.checked = false;                       
            });
        }
    });    
</script>