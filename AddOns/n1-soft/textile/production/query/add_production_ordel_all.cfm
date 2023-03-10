<!---<cfdump var="#attributes#"><cfabort> --->
<cfif not isdefined("new_keyword_")>
	<cfset new_keyword_ = "">
</cfif>


<cfparam name="prod_ind" default="1">
<cfif not isdefined('is_ok')><!--- Çoklu sayfadan da gelse sadece 1 kere include edilsin.. --->
	<cfinclude template="/V16/workdata/get_main_spect_id.cfm">
	<!---<cfinclude template="/V16/objects/functions/get_production_times.cfm">--->
	<cfset is_ok = 1>    
</cfif>
<cfparam name="attributes.total_production_product" default="1">
<cfparam name="attributes.total_production_product_all" default="1">
<cfif not isdefined("is_op")>
	<cfparam name="attributes.deep_level_op" default="0">
	<cfset is_op = 1>    
</cfif>
<cfparam name="prod_ind" default="1"><!--- normal üretim emri ekleme sayfasından geliyorsa 1 tane ürün olacağından 1 atıyoruz direkt olarak... --->
<cfscript>
    attributes.production_row_count = Evaluate("attributes.production_row_count_#prod_ind#");
    attributes.is_time_calculation =  Evaluate("attributes.is_time_calculation_#prod_ind#");
	if(isdefined("attributes.is_operator_display_#prod_ind#"))
    	attributes.is_operator_display = Evaluate("attributes.is_operator_display_#prod_ind#");//talep üretim ayrımını burdan yapıcaz..
    else
		attributes.is_operator_display = 0;
	attributes.start_date = Evaluate("attributes.start_date_#prod_ind#");
    attributes.start_m = Evaluate("attributes.start_m_#prod_ind#");
    attributes.start_h = Evaluate("attributes.start_h_#prod_ind#");
    attributes.finish_m = Evaluate("attributes.finish_m_#prod_ind#");
    attributes.finish_h = Evaluate("attributes.finish_h_#prod_ind#");
    attributes.deliver_date= Evaluate("attributes.deliver_date_#prod_ind#");
	if(isdefined("attributes.works_prog_#prod_ind#"))
   		attributes.works_prog = Evaluate("attributes.works_prog_#prod_ind#");
    else
		attributes.works_prog = 1;
	attributes.production_type = 1; //Evaluate("attributes.production_type_#prod_ind#");
    attributes.project_id = Evaluate("attributes.project_id_#prod_ind#");
	if(isdefined("attributes.demand_no_#prod_ind#"))
		attributes.demand_no = Evaluate("attributes.demand_no_#prod_ind#");
	if(isdefined('attributes.demand_no') and len(attributes.demand_no))	
		attributes.demand_no = attributes.demand_no;
	else
		attributes.demand_no = '';
	if(isdefined("attributes.wrk_row_relation_id_#prod_ind#"))
		attributes.wrk_row_relation_id = Evaluate("attributes.wrk_row_relation_id_#prod_ind#");
	else
		attributes.wrk_row_relation_id = '';
	if(isdefined("attributes.work_id_#prod_ind#"))
		attributes.work_id = Evaluate("attributes.work_id_#prod_ind#");
	if(isdefined('attributes.work_id') and len(attributes.work_id))	
		attributes.work_id = attributes.work_id;
	else
		attributes.work_id = '';
	if(isdefined("attributes.work_head_#prod_ind#"))
		attributes.work_head = Evaluate("attributes.work_head_#prod_ind#");
	if(isdefined('attributes.work_head') and len(attributes.work_head))	
		attributes.work_head = attributes.work_head;
	else
		attributes.work_head = '';
</cfscript>
<cfif isdefined('attributes.is_time_calculation') and attributes.is_time_calculation eq 0><!--- Zaman Hesaplaması Yapılmamış denmiş ise her üretim için başlangıç ve bitiş saatini atıycaz. --->
    <cfif isdefined('attributes.start_date') and isdate(attributes.start_date) and len(attributes.start_m) and len(attributes.start_h)>
      <!---  <cf_date tarih = "attributes.start_date">--->
        <cfset attributes.start_date = date_add("n",attributes.start_m,date_add("h",attributes.start_h ,attributes.start_date))><!--- - session.ep.time_zone --->
    <cfelse>
        <cfset attributes.start_date ="">
    </cfif>
    <cfif isdefined('attributes.deliver_date') and isdate(attributes.deliver_date) and len(attributes.finish_h) and len(attributes.finish_m)>
        <!---<cf_date tarih = "attributes.deliver_date">--->
        <cfset attributes.deliver_date = date_add("n",attributes.finish_m,date_add("h",attributes.finish_h ,attributes.deliver_date))><!--- - session.ep.time_zone --->
    <cfelse>
        <cfset attributes.deliver_date = '' >
    </cfif>
