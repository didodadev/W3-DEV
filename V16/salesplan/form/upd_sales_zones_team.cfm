<cf_xml_page_edit fuseact="salesplan.popup_add_sales_zones_team" is_multi_page="1">
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT DISTINCT
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		HIERARCHY
</cfquery>
<cfquery name="GET_SALES_ZONE" datasource="#DSN#">
	SELECT
		SZ_ID,
		SZ_NAME,
		SZ_HIERARCHY,
		RESPONSIBLE_BRANCH_ID
	FROM
		SALES_ZONES
	WHERE
		SZ_ID IS NOT NULL AND
		SZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#">
</cfquery>
<cfquery name="GET_ROL" datasource="#DSN#">
	SELECT
    	PROJECT_ROLES_ID,
        #dsn#.Get_Dynamic_Language(SETUP_PROJECT_ROLES.PROJECT_ROLES_ID,'#session.ep.language#','SETUP_PROJECT_ROLES','PROJECT_ROLES',NULL,NULL,SETUP_PROJECT_ROLES.PROJECT_ROLES) AS PROJECT_ROLES,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP
    FROM
	    SETUP_PROJECT_ROLES
    ORDER BY
    	PROJECT_ROLES
</cfquery>
<cfquery name="GET_SALES_TEAM_COUNTY" datasource="#DSN#">
	SELECT
    	COUNTY_ID
    FROM
    	SALES_ZONES_TEAM_COUNTY
    WHERE
	    TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">
</cfquery>
<!--- <cfquery name="GET_SALES_TEAM_DISTRICT" datasource="#DSN#">
	SELECT
    	DISTRICT_ID
    FROM
    	SALES_ZONES_TEAM_DISTRICT
    WHERE
	    TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">
</cfquery> --->
<cfquery name="GET_SALES_TEAM" datasource="#DSN#">
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
        <!--- COUNTY_ID,
        DISTRICT_ID,   --->
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP,
        COMPANY_CAT_IDS,
        CONSUMER_CAT_IDS ,
        UPPER_TEAM_ID
    FROM
    	SALES_ZONES_TEAM
    WHERE
	    TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">
</cfquery>
<cfquery name="GET_IMS" datasource="#DSN#">
	SELECT
		SETUP_IMS_CODE.IMS_CODE,
		SETUP_IMS_CODE.IMS_CODE_NAME,
		SETUP_IMS_CODE.IMS_CODE_ID
	FROM
		SETUP_IMS_CODE,
		SALES_ZONES_TEAM_IMS_CODE AS SALES_ZONES_TEAM_IMS_CODE
	WHERE
		SALES_ZONES_TEAM_IMS_CODE.TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#"> AND
		SALES_ZONES_TEAM_IMS_CODE.IMS_ID = SETUP_IMS_CODE.IMS_CODE_ID
</cfquery>
<cfquery name="GET_ROLES" datasource="#DSN#">
	SELECT ROLE_ID, POSITION_CODE FROM SALES_ZONES_TEAM_ROLES WHERE TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#team_id#">
</cfquery>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT
		COUNTRY_ID,
		COUNTRY_NAME,
		IS_DEFAULT
	FROM
		SETUP_COUNTRY
	ORDER BY
		COUNTRY_NAME
</cfquery>
<cfquery name="get_upper_teams" datasource="#dsn#">
    SELECT
        TEAM_ID,
        #dsn#.Get_Dynamic_Language(SALES_ZONES_TEAM.TEAM_ID,'#session.ep.language#','SALES_ZONES_TEAM','TEAM_NAME',NULL,NULL,SALES_ZONES_TEAM.TEAM_NAME) AS TEAM_NAME

    FROM
        SALES_ZONES_TEAM
    WHERE
        SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> AND
        TEAM_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">
</cfquery>
<cfquery name="get_sub_teams" datasource="#dsn#">
	SELECT
    	ST.TEAM_NAME,
        ST.TEAM_ID,
        SZ.SZ_ID
    FROM
    	SALES_ZONES_TEAM ST,
        SALES_ZONES SZ
    WHERE
    	SZ.SZ_ID = ST.SALES_ZONES AND
    	UPPER_TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">
