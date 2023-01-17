<cfinclude template="../../login/send_login.cfm">
<cfparam name="attributes.due_date_2" default="">
<cfparam name="attributes.action_date_1" default="">
<cfparam name="attributes.action_date_2" default="">
<cfparam name="attributes.other_money_2" default="">
<cfparam name="attributes.maxrows" default="#session.pp.maxrows#" />
<cfif not isdefined("attributes.is_camp_info")><cfset attributes.is_camp_info= 0></cfif>
<cfif not isdefined("attributes.is_make_age")><cfset attributes.is_make_age= 0></cfif>
<cfif not isdefined("attributes.is_process_type")><cfset attributes.is_process_type= 0></cfif>
<cfif not isdefined("attributes.is_camp_date")><cfset attributes.is_camp_date= 0></cfif>
<cfquery name="GET_CAMP_DATE" datasource="#DSN3#">
	SELECT 
		CAMP_STARTDATE,
		CAMP_FINISHDATE,
		CAMP_ID,
		CAMP_HEAD
	FROM 
		CAMPAIGNS 
	WHERE 
	<cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
        CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
    <cfelse>
        CAMP_STARTDATE < #now()# 
        AND CAMP_FINISHDATE > #now()#
    </cfif>
</cfquery>
<cfif get_camp_date.recordcount and not isdefined("attributes.camp_id")>
	<cfset attributes.camp_id = get_camp_date.camp_id>
	<cfset attributes.camp_name = get_camp_date.camp_head>
</cfif>
<cfif attributes.is_process_type eq 1>
	<cfset attributes.is_process_cat = 1>
</cfif>
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT 
		MONEY 
	FROM 
		SETUP_MONEY 
	WHERE 
		PERIOD_ID = <cfif isDefined("session.pp")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif> AND MONEY_STATUS = 1
</cfquery>
<cfif isDefined("session.pp")>
	<cfset session_base_money = session.pp.money>
	<cfset session_base_money2 = session.pp.money2>
<cfelse>
	<cfset session_base_money = session.ww.money>
	<cfset session_base_money2 = session.ww.money2>
</cfif>
<cfif isdefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
	<cf_date tarih = "attributes.due_date_2">
</cfif>
<cfif isdefined("attributes.action_date_1") and isdate(attributes.action_date_1)>
	<cf_date tarih = "attributes.action_date_1">
</cfif>
<cfif isdefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
	<cf_date tarih = "attributes.action_date_2">
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih = "attributes.date1">
	<cfset attributes.date1 = dateformat(attributes.date1,'dd/mm/yyyy') >
<cfelse>
	<cfif attributes.is_camp_date eq 1 and get_camp_date.recordcount>
		<cfset date1= dateformat(get_camp_date.camp_startdate,'dd/mm/yyyy')>
	<cfelse>
		<cfset date1="01/01/#session_base.period_year#">
	</cfif>
</cfif>
<cfif isdefined('attributes.date2') and isdate(attributes.date2)>
	<cf_date tarih = "attributes.date2">
	<cfset attributes.date2 = dateformat(attributes.date2,'dd/mm/yyyy') >
<cfelse>
	<cfif attributes.is_camp_date eq 1 and get_camp_date.recordcount>
		<cfset date2= dateformat(get_camp_date.camp_finishdate,'dd/mm/yyyy')>
	<cfelse>
		<cfset date2 = "31/12/#session_base.period_year#">
	</cfif>
</cfif>
<table class="table table-striped">
	<tr>
		<cfif isdefined("session_base.user_level")>		
			<td class="headbold"><cfoutput><cfif isdefined("session.pp")>#get_par_info(session.pp.company_id,1,0,0)#<cfelse>#get_cons_info(session.ww.userid,0,0)#</cfif></cfoutput> Hesap Dökümü</td>
			<td  nowrap style="text-align:right;"><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
		</cfif>
	</tr>
</table>
<cfif isDefined('session.pp.userid')>
	<cfset invoice_partner_link = "objects.popup_detail_invoice">
