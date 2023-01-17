<cfquery name="GET_DIGITAL_ASSET_GROUP" datasource="#DSN#"> 
    SELECT 
        #dsn#.Get_Dynamic_Language(GROUP_ID,'#session.ep.language#','DIGITAL_ASSET_GROUP','GROUP_NAME',NULL,NULL,GROUP_NAME) AS GROUP_NAME,
        #dsn#.Get_Dynamic_Language(GROUP_ID,'#session.ep.language#','DIGITAL_ASSET_GROUP','DETAIL',NULL,NULL,DETAIL) AS DETAIL,
        CONTENT_PROPERTY_ID,
        RECORD_EMP,
        RECORD_DATE,
        RECORD_IP,
        UPDATE_EMP,
        UPDATE_DATE,
        UPDATE_IP
    FROM 
    	DIGITAL_ASSET_GROUP 
    WHERE 
    	GROUP_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.ID#">
</cfquery>
<cfquery name="GET_PRO_PERM" datasource="#DSN#">
	SELECT STATUS,PARTNER_ID, POSITION_CODE,POSITION_CAT FROM DIGITAL_ASSET_GROUP_PERM WHERE GROUP_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.ID#">
</cfquery>
<cfquery name="GET_CONTENT" datasource="#DSN#">
	SELECT NAME, CONTENT_PROPERTY_ID FROM CONTENT_PROPERTY ORDER BY NAME
</cfquery>

<cfset attributes.group_id = URL.ID>
<cfif isDefined("session.digital_asset.emps") and not isDefined("attributes.session_delete")>
	<cfset structdelete(session.digital_asset,"emps")>
</cfif>
<cfif isDefined("session.digital_asset.pars") and not isDefined("attributes.session_delete")>
	<cfset structdelete(session.digital_asset,"pars")>
</cfif>
<cfif not isDefined("session.digital_asset.emps") and not isDefined("session.digital_asset.pars")>
	<cfset session.digital_asset.emps=arraynew(1)>
	<cfset session.digital_asset.pars=arraynew(1)>
	<cfif get_pro_perm.recordcount>
		<cfoutput query="get_pro_perm">
        	<cfif len(position_code)>
				<cfset uzun = arraylen(session.digital_asset.emps)>
                <cfset session.digital_asset.emps[uzun+1]= position_code>
            <cfelseif len(partner_id)>
				<cfset uzun = arraylen(session.digital_asset.pars)>
				<cfset session.digital_asset.pars[uzun+1]= partner_id>
            </cfif>
		</cfoutput>
	</cfif>
