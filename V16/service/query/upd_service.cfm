<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.service_head = replacelist(attributes.service_head,list,list2)>
<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='324.İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=service.list_service</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.service_product") and not len(attributes.service_product) and len(attributes.service_product_serial)>
	<cfquery name="get_seri_product" datasource="#dsn3#" maxrows="1">
		SELECT SGN.STOCK_ID,S.PRODUCT_NAME,S.PRODUCT_ID FROM SERVICE_GUARANTY_NEW SGN,STOCKS S WHERE SGN.STOCK_ID = S.STOCK_ID AND SGN.SERIAL_NO = '#attributes.service_product_serial#' 
	</cfquery>
	<cfif get_seri_product.recordcount>
		<cfset seri_stock_id = get_seri_product.stock_id>
		<cfset seri_product_id = get_seri_product.product_id>
		<cfset seri_product_name = get_seri_product.product_name>
	</cfif>
</cfif>

<cfif isdefined("attributes.apply_date") and isdate(attributes.apply_date) and isdefined("attributes.finish_date1") and isdate(attributes.finish_date1)>
	<cfset FARK=datediff("n",attributes.apply_date,finish_date1)>
</cfif>
<cfif isdefined("attributes.apply_date") and len(attributes.apply_date)>
	<cf_date tarih="attributes.apply_date">
	<cfset attributes.apply_date=date_add("H", attributes.apply_hour - session.ep.time_zone, attributes.apply_date)>
	<cfset attributes.apply_date=date_add("N", attributes.apply_minute,attributes.apply_date)>
</cfif>
<cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>
	<cf_date tarih="attributes.start_date1">
	<cfset attributes.start_date1=date_add("H", attributes.start_hour - session.ep.time_zone,attributes.start_date1)>
	<cfset attributes.start_date1=date_add("N", attributes.start_minute,attributes.start_date1)>
</cfif>
<cfif isdefined("attributes.intervention_date") and len(attributes.intervention_date)>
	<cf_date tarih="attributes.intervention_date">
	<cfset attributes.intervention_date=date_add("H", attributes.intervention_start_hour - session.ep.time_zone,attributes.intervention_date)>
	<cfset attributes.intervention_date=date_add("N", attributes.intervention_start_minute,attributes.intervention_date)>
</cfif>
<cfif isdefined("attributes.finish_date1") and len(attributes.finish_date1)>
	<cf_date tarih="attributes.finish_date1">
	<cfset attributes.finish_date1=date_add("H", attributes.finish_hour - session.ep.time_zone, attributes.finish_date1)>
	<cfset attributes.finish_date1=date_add("N",attributes.finish_minute,attributes.finish_date1)>
</cfif>
<cfif isdefined("attributes.guaranty_start_date") and len(attributes.guaranty_start_date)>
	<cf_date tarih="attributes.guaranty_start_date">
