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
		SZ_NAME ,
		SZ_HIERARCHY
	FROM
		SALES_ZONES
	WHERE
		SZ_ID IS NOT NULL 
        <cfif isdefined('attributes.sz_id') and len(attributes.sz_id)> AND
		SZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#">
        </cfif>
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
        TEAM_NAME
    FROM
        SALES_ZONES_TEAM
        <cfif isdefined('attributes.sz_id') and len(attributes.sz_id)> WHERE
        SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"></cfif>
</cfquery>
<cfif isDefined('attributes.team_id')>
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
           <!---  COUNTY_ID,
            DISTRICT_ID, --->
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
    <cfquery name="GET_SALES_TEAM_COUNTY" datasource="#DSN#">
        SELECT COUNTY_ID FROM SALES_ZONES_TEAM_COUNTY WHERE TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">
    </cfquery>
   <!---  <cfquery name="GET_SALES_TEAM_DISTRICT" datasource="#DSN#">
        SELECT
            DISTRICT_ID
        FROM
            SALES_ZONES_TEAM_DISTRICT
        WHERE
            TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">
    </cfquery> --->
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
    <cfset get_roles_row = get_roles.recordcount>

    <!--- Kopyalama --->
	<cfset attributes.team_name = GET_SALES_TEAM.TEAM_NAME>
    <cfelse>
    <cfset attributes.team_name =''>
    </cfif>

