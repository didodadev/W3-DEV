<cf_xml_page_edit fuseact="myhome.popup_form_upd_assetp_demand">
<cf_get_lang_set module_name="myhome">
<cfquery name="get_assetp_demand" datasource="#dsn#">
	SELECT * FROM ASSET_P_DEMAND WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
</cfquery>
<cfquery name="get_upper_pos_code" datasource="#dsn#">
	SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp_demand.employee_id#"> 
</cfquery>
<cfif len(get_assetp_demand.result_id) and get_assetp_demand.result_id eq 1>
    <cfset valid = 1>
<cfelseif len(get_assetp_demand.result_id) and get_assetp_demand.result_id eq 0>
	<cfset valid = 2>
<cfelse>
	<cfset valid = 0>
</cfif>
<cfinclude template="../query/get_assetp_cats.cfm">
<cfinclude template="../query/get_usage_purpose.cfm">
<cfinclude template="../../correspondence/query/get_brand.cfm">
<cfquery name="get_asset_p_sub_cats" datasource="#dsn#">
	SELECT 
    	ASSETP_SUB_CATID,ASSETP_SUB_CAT 
    FROM 
    	ASSET_P_SUB_CAT 
	<cfif isdefined('get_assetp_demand.assetp_catid') and len(get_assetp_demand.assetp_catid)>
    	WHERE 
        	ASSETP_CATID = #get_assetp_demand.assetp_catid#
	</cfif> ORDER BY ASSETP_SUB_CAT
</cfquery>

<cfif fusebox.circuit eq 'myhome'>
    <cfset action_page = '#request.self#?fuseaction=myhome.list_assetp&event=upd'>
    <cfset popup=1>
<cfelse>
    <cfset action_page = '#request.self#?fuseaction=assetcare.list_assetp_demands&event=upd'>
    <cfset popup=0>
