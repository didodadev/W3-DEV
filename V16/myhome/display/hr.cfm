<cfinclude template="../../rules/display/rule_menu.cfm">
<cfset get_shift_cmp = createObject("component","V16.hr.cfc.get_employee_shift")>
<cfset get_shift_employee = get_shift_cmp.GET_SHIF_EMPLOYEES_IN_OUT(
        employee_id : session.ep.userid
    )>
<div class="blog">
	<div id="hr_content">
			<div class="col col-12 col-xs-12">
				<div class="blog_title">
					<cfoutput><cf_get_lang dictionary_id='47630.İK İşlemleri'></cfoutput>	
				</div>
			</div>
			<cfif not listfindnocase(denied_pages,'myhome.my_extre')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.form_add_payment_request&event=add&is_installment=1">
							<div class="circleBox color-A">
								<i class="fa fa-money"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id = "30914.avans talebi">
							</div>
						</a>
						<div class="sub_desc"> 
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_extre"><cf_get_lang dictionary_id='59921.Önceki Talep ve Hesap Detayları'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfset kalan_izin = 0>
			<cfif not listfindnocase(denied_pages,'myhome.my_offtimes')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_offtimes&event=add&employee_id=<cfoutput>#session.ep.userid#&kalan_izin=#kalan_izin#</cfoutput>">
							<div class="circleBox color-E">
								<i class="fa fa-braille"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='32347.İzin Talebi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_offtimes"><cf_get_lang dictionary_id='59923.Önceki Talep ve İzinler'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.list_my_extra_times')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_extra_times&event=add">
							<div class="circleBox color-PM">
								<i class="fa fa-clock-o"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='59922.Fazla Mesai Talebi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_extra_times"><cf_get_lang dictionary_id='59924.Önceki Talepler ve Mesailer'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.flexible_worktime')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.flexible_worktime&event=add">
							<div class="circleBox color-HR">
								<i class="fa fa-hourglass"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id = "59800.Esnek Çalışma Talebi">
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.flexible_worktime"><cf_get_lang dictionary_id='59925.Önceki Talepler'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.employee_mandate')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.employee_mandate&event=add">
							<div class="circleBox color-V">
								<i class="fa fa-handshake-o"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='60283.Vekalet Ver'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.employee_mandate"><cf_get_lang dictionary_id='60284.Verilen Vekaletler ve Detaylar'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.allowance_expense')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.allowance_expense&event=add">
							<div class="circleBox color-CE">
								<i class="fa fa-cutlery"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='47809.Harcırah Talebi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.allowance_expense"><cf_get_lang dictionary_id='59925.Önceki Talepler'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.list_travel_demands')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_travel_demands&event=add">
							<div class="circleBox color-LM">
								<i class="fa fa-plane"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='59930.Seyahat Talebi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_travel_demands"><cf_get_lang dictionary_id='59928.Önceki Talepler ve Seyahatler'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.list_my_tranings')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_tranings&event=add">
							<div class="circleBox color-ER">
								<i class="fa fa-graduation-cap"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='59824.Eğitim Talebi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_tranings"><cf_get_lang dictionary_id='59929.Önceki Eğitimler ve Talepler'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.health_expense_approve')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.health_expense_approve&event=add">
							<div class="circleBox color-PO">
								<i class="fa fa-stethoscope"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='37614.Sağlık Harcama Talebi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.health_expense_approve"><cf_get_lang dictionary_id='59931.Önceki Sağlık Harcamaları'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.list_my_expense_requests')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_expense_requests&event=add">
							<div class="circleBox color-DE">
								<i class="fa fa-credit-card"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='58987.Harcama Talebi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_expense_requests"><cf_get_lang dictionary_id='59932.Önceki Harcama Talepleri'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.list_assetp')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_assetp&event=add">
							<div class="circleBox color-SU">
								<i class="fa fa-plug"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='59934.Ekipman Talebi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_assetp"><cf_get_lang dictionary_id='59933.Zimmetler ve Varlıklar'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.list_employee_detail_survey_form')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_employee_detail_survey_form">
							<div class="circleBox color-SU">
								<i class="fa fa-comment"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='29744.Değerlendirme Formları'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_employee_detail_survey_form"><cf_get_lang dictionary_id='29744.Değerlendirme Formları'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.list_employee_detail_survey_form') and get_shift_employee.recordcount>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_shifts">
							<div class="circleBox color-SU">
								<i class="fa fa-users"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='61206.Vardiyalarım'>
							</div>
						</a>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'myhome.list_my_pdks')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_pdks">
							<div class="circleBox color-PM">
								<i class="fa fa-paper-plane-o"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='31900.PDKS Durumu'>
							</div>
						</a>
					</div>
				</div>
			</cfif>
	</div>
</div>

	
    
<script type="text/javascript">
    
	<!--- En başta bulunduğumuz yılı ve değerlerini alsın --->
	loadAmounts(<cfoutput>#year(now())#</cfoutput>);
	function loadAmounts(selectedYear) {

		userid = <cfoutput>#session.ep.userid#</cfoutput>;
		var listParam = 1201 + "*" + userid + "*" + selectedYear;
		var total_amount_kdvli = wrk_safe_query('get_emp_health_expense','dsn2',0,listParam+"*_");
		<!--- TOTAL_AMOUNT_KDVLI --->
		if(total_amount_kdvli.TOTAL_AMOUNT != "") $("#total_expense").text(commaSplit(total_amount_kdvli.TOTAL_AMOUNT) + " TL");
		else $("#total_expense").text(commaSplit(0) + " TL");
		<!--- COMP_AMOUNT --->
		if(total_amount_kdvli.COMP_AMOUNT != "") $("#comp_amount").text(commaSplit(total_amount_kdvli.COMP_AMOUNT) + " TL");
		else $("#comp_amount").text(commaSplit(0) + " TL");
		<!--- EMP_AMOUNT --->
		if(total_amount_kdvli.EMP_AMOUNT != "") $("#emp_amount").text(commaSplit(total_amount_kdvli.EMP_AMOUNT) + " TL");
		else $("#emp_amount").text(commaSplit(0) + " TL");
		<!--- REL_AMOUNT --->
		var rel_amount = wrk_safe_query('get_emp_health_expense','dsn2',0,listParam+"*"+1);
		if(rel_amount.TOTAL_AMOUNT != "") $("#rel_amount").text(commaSplit(rel_amount.TOTAL_AMOUNT) + " TL");
		else $("#rel_amount").text(commaSplit(0) + " TL");
		<!--- REL_AMOUNT --->
		var self_amount = wrk_safe_query('get_emp_health_expense','dsn2',0,listParam+"*"+0);
		if(self_amount.TOTAL_AMOUNT != "") $("#self_amount").text(commaSplit(self_amount.TOTAL_AMOUNT) + " TL");
		else $("#self_amount").text(commaSplit(0) + " TL");
	}
</script>

<!--- mesai ve devamsızlık durumum sayfası düzenlenecek ve link değişebilir --->
<!--- yönlenecek sayfaların düzenlemeleri yaptıkca linkler değişebilir --->
<!-- yönetici kontrolleri yapılınca 2. col çıkmayacak ve 1. col col-12 olacak --->