</cfif>
<cfset yilbasi = createodbcdatetime('#session_base.period_year#-01-01')>
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.other_money" default="">
<!-- sil -->
	<cfform name="list_ekstre" method="post" action="#GET_PAGE.FRIENDLY_URL#">
		<div class="form-row align-items-center">
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<input type="hidden" name="ap" id="ap" value="9">
			<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("session.pp")><cfoutput>#session.pp.company_id#</cfoutput></cfif>">
			<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("session.ww.userid")><cfoutput>#session.ww.userid#</cfoutput></cfif>">
			<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'employee'><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
			<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("session.pp")>partner<cfelse>consumer</cfif>">
			<input type="hidden" name="company" id="company" readonly="yes" value="<cfoutput><cfif isdefined("session.pp")>#get_par_info(session.pp.company_id,1,0,0)#<cfelse>#get_cons_info(session.ww.userid,0,0)#</cfif></cfoutput>">		
			<cfif attributes.is_camp_date eq 1>
				<div class="col-sm-2">
					<label class="sr-only" for="camp_name"><cf_get_lang_main no='34.Kampanya'></label>
					<div class="input-group">
						<input type="hidden" name="camp_id" id="camp_id" value="<cfif isdefined("attributes.camp_id")><cfoutput>#attributes.camp_id#</cfoutput></cfif>">
						<input type="text" name="camp_name" id="camp_name" class="form-control" readonly value="<cfif isdefined("attributes.camp_name")><cfoutput>#attributes.camp_name#</cfoutput></cfif>" style="width:200px;">
						<div class="input-group-text">
							<i class="fas fa-ellipsis-v" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_campaigns</cfoutput>&field_id=list_ekstre.camp_id&field_name=list_ekstre.camp_name&field_start_date=list_ekstre.date1&field_finish_date=list_ekstre.date2','list');"></i>
						</div>
					</div>
				</div>
			</cfif>
			<div class="col-auto pb-2">
				<label class="sr-only" for="camp_name"></label>
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang no='101.Baslangiç Tarihi Girmelisiniz !'></cfsavecontent>
					<cfinput type="text" name="date1" id="date1" class="form-control none-border-r" style=" width: 110px; " value="#date1#" required="yes" validate="eurodate" message="#message#">
					<div class="input-group-text append-icon">
						<cf_wrk_date_image date_field="date1">
					</div>
				</div>
			</div>				
			<div class="col-auto pb-2">
				<label class="sr-only" for="camp_name"></label>
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz !'></cfsavecontent>
					<cfinput type="text" name="date2" id="date2" class="form-control none-border-r" style=" width: 110px; " value="#date2#" required="yes" validate="eurodate" message="#message#">
					<div class="input-group-text append-icon">
						<cf_wrk_date_image date_field="date2">
					</div>
				</div>
			</div>
			<div class="col-auto pb-2">
				<label class="sr-only" for="camp_name"></label>
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" id="maxrows" class="form-control" value="#attributes.maxrows#" required="yes" validate="integer" range="1,500" message="#message#" maxlength="3" style="width:50px;">
			</div>
			<input type="hidden" name="due_date_2" id="due_date_2" value="">
			<input type="hidden" name="is_date_filter" id="is_date_filter" value="">
			<input type="hidden" name="due_date_1" id="due_date_1" value="">
			<input type="hidden" name="other_money_2" id="other_money_2" value="">
			<input type="hidden" name="action_date_1" id="action_date_1" value="">
			<input type="hidden" name="action_date_2" id="action_date_2" value="">
			<div class="col-auto">
				<input class="btn btn-color-2 mb-2" type="submit" value="<cf_get_lang dictionary_id='57650.Dök'>" onclick="kontrol();">
			</div>
		</div>		
	</cfform>  
