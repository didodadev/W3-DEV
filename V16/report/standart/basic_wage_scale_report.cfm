
<!---
File: get_wage_scale.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:25.09.2019
Controller: -
Description: Temel Ücret Skalası Raporlama Sayfasıdır.
--->
<cfparam name="attributes.position_id" default="">
<cfparam name="attributes.min_salary" default="">
<cfparam name="attributes.max_salary" default="">
<cfparam name="attributes.maxrows" default=20>
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.totalrecords" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.year" default="#session.ep.period_year#">
<cfset get_component = createObject('component','V16.hr.cfc.wage_scale')><!--- Temel Ücret Skalası. --->
<cfset periods = createObject('component','V16.objects.cfc.periods')><!--- Period yılları çekiliyor. --->
<cfset period_years = periods.get_period_year()>
<cfif isdefined("attributes.is_submit")>
    <cfset get_scale = get_component.GET_WAGE_SCALE(
                                    position_id : len(attributes.position_id) ? "#attributes.position_id#" : "",
                                    min_salary :  len(attributes.min_salary) ? "#attributes.min_salary#" : "",
                                    max_salary :  len(attributes.max_salary) ? "#attributes.max_salary#" : "",
                                    maxrows : attributes.maxrows,
                                    startrow : attributes.page,
                                    year : attributes.year
                        )>
    <cfparam name="attributes.totalrecords" default='#get_scale.recordcount#'>
</cfif>
<cfsavecontent variable = "title"><cf_get_lang dictionary_id="51187.Temel Ücret Skalası"></cfsavecontent>
<cfset get_position_cat = get_component.GET_POSITION_CAT()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="search_scale" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
        <cf_box title="#title#">
            <cf_box_search>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'> * </label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="year" id="year">
                                <cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
                                    <cfoutput>
                                        <option value="#i#" <cfif attributes.year eq i>selected </cfif> >#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="position_id">
                                <option value = ""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                <cfoutput query = "get_position_cat">
                                    <option value = "#position_cat_id#" <cfif attributes.position_id eq position_cat_id>selected</cfif>>#position_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51188.En Düşük Ücret'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="min_salary" id="min_salary" value="<cfif isdefined("attributes.min_salary")><cfoutput><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(attributes.min_salary)#"></cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51193.En yüksek Ücret'></label>
                        <div class="col col-8 col-md-8 col sm-8 col-xs-12">	
                            <input type="text" name="max_salary" id="max_salary" value="<cfif isdefined("attributes.max_salary")><cfoutput><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(attributes.max_salary)#"></cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                </div>
            </cf_box_search>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 margin-top-5">
                <cf_box_footer>
                        <label class="margin-right-5"><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                        <cfelse>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                        </cfif>
                        <input name="is_submit" id="is_submit" value="1" type="hidden">
                        <cf_wrk_search_button button_type='1' is_excel='1' search_function="kontrol()">
                </cf_box_footer>
            </div>
        </cf_box>
    </cfform>
</div>
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
            <cfset attributes.maxrows=get_scale.recordcount>		
        <cfelse>
            <cfset type_ = 0>
        </cfif>
        <thead>
            <tr> 
                <th width="25"><cf_get_lang dictionary_id='58577.Sira'></th>
                <th ><cf_get_lang dictionary_id='58455.Yıl'></th>
                <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                <th><cf_get_lang dictionary_id='51188.En Düşük Ücret'></th>
                <th><cf_get_lang dictionary_id='51193.En yüksek Ücret'></th>
                <th><cf_get_lang dictionary_id='53131.Brüt'> / <cf_get_lang dictionary_id='58083.Net'></th>
            </tr>
        </thead>
        <tbody>
            <cfif isdefined("get_scale.position_id") and get_scale.recordcount>
                <cfoutput query = "get_scale" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfset get_position_cat_name = get_component.GET_POSITION_CAT(position_id : position_id)><!--- Pozisyon kategorisi --->
                    <tr>
                        <td width="25">#currentrow#</td>
                        <td>#year#</td>
                        <td>#get_position_cat_name.position_cat#</td>
                        <td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(min_salary)#"></td>
                        <td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(max_salary)#"></td>
                        <td><cfif gross_net eq 1><cf_get_lang dictionary_id='58083.Net'><cfelse><cf_get_lang dictionary_id='53131.Brüt'></cfif></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                </tr>
            </cfif>
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
<cfif isdefined("attributes.min_salary") and len(attributes.min_salary)>
    <cfset adres="#adres#&min_salary=#attributes.min_salary#">
</cfif>
<cfif isdefined("attributes.max_salary") and len(attributes.max_salary)>
    <cfset adres="#adres#&max_salary=#attributes.max_salary#">
</cfif>
<cfif isdefined("get_scale.recordcount") and get_scale.recordcount gt attributes.maxrows>
    <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#get_scale.recordcount#" 
        startrow="#attributes.startrow#"
        adres="#adres#">
</cfif>
<script>
    function kontrol(){
        search_scale.min_salary.value = filterNum(search_scale.min_salary.value,2);
        search_scale.max_salary.value = filterNum(search_scale.max_salary.value,2);   
    }
</script>