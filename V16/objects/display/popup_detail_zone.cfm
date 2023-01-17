<cfquery name="GET_ZONE_BRANCH_COUNT" datasource="#DSN#">
	SELECT COUNT(ZONE_ID) AS TOTAL FROM BRANCH WHERE ZONE_ID=#attributes.ID#
</cfquery>		
<cfquery name="CATEGORY" datasource="#DSN#">
	SELECT * FROM ZONE WHERE ZONE_ID=#URL.ID# 
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57992.Bölge'></cfsavecontent>
<cf_popup_box title="#message# : #category.zone_name#">
    <table>
        <tr> 
            <td width="100" class="formbold"><cf_get_lang dictionary_id='32820.Ayrıntı'></td>
            <td width="185"><cfoutput>#category.zone_detail#</cfoutput></td>
            <td width="75" class="formbold"><cf_get_lang dictionary_id='57756.Durum'></td>
            <td><cfif len(category.zone_status) and category.zone_status><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
        </tr>
        <tr> 
            <td class="formbold"><cf_get_lang dictionary_id='29511.Yönetici'>1</td>
            <td>
                <input type="Hidden" name="admin1_position_code" id="admin1_position_code" value="<cfoutput>#category.admin1_position_code#</cfoutput>">
                <cfif len(category.admin1_position_code)>
                <cfset attributes.employee_id = "">
                <cfset attributes.position_code = category.admin1_position_code>
                <cfinclude template="../query/get_position.cfm">
                <cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>
                </cfif>
            </td>
            <td class="formbold"><cf_get_lang dictionary_id='57428.E-Mail'></td>
            <td><cfoutput>#category.zone_email#</cfoutput></td>
        </tr>
        <tr> 
            <td class="formbold"><cf_get_lang dictionary_id='29511.Yönetici'> 2</td>
            <td>
                <cfif len(category.admin2_position_code)>
                <cfset attributes.employee_id = "">
                <cfset attributes.position_code = category.admin2_position_code>
                <cfinclude template="../query/get_position.cfm">
                <cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>
                </cfif>
            </td>	
            <td class="formbold"><cf_get_lang dictionary_id='58723.Adres'></td>
            <td><cfoutput>#category.zone_address#</cfoutput></td>
        </tr>
        <tr> 
            <td class="formbold"><cf_get_lang dictionary_id='32407.Tel Kod'>1</td>
            <td><cfoutput>#category.zone_telcode#-#category.zone_tel1#</cfoutput></td>
            <td class="formbold"><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
            <td><cfoutput>#category.postcode#</cfoutput></td>
        </tr>
        <tr> 
            <td class="formbold"><cf_get_lang dictionary_id='57499.Telefon'> 2</td>
            <td><cfoutput>#category.zone_tel2#</cfoutput></td>
            <td class="formbold"><cf_get_lang dictionary_id='58638.İlçe'></td>
            <td><cfoutput>#category.county#</cfoutput></td>
        </tr>
        <tr> 
            <td class="formbold"><cf_get_lang dictionary_id='57499.Telefon'> 3</td>
            <td><cfoutput>#category.zone_tel3#</cfoutput></td>
            <td class="formbold"><cf_get_lang dictionary_id='57971.Şehir'></td>
            <td><cfoutput>#category.city#</cfoutput></td>
        </tr>
        <tr> 
            <td class="formbold"><cf_get_lang dictionary_id='57488.Fax'></td>
            <td><cfoutput>#category.zone_fax#</cfoutput></td>
            <td class="formbold"><cf_get_lang dictionary_id='58219.Ülke'></td>
            <td><cfoutput>#category.country#</cfoutput></td>
        </tr>
    </table>
</cf_popup_box>