<cfelse><!--- Zaman Hesaplaması Yapılsın Denilmiş ise --->
    <cfparam name="n_now_#prod_ind#" default="">
    <cfset xxx_list = ''><!--- Bu liste iç içe kırılımı olan ürünlerde alttaki ürünlerin daha önce üretilmesi için kullanılıyor. --->
    <cfset new_production_row_count_list = ''><!--- Bu değişken ise ürünlerin hangi sırada üretileceğini tutar --->
    <cfloop  to="#attributes.production_row_count#" from="1" index="indexx">
        <cfif isdefined('attributes.product_is_production_#prod_ind#_#indexx#')><!--- Üretilsin diye seçilmiş ise! --->
           <cfif (ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',') eq 1  and len(xxx_list))><!--- 1.ci kırılımdaki ürünler ise --->
                <cfif ListLen(xxx_list,'-')>
                    <cfloop  from="#ListLen(xxx_list,'-')#" to="1" index="real_index" step="-1"><!--- burdaki loop'u listeyi tersine çevirmek için kullanıyoruz. --->
                        <cfset new_production_row_count_list = ListAppend(new_production_row_count_list,ListGetAt(xxx_list,real_index,'-'),',')>
                    </cfloop>
                </cfif>
                <cfset xxx_list =''><!--- 1.ci kırılımdaki ürüne denk geldiğinde bu listeyi sıfırlıyoruz,sonraki 1.ci kırılım ürünleride kendi içinde gruplasın diye! --->
            </cfif>
            <cfset xxx_list = ListAppend(xxx_list,'#ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),4,',')#','-')>
             <cfif indexx eq attributes.production_row_count and listlen(xxx_list) and not ListFind(new_production_row_count_list,xxx_list,',')>
                <cfoutput>
                    <cfloop  from="#ListLen(xxx_list,'-')#" to="1" index="real_index_" step="-1">
                        <cfset new_production_row_count_list = ListAppend(new_production_row_count_list,ListGetAt(xxx_list,real_index_,'-'),',')>
                    </cfloop>
                </cfoutput>
            </cfif>
        </cfif>
    </cfloop>
    <cfset new_production_row_count_list = ListAppend(new_production_row_count_list,0,',')><!--- Son olarak ana ürün üretileceği için onun numarası olan 0'ı ekliyoruz. --->
    <cfloop list="#new_production_row_count_list#" index="indexx">
        <cfif listlen(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),',') eq 4><!--- bu kontrol sonrada kalkacak! --->
            <cfset setup_time = ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),4,',')>
        <cfelse>
            <cfset setup_time = 0 >
        </cfif>
        <cfscript> 
            'production_times#indexx#'=get_production_times(
                station_id : ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),1,','),
                shift_id : attributes.works_prog,
                stock_id : ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),1,','),
                amount : Evaluate('attributes.product_amount_#prod_ind#_#indexx#'),
                production_type : attributes.production_type,
                setup_time_min : setup_time,
                _now_ : Evaluate("n_now_#prod_ind#")
                
            );
        </cfscript>
        <cfset x_now_ = date_add('h',session.ep.TIME_ZONE,now())>
        <cfif not isdefined('production_times#indexx#')><!--- Olası bir hata olduğunda zamanı ayarlasın --->
            <cfset 'production_times#indexx#' = "#DateFormat(x_now_,'YYYYMMDD')#,#TimeFormat(x_now_,'HH:MM')#,#DateFormat(date_add('h',1,x_now_),'YYYYMMDD')#,#TimeFormat(date_add('h',1,x_now_),'HH:MM')#">
        </cfif>
        <cfset s_yil = Left(ListGetAt(Evaluate('production_times#indexx#'),1,','),4)>
        <cfset s_ay =  mid(ListGetAt(Evaluate('production_times#indexx#'),1,','),5,2)>
        <cfset s_gun = mid(ListGetAt(Evaluate('production_times#indexx#'),1,','),7,2)>
        <cfset s_saat =ListFirst(ListGetAt(Evaluate('production_times#indexx#'),2,','),':')>
        <cfset s_dakika =ListLast(ListGetAt(Evaluate('production_times#indexx#'),2,','),':')>
        
        <cfset f_yil = Left(ListGetAt(Evaluate('production_times#indexx#'),3,','),4)>
        <cfset f_ay =  mid(ListGetAt(Evaluate('production_times#indexx#'),3,','),5,2)>
        <cfset f_gun = mid(ListGetAt(Evaluate('production_times#indexx#'),3,','),7,2)>
        <cfset f_saat =ListFirst(ListGetAt(Evaluate('production_times#indexx#'),4,','),':')>
        <cfset f_dakika =ListLast(ListGetAt(Evaluate('production_times#indexx#'),4,','),':')>
        <cfset 'startdate_fn_#prod_ind#_#indexx#' = CreateDateTime(s_yil,s_ay,s_gun,s_saat,s_dakika,0)>
        <cfset 'finishdate_fn_#prod_ind#_#indexx#' = CreateDateTime(f_yil,f_ay,f_gun,f_saat,f_dakika,0)>
       <cfset XYZ = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',')>
	   <cfif isdefined("last_start_#XYZ#")>
			<cfif isdefined('attributes.station_id_#prod_ind#_#indexx#')>
				<cfif indexx neq 0 and ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),1,',') neq evaluate('last_station_#XYZ#')>
					<cfset 'startdate_fn_#prod_ind#_#indexx#' = evaluate('last_start_#XYZ#')>
					<cfset 'finishdate_fn_#prod_ind#_#indexx#' = evaluate('last_finish_#XYZ#')>
				</cfif>
			<cfelse>
				<cfif indexx neq 0 and ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',') eq ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx+1#'),3,',')>
					<cfset 'startdate_fn_#prod_ind#_#indexx#' = evaluate('last_start_#XYZ#')>
					<cfset 'finishdate_fn_#prod_ind#_#indexx#' = evaluate('last_finish_#XYZ#')>
				</cfif>
			</cfif>
	   </cfif>
       <cfif isdefined('XYZ') and XYZ gt ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',') and ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',') neq 1>
          <cfset "n_now_#prod_ind#" = '' >
       <cfelse>
          <cfset "n_now_#prod_ind#" = Evaluate('finishdate_fn_#prod_ind#_#indexx#') >
       </cfif>
	   <cfset "last_start_#XYZ#" = Evaluate('startdate_fn_#prod_ind#_#indexx#')>
	   <cfset "last_station_#XYZ#" = ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),1,',')>
	   <cfset "last_finish_#XYZ#" = Evaluate('finishdate_fn_#prod_ind#_#indexx#')>
        <cfstoredproc procedure="ADD_PRODUCTION_ORDER_CASH" datasource="#DSN3#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('startdate_fn_#prod_ind#_#indexx#')#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('finishdate_fn_#prod_ind#_#indexx#')#">
            <cfprocparam cfsqltype="cf_sql_integer" value="#ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),1,',')#">
        </cfstoredproc>
    </cfloop>
</cfif>
<cf_papers paper_type="production_lot"><!--- Lotnumarası sadece 1 kere alınacak --->
<cfscript>
	if (IsDefined("attributes.LOTNO_LIST"))
		lot_system_paper_no=attributes.lot_no;
	else
		lot_system_paper_no=paper_code & '-' & paper_number & '-' & attributes.operation_type;
	
    lot_system_paper_no_add=paper_number;
</cfscript>
<cfif not len(lot_system_paper_no_add)>
    <script type="text/javascript">
        alert("<cf_get_lang no ='623.Lütfen Lot Belge Numaralarınızı Tanımlayınız'> !");
        history.go(-1);
    </script>
    <cfabort>
</cfif>
<cfstoredproc procedure="UPD_GENERAL_PAPERS_LOT_NUMBER" datasource="#dsn3#">
	<cfprocparam cfsqltype="cf_sql_integer" value="#lot_system_paper_no_add#">
</cfstoredproc>
		
<cfloop from="0" to="#attributes.production_row_count#" index="sayac">
    <cfif isdefined('attributes.product_is_production_#prod_ind#_#sayac#') or sayac eq 0><!--- Eğer Üret Seçeneği Seçilmiş ise  yada sadece ana ürün ise bu bloğa girer --->
        <cf_papers paper_type="prod_order"><!--- Belge Numarası her üretim için tek tek alınıyor! --->
        <cfscript>
            system_paper_no=paper_code & '-' & paper_number;
            system_paper_no_add=paper_number;
        </cfscript>
		<cfif len(new_keyword_)>
			<cfset new_keyword_ = "#new_keyword_#,#system_paper_no#">
		<cfelse>
			<cfset new_keyword_ = "#system_paper_no#">	
		</cfif>
        <cfif not len(system_paper_no_add)>
            <script type="text/javascript">
                alert("<cf_get_lang_main no='1890.Lütfen Belge Numaralarınızı Tanımlayınız'> !");
                history.go(-1);
            </script>
            <cfabort>
        </cfif>
