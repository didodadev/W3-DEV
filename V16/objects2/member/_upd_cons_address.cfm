<!--- Adres Bilgileri  --->
<cfset kontrol_zone = 0>
<cfif not isdefined("attributes.is_other_address")>
	<cfset attributes.is_other_address = 1>
</cfif>
<cfif isdefined("attributes.is_ref_member_zone") and attributes.is_ref_member_zone eq 1 and isdefined("session.ww.userid")>
	<cfquery name="GET_CONTROL_CITY" datasource="#DSN#">
		SELECT ISNULL(HOME_CITY_ID,WORK_CITY_ID) AS CITY_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfif get_control_city.recordcount and len(get_control_city.city_id)>
		<cfset kontrol_zone = ''>
		<cfquery name="GET_CITY_CODE" datasource="#DSN#">
			SELECT PLATE_CODE FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_control_city.city_id#">
		</cfquery>
		<cfif get_city_code.plate_code eq 34>
			<cfquery name="GET_CITYS" datasource="#DSN#">
				SELECT CITY_ID FROM SETUP_CITY WHERE PLATE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_city_code.plate_code#">
			</cfquery>
			<cfloop query="get_citys">
				<cfset kontrol_zone = listappend(kontrol_zone,get_citys.city_id,',')>
			</cfloop>
		<cfelse>
			<cfset kontrol_zone = listappend(kontrol_zone,get_control_city.city_id,',')>
		</cfif>
	<cfelse>
		<cfset kontrol_zone = -1>
	</cfif>
