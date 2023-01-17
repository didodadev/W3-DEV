<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.m_type" default="">
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.employee)>
	<cfset url_str = "#url_str#&employee=#attributes.employee#">
</cfif>
<cfif len(attributes.employee_id)>
	<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("m_type")>
	<cfset url_str = "#url_str#&m_type=#m_type#">
</cfif>
<cfif isdefined("attributes.camp_id")>
	<cfset url_str = "#url_str#&camp_id=#attributes.camp_id#">
</cfif>
<cfif isdefined("attributes.content_subject")>
	<cfset url_str = "#url_str#&content_subject=#attributes.content_subject#">
</cfif>
<cfinclude template="../query/get_campaign.cfm">
<cfinclude template="../query/get_cons.cfm">
<cfinclude template="../query/get_pars.cfm">
<cfquery name="CAMP_EMAIL_CONTS" datasource="#DSN3#">
	SELECT
		CR.CONTENT_ID EMAIL_CONT_ID,
		C.CONT_HEAD EMAIL_SUBJECT
	FROM 
		#dsn_alias#.CONTENT_RELATION CR, 
		#dsn_alias#.CONTENT C
	WHERE 
		CR.CONTENT_ID = C.CONTENT_ID AND
		CR.ACTION_TYPE = 'CAMPAIGN_ID'AND 
		CR.ACTION_TYPE_ID = #attributes.camp_id# 
	ORDER BY
		EMAIL_CONT_ID DESC
</cfquery>
<cfset attributes.consumer_ids = valuelist(get_cons.consumer_id)>
<cfset attributes.partner_ids = valuelist(get_pars.partner_id)>
<script type="text/javascript">
	function list_send_form(xfa,type)
	{ 
		windowopen('','medium','add_instant');
		document.form_list_send.action = '<cfoutput>#request.self#?fuseaction=campaign.popup_send_instant_message&camp_id=#attributes.camp_id#</cfoutput>';
		document.form_list_send.target='add_instant';
		document.form_list_send.submit();
	}
</script>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.cont_type" default="">
<cfparam name="attributes.content_id" default="">
<cfparam name="attributes.content_subject" default="">
<cfset total_no = get_cons.RECORDCOUNT + get_pars.RECORDCOUNT>
<cfset attributes.cons = get_cons.recordcount>
<cfset attributes.pars = get_pars.recordcount>
<cfparam name="attributes.totalrecords" default="#total_no#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif attributes.maxrows lte attributes.cons>
	<cfif attributes.page is 1>
		<cfscript>
			attributes.startrow1 = attributes.startrow;
			attributes.maxrows1 = attributes.maxrows;
			attributes.startrow2 = attributes.startrow;
			attributes.maxrows2 = 1; //0 hata veriyor gecici 1 yaptim bilen duzeltsin fbs
		</cfscript>
	<cfelse>
		<cfset attributes.startrow1 = attributes.startrow>
		<cfset attributes.maxrows1 = attributes.cons - attributes.maxrows*(attributes.page-1)>
		<cfif (attributes.maxrows1 eq attributes.maxrows)>
			<cfset attributes.startrow2 = attributes.startrow>
			<cfset attributes.maxrows2 = 1><!--- 0 hata veriyor gecici 1 yaptim bilen duzeltsin fbs --->
		<cfelse>
			<cfif (attributes.maxrows1 gt 0)>
				<cfif attributes.maxrows1 gt attributes.maxrows>
					<cfset attributes.maxrows1 = attributes.maxrows>
				</cfif>
				<cfset attributes.startrow2 = 1>
				<cfset attributes.maxrows2 = attributes.maxrows - attributes.maxrows1>
			<cfelse>
				<cfset attributes.startrow2 = (attributes.page-1)*attributes.maxrows - attributes.cons+1>
				<cfset attributes.maxrows2 = attributes.maxrows>
			</cfif>
		</cfif>
	</cfif>
