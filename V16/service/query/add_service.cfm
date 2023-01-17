<cf_xml_page_edit fuseact="service.add_service">
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
 
<!--- gorevli atamada kullaniliyor yerini dahi degistirmeyiniz yo13082008--->
<cfif len(attributes.task_person_name) and len(attributes.task_emp_id)>
	<cfset attributes.work_status = 1>
	<cfset temp_apply_date = attributes.apply_date>
	<cfset attributes.startdate_plan = temp_apply_date>
	<cf_date tarih='temp_apply_date'>
	<cfset attributes.finishdate_plan = dateformat(date_add('d',1,temp_apply_date),dateformat_style)>
	<cfset attributes.finish_hour_plan = attributes.apply_hour>
	<cfset attributes.finish_hour = attributes.apply_hour>
	<cfset attributes.start_hour = attributes.apply_hour>
	<cfset attributes.work_fuse = 'service.add_service'>
	<cfset attributes.work_detail = attributes.service_detail>
	<cfset attributes.project_emp_id = attributes.task_emp_id>
	<cfif attributes.member_type is 'partner'>
		<cfset attributes.company_id = attributes.company_id>
		<cfset attributes.company_partner_id = attributes.member_id>
	<cfelseif attributes.member_type is 'consumer'>
		<cfset attributes.company_id = "">
		<cfset attributes.company_partner_id = attributes.member_id>
	</cfif>
	<cfset attributes.task_partner_id = ''>
	<cfquery name="GET_WORK_CAT" datasource="#DSN#" maxrows="1">
		SELECT WORK_CAT_ID, WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
	</cfquery>
	<cfset attributes.PRO_WORK_CAT = GET_WORK_CAT.WORK_CAT_ID>

	<cfquery name="GET_CATS" datasource="#DSN#" maxrows="1">
		SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY
	</cfquery>
	<cfset attributes.PRIORITY_CAT = GET_CATS.PRIORITY_ID>
	
	<cfquery name="GET_WORK_PROCESS" datasource="#DSN#" maxrows="1">
		SELECT TOP 1
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
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.addwork,%">
		ORDER BY
			PTR.LINE_NUMBER
	</cfquery>
	<cfset attributes.work_process_stage = get_work_process.process_row_id>
</cfif>
<cfif len(attributes.apply_date)>
	<cf_date tarih="attributes.apply_date">
	<cfset attributes.apply_date=date_add("H", attributes.apply_hour - session.ep.time_zone,attributes.apply_date)>
	<cfset attributes.apply_date=date_add("N", attributes.apply_minute,attributes.apply_date)>
</cfif>
<cfif len(attributes.start_date1)>
	<cf_date tarih="attributes.start_date1">
	<cfset attributes.start_date1=date_add("H", attributes.start_hour - session.ep.time_zone,attributes.start_date1)>
	<cfset attributes.start_date1=date_add("N", attributes.start_minute,attributes.start_date1)>
</cfif>
<cfif isdefined("attributes.guaranty_start_date") and len(attributes.guaranty_start_date)>
	<cf_date tarih="attributes.guaranty_start_date">
</cfif>
<cfif isdefined("attributes.intervention_date") and len(attributes.intervention_date)>
	<cf_date tarih="attributes.intervention_date">
	<cfset attributes.intervention_date=date_add("H", attributes.intervention_start_hour - session.ep.time_zone,attributes.intervention_date)>
	<cfset attributes.intervention_date=date_add("N", attributes.intervention_start_minute,attributes.intervention_date)>
</cfif>
<cfif isdefined("attributes.finish_date1") and len(attributes.finish_date1)>
	<cf_date tarih="attributes.finish_date1">
	<cfset attributes.finish_date1=date_add("H", attributes.finish_hour1 - session.ep.time_zone,attributes.finish_date1)>
	<cfset attributes.finish_date1=date_add("N", attributes.finish_minute1,attributes.finish_date1)>
