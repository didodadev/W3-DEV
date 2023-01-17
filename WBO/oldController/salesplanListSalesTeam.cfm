<cf_get_lang_set module_name="salesplan">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
 	<cfparam name="attributes.keyword" default="">
    <cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
        SELECT 
            SALES_ZONES_TEAM.TEAM_ID,
            SALES_ZONES.SZ_ID,
            SALES_ZONES_TEAM.TEAM_NAME,
            SALES_ZONES.SZ_NAME
        FROM 
            SALES_ZONES_TEAM,
            SALES_ZONES
        WHERE 
            SALES_ZONES.SZ_ID = SALES_ZONES_TEAM.SALES_ZONES
        <cfif len(attributes.keyword)>
            AND
            ( 
            SALES_ZONES_TEAM.TEAM_NAME LIKE '%#attributes.keyword#%' OR
            SALES_ZONES.SZ_NAME LIKE '%#attributes.keyword#%'
            )
        </cfif>
        ORDER BY 
            SALES_ZONES_TEAM.TEAM_NAME
    </cfquery>
    <cfelse>
        <cfset get_sales_zones_team.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.form_submitted" default="0">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_sales_zones_team.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfelseif isdefined("attributes.event") and ListFindNoCase('upd,add',attributes.event)>
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
                PROJECT_ROLES, 
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
        <cfif IsDefined('attributes.team_id')>
            <cfquery name="GET_SALES_TEAM_COUNTY" datasource="#DSN#">
                SELECT 
                    COUNTY_ID
                FROM 
                    SALES_ZONES_TEAM_COUNTY
                WHERE 
                    TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">
            </cfquery>
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
			<cfif len(get_sales_team.country_id) and len(get_sales_team.city_id)>
                <cfquery name="GET_CITY" datasource="#DSN#">
                    SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_team.country_id#">
                </cfquery>
            </cfif>
            <cfif len(get_sales_team.responsible_branch_id)>
                <cfquery name="GET_BRANCH" datasource="#DSN#">
                    SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_team.responsible_branch_id#">
                </cfquery>
            </cfif>
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
            <cfif IsDefined('attributes.event') and attributes.event is 'add'>
			<!--- Kopyalama --->
				<cfset attributes.team_name = GET_SALES_TEAM.TEAM_NAME>
            </cfif>  
		<cfelse>
			<cfif IsDefined('attributes.event') and attributes.event is 'add'>
				<cfset attributes.team_name =''>
			</cfif>
        </cfif>
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
        <cfif xml_select_upper_team>
            <cfquery name="get_upper_teams" datasource="#dsn#">
                SELECT
                    TEAM_ID,
                    TEAM_NAME
                FROM
                    SALES_ZONES_TEAM
                WHERE
                    SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#">
            </cfquery>
        </cfif>   
    	 <cfif IsDefined('attributes.event') and attributes.event is'add'>
            <cfquery name="GET_BRANCH" datasource="#DSN#">
                SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
            </cfquery>
		</cfif>
        <cfif IsDefined('attributes.event') and attributes.event is'upd'>
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
            </cfif>	
		</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
		   document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and listfindnocase('add,upd',attributes.event)>
		<cfif IsDefined('attributes.event') and attributes.event is 'add'>
				$( document ).ready(function() {
					var country_ = $('#country_id').val();
					<cfif not isdefined("attributes.team_id")>
						if(country_.length)
							LoadCity(country_,'city_id','county_id',0);
					</cfif>
				});
				<cfif isdefined("attributes.team_id")>
					var row_count=<cfoutput>#get_roles.recordcount#</cfoutput>;
				<cfelse>
					var row_count=0;
				</cfif>
				function kontrol()
				{
					if($('#team_name').val() == '')
					{
						alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no="34.Takım Adı">');
						return false;	
					}
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
			</cfif>
			<cfif IsDefined('attributes.event') and attributes.event is 'upd'>
				$( document ).ready(function() {
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
					var country_= $('#country_id option').val();
					var city_=$('city_id option').val(); 
					<cfif not len(get_sales_team.city_id)>
						if(country_.length)
							LoadCity(country_,'city_id','county_id',0)
					</cfif>
						
					<cfif not len(get_sales_team_county.county_id)>
						if(city_ != undefined && city_.length)
							(city_,'county_id')
					</cfif>
				});	
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
									position_id2 = $("#" + position_id2 + 'position_code option'+i).val();
									team_role_id2 = $("#" + team_role_id2 + 'position_code option'+i).val();
								}
								else
								{
									position_id2 =  $("#" + position_id2 + ','+ 'position_code option'+i).val();
									team_role_id2 = $("#" + team_role_id2 + ','+ 'position_code option'+i).val();
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
				newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0" align="absmiddle"></a><input type="hidden"  value="1"  name="row_kontrol' + row_count +'">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="position_code' + row_count +'" id="position_code' + row_count +'"><input name="employee_name' + row_count +'" id="employee_name' + row_count +'" onfocus="on_focus('+row_count+');"  autocomplete="off"   style="width:190px"> <a href="javascript://" <a href="javascript://" onClick="pencere_ac(' + row_count + ');"><img src="/images/plus_thin.gif" align="absbottom" alt="<cf_get_lang no ='36.Üye Ekle'>" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="role_id'+ row_count +'" style="width:135px;"><option value=""><cf_get_lang_main no ="322.Seçiniz"></option><cfoutput query="get_rol"><option value="#project_roles_id#">#project_roles#</option></cfoutput></select>';
			}	
			function pencere_ac(no)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=worker.employee_name'+ no +'&field_code=worker.position_code'+ no +'&select_list=1','list');
			}
			function on_focus(no)
			{
				AutoComplete_Create('employee_name'+no,'MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code'+no,'','3','135');
			}
			function ozel_kaldir_2()
			{
				for (var i=parseInt($('#ims_code option').length)-1 ; i>=0 ; i--)
				{    
					if ($('#ims_code option')[i].selected)
						$('#ims_code option')[i].remove();
				}
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
					alert("<cf_get_lang_main no='1226.İlçe'>");
					return false;
				}
				else
					<cfif IsDefined('attributes.event') and attributes.event is 'upd'>
						windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_districts&team_id=#attributes.team_id#</cfoutput>&field_name=worker.district_id<cfif xml_auto_ims_code eq 1>&field_ims=worker.ims_code</cfif>&county_id='+county_list,'medium');
					<cfelseif IsDefined('attributes.event') and attributes.event is 'add'>
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_districts&field_name=worker.district_id<cfif xml_auto_ims_code eq 1>&field_ims=worker.ims_code</cfif>&county_id='+county_list,'medium');
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
		</cfif>
</script>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'salesplan.list_sales_team';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'salesplan/display/list_sales_team.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'salesplan.popup_upd_sales_zones_team';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'salesplan/form/add_sales_zones_team.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'salesplan/query/add_sales_zones_team.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'salesplan.list_sales_team&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'salesplan.popup_upd_sales_zones_team';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'salesplan/form/upd_sales_zones_team.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'salesplan/query/upd_sales_zones_team.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'salesplan.list_sales_team&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'sz_id=##attributes.sz_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.sz_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=salesplan.emptypopup_del_sales_zone_team&team_id=#attributes.team_id#&head=#get_sales_team.team_name#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'salesplan/query/del_sales_zones_team.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'salesplan/query/del_sales_zones_team.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'salesplan.list_sales_team';
	}
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=salesplan.list_sales_team&event=add&sz_id=#get_sales_team.sales_zones#&branch_id=#get_sales_zone.responsible_branch_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=salesplan.list_sales_team&event=add&sz_id=#get_sales_team.sales_zones#&branch_id=#get_sales_zone.responsible_branch_id#&team_id=#attributes.team_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'salesplanListSalesTeam';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALES_ZONES_TEAM';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-team_name']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
