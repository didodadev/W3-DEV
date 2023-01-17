<!---Select İfadeleri Düzenlendi 19072012 E.A--->
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.is_date_filter" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.close_method" default="">
<cfquery name="GET_MONEY" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfset xml_page_control_list = 'is_revenue_duedate'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1" fuseact="ch.list_company_extre,ch.list_comp_extre,ch.list_extre,ch.dsp_make_age">
<cfif not isdefined("is_revenue_duedate")>
	<cfset is_revenue_duedate = 0>
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset comp_id = attributes.company_id>
	<cfset cons_id = "">
	<cfset comp_name = get_par_info(attributes.company_id,1,1,0)>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset comp_id = "">
	<cfset cons_id = attributes.consumer_id>
	<cfset comp_name = get_cons_info(attributes.consumer_id,0,0)>
<cfelse>
	<cfset cons_id = "">
	<cfset comp_id = "">
	<cfset comp_name = "">
</cfif>
<cfif isdefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
	<cf_date tarih = "attributes.due_date_1">
</cfif>
<cfif isdefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
	<cf_date tarih = "attributes.due_date_2">
</cfif>
<cfif isdefined("attributes.action_date_1") and isdate(attributes.action_date_1)>
	<cf_date tarih = "attributes.action_date_1">
</cfif>
<cfif isdefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
	<cf_date tarih = "attributes.action_date_2">
</cfif>
<cfset is_make_age_date = 1>
<cfif is_make_age_date>
	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
		<cf_date tarih = "attributes.date1">
	<cfelse>
		<cfset date1= "01/01/#session.ep.period_year#">
		<cfparam name="attributes.date1" default="#date1#">
	</cfif>
	<cfif isdefined('attributes.date2') and isdate(attributes.date2)>
		<cf_date tarih = "attributes.date2">
	<cfelse>
		<cfif validate_style eq "eurodate"><cfset date2 = "31/12/#session.ep.period_year#"><cfelse><cfset date2 = "12/31/#session.ep.period_year#"></cfif>
		<cfparam name="attributes.date2" default="#date2#">
	</cfif>
</cfif>


<cfif compare(comp_name,"")>
	<cfset pageHead = #getLang('campaign', 68)# & " : " & comp_name> 
<cfelse>
	<cfset pageHead = #getLang('campaign', 68)# >
</cfif>
<cfsavecontent variable="right_"><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module="dsp_make_age_div" is_ajax="1" isAjaxPage='1' noShow='noShow1'></cfsavecontent>

<cf_catalystHeader>
<cfform name="cari" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
	<div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 107)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="action_date_1" id="action_date_1" value="">
                                    <input type="hidden" name="action_date_2" id="action_date_2" value="">
                                    <input type="hidden" name="is_date_filter" id="is_date_filter" value="">
                                    <input type="hidden" name="is_duedate_group" id="is_duedate_group" value="">
                                    <input type="hidden" name="due_date_2" id="due_date_2" value="">
                                    <input type="hidden" name="due_date_1" id="due_date_1" value="">
                                    <input type="hidden" name="other_money_2" id="other_money_2" value="">
                                    <input type="hidden" name="acc_code" id="acc_code" value="">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#comp_id#</cfoutput>">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#cons_id#</cfoutput>">
                                    <cfinput type="text" name="comp_name" id="comp_name" value="#comp_name#" style="width:120px;" required="Yes" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=cari.company_id&field_comp_name=cari.comp_name&field_code=cari.acc_code&field_name=cari.comp_name&field_consumer=cari.consumer_id</cfoutput>','list')" title="<cfoutput>#getLang('main', 107)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-close_method">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('ch', 137)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <select name="close_method" id="close_method" style="width:130px">
                                    <option value="0" <cfif isdefined("attributes.close_method") and attributes.close_method eq 0>selected</cfif>><cfoutput>#getLang('ch',136)#</cfoutput></option>
                                    <option value="1" <cfif isdefined("attributes.close_method") and attributes.close_method eq 1>selected</cfif>><cfoutput>#getLang('ch',135)#</cfoutput></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <cfif is_make_age_date>
                            <div class="form-group" id="item-date1">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 641)#</cfoutput></label>
                                <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="date1" value="#date1#" required="yes" validate="#validate_style#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <cfif is_make_age_date>
                            <div class="form-group" id="item-date2">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 288)#</cfoutput></label>
                                <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="date2" value="#date2#" required="yes" validate="#validate_style#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-is_doviz_group">
                            <label class="col col-12"><cfoutput>#getLang('ch',195)#</cfoutput><input type="checkbox" name="is_doviz_group" id="is_doviz_group" <cfif isdefined('attributes.is_doviz_group')>checked</cfif>></label>
                        </div>
                        <div class="form-group" id="item-is_cheque_duedate">
                            <label class="col col-12"><cfoutput>#getLang('main',756)#</cfoutput><input type="checkbox" name="is_cheque_duedate" id="is_cheque_duedate" <cfif isdefined('attributes.is_cheque_duedate')>checked</cfif>></label>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cfsavecontent variable="message"><cf_get_lang_main no='238.Dök'></cfsavecontent> 
                        <cf_workcube_buttons is_upd='0' insert_alert='' insert_info='#message#' add_function='kontrol()'>
                    </div>
                </div>
            </div>
        </div> 
	</div>
</cfform>
<div id="dsp_make_age_div">
<cfif isdefined("attributes.close_method") and attributes.close_method eq 0>
	<cfinclude template="../../objects/display/dsp_make_age.cfm">
<cfelseif isdefined("attributes.close_method") and attributes.close_method eq 1>
	<cfinclude template="../../objects/display/dsp_make_age_manuel.cfm">
</cfif>
</div>
<script type="text/javascript">
	function kontrol(){
		if(!$("#comp_name").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang no='99.Cari Hesap Seçmelisiniz !'></cfoutput>"})    
			return false;
		}
		if(!$("#date1").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang_main no='326.Baslangiç Tarihi Girmelisiniz !'></cfoutput>"})    
			return false;
		}
		if(!$("#date2").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz !'></cfoutput>"})    
			return false;
		}
	}
</script>