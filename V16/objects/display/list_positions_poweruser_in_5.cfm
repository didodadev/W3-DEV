<cfinclude template="../../myhome/query/my_sett.cfm">
<cfquery datasource="#dsn#" name="get_ozel_menus">
	SELECT * FROM MAIN_MENU_SETTINGS WHERE (POSITION_CAT_IDS LIKE '%,#get_hr.POSITION_CAT_ID#,%' OR USER_GROUP_IDS LIKE '%,#get_hr.USER_GROUP_ID#,%' OR TO_EMPS LIKE '%,#get_hr.EMPLOYEE_ID#,%') AND IS_ACTIVE = 1
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfform name="form1" method="post" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=left">
	<input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
	<input type="hidden" name="position_id" id="position_id" value="<cfif isdefined('attributes.position_id') and len(attributes.position_id)><cfoutput>#attributes.position_id#</cfoutput></cfif>">
	<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
	<input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
	<input type="hidden" name="from_sec" id="from_sec" value="">
	<cf_box_elements>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='33377.Arayüz'></label>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='33378.Standart Menüler Kapalı'></label>
				<div class="col col-4 col-xs-12"><input type="checkbox" name="standart_menu_closed" id="standart_menu_closed" value="1" <cfif my_sett.standart_menu_closed eq 1>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='33380.Anasayfa Hızlı Erişim Açılsın'></label>
				<div class="col col-4 col-xs-12"><input type="checkbox" name="myhome_quick_menu_page" id="myhome_quick_menu_page" value="1" <cfif my_sett.myhome_quick_menu_page eq 1> checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='61133.Catalyst'></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="interface" id="interface" value="0" <cfif session.ep.design_id eq 0>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='49029.Holistic'></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="interface" id="interface" value="1" <cfif session.ep.design_id  eq 1>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='63843.Watomic'></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="interface" id="interface" value="2" <cfif session.ep.design_id  eq 2>checked</cfif>></div>
			</div>
		</div>
		<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='57236.Standart'></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="color" id="color" value="1" <cfif my_sett.interface_color eq 1>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='63408.Deep Blue'></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="color" id="color" value="2" <cfif my_sett.interface_color eq 2>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='63409.Green Soul'></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="color" id="color" value="3" <cfif my_sett.interface_color eq 3>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='63410.Terra Soil'></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="color" id="color" value="4" <cfif my_sett.interface_color eq 4>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='63412.Golden Horn'></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="color" id="color" value="5" <cfif my_sett.interface_color eq 5>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='63413.Silver Line'></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="color" id="color" value="6" <cfif my_sett.interface_color eq 6>checked</cfif>></div>
			</div>
			<!--- <div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id="33391.Turkuaz"></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="color" id="color" value="6" <cfif my_sett.interface_color eq 6>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id="32567.Natural"></label>
				<div class="col col-4 col-xs-12"><input type="radio" name="color" id="color" value="7" <cfif my_sett.interface_color eq 7>checked</cfif>></div>
			</div> --->
		</div>
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
			<cfquery name="GET_LANG" datasource="#dsn#">
				SELECT * FROM SETUP_LANGUAGE
			</cfquery>
			<cfoutput query="get_lang">
				<div class="form-group">
					<label class="col col-8 col-xs-12">#get_lang.language_set#</label>
					<div class="col col-4 col-xs-12"><input type="radio" name="lang" id="lang" value="#get_lang.language_short#" <cfif my_sett.LANGUAGE_ID eq get_lang.language_short>checked</cfif>></div>
				</div>
			</cfoutput>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='33393.Listeleme Maksimum Kayıt Sayısı'></label>
				<div class="col col-4 col-xs-12">
					<cfinput type="text" name="maxrows" value="#my_sett.maxrows#" onKeyUp="isNumber(this);" required="yes" range="1,250" maxlength="3" message="#getLang('','Lütfen 1 ile 250 Arasında Maksimum Kayıt Sayısı Giriniz',33394)#!">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='33395.Session Timeout Süresi dk'></label>
				<div class="col col-4 col-xs-12">
					<cfinput type="text" name="TIMEOUT_LIMIT" id="TIMEOUT_LIMIT" value="#my_sett.timeout_limit#" onKeyUp="isNumber(this);" required="yes" maxlength="3" validate="integer">
				</div>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cf_record_info query_name="my_sett">
		<cf_workcube_buttons is_upd="0" add_function="control()">
	</cf_box_footer>
</cfform>
<script type="text/javascript">
	function checked_etme_ozel()
	{
		<!---if (document.form1.ozel_menu_id.length != undefined) /*n tane*/
				{
				for (i=0; i < form1.ozel_menu_id.length; i++)
					{
					document.form1.ozel_menu_id[i].checked = false;
					}
				}
		else /*1 tane*/
					document.form1.ozel_menu_id.checked = false;--->
	}
	function checked_etme()
	{
		if (document.form1.interface.length != undefined) /* n tane*/
			{
			for (i=0; i < form1.interface.length; i++)
				{
				document.form1.interface[i].checked = false;
				}
			}
	else /* 1 tane*/
				document.form1.interface.checked = false;
	}
	function control() {
		get_auth_emps(1,0,0,1);
		if($('#TIMEOUT_LIMIT').val() > 360 ){
			alert('<cf_get_lang dictionary_id="33396.Timeout Süresi 5 ile 360 Dakika Arasında Olmalı">');
			return false;
		}
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('form1' , <cfoutput>#attributes.modal_id#</cfoutput>)
		</cfif>
	
	}
</script>
