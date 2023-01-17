<cfinclude template="../query/my_sett.cfm">
<cfinclude template="../../agenda/query/get_event_cats.cfm">
<cfquery name="LAST_LOGIN" datasource="#dsn#" maxrows="1">
	SELECT 
		IN_OUT_TIME,
		LOGIN_IP 
	FROM
		WRK_LOGIN 
	WHERE 
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		IN_OUT = 1 
	ORDER BY 
		IN_OUT_TIME DESC
</cfquery>
<cfif isdefined("attributes.employee_id")>
	<cfquery name="GET_EMPLOYEE_NAME" datasource="#DSN#">
		SELECT 
			EMPLOYEE_NAME, 
			EMPLOYEE_SURNAME 
		FROM 
			EMPLOYEES 
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
</cfif>
<table width="100%" height="100%"border="0" cellspacing="1" cellpadding="2">
	<tr>
		<td valign="top" width="350">
			<cfform method="post" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=center_top" name="form1">
                <table width="100%" border="0">
                    <cfif isdefined("attributes.employee_id")>
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                    </cfif>
                    <tr>
                        <td class="txtboldblue" height="22"><cf_get_lang dictionary_id='31043.Son Oturum'></td>
                    </tr>
                    <tr>
                        <td><cfoutput> #dateformat(date_add('h',session.ep.time_zone,last_login.in_out_time),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,last_login.in_out_time),timeformat_style)# </cfoutput></td>
                    </tr>
                    <tr>
                        <td class="txtboldblue" height="22"><cf_get_lang dictionary_id='57415.Ajanda'></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='30863.Standart Olay Kategorisi'></td>
                    </tr>
                    <tr>
                        <td>
                            <select name="eventcat_id" id="eventcat_id" style="width:336px;">
                                <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_event_cats">
                                    <option value="#eventcat_id#" <cfif eventcat_id eq my_sett.eventcat_id>selected</cfif>>#eventcat#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" name="agenda" id="agenda" <cfif my_sett.agenda eq 1> checked</cfif>><cf_get_lang dictionary_id='31045.Ajandamı herkes görsün'></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='31046.Saat Ayarı'></td>
                    </tr>
                    <tr>
                        <td>
                            <cf_wrkTimeZone width="336">
                            <!--- 17.07.2012 6 ay sonra silinsin P.Y. --->
    <!---                    	<select name="TIME_ZONE" style="width:336px;">
                                <option value="-12" <cfif my_sett.time_zone eq -12>selected</cfif>>(GMT-12:00) International Date Line West</option>
                                <option value="-11" <cfif my_sett.time_zone eq -11>selected</cfif>>(GMT-11:00) Midway Island, Samoa</option>
                                <option value="-10" <cfif my_sett.time_zone eq -10>selected</cfif>>(GMT-10:00) Hawaii</option>
                                <option value="-9"  <cfif my_sett.time_zone eq -9> selected</cfif>>(GMT-09:00) Alaska</option>
                                <option value="-8"  <cfif my_sett.time_zone eq -8> selected</cfif>>(GMT-08:00) Pacific Time (US & Canada); Tijuana</option>
                                <option value="-7"  <cfif my_sett.time_zone eq -7> selected</cfif>>(GMT-07:00) Mountain Time (US & Canada), Arizona</option>
                                <option value="-6"  <cfif my_sett.time_zone eq -6> selected</cfif>>(GMT-06:00) Central Time (US & Canada),Mexico City </option>
                                <option value="-5"  <cfif my_sett.time_zone eq -5> selected</cfif>>(GMT-05:00) Eastern Time (US & Canada), Indiana(West)</option>
                                <option value="-4.5"<cfif my_sett.time_zone eq -4.5> selected</cfif>>(GMT-04:30) Karakas</option>
                                <option value="-4"  <cfif my_sett.time_zone eq -4> selected</cfif>>(GMT-04:00) Atlantic Time (Canada), Cuiba, Santiago</option>
                                <option value="-3.5"<cfif my_sett.time_zone eq -3.5> selected</cfif>>(GMT-03:30) Newfoundland</option>
                                <option value="-3"  <cfif my_sett.time_zone eq -3> selected</cfif>>(GMT-03:00) Brazil, Buenos Aires, Greenland </option>
                                <option value="-2"  <cfif my_sett.time_zone eq -2> selected</cfif>>(GMT-02:00) Coordinated Universal Time-02, Mid-Atlantic</option>
                                <option value="-1"  <cfif my_sett.time_zone eq -1> selected</cfif>>(GMT-01:00) Azores, Cape Verde Is.</option>
                                <option value="0"   <cfif my_sett.time_zone eq 0>  selected</cfif>>(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London</option>
                                <option value="+1"  <cfif my_sett.time_zone eq +1> selected</cfif>>(GMT+01:00) Amsterdam, Berlin, Belgrade, Rome, Paris, Vienna</option>
                                <option value="+2"  <cfif my_sett.time_zone eq +2> selected</cfif>>(GMT+02:00) Athens, Istanbul, Minsk</option>
                                <option value="+3"  <cfif my_sett.time_zone eq +3> selected</cfif>>(GMT+03:00) Moscow, St. Petersburg, Kuwait, Baghdad</option>
                                <option value="+3.5"<cfif my_sett.time_zone eq +3.5> selected</cfif>>(GMT+03:30) Tehran </option>
                                <option value="+4"  <cfif my_sett.time_zone eq +4> selected</cfif>>(GMT+04:00) Baku, Tbilisi, Abu Dhabi</option>
                                <option value="4.5" <cfif my_sett.time_zone eq 4.5> selected</cfif>>(GMT+04:30) Kabil</option>
                                <option value="+5"  <cfif my_sett.time_zone eq +5> selected</cfif>>(GMT+05:00) Islamabad, Tashkent</option>
                                <option value="+5.5"<cfif my_sett.time_zone eq +5.5> selected</cfif>>(GMT+05:30) Kalküta, Chennai, Mumbai, New Delhi</option>
                                <option value="+5.75"<cfif my_sett.time_zone eq +5.75> selected</cfif>>(GMT+05:45) Kathmandu </option>
                                <option value="+6"  <cfif my_sett.time_zone eq +6> selected</cfif>>(GMT+06:00) Novosibirsk, Dakka, Astana</option>
                                <option value="+6.5"<cfif my_sett.time_zone eq +6.5> selected</cfif>>(GMT+06:30) Yongan(Rangoon)</option>
                                <option value="+7"  <cfif my_sett.time_zone eq +7> selected</cfif>>(GMT+07:00) Bangkok, Hanoi, Jakarta, Krasnoyarsk</option>
                                <option value="+8"  <cfif my_sett.time_zone eq +8> selected</cfif>>(GMT+08:00) Beijing, Chongqing, Hong Kong, Singapore</option>
                                <option value="+9"  <cfif my_sett.time_zone eq +9> selected</cfif>>(GMT+09:00) Osaka, Seoul, Tokyo</option>
                                <option value="+9.5"<cfif my_sett.time_zone eq +9.5> selected</cfif>>(GMT+09:30) Adelaide, Darwin</option>
                                <option value="+10" <cfif my_sett.time_zone eq +10>selected</cfif>>(GMT+10:00) Canberra, Melbourne, Sydney</option>
                                <option value="+11" <cfif my_sett.time_zone eq +11>selected</cfif>>(GMT+11:00) Magadan, Solomon Is., New Caledonia</option>
                                <option value="+12" <cfif my_sett.time_zone eq +12>selected</cfif>>(GMT+12:00) Auckland, Wellington, Fiji</option>
                                <option value="+13" <cfif my_sett.time_zone eq +13>selected</cfif>>(GMT+13:00) Nuku'alofa</option>
                            </select>
    --->					</td>
                    </tr>
                    <tr>
                        <td><div id="show_info" style="float:left; margin-top:3px; width:90px; margin-left:193px;"></div><input type="button" name="button1" id="button1" value="<cf_get_lang dictionary_id='57464.Güncelle'>" onclick="AjaxFormSubmit('form1','show_info',1,'Güncelleniyor','Güncellendi');"></td>
                    </tr>
            	</table>
            </cfform>
		</td>
	</tr>
</table>