</cfif>
<cfif isdefined("attributes.service_product") and not len(attributes.service_product) and len(attributes.service_product_serial)>
	<cfquery name="GET_SERI_PRODUCT" datasource="#DSN3#" maxrows="1">
		SELECT SGN.STOCK_ID,S.PRODUCT_NAME,S.PRODUCT_ID FROM SERVICE_GUARANTY_NEW SGN,STOCKS S WHERE SGN.STOCK_ID = S.STOCK_ID AND SGN.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_product_serial#"> 
	</cfquery>
	<cfif get_seri_product.recordcount>
		<cfset seri_stock_id = get_seri_product.stock_id>
		<cfset seri_product_id = get_seri_product.product_id>
		<cfset seri_product_name = get_seri_product.product_name>
	</cfif>
</cfif>


<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
	<cfquery name="GET_SYSTEM" datasource="#DSN3#">
		SELECT TOP 1 * FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
	</cfquery>
	<cfif get_system.recordcount and get_system.valid_days gte 1><!--- sistem var mi --->
		<cfset count_type_ = get_system.valid_days>
		<cfset deger_tarih_ilk_ = now()>
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
	<cfset deger_pzr_bitis_ = 0>
	<cfset attributes.start_date1 = kabul_>
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
		<cfset today_finish_ = deger_pzr_bitis_>
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
							attributes.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
							attributes.mudahale_suresi_ = date_add("n",(deger_cmt_baslangic_+kalan_sure),attributes.mudahale_suresi_);
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
							attributes.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
							attributes.mudahale_suresi_ = date_add("n",(deger_pzr_baslangic_+kalan_sure),attributes.mudahale_suresi_);
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
							attributes.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
							attributes.mudahale_suresi_ = date_add("n",(deger_baslangic_+kalan_sure),attributes.mudahale_suresi_);
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
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
	<cf_papers paper_type="SERVICE_APP">
	<cfset system_paper_no=paper_code & '-' & paper_number>
	<cfset system_paper_no_add=paper_number>
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE
			GENERAL_PAPERS
		SET
			SERVICE_APP_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#system_paper_no_add#">
		WHERE
			SERVICE_APP_NUMBER IS NOT NULL
	</cfquery>
    <cfif len(attributes.task_person_name) and len(attributes.task_emp_id)>
		<cfif len(attributes.service_head)>
            <cfset attributes.work_head = left(attributes.service_head,100)>
        <cfelse>
            <cfset attributes.work_head = left(system_paper_no,100)>
        </cfif>
	</cfif>
	<cfquery name="ADD_SERVICE" datasource="#DSN3#" result="my_result">
		INSERT INTO
			SERVICE
			(
				SERVICE_ACTIVE,
				ISREAD,
				SERVICECAT_ID,
				SERVICE_STATUS_ID,
				SERVICE_SUBSTATUS_ID,
				STOCK_ID,	
				<cfif isDefined("attributes.G_ID")>GUARANTY_ID,</cfif>
				PRIORITY_ID,
				COMMETHOD_ID,
				SERVICE_HEAD,
				SERVICE_DETAIL,
				SERVICE_COUNTY_ID,
				SERVICE_CITY_ID,
				SERVICE_ADDRESS,
				SERVICE_COUNTY,
				SERVICE_CITY,
				DEAD_LINE,
				DEAD_LINE_RESPONSE,
				APPLY_DATE,
				START_DATE,
				<cfif attributes.member_type is 'partner'>
                    SERVICE_PARTNER_ID,
                    SERVICE_COMPANY_ID,					
                <cfelseif attributes.member_type is 'consumer'>
                    SERVICE_CONSUMER_ID,
                </cfif>
				SERVICE_PRODUCT_ID,				
				SERVICE_BRANCH_ID,
				DEPARTMENT_ID,
				LOCATION_ID,
				SERVICE_DEFECT_CODE,				
				APPLICATOR_NAME,
				APPLICATOR_COMP_NAME,
				PRODUCT_NAME,
				<cfif isdefined("attributes.service_product_serial") and len(attributes.service_product_serial)>
                    PRO_SERIAL_NO,
                    MAIN_SERIAL_NO,
                </cfif>	
				GUARANTY_START_DATE,
				GUARANTY_INSIDE,
                INSIDE_DETAIL,
				SERVICE_NO,
				BRING_NAME,
				BRING_EMAIL,
				DOC_NO,
				BRING_TEL_NO,
				BRING_MOBILE_NO,
				BRING_DETAIL,
				ACCESSORY,
                ACCESSORY_DETAIL,
				SUBSCRIPTION_ID,
				RELATED_COMPANY_ID,
				SALE_ADD_OPTION_ID,
				PROJECT_ID,
				IS_SALARIED,
				SHIP_METHOD,
				BRING_SHIP_METHOD_ID,
				CUS_HELP_ID,
				OTHER_COMPANY_ID,
				OTHER_COMPANY_BRANCH_ID,
                INSIDE_DETAIL_SELECT,
                ACCESSORY_DETAIL_SELECT,
                SERVICECAT_SUB_ID,
                SERVICECAT_SUB_STATUS_ID,
                WORKGROUP_ID,
                CALL_SERVICE_ID,
                SZ_ID,
				RECORD_DATE,
				RECORD_MEMBER,
				SERVICE_EMPLOYEE_ID,
				INTERVENTION_DATE,
                FINISH_DATE,
                SPEC_MAIN_ID,
                TIME_CLOCK_HOUR,
                TIME_CLOCK_MINUTE
			)
			VALUES
			(
				1,
				0,
				#attributes.appcat_id#,
				#attributes.process_stage#,
				<cfif len(attributes.service_substatus_id)>#attributes.service_substatus_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>#attributes.stock_id#<cfelseif isdefined("seri_stock_id")>#seri_stock_id#<cfelse>NULL</cfif>,
				<cfif isDefined("G_ID")>#G_ID#,</cfif>
				<cfif len(attributes.priority_id)>#attributes.priority_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.service_head)>'#wrk_eval("attributes.service_head")#'<cfelse>'#system_paper_no#'</cfif>,				
				'#attributes.service_detail#',
				<cfif isdefined("attributes.service_county_id") and len(attributes.service_county_id) and len(attributes.service_county_name)>#attributes.service_county_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.service_city_id") and len(attributes.service_city_id)>#attributes.service_city_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.service_address") and len(attributes.service_address)>'#attributes.service_address#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.service_county") and len(attributes.service_county)>'#attributes.service_county#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.service_city") and len(attributes.service_city)>'#attributes.service_city#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.cozum_suresi_")>#attributes.cozum_suresi_#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.mudahale_suresi_")>#attributes.mudahale_suresi_#<cfelse>NULL</cfif>,
				<cfif len(attributes.apply_date)>#attributes.apply_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.start_date1)>#attributes.start_date1#<cfelse>NULL</cfif>,
				<cfif attributes.member_type is 'partner'>
                    #attributes.member_id#,
                    #attributes.company_id#,					
                <cfelseif attributes.member_type is 'consumer'>
                    #attributes.member_id#,
                </cfif>				
				<cfif isDefined("attributes.service_product_id") and len(attributes.service_product_id) and len(attributes.service_product)>#attributes.service_product_id#<cfelseif isdefined("seri_product_id")>#seri_product_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.service_branch_id") and len(attributes.service_branch_id)>#attributes.service_branch_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.department_id) and len(attributes.department)>#attributes.department_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.location_id) and len(attributes.department)>#attributes.location_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.service_defect_code")>'#attributes.service_defect_code#'<cfelse>NULL</cfif>,
				'#left(attributes.member_name,200)#',
				<cfif isDefined("attributes.applicator_comp_name") and len(attributes.applicator_comp_name)>'#attributes.applicator_comp_name#'<cfelseif isDefined("attributes.company_name") and len(attributes.company_name)>'#attributes.company_name#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.service_product") and len(attributes.service_product)>'#attributes.service_product#'<cfelseif isdefined("seri_product_name")>'#seri_product_name#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.service_product_serial") and len(attributes.service_product_serial)>
                    '#attributes.service_product_serial#',
                    '#attributes.main_serial_no#',
                </cfif>
				<cfif isdefined('attributes.GUARANTY_START_DATE') and len(attributes.GUARANTY_START_DATE)>#attributes.GUARANTY_START_DATE#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.guaranty_inside")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.inside_detail") and len(attributes.inside_detail)>'#attributes.inside_detail#',<cfelse>NULL,</cfif>
				'#system_paper_no#',
				<cfif isdefined("attributes.bring_name")>'#attributes.bring_name#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bring_email")>'#attributes.bring_email#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.doc_no")>'#attributes.doc_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bring_tel_no")>'#attributes.bring_tel_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bring_mobile_no")>'#attributes.bring_mobile_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bring_detail")>'#attributes.bring_detail#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.accessory") and len(attributes.accessory)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.accessory_detail") and isdefined("attributes.accessory") and len(attributes.accessory)>'#attributes.accessory_detail#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.related_company_id) and len(attributes.related_company)>#attributes.related_company_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.sales_add_option") and len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.is_salaried")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.ship_method") and len(attributes.ship_method) and len(attributes.ship_method_name)>#attributes.ship_method#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bring_ship_method_name") and len(attributes.bring_ship_method_name) and len(attributes.bring_ship_method_id)>#attributes.bring_ship_method_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.cus_help_id") and len(attributes.cus_help_id)>#attributes.cus_help_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.other_company_id") and len(attributes.other_company_id) and len(attributes.other_company_name)>#attributes.other_company_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.other_company_branch_id") and len(attributes.other_company_branch_id) and len(attributes.other_company_branch_name)>#attributes.other_company_branch_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.inside_detail_select") and len(attributes.inside_detail_select) and isdefined("attributes.guaranty_inside")>'#attributes.inside_detail_select#'<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.accessory_detail_select") and len(attributes.accessory_detail_select)>'#attributes.accessory_detail_select#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.appcat_sub_id") and len(attributes.appcat_sub_id)>#attributes.appcat_sub_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.appcat_sub_status_id") and len(attributes.appcat_sub_status_id)>#attributes.appcat_sub_status_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.service_work_groups") and len(attributes.service_work_groups)>#attributes.service_work_groups#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.call_service_id") and len(attributes.call_service_id)>#attributes.call_service_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id)>#attributes.sales_zone_id#<cfelse>NULL</cfif>,
                #now()#,
				#session.ep.userid#,
				<cfif len(attributes.task_person_name) and len(attributes.task_emp_id)>#attributes.task_emp_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.intervention_date') and len(attributes.intervention_date)>#attributes.intervention_date#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.finish_date1') and len(attributes.finish_date1)>#attributes.finish_date1#<cfelse>NULL</cfif>,
                <cfif isDefined("attributes.spec_main_id") and len(attributes.spec_main_id) and len(attributes.spect_name)>#attributes.spec_main_id#<cfelse>NULL</cfif>,
                <cfif isDefined("attributes.time_clock_hour") and len(attributes.time_clock_hour)>#attributes.time_clock_hour#<cfelse>NULL</cfif>,
                <cfif isDefined("attributes.time_clock_minute") and len(attributes.time_clock_minute)>#attributes.time_clock_minute#<cfelse>NULL</cfif>
			)
     </cfquery>
	<cfquery name="GET_SERVICE1" datasource="#DSN3#" maxrows="1">
		SELECT  
			RELATED_COMPANY_ID,
			SERVICE_ACTIVE,
            SERVICE_NO,
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
			SERVICE_COUNTY_ID,
			SERVICE_CITY_ID,
			SERVICE_COUNTY,
			SERVICE_CITY,
			SERVICE_CONSUMER_ID,
			NOTES,
			APPLY_DATE,
			START_DATE,
			SERVICE_PRODUCT_ID,
			SERVICE_DEFECT_CODE,
			APPLICATOR_NAME,
			PROJECT_ID,
			RECORD_DATE,
			RECORD_MEMBER,
			UPDATE_DATE,
			UPDATE_MEMBER,
			RECORD_PAR,
			UPDATE_PAR,
			OTHER_COMPANY_ID,
			SHIP_METHOD,
			SERVICE_ID,
            SERVICECAT_SUB_ID,
            SERVICECAT_SUB_STATUS_ID,
            WORKGROUP_ID,
            CALL_SERVICE_ID,
            INTERVENTION_DATE,
            FINISH_DATE,
            GUARANTY_INSIDE
		FROM 
			SERVICE 
		WHERE 
			RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND 
			SERVICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#system_paper_no#"> 
		ORDER BY 
			SERVICE_ID DESC
	</cfquery>
	</cftransaction>
