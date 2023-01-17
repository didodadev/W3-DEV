<cf_get_lang_set module_name="training">
<cfparam name="attributes.pos_req_type_id" default="">
<cfparam name="attributes.pos_req_type" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.stage_id" default="">
<cfinclude template="../query/get_training_cats.cfm">
<cfinclude template="../../training_management/query/get_trainings.cfm">
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_trainings.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfscript>
	cmp_unit = createObject("component","V16.hr.cfc.get_functions");
	cmp_unit.dsn = dsn;
	get_units = cmp_unit.get_function();
	url_str = "";
	if (isdefined("attributes.list_type") and len(attributes.list_type))
		url_str = "#url_str#&list_type=#attributes.list_type#";
	if (isdefined("attributes.field_id") and len(attributes.field_id))
		url_str = "#url_str#&field_id=#attributes.field_id#";
	if (isdefined("attributes.field_name") and len(attributes.field_name))
		url_str = "#url_str#&field_name=#attributes.field_name#";
	if (isdefined("attributes.field_cat_id") and len(attributes.field_cat_id))
		url_str = "#url_str#&field_cat_id=#attributes.field_cat_id#";
	if (isdefined("attributes.field_sec_id") and len(attributes.field_sec_id))
		url_str = "#url_str#&field_sec_id=#attributes.field_sec_id#";
	if (isdefined("attributes.field_training_style"))
		url_str = "#url_str#&field_training_style=#field_training_style#";
	if (len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if (isdefined("attributes.training_cat_id"))
		url_str = "#url_str#&training_cat_id=#training_cat_id#";
	if (len("attributes.pos_req_type_id"))
		url_str = "#url_str#&pos_req_type_id=#attributes.pos_req_type_id#";
	if (len("attributes.pos_req_type"))
		url_str = "#url_str#&pos_req_type=#attributes.pos_req_type#";
	if (len("attributes.func_id"))
		url_str = "#url_str#&func_id=#attributes.func_id#";
</cfscript>

<cfquery name="GET_STAGE" datasource="#dsn#">
	SELECT 
    	TRAINING_STAGE_ID, 
        TRAINING_STAGE, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_TRAINING_STAGE 
    ORDER BY 
    	TRAINING_STAGE
</cfquery>
<cf_box title="#getLang('training',172)#">
    <cfform name="form1" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_training_subjects">
        <cf_box_search>
        <cfif isdefined("attributes.training_cat_id")>
            <cfquery name="GET_CAT" datasource="#dsn#">
                SELECT TRAINING_CAT, TRAINING_CAT_ID FROM TRAINING_CAT WHERE TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#">
            </cfquery>
        </cfif>
        <cfif isdefined("attributes.list_type")><input type="hidden" name="list_type" id="list_type" value="<cfoutput>#attributes.list_type#</cfoutput>"></cfif>
        <cfif isdefined("attributes.field_id")><input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>"></cfif>
        <cfif isdefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>"></cfif>
        <cfif isdefined("attributes.field_cat_id")><input type="hidden" name="field_cat_id" id="field_cat_id" value="<cfoutput>#attributes.field_cat_id#</cfoutput>"></cfif>
        <cfif isdefined("attributes.field_sec_id")><input type="hidden" name="field_sec_id" id="field_sec_id" value="<cfoutput>#attributes.field_sec_id#</cfoutput>"></cfif>
        <cfif isdefined("attributes.field_training_style")><input type="hidden" name="field_training_style" id="field_training_style" value="<cfoutput>#attributes.field_training_style#</cfoutput>"></cfif>
        
        <div class="form-group medium" id="item-keyword">
            <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
        </div>
        <div class="form-group" id="item-stage_id">
            <select name="stage_id" id="stage_id">
                <option value=""><cf_get_lang no='159.Seviye'> <cf_get_lang_main no ='322.Seçiniz'></option>
                <cfoutput query="get_stage">
                    <option value="#training_stage_id#" <cfif attributes.stage_id eq training_stage_id>selected</cfif>>#training_stage#</option>
                </cfoutput>
            </select>
        </div>
        <div class="form-group small">
            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
        </div>
        <div class="form-group">
            <cf_wrk_search_button button_type="4">
        </div>
        <!--- <div class="form-group">
            <a id="ui-otherFileBtn" href="javascript://" class="ui-btn ui-btn-blue ui-btn-addon-right"><cf_get_lang dictionary_id='57904.Daha Fazlası'><i class="fa fa-angle-down"></i></a>
        </div> --->
    </cf_box_search>
        <cf_box_search_detail title="<cf_get_lang dictionary_id='47523.Filtre Seçenekleri'>">
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
             
                <div class="form-group" id="item-pos_req_type">
                    <div class="input-group">
                        <input type="hidden" name="pos_req_type_id" id="pos_req_type_id" value="<cfoutput>#attributes.pos_req_type_id#</cfoutput>">
                        <input type="text" name="pos_req_type" id="pos_req_type" placeholder="<cfoutput>#getLang('main',495)#</cfoutput>" value="<cfoutput>#attributes.pos_req_type#</cfoutput>" style="width:110px">
                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_req&field_id=form1.pos_req_type_id&field_name=form1.pos_req_type','list');"></span>
                    </div>
                </div>
                <div class="form-group" id="item-func_id">
                    <select name="func_id" id="func_id" style="width:110px;">
                        <option value=""><cf_get_lang_main no='1289.Fonksiyon'> <cf_get_lang_main no ='322.Seçiniz'></option>
                        <cfoutput query="get_units">
                            <option value="#get_units.unit_id#" <cfif attributes.func_id eq get_units.unit_id>selected</cfif>>#get_units.unit_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" id="item-func_id">
                    <cfinclude template="../query/get_training_cats.cfm">
                    <select name="training_cat_id" id="training_cat_id" style="width:160;">
                        <option value="0" selected><cf_get_lang_main no='1739.Tum Kategoriler'></option>
                        <cfoutput query="get_training_cats">
                            <cfif isdefined("attributes.training_cat_id")>
                                <option value="#training_cat_id#" <cfif attributes.training_cat_id eq training_cat_id>selected</cfif>>#training_cat#</option>
                            <cfelse>
                                <option value="#training_cat_id#">#training_cat#</option>
                            </cfif>
                        </cfoutput>
                    </select>
                </div>    
           
            </div>
        </cf_box_search_detail>
    
    </cfform>
</cf_box>
<cf_box>
    <cf_grid_list>
        <thead>
            <tr>
                <th height="22" nowrap="nowrap"><cf_get_lang no='66.Konu Başlığı'></th>
                <th class="form-title"><cf_get_lang_main no='74.Kategori'> - <cf_get_lang_main no='583.Bölüm'></th>
                <th class="form-title"><cf_get_lang no='122.Eğitim Şekli'></th>
                <th class="form-title"><cf_get_lang no='7.Amaç'></th>
                <th width="35">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            <cfif get_trainings.recordcount>
                <cfoutput query="get_trainings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td nowrap="nowrap"><a href="javascript:dondur('#train_head#','#train_id#','#training_sec_id#','#training_cat_id#','#training_style_id#');" >#train_head#</a></td>
                        <td>#training_cat# / #section_name#</td>
                        <td>#training_style#</td>
                        <td>#train_objective#</td>
                        <td width="35"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training.popup_dsp_training_detail&train_id=#train_id#');"><img src="../images/squar.gif" border="0" align="absmiddle"></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#attributes.fuseaction##url_str#">
</cf_box>
<script type="text/javascript">
    function dondur(name,id,training_sec_id,training_cat_id,training_style)
    {
        <cfif isdefined("attributes.field_name")>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
        </cfif>
        <cfif isdefined("attributes.field_id")>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
        </cfif>
        <cfif isdefined("attributes.field_sec_id")>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_sec_id#</cfoutput>.value = training_sec_id;
        </cfif>
        <cfif isdefined("attributes.field_cat_id")>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_cat_id#</cfoutput>.value = training_cat_id;
        </cfif>
        <cfif isdefined("attributes.field_training_style")>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_training_style#</cfoutput>.value = training_style;
        </cfif>
        window.close();
    }
</script>