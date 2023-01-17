<cf_xml_page_edit fuseact="salesplan.popup_add_sales_zones_team" is_multi_page="1">
<cfinclude template="../query/get_sales_zone.cfm">
<cfif not session.ep.ehesap>
	<cfquery name="CONTROL_BRANCH" datasource="#DSN#">
		SELECT
			BRANCH_ID
		FROM
			EMPLOYEE_POSITION_BRANCHES
		WHERE
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
			BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_zone.responsible_branch_id#">
	</cfquery>
	<cfif not control_branch.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='17.Bu Satış Bölgesinde İşlem Yetkiniz Bulunmamaktadır'>!");
			history.back();
		</script>
	</cfif>
</cfif>
<cfinclude template="../query/get_sales_zone_hierarchy.cfm">
<cfif xml_select_upper_team>
    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#DSN#">
        SELECT DISTINCT
            UST_TAKIM.TEAM_ID, 
            UST_TAKIM.TEAM_NAME, 
            UST_TAKIM.SALES_ZONES, 
            UST_TAKIM.OZEL_KOD, 
            UST_TAKIM.RESPONSIBLE_BRANCH_ID, 
            UST_TAKIM.LEADER_POSITION_CODE, 
            UST_TAKIM.LEADER_POSITION_ROLE_ID, 
            UST_TAKIM.COUNTRY_ID, 
            UST_TAKIM.CITY_ID,
          <!---   UST_TAKIM.COUNTY_ID, 
            UST_TAKIM.DISTRICT_ID,  --->
            UST_TAKIM.RECORD_DATE, 
            UST_TAKIM.RECORD_EMP, 
            UST_TAKIM.RECORD_IP, 
            UST_TAKIM.UPDATE_DATE, 
            UST_TAKIM.UPDATE_EMP, 
            UST_TAKIM.UPDATE_IP, 
            UST_TAKIM.COMPANY_CAT_IDS, 
            UST_TAKIM.CONSUMER_CAT_IDS,
            UST_TAKIM.UPPER_TEAM_ID
            <cfif isdefined("attributes.upper_filter") and attributes.upper_filter neq 1>
            ,ALT_TAKIM.TEAM_ID AS TEAM_ID2, 
            ALT_TAKIM.TEAM_NAME AS TEAM_NAME2, 
            ALT_TAKIM.SALES_ZONES AS SALES_ZONES2, 
            ALT_TAKIM.OZEL_KOD AS OZEL_KOD2, 
            ALT_TAKIM.RESPONSIBLE_BRANCH_ID AS RESPONSIBLE_BRANCH_ID2, 
            ALT_TAKIM.LEADER_POSITION_CODE AS LEADER_POSITION_CODE2, 
            ALT_TAKIM.LEADER_POSITION_ROLE_ID AS LEADER_POSITION_ROLE_ID2, 
            ALT_TAKIM.COUNTRY_ID AS COUNTRY_ID2, 
            ALT_TAKIM.CITY_ID AS CITY_ID2,
           <!---  ALT_TAKIM.COUNTY_ID AS COUNTY_ID2,  --->
           <!---  ALT_TAKIM.DISTRICT_ID AS DISTRICT_ID2,  --->
            ALT_TAKIM.RECORD_DATE AS RECORD_DATE2, 
            ALT_TAKIM.RECORD_EMP AS RECORD_EMP2, 
            ALT_TAKIM.RECORD_IP AS RECORD_IP2, 
            ALT_TAKIM.UPDATE_DATE AS UPDATE_DATE2, 
            ALT_TAKIM.UPDATE_EMP AS UPDATE_EMP2, 
            ALT_TAKIM.UPDATE_IP AS UPDATE_IP2, 
            ALT_TAKIM.COMPANY_CAT_IDS AS COMPANY_CAT_IDS2, 
            ALT_TAKIM.CONSUMER_CAT_IDS AS CONSUMER_CAT_IDS2,
            ALT_TAKIM.UPPER_TEAM_ID AS UPPER_TEAM_ID2
            </cfif> 
         FROM 
            SALES_ZONES_TEAM ALT_TAKIM RIGHT JOIN
            SALES_ZONES_TEAM UST_TAKIM
        ON
            ALT_TAKIM.UPPER_TEAM_ID = UST_TAKIM.TEAM_ID
        WHERE 
            UST_TAKIM.SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> AND UST_TAKIM.UPPER_TEAM_ID IS NULL 
        ORDER BY 
            UST_TAKIM.TEAM_NAME
    </cfquery>