</cflock>
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
            SERVICE_COUNTY_ID,
            SERVICE_CITY_ID,
            SERVICE_COUNTY,
            SERVICE_CITY,
            SERVICE_CONSUMER_ID,
            NOTES,
            APPLY_DATE,
            FINISH_DATE,
            START_DATE,
            SERVICE_PRODUCT_ID,
            SERVICE_DEFECT_CODE,
            APPLICATOR_NAME,
            PROJECT_ID,
            RECORD_DATE,
            RECORD_MEMBER,
            UPDATE_DATE,
            UPDATE_MEMBER,
            RECORD_PAR,
            UPDATE_PAR,
            OTHER_COMPANY_ID,
            SHIP_METHOD,
            SERVICE_ID,
            SERVICECAT_SUB_ID,
            SERVICECAT_SUB_STATUS_ID,
            WORKGROUP_ID,
            CALL_SERVICE_ID,
            INTERVENTION_DATE,
            GUARANTY_INSIDE
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
            <cfif len(get_service1.service_county_id)>#get_service1.service_county_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.service_city_id)>#get_service1.service_city_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.service_county)>'#get_service1.service_county#'<cfelse>NULL</cfif>,
            <cfif len(get_service1.service_city)>'#get_service1.service_city#'<cfelse>NULL</cfif>,
            <cfif len(get_service1.service_consumer_id)>#get_service1.service_consumer_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.notes)>'#get_service1.notes#'<cfelse>NULL</cfif>,
            <cfif len(get_service1.apply_date)>#createodbcdatetime(get_service1.apply_date)#<cfelse>NULL</cfif>,
            <cfif len(get_service1.finish_date)>#createodbcdatetime(get_service1.finish_date)#<cfelse>NULL</cfif>,
            <cfif len(get_service1.start_date)>#createodbcdatetime(get_service1.start_date)#<cfelse>NULL</cfif>,
            <cfif len(get_service1.service_product_id)>#get_service1.service_product_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.service_defect_code)>'#get_service1.service_defect_code#'<cfelse>NULL</cfif>,
            <cfif len(get_service1.applicator_name) and isdefined('get_service1.applicator_name')>'#get_service1.applicator_name#'<cfelse>NULL</cfif>,
            <cfif len(get_service1.project_id)>#get_service1.project_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.record_date)>#createodbcdatetime(get_service1.record_date)#<cfelse>NULL</cfif>,
            <cfif len(get_service1.record_member)>#get_service1.record_member#<cfelse>NULL</cfif>,
            <cfif len(get_service1.update_date)>#createodbcdatetime(get_service1.update_date)#<cfelse>NULL</cfif>,
            <cfif len(get_service1.update_member)>#get_service1.update_member#<cfelse>NULL</cfif>,
            <cfif len(get_service1.record_par)>#get_service1.record_par#<cfelse>NULL</cfif>,
            <cfif len(get_service1.update_par)>#get_service1.update_par#<cfelse>NULL</cfif>,
            <cfif len(get_service1.other_company_id)>#get_service1.other_company_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.ship_method)>#get_service1.ship_method#<cfelse>NULL</cfif>,						
            #get_service1.service_id#,
            <cfif len(get_service1.servicecat_sub_id)>#get_service1.servicecat_sub_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.servicecat_sub_status_id)>#get_service1.servicecat_sub_status_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.workgroup_id)>#get_service1.workgroup_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.call_service_id)>#get_service1.call_service_id#<cfelse>NULL</cfif>,
            <cfif len(get_service1.INTERVENTION_DATE)>#createodbcdatetime(get_service1.INTERVENTION_DATE)#<cfelse>NULL</cfif>,
            #get_service1.GUARANTY_INSIDE#
        )
