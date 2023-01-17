<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfparam name="attributes.member_type" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.online)>
	<cfset url_str = "#url_str#&online=#attributes.online#">
</cfif>
<cfif isdefined('attributes.train_id') and len(attributes.train_id)>
	<cfset url_str = "#url_str#&train_id=#attributes.train_id#">
</cfif>
<cfif isdefined('attributes.member_type') and len(attributes.member_type)>
	<cfset url_str = "#url_str#&member_type=#attributes.member_type#">
</cfif>
<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
	<cfset url_str = "#url_str#&training_cat_id=#attributes.training_cat_id#">
</cfif>
<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
	<cfset url_str = "#url_str#&training_sec_id=#attributes.training_sec_id#">
</cfif>
<cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)>
	<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfquery name="get_training_names" datasource="#dsn#">
	SELECT TRAIN_ID, TRAIN_HEAD FROM TRAINING ORDER BY TRAIN_HEAD
</cfquery>
<cfif isdefined('attributes.is_submitted')>
	<cfinclude template="../query/get_trainers.cfm">
<cfelse>
	<cfset get_class_trainers.recordcount = 0> 
</cfif>
<cfinclude template="../query/get_trainer_info.cfm">
<cfinclude template="../query/get_trainer_par_info.cfm">
<cfinclude template="../query/get_trainer_con_info.cfm">
<cfinclude template="../query/get_training_name.cfm">
<cfquery name="GET_TRAINING_SEC_NAMES" datasource="#dsn#">
	SELECT
		TRAINING_CAT.TRAINING_CAT_ID,
		TRAINING_SEC.TRAINING_SEC_ID,
		TRAINING_SEC.SECTION_NAME,
		TRAINING_CAT.TRAINING_CAT
	FROM
		TRAINING_SEC,
		TRAINING_CAT
	WHERE
		TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
	ORDER BY
		TRAINING_CAT.TRAINING_CAT,
		TRAINING_SEC.SECTION_NAME
</cfquery>
<cfquery name="get_training_cat" datasource="#dsn#">
	SELECT 
    	TRAINING_CAT_ID, 
        TRAINING_CAT, 
        DETAIL, 
        TRAINING_LANGUAGE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	TRAINING_CAT
