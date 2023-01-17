<cfinclude template="../login/send_login.cfm">
<cfset order = createObject("component","V16.objects2.sale.cfc.order")>
<cfset GET_STAGE_INFO = order.GET_STAGE_INFO()>
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.order_stage" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.zone" default="">
<cfif isdefined('attributes.is_order_list_type_id')>
	<cfparam name="attributes.listing_type" default="#attributes.is_order_list_type_id#">
<cfelse>
	<cfparam name="attributes.listing_type" default="1">
</cfif>
<cfif isdefined('attributes.is_last_order') and attributes.is_last_order eq 1>
	<cfset attributes.form_submitted = 1>
	<cfset attributes.start_date = date_add('d',-3,now())>
	<cfset attributes.finish_date = now()>
</cfif>
<cfset GET_CAMP = order.GET_CAMP()>

<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<!--- xml deki parametreye gore tarihler dolu gelir --->	
	<cfif isdefined("attributes.is_campaign_date_list") and attributes.is_campaign_date_list eq 1 and get_camp.recordcount>
		<cfset  attributes.start_date = createodbcdatetime(get_camp.camp_startdate)>
	<cfelse>
		<cfset attributes.start_date = ''>
	</cfif>
</cfif>

<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfif isdefined("attributes.is_campaign_date_list") and attributes.is_campaign_date_list eq 1 and get_camp.recordcount>
		<cfset attributes.finish_date = createodbcdatetime(get_camp.camp_finishdate)>
	<cfelse>
		<cfset attributes.finish_date = ''>
	</cfif>
</cfif>

<cfif isdefined("session.pp.company_id")>
	<cfset comp_id = session.pp.our_company_id>
<cfelseif isdefined("session.ww.userid")>
	<cfset comp_id = session.ww.our_company_id>
<cfelseif isdefined("session.ep.userid")>
	<cfset comp_id = session.ep.company_id>
</cfif>

<cfif isdefined("session.ww.userid") and isdefined("attributes.is_ref_order") and attributes.is_ref_order eq 1>
	<cfset GET_CONS_REF_CODE = order.GET_CONS_REF_CODE(userid : session.ww.userid)>

	<cfif get_camp.recordcount>
		<cfset GET_LEVEL = order.GET_LEVEL(consumer_cat_id : get_cons_ref_code.consumer_cat_id, camp_id : get_camp.camp_id)>
		<cfset ref_count = get_level.pre_level + listlen(get_cons_ref_code.consumer_reference_code,'.')>
	<cfelse>
		<cfset ref_count = 0>
	</cfif>
	<cfset GET_REF_MEMBER = order.GET_REF_MEMBER(user_id : session.ww.userid, ref_count : ref_count)>
	
	<cfset list_ref_member = ''>
	<cfoutput query="get_ref_member">
		<cfif len(consumer_id) and not listfind(list_ref_member,consumer_id)>
			<cfset list_ref_member = Listappend(list_ref_member,consumer_id)>
		</cfif>
	</cfoutput>
</cfif>

<cfset GET_OUR_COMPANY_INFO = order.GET_OUR_COMPANY_INFO()>

<cfif isdefined('attributes.form_submitted')>
	<cfset GET_ORDER_LIST = order.GET_ORDER_LIST(
													is_product_count : '#IIf(IsDefined("attributes.is_product_count"),"attributes.is_product_count",DE(''))#',
													listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(''))#',
													currency_id : '#IIf(IsDefined("attributes.currency_id"),"attributes.currency_id",DE(''))#',
													zone : '#IIf(IsDefined("attributes.zone"),"attributes.zone",DE(''))#',
													is_ref_order : '#IIf(IsDefined("attributes.is_ref_order"),"attributes.is_ref_order",DE(''))#',
													list_ref_member : '#IIf(IsDefined("attributes.list_ref_member"),"attributes.list_ref_member",DE(''))#',
													keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(''))#',
													order_stage : '#IIf(IsDefined("attributes.order_stage"),"attributes.order_stage",DE(''))#',
													status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(''))#',
													is_order_stage_no : '#IIf(IsDefined("attributes.is_order_stage_no"),"attributes.is_order_stage_no",DE(''))#',
													start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(''))#',
													finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(''))#',
													pos_code_text : '#IIf(IsDefined("attributes.pos_code_text"),"attributes.pos_code_text",DE(''))#',
													pos_code : '#IIf(IsDefined("attributes.pos_code"),"attributes.pos_code",DE(''))#',
													comp_id : '#IIf(IsDefined("attributes.comp_id"),"attributes.comp_id",DE(''))#'
												)>
	
