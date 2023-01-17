<cfsetting showdebugoutput="no">
<cfparam name="attributes.modal_id" default="">
<cfscript>
	url_str = '';
	if (isdefined('attributes.function_name')) url_str = '#url_str#&function_name=#attributes.function_name#';
	if (isdefined('attributes.field_id')) url_str = '#url_str#&field_id=#attributes.field_id#';
	if (isdefined('attributes.width')) url_str = '#url_str#&width=#attributes.width#';
	if (isdefined('attributes.length')) url_str = '#url_str#&length=#attributes.length#';
	if (isdefined('attributes.height')) url_str = '#url_str#&height=#attributes.height#';
	if (isdefined('attributes.field_name')) url_str = '#url_str#&field_name=#attributes.field_name#';
	if (isdefined('attributes.field_motorized_vehicle')) url_str = '#url_str#&field_motorized_vehicle=#attributes.field_motorized_vehicle#';
	if (isdefined('attributes.event_id')) url_str = '#url_str#&event_id=#attributes.event_id#';
	if (isdefined('attributes.motorized_vehicle')) url_str = '#url_str#&motorized_vehicle=#attributes.motorized_vehicle#';
	if (isdefined('attributes.call_function')) url_str = '#url_str#&call_function=#attributes.call_function#';
	if (isdefined('attributes.only_physical_asset')) url_str = '#url_str#&only_physical_asset=#attributes.only_physical_asset#';
	if (isdefined('attributes.only_it_asset')) url_str = '#url_str#&only_it_asset=#attributes.only_it_asset#';
	if (isdefined('attributes.userId')) url_str = '#url_str#&userId=#attributes.userId#';
	if (isdefined('attributes.position_code')) url_str = '#url_str#&position_code=#attributes.position_code#';
	if (isdefined('attributes.employee_id')) url_str = '#url_str#&employee_id=#attributes.employee_id#';
	if (isdefined('attributes.position_employee_name')) url_str = '#url_str#&position_employee_name=#attributes.position_employee_name#';
	if (isdefined('attributes.member_type')) url_str = '#url_str#&member_type=#attributes.member_type#';
	if (isdefined('attributes.only_motorized_vehicle')) url_str = '#url_str#&only_motorized_vehicle=#attributes.only_motorized_vehicle#';
</cfscript>
<cfquery name="get_relation_physical_asset" datasource="#dsn#">
	SELECT
		ASSET_P.ASSETP,
		ASSET_P.ASSETP_ID,
		ASSET_P.POSITION_CODE,
		ASSET_P_CAT.ASSETP_CAT,
		ASSET_P_CAT.MOTORIZED_VEHICLE,
		ASSET_P.PHYSICAL_ASSETS_HEIGHT,
		ASSET_P.PHYSICAL_ASSETS_SIZE,
		ASSET_P.PHYSICAL_ASSETS_WIDTH,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		EP.POSITION_NAME,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		EP.EMPLOYEE_ID,
		ZONE.ZONE_NAME
	FROM
		EMPLOYEE_POSITIONS EP,
		ASSET_P,
		ASSET_P_CAT,			
		DEPARTMENT,
		BRANCH,
		ZONE
	WHERE
		ASSET_P.POSITION_CODE = EP.POSITION_CODE AND
		ASSET_P.STATUS = 1 AND 
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
		ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND 
		ZONE.ZONE_ID = BRANCH.ZONE_ID AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P.RELATION_PHYSICAL_ASSET_ID = #attributes.asset_id#