<cfelse>
	<cfif attributes.page is 1>
		<cfscript>
			attributes.startrow1 = attributes.startrow;
			attributes.maxrows1 = attributes.cons;
			attributes.startrow2 = 1;
			attributes.maxrows2 = attributes.maxrows - attributes.maxrows1; 
		</cfscript>
	<cfelse>
		<cfscript>
			attributes.startrow1 = attributes.startrow;
			attributes.maxrows1 = attributes.cons - attributes.maxrows*(attributes.page-1);
			attributes.startrow2 = (attributes.page-1)*attributes.maxrows - attributes.cons+1;
			attributes.maxrows2 = attributes.maxrows; 
		</cfscript>
	</cfif>
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='49382.Liste Yöneticisi'> : <cfoutput>#campaign.CAMP_HEAD#</cfoutput></cfsavecontent>
<cfset pageHead = "#title#">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_" id="search_" method="post" action="#request.self#?fuseaction=campaign.list_campaign_target&event=add&camp_id=#attributes.camp_id#">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='0' mail='1' doc='1' print='1'>
				</div>
				<cfoutput>
					<cfif not listfindnocase(denied_pages,'campaign.popup_camp_list_label')>
						<div class="form-group">
							<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_camp_list_label&camp_id=#attributes.camp_id#&date1=#dateformat(attributes.date1,dateformat_style)#&date2=#dateformat(attributes.date2,dateformat_style)#','list');"><i class="fa fa-barcode" alt="<cf_get_lang dictionary_id='49500.Etiket Bas'>" title="<cf_get_lang dictionary_id='49500.Etiket Bas'>"></i></a>
						</div>
					</cfif> 
					<div class="form-group">
						<div class="input-group">
							<a class="ui-btn ui-btn-gray" href="javascript://" onClick="gonder_excel();"><i class="fa fa-file-excel-o" alt="<cf_get_lang dictionary_id ='49613.Excel e Gönder'>" title="<cf_get_lang dictionary_id ='49613.Excel e Gönder'>"></i></a>
						</div>
					</div>
				</cfoutput>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-xs-12">
					<div class="form-group" id="item-employee_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfoutput>
									<input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
									<input type="text" name="employee" id="employee" style="width:135px;" value="<cfif len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57899.Kaydeden'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=search_.employee_id&field_name=search_.employee&select_list=1');"></span>
								</cfoutput>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-content_subject">
						<label class="col col-12"><cf_get_lang dictionary_id ='57653.İçerik'></label>
						<div class="col col-12">
							<select name="content_subject" id="content_subject">
								<option value="" selected><cfoutput><cf_get_lang dictionary_id ='57653.İçerik'></cfoutput></option>
								<cfoutput query="camp_email_conts">
									<option value="#email_cont_id#" <cfif isdefined('attributes.content_subject') and attributes.content_subject eq email_cont_id>selected</cfif>>#EMAIL_SUBJECT#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-xs-12">
					<div class="form-group" id="item-sort_type">
						<label class="col col-12"><cf_get_lang dictionary_id ='57653.İçerik'></label>
						<div class="col col-12">
							<select name="sort_type" id="sort_type">
								<option value="1" <cfif isdefined('attributes.sort_type') and attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='49597.Firma Adına Göre'></option>			
								<option value="2" <cfif isdefined('attributes.sort_type') and attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='49598.Üye Adına Göre'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-m_type">
						<label class="col col-12"><cf_get_lang dictionary_id ='57653.İçerik'></label>
						<div class="col col-12">
							<select name="m_type" id="m_type">
								<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
								<option value="1" <cfif isdefined("attributes.m_type") and (attributes.m_type is "1")>selected</cfif>><cf_get_lang dictionary_id='29406.Bireysel'></option>
								<option value="2" <cfif isdefined("attributes.m_type") and (attributes.m_type is "2")>selected</cfif>><cf_get_lang dictionary_id='29408.Kurumsal'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-xs-12">
					<div class="form-group" id="item-start_date1">
						<label class="col col-12"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></label>
						<div class="col col-12">
							<div class="input-group">
								<cfoutput>
									<cfif isdefined("attributes.date1") and Len(attributes.date1)>
										<cfinput name="date1" type="text" value="#dateformat(attributes.date1,dateformat_style)#">
									<cfelse>
										<cfinput name="date1" type="text" value="">
									</cfif>  
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date1"></span>
								</cfoutput>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-start_date2">
						<label class="col col-12"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></label>
						<div class="col col-12">
							<div class="input-group">
								<cfoutput>
									<cfif isdefined("attributes.date2") and Len(attributes.date2)>
										<cfinput name="date2" type="text" value="#dateformat(attributes.date2,dateformat_style)#">
									<cfelse>
										<cfinput name="date2" type="text" value="">
									</cfif>  
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date2"></span>
								</cfoutput>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Liste Yöneticisi',49382)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="35"><cf_get_lang dictionary_id='57630.Tip'></th>
					<th width="250"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th width="200"><cf_get_lang dictionary_id='57571.Ünvan'></th>
					<th width="200"><cf_get_lang dictionary_id='57428.Email'></th>
					<th width="200"><cf_get_lang dictionary_id='30254.Mobil'></th> 
					<th width="200"><cf_get_lang dictionary_id='57499.Telefon'></th>
					<th width="200"><cf_get_lang dictionary_id='57499.Telefon'> 2</th>					
					<th width="200"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><i class="fa fa-envelope" title="<cf_get_lang dictionary_id='30567.I want to receive e-mails'>" alt="<cf_get_lang dictionary_id='30567.I want to receive e-mails'>"></i></th>
					<th width="20" class="header_icn_none text-center"><i class="fa fa-plug" alt="<cf_get_lang dictionary_id='49354.Etkileşim'>" title="<cf_get_lang dictionary_id='49354.Etkileşim'>"></i></th>
					<th width="20" class="header_icn_none text-center"><i class="fa fa-share-alt" alt="<cf_get_lang dictionary_id='49486.Gönderiler'>" title="<cf_get_lang dictionary_id='49486.Gönderiler'>"></i></th>
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars_multiuser&select_list=8,7&url_direction=campaign.emptypopup_add_target_people&camp_id=#attributes.camp_id#&url_params=camp_id','list'</cfoutput>);"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<th width="20" class="header_icn_none text-center" title="<cf_get_lang dictionary_id='33746.Hepsini Seç'>" alt="<cf_get_lang dictionary_id='33746.Hepsini Seç'>">
						<input type="checkbox" name="all_check" id="all_check" onClick="all_checked()">
						<!--- <a href="javascript://" onClick="javascript:if (confirm('<cfoutput>#getLang('','Silmek istediginizden emin misiniz?',57533)#</cfoutput>')) gonder_camp(); else return false;"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a> --->
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>	
				<cfform name="form_del_camp_target_cons" method="post" action="#request.self#?fuseaction=campaign.emptypopup_del_camp_tmarket_cons_toplu">
					<input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#camp_id#</cfoutput>">
					<input type="hidden" name="c_startrow" id="c_startrow" value="<cfoutput>#attributes.startrow#</cfoutput>">
					<input type="hidden" name="c_maxrows" id="c_maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>">
					<input type="hidden" name="p_startrow" id="p_startrow" value="<cfoutput>#attributes.startrow2#</cfoutput>">
					<input type="hidden" name="p_maxrows"  id="p_maxrows" value="<cfoutput>#attributes.maxrows2#</cfoutput>">
					<cfif attributes.cons and not isdefined("attributes.target_company_id") and not len(attributes.target_company_id)><cfinclude template="list_tmarket_cons.cfm"></cfif>
					<cfif attributes.pars><cfinclude template="list_tmarket_pars.cfm"></cfif>
				</cfform>
			</tbody>
				<input type="hidden" name="member_id" id="member_id">
				<input type="hidden" name="member_type" id="member_type" value="consumer">
				<input type="hidden" name="consumer" id="consumer">
				<cfif attributes.totalrecords eq 0>
					<tr> 
						<td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging
				name="search_"
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="campaign.list_campaign_target#url_str#">
		</cfif>
	</cf_box>
	<cfif attributes.totalrecords gt 0>
		<cf_box>
			<cfinclude template="add_interaction_campaign_target.cfm">
		</cf_box>
	</cfif>
