<cfinclude template="../query/get_country.cfm">
<cfif attributes.is_comp eq 0>  
	<cfquery name="get_address" datasource="#dsn#">
        SELECT
            <cfif attributes.no eq 1>
                TAX_ADRESS AS ADDRESS,
                TAX_POSTCODE AS POSTCODE,
                TAX_COUNTRY_ID AS COUNTRY,
                TAX_CITY_ID AS CITY,
                TAX_SEMT AS SEMT,
                TAX_COUNTY_ID AS COUNTY,
            <cfelseif attributes.no eq 2>
                HOMEADDRESS AS ADDRESS,
                HOMEPOSTCODE AS POSTCODE,
                HOME_COUNTRY_ID AS COUNTRY,
                HOME_CITY_ID AS CITY,
                HOME_COUNTY_ID AS COUNTY,
                HOMESEMT AS SEMT,
            <cfelseif attributes.no eq 3>
                WORKADDRESS AS ADDRESS,
                WORKPOSTCODE AS POSTCODE,
                WORK_COUNTY_ID AS COUNTY,
                WORK_CITY_ID AS CITY,
                WORK_COUNTRY_ID AS COUNTRY,
                WORKSEMT AS SEMT,
            </cfif>
            	RECORD_MEMBER AS RECORD_EMP,
                UPDATE_EMP AS UPDATE_EMP,
                RECORD_DATE,
                UPDATE_DATE
        FROM
            CONSUMER
        WHERE
            CONSUMER_ID=<cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.consumer_id#">
    </cfquery>
<cfelse>
	<cfquery name="get_address" datasource="#dsn#">
        SELECT 
            COMPANY_ADDRESS ADDRESS, 
            COMPANY_POSTCODE POSTCODE, 
            COUNTY COUNTY, 
            CITY CITY, 
            COUNTRY COUNTRY, 
            SEMT SEMT,
            RECORD_EMP AS RECORD_EMP,
            UPDATE_EMP AS UPDATE_EMP,
            RECORD_DATE,
            UPDATE_DATE
         FROM 
            COMPANY 
        WHERE 
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
    </cfquery>
</cfif>
<cfquery name="record_name" datasource="#DSN#">
	SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_address.record_emp#">
</cfquery>
<cfif len(#get_address.update_emp#)>
    <cfquery name="update_name" datasource="#DSN#">
        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_address.update_emp#">
    </cfquery>
</cfif>
<cfform id="update_adress" name="update_adress" action="#request.self#?fuseaction=objects.emptypopup_upd_address_member&no=#attributes.no#&consumer_id=#attributes.consumer_id#&is_comp=#attributes.is_comp#" method="post">
	<table  width="100%" cellpadding="2" cellspacing="1" border="0" height="100%" class="color-border">
        <tr class="color-list">
          <td height="35" class="headbold"><cf_get_lang dictionary_id="33229.Adres Güncelle">:</td>
        </tr>
        <tr>
            <td valign="top" class="color-row">
                <table border="0">
               		<tr>
                        <td width="123" nowrap><cf_get_lang dictionary_id="58723.Adres"> :</td>
                      <td width="562"><textarea name="address" id="address" style="width:145px;height:45px" tabindex="7"><cfoutput>#get_address.address#</cfoutput></textarea></td>
                  </tr>
                    <tr>
                        <td nowrap><cf_get_lang dictionary_id="57472.Posta Kodu"> :</td>
                        <td><input type="text" id="p_code" name="p_code" style="width:145px" value="<cfoutput>#get_address.postcode#</cfoutput>"></td>
                     </tr>
                    <tr>
                        <td nowrap><cf_get_lang dictionary_id="58219.Ülke"> :</td>
                        <td>
                            <select name="country" id="country" style="width:145px" onChange="LoadCity(this.value,'city','county',0)">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								 <cfoutput query="GET_COUNTRY">
                                    <option value="#COUNTRY_ID#"<cfif get_address.country eq country_id>selected</cfif>>#COUNTRY_NAME#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap><cf_get_lang dictionary_id="57971.Şehir"> :</td>
                        <td>
                        <cfif len(get_address.country)>
                            <cfquery name="GET_CITY_HOME" datasource="#DSN#">
                                SELECT
                                    CITY_ID,
                                    CITY_NAME 
                                FROM 
                                    SETUP_CITY 
                                WHERE 
                                    COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_address.country#">
                            </cfquery>
                        </cfif>
                        	<select name="city" id="city" style="width:145px" onChange="LoadCounty(this.value,'county','')">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                	<cfif isdefined('get_city_home') and get_city_home.recordcount>
										<cfoutput query="get_city_home">
                                            <option value="#city_id#"<cfif get_city_home.city_id eq get_address.city>selected</cfif>>#city_name#</option>
                                        </cfoutput>
                                    </cfif>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap width="123"><cf_get_lang dictionary_id="58638.İlçe">:</td>
                      <td>
                        <cfif len(get_address.city)>
                        	<cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
                                SELECT 
                                    COUNTY_ID,
                                    COUNTY_NAME
                                FROM 
                                    SETUP_COUNTY 
                                WHERE 
                                    CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_address.city#">
                           </cfquery>
                        </cfif>
                            <select name="county" id="county" style="width:145px">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfif isdefined('get_county_home') and get_county_home.recordcount>
                                	<cfoutput query="get_county_home">
                                    	<option value="#county_id#"<cfif GET_COUNTY_HOME.COUNTY_ID eq get_address.county>selected</cfif>>#county_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap><cf_get_lang dictionary_id="58132.Semt">:</td>
                        <td><input type="text" id="town" name="town" value="<cfoutput>#get_address.semt#</cfoutput>" style="width:145px"></td>
                    </tr>
                    <tr>
                        <td colspan="2"><cf_get_lang dictionary_id='57483.Kayit'> :<cfoutput>#record_name.employee_name# #record_name.employee_surname# - #dateformat(get_address.record_date,dateformat_style)#</cfoutput><br/>
                            <cfif len(#get_address.update_emp#)><cf_get_lang dictionary_id='57703.Güncelleme'> : <cfoutput>#update_name.employee_name# #update_name.employee_surname# - #dateformat(get_address.update_date,dateformat_style)#</cfoutput></cfif>
                        </td>
                    </tr>
                    <tr>
                       <td style="text-align:right;" colspan="2"><cf_workcube_buttons is_upd='0'></td>
                    </tr>
                 </table>
            </td>
        </tr>
    </table>
</cfform> 

