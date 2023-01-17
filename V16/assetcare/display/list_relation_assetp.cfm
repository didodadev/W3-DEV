<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.asset_cat" default="">
<cfquery name="GET_ASSETP_CATS_RESERVE" datasource="#DSN#">
	SELECT ASSETP_CATID,ASSETP_CAT FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>
<cfquery name="GET_ASSETP_NAMES" datasource="#DSN#">
	SELECT
		ASSET_P.ASSETP,
		ASSET_P.ASSETP_ID,
		ASSET_P.POSITION_CODE,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		ZONE.ZONE_NAME
	FROM
		ASSET_P,
		ASSET_P_CAT,			
		DEPARTMENT,
		BRANCH,
		ZONE
	WHERE
		ASSET_P.STATUS = 1 AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) AND
		ISNULL(ASSET_P.DEPARTMENT_ID2,ASSET_P.DEPARTMENT_ID) = DEPARTMENT.DEPARTMENT_ID AND 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		ZONE.ZONE_ID = BRANCH.ZONE_ID AND 
		<cfif isdefined("attributes.row_assetp_id")>
			(ASSET_P_CAT.IT_ASSET = 0 AND ASSET_P_CAT.MOTORIZED_VEHICLE = 0) AND
		</cfif>
		ASSET_P.RELATION_PHYSICAL_ASSET_ID IS NULL
		<cfif len(attributes.keyword)>AND ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
		<cfif len(attributes.asset_cat)>AND ASSET_P.ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_cat#"></cfif>
	ORDER BY 
		ASSET_P.ASSETP
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('main',2207)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<!---Fiziki Varlıklar--->
    <cfform method="post" name="search_asset" action="#request.self#?fuseaction=assetcare.popup_list_relation_assetp">
        <cf_box_search>
            <cfoutput>
                <cfif isdefined("attributes.station_id")>
                    <input type="hidden" name="station_id" id="station_id" value="#attributes.station_id#">
                <cfelseif isdefined("attributes.prod_result_id")>
                    <input type="hidden" name="prod_result_id" id="prod_result_id" value="#attributes.prod_result_id#">
                <cfelseif isdefined("attributes.contract_id")>
                    <input type="hidden" name="contract_id" id="contract_id" value="#attributes.contract_id#" />
                <cfelse>
                    <input type="hidden" name="row_assetp_id" id="row_assetp_id" value="#attributes.row_assetp_id#">
                </cfif>
            </cfoutput>
            <input type="hidden" name="form_submitted" id="form_submitted" value="">
            <div class="form-group">
                <cfinput type="text" placeholder="#getlang('','filtre','57460')#" name="keyword" value="#attributes.keyword#" style="width:100px;">
            </div>
            <div class="form-group">
                <select name="asset_cat" id="asset_cat" placeholder="">
                    <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
                    <cfoutput query="get_assetp_cats_reserve">
                        <option value="#assetp_catid#" <cfif len(attributes.asset_cat) and (attributes.asset_cat eq assetp_catid)>selected</cfif>>#assetp_cat# 
                    </cfoutput>
                </select>
            </div> <div class="form-group small">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='43966.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="3" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_asset' , #attributes.modal_id#)"),DE(""))#"></td>
            </div>
            </cf_box_search>
	</cfform>	
<cf_grid_list>
    <thead>
        <tr> 
            <th><cf_get_lang dictionary_id='29452.Varlık'></th>
            <th><cf_get_lang dictionary_id='57930.Kullanıcı'> <cf_get_lang dictionary_id='30031.Lokasyon'></th>
            <th><cf_get_lang dictionary_id='57544.Sorumlu'> 1</th>
        </tr>
    </thead>
    <tbody>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#GET_ASSETP_NAMES.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>					
    <cfif GET_ASSETP_NAMES.RecordCount>
        <cfoutput query="GET_ASSETP_NAMES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
            <tr>
                <td><cfif isdefined("attributes.station_id")>
                    <a href="javascript://" class="tableyazi" onClick="javascript:add_record_relation_physical('#ASSETP_ID#','#attributes.station_id#',0);">#ASSETP#</a>
                    <cfelseif isdefined("attributes.prod_result_id")>
                    <a href="javascript://" class="tableyazi" onClick="javascript:add_record_relation_physical('#ASSETP_ID#','#attributes.prod_result_id#',1);">#ASSETP#</a>
                    <cfelseif isdefined("attributes.contract_id")>
                    <a href="javascript://" class="tableyazi" onClick="javascript:add_record_relation_physical('#ASSETP_ID#','#attributes.contract_id#',2);">#ASSETP#</a>
                    <cfelse>
                    <a href="javascript://" class="tableyazi" onClick="javascript:add_record('#ASSETP_ID#','#row_assetp_id#');">#ASSETP#</a>
                    </cfif>
                </td>
                <td>#zone_name# / #branch_name# / #department_head#</td>
                <td>#get_emp_info(position_code,1,1)#</td>
            </tr>
        </cfoutput> 
    <cfelse>
        <tr> 
            <td colspan="3"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
  </tbody>
</cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>
                <cfset url_str = "">
                <cfif isdefined('attributes.form_submitted') and len(attributes.form_submitted)>
                    <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
                </cfif>
                <cfif isDefined('attributes.station_id') and len(attributes.station_id)>
                    <cfset url_str = "#url_str#&station_id=#attributes.station_id#">
                </cfif>
                <cfif isDefined('attributes.prod_result_id') and len(attributes.prod_result_id)>
                    <cfset url_str = "#url_str#&prod_result_id=#attributes.prod_result_id#">
                </cfif>
                <cfif isDefined('attributes.contract_id') and len(attributes.contract_id)>
                    <cfset url_str = "#url_str#&contract_id=#attributes.contract_id#">
                </cfif>
                <cfif isDefined('attributes.row_assetp_id') and len(attributes.row_assetp_id)>
                    <cfset url_str = "#url_str#&row_assetp_id=#attributes.row_assetp_id#">
                </cfif>
                <cfif len(attributes.keyword)>
                    <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
                </cfif>
                <cf_paging
                  page="#attributes.page#" 
                  maxrows="#attributes.maxrows#" 
                  totalrecords="#attributes.totalrecords#" 
                  startrow="#attributes.startrow#" 
                  adres="assetcare.popup_list_relation_assetp#url_str#"
                  isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
</cfif>
<script type="text/javascript">
	function add_record(asset_id,row_assetp_id)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_add_assetp_physical_relation&asset_id=' + asset_id + '&row_assetp_id=' + row_assetp_id ,'date');
        <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	function add_record_relation_physical(asset_id,station_id,type)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_add_assetp_relation&type=' +type+ '&asset_id=' + asset_id + '&station_id=' + station_id + '&contract_id=' + station_id,'date');
        <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>