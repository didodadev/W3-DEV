<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.page_type")><cfset attributes.page_type = 1></cfif>
<cf_xml_page_edit fuseact="objects.popup_list_positions_poweruser">
<cf_get_lang_set module_name="objects">
<cfset getcomponent = createObject("component", "V16.objects.cfc.poweruser")>
<cfparam name="attributes.employee_id" default="#session.ep.userid#">
<cfif session.ep.admin eq 0 and not get_module_power_user(67)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57532.Yetkiniz yok'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_user_groups.cfm">
<cfinclude template="../query/get_modules.cfm">
<cfif isdefined('attributes.position_id')>
	<cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
		SELECT
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.USER_GROUP_ID,
			EMPLOYEE_POSITIONS.LEVEL_ID,
			EMPLOYEE_POSITIONS.LEVEL_EXTRA_ID,
			EMPLOYEE_POSITIONS.POWER_USER_LEVEL_ID,
			EMPLOYEE_POSITIONS.UPDATE_EMP,
			EMPLOYEE_POSITIONS.UPDATE_DATE,
			EMPLOYEE_POSITIONS.WRK_MENU,
			EPH.RECORD_DATE,
        	EPH.RECORD_EMP
		FROM
			EMPLOYEE_POSITIONS 
			LEFT JOIN EMPLOYEE_POSITIONS_HISTORY EPH ON EPH.POSITION_ID=EMPLOYEE_POSITIONS.POSITION_ID AND EPH.HISTORY_ID = (SELECT TOP 1 EPH2.HISTORY_ID FROM EMPLOYEE_POSITIONS_HISTORY EPH2 WHERE EPH2.POSITION_ID = #attributes.POSITION_ID# ORDER BY EPH2.HISTORY_ID ASC)
		WHERE
			EMPLOYEE_POSITIONS.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
	</cfquery>
<cfelse>
	<cfset positionid = getcomponent.GET_POS_ID(position_code : session.ep.position_code)>
	<cfparam name="attributes.position_id" default="#positionid.position_id#">
</cfif>
<cfoutput>
	
<cf_box title="#getLang('','Kullanıcı Erişim ve Yetkileri',33368)# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_tab defaultOpen="link1" divId="link1,link2,link3,link5,link6,link7,link8,link9,link10" divLang="#getLang('','Kullanıcı Yetkileri',33365)#;#getLang('','Muhasebe Dönemleri',42172)#;#getLang('','Şube Yetkileri',33369)#;#getLang('','Ek Ayarlar',64275)#;#getLang('','Gündem',57413)#;#getLang('','Tasarım ve Dil',31075)#;#getLang('','Ajanda',57415)#;#getLang('','Belge Numaraları',47520)#;#getLang('','İletişim Grupları',42227)#;"
	 beforeFunction="pageload(1,unique_link1)|pageload(2,unique_link2)|pageload(3,unique_link3)|pageload(5,unique_link5)|pageload(6,unique_link6)|pageload(7,unique_link7)|pageload(8,unique_link8)|pageload(9,unique_link9)|pageload(10,unique_link10)">
			<div class="ui-info-text uniqueBox" id="unique_link1"></div>
			<div class="ui-info-text uniqueBox" id="unique_link2"></div>
			<div class="ui-info-text uniqueBox" id="unique_link3"></div>
			<!---
			<cfif get_module_power_user(67) or session.ep.ehesap>
				<li style="float:left; cursor:pointer;" id="link4" <cfif attributes.page_type eq 4>class="selected"</cfif>><a onClick="pageload(4,link4);"><cf_get_lang_main no='2087.Süper Kullanıcı'></a></li>
			</cfif>                
			--->
			<div class="ui-info-text uniqueBox" id="unique_link5"></div>
			<div class="ui-info-text uniqueBox" id="unique_link6"></div>
			<div class="ui-info-text uniqueBox" id="unique_link7"></div>
			<div class="ui-info-text uniqueBox" id="unique_link8"></div>
			<cfif fusebox.use_period>
				<div class="ui-info-text uniqueBox" id="unique_link9"></div>
			</cfif>
			<div class="ui-info-text uniqueBox" id="unique_link10"></div>
			<div id="SHOW_PRODUCT" class="icerik_tabbed" style="width:98%;height:97%;z-index:9999; float:left;border:0;"></div>
			<cfif isdefined('attributes.from_sec') and attributes.from_sec eq 1>
					<cfsavecontent variable="dsp_name"><cf_get_lang dictionary_id='64328.Yetkilendirilecek Kişiler'></cfsavecontent>
				<div>
					<cf_workcube_to_cc 
						is_update="0" 
						to_dsp_name="#dsp_name#"
						str_list_param="1" 
						data_type="1"
						style="width:40%;">
				</div>
			</cfif>
	</cf_tab>
</cf_box>
</cfoutput>
<script type="text/javascript">
	function get_auth_emps(x,y,z,w)
	{
		temp_str_pos="";
		temp_str_pos_codes="";
		temp_str="";
		temp_control = 0;
		temp_count = $('#tbl_to_names_row_count').val()-1;
		for(i=0;i<=temp_count;i++)
		{
			if(((x == 1 && $('input[name=to_emp_ids]').get(i) && $('input[name=to_emp_ids]').get(i).value.length) || x == 0) && ((y == 1 && $('input[name=to_pos_ids]').get(i) && $('input[name=to_pos_ids]').get(i).value.length) || y == 0) && ((z == 1 && $('input[name=to_pos_codes]').get(i) && $('input[name=to_pos_codes]').get(i).value.length) || z == 0))
			{
				if(temp_control == 1)
				{
					if (x == 1)
						temp_str = temp_str + ',' + $('input[name=to_emp_ids]').get(i).value;
					if (y == 1)
						temp_str_pos = temp_str_pos + ',' + $('input[name=to_pos_ids]').get(i).value;
					if (z == 1)
						temp_str_pos_codes = temp_str_pos_codes + ',' + $('input[name=to_pos_codes]').get(i).value;
				}
				else
				{
					if (x == 1)
						temp_str = temp_str + $('input[name=to_emp_ids]').get(i).value;
					if (y == 1)
						temp_str_pos = temp_str_pos + $('input[name=to_pos_ids]').get(i).value;
					if (z == 1)
						temp_str_pos_codes = temp_str_pos_codes + $('input[name=to_pos_codes]').get(i).value;
					temp_control = 1;
				}
			}
		}
		if (x == 1)
			$('input[name=auth_emps_id]').val(temp_str);
		if (y == 1)
			$('input[name=auth_emps_pos]').val(temp_str_pos);
		if (z == 1)
			$('input[name=auth_emps_pos_codes]').val(temp_str_pos);
		<cfif isdefined('attributes.from_sec') and attributes.from_sec eq 1>
			if (w == 1)
				$('input[name=from_sec]').val(1);
		</cfif>
	}
function pageload(page)
{
	<cfoutput>
	if(page==1)
	{
		_link_ = 'unique_link1';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=1&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#<cfif isdefined('attributes.from_sec')>&from_sec=1</cfif>&modal_id=#attributes.modal_id#&tab=1&draggable=1"
	}
	else if(page==2)
	{
		_link_ = 'unique_link2';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=2&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#&modal_id=#attributes.modal_id#&tab=1&draggable=1"
	}
	else if(page==3)
	{
		_link_ = 'unique_link3';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=3&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#<cfif isdefined('attributes.from_sec')>&from_sec=1</cfif>&modal_id=#attributes.modal_id#&tab=1&draggable=1"
	}
	else if(page==4)
	{
		_link_ = 'link4';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=4&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#"
	}
	else if(page==5)
	{
		_link_ = 'unique_link5';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=5&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#&modal_id=#attributes.modal_id#&tab=1&draggable=1"
	}
	else if(page==6)
	{
		_link_ = 'unique_link6';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=6&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#&modal_id=#attributes.modal_id#&tab=1&draggable=1"
	}
	else if(page==7)
	{
		_link_ = 'unique_link7';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=7&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#&modal_id=#attributes.modal_id#&tab=1&draggable=1"
	}
	else if(page==8)
	{
		_link_ = 'unique_link8';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=8&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#&modal_id=#attributes.modal_id#&tab=1&draggable=1"
	}
	else if(page==9)
	{
		_link_ = 'unique_link9';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=9&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#&modal_id=#attributes.modal_id#&tab=1&draggable=1"
	}
	else if(page==10)
	{
		_link_ = 'unique_link10';
		var url_str = "#request.self#?fuseaction=objects.list_positions_poweruser_in&module_lang_type=#module_lang_type#&type=10&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#&modal_id=#attributes.modal_id#&tab=1&draggable=1"
	}
	AjaxPageLoad(url_str,'SHOW_PRODUCT',1,'<cf_get_lang dictionary_id="58891.Yükleniyor">',eval(_link_));
	return true;
</cfoutput>
}
<cfoutput>
	pageload("#attributes.page_type#");
</cfoutput>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