</cfif>
<cf_catalystheader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#getLang('','varlık talepleri','47806')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_assetp_demand" method="post" action="#action_page#">
        <input type="hidden" name="demand_id" id="demand_id" value="<cfoutput>#attributes.demand_id#</cfoutput>">
        <input type="hidden" name="validator_pos_code" id="validator_pos_code" value="">
        <input type="hidden" name="upper_position_code" id="upper_position_code" value="<cfoutput>#get_upper_pos_code.upper_position_code#</cfoutput>">
        <input type="hidden" name="upper_position_code2" id="upper_position_code2" value="<cfoutput>#get_upper_pos_code.upper_position_code2#</cfoutput>">
        <input type="hidden" name="valid_state" id="valid_state" value="<cfoutput>#valid#</cfoutput>">
        <input type="hidden" name="validator_it_position_id" id="validator_it_position_id" value="<cfif len(x_it_code)><cfoutput>#x_it_code#</cfoutput></cfif>">

       <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-status">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57493.Aktif'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                        <input type="checkbox" name="asset_p_status" id="asset_p_status" value="1" <cfif get_assetp_demand.asset_p_status eq 1>checked</cfif>>
                    </div>
                </div>
                <div class="form-group" id="item-cat_id">
                    <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='48388.Varlık Tipi'> *</label>
                    <div class="col col-8 col-xs-8">
                        <select name="cat_id" id="cat_id" onChange="del_brand();">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_assetp_cats">
                                <option value="#assetp_catid#" <cfif get_assetp_demand.assetp_catid eq assetp_catid>selected</cfif>>#assetp_cat#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-assetp_sub_catid">
                    <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></label>
                    <div class="col col-8 col-xs-8">
                        <select name="assetp_sub_catid" id="assetp_sub_catid" style="width:206px;">
                            <option value=""><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></option>
                            <cfoutput query="get_asset_p_sub_cats">
                                <option value="#assetp_sub_catid#" <cfif get_assetp_demand.assetp_sub_catid eq assetp_sub_catid>selected</cfif>>#assetp_sub_cat#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-employee">
                    <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='276.Talep Eden'> *</label>
                    <div class="col col-8 col-xs-8">
                        <div class="input-group">
                            <cfoutput>
                                <cfquery name="get_emp_name" datasource="#dsn#">
                                    SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_assetp_demand.employee_id#
                                </cfquery>
                                <input type="hidden" name="employee_id" id="employee_id" value="#get_assetp_demand.employee_id#">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='276.Talep Eden '> !</cfsavecontent>
                                <cfinput type="text" name="employee" value="#get_emp_name.employee_name# #get_emp_name.employee_surname#" required="yes" message="#message#" readonly="yes" style="width:206px;">
                                <cfif valid neq 1 and valid neq 2>
                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp_demand.employee_id&field_name=add_assetp_demand.employee&upper_pos_code=#session.ep.position_code#&select_list=1','list')"></span>
                                </cfif>
                            </cfoutput>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-usage_purpose_id">
                    <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='56925.Kullanım Amacı'> *</label>
                    <div class="col col-8 col-xs-8">
                        <select name="usage_purpose_id" id="usage_purpose_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_usage_purpose">
                                <option value="#usage_purpose_id#" <cfif get_assetp_demand.usage_purpose_id eq usage_purpose_id>selected</cfif>>#usage_purpose#</option> 
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-process">
                    <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id="58859.Süreç"></label>
                    <div class="col col-8 col-xs-8">
                        <cf_workcube_process is_upd='0' select_value='#get_assetp_demand.stage#' process_cat_width='206' is_detail='1'>
                        <input type="hidden" name="old_stage" id="old_stage" value="<cfoutput>#get_assetp_demand.stage#</cfoutput>" />
                    </div>
                </div>
                <div class="form-group" id="item-rand_name">
                    <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></label>
                    <div class="col col-8 col-xs-8">
                        <cfif isdefined('get_assetp_demand.brand_type_id') and len(get_assetp_demand.brand_type_id)>
                            <cfquery name="get_brand_name" datasource="#DSN#">
                                SELECT
                                    SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
                                    SETUP_BRAND_TYPE.BRAND_TYPE_ID,
                                    SETUP_BRAND_TYPE.BRAND_ID,
                                    SETUP_BRAND.BRAND_NAME
                                FROM
                                    SETUP_BRAND_TYPE,
                                    SETUP_BRAND
                                WHERE
                                    SETUP_BRAND.BRAND_ID = SETUP_BRAND_TYPE.BRAND_ID 
                                    AND SETUP_BRAND_TYPE.BRAND_TYPE_ID = #get_assetp_demand.brand_type_id#
                            </cfquery>
                        </cfif>
                        <cfoutput><input type="hidden" name="brand_type_id" id="brand_type_id" value="#get_assetp_demand.brand_type_id#">
                        <div class="input-group">
                            <input type="text" name="brand_name" id="brand_name" value="<cfif isdefined('get_brand_name.brand_name') and len(get_brand_name.brand_name)>#get_brand_name.brand_name# / #get_brand_name.brand_type_name#</cfif>"></cfoutput>
                            <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="pencere_ac()"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-make_year">
                    <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='58225.Model'></label>
                    <div class="col col-8 col-xs-8">
                        <select name="make_year" id="make_year">
                            <option value=""></option>
                            <cfset yil = dateformat(dateadd("yyyy",1,now()),"yyyy")>
                            <cfoutput>
                                <cfloop from="#yil#" to="1970" index="i" step="-1">
                                    <option value="#i#" <cfif get_assetp_demand.make_year eq i>selected</cfif>>#i#</option>
                                </cfloop>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-process">
                    <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='51084.Talep Tarihi'>*</label>
                    <div class="col col-8 col-xs-8">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57742.Tarih'> !</cfsavecontent>
                        <div class="input-group">
                            <cfinput type="text" name="request_date" value="#dateformat(get_assetp_demand.request_date,dateformat_style)#" maxlength="10" validate="#validate_style#" required="yes" message="#message#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="request_date"></span>
                        </div>
                    </div>
                </div>
                
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                <label style="display:none!important;"><cf_get_lang dictionary_id='57771.Detay'></label>	
                    <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarset="Basic"
                        basepath="/fckeditor/"
                        instancename="detail"
                        valign="top"
                        value="#get_assetp_demand.detail#"
                        width="600"
                        height="180">
                   
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1'delete_page_url="#request.self#?fuseaction=assetcare.emptypopup_del_assetp_demand&demand_id=#attributes.demand_id#&is_popup=#popup#">
        </cf_box_footer>	
        
    </cfform>
</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		return process_cat_control();
	}
	function pencere_ac()
	{
		x = document.add_assetp_demand.cat_id.selectedIndex;
		if (document.add_assetp_demand.cat_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='56930.Varlık Tipi'>!");
			return false;
		}
		else
			y = document.add_assetp_demand.cat_id[x].value;
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand_type&field_brand_type_id=add_assetp_demand.brand_type_id&field_brand_name=add_assetp_demand.brand_name&cat_id=' + y ,'list','popup_list_brand_type');
	}
	function del_brand()
	{
		document.add_assetp_demand.brand_type_id.value = '';
		document.add_assetp_demand.brand_name.value = '';
		for (i=$('#assetp_sub_catid option').length-1 ; i>-1 ; i--)
	{   
	    $('#assetp_sub_catid option')[i].remove();
	}	
		var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = " + $('#cat_id ').val()+" ORDER BY ASSETP_SUB_CAT","dsn");
	
		if(get_assetp_sub_cat.recordcount > 0)
		{
			$("#assetp_sub_catid").append($("<option></option>").attr("value", '').text("Varlık Alt Kategorisi"));
			
			for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
			{
				$("#assetp_sub_catid").append($("<option></option>").attr("value", get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]).text(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1]));

			}
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">