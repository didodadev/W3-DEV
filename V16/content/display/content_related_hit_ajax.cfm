<cfsetting showdebugoutput="no">
<cfquery name="GET_HIT_COUNT" datasource="#DSN#">
	SELECT 
    	ISNULL(HIT_PARTNER,0) AS HIT_PARTNER,
        ISNULL(HIT,0) AS HIT,
        ISNULL(HIT_EMPLOYEE,0) AS HIT_EMPLOYEE,
		ISNULL(HIT_GUEST,0) AS HIT_GUEST
    FROM 
    	CONTENT 
    WHERE 
    	CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
</cfquery>
<cf_ajax_list>	
	<tbody>
		<cfoutput>
            <tr>
                <td style="width:150px"><cf_get_lang_main no='164.Çalışan'></td>
                <td style="text-align:right;" width="400">: #get_hit_count.hit_employee#</td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='173.Kurumsal Üye'></td>
                <td style="text-align:right;">: #get_hit_count.hit_partner#</td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='174.Bireysel Üye'></td>
                <td style="text-align:right;">: #get_hit_count.hit#</td>
            </tr>
             <tr>
                <td><cf_get_lang no='26.Ziyaretçi'></td>
                <td style="text-align:right;">: #get_hit_count.hit_guest#</td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='80.Toplam'></td>
                <td style="text-align:right;">: #get_hit_count.hit_guest+get_hit_count.hit+get_hit_count.hit_partner+get_hit_count.hit_employee#</td>
            </tr>
        </cfoutput>
    </tbody>
</cf_ajax_list>
