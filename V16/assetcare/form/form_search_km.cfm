<cf_xml_page_edit fuseact="assetcare.form_search_km">
<cfinclude template="../query/get_usage_purpose.cfm">
<cfinclude template="../query/get_assetp_groups.cfm">
<cfinclude template="../query/get_branch.cfm">
<cfparam name="attributes.assetp_id" default="">
<cfparam name="attributes.assetp_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.usage_purpose_id" default="">
<cfparam name="attributes.assetp_group" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_assetp" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT 
        POSITION_CAT,
        POSITION_CAT_ID
	FROM 
		SETUP_POSITION_CAT
	WHERE
		POSITION_CAT_STATUS =1
	ORDER BY 
		POSITION_CAT 
</cfquery>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_km" method="post" action="#request.self#?fuseaction=assetcare.form_search_km" onSubmit="return(kontrol());">
            <cf_box_search>
                <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
                        <input type="text" name="assetp_name" id="assetp_name" placeholder="<cfoutput>#getLang(1656,'Plaka',29453)#</cfoutput>" value="<cfoutput>#attributes.assetp_name#</cfoutput>" style="width:130px;">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=search_km.assetp_id&field_name=search_km.assetp_name');"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="branch_id"  id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
                        <input type="text" name="branch" id="branch" placeholder="<cfoutput>#getLang(41,'Şube',57453)#</cfoutput>" value="<cfoutput>#attributes.branch#</cfoutput>" style="width:130px;">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_km.branch_id&field_branch_name=search_km.branch');"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                        <input type="text" name="employee_name" id="employee_name" placeholder="<cfoutput>#getLang(132,'Sorumlu',57544)#</cfoutput>" id="employee_name" value="<cfoutput>#attributes.employee_name#</cfoutput>" style="width:130px;" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_km.employee_id&field_name=search_km.employee_name&select_list=1&branch_related</cfoutput>')"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message1"><cf_get_lang dictionary_id ='30122.Başlangıç Tarihini Kontrol Ediniz '>!</cfsavecontent>
                        <cfinput type="text" name="start_date" placeholder="#getLang(243,'Başlama Tarihi',57655)#" value="#attributes.start_date#" validate="#validate_style#" message="#message1#" maxlength="10" style="width:100px">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span><!---  date_form="search_km" --->
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message2"><cf_get_lang dictionary_id ='30123.Bitiş Tarihini Kontrol Ediniz'> !</cfsavecontent>
                        <cfinput type="text" name="finish_date" placeholder="#getLang(288,'Bitiş Tarihi',57700)#" value="#attributes.finish_date#" validate="#validate_style#" message="#message2#" maxlength="10" style="width:100px">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span><!---  date_form="search_km" --->
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='kontrol()'>
                </div>	
            </cf_box_search>
            <cf_box_search_detail>                
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <cfif xml_usage_purpose_id eq 1>
                        <div class="form-group" id="item-usagepurpose">
                            <label class="col col-12"><cf_get_lang dictionary_id='47901.Kullanım Amacı'></label>
                            <div class="col col-12">
                                <select name="usage_purpose_id" id="usage_purpose_id" style="width:130px;">
                                    <option value=""></option>
                                    <cfoutput query="get_usage_purpose">
                                        <option value="#usage_purpose_id#" <cfif usage_purpose_id eq attributes.usage_purpose_id>selected</cfif>>#usage_purpose#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
                    <cfif xml_department_id eq 1>
                        <div class="form-group" id="item-department">
                            <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="department_id" id="department_id" value="">
                                    <input type="text" name="department" id="department" value="" style="width:130px;">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=search_km.department_id&field_dep_branch_name=search_km.department');"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                    <cfif xml_position_cat_id eq 1>
                        <div class="form-group" id="item-position_cat_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                            <div class="col col-12">
                                <select name="position_cat_id" id="position_cat_id" style="width:130px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_position_cats">
                                        <option value="#position_cat_id#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
                    <cfif xml_assetp_group eq 1>
                        <div class="form-group" id="item-assetp_group">
                            <label class="col col-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
                            <div class="col col-12">
                                <select name="assetp_group"  id="assetp_group" style="width:130px;">
                                    <option value=""></option>
                                    <cfoutput query="get_assetp_groups">
                                        <option value="#group_id#" <cfif attributes.assetp_group eq group_id>selected</cfif>>#group_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-is_assetp">                        
                        <div class="col col-12">
                            <label class="col col-12"><input name="is_assetp" id="is_assetp" type="checkbox" value="1" <cfif attributes.is_assetp eq 1>checked</cfif>>  <cf_get_lang dictionary_id='48107.Plaka Bazında Grupla'></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_allocated">                        
                        <div class="col col-12">
                            <label class="col col-12"><input name="is_allocated" id="is_allocated" type="checkbox" value="1" <cfif isdefined("attributes.is_allocated") and attributes.is_allocated eq 1>checked</cfif>><cf_get_lang dictionary_id='47992.Araç Tahsis'></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_offtime">
                       
                        <div class="col col-12">
                            <label class="col col-12"> <input name="is_offtime" id="is_offtime" type="radio" value="1" checked><cf_get_lang dictionary_id='58081.Hepsi'></label>
                             <label class="col col-12"><input name="is_offtime" id="is_offtime" type="radio" value="2" <cfif isDefined("attributes.is_offtime") and attributes.is_offtime eq 2>checked</cfif>><cf_get_lang dictionary_id='48237.Mesai İçi'></label>
                             <label class="col col-12"><input name="is_offtime" id="is_offtime" type="radio" value="3" <cfif isDefined("attributes.is_offtime") and attributes.is_offtime eq 3>checked</cfif>><cf_get_lang dictionary_id='48229.Mesai Dışı'></label>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(173,'KM Arama',48044)#" uidrop="1" hide_table_column="1">        
        <cfinclude template="../display/list_km_search.cfm">        
        <cfset url_str = "">
        <cfif len(attributes.assetp_id)>
            <cfset url_str = "#url_str#&emp_id=#attributes.assetp_id#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if($('#maxrows').val() > 200)
	{
		alert("<cf_get_lang dictionary_id ='57537.Kayıt Sayısı Hatalı'>");
		return false;
	}
	
	if(!CheckEurodate($('#start_date').val(),"<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>"))
	{
		return false;
	}
	
	if(!CheckEurodate($('#finish_date').val(),"<cf_get_lang dictionary_id ='57700.Bitiş Tarihi'>"))
	{
		return false;
	}

	if($('#start_date').val() != '' && $('#finish_date').val() != '' && (!date_check(document.search_km.start_date,document.search_km.finish_date,"<cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!")))
	{
		return false;
	}
	return true;
	
}
</script>