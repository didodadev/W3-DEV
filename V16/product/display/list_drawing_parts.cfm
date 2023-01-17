<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.form_varmi" default="">
<cfparam name="attributes.dpl_stage" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.status" default="1">
<cfif len(attributes.form_varmi)>
	<cfquery name="get_dpl_list" datasource="#dsn3#">
		SELECT
			DRAWING_PART.DPL_ID,
            DRAWING_PART.DPL_NO,
            DRAWING_PART.STAGE_ID,
            DRAWING_PART.IS_ACTIVE,
			DRAWING_PART.PROJECT_ID,
			ASSET.ASSET_NAME,
			PRODUCT.PRODUCT_NAME,
			PRODUCT.PRODUCT_CODE_2,
			PRO_PROJECTS.PROJECT_NUMBER,
			PRO_PROJECTS.PROJECT_HEAD
		FROM
			DRAWING_PART
			LEFT JOIN #dsn_alias#.ASSET ON DRAWING_PART.ASSET_ID = ASSET.ASSET_ID
			LEFT JOIN PRODUCT ON DRAWING_PART.MAIN_PRODUCT_ID = PRODUCT.PRODUCT_ID
			LEFT JOIN #dsn_alias#.PRO_PROJECTS ON DRAWING_PART.PROJECT_ID = PRO_PROJECTS.PROJECT_ID 
		WHERE
			1 = 1
			<cfif len(attributes.keyword)> 
				AND DRAWING_PART.DPL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>            
            <cfif isDefined("attributes.status") and len(attributes.status) and (attributes.status) neq 2>
                AND DRAWING_PART.IS_ACTIVE = #attributes.status#
            </cfif>	
            <cfif isdefined("attributes.dpl_stage") and len (attributes.dpl_stage)>
				AND DRAWING_PART.STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dpl_stage#">
			</cfif>
			<cfif isdefined("attributes.project_id") and len (attributes.project_id) and isdefined("attributes.project_head") and len (attributes.project_head)>
				AND DRAWING_PART.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif isdefined("attributes.product_name") and len(attributes.product_name) and len(attributes.product_id)>
				AND DRAWING_PART.MAIN_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
			</cfif>
		ORDER BY
			DRAWING_PART.DPL_NO DESC
	</cfquery> 
<cfelse>
	<cfset get_dpl_list.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_dpl_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%product.list_drawing_parts%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfform name="list_dpl" method="post" action="#request.self#?fuseaction=product.list_drawing_parts">