</cfif>
<table style="width:100%;">
    <cfif isDefined('attributes.is_home_address') and attributes.is_home_address eq 1>
        <tr class="header" style="height:20px;"> 
            <td onclick="gizle_goster(add_1);gizle_goster(add_2);gizle(gizli3);gizle(gizli4);" colspan="2" class="header_title" style="cursor:pointer;">Adres Bilgileri</td>
        </tr>
        <tr id="add_1" style="height:20px;">
            <td onclick="goster(gizli3);gizle(gizli4);" colspan="2" class="tableyazi" style="cursor:pointer;">&nbsp;&nbsp;&nbsp;&raquo;<cf_get_lang no='213.Ev Adresi'></td>
        </tr>
        <cfif len(get_consumer.home_district_id)>
            <cfquery name="GET_HOME_DIST" datasource="#DSN#">
                SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_district_id#"> 
            </cfquery>
            <cfset home_dis = '#get_home_dist.district_name# '>
        <cfelse>
            <cfset home_dis = ''>
        </cfif>
        <tr style="display:none;" id="gizli3">
            <input type="hidden" name="is_other_address" id="is_other_address" value="<cfoutput>#attributes.is_other_address#</cfoutput>">
            <td class="contentforlabel" style="vertical-align:top;">
                <table>
                    <tr>
                        <th style="width:150px;"><cf_get_lang_main no='807.Ülke'></th>
                        <td><select name="home_country" id="home_country" onchange="LoadCity(this.value,'home_city_id','home_county_id',<cfif isdefined('kontrol_zone') and len(kontrol_zone)><cfoutput>'#kontrol_zone#'</cfoutput></cfif><cfif isdefined('attributes.is_detail_adres') and attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'home_district_id'</cfif>)" style="width:140px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_country">
                                    <option value="#country_id#" <cfif is_default eq 1>selected</cfif>>#country_name#</option>
                                </cfoutput>
                            </select>				
                        </td>
                    </tr>
                    <tr>
                        <th><cf_get_lang_main no='559.Şehir'></th>
                        <td><select name="home_city_id" id="home_city_id"  onchange="LoadCounty(this.value,'home_county_id','','0'<cfif isdefined('attributes.is_detail_adres') and attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'home_district_id'</cfif>);" style="width:140px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_consumer.home_city_id) and len(get_consumer.home_country_id)>
                                    <cfquery name="GET_CITY_HOME" datasource="#DSN#">
                                        SELECT 
                                            CITY_ID, CITY_NAME 
                                        FROM 
                                            SETUP_CITY 
                                        WHERE 
                                            COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_country_id#">
                                            <cfif isdefined("kontrol_zone") and kontrol_zone neq 0>
                                                AND CITY_ID IN(#kontrol_zone#)
                                            </cfif>
                                    </cfquery>
                                    <cfoutput query="get_city_home">
                                        <option value="#city_id#" <cfif get_consumer.home_city_id eq city_id>selected</cfif>>#city_name#</option>	
                                    </cfoutput>
                                </cfif>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><cf_get_lang_main no='1226.İlçe'></th>
                        <td><select name="home_county_id" id="home_county_id"<cfif isdefined('attributes.is_detail_adres') and   attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'home_district_id');"</cfif> style="width:140px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_consumer.home_county_id) and len(get_consumer.home_city_id)>
                                    <cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
                                        SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_city_id#">
                                    </cfquery>										
                                    <cfoutput query="get_county_home">
                                        <option value="#county_id#" <cfif get_consumer.home_county_id eq county_id>selected</cfif>>#county_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><cf_get_lang_main no='720.Semt'></th>
                        <td><input type="text" name="home_semt" id="home_semt" value="<cfoutput>#get_consumer.homesemt#</cfoutput>" maxlength="30" style="width:140px;"></td>	
                    </tr>
                    <cfif isdefined('attributes.is_detail_adres') and attributes.is_detail_adres eq 1>
                        <tr>
                            <th><cf_get_lang_main no='1323.Mahalle'></th>
                            <td><cfif attributes.is_residence_select eq 0>
                                    <input type="text" name="home_district" id="home_district" value="<cfif len(get_consumer.home_district)><cfoutput>#get_consumer.home_district#</cfoutput><cfelse><cfoutput>#home_dis#</cfoutput></cfif>" style="width:140px;">
                                <cfelse>
                                    <select name="home_district_id" id="home_district_id" style="width:140px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfif len(get_consumer.home_district_id)>
                                            <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_county_id#">
                                            </cfquery>										
                                            <cfoutput query="get_district_name">
                                                <option value="#district_id#" <cfif get_consumer.home_district_id eq district_id>selected</cfif>>#district_name#</option>
                                            </cfoutput>
                                        </cfif>
                                    </select>
                                </cfif>
                            </td>
                        </tr>
                    </cfif>                	
                </table>
            </td>
            <td>
                <table>
                    <cfif isdefined('attributes.is_detail_adres') and  attributes.is_detail_adres eq 0>
                        <tr>
                            <th rowspan="3" style="vertical-align:top;width:150px;"><cf_get_lang_main no='1311.Adres'></th>
                            <td rowspan="3"><textarea name="home_address" id="home_address" style="width:140px;height:75px;"><cfoutput>#home_dis##get_consumer.homeaddress#</cfoutput></textarea></td>
                        </tr>
                    <cfelse>
                        <tr>
                            <th style="width:150px;"><cf_get_lang no='1335.Cadde'></th>
                            <td><input type="text" name="home_main_street" id="home_main_street" value="<cfoutput>#get_consumer.home_main_street#</cfoutput>" style="width:140px;"></td>
                        </tr>
                        <tr>
                            <th><cf_get_lang no='1334.Sokak'></th>
                            <td><input type="text" name="home_street" id="home_street" style="width:140px;" value="<cfoutput>#get_consumer.home_street#</cfoutput>"></td>
                        </tr>
                        <tr>
                            <th><cf_get_lang no='215.Posta Kodu'></th>
                            <td><input type="text" name="home_postcode" id="home_postcode" maxlength="15" value="<cfoutput>#get_consumer.homepostcode#</cfoutput>" style="width:140px;"></td>
                        <tr>
                            <th style="vertical-align:top;"><cf_get_lang no='1368.Adres Detay'></th>
                            <td><textarea name="home_door_no" id="home_door_no"  style="width:140px;" maxlength="200"><cfoutput>#get_consumer.home_door_no#</cfoutput></textarea></td>
                        </tr>
                    </cfif>
                 </table>
            </td>
        </tr>
    </cfif>
    <cfif len(get_consumer.work_district_id)>
        <cfquery name="GET_WORK_DIST" datasource="#DSN#">
            SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_district_id#">
        </cfquery>
        <cfset work_dis = '#get_work_dist.district_name# '>
    <cfelse>
        <cfset work_dis = ''>
    </cfif>
    <cfif isDefined('attributes.is_work_address') and attributes.is_work_address eq 1>
        <tr id="add_2" style="height:20px;">
            <td onclick="goster(gizli4);gizle(gizli3);" class="tableyazi" style="cursor:pointer;">&nbsp;&nbsp;&nbsp;&raquo;<cf_get_lang no='216.İş Adresim'></td>
        </tr>
        <tr style="display:none;" id="gizli4">
            <td style="vertical-align:top;">
                <table>
                    <tr>
                        <th style="width:150px;"><cf_get_lang_main no='807.Ülke'></th>
                        <td><select name="work_country" id="work_country" style="width:140px;" onchange="LoadCity(this.value,'work_city_id','work_county_id',<cfif isdefined('kontrol_zone') and len(kontrol_zone)><cfoutput>'#kontrol_zone#'</cfoutput></cfif><cfif isdefined('attributes.is_detail_adres') and  attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'work_district_id'</cfif>)">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_country">
                                    <option value="#country_id#" <cfif is_default eq 1>selected</cfif>>#country_name#</option>
                                </cfoutput>
                            </select>				
                        </td>
                    </tr>
                    <tr>
                        <th><cf_get_lang_main no='559.Şehir'></th>
                        <td><select name="work_city_id"  id="work_city_id" onchange="LoadCounty(this.value,'work_county_id','','0'<cfif isdefined('attributes.is_detail_adres') and  attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'work_district_id'</cfif>);" style="width:140px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_consumer.work_city_id)>
                                    <cfquery name="GET_CITY_WORK" datasource="#DSN#">
                                        SELECT 
                                            CITY_ID,
                                            CITY_NAME 
                                        FROM 
                                            SETUP_CITY 
                                        WHERE 
                                            COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">
                                            <cfif isdefined("kontrol_zone") and kontrol_zone neq 0>
                                                AND CITY_ID IN(#kontrol_zone#)
                                            </cfif>
                                    </cfquery>
                                    <cfoutput query="get_city_work">
                                        <option value="#city_id#" <cfif get_consumer.work_city_id eq city_id>selected</cfif>>#city_name#</option>	
                                    </cfoutput>
                                </cfif>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><cf_get_lang_main no='1226.İlçe'></th>
                        <td><select name="work_county_id"  id="work_county_id" <cfif isdefined('attributes.is_detail_adres') and  attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'work_district_id');"</cfif> style="width:140px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_consumer.work_county_id)>
                                    <cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
                                        SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_city_id#">
                                    </cfquery>										
                                    <cfoutput query="get_county_work">
                                        <option value="#county_id#" <cfif get_consumer.work_county_id eq county_id>selected</cfif>>#county_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><cf_get_lang_main no='720.Semt'></th>
                        <td><input type="text" name="work_semt" id="work_semt" value="<cfoutput>#get_consumer.worksemt#</cfoutput>" maxlength="30" style="width:140px;"></td>	
                    </tr>
                    <cfif isdefined('attributes.is_detail_adres') and  attributes.is_detail_adres eq 1>
                        <tr>
                            <th>&nbsp;</th>
                            <th><cf_get_lang_main no='1323.Mahalle'></th>
                            <td><cfif attributes.is_residence_select eq 0>
                                    <input type="text" name="work_district" id="work_district" style="width:140px;" value="<cfif len(get_consumer.work_district)><cfoutput>#get_consumer.work_district#</cfoutput><cfelse><cfoutput>#work_dis#</cfoutput></cfif>">
                                <cfelse>
                                    <select name="work_district_id" id="work_district_id" style="width:140px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfif len(get_consumer.work_district_id)>
                                            <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_county_id#">
                                            </cfquery>										
                                            <cfoutput query="get_district_name">
                                                <option value="#district_id#" <cfif get_consumer.work_district_id eq district_id>selected</cfif>>#district_name#</option>
                                            </cfoutput>
                                        </cfif>
                                    </select>
                                </cfif>
                            </td>
                        </tr>
                    </cfif>
                </table>
            </td>
            <td>
                <table border="0">
                    <cfif isdefined('attributes.is_detail_adres') and  attributes.is_detail_adres eq 0>
                        <tr>
                            <th style="vertical-align:top; width:150px;"><cf_get_lang_main no='1311.Adres'></th>
                            <td rowspan="3"><textarea name="work_address" id="work_address" style="width:140px;height:75px;"><cfoutput>#work_dis##get_consumer.workaddress#</cfoutput></textarea></td>
                        </tr>
                    <cfelse>
                        <tr>
                            <th style="width:150px;"><cf_get_lang no='1335.Cadde'></th>
                            <td><input type="text" name="work_main_street" id="work_main_street" style="width:140px;" value="<cfoutput>#get_consumer.work_main_street#</cfoutput>"></td>  
                        </tr>
                        <tr>
                            <th><cf_get_lang no='1334.Sokak'></th>
                            <td><input type="text" name="work_street" id="work_street" style="width:140px;" value="<cfoutput>#get_consumer.work_street#</cfoutput>"></td
                        ></tr>
                        <tr>
                            <th><cf_get_lang no='215.Posta Kodu'></th>
                            <td><input type="text" name="work_postcode" id="work_postcode" maxlength="15" value="<cfoutput>#get_consumer.workpostcode#</cfoutput>" style="width:140px;"></td>
                        </tr>
                        <tr>
                            <th style="vertical-align:top;"><cf_get_lang no='1368.Adres Detay'></th>
                            <td><textarea name="work_door_no" id="work_door_no" style="width:140px;" maxlength="200"><cfoutput>#get_consumer.work_door_no#</cfoutput></textarea></td>
                        </tr>
                    </cfif>
                </table>
            </td>
        </tr>
    </cfif>
</table>

