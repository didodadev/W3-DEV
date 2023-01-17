
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

<div class="table-responsive">
<table class="table">
	<thead>
		<tr>
			<td><cf_get_lang dictionary_id='57487.No'></td>
			<td><cf_get_lang dictionary_id='58820.Başlık'></td>
			<td><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></td>			
			<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
				<td><cf_get_lang dictionary_id='44019.Ürün'></td>
				<td>Spec</td>
				<cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td>Açıklama</td></cfif>
			</cfif>
			<cfif isdefined('attributes.is_order_reference_no') and attributes.is_order_reference_no eq 1>
				<td><cf_get_lang dictionary_id='58794.Referans No'></td>
			</cfif>
			<td><cf_get_lang dictionary_id='58796.Sipariş Veren'></td>
			<cfif isdefined("attributes.is_zone") and attributes.is_zone eq 1>
				<td><cf_get_lang dictionary_id='33624.Bölge Kodu'></td>
			</cfif>
			<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
				<td class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></td>
				<cfif isdefined('attributes.is_order_teslim_kalan') and attributes.is_order_teslim_kalan eq 1>
					<td class="text-right"><cf_get_lang dictionary_id='35897.Teslim Edilen'></td>
					<td class="text-right"><cf_get_lang dictionary_id='58444.Kalan'></td>
					<td class="text-right"><cf_get_lang dictionary_id='33986.Kalan Tutar'></td>
				</cfif>
			</cfif>
			<cfif (isDefined("attributes.is_currency_dsp") and attributes.is_currency_dsp) or not isdefined("attributes.is_currency_dsp")>
				<td class="text-right"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></td><!--- xmlden dövizli tutar gösterimi --->
			</cfif>
			<cfif isdefined('attributes.is_order_total') and attributes.is_order_total eq 1>
				<td class="text-right"><cf_get_lang dictionary_id='57673.Tutar'></td>
			</cfif>
			<cfif isdefined('attributes.is_show_discount') and attributes.is_show_discount eq 1>
				<td class="text-right" title="Parapuan ve Hediye Kartı">Kullanılan İndirimler</td>
				<td class="text-right"><cf_get_lang dictionary_id='34377.Ödenecek Tutar'></td>
			</cfif>
			<cfif isdefined("attributes.is_product_count") and attributes.is_product_count eq 1>
				<td class="text-right"><cf_get_lang dictionary_id='58082.Adet'></td>
			</cfif>
			<cfif isdefined("attributes.is_order_status") and attributes.is_order_status eq 1>
				<td><cf_get_lang dictionary_id='57756.Durum'></td>
			</cfif>
			<cfif isdefined("attributes.is_order_address") and attributes.is_order_address eq 1>
				<td><cf_get_lang dictionary_id='58449.Teslim Yeri'></td>
			</cfif>
			<cfif isdefined('attributes.is_record_date') and attributes.is_record_date eq 1>
				<td><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></td>
			</cfif>
			<cfif isdefined("attributes.x_mng_entegrasyon") and attributes.x_mng_entegrasyon eq 1>
				<td class="text-right"></td>
			</cfif>
			<cfif isdefined("attributes.x_aras_entegrasyon") and attributes.x_aras_entegrasyon eq 1>
				<td class="text-right"></td>
			</cfif>
			<cfif isdefined("attributes.x_yurtici_entegrasyon") and attributes.x_yurtici_entegrasyon eq 1>
				<td class="text-right"></td>
			</cfif>
			<cfif isdefined("attributes.is_order_cargo") and attributes.is_order_cargo eq 1>
				<td></td>
			</cfif>
			<cfif isdefined("attributes.is_order_callcenter") and attributes.is_order_callcenter eq 1>
				<td></td>
			</cfif>
		</tr>
	</thead>
	<cfset partner_id_list = ''>
	<cfset consumer_id_list = ''>
	<cfset order_id_list = ''>
	<cfset order_row_id_list = ''>
	<cfset ims_id_list = ''>
	<cfif get_order_list.recordcount>
	<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
			<cfset partner_id_list=listappend(partner_id_list,partner_id)>
		</cfif>
		<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
			<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
		</cfif>
		<cfif len(order_id) and not listfind(order_id_list,order_id) and (is_processed eq 1)><!--- BK 20070522 is_processed sevk durumuna gelme olayi  --->
			<cfset order_id_list=listappend(order_id_list,order_id)>
		</cfif>	
		<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (len(order_row_id) and not listfind(order_row_id_list,order_row_id))>
			<cfset order_row_id_list=listappend(order_row_id_list,order_row_id)>
		</cfif>	
		<cfif len(ims_code_id) and not listfind(ims_id_list,ims_code_id)>
			<cfset ims_id_list=listappend(ims_id_list,ims_code_id)>
		</cfif>	
	</cfoutput>
	<cfset ims_id_list=listsort(ims_id_list,"numeric")>
	<cfif len(ims_id_list)>
		<cfset GET_IMS = order.GET_IMS(ims_id_list: ims_id_list)>
		<cfset ims_id_list = listsort(listdeleteduplicates(valuelist(get_ims.ims_code_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(order_id_list) and isdefined("attributes.is_order_cargo") and attributes.is_order_cargo eq 1>
		<cfset order_id_list=listsort(order_id_list,"numeric","ASC",",")>
		<cfset GET_ORDERS_SHIP = order.GET_ORDERS_SHIP(order_id_list: order_id_list)>
	</cfif>
	<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (len(order_row_id_list)) and (isdefined('attributes.is_order_teslim_kalan') and attributes.is_order_teslim_kalan eq 1)>
		<cfset order_row_id_list=listsort(order_row_id_list,"numeric","ASC",",")>
		<cfset GET_PRODUCTION_INFO = order.GET_PRODUCTION_INFO(order_row_id_list: order_row_id_list)>
		<cfset GET_SHIP_AMOUNT = order.GET_SHIP_AMOUNT(order_row_id_list: order_row_id_list)>
		
		<cfscript>
			for(gpi_ind=1;gpi_ind lte get_production_info.recordcount;gpi_ind=gpi_ind+1)
			{
				if(not isdefined('toplam_#get_production_info.order_row_id[gpi_ind]#'))
					'toplam_#get_production_info.order_row_id[gpi_ind]#' = get_production_info.quantity[gpi_ind];
				else
					'toplam_#get_production_info.order_row_id[gpi_ind]#' = Evaluate('toplam_#get_production_info.order_row_id[gpi_ind]#')+get_production_info.quantity[gpi_ind];
			}
			for(gpi_ind=1;gpi_ind lte get_ship_amount.recordcount;gpi_ind=gpi_ind+1)
			{
				'toplam_irsaliye_#get_ship_amount.order_row_id[gpi_ind]#' =get_ship_amount.ship_amount[gpi_ind];
			}
		</cfscript>
	</cfif>
	<cfif len(partner_id_list)>
		<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
		<cfset GET_PARTNER = order.GET_PARTNER(partner_id_list: partner_id_list)>
	<cfelse>
		<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
		<cfset GET_CONSUMER = order.GET_CONSUMER(consumer_id_list: consumer_id_list)>
		
	</cfif>
	<cfset total_quantity = 0>
	<cfset total_order = 0>
	<cfset total_amount = 0>
	<cfif attributes.page neq 1>
		<cfoutput query="get_order_list" startrow="1" maxrows="#attributes.startrow-1#">
			<cfset total_order = total_order +  nettotal>
			<cfset total_quantity = total_quantity +  total_amount>
		</cfoutput>				  
	</cfif>
	
	<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		
		<tr>
			<td><a href="/#get_page.DET_PAGE_URL#/#order_id#<cfif isdefined("attributes.is_ref_order") and attributes.is_ref_order eq 1>/ref_company=1</cfif>" class="tableyazi">#order_number#</a></td>
			<td><a href="#request.self#?fuseaction=objects2.order_detail&order_id=#order_id#<cfif isdefined("attributes.is_ref_order") and attributes.is_ref_order eq 1>&ref_company=1</cfif>" class="tableyazi">#order_head#</a></td>
			<td>#dateformat(order_date,'dd/mm/yyyy')#</td>             
			<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
                <td><a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#product_name#</a></td>
				<td><cfif len(spect_var_name) and spect_var_name neq product_name>#spect_var_name#</cfif></td>
                <cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td>#product_name2#</td></cfif>
            </cfif>
			<cfif isdefined('attributes.is_order_reference_no') and attributes.is_order_reference_no eq 1>
				<td>#ref_no#</td>
			</cfif>
            <td><cfif len(partner_id_list)>
					#get_partner.company_partner_name[listfind(partner_id_list,get_order_list.partner_id,',')]# #get_partner.company_partner_surname[listfind(partner_id_list,get_order_list.partner_id,',')]#
				<cfelse>
					#get_consumer.consumer_name[listfind(consumer_id_list,get_order_list.consumer_id,',')]# #get_consumer.consumer_surname[listfind(consumer_id_list,get_order_list.consumer_id,',')]#
				</cfif>
			</td>
			<cfif isdefined("attributes.is_zone") and attributes.is_zone eq 1>
				<td  nowrap class="text-right">
					<cfif len(ims_code_id)>
						#get_ims.ims_code[listfind(ims_id_list,ims_code_id,',')]#
					</cfif>
				</td>
			</cfif>
            <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
                <td class="text-right">#quantity# #unit#</td>
				<cfif isdefined('attributes.is_order_teslim_kalan') and attributes.is_order_teslim_kalan eq 1>
					<td  nowrap class="text-right">
						<cfif isdefined('toplam_irsaliye_#order_row_id#')>
							<cfset irsaliye__ = Evaluate('toplam_irsaliye_#order_row_id#')>
						<cfelse>
							<cfset irsaliye__ = 0>
						</cfif>
						#irsaliye__#
					</td>
					<td nowrap class="text-right"> 
						<cfif isdefined('attributes.is_order_teslim_kalan') and attributes.is_order_teslim_kalan eq 1>
							<cfif isdefined('toplam_#order_row_id#')>
								<cfset kalan_uretim_emri = quantity-Evaluate('toplam_#order_row_id#')>
							<cfelse>
								<cfset kalan_uretim_emri = quantity>
							</cfif>
							<cfif isdefined('toplam_irsaliye_#order_row_id#')>
								<cfset kalan_irsaliye = quantity-Evaluate('toplam_irsaliye_#order_row_id#')>
							<cfelse>
								<cfset kalan_irsaliye = quantity>
							</cfif>
						</cfif>
						#kalan_irsaliye#
					</td>
					<td class="text-right">
						<cfset kalan_total_ = kalan_irsaliye*price>
						<cfif len(kalan_total_) and isdefined("session.pp.money")>
							#TLFormat(kalan_total_)# #session.pp.money#
						<cfelseif len(kalan_total_) and isdefined("session.ww.money")>
							#TLFormat(kalan_total_)# #session.ww.money#
						<cfelseif len(kalan_total_) and isdefined("session.ep.money")>
							#TLFormat(kalan_total_)# #session.ep.money#
						</cfif>
					</td>
				</cfif>
            </cfif>
			<cfif (isDefined("attributes.is_currency_dsp") and attributes.is_currency_dsp) or not isdefined("attributes.is_currency_dsp")>
            	<td  class="text-right"><cfif len(other_money_value)>#TLFormat(other_money_value)# #other_money#</cfif></td>
			</cfif>
            <cfif isdefined('attributes.is_order_total') and attributes.is_order_total eq 1>
                <td  class="text-right">
                    <cfif len(nettotal) and isdefined("session.pp.money")>
                        #TLFormat(nettotal)# #session.pp.money#
                    <cfelseif len(nettotal) and isdefined("session.ww.money")>
                        #TLFormat(nettotal)# #session.ww.money#
                    <cfelseif len(nettotal) and isdefined("session.ep.money")>
                        #TLFormat(nettotal)# #session.ep.money#
                    </cfif>
                    <cfset total_order = total_order +  nettotal>
                </td>
            </cfif>
			<cfif isdefined('attributes.is_show_discount') and attributes.is_show_discount eq 1>
                <td  class="text-right">
                    #TLFormat(use_credit)#
                </td>
				<td  class="text-right">
                    #TLFormat(nettotal-use_credit)#
                </td>
			</cfif>
			<cfif isdefined("attributes.is_product_count") and attributes.is_product_count eq 1>
				<td  class="text-right">
					#total_amount#
					<cfset total_quantity = total_quantity +  total_amount>
				</td>
			</cfif>
			<cfif isdefined("attributes.is_order_status") and attributes.is_order_status eq 1>
				<td align="center"><cfif order_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='35966.İptal Edildi'></cfif></td>
			</cfif>
            <cfif isdefined("attributes.is_order_address") and attributes.is_order_address eq 1>
                <td>#ship_address#</td>
            </cfif>
			<cfif isdefined('attributes.is_record_date') and attributes.is_record_date eq 1>
				<td>#dateformat(record_date,'dd/mm/yyyy')#
					<cfif isDefined("session.pp")>
						(#timeformat(date_add('h',session.pp.time_zone,record_date),'HH:MM')#)
					<cfelseif isdefined("session.ww")>
						(#timeformat(date_add('h',session.ww.time_zone,record_date),'HH:MM')#)
					<cfelseif isdefined("session.ep")>
						(#timeformat(date_add('h',session.ep.time_zone,record_date),'HH:MM')#)
					</cfif>
				</td>
			</cfif>
			<cfif isdefined("attributes.x_mng_entegrasyon") and attributes.x_mng_entegrasyon eq 1>
				<td align="center">
					<script type="text/javascript">
						function mng_kargo(o_number)
						{
							var get_mng_result = wrk_safe_query('obj2_get_mng_result','SorunTakip',0,o_number);
							if(get_mng_result.recordcount > 0)
							{
								var fatseri = get_mng_result.FATSERI;
								var fatnumara = get_mng_result.FATNO;
								window.open('http://service.mngkargo.com.tr/iactive/takip.asp?fatseri='+fatseri+'&fatnumara='+fatnumara+'&fi=2','_blank');
							}
							else if(get_mng_result.recordcount == 0)
							{
								alert('Kargo Bilgisi Ulaşmamıştır !');
								return false;
							}
							else
							{
								alert("MNG Entegrasyonu Datası Çekildiği İçin Production Ortamında Hata Verebilir. XML Tanımını Kontrol Ediniz.");
							}
						}
					</script>
				<cfif order_status eq 1>
 					<a href="javascript://" onclick="mng_kargo('#order_number#');"><!---<img src="/images/mng.png" title="MNG Kargo Bilgileri" border="0">--->MNG Kargo Bilgileri</a> 
				</cfif>
				</td>
			</cfif>
            <cfif isdefined("attributes.x_aras_entegrasyon") and attributes.x_aras_entegrasyon eq 1>
				<td align="center">
					<cfif order_status eq 1 and len(cargo_invoice_no)>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.emptypopup_cargo_detail&cargo_type=aras&ref_no=#cargo_invoice_no#','wide');"><img src="/images/araskargo.png" title="Aras Kargo Bilgileri" border="0"></a> 
                    </cfif>
				</td>
			</cfif>
			<cfif isdefined("attributes.x_yurtici_entegrasyon") and attributes.x_yurtici_entegrasyon eq 1>
				<td align="center">
					<cfif order_status eq 1 and len(ref_no)>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.emptypopup_cargo_detail&cargo_type=yurtici&ref_no=#ref_no#','wide');"><img src="/images/yurtici.png" title="Yurtici Kargo Bilgileri" width="25px" height="25px" border="0"></a> 
                    </cfif>
				</td>
			</cfif>
			<cfif isdefined("attributes.is_order_cargo") and attributes.is_order_cargo eq 1>
				<td width="60">
                	<cfquery name="GET_STAGE_NAME" dbtype="query">
                    		SELECT * FROM GET_STAGE_INFO WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_stage#">
                    </cfquery>
                	<cfif isdefined('attributes.is_order_state') and attributes.is_order_state eq 1>
                    	<cfif get_stage_name.recordcount and len(get_stage_name.stage)>
                    		 #get_stage_name.stage#
                        </cfif>
                    <cfelseif isdefined('attributes.is_order_state') and attributes.is_order_state eq 2>
                    	<cfif get_stage_name.recordcount and len(get_stage_name.detail)>
                    		 #get_stage_name.detail#
                        </cfif>
                	<cfelseif isdefined('attributes.is_order_state') and attributes.is_order_state eq 0>
						<cfif is_processed eq 1>
                            <cfquery name="GET_ORDERS_" dbtype="query">
                                SELECT * FROM GET_ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_list.order_id#">
                            </cfquery>
                            <cfif get_orders_.recordcount>
                                <cfif get_orders_.ozel_kod_2 eq 'YURTICI KARGO'>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_cargo_information&cargo_type=1&order_number=#order_number#&ozel_alan=#GET_ORDERS_SHIP.SHIP_FIS_NO#','horizantal','popup_cargo_information');" title="<cf_get_lang no='1193.Yurt İçi Kargo Bilgileri'>"><img src="/images/cargo.gif" alt="<cf_get_lang no='1193.Yurt İçi Kargo Bilgileri'>" border="0" /></a>
                                <cfelseif get_orders_.ozel_kod_2 eq 'UPS' and len(get_our_company_info.cargo_customer_code)>
                                    <cfset date1 = get_order_list.order_date>
                                    <cfset date2 = date_add('d',15,get_order_list.order_date)>
                                    <cfset g1 = dateformat(date1,"dd")>
                                    <cfset a1 = dateformat(date1,"mm")>
                                    <cfset y1 = dateformat(date1,"yyyy")>
                                    <cfset g2 = dateformat(date2,"dd")>
                                    <cfset a2 = dateformat(date2,"mm")>
                                    <cfset y2 = dateformat(date2,"yyyy")>
                                    <a href="javascript://" onclick="windowopen('http://www.ups.com.tr/PMusteriRefSorguSonuc.asp?musterikodu=#get_our_company_info.cargo_customer_code#&referansNo=#listlast(get_orders_.ship_fis_no,'-')#&g1=#g1#&a1=#a1#&y1=#y1#&g2=#g2#&a2=#a2#&y2=#y2#','horizantal','popup_cargo_information');" title="<cf_get_lang no='1194.UPS Kargo Bilgileri'>" ><img src="/images/cargo.gif" alt="<cf_get_lang no='1194.UPS Kargo Bilgileri'>" border="0" /></a>
                                <cfelseif get_orders_.ozel_kod_2 eq 'SURAT'>
									<a href="javascript://" onclick="windowopen('http://www.suratkargo.com.tr/kargoweb/bireysel.aspx?SATICI=1013916120-1013940737&no=AS&action=Getir','horizantal','popup_cargo_information');" title="Sürat Kargo Bilgileri" ><img src="/images/surat_kargo.gif" alt="Sürat Kargo Bilgileri" border="0" style="width:20px;" /></a>
								</cfif>
                            </cfif>
                        <cfelse>
                            <font color="FF0000"><cf_get_lang dictionary_id="35966.Açık"></font>
                        </cfif>
                    </cfif>
				</td>
			</cfif>
            <cfif isdefined("attributes.is_order_callcenter") and attributes.is_order_callcenter eq 1>
                <td><a href="javascript://"onclick="windowopen('#request.self#?fuseaction=objects2.popup_add_service_callcenter&order_no=#order_number#','list')" title="<cf_get_lang no='1608.Şikayet Ekle'>"><img src="/images/tel.gif" alt="<cf_get_lang no='1608.Şikayet Ekle'>" border="0" /></a></td>
            </cfif>
		</tr>		
	</cfoutput> 
	<cfif isdefined("attributes.is_dsp_total") and attributes.is_dsp_total eq 1>
		<cfoutput>
			<tr>
				<cfif (isDefined("attributes.is_currency_dsp") and attributes.is_currency_dsp) or not isdefined("attributes.is_currency_dsp")>
					<cfset colspan_info = 5>
				<cfelse>
					<cfset colspan_info = 4>
				</cfif>
				<cfif isdefined("attributes.is_zone") and attributes.is_zone eq 1>
					<cfset colspan_info = colspan_info + 1>
				</cfif>
                <cfif isdefined("attributes.listing_type") and attributes.listing_type eq 2>
					<cfset colspan_info = colspan_info + 3>
				</cfif>
				<td colspan="#colspan_info#" class="text-right"><cf_get_lang dictionary_id='57492.Toplam'></td>
				<td class="text-right">
					#tlformat(total_order)# #session_base.money#
				</td>
				<cfif isdefined("attributes.is_product_count") and attributes.is_product_count eq 1>
					<td class="text-right">
						#tlformat(total_quantity)#
					</td>
				</cfif>
				<td colspan="9"></td>
			</tr>
		</cfoutput>
	</cfif>
	<cfelse>
		<tr> 
			<td colspan="15"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
		</tr>
	</cfif>
</table>
</div>
<cfif attributes.maxrows lt attributes.totalrecords> 
	<div class="table-responsive">
		<table class="table">
			<tr> 
				<td> 
					<cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="#url_str#"> 
				</td>
				<td class="text-right"><cfoutput> <cf_get_lang dictionary_id='55072.Toplam Kayıt'> : #attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'> : #attributes.page# / #lastpage#</cfoutput></td>
			</tr>
		</table>
	</div>
</cfif>