</cfif>
<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
	<cfquery name="get_system" datasource="#dsn3#">
		SELECT TOP 1 SC.* FROM SUBSCRIPTION_CONTRACT SC WHERE SC.SUBSCRIPTION_ID = #attributes.subscription_id#
	</cfquery>
	<cfif get_system.recordcount and get_system.valid_days gte 1><!--- sistem var mi --->
		<cfset count_type_ = get_system.valid_days>
		<cfset deger_tarih_ilk_ = attributes.start_date1><!--- now() --->
		<cfset deger_tarih_ = date_add("h",session.ep.time_zone,deger_tarih_ilk_)>
		<cfset deger_saat_ = timeformat(deger_tarih_,'HH')>
		<cfset deger_dakika_ = timeformat(deger_tarih_,'MM')>
		<cfset deger_gercek_ = (deger_saat_ * 60) + deger_dakika_>
		<cfset gun_ = dayofweek(deger_tarih_)>
		<cfif count_type_ eq 1><!--- hafta ici --->
			<cfset control_baslangic_saat_ = get_system.start_clock_1>			
			<cfset control_baslangic_dakika_ = get_system.start_minute_1>
			<cfset deger_baslangic_ = (control_baslangic_saat_ * 60) + control_baslangic_dakika_>
			
			<cfset control_bitis_saat_ = get_system.finish_clock_1>			
			<cfset control_bitis_dakika_ = get_system.finish_minute_1>
			<cfset deger_bitis_ = (control_bitis_saat_ * 60) + control_bitis_dakika_>
			
			<cfset h_ici_total_mesai_ = deger_bitis_ - deger_baslangic_>
			<cfset cmt_total_mesai_ = 0>
			<cfset pzr_total_mesai_ = 0>
			
			<cfif gun_ eq 1><!--- gun pazar --->
				<cfset add_day_ = 1>
				<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
				<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
				<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
				<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
				<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
			<cfelseif gun_ eq 7><!--- gun cmt --->
				<cfset add_day_ = 2>
				<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
				<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
				<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
				<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
				<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
			<cfelse><!--- gun hafta ici --->
					<cfif deger_gercek_ gte deger_baslangic_ and deger_gercek_ lte deger_bitis_>
						<cfset kabul_ = deger_tarih_ilk_>
					<cfelseif deger_gercek_ lt deger_baslangic_>
						<cfset kabul_ = deger_tarih_ilk_>
						<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
						<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
						<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
						<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
					<cfelseif deger_gercek_ gt deger_bitis_>
						<cfif gun_ eq 6>
							<cfset add_day_ = 2>
						<cfelse>
							<cfset add_day_ = 1>
						</cfif>					
						<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
						<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
						<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
						<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
						<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
					</cfif>
			</cfif>
		<cfelseif count_type_ eq 2><!--- hafta ici + cumartesi --->
			<cfset control_baslangic_saat_ = get_system.start_clock_1>			
			<cfset control_baslangic_dakika_ = get_system.start_minute_1>
			<cfset deger_baslangic_ = (control_baslangic_saat_ * 60) + control_baslangic_dakika_>
			
			<cfset control_bitis_saat_ = get_system.finish_clock_1>			
			<cfset control_bitis_dakika_ = get_system.finish_minute_1>
			<cfset deger_bitis_ = (control_bitis_saat_ * 60) + control_bitis_dakika_>
			
			<cfset control_cmt_baslangic_saat_ = get_system.start_clock_2>			
			<cfset control_cmt_baslangic_dakika_ = get_system.start_minute_2>
			<cfset deger_cmt_baslangic_ = (control_cmt_baslangic_saat_ * 60) + control_cmt_baslangic_dakika_>
			
			<cfset control_cmt_bitis_saat_ = get_system.finish_clock_2>			
			<cfset control_cmt_bitis_dakika_ = get_system.finish_minute_2>
			<cfset deger_cmt_bitis_ = (control_cmt_bitis_saat_ * 60) + control_cmt_bitis_dakika_>
			
			
			<cfset h_ici_total_mesai_ = deger_bitis_ - deger_baslangic_>
			<cfset cmt_total_mesai_ = deger_cmt_bitis_ - deger_cmt_baslangic_>
			<cfset pzr_total_mesai_ = 0>
			
				<cfif gun_ eq 1><!--- gun pazar --->
					<cfset add_day_ = 1>
					<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
					<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
					<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
					<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
					<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
				<cfelseif gun_ eq 7><!--- gun cmt --->
						<cfif deger_gercek_ gte deger_cmt_baslangic_ and deger_gercek_ lte deger_cmt_bitis_>
							<cfset kabul_ = deger_tarih_ilk_>
						<cfelseif deger_gercek_ lt deger_cmt_baslangic_>
							<cfset kabul_ = deger_tarih_ilk_>
							<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
							<cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
							<cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
							<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
						<cfelseif deger_gercek_ gt deger_cmt_bitis_>
							<cfset add_day_ = 2>
							<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
							<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
							<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
							<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
							<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
						</cfif>
				<cfelse><!--- gun hafta ici --->
						<cfif deger_gercek_ gte deger_baslangic_ and deger_gercek_ lte deger_bitis_>
							<cfset kabul_ = deger_tarih_ilk_>
						<cfelseif deger_gercek_ lt deger_baslangic_>
							<cfset kabul_ = deger_tarih_ilk_>
							<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
							<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
							<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
							<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
						<cfelseif deger_gercek_ gt deger_bitis_>
							<cfif gun_ eq 6>
								<cfset add_day_ = 1>
								<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
								<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
								<cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
								<cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
								<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
							<cfelse>
								<cfset add_day_ = 1>
								<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
								<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
								<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
								<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
								<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
							</cfif>					
						</cfif>
				</cfif>	
		<cfelseif count_type_ eq 3><!--- pazar --->
			<cfset control_baslangic_saat_ = get_system.start_clock_1>			
			<cfset control_baslangic_dakika_ = get_system.start_minute_1>
			<cfset deger_baslangic_ = (control_baslangic_saat_ * 60) + control_baslangic_dakika_>
			
			<cfset control_bitis_saat_ = get_system.finish_clock_1>			
			<cfset control_bitis_dakika_ = get_system.finish_minute_1>
			<cfset deger_bitis_ = (control_bitis_saat_ * 60) + control_bitis_dakika_>
			
			<cfset control_cmt_baslangic_saat_ = get_system.start_clock_2>			
			<cfset control_cmt_baslangic_dakika_ = get_system.start_minute_2>
			<cfset deger_cmt_baslangic_ = (control_cmt_baslangic_saat_ * 60) + control_cmt_baslangic_dakika_>
			
			<cfset control_cmt_bitis_saat_ = get_system.finish_clock_2>			
			<cfset control_cmt_bitis_dakika_ = get_system.finish_minute_2>
			<cfset deger_cmt_bitis_ = (control_cmt_bitis_saat_ * 60) + control_cmt_bitis_dakika_>
			
			<cfset control_pzr_baslangic_saat_ = get_system.start_clock_3>			
			<cfset control_pzr_baslangic_dakika_ = get_system.start_minute_3>
			<cfset deger_pzr_baslangic_ = (control_pzr_baslangic_saat_ * 60) + control_pzr_baslangic_dakika_>
			
			<cfset control_pzr_bitis_saat_ = get_system.finish_clock_3>			
			<cfset control_pzr_bitis_dakika_ = get_system.finish_minute_3>
			<cfset deger_pzr_bitis_ = (control_pzr_bitis_saat_ * 60) + control_pzr_bitis_dakika_>
			
			<cfset h_ici_total_mesai_ = deger_bitis_ - deger_baslangic_>
			<cfset cmt_total_mesai_ = deger_cmt_bitis_ - deger_cmt_baslangic_>
			<cfset pzr_total_mesai_ = deger_pzr_bitis_ - deger_pzr_baslangic_>
			
					<cfif gun_ eq 1><!--- gun pazar --->
						<cfif deger_gercek_ gte deger_pzr_baslangic_ and deger_gercek_ lte deger_pzr_bitis_>
							<cfset kabul_ = deger_tarih_ilk_>
						<cfelseif deger_gercek_ lt deger_pzr_baslangic_>
							<cfset kabul_ = deger_tarih_ilk_>
							<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
							<cfset kabul_ = date_add("h",control_pzr_baslangic_saat_,kabul_)>
							<cfset kabul_ = date_add('n',control_pzr_baslangic_dakika_,kabul_)>
							<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
						<cfelseif deger_gercek_ gt deger_pzr_baslangic_>
							<cfset add_day_ = 1>
							<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
							<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
							<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
							<cfset kabul_ = date_add('n',control_baslangic_dahika_,kabul_)>
							<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
						</cfif>
					<cfelseif gun_ eq 7><!--- gun cmt --->
						<cfif deger_gercek_ gte deger_cmt_baslangic_ and deger_gercek_ lte deger_cmt_bitis_>
							<cfset kabul_ = deger_tarih_ilk_>
						<cfelseif deger_gercek_ lt deger_cmt_baslangic_>
							<cfset kabul_ = deger_tarih_ilk_>
							<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
							<cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
							<cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
							<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
						<cfelseif deger_gercek_ gt deger_cmt_bitis_>
							<cfset add_day_ = 1>
							<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
							<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
							<cfset kabul_ = date_add("h",control_pzr_baslangic_saat_,kabul_)>
							<cfset kabul_ = date_add('n',control_pzr_baslangic_dakika_,kabul_)>
							<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
						</cfif>
					<cfelse><!--- gun hafta ici --->
						<cfif deger_gercek_ gte deger_baslangic_ and deger_gercek_ lte deger_bitis_>
							<cfset kabul_ = deger_tarih_ilk_>
						<cfelseif deger_gercek_ lt deger_baslangic_>
							<cfset kabul_ = deger_tarih_ilk_>
							<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
							<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
							<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
							<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
						<cfelseif deger_gercek_ gt deger_bitis_>
							<cfif gun_ eq 6>
								<cfset add_day_ = 1>
								<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
								<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
								<cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
								<cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
								<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
							<cfelse>
								<cfset add_day_ = 1>
								<cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
								<cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
								<cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
								<cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
								<cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
							</cfif>					
						</cfif>
					</cfif>	
		</cfif>
	</cfif><!--- sistem var mi --->