<input name="form_varmi" id="form_varmi" value="1" type="hidden">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37017.DPL'></cfsavecontent>
<cf_big_list_search title="#message#"> 
    <cf_big_list_search_area>
        <table>
            <tr> 
                <td><cf_get_lang dictionary_id='57460.Filtre'></td>
                <td><cfinput type="text" maxlength="50" name="keyword" style="width:100px;" value="#attributes.keyword#"></td>
                <td><cf_get_lang dictionary_id='57657.Ürün'></td>
                <td>
                    <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                    <input name="product_name" type="text" id="product_name" style="width:120px;"  onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" passthrough="readonly=yes" autocomplete="off">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=list_dpl.product_id&field_name=list_dpl.product_name&keyword='+encodeURIComponent(document.list_dpl.product_name.value),'list');"><img src="/images/plus_thin.gif"></a>
                </td>
                <td><cf_get_lang dictionary_id ='57416.proje'></td>
                <td>
                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                    <input type="text" name="project_head"  id="project_head" style="width:90px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                    <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=list_dpl.project_id&project_head=list_dpl.project_head');"> <img src="/images/plus_thin.gif"></a>
                </td>
                <td><select name="dpl_stage" id="dpl_stage" style="width:100px;">
                        <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                        <cfoutput query="get_process_type">
                        	<option value="#process_row_id#"<cfif attributes.dpl_stage eq process_row_id>selected</cfif>>#stage#</option>
                        </cfoutput>
                    </select>
                </td>
                <td><select name="status" id="status" style="width:55px;">
                        <option value="2" <cfif isdefined("attributes.status") and attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif isdefined("attributes.status") and attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif isdefined("attributes.status") and attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </td>
                <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </td>
                <td><cf_wrk_search_button></td>	
            </tr>
        </table>
    </cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr> 
            <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
            <th width="55"><cf_get_lang dictionary_id='37120.DPL No'></th>
            <th><cf_get_lang dictionary_id='37164.Ana Ürün'></th>
            <th><cf_get_lang dictionary_id='58080.Resim'></th>
            <th><cf_get_lang dictionary_id ='57416.proje'></th>
            <th><cf_get_lang dictionary_id ='57756.Durum'></th>
            <th width="100"><cf_get_lang dictionary_id='58859.Süreç'></th>
            <th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.form_add_drawing_parts"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></td>
        
        </tr>
    </thead>
    <tbody>
		<cfif isdefined("attributes.form_varmi") and get_dpl_list.recordcount>
            <cfset dpl_stage_list=''>
            <cfoutput query="get_dpl_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif len(stage_id) and not listfind(dpl_stage_list,stage_id)>
                    <cfset dpl_stage_list=listappend(dpl_stage_list,stage_id)>
                </cfif>	        
            </cfoutput>
            <cfif len(dpl_stage_list)>
                <cfset dpl_stage_list=listsort(dpl_stage_list,"numeric","ASC",",")>
                <cfquery name="PROCESS_TYPE" datasource="#DSN#">
                    SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#dpl_stage_list#) ORDER BY PROCESS_ROW_ID
                </cfquery>
            </cfif>
            	<cfoutput query="get_dpl_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=product.form_upd_drawing_parts&dpl_id=#dpl_id#" class="tableyazi">#dpl_no#</a></td>
                        <td><cfif len(PRODUCT_CODE_2)>#PRODUCT_CODE_2#-</cfif>#PRODUCT_NAME#</td>
                        <td>#asset_name#</td>
                        <td><cfif len(project_id)><a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" target="_blank" class="tableyazi">#project_number#-#project_head#</a></cfif></td>
                        <td><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                        <td><cfif len(dpl_stage_list)>#process_type.stage[listfind(dpl_stage_list,stage_id,',')]#</cfif></td>
                        <!-- sil -->
                        <td width="15" align="center">
                            <a href="#request.self#?fuseaction=product.form_upd_drawing_parts&dpl_id=#dpl_id#"><img src="/images/update_list.gif"></a></td>
                        </td>
                        <!-- sil -->
                    </tr>
            </cfoutput>
        <cfelse>
            <tr> 
                <td colspan="8" height="20"><cfif len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
            </tr>
        </cfif>
	</tbody>
</cf_big_list>
<cfset url_str = "product.list_drawing_parts">
<cfif isdefined("attributes.form_varmi")>
	<cfset url_str = "#url_str#&form_varmi=#attributes.form_varmi#" >
</cfif>
<cfif len(attributes.keyword)>
  <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.product_id)>
  <cfset url_str = "#url_str#&product_id=#attributes.product_id#">
</cfif>
<cfif len(attributes.product_name)>
  <cfset url_str = "#url_str#&product_name=#attributes.product_name#">
</cfif>
<cfif len(attributes.dpl_stage)>
  <cfset url_str = "#url_str#&dpl_stage=#attributes.dpl_stage#">
</cfif>
<cfif isdefined("attributes.status") and len(attributes.status)>
  <cfset url_str = "#url_str#&status=#attributes.status#">
</cfif>
<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
  <cfset url_str = "#url_str#&project_id=#attributes.project_id#">
</cfif>
<cfif isdefined("attributes.project_head") and len(attributes.project_head)>
  <cfset url_str = "#url_str#&project_head=#attributes.project_head#">
</cfif>
<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