<!-- sil --> 
<cfif isdefined('attributes.form_submit')>
	<cfif isdefined('session.pp')>
        <cfparam name="attributes.company_id" default="#session.pp.company_id#">
        <cfparam name="attributes.company" default="#get_par_info(session.pp.company_id,1,0,0)#">
		<cfset member_type ="partner">
	<cfelse>
		<cfset member_type ="consumer">
	</cfif>
	<cfquery name="GET_PERIODS" datasource="#DSN#">
		SELECT 
			PERIOD_ID,
			PERIOD_YEAR,
			OUR_COMPANY_ID
		FROM 
			SETUP_PERIOD 
		WHERE 
			OUR_COMPANY_ID = <cfif isDefined("session.pp")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"></cfif> AND
			PERIOD_YEAR >= #dateformat(attributes.date1,'yyyy')# AND 
            PERIOD_YEAR <= #dateformat(attributes.date2,'yyyy')#
		ORDER BY 
			OUR_COMPANY_ID,
			PERIOD_YEAR 
	</cfquery> 
	<cfif not get_periods.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='447.Dönem Kaydı Bulunmamaktadır'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
	<cfloop query="get_periods">
		<cfset new_period = get_periods.period_id>
		<cfset new_dsn = '#dsn#_#get_periods.period_year#_#get_periods.our_company_id#'>
		<cfif isdefined('attributes.form_submit')>	
			<cfquery name="CARI_ROWS" datasource="#new_dsn#">
				SELECT 
					ACTION_ID,
					ACTION_TYPE_ID,
					CARI_ACTION_ID,
					ACTION_TABLE,
					OTHER_MONEY,
					PAPER_NO,
					ACTION_NAME,
					PROCESS_CAT,
					TO_CMP_ID,
					TO_CONSUMER_ID,
					DUE_DATE,
					ACTION_DETAIL,
					ACTION_DATE AS ACTION_DATE, 
					0 AS BORC, 
					0 AS BORC2,
					0 AS BORC_OTHER,
					ACTION_VALUE AS ALACAK,
					ACTION_VALUE_2 AS ALACAK2,
					OTHER_CASH_ACT_VALUE AS ALACAK_OTHER,
					0 AS PAY_METHOD,
					IS_PROCESSED,
					(SELECT TOP 1 CAMP_HEAD FROM #dsn3_alias#.CAMPAIGNS CC WHERE CC.CAMP_STARTDATE <= CARI_ROWS.ACTION_DATE AND CC.CAMP_FINISHDATE >= CARI_ROWS.ACTION_DATE) AS CAMP_HEAD
				FROM 
					CARI_ROWS
                WHERE
					<cfif isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner'>
                        FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
                    <cfelseif isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer'>
                        FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
                    <cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
                        FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
                    </cfif>
                    <cfif isDefined("attributes.action_type") and len(attributes.action_type)>
                        ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"> AND 
                    </cfif>
                    <cfif isDefined("attributes.other_money") and len(attributes.other_money)>
                        OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#"> AND 
                    </cfif>
					1=1				
                UNION
				
                SELECT
					ACTION_ID,
					ACTION_TYPE_ID,
					CARI_ACTION_ID,
					ACTION_TABLE,
					OTHER_MONEY,
					PAPER_NO,
					ACTION_NAME,
					PROCESS_CAT,
					TO_CMP_ID,
					TO_CONSUMER_ID,
					DUE_DATE,
					ACTION_DETAIL,
					ACTION_DATE AS ACTION_DATE, 
					ACTION_VALUE AS BORC,
					ACTION_VALUE_2 AS BORC2,
					OTHER_CASH_ACT_VALUE AS BORC_OTHER,
					0 AS ALACAK,
					0 AS ALACAK2,
					0 AS ALACAK_OTHER,
					0 AS PAY_METHOD,
					IS_PROCESSED,
					(SELECT TOP 1 CAMP_HEAD FROM #dsn3_alias#.CAMPAIGNS CC WHERE CC.CAMP_STARTDATE <= CARI_ROWS.ACTION_DATE AND CC.CAMP_FINISHDATE >= CARI_ROWS.ACTION_DATE) AS CAMP_HEAD
				FROM 
					CARI_ROWS
                WHERE
					<cfif isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner'>
						TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
					<cfelseif isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer'>
						TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
					<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
						TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
					</cfif>
					<cfif isDefined("attributes.action_type") and len(attributes.action_type)>
						ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"> AND
					</cfif>
					<cfif isDefined("attributes.other_money") and len(attributes.other_money)>
						OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#">  AND
					</cfif>
					1=1 
				ORDER BY
					ACTION_DATE,
					ACTION_ID
			</cfquery>
			<cfquery name="CARI_ROWS_ALL" dbtype="query">
				SELECT
					ACTION_ID,
					ACTION_TYPE_ID,
					CARI_ACTION_ID,
					ACTION_TABLE,
					OTHER_MONEY,
					PAPER_NO,
					ACTION_NAME,
					PROCESS_CAT,
					TO_CMP_ID,
					TO_CONSUMER_ID,
					DUE_DATE,
					ACTION_DETAIL,
					ACTION_DATE, 
					BORC,
					BORC2,
					BORC_OTHER,
					ALACAK,
					ALACAK2,
					ALACAK_OTHER,
					PAY_METHOD,
					IS_PROCESSED,
					CAMP_HEAD
				FROM 
					CARI_ROWS
				WHERE
					ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> 
				<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                    AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
			</cfquery>
		<cfelse>
			<cfset cari_rows_all.recordcount = 0>
		</cfif>
		<cfif isdefined('attributes.is_excel')>
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows=cari_rows_all.recordcount>
		</cfif>	
		<cfparam name="attributes.page" default = "1">
		<cfparam name="attributes.totalrecords" default = "#cari_rows_all.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		
		<cfif isdefined('attributes.is_excel')>
			<cfset filename = "#createuuid()#">
			<cfheader name="Expires" value="#Now()#">
			<cfcontent type="application/vnd.msexcel;charset=utf-8">
			<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
			<meta http-equiv="content-type" content="text/plain; charset=utf-8">
		</cfif>	

			<h5 class="mb-4"><cfoutput><cfif isdefined ('attributes.company') and len(attributes.company)>#attributes.company#</cfif> #get_periods.period_year#</cfoutput> <cf_get_lang dictionary_id='34435.Dönemi'> <cf_get_lang_main no='397.Hesap Ekstresi'></h5>			
			<div class="table-responsive">
				<table class="table">
					<thead>
						<tr class="color-header main-bg-color" style="height:22px;">
							<th class="form-title"><cf_get_lang_main no='75.No'></th>
							<th class="form-title"><cf_get_lang_main no='330.Tarih'></th>
							<cfif isdefined('attributes.is_due_date') and attributes.is_due_date eq 1>
								<th class="form-title"><cf_get_lang no='117.Ortalama'><cf_get_lang_main no='228.Vade'></th>
							</cfif>
							<cfif isdefined('attributes.is_paper_no') and attributes.is_paper_no eq 1> 
								<th class="form-title"><cf_get_lang_main no='56.Belge'></th>
							</cfif>
							<th class="form-title"><cf_get_lang_main no='280.İşlem'></th>
							<th  class="form-title" style="text-align:right;"><cf_get_lang_main no='175.Borç'></th>
							<th  class="form-title" style="text-align:right;"><cf_get_lang_main no='176.Alacak'></th>
							<th  class="form-title" style="text-align:right;"><cf_get_lang_main no='177.Bakiye'></th>
						</tr>
					
						<cfset money_list_borc_2 = ''>
						<cfset money_list_borc_1 = ''>
						<cfset money_list_alacak_2 = ''>
						<cfset money_list_alacak_1 = ''>
						<cfscript>
							devir_total = 0;
							devir_borc = 0;
							devir_alacak = 0;
							bakiye = 0;
							devir_total_2 = 0;
							devir_borc_2 = 0;
							devir_alacak_2 = 0;
							bakiye_2 = 0;
							gen_borc_top = 0;
							gen_ala_top = 0;
							gen_bak_top = 0;
							gen_bak_top_2 = 0;
							gen_borc_top_2 = 0;
							gen_ala_top_2 = 0;
							gen_borc_top_other = 0;
							gen_ala_top_other = 0;
						</cfscript>	
						<cfoutput query="get_money">
							<cfset 'devir_borc_#money#' = 0>
							<cfset 'devir_alacak_#money#' = 0>
						</cfoutput>
						<cfif datediff('d',yilbasi,date1) neq 0>
							<cfquery name="GET_TARIH_DEVIR" dbtype="query">
								SELECT
									SUM(BORC) BORC,
									SUM(ALACAK) ALACAK,
									SUM(BORC-ALACAK) DEVIR_TOTAL,
									SUM(BORC2) BORC2,

									SUM(ALACAK2) ALACAK2,
									SUM(BORC2-ALACAK2) DEVIR_TOTAL2
								FROM
									CARI_ROWS
								WHERE
									ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
							</cfquery>
							<cfif get_tarih_devir.recordcount>
								<cfset devir_borc = get_tarih_devir.borc>
								<cfset devir_alacak = get_tarih_devir.alacak>
								<cfset devir_total = get_tarih_devir.devir_total>
								<cfset devir_borc_2 = get_tarih_devir.borc2>
								<cfset devir_alacak_2 = get_tarih_devir.alacak2>
								<cfset devir_total_2 = get_tarih_devir.devir_total2>
							</cfif>
						</cfif>
						<cfif attributes.page gt 1>
							<cfset max_=(attributes.page-1)*attributes.maxrows>
							<cfoutput query="cari_rows_all" startrow="1" maxrows="#max_#">
								<cfset devir_borc = devir_borc + borc>
								<cfset devir_alacak = devir_alacak + alacak>
								<cfset devir_total = devir_borc - devir_alacak>
								<cfif len(borc2)><cfset devir_borc_2 = devir_borc_2 + borc2></cfif>
								<cfif len(alacak2)><cfset devir_alacak_2 = devir_alacak_2 + alacak2></cfif>
								<cfset devir_total_2 = devir_borc_2 - devir_alacak_2>
								<cfset 'devir_borc_#other_money#' = evaluate('devir_borc_#other_money#') +borc_other>
								<cfset 'devir_alacak_#other_money#' = evaluate('devir_alacak_#other_money#') +alacak_other>
							</cfoutput>
						</cfif>
						<cfoutput>
							<cfif (isdefined('attributes.is_paper_no') and attributes.is_paper_no eq 1) and (isdefined('attributes.is_due_date') and attributes.is_due_date eq 1)>
								<cfset col_say = 5>
							<cfelseif (not isdefined('attributes.is_paper_no') or (isdefined('attributes.is_paper_no') and attributes.is_paper_no neq 1)) and (not isdefined('attributes.is_due_date') or (isdefined('attributes.is_due_date') and attributes.is_due_date neq 1))>
								<cfset col_say = 3>
							<cfelse>
								<cfset col_say = 4>
							</cfif>
							<tr class="color-row" style="height:20px;">
								<td colspan="#col_say#"  style="text-align:right;"><b><cf_get_lang_main no='452.Devir'></b></td>
								<td  style="text-align:right;">#TLFormat(devir_borc)# #session_base.money#</td>
								<td  style="text-align:right;">#TLFormat(devir_alacak)# #session_base.money#</td>
								<td  style="text-align:right;">#TLFormat(ABS(devir_total))# #session_base.money# <cfif devir_borc gt devir_alacak>-B<cfelseif devir_borc lt devir_alacak>-A</cfif></td> 
							</tr>
						</cfoutput>
					</thead>
					<cfif cari_rows_all.recordcount>
						<!--- banka talimatlarındaki odeme tarihine gore listelemek icin--->
						<cfset bank_order_list="">
						<cfoutput query="cari_rows_all">
							<cfif (cari_rows_all.action_type_id eq 260)>
								<cfset bank_order_list=listappend(bank_order_list,cari_rows_all.action_id)>
							</cfif>
						</cfoutput>
						<cfif len(bank_order_list)>
							<cfset bank_order_list=listsort(bank_order_list,"numeric","desc",",")>
							<cfquery name="GET_BANK_ORDER" datasource="#new_dsn#">
								SELECT 
									BANK_ORDER_ID,
									PAYMENT_DATE
								FROM
									BANK_ORDERS
								WHERE
									BANK_ORDER_ID IN (#bank_order_list#)
								ORDER BY
									BANK_ORDER_ID DESC
							</cfquery>
						</cfif>
						<!--- //banka talimatlarındaki odeme tarihine gore listelemek icin --->
						<cfif get_periods.recordcount eq 1><!--- tek donem kaydi dokumu alinirsa sayfalama yapmak icin konuldu. (2 donem arasi kayitlar alinirsa alt alta listelenir. ) --->
							<cfset process_cat_id_list = ''><!--- islem tipi  --->
							<cfif isdefined('attributes.is_process_cat')><!--- islem tipi seçilmişse --->
								<cfoutput query="cari_rows_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
									<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
										<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
									</cfif>
								</cfoutput>  	
								<cfif len(process_cat_id_list)>
									<cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
									<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
										SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
									</cfquery>
									<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.process_cat_id,',')),'numeric','ASC',',')>
								</cfif>
							</cfif>
							<tbody>
								<cfoutput query="cari_rows_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
									<cfif len(borc_other)>
										<cfset bakiye_borc_2 = borc_other>
										<cfset bakiye_borc_1 = borc>
									<cfelse>
										<cfset bakiye_borc_2 = 0>
										<cfset bakiye_borc_1 = 0>
									</cfif>
									<cfif len(alacak_other)>
										<cfset bakiye_alacak_2 = alacak_other>
										<cfset bakiye_alacak_1 = alacak>
									<cfelse>
										<cfset bakiye_alacak_2 = 0>
										<cfset bakiye_alacak_1 = 0>
									</cfif>
									<cfset money_2 = other_money>
									<cfset money_1 = session_base.money>
									<cfif bakiye_borc_2 gt 0>
										<cfset money_list_borc_2 = listappend(money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
										<cfset money_list_borc_1 = listappend(money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
									</cfif>	
									<cfif bakiye_alacak_2 gt 0>
										<cfset money_list_alacak_2 = listappend(money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
										<cfset money_list_alacak_1 = listappend(money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
									</cfif>
									<cfset type="">
									<cfswitch expression = "#action_type_id#">
										<cfcase value="40"><!--- cari acilis fisi --->
											<cfset type="objects2.popup_dsp_account_open&period_id=#encrypt(encrypt(get_periods.period_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="24"><!--- gelen havale --->
											<cfset type="objects2.popup_dsp_gelenh&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="25"><!--- giden havale --->
											<cfset type="objects2.popup_dsp_gidenh&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="34"><!---alış f. kapama--->
											<cfset type="objects2.popup_dsp_alisf_kapa&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="35"><!---satış f. kapama--->
											<cfset type="objects2.popup_dsp_satisf_kapa&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="241"><!--- kredi kartı tahsilat --->
											<cfset type="objects2.popup_dsp_credit_card_payment_type">
										</cfcase>
										<cfcase value="242"><!--- kredi karti odeme --->
											<cfset type="objects2.popup_dsp_credit_card_pay&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="245"><!--- kredi kartı tahsilat --->
											<cfset type="objects2.popup_dsp_credit_card_payment_type">
										</cfcase>
										<cfcase value="31"><!---tahsilat--->
											<cfset type="objects2.popup_dsp_cash_revenue&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="32"><!---ödeme--->
											<cfset type="objects2.popup_dsp_cash_payment&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<!--- BK kaldirdi 20130912 6 aya kaldirilsin <cfcase value="36">
											<cfset type="objects2.popup_list_cash_expense&period_id=#encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase> --->	
										<cfcase value="41,42"><!--- borc/alacak dekontu --->
											<cfset type="objects2.popup_dsp_debt_claim_note&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="43"><!--- cari virman --->
											<cfset type="objects2.popup_dsp_cari_to_cari&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="90"><!--- çek giriş bordrosu --->
											<cfset type="objects2.popup_dsp_payroll_entry&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="91"><!--- çek çıkış bordrosu(ciro) --->
											<cfset type="objects2.popup_dsp_payroll_endorsement&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="94"><!--- Çek İade çıkış bordrosu --->
											<cfset type="objects2.popup_dsp_payroll_endor_return&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="95"><!--- Çek iade giriş bordrosu --->
											<cfset type="objects2.popup_dsp_payroll_entry_return&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="98,101,97,108"><!--- Senet Çıkış bordrosu --->
											<cfset type="objects2.popup_dsp_voucher_endorsement&type=#action_type_id#&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="120"><!--- masraf fisi --->
											<cfset type="objects2.popup_list_cost_expense&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="121"><!--- gelir fisi --->
											<cfset type="objects2.popup_list_cost_expense&is_income=1&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<cfcase value="50,51,52,53,531,54,55,56,57,58,59,591,60,61,62,63,64,65,66,690,601,561,48,49">
											<cfset type="objects2.popup_detail_invoice&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
										<!--- Gelen ve Giden Banka Talimatı --->
										<cfcase value="260,251">
											<cfset type="objects2.popup_dsp_assign_order&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
										</cfcase>
									</cfswitch>		
									<cfif listfind('24,25,26,27,31,32,34,35,40,41,42,43,241,242,177,245,250,260,251',action_type_id,',')>
										<cfset page_type = 'small'>
									<cfelse>
										<cfset page_type = 'page'>
									</cfif>
									<tr>
										<td>#currentrow#</td>
										<td>#dateformat(action_date,'dd/mm/yyyy')#</td>
										<cfif isdefined('attributes.is_due_date') and attributes.is_due_date eq 1>
											<td>#dateformat(due_date,'dd/mm/yyyy')#</td>
										</cfif>
										<cfif isdefined('attributes.is_paper_no') and attributes.is_paper_no eq 1>
											<td>#paper_no# <cfif attributes.is_camp_info eq 1 and len(camp_head) and action_table is 'invoice'>(#camp_head#)</cfif></td>
										</cfif>
										<td>
											<cfif not len(type)><!--- display sayfası olmayan tipler için --->
												#action_name#
												<cfif isdefined('attributes.is_action_detail')><td>#action_detail#</td></cfif>
											<cfelse>
												<cfif listfind("291,292",action_type_id)><!--- Kredi Odemesi ,Kredi Tahsilat --->
													<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#&period_id=#session.ep.period_id#&our_company_id=#session.ep.company_id#','#page_type#');">
												<cfelseif action_table is 'cheque'>
													<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_cheque_det&id=#encrypt(encrypt(action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#','small')">
												<cfelse>
													<a class="tableyazi" href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=#type#&id=#encrypt(encrypt(action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#&cari_act_id=#encrypt(encrypt(cari_action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#&table_name=#action_table#','#page_type#');">
												</cfif>
												<cfif isdefined('attributes.is_process_cat')>
													<cfif listfind(process_cat_id_list,process_cat,',')>
														#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
													<cfelse>
														#action_name#
													</cfif>
												<cfelse>
													#action_name#
												</cfif>
												</a>
											</cfif>
										</td>
										<td  style="text-align:right;">#TLFormat(borc)# #session_base.money#</td>
										<td  style="text-align:right;">#TLFormat(alacak)# #session_base.money#</td>
										<td  style="text-align:right;">
											<cfif (currentrow mod attributes.maxrows) eq 1>
												<cfset bakiye = devir_total + borc - alacak>
												<cfset gen_borc_top = devir_borc + borc + gen_borc_top>
												<cfset gen_ala_top = devir_alacak + alacak + gen_ala_top>
												<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = devir_total_2 + borc2 - alacak2></cfif>
												<cfif len(borc2)><cfset gen_borc_top_2 = devir_borc_2 + borc2 + gen_borc_top_2></cfif>
												<cfif len(alacak2)><cfset gen_ala_top_2 = devir_alacak_2 + alacak2 + gen_ala_top_2></cfif>
											<cfelse>
												<cfset bakiye = borc - alacak >
												<cfset gen_borc_top = borc + gen_borc_top>
												<cfset gen_ala_top = alacak + gen_ala_top>
												<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = borc2 - alacak2></cfif>
												<cfif len(borc2)><cfset gen_borc_top_2 = borc2 + gen_borc_top_2></cfif>
												<cfif len(alacak2)><cfset gen_ala_top_2 = alacak2 + gen_ala_top_2></cfif>
											</cfif>
											<cfset gen_bak_top = bakiye + gen_bak_top>
											<cfset gen_bak_top_2 = bakiye_2 + gen_bak_top_2>
											#TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0>- B<cfelse>- A</cfif>
										</td>
									</tr>
								</cfoutput>
							</tbody>
						<cfelse> <!--- get_periods.recordcount neq 1 (2 donem kaydi aliniyorsa(2005-2006))--->
							<cfoutput query="cari_rows_all">		  	
								<cfset type="">
								<cfswitch expression = "#action_type_id#">
									<cfcase value="40"><!--- cari acilis fisi --->
										<cfset type="objects2.popup_dsp_account_open&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="24"><!--- gelen havale --->
										<cfset type="objects2.popup_dsp_gelenh&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="25"><!--- giden havale --->
										<cfset type="objects2.popup_dsp_gidenh&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="34"><!---alış f. kapama--->
										<cfset type="objects2.popup_dsp_alisf_kapa&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="35"><!---satış f. kapama--->
										<cfset type="objects2.popup_dsp_satisf_kapa&period_id=#new_period#">
									</cfcase>
									<cfcase value="241"><!--- kredi kartı tahsilat --->
										<cfset type="objects2.popup_dsp_credit_card_payment_type">
									</cfcase>
									<cfcase value="242"><!--- kredi karti odeme --->
										<cfset type="objects2.popup_dsp_credit_card_pay&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="245"><!--- kredi kartı tahsilat --->
										<cfset type="objects2.popup_dsp_credit_card_payment_type">
									</cfcase>
									<cfcase value="31"><!---tahsilat--->
										<cfset type="objects2.popup_dsp_cash_revenue&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="32"><!---ödeme--->
										<cfset type="objects2.popup_dsp_cash_payment&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="41,42"><!--- borc/alacak dekontu --->
										<cfset type="objects2.popup_dsp_debt_claim_note&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="43"><!--- cari virman --->
										<cfset type="objects2.popup_dsp_cari_to_cari&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="90"><!--- çek giriş bordrosu --->
										<cfset type="objects2.popup_dsp_payroll_entry&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="91"><!--- çek çıkış bordrosu(ciro) --->
										<cfset type="objects2.popup_dsp_payroll_endorsement&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="94"><!--- Çek İade çıkış bordrosu --->
										<cfset type="objects2.popup_dsp_payroll_endor_return&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="95"><!--- Çek iade giriş bordrosu --->
										<cfset type="objects2.popup_dsp_payroll_entry_return&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="120"><!--- masraf fisi --->
										<cfset type="objects2.popup_list_cost_expense&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="121"><!--- gelir fisi --->
										<cfset type="objects2.popup_list_cost_expense&is_income=1&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="50,51,52,53,531,54,55,56,57,58,59,591,60,61,62,63,64,65,66,690"><!--- Gelen ve Giden Banka Talimatı --->
										<cfset type="objects2.popup_detail_invoice&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
									<cfcase value="260,251">
										<cfset type="objects2.popup_dsp_assign_order&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
									</cfcase>
								</cfswitch>		
								<cfif listfind('24,25,26,27,31,32,34,35,40,41,42,43,241,242,177,250,260,245,251',action_type_id,',')>
									<cfset page_type = 'small'>
								<cfelse>
									<cfset page_type = 'page'>
								</cfif>
								<cfif len(borc_other)>
									<cfset bakiye_borc_2 = borc_other>
									<cfset bakiye_borc_1 = borc>
								<cfelse>
									<cfset bakiye_borc_2 = 0>
									<cfset bakiye_borc_1 = 0>
								</cfif>
								<cfif len(alacak_other)>
									<cfset bakiye_alacak_2 = alacak_other>
									<cfset bakiye_alacak_1 = alacak>
								<cfelse>
									<cfset bakiye_alacak_2 = 0>
									<cfset bakiye_alacak_1 = 0>
								</cfif>
								<cfset money_2 = other_money>
								<cfset money_1 = session_base.money>
								<cfif bakiye_borc_2 gt 0>
									<cfset money_list_borc_2 = listappend(money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
									<cfset money_list_borc_1 = listappend(money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
								</cfif>	
								<cfif bakiye_alacak_2 gt 0>
									<cfset money_list_alacak_2 = listappend(money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
									<cfset money_list_alacak_1 = listappend(money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
								</cfif>	
								<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
									<td>#currentrow#</td>
									<td>#dateformat(action_date,'dd/mm/yyyy')#</td>
									<td>#paper_no# <cfif attributes.is_camp_info eq 1 and len(camp_head) and action_table is 'invoice'>(#camp_head#)</cfif></td>
									<td>
										<cfif not len(type)><!--- display sayfası olmayan tipler için --->
											#action_name#
										<cfelse>
											<cfif listfind("291,292",action_type_id)><!--- Kredi Odemesi ,Kredi Tahsilat --->
												<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#&period_id=#session.ep.period_id#&our_company_id=#session.ep.company_id#','#page_type#');">
											<cfelseif action_table is 'cheque'>
												<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_cheque_det&id=#encrypt(encrypt(action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#','small')">
											<cfelse>
												<a class="tableyazi" href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=#type#&id=#encrypt(encrypt(action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#&cari_act_id=#encrypt(encrypt(cari_action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#&table_name=#action_table#','#page_type#');">
											</cfif>
												#action_name#
											</a>
										</cfif>
									</td>
									<td  style="text-align:right;">
										#TLFormat(borc)# #session_base.money#
									</td>
									<td  style="text-align:right;">
										#TLFormat(alacak)# #session_base.money#
									</td>
									<td  style="text-align:right;">
										<cfif (currentrow mod attributes.maxrows) eq 1>
											<cfset bakiye = devir_total + borc - alacak>
											<cfset gen_borc_top = devir_borc + borc + gen_borc_top>
											<cfset gen_ala_top = devir_alacak + alacak + gen_ala_top>
											<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = devir_total_2 + borc2 - alacak2></cfif>
											<cfif len(borc2)><cfset gen_borc_top_2 = devir_borc_2 + borc2 + gen_borc_top_2></cfif>
											<cfif len(alacak2)><cfset gen_ala_top_2 = devir_alacak_2 + alacak2 + gen_ala_top_2></cfif>
										<cfelse>
											<cfset bakiye = borc - alacak >
											<cfset gen_borc_top = borc + gen_borc_top>
											<cfset gen_ala_top = alacak + gen_ala_top>
											<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = borc2 - alacak2></cfif>
											<cfif len(borc2)><cfset gen_borc_top_2 = borc2 + gen_borc_top_2></cfif>
											<cfif len(alacak2)><cfset gen_ala_top_2 = alacak2 + gen_ala_top_2></cfif>
										</cfif>
										<cfset gen_bak_top = bakiye + gen_bak_top>
										<cfset gen_bak_top_2 = bakiye_2 + gen_bak_top_2>
										#TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0>- B<cfelse>- A</cfif>
									</td>
								</tr>
							</cfoutput>
						</cfif>
						<tfoot>
							<tr class="color-row" style="height:20px;">
								<td colspan="<cfoutput>#col_say#</cfoutput>"  style="text-align:right;"><b><cf_get_lang_main no='268.Genel Toplam'></b></td>
								<td  style="text-align:right;"><cfoutput>#TLFormat(gen_borc_top)# #session_base.money#</cfoutput></td>
								<td  style="text-align:right;"><cfoutput>#TLFormat(gen_ala_top)# #session_base.money#</cfoutput></td>
								<td  style="text-align:right;"> 
									<cfoutput>
										#TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0> -B<cfelse> -A</cfif>
									</cfoutput>
								</td>
							</tr>
						</tfoot>		  	       
					</cfif>
				</table>
			</div>		
	</cfloop>
	<cfif isdefined("session.ww.userid")>
		<cfset session_base.company_id = session.ww.our_company_id>
	</cfif>
</cfif>
<cfif isDefined("attributes.totalrecords") and attributes.totalrecords gt attributes.maxrows>
	<div class="card">
		<div class="card-header"></div>
		<div class="card-body">
			<table class="table table-striped">
				<tr> 
					<td>
						<cfset adres="#GET_PAGE.FRIENDLY_URL#">
						<cfset adres = adres & "&date1=#dateformat(attributes.date1,'dd/mm/yyyy')#">					
						<cfset adres = "#adres#&date2=#dateformat(attributes.date2,'dd/mm/yyyy')#">
						<cfif isdefined("attributes.company_id")>
							<cfset adres = adres & "&company_id=#attributes.company_id#">					
						</cfif>
						<cfif isdefined("attributes.consumer_id")>
							<cfset adres = adres & "&consumer_id=#attributes.consumer_id#">					
						</cfif>
						<cfif isdefined("attributes.form_submit")>
							<cfset adres = "#adres#&form_submit=#attributes.form_submit#">
						</cfif>
						<cfif isdefined("attributes.company") and len(attributes.company)>
							<cfset adres = "#adres#&company=#attributes.company#">
						</cfif>
						<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
							<cfset adres = "#adres#&employee_id=#attributes.employee_id#">
						</cfif>
						<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
							<cfset adres = "#adres#&member_type=#attributes.member_type#">
						</cfif>
						<cfif isdefined("attributes.action_type") and len(attributes.action_type)>
							<cfset adres = "#adres#&action_type=#attributes.action_type#">
						</cfif>
						<cfif isdefined("attributes.other_money")>
							<cfset adres = "#adres#&other_money=#attributes.other_money#">
						</cfif>
						<cf_pages page="#attributes.page#" 
							maxrows="#attributes.maxrows#"
							totalrecords="#attributes.totalrecords#"
							startrow="#attributes.startrow#"
							adres="#adres#"> 
					</td>
					<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
				</tr>
			</table>
		</div>
	</div>
</cfif>  
<cfif isdefined('attributes.form_submit') and attributes.is_make_age eq 1>
	<cfset attributes.is_ajax_popup = 1>
	<cfset attributes.action_date_1 = attributes.date1>
	<cfset attributes.action_date_2 = attributes.date2>
	<cfinclude template="../../../objects/display/dsp_make_age_manuel.cfm">	
</cfif>
<script type="text/javascript">
	function kontrol()
	{	
		if((document.getElementById('company').value.length == 0))
		{
			document.getElementById('company_id').value = '';
			document.getElementById('consumer_id').value = '';
			document.getElementById('employee_id').value = '';
		}
		if( (document.getElementById('company_id').value == "")&&(document.getElementById('consumer_id').value == "") && (document.getElementById('company').value == "") &&(document.getElementById('employee_id').value == ""))
		{ 
			alert ("<cf_get_lang no='122.Cari Hesap Seçiniz veya Çalışan Hesap Seçiniz'>!");
			return false;
		}
		return date_diff(document.list_ekstre.date1,document.list_ekstre.date2,1,'<cf_get_lang_main no ="394.Tarih Aralığını Kontrol Ediniz">!');
	}
</script>