<cf_get_lang_set module_name="product">
<cfsetting showdebugoutput="no">
<cfquery name="GET_SETUP_CITY" datasource="#DSN#">
	SELECT 
		SETUP_CITY.CITY_NAME,
		SETUP_CITY.CITY_ID 
	FROM 
		SETUP_CITY,
		SETUP_COUNTRY 
	WHERE 
		SETUP_COUNTRY.COUNTRY_ID = SETUP_CITY.COUNTRY_ID AND
		SETUP_COUNTRY.IS_DEFAULT = 1
	ORDER BY
		SETUP_CITY.CITY_NAME
</cfquery>
<cfparam name="attributes.mode" default="3">  
<!--- Bu cariye ait hangi iller secilmis --->
<cfquery name="GET_CONTROL" datasource="#DSN#">
	SELECT 
		MULTI_CITY_ID
	FROM 
		SHIP_METHOD_PRICE
	WHERE
		MULTI_CITY_ID IS NOT NULL AND
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		<cfif isdefined("attributes.ship_method_price_id")>
            AND SHIP_METHOD_PRICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_price_id#">
        </cfif>
</cfquery>
<cfset kontrol_city_list = ''>
<cfif get_control.recordcount>
	<cfoutput query="get_control">
		<cfset kontrol_city_list = listappend(kontrol_city_list,get_control.multi_city_id)>
	</cfoutput>
	<cfset kontrol_city_list = ","&listdeleteduplicates(kontrol_city_list)&",">
</cfif>
<cf_box title="Sevkiyat Bölgesi İl Seçimi">
    <div style="height:300px; overflow:auto;">
        <table border="0" width="200" cellpadding="2" cellspacing="1">
            <tr>
                <td class="txtbold"><input type="checkbox" id="select_all" name="select_all"  onclick="checkall_uncheckall()" selected/><cf_get_lang no='803.Hepsini Seç'></td>
            </tr>
            <cfloop  from = "1" to = "#get_setup_city.recordcount#" index = "LoopCount">
                <cfif ((LoopCount mod attributes.mode is 1)) or (LoopCount eq 1)>
                    <tr>
                </cfif>
                <td nowrap="nowrap">
                    <cfoutput>
                        <!--- diger fiyat listelerinde secilmis bu cariye ait illerin secilememesi icin BK --->
                        <cfif listfind(kontrol_city_list,get_setup_city.city_id[LoopCount])>
                            <!--- <input type="hidden" name="control_#get_setup_city.city_id[LoopCount]#" value="0"> --->
                            <input type="checkbox" name="select_city_#get_setup_city.city_id[LoopCount]#" id="select_city_#get_setup_city.city_id[LoopCount]#" value="#get_setup_city.city_id[LoopCount]#" disabled>#get_setup_city.city_name[LoopCount]#
                        <cfelse>
                            <!--- <input type="hidden" name="control_#get_setup_city.city_id[LoopCount]#" value="1"> --->
                            <input type="checkbox" name="select_city_#get_setup_city.city_id[LoopCount]#" id="select_city_#get_setup_city.city_id[LoopCount]#" value="#get_setup_city.city_id[LoopCount]#" <cfif listfind(multi_city_id,get_setup_city.city_id[LoopCount])> checked</cfif>>#get_setup_city.city_name[LoopCount]#
                        </cfif>
                    </cfoutput>
                </td>
                <cfif ((LoopCount mod attributes.mode is 0)) or (LoopCount eq get_setup_city.recordcount)>
                    </tr>
                </cfif>                  
            </cfloop>
            <tr>
                <td colspan="<cfoutput>#attributes.mode-1#</cfoutput>"></td>
                <td><input type="button" value="<cf_get_lang_main no='170.Ekle'>" onclick="city_add()"></td>		
            </tr>
        </table>
    </div>
</cf_box>
<script type="text/javascript">
	function city_add()
	{
		city_list = '';
		<cfoutput query="get_setup_city">
			if(document.getElementById('select_city_#city_id#').checked == true)
				if(city_list == '')
					city_list+=','+document.getElementById('select_city_#city_id#').value+',';
				else
					city_list+=document.getElementById('select_city_#city_id#').value+',';
		</cfoutput>
		document.getElementById('multi_city_id').value = city_list ;
		gizle(is_sending_zone);
	}	
	function checkall_uncheckall()
	{
		<cfoutput>
			<cfloop from="1" to="#get_setup_city.recordcount#" index="LoopCount">
				document.getElementById('select_city_#get_setup_city.city_id[LoopCount]#').checked=document.getElementById('select_all').checked;
			</cfloop>
		</cfoutput>
	}
</script>