</cfif>
<cfif isdefined("kabul_")>
	<!--- <cfset attributes.start_date1 = kabul_> Niye yapıldıgını anlasılmadı, kapatıldı 21012013 MA --->
	<cfif len(get_system.hour1) and len(get_system.minute1)>
		<cfset cozum_suresi_ = (get_system.hour1 * 60) + get_system.minute1>
	<cfelseif len(get_system.hour1)>
		<cfset cozum_suresi_ = (get_system.hour1 * 60)>
	<cfelseif len(get_system.minute1)>
		<cfset cozum_suresi_ = get_system.minute1>
	<cfelse>
		<cfset cozum_suresi_ = 60>
	</cfif>
	<cfif len(get_system.response_hour1) and len(get_system.response_minute1)>
		<cfset mudahale_suresi_ = (get_system.response_hour1 * 60) + get_system.response_minute1>
	<cfelseif len(get_system.response_hour1)>
		<cfset mudahale_suresi_ = (get_system.response_hour1 * 60)>
	<cfelseif len(get_system.response_minute1)>
		<cfset mudahale_suresi_ = get_system.response_minute1>
	<cfelse>
		<cfset mudahale_suresi_ = 60>
	</cfif>
	<cfset gun_ = dayofweek(kabul_)>
	<cfif gun_ eq 7><!--- cumartesi --->
		<cfset today_finish_ = deger_cmt_bitis_>
	<cfelseif gun_ eq 1><!--- pazar --->
		<cfif isdefined("deger_pzr_bitis_")>
			<cfset today_finish_ = deger_pzr_bitis_>
		<cfelse>
			<cfset today_finish_ = 0>
		</cfif>
	<cfelse>
		<cfset today_finish_ = deger_bitis_>
	</cfif>
	<cfset deger_saat_ = timeformat(kabul_,'HH')>
	<cfset deger_dakika_ = timeformat(kabul_,'MM')>
	<cfset deger_gercek_ = (deger_saat_ * 60) + deger_dakika_>
	<cfif today_finish_ gt (cozum_suresi_ + deger_gercek_)>
		<cfset attributes.cozum_suresi_ = date_add("n",cozum_suresi_,kabul_)>
	<cfelse>
		<cfset kalan_sure = cozum_suresi_ - (today_finish_ - deger_gercek_)>
		<cfset flag = 1>
		<cfset day_add_ = 0>
		<cfscript>
			while(flag)
				{
				day_add_ = day_add_ + 1;
				new_date_gun_ = date_add("d",day_add_,kabul_);
				get_day_ = dayofweek(new_date_gun_);
				if(get_day_ eq 7)
					{
						if(cmt_total_mesai_ gt kalan_sure)
							{
							attributes.cozum_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
							attributes.cozum_suresi_ = date_add("n",(deger_cmt_baslangic_+kalan_sure),attributes.cozum_suresi_);
							flag = 0;
							}
						else
							{
							kalan_sure = kalan_sure - cmt_total_mesai_;
							}
					}
				else if(get_day_ eq 1)
					{
						if(pzr_total_mesai_ gt kalan_sure)
							{
							attributes.cozum_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
							attributes.cozum_suresi_ = date_add("n",(deger_pzr_baslangic_+kalan_sure),attributes.cozum_suresi_);
							flag = 0;
							}
						else
							{
							kalan_sure = kalan_sure - pzr_total_mesai_;
							}
					}
				else
					{
						if(h_ici_total_mesai_ gt kalan_sure)
							{
							attributes.cozum_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
							attributes.cozum_suresi_ = date_add("n",(deger_baslangic_+kalan_sure),attributes.cozum_suresi_);
							flag = 0;
							}
						else
							{
							kalan_sure = kalan_sure - h_ici_total_mesai_;
							}
					}
				}
		</cfscript>	
	</cfif>
	
	<cfif today_finish_ gt (mudahale_suresi_ + deger_gercek_)>
		<cfset attributes.mudahale_suresi_ = date_add("n",mudahale_suresi_,kabul_)>
	<cfelse>
		<cfset kalan_sure = mudahale_suresi_ - (today_finish_ - deger_gercek_)>
		<cfset flag2 = 1>
		<cfset day_add2_ = 0>
		<cfscript>
			while(flag2)
				{
				day_add2_ = day_add2_ + 1;
				new_date_gun2_ = date_add("d",day_add2_,kabul_);
				get_day2_ = dayofweek(new_date_gun2_);
				if(get_day2_ eq 7)
					{
						if(cmt_total_mesai_ gt kalan_sure)
							{
							attributes.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun2_),month(new_date_gun2_),day(new_date_gun2_)));
							attributes.mudahale_suresi_ = date_add("n",(deger_cmt_baslangic_+kalan_sure),attributes.mudahale_suresi_);
							flag2 = 0;
							}
						else
							{
							kalan_sure = kalan_sure - cmt_total_mesai_;
							}
					}
				else if(get_day2_ eq 1)
					{
						if(pzr_total_mesai_ gt kalan_sure)
							{
							attributes.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun2_),month(new_date_gun2_),day(new_date_gun2_)));
							attributes.mudahale_suresi_ = date_add("n",(deger_pzr_baslangic_+kalan_sure),attributes.mudahale_suresi_);
							flag2 = 0;
							}
						else
							{
							kalan_sure = kalan_sure - pzr_total_mesai_;
							}
					}
				else
					{
						if(h_ici_total_mesai_ gt kalan_sure)
							{
							attributes.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun2_),month(new_date_gun2_),day(new_date_gun2_)));
							attributes.mudahale_suresi_ = date_add("n",(deger_baslangic_+kalan_sure),attributes.mudahale_suresi_);
							flag2 = 0;
							}
						else
							{
							kalan_sure = kalan_sure - h_ici_total_mesai_;
							}
					}
				}
		</cfscript>
	</cfif>