<cfelse>
    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#DSN#">
        SELECT
            TEAM_ID, 
            TEAM_NAME, 
            SALES_ZONES, 
            OZEL_KOD, 
            RESPONSIBLE_BRANCH_ID, 
            LEADER_POSITION_CODE, 
            LEADER_POSITION_ROLE_ID, 
            COUNTRY_ID, 
            CITY_ID,
           <!---  COUNTY_ID, 
            DISTRICT_ID,  --->
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            COMPANY_CAT_IDS, 
            CONSUMER_CAT_IDS,
            UPPER_TEAM_ID
        FROM 
            SALES_ZONES_TEAM
        WHERE 
            SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> 
        ORDER BY 
            TEAM_NAME
    </cfquery>
</cfif>
<cfquery name="GET_SALES_SUB_ZONE" datasource="#DSN#">
	SELECT 
		SZ_NAME, 
		SZ_ID,
		SZ_HIERARCHY,
		IS_ACTIVE,
		RESPONSIBLE_BRANCH_ID,
		B.BRANCH_NAME
	FROM 
		SALES_ZONES,
		BRANCH B
	WHERE 
		SZ_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> AND 
		SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_zone.sz_hierarchy#.%"> AND
		B.BRANCH_ID = SALES_ZONES.RESPONSIBLE_BRANCH_ID