</cfquery>
<cfset get_roles_row = get_roles.recordcount>
<cfsavecontent variable="right">
		<a href="<cfoutput>#request.self#?fuseaction=salesplan.popup_add_sales_zones_team&sz_id=#get_sales_team.sales_zones#&branch_id=#get_sales_zone.responsible_branch_id#&team_id=#attributes.team_id#</cfoutput>" title="İçeriği Kopyala"><img src="/images/plus.gif" align="absmiddle" alt="64.İçeriği Kopyala"></a>
	<cfif not listfindnocase(denied_pages,'salesplan.popup_add_sales_zones_team')>
		<a href="<cfoutput>#request.self#?fuseaction=salesplan.popup_add_sales_zones_team&sz_id=#get_sales_team.sales_zones#&branch_id=#get_sales_zone.responsible_branch_id#</cfoutput>"><img src="/images/plus1.gif" align="absmiddle" title="<cf_get_lang dictionary_id ='57582.Ekle'>" border="0"></a>
	</cfif>
</cfsavecontent>
<cf_catalystHeader>    
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Satış Takımları',57803)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="worker" action="#request.self#?fuseaction=salesplan.emptypopup_upd_sales_zones_team" method="post">
            <input type="hidden" name="sz_id" id="sz_id" value="<cfoutput>#attributes.sz_id#</cfoutput>">
            <input type="hidden" name="team_id" id="team_id" value="<cfoutput>#attributes.team_id#</cfoutput>">
            <input type="hidden" name="get_upper_info" id="get_upper_info" value="0" />
            <input type="hidden" name="upd_sub_teams" id="upd_sub_teams" value="0" />
            <cf_box_elements>
                <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-team_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41479.Takım Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="team_name" id="team_name" value="#get_sales_team.team_name#" required="yes">
                        </div>
                    </div>
                    <div class="form-group" id="item-sales_zone">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57659.satis bölgesi'></label>
                        <div class="col col-8 ccol-xs-12">
                            <cfif isdefined("attributes.branch_id") and len (attributes.branch_id)>
                                <input type="hidden" name="sales_zone" id="sales_zone" value="<cfoutput>#get_sales_zone.sz_hierarchy#,#get_sales_zone.sz_id#</cfoutput>">
                                <cfoutput>#get_sales_zone.sz_name#</cfoutput>
                            <cfelse>
                                <cfquery name="GET_SALES_ZONE" datasource="#DSN#">
                                    SELECT
                                        SZ_ID,
                                        SZ_NAME ,
                                        SZ_HIERARCHY
                                    FROM
                                        SALES_ZONES
                                    WHERE
                                        SZ_ID IS NOT NULL
                                </cfquery>
                                <select name="sales_zone" id="sales_zone">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_sales_zone">
                                        <option value="#get_sales_zone.sz_hierarchy#,#get_sales_zone.sz_id#" <cfif get_sales_team.SALES_ZONES eq sz_id>selected</cfif>>#get_sales_zone.sz_name#</option>
                                    </cfoutput>
                                </select>
                            </cfif>   
                        </div>
                    </div>
                    <div class="form-group" id="item-responsible_branch_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41457.İlgili Şube'></label>
                        <div class="col col-8 ccol-xs-12">                            
                            <cfif len(get_sales_team.responsible_branch_id)>
                                <cfif isdefined("attributes.branch_id") and len (attributes.branch_id)>
                                    <cfquery name="GET_BRANCH" datasource="#DSN#">
                                        SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_team.responsible_branch_id#">
                                    </cfquery>
                                    <input type="hidden" name="responsible_branch_id" id="responsible_branch_id" value="<cfoutput>#get_sales_team.responsible_branch_id#</cfoutput>">
                                    <cfoutput>#get_branch.branch_name#</cfoutput>
                                <cfelse>
                                    <cfquery name="GET_BRANCH" datasource="#DSN#">
                                        SELECT BRANCH_NAME,BRANCH_ID FROM BRANCH
                                    </cfquery>
                                    <select name="responsible_branch_id" id="responsible_branch_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="GET_BRANCH">
                                            <option value="#branch_id#" <cfif get_sales_team.responsible_branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                                        </cfoutput>
                                    </select>
                                </cfif>     
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-country_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                        <div class="col col-8 ccol-xs-12">
                            <select name="country_id" id="country_id" onChange="LoadCity(this.value,'city_id','county_id',0)">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_country">
                                    <option value="#get_country.country_id#" <cfif get_sales_team.country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-city_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
                        <div class="col col-8 ccol-xs-12">
                            <select name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id','')">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif len(get_sales_team.country_id) and len(get_sales_team.city_id)>
                                    <cfquery name="GET_CITY" datasource="#DSN#">
                                        SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_team.country_id#">
                                    </cfquery>
                                    <cfoutput query="get_city">
                                        <option value="#get_city.city_id#"<cfif get_sales_team.city_id eq get_city.city_id>selected</cfif>>#get_city.city_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-county_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                        <div class="col col-8 ccol-xs-12">
                            <select name="county_id" id="county_id" style="width:200px;height:80px;" multiple>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif len(get_sales_team.city_id) and len(get_sales_team_county.county_id)>
                                    <cfquery name="GET_COUNTY" datasource="#DSN#">
                                        SELECT
                                            COUNTY_ID,
                                            COUNTY_NAME
                                        FROM
                                            SETUP_COUNTY
                                        WHERE
                                            CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_team.city_id#">
                                        ORDER BY
                                            COUNTY_NAME
                                    </cfquery>
                                    <cfset list_county = ValueList(get_sales_team_county.county_id,',') >
                                    <cfoutput query="get_county">
                                        <option value="#county_id#" <cfif listfind(list_county,get_county.county_id)>selected</cfif>>#get_county.county_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-member_cat_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
                        <div class="col col-8 ccol-xs-12">
                            <select name="member_cat_type" id="member_cat_type" multiple style="width:200px;height:75px;">
                                <optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>"></optgroup>
                                <cfoutput query="get_company_cat">
                                    <option value="1-#companycat_id#" <cfif listfind(get_sales_team.company_cat_ids,'#companycat_id#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option>
                                </cfoutput>
                                <optgroup label="<cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'>"></optgroup>
                                <cfoutput query="get_consumer_cat">
                                    <option value="2-#conscat_id#" <cfif listfind(get_sales_team.consumer_cat_ids,'#conscat_id#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-upper_team">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41446.Üst Takım'></label>
                        <div class="col col-8 ccol-xs-12">
                            <select name="upper_team" id="upper_team">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_upper_teams">
                                    <option value="#get_upper_teams.team_id#" <cfif get_sales_team.upper_team_id eq get_upper_teams.team_id>selected</cfif>>#get_upper_teams.team_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id = "item-leader_position_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41483.Lider'> 1</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="leader_position_code" id="leader_position_code" value="<cfoutput>#get_sales_team.leader_position_code#</cfoutput>">
                                <input type="text" name="leader_position_name" id="leader_position_name" value="<cfif len(get_sales_team.leader_position_code)><cfoutput>#get_emp_info(get_sales_team.leader_position_code,1,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('leader_position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','leader_position_code','','3','135');"   autocomplete="off" style="width:200px;">
                                <cfif get_module_user(47)>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=worker.leader_position_name&field_code=worker.leader_position_code&select_list=1');"></span>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-leader_position_role_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42014.Rol'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="leader_position_role_id" id="leader_position_role_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_rol">
                                    <option value="#project_roles_id#" <cfif get_sales_team.leader_position_role_id eq project_roles_id>selected</cfif>>#project_roles#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-ozel_kod">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ozel_kod" id="ozel_kod" value="<cfif len(get_sales_team.ozel_kod)><cfoutput>#get_sales_team.ozel_kod#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-district_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <select name="district_id" id="district_id" style="width:200px;height:80px;" multiple>
                                    <cfif len(get_sales_team_county.county_id)>
                                        <cfquery name="GET_DISTRICT" datasource="#DSN#">
                                            SELECT
                                                SD.DISTRICT_NAME,
                                                SD.DISTRICT_ID,
                                                SC.COUNTY_NAME
                                            FROM
                                                SETUP_DISTRICT SD,
                                                SETUP_COUNTY SC
                                            WHERE
                                                SD.COUNTY_ID = SC.COUNTY_ID AND
                                                SD.DISTRICT_ID IN (SELECT
                                                                        DISTRICT_ID
                                                                    FROM
                                                                        SALES_ZONES_TEAM_DISTRICT
                                                                    WHERE
                                                                        TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">)
                                            ORDER BY
                                                SD.DISTRICT_NAME
                                        </cfquery>
                                        <!---  <cfset List_District = ValueList(get_district.district_id,',') > --->
                                        <cfoutput query="get_district">
                                        <option value="#district_id#"selected>#county_name# #district_name#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                                <span class="input-group-addon icon-pluss btnPointer" onClick="open_districts();"></span>
                                <span class="input-group-addon icon-minus btnPointer" onClick="ozel_kaldir();"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ims_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41477.IMS Kodları'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <select name="ims_code" id="ims_code" multiple>
                                    <cfoutput query="get_ims">
                                        <option value="#ims_code_id#">#ims_code# #ims_code_name#</option>
                                    </cfoutput>
                                </select>
                                <span class="input-group-addon icon-pluss btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=salesplan.popup_list_ims_codes&field_name=worker.ims_code');"></span>
                                <span class="input-group-addon icon-minus btnPointer" onClick="ozel_kaldir_2();"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_seperator id="takim_uyeleri" title="#getLang('salesplan',35)#"><!--- <cf_get_lang dictionary_id='35.Takım Üyeleri'> --->
            <cf_grid_list id="takim_uyeleri" table_width="800">
                <thead>
                    <tr>
                        <th width="20">
                            <a type="button" onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a>
                            <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_roles_row#</cfoutput>">
                        </th>
                        <th><cf_get_lang dictionary_id='57658.Üye'></th>
                        <th><cf_get_lang dictionary_id='42014.Rol'></th>
                    </tr>
                </thead>
                <tbody id="table1">
                    <cfoutput query="get_roles">
                        <tr id="frm_row#currentrow#">
                            <td>
                                <a style="cursor:pointer" onClick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1" ></td>
                                <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                                    SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_roles.position_code#">
                                </cfquery>
                            </td>
                            <td>
                                <div class="form-group">
                                    <div class="input-group">
                                        <input type="hidden" name="position_code#currentrow#" id="position_code#currentrow#" value="#position_code#">
                                        <input name="employee_name#currentrow#" id="employee_name#currentrow#" style="width:190px" readonly="yes" value="#get_emp_name.employee_name# #get_emp_name.employee_surname#">
                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('#currentrow#');" title="<cf_get_lang dictionary_id='41481.Üye Ekle'>" alt="<cf_get_lang dictionary_id='41481.Üye Ekle'>"></span> 
                                    </div>
                                </div>
                                
                            </td>
                            <td>
                                <div class="form-group">
                                    <select name="role_id#currentrow#" id="role_id#currentrow#">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfset role_id_ = get_roles.role_id>
                                        <cfloop query="get_rol">
                                            <option value="#project_roles_id#" <cfif role_id_ eq project_roles_id>selected</cfif>>#project_roles#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
            <cf_seperator id="sub_teams" title="#getLang('','Alt Takım',62035)#">
                <cf_grid_list id="sub_teams" table_width="800">
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='58511.Takım'></th>
                            <th width="20" class="text-center"><i class="fa fa-pencil"></i></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="get_sub_teams">
                            <tr>
                                <td>#TEAM_NAME#</td>
                                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=salesplan.list_sales_team&event=upd&team_id=#team_id#&sz_id=#SZ_ID#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
                <cf_box_footer>
                    <div class="col col-6 col-xs-12">
                        <cf_record_info query_name='get_sales_team'>
                    </div>
                    <div class="col col-6 col-xs-12">
                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=salesplan.emptypopup_del_sales_zone_team&team_id=#attributes.team_id#&head=#get_sales_team.team_name#'>
                    </div>
                </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	row_count=<cfoutput>#get_roles_row#</cfoutput>;
	<cfif get_sub_teams.recordcount>//Alt takımları varsa güncelleme yapması için
		leader = $('#leader_position_code').val();
		role_id = $('#leader_position_role_id').val();
		position_id = '';
		team_role_id = '';
		if(row_count>0)
		{
			for(i=1;i<=row_count;i++)
			{
				if(i == 1)
				{
					position_id = position_id + $('#position_code'+i).val();
					team_role_id = team_role_id + $('#role_id option'+i).val();
				}
				else
				{
					position_id = position_id +','+ $('#position_code'+i).val();
					team_role_id = team_role_id +','+ $('#role_id option'+i).val();
				}
			}
		}
	</cfif>
	var country_= $('#country_id').val();
	<cfif not len(get_sales_team.city_id)>
		if(country_.length)
			LoadCity(country_,'city_id','county_id',0)
	</cfif>
	var city_=$('#city_id').val();
	<cfif not len(get_sales_team_county.county_id)>
		if(city_.length)
			LoadCounty(city_,'county_id');
	</cfif>
	function sil(sy)
	{
		$('#row_kontrol'+sy).val('0');
		$('#frm_row'+sy).hide();
	}
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
		else
			return true;
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;

		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		$('#record_num').val(row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a><input type="hidden"  value="1"  name="row_kontrol' + row_count +'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="position_code' + row_count +'" id="position_code' + row_count +'"><div class="form-group"><div class="input-group"><input name="employee_name' + row_count +'" id="employee_name' + row_count +'" onfocus="on_focus('+row_count+');" autocomplete="off"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(' + row_count + ');" title="<cf_get_lang dictionary_id ='41481.Üye Ekle'>" alt="<cf_get_lang dictionary_id ='41481.Üye Ekle'>"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="role_id'+ row_count +'"><option value=""><cf_get_lang dictionary_id ="57734.Seçiniz"></option><cfoutput query="get_rol"><option value="#project_roles_id#">#project_roles#</option></cfoutput></select></div>';
	}
	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=worker.employee_name'+ no +'&field_code=worker.position_code'+ no +'&select_list=1');
	}
	function ozel_kaldir_2()
	{
		for (var i=parseInt($('#ims_code option').length)-1 ; i>=0 ; i--)
		{
			if ($('#ims_code option')[i].selected)
				$('#ims_code option')[i].remove();
		}
	}
	function on_focus(no)
	{
		AutoComplete_Create('employee_name'+no,'MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code'+no,'','3','135');
	}
	function ozel_kaldir()
	{
		for (var i=parseInt($('#district_id option').length)-1 ; i>=0 ; i--)
		{
			if ($('#district_id option')[i].selected)
			{
				<cfif xml_auto_ims_code eq 1>
					var sql = "SELECT IMS_CODE_ID FROM SETUP_DISTRICT WHERE DISTRICT_ID ="+$('#district_id option')[i].value;
					get_ims_code_id = wrk_query(sql,'dsn');
					var ims_code_remove =get_ims_code_id.IMS_CODE_ID;
				</cfif>
				$('#district_id option')[i].remove();
			}
	   	}
		<cfif xml_auto_ims_code eq 1>
		if(ims_code_remove !=undefined)
		{
			for (k=parseInt($('#ims_code option').length)-1;k>-1;k--)
			{
				if ($('#ims_code option')[k].val()==ims_code_remove)
					$('#ims_code option')[k].remove();
			}
		}
		</cfif>
	}

	function select_all(selected_field)
	{
		var selected_field_temp = selected_field +" option";
		for(i=0;i<$("#" + selected_field_temp).length;i++)
        {
			$("#" + selected_field_temp)[i].selected=true;
        }
	}

	function kontrol()
	{
		select_all('ims_code');
		select_all('district_id');
		if($('#upper_team option') != null && $('#upper_team option').val()==0)
		{
			var r = confirm("Lider ve Takım Üyeleri Üst Takımdan Gelsin mi?");
			if(r==true)
				$('#upd_sub_teams option').val('1')
			else
		    	$('#upd_sub_teams option').val('0');
		}
		<cfif get_sub_teams.recordcount>
			leader2 = $('#leader_position_code option').val();
			role_id2 = $('#leader_position_role_id option').val();
			position_id2='';
			team_role_id2='';
			if(row_count>0)
			{
				for(i=1;i<=row_count;i++)
				{
					if(i == 1)
					{
						position_id2 = $("#" + position_id2 + '#position_code option'+i).val();
						team_role_id2 = $("#" + team_role_id2 + '#position_code option'+i).val();
					}
					else
					{
						position_id2 =  $("#" + position_id2 + ','+ '#position_code option'+i).val();
						team_role_id2 = $("#" + team_role_id2 + ','+ '#position_code option'+i).val();
					}
				}
			}
			if(leader!=leader2||role_id!=role_id2||position_id!=position_id2||team_role_id!=team_role_id2)
			{
				var r = confirm("Lider ve Takım Üyeleri Üst Takımdan Gelsin mi?");
				if(r==true)
					$('#upd_sub_teams option').val('1')
				else
					$('#upd_sub_teams option').val('0');
		    }
		</cfif>
		return true;
	}
	function open_districts()
	{
		var county_list='';
		for(kk=0;kk<parseInt($('#county_id option').length); kk++)
		{
			if($('#county_id option')[kk].selected && $('#county_id option')[kk]!='')
				if(county_list == '')
					county_list = $('#county_id option')[kk].value;
				else
					county_list = county_list + ',' + $('#county_id option')[kk].value;
		}
		if(county_list == '')
		{
			alert("<cf_get_lang dictionary_id='58638.İlçe'>");
			return false;
		}
		else
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_districts&team_id=#attributes.team_id#</cfoutput>&field_name=worker.district_id<cfif xml_auto_ims_code eq 1>&field_ims=worker.ims_code</cfif>&county_id='+county_list,'medium');
	}
</script>