</cfif>
<cfquery name="GET_DIGITAL_ASSET_GROUPS" datasource="#DSN#">
    SELECT 
        DETAIL,
        GROUP_ID,
        #dsn#.Get_Dynamic_Language(GROUP_ID,'#session.ep.language#','DIGITAL_ASSET_GROUP','GROUP_NAME',NULL,NULL,GROUP_NAME) AS GROUP_NAME 
    FROM 
        DIGITAL_ASSET_GROUP
    ORDER BY
		GROUP_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">	
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='45129.Dijital Varlık Grupları'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.list_digital_asset_group" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">	
			<table>
					<cfif get_digital_asset_groups.recordcount>
						<cfoutput query="get_digital_asset_groups">
                            <tr>
                                <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
								<td width="380"><a href="#request.self#?fuseaction=settings.list_digital_asset_group&event=upd&id=#group_id#" class="tableyazi"> #group_name# </a> </td>	
							</tr>
						</cfoutput>
					<cfelse>
                        <tr>
                            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
							<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						</tr>
					</cfif>	
			</table>
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">	
			<cfform name="upd_digital_asset_group" action="#request.self#?fuseaction=settings.emptypopup_upd_digital_asset_group&id=#attributes.group_id#" method="post">
                <input type="hidden" name="GROUP_ID" id="GROUP_ID" value="<cfoutput>#attributes.GROUP_ID#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45131.Dijital Varlık Grup Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="Text" name="asset_group" value="#get_digital_asset_group.group_name#"  required="yes" message="Dijital Varlık Grup Adı Giriniz!" maxlength="50">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="DIGITAL_ASSET_GROUP" 
                                        column_name="GROUP_NAME" 
                                        column_id_value="#url.id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="GROUP_ID" 
                                        control_type="0">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <textarea name="detail" id="detail"><cfoutput>#get_digital_asset_group.detail#</cfoutput></textarea>
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="DIGITAL_ASSET_GROUP" 
                                        column_name="DETAIL" 
                                        column_id_value="#url.id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="GROUP_ID" 
                                        control_type="0">
                                    </span>
                                </div>
                            </div>
                            
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58067.Döküman Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="get_content_property" id="get_content_property" multiple="multiple" >
                                    <cfoutput query="get_content">
                                        <option value="#content_property_id#" <cfif listfindnocase(get_digital_asset_group.content_property_id,get_content.content_property_id,',')>selected="selected"</cfif>>#name#</option>
                                    </cfoutput>
                                </select>  
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12" style="display:none!important"><cf_get_lang dictionary_id='36167.Yetkili Pozisyonlar'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="gizli1">
                                    <cfsavecontent variable="txt_1"><cf_get_lang dictionary_id='36167.Yetkili Pozisyonlar'></cfsavecontent>
                                    <cf_workcube_to_cc 
                                        is_update="1" 
                                        to_dsp_name="#txt_1#" 
                                        form_name="upd_digital_asset_group" 
                                        str_list_param="1,2" 
                                        action_dsn="#DSN#"
                                        str_action_names = "PARTNER_ID TO_PAR,POSITION_CODE TO_POS_CODE"
                                        str_alias_names = "TO_PAR,TO_POS_CODE"
                                        action_table="DIGITAL_ASSET_GROUP_PERM"
                                        action_id_name="GROUP_ID"
                                        data_type="2"
                                        action_id="#attributes.GROUP_ID#">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12" style="display:none!important"><cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="gizli1">
                                <cf_flat_list>
                                    <thead>
                                        <tr>
                                            <th width="20">
                                                <input type="hidden" name="position_cats" id="position_cats" value="<cfoutput>#ListSort(ValueList(GET_PRO_PERM.POSITION_CAT),'numeric')#</cfoutput>">
                                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=upd_digital_asset_group.position_cats&field_td=td_yetkili2</cfoutput>','list');"><i class="icon-pluss"></i>
                                                </a>
                                                
                                            </th>
                                            <th><cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="td_yetkili2">
                                        <cfquery name="get_status_cats" datasource="#dsn#">
                                            SELECT SC.POSITION_CAT,SC.POSITION_CAT_ID FROM DIGITAL_ASSET_GROUP_PERM,SETUP_POSITION_CAT SC WHERE SC.POSITION_CAT_ID = DIGITAL_ASSET_GROUP_PERM.POSITION_CAT AND GROUP_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.ID#">
                                        </cfquery>
                                        <cfif get_status_cats.recordcount>
                                            <cfoutput query="get_status_cats">
                                                <input type="hidden" name="status_#position_cat_id#" id="status_#position_cat_id#" value="1">
                                                <tr id="tr_#position_cat_id#">
                                                    <td><a href="javascript://" onclick="del_pos_cat(#position_cat_id#);"><i class="icon-minus"></i></a><br/></td>
                                                    <td>#position_cat#</td>
                                                </tr>
                                            </cfoutput>
                                        </cfif>
                                    </tbody>
                                </cf_flat_list>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="get_digital_asset_group">
                    <cf_workcube_buttons is_upd='1' is_delete = '0' add_function="kontrol()">
                </cf_box_footer>
            </cfform>
		</div>
	</cf_box>
</div>

<script language="javascript">
	function del_pos_cat(pos_cat_id)
	{	
		document.getElementById('status_'+pos_cat_id).value = 0;
		document.getElementById('tr_'+pos_cat_id).style.display = 'none';
	}
</script>