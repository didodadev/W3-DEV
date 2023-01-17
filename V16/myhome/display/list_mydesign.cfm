<cfinclude template="../query/my_sett.cfm">
<cfif isdefined("attributes.employee_id")>
   <cfquery name="GET_EMPLOYEE_NAME" datasource="#DSN#">
  		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
  </cfquery>
</cfif>
<cfquery name="GET_MY_POSITION_CAT_USER_GROUP" datasource="#DSN#">
	SELECT POSITION_CAT_ID,USER_GROUP_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfquery name="GET_OZEL_MENUS" datasource="#DSN#">
	SELECT * FROM MAIN_MENU_SETTINGS WHERE (POSITION_CAT_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_position_cat_user_group.position_cat_id#,%"> OR USER_GROUP_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_position_cat_user_group.user_group_id#,%"> OR TO_EMPS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">) AND IS_ACTIVE = 1
</cfquery>
<table border="0" cellspacing="1" cellpadding="2" style="width:98%; height:98%">
    <tr>
        <td style="vertical-align:top;">
            <cfform action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=left" method="POST" name="form1">
				<cfif isdefined("attributes.employee_id")>
                	<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
              	</cfif>
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td style="width:150px; vertical-align:top;">
                            <table style="width:100%">
                                <tr>
                                    <td class="txtboldblue"><cf_get_lang dictionary_id='31077.Arayüz'></td>
                                </tr>
                                <cfif my_sett.standart_menu_closed neq 1>
                                    <tr>
                                        <td><input type="radio" name="interface" id="interface" <cfif get_ozel_menus.recordcount>onFocus="checked_etme_ozel();"</cfif> value="4" <cfif listfindnocase('1,2,3,4',my_sett.interface_id)>checked</cfif>>
                                        <cf_get_lang dictionary_id='29954.Genel'></td>
                                    </tr>
                                    <tr>
                                        <td><input type="radio" name="interface" id="interface" <cfif get_ozel_menus.recordcount>onFocus="checked_etme_ozel();"</cfif> value="7"  <cfif my_sett.interface_id eq 7>checked</cfif>>
                                        CRM</td>
                                    </tr>
                                    <tr>
                                        <td><input type="radio" name="interface" id="interface" <cfif get_ozel_menus.recordcount>onFocus="checked_etme_ozel();"</cfif> value="8"  <cfif my_sett.interface_id eq 8>checked</cfif>>
                                        HR</td>
                                    </tr>
                                    <tr>
                                        <td><input type="radio" name="interface" id="interface" <cfif get_ozel_menus.recordcount>onFocus="checked_etme_ozel();"</cfif> value="9"  <cfif my_sett.interface_id eq 9>checked</cfif>>
                                        LMS</td>
                                    </tr>
                                </cfif>
                                <cfoutput query="get_ozel_menus">
                                    <tr>
                                        <td><input type="radio" name="interface" id="interface" <cfif my_sett.standart_menu_closed neq 1>onFocus="checked_etme();"</cfif> value="o-#menu_id#" <cfif my_sett.ozel_menu_id eq menu_id>checked</cfif>> #menu_name#</td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                        <td style="width:150px; vertical-align:top;">
                            <table style="width:100%">
                                <tr>
                                    <td class="txtboldblue"><cf_get_lang dictionary_id='31078.Renkler'></td>
                                </tr>
                                <tr>
                                    <td><input type="radio" name="color" id="color" value="1" <cfif my_sett.interface_color eq 1>checked</cfif>>
                                    Aqua</td>
                                </tr>
                                <tr>
                                    <td><input type="radio" name="color" id="color" value="2" <cfif my_sett.interface_color eq 2>checked</cfif>>
                                    Brown</td>
                                </tr>
                                <tr>
                                    <td><input type="radio" name="color" id="color" value="3" <cfif my_sett.interface_color eq 3>checked</cfif>>
                                    Orange</td>
                                </tr>
                                <tr>
                                    <td><input type="radio" name="color" id="color" value="4" <cfif my_sett.interface_color eq 4>checked</cfif>>
                                    Olive</td>
                                </tr>
                                <tr>
                                    <td><input type="radio" name="color" id="color" value="5" <cfif my_sett.interface_color eq 5>checked</cfif>>
                                    Kurşuni</td>
                                </tr>
                                <tr>
                                    <td><input type="radio" name="color" id="color" value="6" <cfif my_sett.interface_color eq 6>checked</cfif>> 
                                    <cf_get_lang dictionary_id='31138.Turkuaz'></td>
                                </tr>
                                <tr>
                                    <td><input type="radio" name="color" id="color" value="7" <cfif my_sett.interface_color eq 7>checked</cfif>> 
                                    Natural</td>
                                </tr>
                            </table>
                        </td>
                      	<td style="width:150px; vertical-align:top;">
                            <table style="width:100%">
                                <tr>
                                    <td class="txtboldblue" height="9"><cf_get_lang dictionary_id='31083.Dil Tercihim'></td>
                                </tr>
                                <cfquery name="GET_LANG" datasource="#DSN#">
                                    SELECT LANGUAGE_SET,LANGUAGE_SHORT FROM SETUP_LANGUAGE
                                </cfquery>
                                <cfoutput query="get_lang">
                                    <tr>
                                        <td><input type="radio" name="lang" id="lang" value="#get_lang.language_short#" <cfif my_sett.language_id eq get_lang.language_short>checked</cfif>>#get_lang.language_set#</td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                        <td style="width:200px; vertical-align:top;">
                            <table border="0">
                                <tr>
                                    <td class="txtboldblue"><cf_get_lang dictionary_id='31128.Listeleme Maksimum Kayıt Sayısı'></td>
                                </tr>
                                <tr>
                                    <td>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='31129.Lütfen 1 ile 250 Arasında Maksimum Kayıt Sayısı Giriniz'>!</cfsavecontent>
                                        <cfinput type="text" name="maxrows" id="maxrows" value="#my_sett.maxrows#" onKeyUp="isNumber(this);" required="yes" range="1,250" maxlength="3" validate="integer" message="#message#">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="txtboldblue"><cf_get_lang dictionary_id='31001.Session Timeout Süresi (dk)'></td>
                                </tr>
                                <tr>
                                    <td>
                                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='31008.Timeout Süresi 5 ile 119 Dakika Arasında Olmalı'>!</cfsavecontent>
                                    	<cfinput type="text" name="timeout_limit" id="timeout_limit" value="#my_sett.timeout_limit#" onKeyUp="isNumber(this);" required="yes" range="5,119" maxlength="3" validate="integer" message="#message#">
                                    </td>
                                </tr>
                                <cfif my_sett.standart_menu_closed neq 1>
                                    <tr>
                                        <td class="txtbold">						
                                            <input type="checkbox" name="myhome_quick_menu_page" id="myhome_quick_menu_page" value="1" <cfif my_sett.myhome_quick_menu_page eq 1> checked</cfif>>						  
                                            <cf_get_lang dictionary_id='31139.Menüm Anasayfam Olsun'> <!--- Anasayfada Hızlı Erişim Açılsın --->
                                        </td>
                                    </tr>
                                </cfif>
                            </table>
                        </td>
                    </tr>
                    <tr style="height:30px;">
                        <td style="text-align:right;"><cf_workcube_buttons is_upd='0'>&nbsp;&nbsp;</td>
                    </tr>
                </table>
            </cfform>
        </td>
    </tr>
</table>
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
</script>                 
 