</cfquery>
    <cf_flat_list>
        <cfif get_relation_physical_asset.recordcount>
            <cfoutput query="get_relation_physical_asset">
                 <tr>
                    <td width="10"></td>
                    <td width="15" align="center" id="asset_row#currentrow#" class="color-row" onClick="gizle_goster(document.getElementById('asset_detail#assetp_id##currentrow#'));connectAjax('#currentrow#','#assetp_id#');gizle_goster('asset_goster#assetp_id##currentrow#');gizle_goster(document.getElementById('asset_gizle#assetp_id##currentrow#'));">
                        <img id="asset_goster#assetp_id##currentrow#" style="cursor:pointer;" src="/images/kapa.gif" border="0" alt="<cf_get_lang_main no ='1184.Göster'>" title="<cf_get_lang_main no ='1184.Göster'>">
                        <img id="asset_gizle#assetp_id##currentrow#" style="cursor:pointer;" src="/images/asagi.gif" border="0" alt="<cf_get_lang_main no ='1216.Gizle'>" title="<cf_get_lang_main no ='1216.Gizle'>">
                    </td>
                    <td><cfset assetp_ = replace(assetp,"'","","all")>
                        <a href="javascript://" onClick="asset_care_realation('#assetp_id#','#assetp_#','#motorized_vehicle#','#PHYSICAL_ASSETS_WIDTH#','#PHYSICAL_ASSETS_SIZE#','#PHYSICAL_ASSETS_HEIGHT#','#position_code#','#employee_name# #employee_surname#','#employee_id#');" class="tableyazi">#assetp#</a>
                    </td>
                    <td width="130" colspan="2">#zone_name# / #branch_name# / #department_head#</td>
                    <td width="130">#employee_name# #employee_surname#</td>
                    <td width="100">#assetp_cat#</td>
                    <td width="50"><cfif len(PHYSICAL_ASSETS_WIDTH)>#PHYSICAL_ASSETS_WIDTH# <cfelse> 0</cfif> x <cfif len(PHYSICAL_ASSETS_SIZE)>#PHYSICAL_ASSETS_SIZE# <cfelse>0</cfif> x <cfif len(PHYSICAL_ASSETS_HEIGHT)> #PHYSICAL_ASSETS_HEIGHT# <cfelse>0</cfif></td>
                </tr>
                <tr id="asset_detail#assetp_id##currentrow#" style="display:none;">
                    <td colspan="7"><div align="left" id="RELATION_PHYSICAL_ASSET#currentrow#"></div></td>
                </tr>
              </cfoutput>
          <cfelse>
          <tr>
            <td colspan="7"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
          </tr>
          </cfif>
    </cf_flat_list>   
<script type="text/javascript">
function asset_care_realation(id,assetp,motorized_vehicle,width,length,height,position_code,position_name,employee_id)
{
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_name#</cfoutput>.value = assetp;
	</cfif>
	<cfif isdefined("attributes.field_motorized_vehicle")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_motorized_vehicle#</cfoutput>.value = motorized_vehicle;
	</cfif>
	<cfif isdefined("attributes.width")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#width#</cfoutput>.value = width;
	</cfif>
	<cfif isdefined("attributes.length")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#length#</cfoutput>.value = length;
	</cfif>
	<cfif isdefined("attributes.position_code")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#position_code#</cfoutput>.value = position_code;
	</cfif>
	<cfif isdefined("attributes.employee_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#employee_id#</cfoutput>.value = employee_id;
	</cfif>	
	<cfif isdefined("attributes.position_employee_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#position_employee_name#</cfoutput>.value = position_name;
	</cfif>
	<cfif isdefined("attributes.member_type")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#member_type#</cfoutput>.value = 'employee';
	</cfif>
	<cfif isdefined("attributes.height")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#height#</cfoutput>.value = height;
	</cfif>
	<cfif isdefined("attributes.call_function")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.call_function#();</cfoutput>;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
function connectAjax(crtrow,asset_id){
	if(asset_id==0) var asset_id = document.getElementById('asset_id_'+crtrow).value;
	var bb = '<cfoutput>#request.self#?fuseaction=assetcare.emptypopup_relation_list_assetp_ajax&asset_id='+asset_id+'&#url_str#<cfif isdefined("attributes.draggable")>&draggable=#attributes.draggable#</cfif>'</cfoutput>;
	AjaxPageLoad(bb,'RELATION_PHYSICAL_ASSET'+crtrow,1);
}
</script>
