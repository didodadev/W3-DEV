<cfparam name="attributes.module_id_control" default="16">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.MONEY_TYPE" default="#session.ep.money#">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.buyer_seller" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.fatura_startdate" default="">
<cfparam name="attributes.fatura_finishdate" default="">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
<cfif isdefined("attributes.finishdate") and  isdate(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
<cfif isdefined("attributes.fatura_startdate") and isdate(attributes.fatura_startdate)><cf_date tarih="attributes.fatura_startdate"></cfif>
<cfif isdefined("attributes.fatura_finishdate") and  isdate(attributes.fatura_finishdate)><cf_date tarih="attributes.fatura_finishdate"></cfif>
<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT MONEY_ID, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
<cfquery name="get_our_companies" datasource="#dsn#">
	SELECT 
		DISTINCT
		SP.OUR_COMPANY_ID
	FROM
		EMPLOYEE_POSITIONS EP,
		SETUP_PERIOD SP,
		EMPLOYEE_POSITION_PERIODS EPP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID AND
		EP.EMPLOYEE_ID = #session.ep.userid#
</cfquery>

<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	SELECT 
		DISTINCT
		CT.COMPANYCAT_ID, 
		CT.COMPANYCAT
	FROM
		COMPANY_CAT CT,
		COMPANY_CAT_OUR_COMPANY CO
	WHERE
		CT.COMPANYCAT_ID = CO.COMPANYCAT_ID AND
		CO.OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#)
	ORDER BY
		COMPANYCAT
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_pay_list" datasource="#dsn2#">
		SELECT 
				<cfif isdefined("attributes.is_temsilci")>
				EP.EMPLOYEE_NAME,
				EP.EMPLOYEE_SURNAME,
				</cfif>
				MAIN_GET_CLOSED.*,
				C.FULLNAME,
				C.MEMBER_CODE,
				CC.COMPANYCAT,
				(	SELECT
						POSITION_CODE 
					FROM
						#dsn_alias#.WORKGROUP_EMP_PAR
					WHERE
						IS_MASTER=1 AND
						OUR_COMPANY_ID = #session.ep.company_id# AND 
						COMPANY_ID = C.COMPANY_ID AND
						COMPANY_ID IS NOT NULL
				) TEM_POSITION_CODE
			FROM 
			(
				SELECT
					CR.ACTION_NAME,
					CR.ACTION_ID,
					CR.PAPER_NO,
					CR.ACTION_TYPE_ID,
					CR.TO_CMP_ID,
					CR.FROM_CMP_ID,
                    <cfif attributes.money_type neq session.ep.money>
                    	ROUND(CR.OTHER_CASH_ACT_VALUE,2) ACTION_VALUE,
                    <cfelse>
						ROUND(CR.ACTION_VALUE,2) ACTION_VALUE, 
                    </cfif>
					CR.ACTION_DATE,
					CR.DUE_DATE,
					CR.OTHER_MONEY,
					ROUND(SUM(ICR.CLOSED_AMOUNT),2) TOTAL_CLOSED_AMOUNT,
					ROUND(SUM(ICR.OTHER_CLOSED_AMOUNT),2) OTHER_CLOSED_AMOUNT,
					ICR.OTHER_MONEY I_OTHER_MONEY
				FROM 
					CARI_ROWS CR,
					CARI_CLOSED_ROW ICR,
					CARI_CLOSED
				WHERE
					ROUND(CR.ACTION_VALUE,2) >= 1 AND
					CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID AND
					CARI_CLOSED.COMPANY_ID = CR.TO_CMP_ID AND
					CR.ACTION_TYPE_ID NOT IN (48,49,45,46) AND
					CR.TO_CMP_ID IS NOT NULL AND
					CR.ACTION_ID = ICR.ACTION_ID AND
					CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND
					ICR.CLOSED_AMOUNT IS NOT NULL AND
					((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
					(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
					CR.OTHER_MONEY = ICR.OTHER_MONEY AND					
					ICR.ACTION_ID IN (SELECT ICCR.ACTION_ID FROM CARI_CLOSED_ROW ICCR,CARI_CLOSED IC WHERE ICCR.CLOSED_ID = IC.CLOSED_ID AND CR.ACTION_TYPE_ID = ICCR.ACTION_TYPE_ID AND IC.COMPANY_ID = CR.TO_CMP_ID AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICCR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICCR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.OTHER_MONEY = ICCR.OTHER_MONEY AND IC.OTHER_MONEY = '#attributes.money_type#')
					AND CR.OTHER_MONEY = '#attributes.money_type#'
					<cfif len(attributes.project_id) and len(attributes.project_head)>
						AND CR.PROJECT_ID = #attributes.project_id#
					</cfif>
				GROUP BY
					CR.ACTION_NAME,
					CR.ACTION_ID,
					CR.PAPER_NO,
					CR.ACTION_TYPE_ID,
					CR.TO_CMP_ID,
					CR.FROM_CMP_ID,
                    <cfif attributes.money_type neq session.ep.money>
                    	CR.OTHER_CASH_ACT_VALUE,
                    <cfelse>
						CR.ACTION_VALUE,
                    </cfif>
					CR.ACTION_DATE,
					CR.DUE_DATE,
					
					CR.OTHER_MONEY,
					ICR.OTHER_MONEY				
				UNION
				
				SELECT
					CR.ACTION_NAME,
					CR.ACTION_ID,
					CR.PAPER_NO,
					CR.ACTION_TYPE_ID,
					CR.TO_CMP_ID,
					CR.FROM_CMP_ID,
                    <cfif attributes.money_type neq session.ep.money>
                    	ROUND(CR.OTHER_CASH_ACT_VALUE,2) ACTION_VALUE,
                   	<cfelse>
						ROUND(CR.ACTION_VALUE,2) ACTION_VALUE,
                   	</cfif>
					CR.ACTION_DATE,
					CR.DUE_DATE,
					
					CR.OTHER_MONEY,				
					0 TOTAL_CLOSED_AMOUNT,
					0 OTHER_CLOSED_AMOUNT,
					'' I_OTHER_MONEY
				FROM 
					CARI_ROWS CR
				WHERE
					ROUND(CR.ACTION_VALUE,2) >= 1 AND
					CR.ACTION_TYPE_ID NOT IN (48,49,45,46) AND
					CR.TO_CMP_ID IS NOT NULL AND
					CR.ACTION_ID NOT IN (SELECT ICCR.ACTION_ID FROM CARI_CLOSED_ROW ICCR,CARI_CLOSED IC WHERE ICCR.CLOSED_ID = IC.CLOSED_ID AND CR.ACTION_TYPE_ID = ICCR.ACTION_TYPE_ID AND IC.COMPANY_ID = CR.TO_CMP_ID AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICCR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICCR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND CR.OTHER_MONEY = ICCR.OTHER_MONEY AND ICCR.CLOSED_AMOUNT IS NOT NULL)
					AND CR.OTHER_MONEY = '#attributes.money_type#'
					<cfif len(attributes.project_id) and len(attributes.project_head)>
						AND CR.PROJECT_ID = #attributes.project_id#
					</cfif>
				) 
				MAIN_GET_CLOSED,
				<cfif isdefined("attributes.is_temsilci")>
					#dsn_alias#.EMPLOYEE_POSITIONS EP,
				</cfif>
				#dsn_alias#.COMPANY C,
				#dsn_alias#.COMPANY_CAT CC
			WHERE		  
				<cfif isdefined("attributes.is_temsilci")>
				EP.POSITION_CODE = (SELECT POSITION_CODE FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE COMPANY_ID = C.COMPANY_ID AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id#) AND
				</cfif>
				<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
				C.COMPANY_ID IN 
				(SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
				AND
				</cfif>
				<cfif isDefined("attributes.STARTDATE")>
						<cfif len(attributes.STARTDATE) AND len(attributes.FINISHDATE)>
						(
						DUE_DATE >= #attributes.STARTDATE# AND
						DUE_DATE <= #attributes.FINISHDATE#
						) AND
						<cfelseif len(attributes.STARTDATE)>
						DUE_DATE >= #attributes.STARTDATE# AND
						<cfelseif len(attributes.FINISHDATE)>
						DUE_DATE <= #attributes.FINISHDATE# AND
						</cfif>
						
				</cfif>
				<cfif isDefined("attributes.fatura_startdate")>
						<cfif len(attributes.fatura_startdate) AND len(attributes.fatura_finishdate)>
						(
						ACTION_DATE >= #attributes.fatura_startdate# AND
						ACTION_DATE <= #attributes.fatura_finishdate#
						) AND
						<cfelseif len(attributes.fatura_startdate)>
						ACTION_DATE >= #attributes.fatura_startdate# AND
						<cfelseif len(attributes.fatura_finishdate)>
						ACTION_DATE <= #attributes.fatura_finishdate# AND
						</cfif>
				</cfif>
				<cfif isdefined("attributes.comp_cat") and listlen(attributes.comp_cat)>
					CC.COMPANYCAT_ID IN (#attributes.comp_cat#) AND
				</cfif>
				<cfif Len(attributes.buyer_seller) and attributes.buyer_seller eq 1>
					C.IS_BUYER = 1 AND
				<cfelseif Len(attributes.buyer_seller) and attributes.buyer_seller eq 0>
					C.IS_SELLER = 1 AND
				</cfif>
				ROUND(OTHER_CLOSED_AMOUNT,2) <> ROUND(ACTION_VALUE,2) AND<!--- kısmi kapamalar için ama neden #session.ep.money# alanlar karşılaştırılmamış --->
				MAIN_GET_CLOSED.TO_CMP_ID = C.COMPANY_ID AND
				CC.COMPANYCAT_ID = C.COMPANYCAT_ID
			ORDER BY
				<cfif isdefined("attributes.is_temsilci")>
				TEM_POSITION_CODE,	
				</cfif>
				FULLNAME,
				ACTION_TYPE_ID,
				TO_CMP_ID			
	</cfquery>
<cfelse>
	<cfset get_pay_list.recordcount = 0>
</cfif>
<cfscript>
	toplam_fatura_tutar = 0;
	toplam_kapatilan_tutar = 0;
	toplam_kalan_tutar = 0;
	toplam_ortalama_vade = 0;
	toplam_ortalama_fatura = 0;
	musteri_fatura_tutar = 0;
	musteri_kapatilan_tutar = 0;
	musteri_kalan_tutar = 0;
	musteri_ortalama_vade = 0;
	musteri_ortalama_fatura = 0;
	temsilci_fatura_tutar = 0;
	temsilci_kapatilan_tutar = 0;
	temsilci_kalan_tutar = 0;
	temsilci_ortalama_vade = 0;
	temsilci_ortalama_fatura = 0;
</cfscript>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_pay_list.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39639.Müşteri Ödeme Listesi'></cfsavecontent>
<cfform name="form_search" action="#request.self#?fuseaction=report.company_payment_list&form_submitted=1" method="post">
<cf_report_list_search title="#head#">
	<cf_report_list_search_area>
		<div class="row">
			<div class="col col-12 col-xs-12 ">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-md-12">
								<div class="form-group">
									<label class="col col-12 "><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
									<div class="col col-12 col-xs-12">
										<select name="comp_cat" id="comp_cat" multiple style="height:100px;">
											<cfoutput query="get_companycat">
												<option value="#COMPANYCAT_ID#" <cfif isdefined("attributes.comp_cat") and listfindnocase(attributes.comp_cat,COMPANYCAT_ID)> selected</cfif>>#companycat#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-12 "></div>
									<div class="col col-12 col-xs-12">
										<label><cf_get_lang dictionary_id ='57908.Temsilci'><cf_get_lang dictionary_id ='58601.Bazında'><input type="checkbox" name="is_temsilci" id="is_temsilci" value="1" <cfif isdefined("attributes.is_temsilci")>checked</cfif>></label>
									</div>
								</div>								
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-md-12">							
								<div class="form-group">
									<label class="col col-12 "><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57441.Fatura'><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
											<cfif isdefined('attributes.fatura_startdate') and len(attributes.fatura_startdate)>
												<cfinput type="text" name="fatura_startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.fatura_startdate,dateformat_style)#">
											<cfelse>
												<cfinput type="text" name="fatura_startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#">
											</cfif>
											<span class="input-group-addon"><cf_wrk_date_image date_field="fatura_startdate"></span>
										</div>
									</div>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57441.Fatura'><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
											<cfif isdefined("attributes.fatura_finishdate") and len(attributes.fatura_finishdate)>
												<cfinput type="text" name="fatura_finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.fatura_finishdate,dateformat_style)#">
											<cfelse>
												<cfinput type="text" name="fatura_finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#">
											</cfif>
											<span class="input-group-addon"><cf_wrk_date_image date_field="fatura_finishdate"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 "><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57640.Vade'> <cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
											<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
												<cfinput type="text" name="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
											<cfelse>
												<cfinput type="text" name="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#">
											</cfif>
											<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
										</div>
									</div>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57640.Vade'><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
											<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
												<cfinput type="text" name="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
											<cfelse>
												<cfinput type="text" name="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#">
											</cfif>
											<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 "><cf_get_lang dictionary_id='57908.Temsilci'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
											<cf_wrk_employee_positions form_name='form_list_company' pos_code='pos_code' emp_name='pos_code_text'>
											<input type="text" name="pos_code_text" id="pos_code_text" style="width:110px;" value="<cfif len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" autocomplete="off">	
											<span class="input-group-addon btnPointer icon-ellipsis"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_search.pos_code&field_name=form_search.pos_code_text&select_list=1','list','popup_list_positions');return false"></span>
										</div>
									</div>
								</div>
							</div>							
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-md-12">								
								<div class="form-group">
									<label class="col col-12 "><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
											<input type="text" name="project_head" id="project_head" style="width:145px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_search.project_id&project_head=form_search.project_head');"> </span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 "><cf_get_lang dictionary_id ='57489.Para Birimi'></label>
									<div class="col col-12 col-xs-12">
										<select name="money_type" id="money_type" >
											<cfoutput query="GET_MONEYS">
												<option value="#MONEY#"<cfif attributes.money_type eq MONEY>selected</cfif>>#MONEY#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 "><cf_get_lang dictionary_id='57708.Tümü'></label>
									<div class="col col-12 col-xs-12">
										<select name="buyer_seller" id="buyer_seller">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1" <cfif Len(attributes.buyer_seller) and attributes.buyer_seller eq 1>selected</cfif>><cf_get_lang dictionary_id='58733.Alıcı'></option>
											<option value="0" <cfif Len(attributes.buyer_seller) and attributes.buyer_seller eq 0>selected</cfif>><cf_get_lang dictionary_id='58873.Satıcı'></option>
										</select>
									</div>
								</div>								
							</div>
						</div>
					</div>
				</div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter">
						<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    	<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">    
						<input type="hidden" name="form_submitted" id="form_submitted" value="1">
						<cf_wrk_report_search_button insert_info='#message#' button_type='1' search_function='control()' is_excel='1'>
					</div>
				</div>
			</div>
		</div>
	</cf_report_list_search_area>
</cf_report_list_search>
</cfform>

<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="company_payment_list#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-8">
</cfif>
<cfif isdefined("attributes.form_submitted")>	
<cf_report_list>
	<thead>
		<tr>
			<th width="90"><cf_get_lang dictionary_id ='38889.Hesap Kodu'></th>
			<th><cf_get_lang dictionary_id ='38890.Hesap Adı'></th>
			<th><cf_get_lang dictionary_id ='58759.Fatura T'></th>
			<th><cf_get_lang dictionary_id ='57881.Vade T'></th>
			<th><cf_get_lang dictionary_id ='57441.Fatura'><cf_get_lang dictionary_id ='57673.Tutar'></th>
			<th><cf_get_lang dictionary_id ='58661.Kapatılan'><cf_get_lang dictionary_id ='57673.Tutar'></th>
			<th><cf_get_lang dictionary_id ='58444.Kalan'><cf_get_lang dictionary_id ='57673.Tutar'></th>
			<th>&nbsp;</th>
			<th>%</th>
			<th>&nbsp;</th>
		</tr>
    </thead>
	<cfif get_pay_list.recordcount>
		<cfif isdefined("attributes.is_temsilci")>
			<cfoutput query="get_pay_list" group="tem_position_code" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td colspan="10"><b><cf_get_lang dictionary_id ='57908.TEMSİLCİ'> : #employee_name# #employee_surname#</b></td>
				</tr>
				<cfoutput>
					 <tbody>
					 <tr>
						<td>#MEMBER_CODE#</td>
						<td>#FULLNAME#</td>
						<td>#dateformat(ACTION_DATE,dateformat_style)#</td>
						<td><cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#<cfelse>#dateformat(ACTION_DATE,dateformat_style)#</cfif></td>
						<td>#tlformat(action_value)#&nbsp;(B)</td>
						<td>#tlformat(total_closed_amount)#</td>
						<td>#tlformat(action_value - total_closed_amount)#</td>
						<td>#other_money#</td>
						<td>% #wrk_round((action_value - total_closed_amount) * 100 / action_value)#</td>
						<td>#get_process_name(ACTION_TYPE_ID)#</td>
					</tr>
					<cfscript>
						if(len(DUE_DATE))
							fark_ = datediff("d",now(),DUE_DATE);
						else
							fark_ = datediff("d",now(),ACTION_DATE);
							
						fark_fatura_ = datediff("d",now(),ACTION_DATE);
							
						toplam_ortalama_fatura = toplam_ortalama_fatura + wrk_round(((action_value - total_closed_amount) * fark_fatura_),2);	
						toplam_ortalama_vade = toplam_ortalama_vade + wrk_round(((action_value - total_closed_amount) * fark_),2);
						toplam_fatura_tutar = toplam_fatura_tutar + action_value;
						toplam_kapatilan_tutar = toplam_kapatilan_tutar + total_closed_amount;
						toplam_kalan_tutar = toplam_kalan_tutar + wrk_round((action_value - total_closed_amount),2);
						
						temsilci_ortalama_fatura = temsilci_ortalama_fatura + wrk_round(((action_value - total_closed_amount) * fark_fatura_),2);	
						temsilci_ortalama_vade = temsilci_ortalama_vade + wrk_round(((action_value - total_closed_amount) * fark_),2);
						temsilci_fatura_tutar = temsilci_fatura_tutar + action_value;
						temsilci_kapatilan_tutar = temsilci_kapatilan_tutar + total_closed_amount;
						temsilci_kalan_tutar = temsilci_kalan_tutar + wrk_round((action_value - total_closed_amount),2);
					</cfscript>
					<cfif currentrow neq recordcount and TO_CMP_ID neq TO_CMP_ID[currentrow + 1]>
						<cfscript>
							musteri_fatura_tutar = musteri_fatura_tutar + action_value;
							musteri_kapatilan_tutar = musteri_kapatilan_tutar + total_closed_amount;
							musteri_kalan_tutar = musteri_kalan_tutar + wrk_round((action_value - total_closed_amount),2);
							musteri_ortalama_vade = musteri_ortalama_vade + wrk_round(((action_value - total_closed_amount) * fark_),2);
							musteri_ortalama_fatura = musteri_ortalama_fatura + wrk_round(((action_value - total_closed_amount) * fark_fatura_),2);
						</cfscript>
						<cfif musteri_kalan_tutar neq 0>
							<cfset due_day_fatura = wrk_round(ceiling(musteri_ortalama_fatura/musteri_kalan_tutar),0)>
							<cfset due_day = wrk_round(ceiling(musteri_ortalama_vade/musteri_kalan_tutar),0)>
						<cfelse>
							<cfset due_day_fatura = 0>
							<cfset due_day = 0>
						</cfif>
						<cfif due_day lt 0.00001 and due_day gt -0.00001>
							<cfset due_day = 0>
						</cfif>
						<cfif due_day_fatura lt 0.00001 and due_day_fatura gt -0.00001>
							<cfset due_day_fatura = 0>
						</cfif>
						<tr>
							<td colspan="2"><cf_get_lang dictionary_id ='57492.Toplam'></td>
							<td>#dateformat(date_add("d",due_day_fatura,now()),dateformat_style)#</td>
							<td>#dateformat(date_add("d",due_day,now()),dateformat_style)#</td>
							<td>#tlformat(musteri_fatura_tutar)#</td>
							<td>#tlformat(musteri_kapatilan_tutar)#</td>
							<td>#tlformat(musteri_kalan_tutar)#</td>
							<td>#other_money#</td>
							<td>% #wrk_round(musteri_kalan_tutar * 100 / musteri_fatura_tutar)#</td>
							<td>&nbsp;</td>
						</tr>
						<cfscript>
							musteri_fatura_tutar = 0;
							musteri_kapatilan_tutar = 0;
							musteri_kalan_tutar = 0;
							musteri_ortalama_vade = 0;
							musteri_ortalama_fatura = 0;
						</cfscript>
					<cfelseif currentrow neq recordcount and TO_CMP_ID eq TO_CMP_ID[currentrow + 1]>
						<cfscript>
							musteri_fatura_tutar = musteri_fatura_tutar + action_value;
							musteri_kapatilan_tutar = musteri_kapatilan_tutar + total_closed_amount;
							musteri_kalan_tutar = musteri_kalan_tutar + wrk_round((action_value - total_closed_amount),2);
							musteri_ortalama_vade = musteri_ortalama_vade + wrk_round(((action_value - total_closed_amount) * fark_),2);
							musteri_ortalama_fatura = musteri_ortalama_fatura + wrk_round(((action_value - total_closed_amount) * fark_fatura_),2);
						</cfscript>
					<cfelse>
						<cfscript>
							musteri_fatura_tutar = musteri_fatura_tutar + action_value;
							musteri_kapatilan_tutar = musteri_kapatilan_tutar + total_closed_amount;
							musteri_kalan_tutar = musteri_kalan_tutar + wrk_round((action_value - total_closed_amount),2);
							musteri_ortalama_vade = musteri_ortalama_vade + wrk_round(((action_value - total_closed_amount) * fark_),2);
							musteri_ortalama_fatura = musteri_ortalama_fatura + wrk_round(((action_value - total_closed_amount) * fark_fatura_),2);
						</cfscript>
						<cfif musteri_kalan_tutar neq 0>
							<cfset due_day_fatura = wrk_round(ceiling(musteri_ortalama_fatura/musteri_kalan_tutar),0)>
							<cfset due_day = wrk_round(ceiling(musteri_ortalama_vade/musteri_kalan_tutar),0)>
						<cfelse>
							<cfset due_day_fatura = 0>
							<cfset due_day = 0>
						</cfif>
						<cfif due_day lt 0.00001 and due_day gt -0.00001>
							<cfset due_day = 0>
						</cfif>
						<cfif due_day_fatura lt 0.00001 and due_day_fatura gt -0.00001>
							<cfset due_day_fatura = 0>
						</cfif>
						<tr>
							<td colspan="2"><cf_get_lang dictionary_id ='57492.Toplam'></td>
							<td>#dateformat(date_add("d",due_day_fatura,now()),dateformat_style)#</td>
							<td>#dateformat(date_add("d",due_day,now()),dateformat_style)#</td>
							<td>#tlformat(musteri_fatura_tutar)#</td>
							<td>#tlformat(musteri_kapatilan_tutar)#</td>
							<td>#tlformat(musteri_kalan_tutar)#</td>
							<td>#other_money#</td>
							<td>% #wrk_round(musteri_kalan_tutar * 100 / musteri_fatura_tutar)#</td>
							<td>&nbsp;</td>
						</tr>
					</cfif>
				</cfoutput>
				<cfif temsilci_kalan_tutar neq 0>
					<cfset due_day_tem= wrk_round(ceiling(temsilci_ortalama_fatura/temsilci_kalan_tutar),0)>
					<cfset due_day_2 = wrk_round(ceiling(temsilci_ortalama_vade/temsilci_kalan_tutar),0)>
				<cfelse>
					<cfset due_day_tem = 0>
					<cfset due_day_2 = 0>
				</cfif>
				<cfif due_day_tem lt 0.00001 and due_day_tem gt -0.00001>
					<cfset due_day_tem = 0>
				</cfif>
				<cfif due_day_2 lt 0.00001 and due_day_2 gt -0.00001>
					<cfset due_day_2 = 0>
				</cfif>
				<tr class="total">
					<td colspan="2">#employee_name# #employee_surname# <cf_get_lang dictionary_id ='57492.Toplam'></td>
					<td>#dateformat(date_add("d",due_day_tem,now()),dateformat_style)#</td>
					<td>#dateformat(date_add("d",due_day_2,now()),dateformat_style)#</td>
					<td>#tlformat(temsilci_fatura_tutar)#</td>
					<td>#tlformat(temsilci_kapatilan_tutar)#</td>
					<td>#tlformat(temsilci_kalan_tutar)#</td>
					<td>#attributes.money_type#</td>
					<td>% #wrk_round(temsilci_kalan_tutar * 100 / temsilci_fatura_tutar)#</td>
					<td>&nbsp;</td>
				</tr>
				</tbody>
				<cfscript>
					temsilci_ortalama_fatura = 0;	
					temsilci_ortalama_vade = 0;
					temsilci_fatura_tutar = 0;
					temsilci_kapatilan_tutar = 0;
					temsilci_kalan_tutar = 0;
				</cfscript>
			</cfoutput>
		<cfelse>
			<cfoutput query="get_pay_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tbody>
				<tr>
					<td>#MEMBER_CODE#</td>
					<td>#FULLNAME#</td>
					<td >#dateformat(ACTION_DATE,dateformat_style)#</td>
					<td><cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#<cfelse>#dateformat(ACTION_DATE,dateformat_style)#</cfif></td>
					<td>#tlformat(action_value)#&nbsp;(B)</td>
					<td>#tlformat(total_closed_amount)#</td>
					<td>#tlformat(action_value - total_closed_amount)#</td>
					<td>#other_money#</td>
					<td>% #wrk_round((action_value - total_closed_amount) * 100 / action_value)#</td>
					<td>#get_process_name(ACTION_TYPE_ID)#</td>
				</tr>
				<cfscript>
					if(len(DUE_DATE))
						fark_ = datediff("d",now(),DUE_DATE);
					else
						fark_ = datediff("d",now(),ACTION_DATE);
					fark_fatura_ = datediff("d",now(),ACTION_DATE);
						
					toplam_ortalama_fatura = toplam_ortalama_fatura + wrk_round(((action_value - total_closed_amount) * fark_fatura_),2);	
					toplam_ortalama_vade = toplam_ortalama_vade + wrk_round(((action_value - total_closed_amount) * fark_),2);
					toplam_fatura_tutar = toplam_fatura_tutar + action_value;
					toplam_kapatilan_tutar = toplam_kapatilan_tutar + total_closed_amount;
					toplam_kalan_tutar = toplam_kalan_tutar + wrk_round((action_value - total_closed_amount),2);
				</cfscript>
				<cfif currentrow neq recordcount and TO_CMP_ID neq TO_CMP_ID[currentrow + 1]>
					<cfscript>
						musteri_fatura_tutar = musteri_fatura_tutar + action_value;
						musteri_kapatilan_tutar = musteri_kapatilan_tutar + total_closed_amount;
						musteri_kalan_tutar = musteri_kalan_tutar + wrk_round((action_value - total_closed_amount),2);
						musteri_ortalama_vade = musteri_ortalama_vade + wrk_round(((action_value - total_closed_amount) * fark_),2);
						musteri_ortalama_fatura = musteri_ortalama_fatura + wrk_round(((action_value - total_closed_amount) * fark_fatura_),2);
					</cfscript>
					<cfif musteri_kalan_tutar neq 0>
						<cfset due_day_fatura = wrk_round(ceiling(musteri_ortalama_fatura/musteri_kalan_tutar),0)>
						<cfset due_day = wrk_round(ceiling(musteri_ortalama_vade/musteri_kalan_tutar),0)>
					<cfelse>
						<cfset due_day_fatura = 0>
						<cfset due_day = 0>
					</cfif>
					<cfif due_day lt 0.00001 and due_day gt -0.00001>
						<cfset due_day = 0>
					</cfif>
					<cfif due_day_fatura lt 0.00001 and due_day_fatura gt -0.00001>
						<cfset due_day_fatura = 0>
					</cfif>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id ='57492.Toplam'></td>
						<td>#dateformat(date_add("d",due_day_fatura,now()),dateformat_style)#</td>
						<td>#dateformat(date_add("d",due_day,now()),dateformat_style)#</td>
						<td>#tlformat(musteri_fatura_tutar)#</td>
						<td>#tlformat(musteri_kapatilan_tutar)#</td>
						<td>#tlformat(musteri_kalan_tutar)#</td>
						<td>#other_money#</td>
						<td>% #wrk_round(musteri_kalan_tutar * 100 / musteri_fatura_tutar)#</td>
						<td>&nbsp;</td>
					</tr>
					<cfscript>
						musteri_fatura_tutar = 0;
						musteri_kapatilan_tutar = 0;
						musteri_kalan_tutar = 0;
						musteri_ortalama_vade = 0;
						musteri_ortalama_fatura = 0;
					</cfscript>
				<cfelseif currentrow neq recordcount and TO_CMP_ID eq TO_CMP_ID[currentrow + 1]>
					<cfscript>
						musteri_fatura_tutar = musteri_fatura_tutar + action_value;
						musteri_kapatilan_tutar = musteri_kapatilan_tutar + total_closed_amount;
						musteri_kalan_tutar = musteri_kalan_tutar + wrk_round((action_value - total_closed_amount),2);
						musteri_ortalama_vade = musteri_ortalama_vade + wrk_round(((action_value - total_closed_amount) * fark_),2);
						musteri_ortalama_fatura = musteri_ortalama_fatura + wrk_round(((action_value - total_closed_amount) * fark_fatura_),2);
					</cfscript>
				<cfelse>
					<cfscript>
						musteri_fatura_tutar = musteri_fatura_tutar + action_value;
						musteri_kapatilan_tutar = musteri_kapatilan_tutar + total_closed_amount;
						musteri_kalan_tutar = musteri_kalan_tutar + wrk_round((action_value - total_closed_amount),2);
						musteri_ortalama_vade = musteri_ortalama_vade + wrk_round(((action_value - total_closed_amount) * fark_),2);
						musteri_ortalama_fatura = musteri_ortalama_fatura + wrk_round(((action_value - total_closed_amount) * fark_fatura_),2);
					</cfscript>
					<cfif musteri_kalan_tutar neq 0>
						<cfset due_day_fatura = wrk_round(ceiling(musteri_ortalama_fatura/musteri_kalan_tutar),2)>
						<cfset due_day = wrk_round(ceiling(musteri_ortalama_vade/musteri_kalan_tutar),2)>
					<cfelse>
						<cfset due_day_fatura = 0>
						<cfset due_day = 0>
					</cfif>
					<cfif due_day lt 0.00001 and due_day gt -0.00001>
						<cfset due_day = 0>
					</cfif>
					<cfif due_day_fatura lt 0.00001 and due_day_fatura gt -0.00001>
						<cfset due_day_fatura = 0>
					</cfif>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id ='57492.Toplam'></td>
						<td>#dateformat(date_add("d",due_day_fatura,now()),dateformat_style)#</td>
						<td >#dateformat(date_add("d",due_day,now()),dateformat_style)#</td>
						<td >#tlformat(musteri_fatura_tutar)#</td>
						<td>#tlformat(musteri_kapatilan_tutar)#</td>
						<td>#tlformat(musteri_kalan_tutar)#</td>
						<td>#other_money#</td>
						<td>% #wrk_round(musteri_kalan_tutar * 100 / musteri_fatura_tutar)#</td>
						<td>&nbsp;</td>
					</tr>
				</cfif>
			</tbody>
			</cfoutput>
		</cfif>
		<!--- toplam --->
			<cfoutput>
				<tr>
					<td colspan="2" ><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
					<td>#dateformat(date_add("d",wrk_round(ceiling(toplam_ortalama_fatura/toplam_kalan_tutar),2),now()),dateformat_style)#</td>
					<td>#dateformat(date_add("d",wrk_round(ceiling(toplam_ortalama_vade/toplam_kalan_tutar),2),now()),dateformat_style)#</td>
					<td>#tlformat(toplam_fatura_tutar)#</td>
					<td>#tlformat(toplam_kapatilan_tutar)#</td>
					<td>#tlformat(toplam_kalan_tutar)#</td>
					<td>#attributes.money_type#</td>
					<td>% #wrk_round(toplam_kalan_tutar * 100 / toplam_fatura_tutar)#</td>
					<td>&nbsp;</td>
				</tr>
			</cfoutput>
		<!--- toplam --->
	<cfelse>
		<tbody>
			<tr>
				<td colspan="12"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
			</tr>
		</tbody>
	</cfif>

</cf_report_list>
</cfif>
<cfif get_pay_list.recordcount and (attributes.maxrows lt attributes.totalrecords)>
		<cfset url_str = "report.company_payment_list">
		<cfif isdefined("attributes.report_id")>
			<cfset url_str = "#url_str#&report_id=#attributes.report_id#">
		</cfif>
		<cfif len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.money_type)>
			<cfset url_str = "#url_str#&money_type=#attributes.money_type#">
		</cfif>
		<cfif len(attributes.pos_code_text)>
			<cfset url_str = "#url_str#&pos_code_text=#attributes.pos_code_text#">
		</cfif>
		<cfif len(attributes.pos_code)>
			<cfset url_str = "#url_str#&pos_code=#attributes.pos_code#">
		</cfif>
		<cfif len(attributes.project_id)>
			<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
		</cfif>
		
		<cfif len(attributes.buyer_seller)>
			<cfset url_str = "#url_str#&buyer_seller=#attributes.buyer_seller#">
		</cfif>
       <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
            <cfset url_str = '#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
        </cfif>
		<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
			<cfset url_str = '#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
		</cfif>
		
		<cfif isdefined("attributes.fatura_startdate") and isdate(attributes.fatura_startdate)>
			<cfset url_str = "#url_str#&fatura_startdate=#attributes.fatura_startdate#">
		</cfif>
		<cfif isdefined("attributes.fatura_finishdate") and isdate(attributes.fatura_finishdate)>
			<cfset url_str = "#url_str#&fatura_finishdate=#attributes.fatura_finishdate#">
		</cfif>
      <cf_paging page="#attributes.page#" 
                 maxrows="#attributes.maxrows#"
                 totalrecords="#attributes.totalrecords#"
                 startrow="#attributes.startrow#"
                 adres="#url_str#">
	</cfif>
<script type="text/javascript">
	function control(){
		if ((document.form_search.startdate.value != '') && (document.form_search.finishdate.value != '') &&
	    !date_check(form_search.startdate,form_search.finishdate,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if ((document.form_search.fatura_startdate.value != '') && (document.form_search.fatura_finishdate.value != '') &&
	    !date_check(form_search.fatura_startdate,form_search.fatura_finishdate,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.form_search.is_excel.checked==false)
			{
				document.form_search.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.company_payment_list"
				return true;
			}
			else
				document.form_search.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_company_payment_list</cfoutput>"
	}
</script>