 <cfif isdefined("attributes.is_form_submitted")>
    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
        SELECT 
            SALES_ZONES_TEAM.TEAM_ID,
            SALES_ZONES_TEAM.TEAM_NAME,
            SALES_ZONES.SZ_NAME
        FROM 
            SALES_ZONES_TEAM,
            SALES_ZONES
        WHERE 
            SALES_ZONES.SZ_ID = SALES_ZONES_TEAM.SALES_ZONES
             <cfif (isdefined("attributes.keyword") and len(attributes.keyword)) >
            AND SALES_ZONES_TEAM.TEAM_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
             </cfif>
            ORDER BY 
            SALES_ZONES_TEAM.TEAM_NAME
    </cfquery>
<cfelse>
	<cfset get_sales_zones_team.recordcount = 0>    
</cfif>    
<script type="text/javascript">
function add_sales_zone(sales_zone_team_name,sales_zone_team_id)
{

	<cfif isDefined("attributes.field_sz_team_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_sz_team_name#</cfoutput>.value = sales_zone_team_name;
	</cfif>
	<cfif isDefined("attributes.field_sz_team_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_sz_team_id#</cfoutput>.value = sales_zone_team_id;
	</cfif>
	<cfif isdefined("attributes.call_function")>
		try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;}
			catch(e){};
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
		<cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.modal_id" default="">
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfif not isNumeric(attributes.maxrows)>
			<cfset attributes.maxrows = session.ep.maxrows>
		</cfif>
<cfparam name="attributes.totalrecords" default='#get_sales_zones_team.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','Satış Takımları',57803)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="search_team" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&field_sz_team_id=#attributes.field_sz_team_id#&field_sz_team_name=#attributes.field_sz_team_name#">
        <cf_box_search more="0">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="form-group" id="item-keyword">
                <cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" maxlength="50" value="#attributes.keyword#">
            </div>
            <div class="form-group small">
                <cfinput type="text" name="maxrows" required="yes" onKeyUp="isNumber(this)" value="#attributes.maxrows#" validate="integer" range="1,250" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_team' , #attributes.modal_id#)"),DE(""))#">
            </div>
        </cf_box_search>                       
    </cfform>
    <cf_grid_list>
        <thead>
            <tr>
                <th width="35"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='57803.Satış Takımı'></th>
                <th><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_sales_zones_team.recordcount>
                <cfoutput query="get_sales_zones_team" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td><a href="javascript:add_sales_zone('#team_name#','#team_id#');" class="tableyazi">#currentrow#</a></td>
                        <td><a href="javascript:add_sales_zone('#team_name#','#team_id#');" class="tableyazi">#team_name#</a></td>
                        <td>#sz_name#</td>	
                    </tr>
                </cfoutput>
            <cfelse>
                <tr> 
                    <td colspan="3">
                        <cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
                            <cf_get_lang dictionary_id='57484.Kayıt Yok'>!
                        <cfelse>
                            <cf_get_lang dictionary_id='57701.Filtre Ediniz '>!
                        </cfif>
                    </td>
                </tr>    
            </cfif> 
        </tbody>
    </cf_grid_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfset url_string = "">
        <cfif isDefined("attributes.field_sz_team_id") and len(attributes.field_sz_team_id)>
            <cfset url_string = '#url_string#&field_sz_team_id=#attributes.field_sz_team_id#'>
        </cfif>
        <cfif isDefined("attributes.field_sz_team_name") and len(attributes.field_sz_team_name)>
            <cfset url_string = '#url_string#&field_sz_team_name=#attributes.field_sz_team_name#'>
        </cfif>
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#attributes.fuseaction#&#url_string#&keyword=#attributes.keyword#&is_form_submitted=1"
            isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cfif>
</cf_box>


