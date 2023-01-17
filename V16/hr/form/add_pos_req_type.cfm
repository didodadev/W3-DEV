<cf_xml_page_edit fuseact="hr.add_pos_req_type"> 
<cf_catalystHeader>
<cfform action="#request.self#?fuseaction=hr.emptypopup_add_pos_req_type" name="add_req_type_relation" method="post">
	<cf_box>
		<cf_box_elements>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-perfection_year">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='58472.Dönem'></label>
					<div class="col col-9 col-xs-12">
						<select name="perfection_year" id="perfection_year">
							<cfloop from="#year(now())-3#" to="#year(now())+2#" index="j">
								<cfoutput><option value="#j#" <cfif j eq year(now())>selected</cfif>>#j#</option></cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-REQ_TYPE">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
					<div class="col col-9 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
						<cfinput type="text" name="REQ_TYPE" id="REQ_TYPE" style="width:300px;" required="yes" message="#message#" maxlength="50">
					</div>
				</div>
				<div class="form-group" id="item-detail">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-9 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
						<textarea name="detail" id="detail" style="width:300px;height:45px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
					</div>
				</div>
			</div>
			<div class="col col-3" type="column" index="2" sort="true">
				<div class="form-group" id="item-is_active">
					<label class="col col-12"><cf_get_lang dictionary_id ='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" value="1"></label>
				</div>
				<cfif xml_view_opt eq 1>
				<div class="form-group" id="item-is_group_req_type">
					<label class="col col-12"><cf_get_lang dictionary_id ='56552.Grup Yetkinliği'><input type="checkbox" name="is_group_req_type" id="is_group_req_type" value="1"></label>
				</div>
				</cfif>
				<cfif xml_view_opt eq 1>
				<div class="form-group" id="item-is_coach">
					<label class="col col-12"><cf_get_lang dictionary_id ='56553.Koçluk'><input type="checkbox" name="is_coach" id="is_coach" value="1"></label>
				</div>
				</cfif>
				<div class="form-group" id="item-is_dep_admin">
					<label class="col col-12"><cf_get_lang dictionary_id ='56554.Departman Yöneticisi'><input type="checkbox" name="is_dep_admin" id="is_dep_admin" value="1"></label>
				</div>
				<div class="form-group" id="item-is_standart">
					<label class="col col-12"><cf_get_lang dictionary_id ='56555.Standart Yeterlilik'><input type="checkbox" name="is_standart" id="is_standart" value="1"></label>
				</div>
			</div>
			<div class="row formContentFooter">
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0'>
				</div>
			</div>
		</cf_box_elements>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="55638.Performans Form Kullanım Alanları: Yetkinlik Hangi birim, pozisyon, üyelerde ve yıllarda geçerli?"></cfsavecontent>
	<cf_box title="#message#">
        <cf_relation_segment
            is_upd='0'
            is_form='1'
            table_name='TARGET_CAT'
            action_table_name='RELATION_SEGMENT'
            select_list='1,2,3,4,5,6,7,8,10'>
   </cf_box>
</cfform>