</cfif>
<cfquery name="GET_DATE_CONTROL" datasource="#DSN3#">
	SELECT SERVICE_STATUS_ID FROM SERVICE WHERE SERVICE_ID = #ATTRIBUTES.SERVICE_ID#
</cfquery>
<cfset is_change = 0>
<cfif GET_DATE_CONTROL.SERVICE_STATUS_ID neq attributes.process_stage>
	<cfset is_change = 1>
</cfif>
<cfquery name="UPD_SERVICE" datasource="#DSN3#">
	UPDATE
		SERVICE
	SET
		SERVICE_ACTIVE = <cfif isDefined("attributes.status")>1<cfelse>0</cfif>,
		SERVICECAT_ID = #attributes.appcat_id#,
		SERVICE_STATUS_ID = #attributes.process_stage#,		
		SERVICE_SUBSTATUS_ID = <cfif isDefined('attributes.service_substatus_id') and len(attributes.service_substatus_id)>#attributes.service_substatus_id#<cfelse>NULL</cfif>,
		PRO_SERIAL_NO = <cfif isDefined("attributes.service_product_serial") and len(attributes.service_product_serial)>'#attributes.service_product_serial#'<cfelse>NULL</cfif>,
		<cfif isDefined("attributes.MAIN_SERIAL_NO")>MAIN_SERIAL_NO = '#attributes.MAIN_SERIAL_NO#',</cfif>
		GUARANTY_INSIDE = <cfif isdefined("attributes.guaranty_inside")>1<cfelse>0</cfif>,
        INSIDE_DETAIL = <cfif isdefined("attributes.inside_detail") and len(attributes.inside_detail)>'#attributes.inside_detail#'<cfelse>NULL</cfif>,
		STOCK_ID = <cfif isDefined("attributes.stock_id") and len(attributes.stock_id) and len(attributes.service_product)>#attributes.stock_id#<cfelseif isdefined("seri_stock_id")>'#seri_stock_id#'<cfelse>NULL</cfif>,
		PRODUCT_NAME = <cfif isdefined("attributes.service_product") and len(attributes.service_product) and len(attributes.service_product_id)>'#attributes.service_product#',<cfelseif isdefined("seri_product_name")>'#seri_product_name#',<cfelse>NULL,</cfif>
		SERVICE_PRODUCT_ID = <cfif isDefined("attributes.service_product_id") and len(attributes.service_product_id) and len(attributes.service_product)>#attributes.service_product_id#,<cfelseif isdefined("seri_product_id")>#seri_product_id#,<cfelse>NULL,</cfif>
		SPEC_MAIN_ID = <cfif isDefined("attributes.spec_main_id") and len(attributes.spec_main_id) and len(attributes.spect_name)>#attributes.spec_main_id#,<cfelse>NULL,</cfif>
		<cfif isDefined("G_ID")>GUARANTY_ID = #G_ID#,</cfif>
		<cfif len(attributes.priority_id)>PRIORITY_ID = #attributes.priority_id#,</cfif>
		<cfif len(attributes.commethod_id)>COMMETHOD_ID = #attributes.commethod_id#,</cfif>
		RELATED_COMPANY_ID = <cfif len(attributes.RELATED_COMPANY_ID) and len(attributes.RELATED_COMPANY)>#attributes.RELATED_COMPANY_ID#<cfelse>NULL</cfif>,
		SERVICE_HEAD = '#wrk_eval("attributes.service_head")#',
		SERVICE_DETAIL = <cfif len(attributes.service_detail)>'#attributes.service_detail#'<cfelse>NULL</cfif>,
		SERVICE_ADDRESS = <cfif isdefined("attributes.service_address") and len(attributes.service_address)>'#attributes.service_address#'<cfelse>NULL</cfif>,
		SERVICE_COUNTY_ID = <cfif isdefined("attributes.service_county_id") and len(attributes.service_county_id) and len(attributes.service_county_name)>#attributes.service_county_id#<cfelse>NULL</cfif>,
		SERVICE_CITY_ID = <cfif isdefined("attributes.service_city_id") and len(attributes.service_city_id)>#attributes.service_city_id#<cfelse>NULL</cfif>,
		SERVICE_COUNTY = <cfif isdefined("attributes.service_county") and len(attributes.service_county)>'#attributes.service_county#'<cfelse>NULL</cfif>,
		SERVICE_CITY =  <cfif isdefined("attributes.service_city") and len(attributes.service_city)>'#attributes.service_city#'<cfelse>NULL</cfif>,
		<cfif attributes.member_type is 'partner'>
			SERVICE_CONSUMER_ID = NULL,
			SERVICE_PARTNER_ID = #attributes.member_id#,
			SERVICE_COMPANY_ID = #attributes.company_id#,					
		<cfelseif attributes.member_type is 'consumer'>
			SERVICE_CONSUMER_ID = #attributes.member_id#,
			SERVICE_PARTNER_ID = NULL,
			SERVICE_COMPANY_ID = NULL,
		<cfelse>
			SERVICE_CONSUMER_ID = NULL,
			SERVICE_PARTNER_ID = NULL,
			SERVICE_COMPANY_ID = NULL,
		</cfif>
		BRING_NAME = <cfif isdefined("attributes.bring_name") and len(attributes.bring_name)>'#attributes.bring_name#'<cfelse>NULL</cfif>,
		BRING_EMAIL = <cfif isdefined("attributes.bring_email") and len(attributes.bring_email)>'#attributes.bring_email#'<cfelse>NULL</cfif>,
		DOC_NO = <cfif isdefined("attributes.doc_no") and len(attributes.doc_no)>'#attributes.doc_no#'<cfelse>NULL</cfif>,
		BRING_TEL_NO = <cfif isdefined("attributes.bring_tel_no") and len(attributes.bring_tel_no)>'#attributes.bring_tel_no#'<cfelse>NULL</cfif>,

		BRING_MOBILE_NO = <cfif isdefined("attributes.bring_mobile_no") and len(attributes.bring_mobile_no)>'#attributes.bring_mobile_no#'<cfelse>NULL</cfif>,
		BRING_DETAIL = <cfif isdefined("attributes.bring_detail") and len(attributes.bring_detail)>'#attributes.bring_detail#'<cfelse>NULL</cfif>,
		GUARANTY_START_DATE = <cfif isDefined("attributes.GUARANTY_START_DATE") and len(attributes.GUARANTY_START_DATE)>#attributes.GUARANTY_START_DATE#<cfelse>NULL</cfif>,
		DEAD_LINE = <cfif isdefined("attributes.cozum_suresi_")>#attributes.cozum_suresi_#<cfelse>NULL</cfif>,
		DEAD_LINE_RESPONSE = <cfif isdefined("attributes.mudahale_suresi_")>#attributes.mudahale_suresi_#<cfelse>NULL</cfif>,
		APPLY_DATE = <cfif len(attributes.apply_date)>#attributes.apply_date#<cfelse>NULL</cfif>,
		START_DATE = <cfif len(attributes.start_date1)>#attributes.start_date1#<cfelse>NULL</cfif>,
		INTERVENTION_DATE = <cfif isdefined('attributes.intervention_date') and len(attributes.intervention_date)>#attributes.intervention_date#<cfelse>NULL</cfif>,
		FINISH_DATE = <cfif len(attributes.finish_date1)>#attributes.finish_date1#<cfelse>NULL</cfif>,
		PAID_REPAIR = <cfif isdefined("attributes.paid_repair")>1<cfelse>0</cfif>,
		ACCESSORY = <cfif isdefined("attributes.accessory") and attributes.accessory eq 1>1<cfelse>0</cfif>,
        ACCESSORY_DETAIL = <cfif isdefined("attributes.accessory_detail") and len(attributes.accessory_detail) and isdefined("attributes.accessory") and attributes.accessory eq 1>'#accessory_detail#'<cfelse>NULL</cfif>,
		SERVICE_BRANCH_ID = <cfif isDefined("attributes.service_branch_id") and len(attributes.service_branch_id)>#attributes.service_branch_id#<cfelse>NULL</cfif>,
		DEPARTMENT_ID = <cfif len(attributes.department_id) and len(attributes.department)>#attributes.department_id#<cfelse>NULL</cfif>,
		LOCATION_ID = <cfif len(attributes.location_id) and len(attributes.department)>#attributes.location_id#<cfelse>NULL</cfif>,
		SERVICE_DEFECT_CODE = <cfif isdefined("attributes.service_defect_code") and len(attributes.service_defect_code)>'#attributes.service_defect_code#'<cfelse>NULL</cfif>,
		APPLICATOR_NAME = '#attributes.member_name#',
		PROJECT_ID = <cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#,<cfelse>NULL,</cfif>
		SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		<!--- <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>SUBSCRIPTION_ID = #attributes.subscription_id#,</cfif> --->
		<cfif isdefined("attributes.sales_add_option")> SALE_ADD_OPTION_ID = <cfif len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,</cfif>
		APPLICATOR_COMP_NAME = <cfif isDefined("attributes.applicator_comp_name") and len(attributes.applicator_comp_name)>'#attributes.applicator_comp_name#'<cfelse>NULL</cfif>,
		IS_SALARIED = <cfif isdefined("attributes.is_salaried")>1<cfelse>0</cfif>,
		SHIP_METHOD = <cfif isdefined("attributes.ship_method") and len(attributes.ship_method) and len(attributes.ship_method_name)>#attributes.ship_method#<cfelse>NULL</cfif>,
		OTHER_COMPANY_ID = <cfif isdefined("attributes.other_company_id") and len(attributes.other_company_id) and len(attributes.other_company_name)>#attributes.other_company_id#<cfelse>NULL</cfif>,
		OTHER_COMPANY_BRANCH_ID = <cfif isdefined("attributes.other_company_branch_id") and len(attributes.other_company_branch_id) and len(attributes.other_company_branch_name)>#attributes.other_company_branch_id#<cfelse>NULL</cfif>,
        INSIDE_DETAIL_SELECT = <cfif isdefined("attributes.inside_detail_select") and len(attributes.inside_detail_select) and isdefined("attributes.guaranty_inside")>'#attributes.inside_detail_select#'<cfelse>NULL</cfif>,
        ACCESSORY_DETAIL_SELECT = <cfif isdefined("attributes.accessory_detail_select") and len(attributes.accessory_detail_select)>'#attributes.accessory_detail_select#'<cfelse>NULL</cfif>,
		SERVICECAT_SUB_ID = <cfif isdefined("attributes.appcat_sub_id") and len(attributes.appcat_sub_id)>'#attributes.appcat_sub_id#'<cfelse>NULL</cfif>,
        SERVICECAT_SUB_STATUS_ID = <cfif isdefined("attributes.appcat_sub_status_id") and len(attributes.appcat_sub_status_id)>'#attributes.appcat_sub_status_id#'<cfelse>NULL</cfif>,
        SZ_ID=<cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id)>#attributes.sales_zone_id#<cfelse>NULL</cfif>,
        BRING_SHIP_METHOD_ID = <cfif isdefined("attributes.bring_ship_method_name") and len(attributes.bring_ship_method_name) and len(attributes.bring_ship_method_id)>#attributes.bring_ship_method_id#<cfelse>NULL</cfif>,
        UPDATE_DATE = #now()#,
		UPDATE_MEMBER = #session.ep.userid#	,
		SERVICE_EMPLOYEE_ID = <cfif len(attributes.task_person_name) and len(attributes.task_emp_id)>#attributes.task_emp_id#<cfelse>NULL</cfif>,
        TIME_CLOCK_HOUR = <cfif isdefined("attributes.time_clock_hour") and len(attributes.time_clock_hour)>#attributes.time_clock_hour#<cfelse>NULL</cfif>,
        TIME_CLOCK_MINUTE = <cfif isdefined("attributes.time_clock_minute") and len(attributes.time_clock_minute)>#attributes.time_clock_minute#<cfelse>NULL</cfif>
	WHERE
		SERVICE_ID = #attributes.id#