</cfquery>
<cfif x_activity_time eq 1>
	<!--- MT:başvuru kaydedildiğinde zaman harcamasına kayıt atılıyor.--->
        <cfquery name="GET_SERVICE_CONTROL" datasource="#dsn3#">
            SELECT 
                TIME_CLOCK_HOUR,
                TIME_CLOCK_MINUTE,
                APPLY_DATE, <!---Başvuru tarihi--->
                <cfif len(attributes.company_id)>
                    SERVICE_COMPANY_ID,<!---Müşteri--->
                <cfelse>
                    SERVICE_CONSUMER_ID,<!---Müşteri--->
                </cfif>
                SUBSCRIPTION_ID,<!---Abone No--->
                PROJECT_ID,<!--- Proje --->
                SERVICE_HEAD,<!---Servis Konusu--->
                SERVICE_NO,	<!---Kaydedilen Servis--->
                SERVICE_ID
            FROM 
                SERVICE
            WHERE 
                SERVICE_ID = #my_result.identitycol#        
        </cfquery>
        <cfquery name="get_process_stage" datasource="#dsn#" maxrows="1">
            SELECT
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
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.time_cost%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
		<!---<cfset minute_ = LSNumberFormat(GET_SERVICE_CONTROL.TIME_CLOCK_MINUTE)>
        <cfset hour_ = LSNumberFormat(GET_SERVICE_CONTROL.TIME_CLOCK_HOUR)>--->
        <cfset minute_ = GET_SERVICE_CONTROL.TIME_CLOCK_MINUTE>
        <cfset hour_ = GET_SERVICE_CONTROL.TIME_CLOCK_HOUR>
        <cfset totalminute = hour_*60+minute_>
        <cfset totalhour = totalminute/60>
        <cfquery name="GET_TIME_COST" datasource="#dsn#">
            SELECT
                EXPENSED_MINUTE,
                TOTAL_TIME
            FROM
                TIME_COST
            WHERE
                SERVICE_ID = #GET_SERVICE_CONTROL.SERVICE_ID#
        </cfquery>
        <cfif attributes.time_clock_hour neq 0 or attributes.time_clock_minute neq 0>
            <cfquery name="ADD_TIME_COST" datasource="#dsn#">
                INSERT INTO TIME_COST
                (
                    ACTIVITY_ID,
                    EVENT_DATE,
                    <cfif len(attributes.company_id)>
                        COMPANY_ID,
                    <cfelse>
                        CONSUMER_ID,
                    </cfif>
                    SUBSCRIPTION_ID,
                    PROJECT_ID,
                    EMPLOYEE_ID,
                    EXPENSED_MINUTE,
                    TOTAL_TIME,
                    SERVICE_ID,
                    COMMENT,
                    TIME_COST_STAGE
                )
                VALUES
                (
                    <cfif len(attributes.ACTIVITY_ID)>#attributes.ACTIVITY_ID#<cfelse>NULL</cfif>,
                    <cfif len(GET_SERVICE_CONTROL.APPLY_DATE)>'#GET_SERVICE_CONTROL.APPLY_DATE#'<cfelse>NULL</cfif>,
                    <cfif len(attributes.company_id)>
                        #GET_SERVICE_CONTROL.SERVICE_COMPANY_ID#,
                    <cfelse>
                        #GET_SERVICE_CONTROL.SERVICE_CONSUMER_ID#,
                    </cfif>
                    <cfif len(GET_SERVICE_CONTROL.SUBSCRIPTION_ID)>#GET_SERVICE_CONTROL.SUBSCRIPTION_ID#<cfelse>NULL</cfif>,
                    <cfif len(GET_SERVICE_CONTROL.PROJECT_ID)>#GET_SERVICE_CONTROL.PROJECT_ID#<cfelse>NULL</cfif>,
                    #session.ep.userid#,
                    <cfif len(totalminute)>#totalminute#<cfelse>NULL</cfif>,
                    <cfif len(totalhour)>#totalhour#<cfelse>NULL</cfif>,
                    <cfif len(GET_SERVICE_CONTROL.SERVICE_ID)>#GET_SERVICE_CONTROL.SERVICE_ID#<cfelse>NULL</cfif>,
                    <cfif len(GET_SERVICE_CONTROL.SERVICE_HEAD)>'#GET_SERVICE_CONTROL.SERVICE_HEAD#'<cfelse>NULL</cfif>,
                    <cfif isdefined('get_process_stage.process_row_id') and len(get_process_stage.process_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#"><cfelse>NULL</cfif>
                )
            </cfquery>
		</cfif>            
    <!--- MT:başvuru kaydedildiğinde zaman harcamasına kayıt atılıyor.--->
</cfif>    
<cfif isdefined("attributes.service_work_groups") and len(attributes.service_work_groups)>
	<cfquery name="GET_WRK_EMPS" datasource="#DSN#">
    	SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service1.workgroup_id#"> ORDER BY HIERARCHY
    </cfquery>
    <cfloop query="get_wrk_emps">
    	<cfquery name="ADD_WRKGROUPS" datasource="#DSN3#">
            INSERT INTO 
                SERVICE_EMPLOYEES 
                (
                    EMPLOYEE_ID,
                    SERVICE_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP)
            	VALUES
                (
                    #employee_id#,
                    #get_service1.service_id#,
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.REMOTE_ADDR#'
                )
        </cfquery>
    </cfloop>
</cfif>	
<cfif isdefined("attributes.failure_code") and len(attributes.failure_code)>
	<cfloop list="#attributes.failure_code#" index="m">
		<cfquery name="ADD_SERVICE_CODE_ROWS" datasource="#DSN3#">
			INSERT INTO
				SERVICE_CODE_ROWS
			(
				SERVICE_CODE_ID,
				SERVICE_ID
			)				
			VALUES
			(
				#m#,
				#get_service1.service_id#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.event_id") and len(attributes.event_id)>
	<cfquery name="ADD_EVENT" datasource="#DSN#">
		INSERT INTO
			EVENTS_RELATED
		(
			EVENT_ID,
			ACTION_ID,
			ACTION_SECTION,
			COMPANY_ID,
			EVENT_TYPE
		)				
		VALUES
		(
			#attributes.event_id#,
			#get_service1.service_id#,
			'SERVICE_ID',
			#session.ep.company_id#,
			1
		)
	</cfquery>
</cfif>	
<cfif len(attributes.task_person_name) and len(attributes.task_emp_id) and isdefined("x_is_emp_workadd") and x_is_emp_workadd eq 1>
	<cfset attributes.service_id = get_service1.service_id>
	<cfset attributes.our_company_id = session.ep.company_id>
	<cfset attributes.is_mail = 1>
	<cfinclude template="../../project/query/add_work.cfm">
</cfif>
<!---Ek Bilgiler--->
<cfset attributes.info_id = my_result.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -15>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cf_workcube_process is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='SERVICE'
		action_column='SERVICE_ID'
		action_id='#get_service1.service_id#'
		action_page='#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service1.service_id#' 
		warning_description='Servis No : #system_paper_no#'
		paper_no='#system_paper_no#'>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service1.service_id#</cfoutput>';
</script>