<cfquery name="GET_ROL" datasource="#DSN#">
	SELECT
    	PROJECT_ROLES_ID,
        #dsn#.Get_Dynamic_Language(SETUP_PROJECT_ROLES.PROJECT_ROLES_ID,'#session.ep.language#','SETUP_PROJECT_ROLES','PROJECT_ROLES',NULL,NULL,SETUP_PROJECT_ROLES.PROJECT_ROLES) AS PROJECT_ROLES,
        DETAIL,
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
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Satış Takımları',57803)#"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfparam name="attributes.branch_id" default="">
        <cfform name="worker" action="#request.self#?fuseaction=salesplan.emptypopup_add_sales_zones_team" method="post">
            <input type="hidden" name="sz_id" id="sz_id" value="<cfif isDefined("attributes.sz_id")><cfoutput>#attributes.sz_id#</cfoutput></cfif>">
            <input type="hidden" name="get_upper_info" id="get_upper_info" value="0" />
            <cf_box_elements>
                <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-team_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41479.Takım Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="team_name" id="team_name" value="#attributes.team_name#" required="yes" message="#getLang('main',782)# : #getLang('salesplan',34)#">
                        </div>
                    </div>
                    <div class="form-group" id="item-sales_zone">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
                        <div class="col col-8 ccol-xs-12">                            
                            <cfif isdefined("attributes.branch_id") and len (attributes.branch_id)>
                                <input type="hidden" name="sales_zone" id="sales_zone" value="<cfoutput>#get_sales_zone.sz_hierarchy#,#get_sales_zone.sz_id#</cfoutput>">
                                <cfoutput>#get_sales_zone.sz_name#</cfoutput>
                            <cfelse>
                                <select name="sales_zone" id="sales_zone">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_sales_zone">
                                        <option value="#get_sales_zone.sz_hierarchy#,#get_sales_zone.sz_id#">#get_sales_zone.sz_name#</option>
                                    </cfoutput>
                                </select>
                            </cfif>                            
                        </div>
                    </div>
                    <div class="form-group" id="item-responsible_branch_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41457.İlgili Şube'></label>
                        <div class="col col-8 ccol-xs-12">
                            <cfquery name="GET_BRANCH" datasource="#DSN#">
                                SELECT BRANCH_NAME,BRANCH_ID FROM BRANCH <cfif isdefined("attributes.branch_id") and len (attributes.branch_id)>WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"></cfif>
                            </cfquery>                            
                            <cfif isdefined("attributes.branch_id") and len (attributes.branch_id)>
                                <input type="hidden" name="responsible_branch_id" id="responsible_branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
                                <cfoutput>#get_branch.branch_name#</cfoutput>
                            <cfelse>
                                <select name="responsible_branch_id" id="responsible_branch_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="GET_BRANCH">
                                        <option value="#branch_id#">#branch_name#</option>
                                    </cfoutput>
                                </select>
                            </cfif>                            
                        </div>
                    </div>
                    <div class="form-group" id="item-country_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                        <div class="col col-8 ccol-xs-12">
                            <select name="country_id" id="country_id" tabindex="8" onChange="LoadCity(this.value,'city_id','county_id',0)">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_country">
                                    <option value="#get_country.country_id#" <cfif (isdefined('attributes.team_id') and len(get_sales_team.country_id) and get_sales_team.country_id eq get_country.country_id) or is_default eq 1>selected</cfif>>#get_country.country_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-city_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
                        <div class="col col-8 ccol-xs-12">
                            <select name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id','')">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif isDefined('attributes.team_id') and len(get_sales_team.country_id)>
                                    <cfquery name="GET_CITY" datasource="#DSN#">
                                        SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_team.country_id#">
                                    </cfquery>
                                    <cfoutput query="get_city">
                                        <option value="#get_city.city_id#" <cfif get_sales_team.city_id eq get_city.city_id>selected</cfif>>#get_city.city_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-county_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                        <div class="col col-8 ccol-xs-12">
                            <select name="county_id" id="county_id" style="width:200px;height:80px;" multiple>
                                <option value=""><cf_get_lang dictionary_id='58638.İlçe'></option>
                                <cfif isDefined('attributes.team_id') and len(get_sales_team.city_id)>
                                    <cfquery name="GET_COUNTY" datasource="#DSN#">
                                        SELECT
                                            COUNTY_ID,
                                            COUNTY_NAME
                                        FROM
                                            SETUP_COUNTY
                                        WHERE
                                            CITY =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_team.city_id#">
                                        ORDER BY
                                            COUNTY_NAME
                                    </cfquery>
                                    <cfset list_county = ValueList(get_sales_team_county.county_id,',') >
                                    <cfoutput query="get_county">
                                        <option value="#county_id#">#get_county.county_name#</option>
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
                                    <option value="1-#companycat_id#">#companycat#</option>
                                </cfoutput>
                                <optgroup label="<cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'>"></optgroup>
                                <cfoutput query="get_consumer_cat">
                                    <option value="2-#conscat_id#">#conscat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-upper_team">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41446.Üst Takım"></label>
                        <div class="col col-8 ccol-xs-12">
                            <select name="upper_team" id="upper_team" style="width:200px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_upper_teams">
                                    <option value="#team_id#" <cfif isdefined("attributes.team_id") and len(get_sales_team.upper_team_id) and get_sales_team.upper_team_id eq team_id>selected</cfif>>#team_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id = "item-leader_position_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41483.Lider'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="leader_position_code" id="leader_position_code" value="<cfif isDefined('attributes.team_id') and len(get_sales_team.leader_position_code)><cfoutput>#get_sales_team.leader_position_code#</cfoutput></cfif>">
                                <input type="text" name="leader_position_name" id="leader_position_name" value="<cfif isDefined('attributes.team_id') and len(get_sales_team.leader_position_code)><cfoutput>#get_emp_info(get_sales_team.leader_position_code,1,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('leader_position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','leader_position_code','','3','135');"   autocomplete="off" style="width:200px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=worker.leader_position_name&field_code=worker.leader_position_code&select_list=1');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-leader_position_role_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42014.Rol'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="leader_position_role_id" id="leader_position_role_id" style="width:200px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_rol">
                                    <option value="#project_roles_id#" <cfif isDefined('attributes.team_id') and len(get_sales_team.leader_position_role_id) and get_sales_team.leader_position_role_id eq get_rol.project_roles_id>selected</cfif>>#project_roles#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-ozel_kod">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ozel_kod" id="ozel_kod" value="<cfif isdefined("attributes.team_id") and len(get_sales_team.ozel_kod)><cfoutput>#get_sales_team.ozel_kod#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-district_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <select name="district_id" id="district_id" style="width:200px;height:80px;" multiple></select>
                                <span class="input-group-addon icon-pluss btnPointer" onClick="open_districts();"></span>
                                <span class="input-group-addon icon-minus btnPointer" onClick="ozel_kaldir_2();"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ims_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41477.IMS Kodları'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <select name="ims_code" id="ims_code" multiple>
                                    <cfif isDefined('attributes.team_id')>
                                        <cfoutput query="get_ims">
                                            <option value="#ims_code_id#">#ims_code# #ims_code_name#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                                <span class="input-group-addon icon-pluss btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=salesplan.popup_list_ims_codes&field_name=worker.ims_code');"></span>
                                <span class="input-group-addon icon-minus btnPointer" onClick="ozel_kaldir();"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_seperator id="takim_uyeleri" title="#getLang('salesplan','Takım Üyeleri',41480)#"><!---Takım Üyeleri--->
            <cf_grid_list id="takim_uyeleri" table_width="800">
                <thead>
                    <tr>
                        <th width="20">
                            <a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a>
                            <input type="hidden" name="record_num" id="record_num" value="<cfif isDefined('get_roles_row')><cfoutput>#get_roles_row#</cfoutput><cfelse>0</cfif>">
                        </th>
                        <th><cf_get_lang dictionary_id='57658.Üye'></th>
                        <th><cf_get_lang dictionary_id='42014.Rol'></th>
                    </tr>
                </thead>
                <cfif isDefined('attributes.team_id')>
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
                                    <input type="hidden" name="position_code#currentrow#" id="position_code#currentrow#" value="#position_code#">
                                    <input name="employee_name#currentrow#" id="employee_name#currentrow#" style="width:190px" readonly="yes" value="#get_emp_name.employee_name# #get_emp_name.employee_surname#">
                                    <a href="javascript://" onClick="pencere_ac('#currentrow#');"><img src="/images/plus_thin.gif" align="absbottom" title="<cf_get_lang dictionary_id='41481.Üye Ekle'>" border="0"></a>
                                </td>
                                <td>
                                    <select name="role_id#currentrow#" id="role_id#currentrow#" style="width:135px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfset role_id_ = get_roles.role_id>
                                        <cfloop query="get_rol">
                                            <option value="#project_roles_id#" <cfif role_id_ eq project_roles_id>selected</cfif>>#project_roles#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                <cfelse>
                    <tbody id="table1"></tbody>
                </cfif>
            <cf_grid_list>
            <cf_box_footer>
                <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	var country_ = $('#country_id').val();
	<cfif not isdefined("attributes.team_id")>
	if(country_.length)
		LoadCity(country_,'city_id','county_id',0);
	</cfif>
	<cfif isdefined("attributes.team_id")>
		var row_count=<cfoutput>#get_roles.recordcount#</cfoutput>;
	<cfelse>
		var row_count=0;
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

		newRow =document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);

	    $('#record_num').val(row_count);

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a><input type="hidden"  value="1"  name="row_kontrol' + row_count +'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="position_code' + row_count +'" id="position_code' + row_count +'"><div class="form-group"><div class="input-group"><input name="employee_name'+ row_count +'" id="employee_name'+ row_count +'" onfocus="on_focus('+row_count+')"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(' + row_count + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="role_id'+ row_count +'" id="role_id'+ row_count +'"><option value=""><cf_get_lang dictionary_id ="57734.Seçiniz"></option><cfoutput query="get_rol"><option value="#project_roles_id#">#project_roles#</option></cfoutput></select></div>';
	}
	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=worker.employee_name'+ no +'&field_code=worker.position_code'+ no +'&select_list=1');
	}
	function on_focus(no)
	{
		AutoComplete_Create('employee_name'+no,'MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code'+no,'','3','135');
	}
	function ozel_kaldir()
	{
		for (var i=parseInt($('#ims_code option').length)-1 ; i>=0 ; i--)
		{
			if ($('#ims_code option')[i].selected)
				$('#ims_code option')[i].remove();
		}
	}
	function ozel_kaldir_2()
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
				for (var i=parseInt($('#ims_code option').length)-1 ; i>=0 ; i--)
				{
					if ($('#ims_code option')[i].selected)
						$('#ims_code option')[i].remove();
				}
			}
		</cfif>
	}
	function select_all(selected_field)
	{
		var selected_field_temp = selected_field +" option";
		for(i=0;i< $("#" + selected_field_temp).length;i++)
        {
			$("#" + selected_field_temp)[i].selected=true;
        }

	}
	function kontrol()
	{
		if($('#upper_team option') != null && $('#upper_team option').val() != '')
		{
			var r = confirm("Lider ve Takım Üyeleri Üst Takımdan Gelsin mi?");
			if(r==true)
				$('#upper_team option').val('1')
			else
		   		$('#upper_team option').val('0');
		}
		select_all('ims_code');
		select_all('district_id');
		return true;
	}
	function open_districts()
	{
		var county_list='';
		for(kk=0;kk<parseInt($('#county_id option').length); kk++)
		{
			if($("#county_id option")[kk].selected && $('#county_id option')[kk]!='')
			{
				if(county_list == '')
					county_list = $('#county_id option')[kk].value;
				else
					county_list = county_list + ',' + $('#county_id option')[kk].value;
			}
		}
		if(county_list == '')
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58638.İlçe'>");
			return false;
		}
		else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_districts&field_name=worker.district_id<cfif xml_auto_ims_code eq 1>&field_ims=worker.ims_code</cfif>&county_id='+county_list);
	}
</script>