</cfquery>
<cf_catalystHeader>
    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <!---Bolge planlama detay --->
        <cfsavecontent variable="head"><cf_get_lang dictionary_id='47074.Bölge Planlama'> <cf_get_lang dictionary_id='57771.Detay'></cfsavecontent>
        <cf_box title="#head#" closable="0">
            <cfform name="detail_sales_zone" method="post" action="#request.self#?fuseaction=salesplan.emptypopup_upd_sales_zone">
            <cf_box_elements vertical="1">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_active">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'> 
                                <input name="is_active" id="is_active" type="checkbox" value="1" <cfif get_sales_zone.is_active eq 1>checked="checked"</cfif>>
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-sz_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57659.satis bölgesi'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="sz_name" value="#get_sales_zone.sz_name#" required="Yes">
                                <span class="input-group-addon btnPointer"><cf_language_info 
                                    table_name="SALES_ZONES" 
                                    column_name="SZ_NAME" 
                                    column_id_value="#attributes.sz_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="SZ_ID" 
                                    control_type="0"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ozel_kod">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="ozel_kod" id="ozel_kod"
                            value="<cfoutput>#get_sales_zone.ozel_kod#</cfoutput>" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-responsible_branch_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41457.İlgili Şube'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="responsible_branch_id" id="responsible_branch_id" value="<cfoutput>#get_sales_zone.responsible_branch_id#</cfoutput>">
                                    <cfif len(get_sales_zone.responsible_branch_id)>
                                    <cfquery name="GET_BRANCH" datasource="#DSN#">
                                        SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #get_sales_zone.responsible_branch_id#
                                    </cfquery>
                                    <input name="responsible_branch" type="text" id="responsible_branch" onFocus="AutoComplete_Create('responsible_branch','BRANCH_NAME','BRANCH_NAME','get_branch_name','','BRANCH_ID','responsible_branch_id','','3','150');" value="<cfoutput>#get_branch.branch_name#</cfoutput>" autocomplete="off">
                                    <cfelse>
                                    <input name="responsible_branch" type="text" id="responsible_branch" onFocus="AutoComplete_Create('responsible_branch','BRANCH_NAME','BRANCH_NAME','get_branch_name','','BRANCH_ID','responsible_branch_id','','3','150');" autocomplete="off">
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=detail_sales_zone.responsible_branch_id&field_branch_name=detail_sales_zone.responsible_branch');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-responsible_position_code">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41458.Bölge Yöneticisi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="responsible_position_code" id="responsible_position_code" value="<cfoutput>#get_sales_zone.responsible_position_code#</cfoutput>">
                                <input type="text" name="responsible_position" id="responsible_position" value="<cfoutput>#get_emp_info(get_sales_zone.responsible_position_code,1,0)#</cfoutput>" onFocus="AutoComplete_Create('responsible_position','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\'','POSITION_CODE,COMPANY_ID,CONSUMER_ID','responsible_position_code,responsible_cmp_id,responsible_consumer_id','','3','150');" style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=detail_sales_zone.responsible_position_code&field_name=detail_sales_zone.responsible_position');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-sz_hierarchy">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41448.Üst Bölge'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif listlen(get_sales_zone.sz_hierarchy, ".")>
                                <cfset temp = listdeleteat(get_sales_zone.sz_hierarchy, listlen(get_sales_zone.sz_hierarchy, "."), ".")>
                            <cfelse>
                                <cfset temp = "">
                            </cfif>
                            <input type="hidden" name="old_hierarchy" id="old_hierarchy" value="<cfoutput>#get_sales_zone.sz_hierarchy#</cfoutput>">
                            <select name="sz_hierarchy" id="sz_hierarchy">
                                <option value="0,0"><cf_get_lang dictionary_id ='41611.Üst Bölge Seçiniz'></option>
                                <cfoutput query="get_sales_zone_hierarchy">
                                    <option value="#sz_hierarchy#,#sz_id#" <cfif temp is sz_hierarchy>selected</cfif>>#sz_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-key_account_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41455.Key Account'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_sales_zone.key_account_id)>
                                    <cfset attributes.company_id = get_sales_zone.key_account_id>
                                    <cfinclude template="../query/get_company_name.cfm">
                                    <input type="hidden" name="key_account_id" id="key_account_id" value="<cfoutput>#get_sales_zone.key_account_id#</cfoutput>">
                                    <input name="key_account" type="text" id="key_account" onFocus="AutoComplete_Create('key_account','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1','MEMBER_ID','key_account_id','','3','250');" value="<cfoutput>#get_company_name.fullname#</cfoutput>" autocomplete="off">
                                <cfelse>
                                    <input type="hidden" name="key_account_id" id="key_account_id" value="">
                                    <input name="key_account" type="text" id="key_account" onFocus="AutoComplete_Create('key_account','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1','MEMBER_ID','key_account_id','','3','250');" value="" autocomplete="off">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=detail_sales_zone.key_account&field_comp_id=detail_sales_zone.key_account_id&select_list=2,6');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-member_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41456.İş Ortağı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="member_type" id="member_type" value="">
                                <input type="hidden" name="responsible_company_id" id="responsible_company_id" value="<cfoutput>#get_sales_zone.responsible_company_id#</cfoutput>">
                                <cfif len(get_sales_zone.responsible_company_id)>
                                    <cfset attributes.company_id = get_sales_zone.responsible_company_id>
                                    <cfinclude template="../query/get_company_name.cfm">
                                    <input type="text" name="responsible_company" id="responsible_company" value="<cfoutput>#get_company_name.fullname#</cfoutput>" onFocus="AutoComplete_Create('responsible_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2,3\'','COMPANY_ID,MEMBER_PARTNER_NAME2,PARTNER_CODE,MEMBER_TYPE','responsible_company_id,responsible_par,responsible_par_id,member_type','','3','250','return_company()');">
                                <cfelse>
                                    <input type="text" name="responsible_company" id="responsible_company" value="" onFocus="AutoComplete_Create('responsible_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2,3\'','COMPANY_ID,MEMBER_PARTNER_NAME2,PARTNER_CODE,MEMBER_TYPE','responsible_company_id,responsible_par,responsible_par_id,member_type','','3','250','return_company()');">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=detail_sales_zone.responsible_par_id&field_name=detail_sales_zone.responsible_par&field_comp_name=detail_sales_zone.responsible_company&field_comp_id=detail_sales_zone.responsible_company_id');return false;"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-responsible_par_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41459.İş Ortağı Çalışan'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="hidden" name="responsible_par_id" id="responsible_par_id" value="<cfoutput>#get_sales_zone.responsible_par_id#</cfoutput>">
                            <cfif len(get_sales_zone.responsible_par_id)>
                                <cfinput type="text" name="responsible_par" id="responsible_par" value="#get_par_info(get_sales_zone.responsible_par_id,0,-1,0)#" readonly="true">
                            <cfelse>
                                <cfinput type="text" name="responsible_par" id="responsible_par" value="" readonly="true">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-sz_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="sz_detail" id="sz_detail"><cfoutput>#get_sales_zone.sz_detail#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6">
                    <cf_record_info query_name='get_sales_zone'>
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function='check()'>
                </div>
            </cf_box_footer>
            <input type="hidden" name="sz_id" id="sz_id" value="<cfoutput>#attributes.sz_id#</cfoutput>">
            </cfform>
        </cf_box>   
        <cfif isdefined('upper_filter')>
            <cfset sz_team_box_page = '#request.self#?fuseaction=salesplan.dsp_sales_zones_team&sz_id=#attributes.sz_id#&upper_filter=#attributes.upper_filter#'>
        <cfelse>
            <cfset sz_team_box_page = '#request.self#?fuseaction=salesplan.dsp_sales_zones_team&sz_id=#attributes.sz_id#&upper_filter=1'>
        </cfif>
        <cf_box 
            title="#getLang('','Satış Takımları',57803)#" 
            id="sales_zones_team" 
            closable="0" 
            add_href='#request.self#?fuseaction=salesplan.list_sales_team&event=add&sz_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#'
            box_page="#sz_team_box_page#">
        </cf_box>
    </div>
    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <cfsavecontent variable="text"><cf_get_lang dictionary_id='41545.Satış Bölgesi Ekibi'></cfsavecontent>
        <cf_box id="zone_team_" 
            title="#text#"
            add_href="openBoxDraggable('#request.self#?fuseaction=salesplan.popup_form_add_worker&sz_id=#url.sz_id#','','ui-draggable-box-small')"
            box_page="#request.self#?fuseaction=salesplan.zone_team&sz_id=#attributes.sz_id#"
            closable="0">
            </cf_box>
        <cfsavecontent variable="text"><cf_get_lang dictionary_id='41599.Alt Bölge ve Şubeler'></cfsavecontent>
        <cf_box 
            id="sales_hier" 
            title="#text#" 
            closable="0" 
            style="widows:98%;" 
            box_page="#request.self#?fuseaction=salesplan.dsp_sales_hierarchy&sz_id=#attributes.sz_id#">
        </cf_box>
        <cfsavecontent variable="text"><cf_get_lang dictionary_id='41501.Satış Hedefleri'></cfsavecontent>
        <cf_box 
            id="sales_target" 
            title="#text#" 
            closable="0" 
            style="widows:98%;" 
            box_page="#request.self#?fuseaction=salesplan.list_sales_target_link&sz_id=#attributes.sz_id#">
        </cf_box>
        
        <!--- Notlar --->
        <cf_get_workcube_note company_id="#session.ep.company_id#" action_section='SZ_ID' action_id='#attributes.SZ_ID#'>
        <!--- Varlıklar --->
        <cf_get_workcube_asset asset_cat_id="-18" module_id='11' action_section='SZ_ID' action_id='#attributes.SZ_ID#'>
    </div>
<script type="text/javascript">
	function check()
	{
		if ((detail_sales_zone.responsible_position_code.value == "") || (detail_sales_zone.responsible_position.value == ""))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='41458.Bölge Yöneticisi'>");
			return false;
		}
		
		if((detail_sales_zone.responsible_branch.value=="") || (detail_sales_zone.responsible_branch_id.value==""))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='41457.İlgili Şube'>");
			return false;
		}
		return true;	
	}
		function return_company()
	{	
		if(document.getElementById('member_type').value=='employee')
		{	
			var pos_id=document.getElementById('responsible_par_id').value;
			var GET_COMPANY = wrk_safe_query('slsp_get_compny','dsn',0,pos_id);
			document.getElementById('responsible_company_id').value=GET_COMPANY.COMP_ID;
		}
		 if(document.getElementById('member_type').value=='consumer')
		{
			var responsible_name=document.getElementById('responsible_par_id').value;
			var GET_COMPANY_NAME=wrk_safe_query('slsp_get_cmp_name','dsn',0,responsible_name);
			if(GET_COMPANY_NAME.COMPANY!=undefined)
				document.getElementById('responsible_company').value=GET_COMPANY_NAME.COMPANY;
		}
		else
			return false;
	}
</script>