</cfquery>

<cfquery name="GET_SERVICE1" datasource="#DSN3#">
	SELECT * FROM SERVICE WHERE SERVICE_ID = #attributes.id#
</cfquery>
<cfif len(get_service1.record_date)><cfset attributes.record_date = createodbcdatetime(get_service1.record_date)></cfif>
<cfif len(get_service1.apply_date)><cfset attributes.apply_date = createodbcdatetime(get_service1.apply_date)></cfif>
<cfif len(get_service1.start_date)><cfset attributes.start_date = createodbcdatetime(get_service1.start_date)></cfif>
<cfif len(get_service1.finish_date)><cfset attributes.finish_date = createodbcdatetime(get_service1.finish_date)></cfif>
<cfif len(get_service1.update_date)><cfset attributes.update_date = createodbcdatetime(get_service1.update_date)></cfif>
<cfif len(get_service1.INTERVENTION_DATE)><cfset attributes.INTERVENTION_DATE = createodbcdatetime(get_service1.INTERVENTION_DATE)></cfif>
<cfquery name="ADD_HISTORY" datasource="#DSN3#">
	INSERT INTO
		SERVICE_HISTORY
	(
		RELATED_COMPANY_ID,
		SERVICE_ACTIVE,
		SERVICECAT_ID,
		PRO_SERIAL_NO,
		STOCK_ID,
		PRODUCT_NAME,
		SERVICE_SUBSTATUS_ID,
		SERVICE_STATUS_ID,
		GUARANTY_ID,
		GUARANTY_PAGE_NO,
		PRIORITY_ID,
		COMMETHOD_ID,				
		SERVICE_HEAD,
		SERVICE_DETAIL,
		SERVICE_ADDRESS,
		SERVICE_COUNTY,
		SERVICE_CITY,
		SERVICE_CONSUMER_ID,
		NOTES,
		APPLY_DATE,
		FINISH_DATE,
		START_DATE,
		SERVICE_PRODUCT_ID,
		SPEC_MAIN_ID,
		SERVICE_DEFECT_CODE,
		APPLICATOR_NAME,
		PROJECT_ID,
		RECORD_DATE,
		RECORD_MEMBER,
		UPDATE_DATE,
		UPDATE_MEMBER,
		RECORD_PAR,
		UPDATE_PAR,
		SHIP_METHOD,
		OTHER_COMPANY_ID,
		SERVICE_COUNTY_ID,
		SERVICE_CITY_ID,
		SERVICE_ID,
        SERVICECAT_SUB_ID,
        SERVICECAT_SUB_STATUS_ID,
        WORKGROUP_ID,
        CALL_SERVICE_ID,
        INTERVENTION_DATE,
        GUARANTY_INSIDE,
        SERVICE_BRANCH_ID
	)
	VALUES
	(
		<cfif len(get_service1.RELATED_COMPANY_ID)>#get_service1.RELATED_COMPANY_ID#<cfelse>NULL</cfif>,
		#get_service1.service_active#,
		<cfif len(get_service1.servicecat_id)>#get_service1.servicecat_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.pro_serial_no)>'#get_service1.pro_serial_no#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.stock_id)>#get_service1.stock_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.product_name)>'#get_service1.product_name#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_substatus_id)>#get_service1.service_substatus_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_status_id)>#get_service1.service_status_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.guaranty_id)>#get_service1.guaranty_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.guaranty_page_no)>#get_service1.guaranty_page_no#<cfelse>NULL</cfif>,
		<cfif len(get_service1.priority_id)>#get_service1.priority_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.commethod_id)>#get_service1.commethod_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_head)>'#wrk_eval("get_service1.service_head")#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_detail)>'#get_service1.service_detail#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_address)>'#get_service1.service_address#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_county)>'#get_service1.service_county#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_city)>'#get_service1.service_city#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_consumer_id)>#get_service1.service_consumer_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.notes)>'#get_service1.notes#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.apply_date)>#createodbcdatetime(get_service1.apply_date)#<cfelse>NULL</cfif>,
		<cfif len(get_service1.finish_date)>#createodbcdatetime(get_service1.finish_date)#<cfelse>NULL</cfif>,
		<cfif len(get_service1.start_date)>#createodbcdatetime(get_service1.start_date)#<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_product_id)>#get_service1.service_product_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.SPEC_MAIN_ID)>#get_service1.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_defect_code)>'#get_service1.service_defect_code#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.applicator_name) and isdefined('get_service1.applicator_name')>'#get_service1.applicator_name#'<cfelse>NULL</cfif>,
		<cfif len(get_service1.PROJECT_ID)>#get_service1.PROJECT_ID#<cfelse>NULL</cfif>,
		<cfif len(get_service1.record_date)>#createodbcdatetime(get_service1.record_date)#<cfelse>NULL</cfif>,
		<cfif len(get_service1.record_member)>#get_service1.record_member#<cfelse>NULL</cfif>,
		<cfif len(get_service1.update_date)>#createodbcdatetime(get_service1.update_date)#<cfelse>NULL</cfif>,
		<cfif len(get_service1.update_member)>#get_service1.update_member#<cfelse>NULL</cfif>,
		<cfif len(get_service1.record_par)>#get_service1.record_par#<cfelse>NULL</cfif>,
		<cfif len(get_service1.update_par)>#get_service1.update_par#<cfelse>NULL</cfif>,
		<cfif len(get_service1.ship_method)>#get_service1.ship_method#<cfelse>NULL</cfif>,
		<cfif len(get_service1.other_company_id)>#get_service1.OTHER_COMPANY_ID#<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_county_id)>#get_service1.service_county_id#<cfelse>NULL</cfif>,
		<cfif len(get_service1.service_city_id)>#get_service1.service_city_id#<cfelse>NULL</cfif>,							
		#get_service1.service_id#,
        <cfif len(get_service1.servicecat_sub_id)>#get_service1.SERVICECAT_SUB_ID#<cfelse>NULL</cfif>,
        <cfif len(get_service1.servicecat_sub_status_id)>#get_service1.SERVICECAT_SUB_STATUS_ID#<cfelse>NULL</cfif>,
        <cfif len(get_service1.workgroup_id)>#get_service1.WORKGROUP_ID#<cfelse>NULL</cfif>,
        <cfif len(get_service1.call_service_id)>#get_service1.CALL_SERVICE_ID#<cfelse>NULL</cfif>,
         <cfif len(get_service1.INTERVENTION_DATE)>#createodbcdatetime(get_service1.INTERVENTION_DATE)#<cfelse>NULL</cfif>,
        #get_service1.GUARANTY_INSIDE#,
        <cfif len(get_service1.SERVICE_BRANCH_ID)>#get_service1.SERVICE_BRANCH_ID#<cfelse>NULL</cfif>
	)
</cfquery>
<cfquery name="del_defected_code" datasource="#dsn3#">
	DELETE FROM SERVICE_CODE_ROWS WHERE SERVICE_ID=#attributes.id#
</cfquery>

<cfif isdefined("attributes.failure_code") and listlen(attributes.failure_code)>
	<cfloop list="#attributes.failure_code#" index="m">
			<cfquery name="ADD_SERVICE_CODE_ROWS" datasource="#dsn3#">
				INSERT INTO
					SERVICE_CODE_ROWS
				(
					SERVICE_CODE_ID,
					SERVICE_ID
				)				
				VALUES
				(
					#m#,
					#attributes.id#
				)
			</cfquery>
	</cfloop>
</cfif>
<!--- Custom Tag' a Gidecek Parametreler --->
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.ID>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id = -15>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cf_workcube_process 
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='SERVICE'
	action_column='SERVICE_ID'
	action_id='#attributes.id#' 
	action_page='#request.self#?fuseaction=service.list_service&event=upd&service_id=#attributes.id#' 
	warning_description='Servis No : #get_service1.service_no#'
	paper_no='#get_service1.service_no#'>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=service.list_service&event=upd&service_id=#attributes.id#</cfoutput>';
</script>