<cfelse>
	<cfset get_order_list.recordcount = 0>
</cfif>

<cfset order_currency_list="#getLang('main',1305)#,#getLang('main',1948)#,#getLang('main',1949)#,#getLang('main',1950)#,#getLang('main',44)#,#getLang('main',1349)#,#getLang('main',1951)#,#getLang('main',1952)#,#getLang('main',1094)#,#getLang('main',1211)#">

<cfif isdefined("session.pp.our_company_id")>
	<cfset my_our_comp_ = session.pp.our_company_id>
<cfelseif isdefined("session.ww.our_company_id")>
	<cfset my_our_comp_ = session.ww.our_company_id>
<cfelse>
	<cfset my_our_comp_ = session.ep.company_id>
</cfif>
<cfif isdefined('attributes.is_order_stage') and attributes.is_order_stage eq 1>
	<cfset GET_PROCESS_TYPE = order.GET_PROCESS_TYPE(my_our_comp_: my_our_comp_, is_order_stage_no: '#IIf(IsDefined("attributes.is_order_stage_no"),"attributes.is_order_stage_no",DE(''))#')>
</cfif>
<cfparam name="attributes.page" default=1>
<cfif isdefined("session.pp.maxrows")>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelseif isdefined("session.ww.maxrows")>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
</cfif>

<cfparam name="attributes.totalrecords" default='#get_order_list.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset url_str = "#request.self#">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.currency_id)>
	<cfset url_str = "#url_str#&currency_id=#attributes.currency_id#">
</cfif>
<cfif len(attributes.status)>
	<cfset url_str = "#url_str#&status=#attributes.status#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isDefined("attributes.order_stage") and len(attributes.order_stage)>
	<cfset url_str = "#url_str#&order_stage=#attributes.order_stage#">
</cfif>
<cfif isDefined("attributes.pos_code_text") and len(attributes.pos_code_text)>
	<cfset url_str = "#url_str#&pos_code_text=#attributes.pos_code_text#">
</cfif>
<cfif isDefined("attributes.pos_code") and len(attributes.pos_code)>
	<cfset url_str = "#url_str#&pos_code=#attributes.pos_code#">
</cfif>
	