</div>
<script type="text/javascript">
	function addInteraction()//toplu etkilesim kaydetmek icin.
	{
		if(document.add_interaction.interaction_detail.value == "")
		{
			alert("<cf_get_lang dictionary_id='54709.Açıklama Alanını Boş Bırakamazsınız'>!");
			return false;
		}
		if(document.add_interaction.interaction_cat.value == "")
		{
			alert("<cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'>!");
			return false;
		}
		if(document.add_interaction.app_cat.value == "")
		{
			alert("<cf_get_lang dictionary_id='54710.İletişim Yöntemi Seçmelisiniz'>!");
			return false;
		}
		if(document.add_interaction.interaction_process.value == "")
		{
			alert("<cf_get_lang dictionary_id='58231.Durum Seçmelisiniz'>!");
			return false;
		}
		consumerList = '';
		partnerList = '';
		<cfif get_cons.recordcount and attributes.startrow1 gt 0 and attributes.maxrows1 gt 0>
		<cfoutput query="get_cons" startrow="#attributes.startrow1#" maxrows="#attributes.maxrows1#">
			if(document.form_del_camp_target_cons.cons_list_#currentrow#.checked == true)
				consumerList = consumerList + '#consumer_id#,';
		</cfoutput>
		</cfif>
		<cfif get_pars.recordcount and attributes.startrow2 gt 0 and attributes.maxrows2 gt 0>
		<cfoutput query="get_pars" startrow="#attributes.startrow2#" maxrows="#attributes.maxrows2#">
			if(document.form_del_camp_target_cons.pars_list_#currentrow#.checked == true)
				partnerList = partnerList + '#partner_id#,';
		</cfoutput>
		</cfif>
		
		if(consumerList=='' && partnerList=='')
			{
			alert("<cf_get_lang dictionary_id='62262.Listeden en az bir kişi seçmelisiniz'>!");
			return false;
			}
		else
			{
			document.add_interaction.consumer_ids.value = consumerList;
			document.add_interaction.partner_ids.value = partnerList;
			}
	}
	
	function gonder_camp()
	{
		windowopen('','small','del_cam_target_sil');
		form_del_camp_target_cons.target='del_cam_target_sil';
		document.form_del_camp_target_cons.submit();
	}
	function gonder_excel()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=campaign.popup_camp_list_excel&camp_id=#attributes.camp_id#</cfoutput>&date1='+document.search_.date1.value+'&date2='+document.search_.date2.value+'&employee_id='+document.search_.employee_id.value+'&employee='+document.search_.employee.value,'list');
	}
	function all_checked()
	{
		var start = <cfoutput>#attributes.startrow#</cfoutput>;
		var maxr = <cfoutput>#attributes.maxrows#</cfoutput>;
		var start2 = <cfoutput>#attributes.startrow2#</cfoutput>;
		var maxr2 = <cfoutput>#attributes.maxrows2#</cfoutput>;
		if (maxr!=maxr2)
		for (i=start;i<=start+maxr;i++)
		{
			if (eval("document.form_del_camp_target_cons.cons_list_"+i) != undefined)
				if(eval("document.form_del_camp_target_cons.cons_list_"+i).checked == false)
					eval("document.form_del_camp_target_cons.cons_list_"+i).checked = true;
				else
					eval("document.form_del_camp_target_cons.cons_list_"+i).checked = false;
		}
		if(maxr2 > 0)
		for (j=start2;j<=start2+maxr2;j++)
		{
			if (eval("document.form_del_camp_target_cons.pars_list_"+j) != undefined)
				if(eval("document.form_del_camp_target_cons.pars_list_"+j).checked==false)
				eval("document.form_del_camp_target_cons.pars_list_"+j).checked = true;
				else
				eval("document.form_del_camp_target_cons.pars_list_"+j).checked = false;
		}
	}
</script>