</cfquery>
<cfquery name="get_training_sec" datasource="#dsn#">
	SELECT 
        TRAINING_CAT_ID, 
        TRAINING_SEC_ID, 
        SECTION_NAME, 
        SECTION_DETAIL, 
        RECORD_EMP, 
        RECORD_PAR, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_PAR, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	TRAINING_SEC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_class_trainers.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform action="#request.self#?fuseaction=training_management.list_trainers" method="post" name="form">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" style="width:100px;" placeholder="#place#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="training_cat_id" id="training_cat_id" style="width:135px">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_training_cat">
							<option value="#training_cat_id#" <cfif isdefined("attributes.training_cat_id") and (attributes.training_cat_id eq training_cat_id)>selected</cfif>>#training_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="training_sec_id" id="training_sec_id" style="width:135px">
						<option value=""><cf_get_lang dictionary_id='57995.Bölüm'></option>
						<cfoutput query="get_training_sec">
							<option value="#training_sec_id#" <cfif isdefined("attributes.training_sec_id") and (attributes.training_sec_id eq training_sec_id)>selected</cfif>>#section_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="train_id" id="train_id" style="width:185px;">
						<option value=""><cf_get_lang dictionary_id='57480.Konu'></option>
						<cfoutput query="get_training_name">
						<option value="#train_id#" <cfif isdefined('attributes.train_id') and attributes.train_id eq train_id>selected</cfif>>#train_head#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="member_type" id="member_type">
						<option value=""><cf_get_lang dictionary_id='57576.Çalışan'> <cf_get_lang dictionary_id='30111.Durumu'></option>
						<option value="0"<cfif isdefined('attributes.member_type') and (attributes.member_type eq 0)> selected</cfif>><cf_get_lang dictionary_id ='57576.Çalışan'></option>
						<option value="1"<cfif isdefined('attributes.member_type') and (attributes.member_type eq 1)> selected</cfif>><cf_get_lang dictionary_id ='46358.Kurumsal'></option>
						<option value="2"<cfif isdefined('attributes.member_type') and (attributes.member_type eq 2)> selected</cfif>><cf_get_lang dictionary_id ='46359.Bireysel'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='46707.Sayfadaki Maksimum Kayit Sayisi'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" maxlength="3" value="#attributes.maxrows#"  range="1," message="#message#" style="width:25px;" required="yes">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(118,'Eğitimciler',46325)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>	
				<tr> 
					<th width="35"><cf_get_lang dictionary_id ='58577.Sira'></th>
					<th><cf_get_lang dictionary_id='46230.Eğitimci'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<!-- sil -->
					<th class="header_icn_none text-center"><cf_get_lang dictionary_id='29912.Eğitimler'></th>
					<th class="header_icn_none text-center">
						<cf_get_lang dictionary_id='46133.Eğitim Konuları'>
						</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_class_trainers.RecordCount>
					<cfoutput query="get_class_trainers" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td width="35">#currentrow#</td>
							<td> 
								<cfif TIP IS 'partner'>
								<cfset fonk=get_par_company(COMP_ID)>
								<cfif listlen(fonk,"|") and listlen(fonk,"|") gt 1>
									<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMP_ID#','medium');"  >#nickname#</a>&nbsp; -&nbsp; 
									<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#MEMB_ID#','medium');"  >#NAME# #SURNAME#</a>
									<cfset pos_name=ListGetAt(fonk,2,"|")>
									<cfset dep_info=ListGetAt(fonk,1,"|")>
								<cfelse>
									<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMP_ID#','medium');"  >#nickname#</a> - 
									<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#MEMB_ID#','medium');"  >#NAME# #SURNAME#</a>
									<cfset pos_name="">
									<cfset dep_info="">
								</cfif>
								<cfelseif TIP IS 'calisan'>
								<cfset fonk=get_emp_position(ID)>
								<cfif listlen(fonk,"|") and listlen(fonk,"|") gt 1>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#id#','project');"  >#NAME# #SURNAME#</a>
									<cfset pos_name=ListGetAt(fonk,2,"|")>
									<cfset dep_info=ListGetAt(fonk,1,"|")>
								<cfelse>
									#NAME# #SURNAME#
									<cfset pos_name="">
									<cfset dep_info="">
								</cfif>
								<cfelseif TIP IS 'consumer'>
								<cfset fonk=get_consumer_pos(ID)>
								<cfif listlen(fonk,"|") and listlen(fonk,"|") gt 1>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#ID#','project');"  >#NAME# #SURNAME#</a>
									<cfset pos_name=ListGetAt(fonk,2,"|")>
									<cfset dep_info=ListGetAt(fonk,1,"|")>
								<cfelse>
									#NAME# #SURNAME#
									<cfset pos_name="">
									<cfset dep_info="">
								</cfif>
								</cfif>
							</td>
							<td><cfif ListLen(dep_info)>#ListGetAt(dep_info,1,'/')#</cfif></td>
							<td><cfif ListLen(dep_info)>#ListGetAt(dep_info,2,'/')#</cfif></td>
							<td><cfif ListLen(dep_info)>#ListGetAt(dep_info,3,'/')#</cfif></td>
							<td>#pos_name#</td>
							<td>
								<cfif TIP IS 'calisan'><cf_get_lang dictionary_id='57576.Çalışan'><cfelseif TIP IS 'partner'><cf_get_lang dictionary_id='57585.Kurumsal Üye'><cfelseif TIP IS 'consumer'><cf_get_lang dictionary_id ='57586.Bireysel Üye'>  <cfelseif TIP IS 'group'><cf_get_lang dictionary_id='43396.Grup'></cfif>
							</td>
							<!-- sil -->
							<td style="text-align:center">
								<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_trainer_classes&tip=#TIP#&trainer_id=#ID#')"><i class="fa fa-graduation-cap" title="<cf_get_lang dictionary_id='46389.Verdiği Eğitimler'>"></i></a>
							</td>
							<td style="text-align:center">
								<cfif TIP IS 'calisan'>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_training_trainer&employee_id=#ID#')"><i class="fa fa-list" title="<cf_get_lang dictionary_id='46133.Eğitim Konuları'>"></i></a>
								<cfelseif TIP IS 'partner'>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_training_trainer&partner_company_id=#ID#&partner_id=#MEMB_ID#')"><i class="fa fa-list" title="<cf_get_lang dictionary_id='46133.Eğitim Konuları'>"></i></a>
								<cfelseif TIP IS 'consumer'>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_training_trainer&consumer_id=#ID#')"><i class="fa fa-list" title="<cf_get_lang dictionary_id='46133.Eğitim Konuları'>"></i></a>
								</cfif>
								
							</td>
							<!-- sil -->
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="9"><cfif isdefined('attributes.is_submitted') and attributes.is_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="training_management.list_trainers#url_str#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