<cfform name="list_order" method="post" action="#request.self#">
	<div class="in_filter_item">
		<input name="form_submitted" id="form_submitted" type="hidden" value="1">
		<div class="form-group col-md-6 col-lg-3 col-xl-2">
			<label><cf_get_lang dictionary_id='57460.Filtre'></label>
			<cfinput type="text" class="form-control" name="keyword" id="keyword" value="#attributes.keyword#">
		</div>		
		<cfif isdefined("attributes.is_order_list_type") and attributes.is_order_list_type eq 1>
			<div class="form-group col-md-6 col-lg-3 col-xl-2">
				<label>Listeleme Türü</label>
				<select class="form-control" name="listing_type" id="listing_type">
					<option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
					<option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
				</select>
			</div>
		</cfif>
		<cfif isdefined("attributes.is_pos_code") and attributes.is_pos_code eq 1>
			<div class="form-group col-md-6 col-lg-3 col-xl-2">
				<label><cf_get_lang dictionary_id='57908.Temsilci'></label>                       
				<input type="hidden" name="pos_code" id="pos_code" value="<cfif isdefined("attributes.pos_code_text") and len(attributes.pos_code) and len(attributes.pos_code) and len(attributes.pos_code_text)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
				<input type="Text" class="form-control" name="pos_code_text" id="pos_code_text" value="<cfif isdefined("attributes.pos_code_text") and len(attributes.pos_code_text)><cfoutput>#attributes.pos_code_text#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','list_order','3','150');">
				<!--- <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_positions&field_code=list_order.pos_code&field_name=list_order.pos_code_text&select_list=1','list')" title="<cf_get_lang_main no='496.Temsilci'> <cf_get_lang_main no='1281.Seç'>"><img src="/images/plus_thin.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='496.Temsilci'> <cf_get_lang_main no='1281.Seç'>" /></a>					 --->
			</div>
		</cfif>
		<cfif (isdefined("attributes.is_order_row_stage") and attributes.is_order_row_stage eq 1) or not isdefined("attributes.is_order_row_stage")>
			<div class="form-group col-md-6 col-lg-3 col-xl-2">
				<label><cf_get_lang dictionary_id='35890.Satır Aşaması'></label>
				<select class="form-control" name="currency_id" id="currency_id">
					<option value=""><cf_get_lang dictionary_id='35890.Satır Aşaması'></option>
					<cfoutput>
						<cfloop from="1" to="#listlen(order_currency_list)#" index="cur_list">
							<option value="#-1*cur_list#"<cfif attributes.currency_id eq (-1*cur_list)> selected</cfif>>#ListGetAt(order_currency_list,cur_list,",")#</option>
						</cfloop>
					</cfoutput>
				</select>
			</div>
		</cfif>
		<cfif isdefined("attributes.is_order_stage") and attributes.is_order_stage eq 1>
			<div class="form-group col-md-6 col-lg-3 col-xl-2">
				<label><cf_get_lang dictionary_id='57482.Aşama'></label>
				<select class="form-control" name="order_stage" id="order_stage">
					<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
					<cfoutput query="get_process_type">
						<option value="#process_row_id#"<cfif attributes.order_stage eq process_row_id>selected</cfif>>#stage#</option>
					</cfoutput>
				</select>
			</div>
		</cfif>
		<cfif isdefined("attributes.is_order_status") and attributes.is_order_status eq 1>
			<div class="form-group col-md-6 col-lg-3 col-xl-2">
				<label><cf_get_lang dictionary_id='57756.Durum'></label>
				<select class="form-control" name="status" id="status">
					<option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
					<option value="0"<cfif isdefined('attributes.status') and (attributes.status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					<option value="1"<cfif isdefined('attributes.status') and (attributes.status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
				</select>
			</div>
		</cfif>
		<cfif isdefined("attributes.is_order_zone") and attributes.is_order_zone eq 1>
			<div class="form-group col-md-6 col-lg-3 col-xl-2">
				<label><cf_get_lang dictionary_id='35895.Sipariş Kanalı'></label>
				<select class="form-control" name="zone" id="zone">
					<option value=""><cf_get_lang dictionary_id='35895.Sipariş Kanalı<'></option>
					<option value="1"<cfif isdefined('attributes.zone') and (attributes.zone eq 1)> selected</cfif>><cf_get_lang dictionary_id='58079.İnternet'></option>
					<option value="0"<cfif isdefined('attributes.zone') and (attributes.zone eq 0)> selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
				</select>
			</div>
		</cfif>
		<div class="form-group col-md-6 col-lg-3 col-xl-2">
			<label><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
			<div class="input-group">							
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='30122.Başlangıç Tarihini Kontrol Ediniz'></cfsavecontent>
				<cfinput type="text" class="form-control" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
				<div class="input-group-append">
					<span class="input-group-text"><cf_wrk_date_image date_field="start_date"></span> 
				</div>
			</div>
		</div>
		<div class="form-group col-md-6 col-lg-3 col-xl-2">
			<label><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
			<div class="input-group">	
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='30123.Bitiş Tarihini Kontrol Ediniz'></cfsavecontent>
				<cfinput type="text" class="form-control" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" >
				<div class="input-group-append">
					<span class="input-group-text"><cf_wrk_date_image date_field="finish_date"> </span>
				</div>
			</div>
		</div>
		<div class="form-group col-md-6 col-lg-3 col-xl-2">
			<label><cf_get_lang dictionary_id='58829.Kayıt Sayısı'></label>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
			<cfinput type="text" class="form-control" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
		</div>
		<div class="in_filter_item_btn form-group col-lg-2 col-xl-2">  
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 0>
				<cf_wrk_search_button is_excel='0'>
			<cfelse>
				<cf_wrk_search_button>
			</cfif>
		</div>			
	</div>
</cfform>