<!---<cfdump var="#attributes#" abort>--->
        <cflock name="#CreateUUID()#" timeout="60">
            <cftransaction>
			
            <cfif prod_ind eq 1 and sayac eq 0>
                <cfquery name="get_party_no" datasource="#dsn3#">
                    SELECT PRODUCTION_PARTY_NO,PRODUCTION_PARTY_NUMBER FROM GENERAL_PAPERS
                    WHERE PAPER_TYPE IS NULL AND ZONE_TYPE=0
                </cfquery>
                <cfset party_paperno="#get_party_no.PRODUCTION_PARTY_no#"&"-"&"#get_party_no.PRODUCTION_PARTY_number+1#">
                <cfset attributes.party_number=party_paperno>
        
                <cfquery name="prod_kontrol" datasource="#dsn3#">
                    select *from TEXTILE_PRODUCTION_ORDERS_MAIN WHERE PARTY_NO='#attributes.party_number#'
                </cfquery>
                <cfif prod_kontrol.recordcount gt 0>
                <script>
                    alert('Bu parti numaralı üretim emirleri var.Parti Numarasını değiştiriniz!');
                        history.go(-1);
                </script>
                  <cfabort>
                  </cfif>
				<cfquery name="add_production_orders_main" datasource="#dsn3#" result="MAX_ID">
					INSERT INTO [TEXTILE_PRODUCTION_ORDERS_MAIN]
					   (
						[PARTY_NO]
					   ,[PARTY_STARTDATE]
					   ,[PARTY_FINISHDATE]
					   ,[STAGE]
					   ,[PRODUCT_ID]
					    ,ORDER_ID
						,[OPERATION_TYPE_ID]
                        ,MAIN_OPERATION_ID
                        ,REQ_ID
                        ,P_OPERATION_ID
                        ,STATION_ID
						)
				 VALUES
					   (
						'#attributes.party_number#'
					   ,#attributes.party_start_date#
					   ,#attributes.party_finish_date#
					   ,#attributes.process_stage#
					   ,#attributes.pid#
					   ,#attributes.order_id#
					   ,#attributes.operation_type_id#
                       ,#attributes.main_operation_id#
                       ,#attributes.req_id#
                       ,#attributes.p_operation_id#
                       ,<cfif isdefined('attributes.station_id_#prod_ind#_#sayac#') and len(ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),1,',')) and ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),1,',') gt 0>
                        	#ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),1,',')#
                        <cfelse>
                        	NULL
                        </cfif>
						)
				</cfquery>
				<cfset attributes.party_id=MAX_ID.IDENTITYCOL>
			</cfif>
                <cfset production_stock_id = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),1,',')>
                <cfif sayac eq 0><!--- Sadece Ana Ürünün spect_id'si spect_var_id'yi tutuyor diğerleri ise spect_main_id'yi tutuyor bu sebeble diğerlerinde spect_id'ler yeniden oluşturulucak specer fonksiyonu ile --->
                    <cfset spect_id = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),2,',')>
                    <cfset spect_main_id___ = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),5,',')>
                     <cfquery name="GET_SPECT" datasource="#DSN3#">
                        <cfif len(spect_id) and spect_id gt 0>
                             SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = #spect_id#
                        <cfelse>
                            SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME  FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #spect_main_id___#
                        </cfif>
                      </cfquery>
                      <cfset spec_var_name=GET_SPECT.SPECT_VAR_NAME>
                      <cfset production_level = 0><!--- Ana ürün 0.cı kırılım. --->
                      <cfset production_step = 0><!--- Üretim adımı --->
                <cfelse><!--- Ana Ürün değilse main_spect'id'yi kullanarak yeni bir spect oluşturuyoruz! --->
                    <cfset spect_main_id___ = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),2,',')>
                    <cfif  spect_main_id___ eq 0><!--- SpectMainID değeri 0dan büyüksa,yani ürün üretilen bir ürün olduğu halde eğerki ağaçta spect seçilmemiş ise burda o ürün için ağacındaki varsayılan MAIN spect değerini alıcaz. --->
                        <cfscript>
                            create_spect_from_product_tree = get_main_spect_id(production_stock_id);
                            if(len(create_spect_from_product_tree.SPECT_MAIN_ID))
                                spect_main_id___ = create_spect_from_product_tree.SPECT_MAIN_ID;
                        </cfscript> 
                    </cfif>
                    <cfif spect_main_id___ gt 0><!--- Bir üst satırda yapılan eşleştirmeye rağmen  spect_main_id hala 0 ise bu şu anlama geliyor;ÜrünDetayında üretiliyor seçilmiş fakat,ürünün bir ağacı yok yada var ancak ağacı varyasyonlanmamış --->
                        <cfquery name="get_spec_main_name" datasource="#dsn3#">
                            SELECT SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #spect_main_id___#
                        </cfquery>
                        <cfset spec_var_name = get_spec_main_name.SPECT_MAIN_NAME> 
                        <cfset production_level = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),3,',')><!--- Diğer ürünlerin ağaçta kaçıncı kırılım olduğu --->
                        <cfset production_step = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),4,',')><!--- Üretimin kaçıncı adımda olduğunu alıyoruz,bu değişken silinmesin,verilen üretim emirlerini kontrol ederken kullanlılıyor. --->
                    </cfif>            
                </cfif>
                <cfif sayac eq 0 or spect_main_id___ gt 0><!--- Ana Ürünse veya sarf ürünlerde spect seçilmiş ürünler ise --->
                    <cfset quantity = Evaluate('attributes.product_amount_#prod_ind#_#sayac#')>
                    <cfset ____po_related_id____ =''>
                    <!--- bu if manuel olarak en fazla 10 kırılım olabileceği düşünelerak yazıldı muhtemelen bundan fazlasıda olmaz,bunun için bir fonksiyon yerine manuel yazmak daha kolay olduğu için böle yazıldı..İlerde fonksiyon ilede halledilebilir. Ayrıca yukarıda üretim emirlerinin zamanlarını hesaplama kısmıda düzenlenmeli buraya göre......--->
                    <cfif production_level gt 0>
                        <cfif production_level gte 1 and isdefined('po_related_id_#prod_ind#_#production_level-1#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-1#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-1#')>
                        <cfelseif production_level gte 2 and isdefined('po_related_id_#prod_ind#_#production_level-2#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-2#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-2#')>
                        <cfelseif production_level gte 3 and isdefined('po_related_id_#prod_ind#_#production_level-3#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-3#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-3#')>
                        <cfelseif production_level gte 4 and isdefined('po_related_id_#prod_ind#_#production_level-4#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-4#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-4#')>
                        <cfelseif production_level gte 5 and isdefined('po_related_id_#prod_ind#_#production_level-5#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-5#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-5#')>
                        <cfelseif production_level gte 6 and isdefined('po_related_id_#prod_ind#_#production_level-6#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-6#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-6#')>
                        <cfelseif production_level gte 7 and isdefined('po_related_id_#prod_ind#_#production_level-7#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-7#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-7#')>
                        <cfelseif production_level gte 8 and isdefined('po_related_id_#prod_ind#_#production_level-8#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-8#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-8#')>
                        <cfelseif production_level gte 9 and isdefined('po_related_id_#prod_ind#_#production_level-9#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-9#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-9#')>
                        <cfelseif production_level gte 10 and isdefined('po_related_id_#prod_ind#_#production_level-10#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-10#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-10#')>
                        <cfelseif production_level gte 11 and isdefined('po_related_id_#prod_ind#_#production_level-11#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-11#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-11#')>
                        <cfelseif production_level gte 12 and isdefined('po_related_id_#prod_ind#_#production_level-12#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-12#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-12#')>
                        <cfelseif production_level gte 13 and isdefined('po_related_id_#prod_ind#_#production_level-13#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-13#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-13#')>
                        <cfelseif production_level gte 14 and isdefined('po_related_id_#prod_ind#_#production_level-14#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-14#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-14#')>
                        <cfelseif production_level gte 15 and isdefined('po_related_id_#prod_ind#_#production_level-15#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-15#'))>
                            <cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-15#')>
                        </cfif>
                    </cfif>
					<cfif len(spect_main_id___)>
                        <!---<cfquery name="get_tree_operations" datasource="#dsn3#">
                            SELECT STOCK_ID,OPERATION_TYPE_ID,IS_PROPERTY,AMOUNT FROM SPECT_MAIN_ROW WHERE STOCK_ID IS NULL AND SPECT_MAIN_ID = #spect_main_id___# AND IS_PROPERTY IN (0,3,4)
                        </cfquery>--->
						
						<cfquery name="get_tree_operations" datasource="#dsn3#">
									select NULL AS STOCK_ID,OPERATION_TYPE_ID,3 IS_PROPERTY,1 AMOUNT FROM OPERATION_TYPES 
									<!---WHERE OPERATION_TYPE_ID IN(#listgetat(Evaluate('attributes.op_id_#prod_ind#'),1,',')#)---><!---kardelen tekstil için bu koşul--->
								</cfquery>
                    </cfif>
                    <cfif isdefined('attributes.station_id_#prod_ind#_#sayac#') and ListLen(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),',') gt 5>
						<cfset  _EXIT_DEP_ID=ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),6,',')>
                        <cfset  _EXIT_LOC_ID=ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),7,',')>
                        <cfset  _PRODUCTION_DEP_ID=ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),8,',')>
                        <cfset  _PRODUCTION_LOC_ID=  ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),9,',')>
					<cfelse>
						<cfset  _EXIT_DEP_ID=''>
                        <cfset  _EXIT_LOC_ID=''>
                        <cfset  _PRODUCTION_DEP_ID=''>
                        <cfset  _PRODUCTION_LOC_ID= ''>
                    </cfif>
					<cfset wrk_id_new = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#'>
                  
                    <cfstoredproc procedure="TEXTILE_ADD_PRODUCTION_ORDER" datasource="#dsn3#">
						<cfif production_level eq 0 and isdefined('attributes.po_related_id_main') and len(attributes.po_related_id_main)><!--- Bir üretimin detayından ilişkili bir üretim ekleniyorsa --->
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.po_related_id_main#">
                        <cfelseif len(____po_related_id____)><!--- Verilen Üretim emrinde seçilen ürünün ağacında bulunan üretilen ürünler için siparişi verilen ürün ile ilgili bağlantıları kuruyoruz. --->
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#____po_related_id____#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#production_stock_id#">
                        <cfprocparam cfsqltype="cf_sql_float" value="#quantity#">
                        <cfif isdefined('attributes.is_time_calculation') and attributes.is_time_calculation eq 0 and isdate(attributes.party_start_date)>
                        	<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.party_start_date#">
                        <cfelseif isdefined('startdate_fn_#prod_ind#_#sayac#')>    
                        	<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('startdate_fn_#prod_ind#_#sayac#')#">
                        <cfelseif isdefined('startdate_fn_1_0')>    
                        	<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('startdate_fn_1_0')#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">    
                        </cfif>
                        <cfif isdefined('attributes.is_time_calculation') and attributes.is_time_calculation eq 0 and isdate(attributes.deliver_date)>
                        	<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date#">
                        <cfelseif isdefined('finishdate_fn_#prod_ind#_#sayac#')>    
                        	<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('finishdate_fn_#prod_ind#_#sayac#')#">
                        <cfelseif isdefined('finishdate_fn_1_0')>    
                        	<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('finishdate_fn_1_0')#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                        </cfif>
                        <cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                        <cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfif isdefined('attributes.project_id') and len(attributes.project_id)>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#system_paper_no#">
                        <cfif isdefined('attributes.detail')>
                        	<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                        </cfif>
                        <cfif isdefined("attributes.process_stage")>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfif isdefined('attributes.station_id_#prod_ind#_#sayac#') and len(ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),1,',')) and ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),1,',') gt 0>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),1,',')#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfif len(spect_id) and spect_id gt 0 and sayac eq 0>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#spect_id#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif><!--- Sadece Ana Ürün için spect_var_id oluşturuyoruz. --->
                        <cfif isdefined("spec_var_name") and len(spec_var_name)>
                        	<cfprocparam cfsqltype="cf_sql_varchar" value="#spec_var_name#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                        </cfif>
                        <cfif isdefined('attributes.stock_reserved')>
                        	<cfprocparam cfsqltype="cf_sql_bit" value="#attributes.stock_reserved#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_bit" value="0">
                        </cfif>
                        <cfif isdefined('attributes.is_demontaj') and attributes.is_demontaj eq 1>
                        	<cfprocparam cfsqltype="cf_sql_bit" value="#attributes.is_demontaj#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_bit" value="0">
                        </cfif>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#lot_system_paper_no#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#production_step#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#spect_main_id___#">
                        <cfif attributes.is_operator_display eq 1 and attributes.is_stage eq 4>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="0">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.is_stage#">
                        </cfif>
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_id_new#">
                        <cfif isdefined('attributes.demand_no') and len(attributes.demand_no)>
                        	<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.demand_no#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                        </cfif>
                        <cfif len(_EXIT_DEP_ID) and _EXIT_DEP_ID gt 0>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#_EXIT_DEP_ID#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfif len(_EXIT_LOC_ID) and _EXIT_LOC_ID gt 0>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#_EXIT_LOC_ID#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfif len(_PRODUCTION_DEP_ID) and _PRODUCTION_DEP_ID gt 0>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#_PRODUCTION_DEP_ID#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfif len(_PRODUCTION_LOC_ID) and _PRODUCTION_LOC_ID gt 0>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#_PRODUCTION_LOC_ID#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfif isdefined('attributes.work_id') and len(attributes.work_id) and len(attributes.work_head)>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfif isdefined('attributes.wrk_row_relation_id') and len(attributes.wrk_row_relation_id)>
                        	<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.wrk_row_relation_id#">
                        <cfelse>
                        	<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                        </cfif>
								<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.party_id#" >	
                    </cfstoredproc>
               
								
				 
 					<!--- E.A storedprocedure çevirdim 6 aya silinsin 20130221--->
                    <!---<cfquery name="UPD_GEN_PAP" datasource="#dsn3#">
                        UPDATE 
                            GENERAL_PAPERS
                        SET
                            PROD_ORDER_NUMBER = #system_paper_no_add#
                        WHERE
                            PROD_ORDER_NUMBER IS NOT NULL
                    </cfquery>---> 
                    
                    <cfstoredproc procedure="UPD_GENERAL_PAPERS_PROD_ORDER_NUMBER" datasource="#dsn3#">
                    	<cfprocparam cfsqltype="cf_sql_integer" value="#system_paper_no_add#">
                    </cfstoredproc>
                    <!---E.A storedprocedure çevirdim 6 aya silinsin 20130221--->                
                    <!---<cfquery name="GET_MAX" datasource="#dsn3#">
                        SELECT
                            P_ORDER_ID PID,
							IS_DEMONTAJ,
							QUANTITY AMOUNT
                        FROM
                            PRODUCTION_ORDERS
						WHERE
							WRK_ROW_ID = '#wrk_id_new#'
                    </cfquery>--->
                    <cfstoredproc procedure="GET_PRODUCTION_ORDER_MAX" datasource="#dsn3#">
                    	<cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_id_new#">
                        <cfprocresult name="GET_MAX">
                    </cfstoredproc>
                    
                    
					<cfif production_level gte 0>
						<cfset 'po_related_id_#prod_ind#_#production_level#' = GET_MAX.PID >
					</cfif>
					<cfset product_tree_id_list = ''>
					<cfset operation_type_id_list = ''>
					<cfset amount_list = ''>
                    <cfset deep_level_list = ''>
                 
					<cfscript>
						//writeoutput("deep_level_op:#attributes.deep_level_op#<br>");
						writeTree_operation(production_stock_id,0,0,0);
					</cfscript>
					<cfif len(product_tree_id_list)>
						
						<cfloop query="get_tree_operations">
							<cfset _OPERATION_TYPE_ID_ = get_tree_operations.OPERATION_TYPE_ID>
							<cfset _AMOUNT_ = get_tree_operations.AMOUNT>
							<cfset _DEEP_LEVEL_ =0> <!---evaluate("deep_level_#_OPERATION_TYPE_ID_#")>--->
							<!---E.A stored procedure çevirdim 6 aya silinsin 20130221--->
							<!---<cfquery name="GET_OPERATIONS_STATIONS" datasource="#DSN3#">
								SELECT 
									WS_ID AS STATION_ID,
									OPERATION_TYPE_ID,
									PRODUCTION_TIME 
								FROM
									WORKSTATIONS_PRODUCTS 
								WHERE 
									OPERATION_TYPE_ID = #_OPERATION_TYPE_ID_#  
									AND MAIN_STOCK_ID = #production_stock_id#
							</cfquery>--->
							
                            <cfstoredproc procedure="GET_WORKSTATIONS_PRODUCTS" datasource="#dsn3#">
                            	<cfprocparam cfsqltype="cf_sql_integer" value="#_OPERATION_TYPE_ID_#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#production_stock_id#">
                                <cfprocresult name="GET_OPERATIONS_STATIONS">
                            </cfstoredproc>
							<!---E.A stored procedure çevirdim 6 aya silinsin 20130221--->
							
							
							<cfif prod_ind eq 1 and sayac eq 0>
							<cfquery name="add_operations" datasource="#dsn3#">
								INSERT INTO 
									PRODUCTION_OPERATION_MAIN
									(
										PARTY_ID,
										STATION_ID,
										O_MINUTE,
										OPERATION_TYPE_ID,
										AMOUNT,
										RECORD_EMP,
										RECORD_DATE,
										RECORD_IP,
										STAGE,
										DEEP_LEVEL
									)
									VALUES
									(
										#attributes.party_id#,	
										<cfif GET_OPERATIONS_STATIONS.recordcount>#GET_OPERATIONS_STATIONS.STATION_ID#<cfelse>NULL</cfif>,
										<cfif GET_OPERATIONS_STATIONS.recordcount>#GET_OPERATIONS_STATIONS.PRODUCTION_TIME#<cfelse>NULL</cfif>,
										#get_tree_operations.OPERATION_TYPE_ID#,
										#get_tree_operations.AMOUNT*quantity#,
										#session.ep.userid#,
										#now()#,
										'#CGI.REMOTE_ADDR#',
										0,
										0
									)
							</cfquery>
						
						</cfif>
							
							<cfstoredproc procedure="ADD_PRODUCTION_OPERATION" datasource="#dsn3#">	
                                <cfprocparam cfsqltype="cf_sql_integer" value="#GET_MAX.PID#">	
                                <cfif GET_OPERATIONS_STATIONS.recordcount>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="#GET_OPERATIONS_STATIONS.STATION_ID#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                                </cfif>
                                <cfif GET_OPERATIONS_STATIONS.recordcount>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#GET_OPERATIONS_STATIONS.PRODUCTION_TIME#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_integer" value="#_OPERATION_TYPE_ID_#">
                                <cfprocparam cfsqltype="cf_sql_float" value="#_AMOUNT_*quantity#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                <cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="0">
                                <!---<cfprocparam cfsqltype="cf_sql_integer" value="#_DEEP_LEVEL_#">--->
							</cfstoredproc>
                        </cfloop>
                    </cfif>
					<cfif not isdefined("attributes.kontrol_order_#prod_ind#")><cfset "attributes.kontrol_order_#prod_ind#" = 1></cfif>
					<cfloop from="1" to="#listlen(Evaluate('attributes.order_row_id_#prod_ind#'),',')#" index="i">
						<cfif len(Evaluate('attributes.order_row_id_#prod_ind#')) and Evaluate('attributes.order_row_id_#prod_ind#') gt 0 and evaluate("attributes.kontrol_order_#prod_ind#") eq 1>
							<!---E.A stored procedure çevirdim 6 aya silinsin 20130221--->
							<!---<cfquery name="ADD_ROW" datasource="#DSN3#">
								INSERT INTO
									PRODUCTION_ORDERS_ROW
								(
									PRODUCTION_ORDER_ID,
									ORDER_ID,
									ORDER_ROW_ID,
									TYPE<!--- 0 İSE TALEP 1 İSE ÜRETİM... --->
								)
								VALUES
								(
									#get_max.pid#,
									#listgetat(Evaluate('attributes.order_id_#prod_ind#'),i,',')#,
									#listgetat(Evaluate('attributes.order_row_id_#prod_ind#'),i,',')#,
									<cfif attributes.is_stage eq -1>0<cfelse>1</cfif>
								)
							</cfquery>--->
                             <cfstoredproc procedure="TEXTILE_ADD_PRODUCTION_ORDERS_ROW" datasource="#DSN3#">
                             	<cfprocparam cfsqltype="cf_sql_integer" value="#get_max.pid#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#listgetat(Evaluate('attributes.order_id_#prod_ind#'),i,',')#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#listgetat(Evaluate('attributes.order_row_id_#prod_ind#'),i,',')#">
                                <cfif attributes.is_stage eq -1>
                                	<cfprocparam cfsqltype="cf_sql_integer" value="0">
								<cfelse>
                                	<cfprocparam cfsqltype="cf_sql_integer" value="1">
								</cfif>   
								<cfprocparam cfsqltype="cf_sql_integer" value="#listgetat(Evaluate('attributes.op_id_#prod_ind#'),i,',')#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.plan_id#">
                             </cfstoredproc>
						</cfif>
					</cfloop>
					<!--- üretim emrine sarf ekleniyor --->
					<cfparam name="phantom_stock_id_list" default="0">
					<cfparam name="phantom_spec_main_id_list" default="0">
					<cfset phantom_stock_id_list = ''>
					<cfset phantom_spec_main_id_list = ''>
					<cfset main_product_spec_main_id = spect_main_id___>
					<cfif isdefined("main_product_spec_main_id") and main_product_spec_main_id gt 0>
						<cfscript>
							writeTree_order(main_product_spec_main_id,1);
						</cfscript>
					</cfif>
					<cfquery name="get_sub_product" datasource="#dsn3#">
						SELECT
							SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
							SPECT_MAIN_ROW.AMOUNT AS AMOUNT, 
							ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
							STOCKS.PRODUCT_ID,
							STOCKS.STOCK_ID,
							PRODUCT_UNIT.PRODUCT_UNIT_ID,
							0 IS_PHANTOM,
							SPECT_MAIN_ROW.IS_SEVK,
							SPECT_MAIN_ROW.IS_PROPERTY,
							ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
							ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
							0 AS SUB_SPEC_MAIN_ID,
							SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
							 ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
                            ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) MAIN_LINE_NUMBER,
                            '' AS LOT_NO
						FROM
							SPECT_MAIN,
							SPECT_MAIN_ROW,
							STOCKS,
							PRODUCT_UNIT,
							PRICE_STANDART,
					        TEXTILE_SR_SUPLIERS
						WHERE
							PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
							PRICE_STANDART.PURCHASESALES = 1 AND
							PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
							STOCKS.STOCK_STATUS = 1	AND
                            TEXTILE_SR_SUPLIERS.STOCK_ID=SPECT_MAIN_ROW.STOCK_ID AND 
                            TEXTILE_SR_SUPLIERS.OPERATION_ID=#attributes.operation_type_id# AND
                            TEXTILE_SR_SUPLIERS.REQ_ID=#attributes.req_id# AND
							SPECT_MAIN.SPECT_MAIN_ID = #spect_main_id___# AND
							SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
							SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
							SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
							ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
							STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID AND
							STOCKS.STOCK_ID NOT IN (0)
							<cfif len(phantom_stock_id_list)><!--- FANTOM ÜRÜNLERİ SARF LİSTESİNDEN ÇIKARIYORUZ.AŞAĞIDA FHANTOMLARIN SPECLERİNDEN FAYDALANARAK BU ÇIKARTTIĞIMIZ ÜRÜNÜN BİLEŞENLERİNİ DAHİL EDİCEZ.. --->
								AND STOCKS.STOCK_ID NOT IN (#phantom_stock_id_list#)
							</cfif>
						UNION ALL
						SELECT
							SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
							SPECT_MAIN_ROW.AMOUNT AS AMOUNT, 
							ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
							STOCKS.PRODUCT_ID,
							STOCKS.STOCK_ID,
							PRODUCT_UNIT.PRODUCT_UNIT_ID,
							0 IS_PHANTOM,
							SPECT_MAIN_ROW.IS_SEVK,
							SPECT_MAIN_ROW.IS_PROPERTY,
							ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
							ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
							0 AS SUB_SPEC_MAIN_ID,
							SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
							 ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
                            ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) MAIN_LINE_NUMBER,
                            '' AS LOT_NO
						FROM
							SPECT_MAIN,
							SPECT_MAIN_ROW,
							STOCKS,
							PRODUCT_UNIT,
							PRICE_STANDART,
					        TEXTILE_SR_PROCESS
						WHERE
							PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
							PRICE_STANDART.PURCHASESALES = 1 AND
							PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
							STOCKS.STOCK_STATUS = 1	AND
                            TEXTILE_SR_PROCESS.STOCK_ID=SPECT_MAIN_ROW.STOCK_ID AND 
                            TEXTILE_SR_PROCESS.OPERATION_ID=#attributes.operation_type_id# AND
                            TEXTILE_SR_PROCESS.REQUEST_ID=#attributes.req_id# AND
							SPECT_MAIN.SPECT_MAIN_ID = #spect_main_id___# AND
							SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
							SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
							SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
							ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
							STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID AND
							STOCKS.STOCK_ID NOT IN (0)
							<cfif len(phantom_stock_id_list)><!--- FANTOM ÜRÜNLERİ SARF LİSTESİNDEN ÇIKARIYORUZ.AŞAĞIDA FHANTOMLARIN SPECLERİNDEN FAYDALANARAK BU ÇIKARTTIĞIMIZ ÜRÜNÜN BİLEŞENLERİNİ DAHİL EDİCEZ.. --->
								AND STOCKS.STOCK_ID NOT IN (#phantom_stock_id_list#)
							</cfif>
						<cfif phantom_spec_main_id_list gt 0><!--- eğer phantom ürün var ise... --->
							UNION ALL
								SELECT
									SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
									SPECT_MAIN_ROW.AMOUNT AS AMOUNT, 
									ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
									STOCKS.PRODUCT_ID,
									STOCKS.STOCK_ID,
									PRODUCT_UNIT.PRODUCT_UNIT_ID,
									1 IS_PHANTOM,
									SPECT_MAIN_ROW.IS_SEVK,
									SPECT_MAIN_ROW.IS_PROPERTY,
									ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
									ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
									SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
									SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
                                    '' AS LOT_NO
								FROM
									SPECT_MAIN,
									SPECT_MAIN_ROW,
									STOCKS,
									PRODUCT_UNIT,
									PRICE_STANDART,
					                TEXTILE_SR_SUPLIERS
								WHERE
									PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
									PRICE_STANDART.PURCHASESALES = 1 AND
									PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
									STOCKS.STOCK_STATUS = 1	AND
                                    TEXTILE_SR_SUPLIERS.STOCK_ID=SPECT_MAIN_ROW.STOCK_ID AND 
                                    TEXTILE_SR_SUPLIERS.OPERATION_ID=#attributes.operation_type_id# AND
                                    TEXTILE_SR_SUPLIERS.REQ_ID=#attributes.req_id# AND
									SPECT_MAIN.SPECT_MAIN_ID IN (#phantom_spec_main_id_list#) AND
									SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
									SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
									SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
									ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
									<cfif get_max.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
									PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
									STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
                        </cfif>
                        <cfif len(attributes.previous_operation_type_id) and attributes.previous_operation_type_id neq attributes.operation_type_id>
                        UNION ALL
                        select 
                                PRODUCTION_ORDERS.SPEC_MAIN_ID RELATED_MAIN_SPECT_ID,
							    PRODUCTION_ORDERS.QUANTITY AMOUNT, 
							    1 AS IS_FREE_AMOUNT,
                                ISNULL(ORDER_ROW.PRODUCT_ID,0) PRODUCT_ID,
                                ISNULL(ORDER_ROW.STOCK_ID,0) STOCK_ID,
                                ISNULL(ORDER_ROW.UNIT_ID,0) PRODUCT_UNIT_ID,
                                1 IS_PHANTOM,
								1 IS_SEVK,
								99 IS_PROPERTY,
								0 FIRE_AMOUNT,
								0 FIRE_RATE,
								0  AS SUB_SPEC_MAIN_ID,
								0 SPECT_MAIN_ROW_ID,
                                1 LINE_NUMBER,
                                1 MAIN_LINE_NUMBER,
                                PRODUCTION_ORDERS.LOT_NO
                            from 
                                PRODUCTION_ORDERS_ROW,
                                PRODUCTION_ORDERS,
								ORDER_ROW
                                <!---JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1--->
                            where
                                PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
								AND ORDER_ROW.ORDER_ROW_ID=PRODUCTION_ORDERS_ROW.ORDER_ROW_ID
                                AND PRODUCTION_ORDERS_ROW.ORDER_ROW_ID=#order_row_id#
                                AND PRODUCTION_ORDERS_ROW.OP_ID=#attributes.previous_operation_type_id#
                                AND PRODUCTION_ORDERS_ROW.ORDER_ID=#ORDER_ID#
                        </cfif>
					</cfquery>
             <!---  <cfdump var="#get_sub_product#"><cfabort>--->
             <cfquery name="get_prev_op" dbtype="query">
                 select * from get_sub_product where IS_PROPERTY=99
             </cfquery>
			 
             <cfif len(attributes.previous_operation_type_id) and attributes.previous_operation_type_id neq attributes.operation_type_id and get_prev_op.recordCount eq 0>
                <div class="col-6 col-md-4">
                    <div class="alert alert-warning" role="alert">
                        <img src="images/warning.gif"> <br/>Önceki operasyonda sonlandırma yapılmadan işlem yapılamaz! <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=textile.product_plan&event=add_tree&pid=#product_id#&req_id=#attributes.req_id#&operation_type_id=#attributes.operation_type_id#</cfoutput>','page');" class="alert-link">(Operasyon:<cfoutput><b>#attributes.operation_type#</b> Stok Adı : <b>#product_name# #property#</b> Stok Id:<b>#stock_id#</b></cfoutput></a>)
                    </div>
                 </div>
                <cftransaction action="rollback" /> 
                <cfabort>

             </cfif>
             <cfif get_sub_product.recordcount eq 0>    
                <div class="col-6 col-md-4">
                        <div class="alert alert-warning" role="alert">
                            <img src="images/warning.gif"> <br/>Üretim ağacı olmayan stoklar var kontrol ediniz! <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=textile.product_plan&event=add_tree&pid=#product_id#&req_id=#attributes.req_id#&operation_type_id=#attributes.operation_type_id#</cfoutput>','page');" class="alert-link">(Operasyon:<cfoutput><b>#attributes.operation_type#</b> Stok Adı : <b>#product_name# #property#</b> Stok Id:<b>#stock_id#</b></cfoutput></a>)
                        </div>
                </div>
                    <cftransaction action="rollback" /> 
                    <cfabort>
            </cfif>

						<cfoutput query="get_sub_product">
							<cfset _AMOUNT_ = AMOUNT>
							<cfif isdefined('multipler_#SUB_SPEC_MAIN_ID#')>
								<cfset _AMOUNT_ =  Evaluate('multipler_#SUB_SPEC_MAIN_ID#')*AMOUNT>
							</cfif>
							<!--- <cfif get_max.is_demontaj eq 1>
								<cfset amount_ = get_max.AMOUNT>
							<cfelse> --->
								<cfif is_free_amount eq 1>
									<cfset amount_ = _AMOUNT_>
								<cfelse>
									<cfset amount_ = _AMOUNT_ * get_max.AMOUNT>
								</cfif>
							<!--- </cfif> --->
							<cfset wrk_id_new_sarf = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#U#get_max.pid#S#STOCK_ID#'>
							<!---E.A stored procedure çevirdim 6 aya silinsin 20130221--->
							<!---<cfquery name="add_sarf" datasource="#dsn3#">
								INSERT INTO
									PRODUCTION_ORDERS_STOCKS
								(
									P_ORDER_ID,
									PRODUCT_ID,
									STOCK_ID,
									SPECT_MAIN_ID,
									AMOUNT,
									TYPE,
									PRODUCT_UNIT_ID,
									RECORD_EMP,
									RECORD_DATE,
									RECORD_IP,
									IS_PHANTOM,
									IS_SEVK,
									IS_PROPERTY,
									IS_FREE_AMOUNT,
									FIRE_AMOUNT,
									FIRE_RATE,
									SPECT_MAIN_ROW_ID,
									IS_FLAG,
									WRK_ROW_ID
								)
								VALUES
								(
									#get_max.pid#,
									#PRODUCT_ID#,
									#STOCK_ID#,
									<cfif len(RELATED_MAIN_SPECT_ID)>#RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
									#amount_#,
									2,
									#PRODUCT_UNIT_ID#,
									#session.ep.userid#,
									#now()#,
									'#CGI.REMOTE_ADDR#',
									#IS_PHANTOM#,
									#IS_SEVK#,
									#IS_PROPERTY#,
									#IS_FREE_AMOUNT#,
									#FIRE_AMOUNT#,
									#FIRE_RATE#,
									#SPECT_MAIN_ROW_ID#,
									1,
									'#wrk_id_new_sarf#'
								)
							</cfquery>--->
                            <cfstoredproc procedure="TEXTILE_ADD_PRODUCTION_ORDERS_STOCKS" datasource="#dsn3#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#get_max.pid#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
                                <cfif len(RELATED_MAIN_SPECT_ID)>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="#RELATED_MAIN_SPECT_ID#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_float" value="#amount_#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="2">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#PRODUCT_UNIT_ID#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                <cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                                <cfprocparam cfsqltype="cf_sql_bit" value="#IS_PHANTOM#">
                                <cfprocparam cfsqltype="cf_sql_bit" value="#IS_SEVK#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#IS_PROPERTY#">
                                <cfprocparam cfsqltype="cf_sql_bit" value="#IS_FREE_AMOUNT#">
                                <cfprocparam cfsqltype="cf_sql_float" value="#FIRE_AMOUNT#">
                                <cfprocparam cfsqltype="cf_sql_float" value="#FIRE_RATE#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ROW_ID#">
                                <cfprocparam cfsqltype="cf_sql_bit" value="1">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_id_new_sarf#">
                                  <cfprocparam cfsqltype="cf_sql_integer" value="#MAIN_LINE_NUMBER#">
                                  <cfprocparam cfsqltype="cf_sql_varchar" value="#LOT_NO#">
                            </cfstoredproc>
								
                            	
                        </cfoutput>
                    
					<!--- üretim emrine fire ekleniyor --->
					<!---E.A stored procedure çevirdim 6 aya silinsin 20130221--->
					<!---<cfquery name="get_sub_product_fire" datasource="#dsn3#">
						SELECT
							SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
							CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) <> 0)
							THEN
								SPECT_MAIN_ROW.FIRE_AMOUNT
							ELSE
								CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) <> 0)
								THEN
								SPECT_MAIN_ROW.AMOUNT*SPECT_MAIN_ROW.FIRE_RATE/100
								ELSE
								SPECT_MAIN_ROW.AMOUNT
								END
							END AS AMOUNT ,
							ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
							STOCKS.PRODUCT_ID,
							STOCKS.STOCK_ID,
							PRODUCT_UNIT.PRODUCT_UNIT_ID,
							SPECT_MAIN_ROW.IS_SEVK,
							SPECT_MAIN_ROW.IS_PROPERTY,
							ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
							ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
							SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID
						FROM
							SPECT_MAIN,
							SPECT_MAIN_ROW,
							STOCKS,
							PRODUCT_UNIT,
							PRICE_STANDART
						WHERE
							PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
							PRICE_STANDART.PURCHASESALES = 1 AND
							PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
							STOCKS.STOCK_STATUS = 1	AND
							ISNULL(IS_PHANTOM,0) = 0 AND
							SPECT_MAIN.SPECT_MAIN_ID = #spect_main_id___# AND
							SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
							SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
							(ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0)  AND
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
							STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
					</cfquery>--->
					<cfquery name="GET_SUB_PRODUCT_FIRE" datasource="#dsn3#">
                    	SELECT
                                SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
                                CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) <> 0)
                                THEN
                                    SPECT_MAIN_ROW.FIRE_AMOUNT
                                ELSE
                                    CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) <> 0)
                                    THEN
                                    SPECT_MAIN_ROW.AMOUNT*SPECT_MAIN_ROW.FIRE_RATE/100
                                    ELSE
                                    SPECT_MAIN_ROW.AMOUNT
                                    END
                                END AS AMOUNT ,
                                ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
                                STOCKS.PRODUCT_ID,
                                STOCKS.STOCK_ID,
                                PRODUCT_UNIT.PRODUCT_UNIT_ID,
                                0 AS IS_PHANTOM,
                                SPECT_MAIN_ROW.IS_SEVK,
                                SPECT_MAIN_ROW.IS_PROPERTY,
                                ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
                                ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
                                SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,
                                SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
                                SPECT_MAIN_ROW.LINE_NUMBER,
                                ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) MAIN_LINE_NUMBER
                            FROM
                                SPECT_MAIN,
                                SPECT_MAIN_ROW,
                                STOCKS,
                                PRODUCT_UNIT,
                                PRICE_STANDART
                            WHERE
                                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                                PRICE_STANDART.PURCHASESALES = 1 AND
                                PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                                STOCKS.STOCK_STATUS = 1	AND
                                ISNULL(IS_PHANTOM,0) = 0 AND
                                SPECT_MAIN.SPECT_MAIN_ID = #spect_main_id___# AND
                                SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                                SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                                (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0)  AND
                                PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                                STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
                                <cfif len(phantom_stock_id_list)><!--- FANTOM ÜRÜNLERİ SARF LİSTESİNDEN ÇIKARIYORUZ.AŞAĞIDA FHANTOMLARIN SPECLERİNDEN FAYDALANARAK BU ÇIKARTTIĞIMIZ ÜRÜNÜN BİLEŞENLERİNİ DAHİL EDİCEZ.. --->
								AND STOCKS.STOCK_ID NOT IN (#phantom_stock_id_list#)
							</cfif>
                                <cfif phantom_spec_main_id_list gt 0><!--- eğer phantom ürün var ise... --->
                        	<cfif isdefined('phantom_line_number_list') and len(phantom_line_number_list)><!---**** sira numarasina gore sarflar listelenmek istendiginde fantom urunlerin siralari karisikliga yol aciyordu. Sıra numaralarına gore loop yaparak bir ust sira numarasini tutmak icin yapıldı.  --->
                            	<cfloop from="1" to="#listlen(phantom_line_number_list)#" index="ln">
                                    UNION ALL
                                        SELECT
                                            SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
                                             CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) <> 0)
                                            THEN
                                                SPECT_MAIN_ROW.FIRE_AMOUNT
                                            ELSE
                                                CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) <> 0)
                                                THEN
                                                SPECT_MAIN_ROW.AMOUNT*SPECT_MAIN_ROW.FIRE_RATE/100
                                                ELSE
                                                SPECT_MAIN_ROW.AMOUNT
                                                END
                                            END AS AMOUNT ,
                                            ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
                                            STOCKS.PRODUCT_ID,
                                            STOCKS.STOCK_ID,
                                            PRODUCT_UNIT.PRODUCT_UNIT_ID,
                                            1 IS_PHANTOM,
                                            SPECT_MAIN_ROW.IS_SEVK,
                                            SPECT_MAIN_ROW.IS_PROPERTY,
                                            ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
                                            ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
                                            SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
                                            SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
                                            ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
                            				#listgetat(phantom_line_number_list,ln)# MAIN_LINE_NUMBER<!--- SARFIN BAGLI OLDUGU URUNUN SIRA NUMARASINI GETIRIYORUZ. FANTOM URUNLERIN SIRAYI BOZMAMASI ICIN GEREKIYOR. --->
                                        FROM
                                            SPECT_MAIN,
                                            SPECT_MAIN_ROW,
                                            STOCKS,
                                            PRODUCT_UNIT,
                                            PRICE_STANDART
                                        WHERE
                                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                                            PRICE_STANDART.PURCHASESALES = 1 AND
                                            PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                                            STOCKS.STOCK_STATUS = 1	AND
                                            SPECT_MAIN.SPECT_MAIN_ID IN (#listgetat(phantom_spec_main_id_list,ln)#) AND
                                            SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                                            SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                                            SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
                                            (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0)  AND
                                            ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
                                            <cfif get_max.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
                                            PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                                            STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
                                </cfloop>
                            <cfelse>
                                UNION ALL
                                    SELECT
                                        SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
                                         CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) <> 0)
                                        THEN
                                            SPECT_MAIN_ROW.FIRE_AMOUNT
                                        ELSE
                                            CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) <> 0)
                                            THEN
                                            SPECT_MAIN_ROW.AMOUNT*SPECT_MAIN_ROW.FIRE_RATE/100
                                            ELSE
                                            SPECT_MAIN_ROW.AMOUNT
                                            END
                                        END AS AMOUNT ,
                                        ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
                                        STOCKS.PRODUCT_ID,
                                        STOCKS.STOCK_ID,
                                        PRODUCT_UNIT.PRODUCT_UNIT_ID,
                                        1 IS_PHANTOM,
                                        SPECT_MAIN_ROW.IS_SEVK,
                                        SPECT_MAIN_ROW.IS_PROPERTY,
                                        ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
                                        ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
                                        SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
                                        SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
                                        ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
                                        ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) MAIN_LINE_NUMBER
                                    FROM
                                        SPECT_MAIN,
                                        SPECT_MAIN_ROW,
                                        STOCKS,
                                        PRODUCT_UNIT,
                                        PRICE_STANDART
                                    WHERE
                                        PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                                        PRICE_STANDART.PURCHASESALES = 1 AND
                                        PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                                        STOCKS.STOCK_STATUS = 1	AND
                                        SPECT_MAIN.SPECT_MAIN_ID IN (#phantom_spec_main_id_list#) AND
                                        SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                                        SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                                        (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0)  AND
                                        SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
                                        ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
                                        <cfif get_max.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
                                        PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                                        STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
                            </cfif>
						</cfif>
                    </cfquery>
                    <!---<cfstoredproc procedure="GET_SUB_PRODUCT_FIRE" datasource="#dsn3#">
                    	<cfprocparam cfsqltype="cf_sql_integer" value="#spect_main_id___#">
                        <cfprocresult name="GET_SUB_PRODUCT_FIRE">
                    </cfstoredproc>--->
					<cfif get_sub_product_fire.recordcount>
						<cfoutput query="get_sub_product_fire">
						<cfset amount_ = AMOUNT * get_max.AMOUNT>
							<cfset wrk_id_new_fire = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#U#get_max.pid#F#STOCK_ID#'>
							<!---E.A stored procedure çevirdim 6 aya silinsin 20130221--->
                            <!---<cfquery name="add_fire" datasource="#dsn3#">
								INSERT INTO
									PRODUCTION_ORDERS_STOCKS
								(
									P_ORDER_ID,
									PRODUCT_ID,
									STOCK_ID,
									SPECT_MAIN_ID,
									AMOUNT,
									TYPE,
									PRODUCT_UNIT_ID,
									RECORD_EMP,
									RECORD_DATE,
									RECORD_IP,
									IS_PHANTOM,
									IS_SEVK,
									IS_PROPERTY,
									IS_FREE_AMOUNT,
									FIRE_AMOUNT,
									FIRE_RATE,
									SPECT_MAIN_ROW_ID,
									IS_FLAG,
									WRK_ROW_ID
								)
								VALUES
								(
									#get_max.pid#,
									#PRODUCT_ID#,
									#STOCK_ID#,
									<cfif len(RELATED_MAIN_SPECT_ID)>#RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
									#amount_#,
									3,
									#PRODUCT_UNIT_ID#,
									#session.ep.userid#,
									#now()#,
									'#CGI.REMOTE_ADDR#',
									0,
									#IS_SEVK#,
									#IS_PROPERTY#,
									#IS_FREE_AMOUNT#,
									#FIRE_AMOUNT#,
									#FIRE_RATE#,
									#SPECT_MAIN_ROW_ID#,
									1,
									'#wrk_id_new_fire#'
								)
							</cfquery>	--->
                            <cfstoredproc procedure="ADD_PRODUCTION_ORDERS_STOCKS" datasource="#dsn3#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#get_max.pid#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
                                <cfif len(RELATED_MAIN_SPECT_ID)>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="#RELATED_MAIN_SPECT_ID#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_float" value="#amount_#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="3">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#PRODUCT_UNIT_ID#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                <cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                                <cfprocparam cfsqltype="cf_sql_bit" value="#0#">
                                <cfprocparam cfsqltype="cf_sql_bit" value="#IS_SEVK#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#IS_PROPERTY#">
                                <cfprocparam cfsqltype="cf_sql_bit" value="#IS_FREE_AMOUNT#">
                                <cfprocparam cfsqltype="cf_sql_float" value="#FIRE_AMOUNT#">
                                <cfprocparam cfsqltype="cf_sql_float" value="#FIRE_RATE#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ROW_ID#">
                                <cfprocparam cfsqltype="cf_sql_bit" value="1">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_id_new_fire#">
                            </cfstoredproc>
						</cfoutput>
					</cfif>
                </cfif>
				 
				<cfif prod_ind eq GET_AMOUNT.recordcount and attributes.production_row_count eq sayac and not isdefined("control_link")>		
					<cfinclude template="upd_related_party.cfm">
				</cfif>
            </cftransaction>
        </cflock>
    </cfif>
</cfloop> 
				 <cfif prod_ind eq GET_AMOUNT.recordcount and not isdefined("control_link")>
						<cfquery name="get_sum_amount" datasource="#dsn3#">
							SELECT SUM(QUANTITY) AMOUNT FROM PRODUCTION_ORDERS WHERE PARTY_ID =#attributes.party_id#
						</cfquery>
						<cfquery name="update" datasource="#dsn3#">
							UPDATE TEXTILE_PRODUCTION_ORDERS_MAIN
							SET AMOUNT=#get_sum_amount.AMOUNT#
							WHERE PARTY_ID =#attributes.party_id#
							
							UPDATE TEXTILE_PRODUCTION_OPERATION_MAIN
							SET AMOUNT=#get_sum_amount.AMOUNT#
							WHERE PARTY_ID =#attributes.party_id#
						</cfquery>	
					  
					  
						 <cfquery name="UPD_GEN_PAP" datasource="#dsn3#">
								UPDATE 
									GENERAL_PAPERS
								SET
                                 PRODUCTION_PARTY_NUMBER = PRODUCTION_PARTY_NUMBER+1
								WHERE PAPER_TYPE IS NULL AND ZONE_TYPE=0
						</cfquery>		
					</cfif>	 
<cfquery name="GET_PAPER" datasource="#dsn3#">
	SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #Evaluate('po_related_id_#prod_ind#_0')#
</cfquery>
<cfif not isdefined("is_import_prod")>
	<cfquery name="GET_PAPER" datasource="#dsn3#">
		SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #Evaluate('po_related_id_#prod_ind#_0')#
	</cfquery>
	<cf_workcube_process
		is_upd='1' 
        data_source='#dsn3#'
		old_process_line='0' 
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_id='#Evaluate('po_related_id_#prod_ind#_0')#'
		action_table='PRODUCTION_ORDERS'
		action_column='P_ORDER_ID'
		action_page='#request.self#?fuseaction=textile.order&event=upd&party_id=#attributes.party_id#' 
		warning_description = 'Üretim Emri : #get_paper.p_order_no#'>
    <cfquery name="DELETE_PRODUCTION_ORDER_CASH" datasource="#DSN3#">
        DELETE FROM PRODUCTION_ORDERS_CASH
    </cfquery>
    <cfif attributes.total_production_product_all eq 1>
       <!--- <cflocation url="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#Evaluate('po_related_id_#prod_ind#_0')#" addtoken="No">--->
	   <cflocation url="#request.self#?fuseaction=textile.order&event=upd&party_id=#attributes.party_id#" addtoken="No">
    <cfelse>
        <cfoutput>
        <cfif  isdefined("attributes.is_demand") and attributes.is_demand eq 1><cfset _keyword_ = 'Talep'><cfelse><cfset _keyword_ = 'Üretim Emri'></cfif>
		 </cfoutput>
                <cfif prod_ind eq GET_AMOUNT.recordcount and not isdefined("control_link")><!--- Bitmiş Demektir.. --->
					<script>
						 <cfoutput>window.location="#request.self#?fuseaction=textile.order&event=upd&party_id=#attributes.party_id#";</cfoutput>
						   
					</script>
                </cfif>
       
    </cfif>
</cfif>