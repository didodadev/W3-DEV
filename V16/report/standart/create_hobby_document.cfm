<cf_get_lang_set module_name="invoice">
<cf_xml_page_edit fuseact="invoice.list_bill">
<cfparam name="is_show_detail_search" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_txt" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.payment_type_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.payment_type" default="">
<cfparam name="attributes.empo_id" default="">
<cfparam name="attributes.parto_id" default="">
<cfparam name="attributes.emp_partner_nameo" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.detail" default="">
<cfparam name="attributes.iptal_invoice" default="0">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.turned_to_total_inv" default="0">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.from_report" default="0">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>	
	<cfset attributes.start_date = date_add('d',-7,now())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_date = ''>
	<cfelse>
		<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
	</cfif>
</cfif>
<cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
	<cf_date tarih= "attributes.record_date">
</cfif>
<cfif isdefined("attributes.record_date2") and isdate(attributes.record_date2)>
	<cf_date tarih= "attributes.record_date2">
</cfif>
<cfset islem_tipi = '50,52,53,531,532,56,58,62,561,54,48,36'>
<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>
<cfinclude template="../../member/query/get_company_cat.cfm">
<cfinclude template="../../member/query/get_consumer_cat.cfm">
<cfif isdefined("attributes.form_varmi")>
	<cfif attributes.report_type eq 0>
		<cfinclude template="../../invoice/query/get_bill.cfm">
		<cfif isdefined("attributes.is_update") and attributes.is_update eq 1>
           <cfquery name="ADD_INVOICE_MULTI" datasource="#dsn2#">
				INSERT INTO
					INVOICE_MULTI
					(
						WRK_ID,
						IS_FROM_REPORT,
						START_DATE,
						FINISH_DATE,
						INVOICE_DATE, 
						PROCESS_CAT,
						DEPARTMENT_ID, 
						PAY_METHOD,
						CARD_PAYMETHOD,
						IS_GROUP_INVOICE,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						'#wrk_id#',
						1,
						<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
						<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
						#now()#,<!--- islem tarihi --->
						<cfif isdefined("attributes.cat") and ListLen(attributes.cat,'-') eq 1 and ListLen(attributes.cat,',') eq 1><!--- Ana Islem Tipleri --->
							#ListFirst(attributes.cat,'-')#
						<cfelseif isdefined("attributes.cat") and ListLen(attributes.cat,'-') gt 1 and ListLen(attributes.cat,',') eq 1><!--- Alt Islem Tipleri --->
							#listgetat(attributes.cat,2,'-')#
						<cfelse>
							NULL
						</cfif>,
						<cfif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>, 
						<cfif isDefined("attributes.payment_type_id") and len(attributes.payment_type_id)>#attributes.payment_type_id#,<cfelse>NULL,</cfif>
						<cfif isDefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>#attributes.card_paymethod_id#,<cfelse>NULL,</cfif>
						<cfif isDefined("is_group_inv")>1,<cfelse>0,</cfif>
						#session.ep.userid#,
						#now()#,
						'#cgi.remote_addr#'
					)
            </cfquery>
			<cfquery name="GET_INVOICE_MULTI" datasource="#dsn2#">
				SELECT MAX(INVOICE_MULTI_ID) AS MAX_ID FROM INVOICE_MULTI
			</cfquery>
			<cfoutput query="get_bill">
				<cfif isdefined("attributes.batch_print#currentrow#")>
                    <cfquery name="upd_inv_multi_id" datasource="#dsn2#">
                        UPDATE
                            INVOICE
                        SET
                            INVOICE_MULTI_ID = #GET_INVOICE_MULTI.MAX_ID#
                        WHERE
                            INVOICE_ID = #invoice_id#
                    </cfquery>
                </cfif>
			</cfoutput>
		</cfif>
	<cfelseif attributes.report_type eq 1>
		<cfquery name="get_bill" datasource="#dsn2#">
			SELECT
				IM.*,
                FE.IS_IPTAL,
                FE.IS_SENT,
                FE.IS_PRINTED,
                FE.FILE_NAME
			FROM
				INVOICE_MULTI IM
                LEFT OUTER JOIN FILE_EXPORTS FE ON FE.E_ID = IM.HOBIM_ID
			WHERE
				1=1
			<!---<cfif isdefined('attributes.startdate') and len(attributes.startdate) and isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND RECORD_DATE <= #DATEADD('d',1,attributes.finishdate)# AND RECORD_DATE >= #attributes.startdate#
			<cfelseif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND RECORD_DATE <= #DATEADD('d',1,attributes.finishdate)#
			<cfelseif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND RECORD_DATE >= #attributes.startdate#
			</cfif>--->
			<cfif isdate(attributes.record_date) or (isdefined("attributes.record_date2") and isdate(attributes.record_date2))>
				AND IM.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#"> <cfif isdefined("attributes.record_date2") and len(attributes.record_date2)>AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.record_date2)#"><cfelse>AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.record_date)#"></cfif>
			</cfif>
			<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
				AND IM.RECORD_EMP = #attributes.record_emp_id#
			</cfif>
			<cfif isdefined("attributes.from_report") and len(attributes.from_report)>
				AND IM.IS_FROM_REPORT = 1
			</cfif>
			ORDER BY 
				IM.RECORD_DATE DESC
		</cfquery>
		<cfset multi_id_list = valuelist(get_bill.INVOICE_MULTI_ID)>
		<cfif listlen(multi_id_list)>
			<cfquery name="get_invoice" datasource="#dsn2#">
			SELECT
				SUM(TOPLAM) TOPLAM,
				SUM(SAYI) SAYI,<!--- FATURA SAYISI --->
				SUM(TOPLAM_2) TOPLAM_2,
				SUM(SAYI_2) SAYI_2,<!--- BASILMAYAN FATURA SAYISI --->
				INVOICE_MULTI_ID
			FROM
				(
					SELECT 
						SUM(NETTOTAL) TOPLAM,
						COUNT(INVOICE_MULTI_ID) SAYI,
						0 TOPLAM_2,
						0 SAYI_2,
						INVOICE_MULTI_ID
					FROM
						INVOICE,
						#dsn_alias#.COMPANY COMPANY
					WHERE
						INVOICE_MULTI_ID IN(#multi_id_list#) AND
						COMPANY.COMPANY_ID = INVOICE.COMPANY_ID AND
						ISNULL(COMPANY.RESOURCE_ID,0) = 1 <!--- FATURA basilacaklar --->
					GROUP BY

						INVOICE_MULTI_ID
				UNION ALL
					SELECT 
						SUM(NETTOTAL) TOPLAM,
						COUNT(INVOICE_MULTI_ID) SAYI,
						0 TOPLAM_2,
						0 SAYI_2,
						INVOICE_MULTI_ID
					FROM
						INVOICE,
						#dsn_alias#.CONSUMER CONSUMER
					WHERE
						INVOICE_MULTI_ID IN(#multi_id_list#) AND
						CONSUMER.CONSUMER_ID = INVOICE.CONSUMER_ID AND
						ISNULL(CONSUMER.RESOURCE_ID,0) = 1 <!--- FATURA basilacaklar --->
					GROUP BY
						INVOICE_MULTI_ID
				UNION ALL
					SELECT 
						0 TOPLAM,
						0 SAYI,
						SUM(NETTOTAL) TOPLAM_2,
						COUNT(INVOICE_MULTI_ID) SAYI_2,
						INVOICE_MULTI_ID
					FROM
						INVOICE,
						#dsn_alias#.COMPANY COMPANY
					WHERE
						INVOICE_MULTI_ID IN(#multi_id_list#) AND
						COMPANY.COMPANY_ID = INVOICE.COMPANY_ID AND
						ISNULL(COMPANY.RESOURCE_ID,0) <> 1 <!--- FATURA basilmayacaklar --->
					GROUP BY
						INVOICE_MULTI_ID
				UNION ALL
					SELECT 
						0 TOPLAM,
						0 SAYI,
						SUM(NETTOTAL) TOPLAM_2,
						COUNT(INVOICE_MULTI_ID) SAYI_2,
						INVOICE_MULTI_ID
					FROM
						INVOICE,
						#dsn_alias#.CONSUMER CONSUMER
					WHERE
						INVOICE_MULTI_ID IN(#multi_id_list#) AND
						CONSUMER.CONSUMER_ID = INVOICE.CONSUMER_ID AND
						ISNULL(CONSUMER.RESOURCE_ID,0) <> 1 <!--- FATURA basilmayacaklar --->
					GROUP BY
						INVOICE_MULTI_ID
						
				) T1
			GROUP BY
				INVOICE_MULTI_ID
			</cfquery>
			<cfset invoice_multi_id_list = valuelist(get_invoice.invoice_multi_id)>
		</cfif>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#get_bill.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
	<cfset get_bill.recordcount = 0>	
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="form" method="post" action="#request.self#?fuseaction=report.create_hobby_document">
		<cf_box>
			<cf_box_search>
				<input type="hidden" name="form_submit" id="form_submit" value="1">
				<div class="form-group">
					<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cfoutput>#getLang(48,'Filtre',57460)#</cfoutput>">
				</div>
				<div class="form-group">
					<cfinput type="text" name="belge_no" value="#attributes.belge_no#" placeholder="#getLang('','No','57487')#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></cfsavecontent>
						<cfif session.ep.our_company_info.unconditional_list>
							<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10">
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58053.Baslama Tarihi'></cfsavecontent>
							<cfif isdefined("url.cat")>
								<cfinput type="text" name="start_date" value="" style="width:70px;" validate="#validate_style#" required="no" maxlength="10" message="#message#">
							<cfelse>
								<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#"  style="width:70px;" validate="#validate_style#" required="yes" maxlength="10" message="#message#">
							</cfif>
						</cfif>
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
						<cfif session.ep.our_company_info.unconditional_list>
							<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10">
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitis Tarihi'></cfsavecontent>
							<cfif isdefined("url.cat") >
								<cfinput type="text" name="finish_date" value="" style="width:70px;" validate="#validate_style#" maxlength="10" required="no" message="#message#">			
							<cfelse>
								<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" required="yes" message="#message#">			
							</cfif>
						</cfif>
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small"> 					
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" onKeyUp="isNumber(this)" maxlength="3">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<input name="form_varmi" id="form_varmi" value="1" type="hidden">
				<input type="hidden" name="is_update" id="is_update" value="0">
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" item="detail">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57629.Aciklama'></label>            
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">            
								<cfinput type="text" name="detail" value="#attributes.detail#" maxlength="500">
							</div>  
						</div>
					</div>
					<div class="form-group" item="registrant">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>            
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">            
								<div class="input-group">
									<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
									<input name="record_emp_name" type="text"  id="record_emp_name" onfocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','form','3','135')" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=form.record_emp_name&field_emp_id=form.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9');return false"></span>
								</div>
							</div> 
						</div>
					</div>
					<div class="form-group" item="salesman">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57021.Satis Yapan'></label>            
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">  
								<div class="input-group">         
								<input type="hidden" name="EMPO_ID" id="EMPO_ID" value="<cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)><cfoutput>#attributes.EMPO_ID#</cfoutput></cfif>">
								<input type="hidden" name="PARTO_ID" id="PARTO_ID" value="<cfif isdefined("attributes.PARTO_ID") and len(attributes.PARTO_ID)><cfoutput>#attributes.PARTO_ID#</cfoutput></cfif>" >
								<input type="text" name="EMP_PARTNER_NAMEO" id="EMP_PARTNER_NAMEO" value="<cfif isdefined("attributes.EMP_PARTNER_NAMEO") and len(attributes.EMP_PARTNER_NAMEO)><cfoutput>#attributes.EMP_PARTNER_NAMEO#</cfoutput></cfif>" style="width:120px;"  onfocus="AutoComplete_Create('EMP_PARTNER_NAMEO','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,PARTNER_CODE','EMPO_ID,PARTO_ID','','3','250');">
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form.EMP_PARTNER_NAMEO&field_partner=form.PARTO_ID&field_EMP_id=form.EMPO_ID</cfoutput>')"></span>
								</div>
							</div> 
						</div>
					</div>
					<div class="form-group" item="current">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>            
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">            
								<div class="input-group">
									<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
									<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
									<input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
									<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
									<input name="company" type="text" id="company" style="width:120px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id&field_member_name=form.company&field_emp_id=form.employee_id&field_name=form.company&&field_type=form.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>&keyword='+encodeURIComponent(document.form.company.value))"></span>
								</div>
							</div> 
						</div>
					</div>
					<div class="form-group">
						<select name="member_cat_type" id="member_cat_type">
							<option value="" selected><cf_get_lang dictionary_id="57004.Üye Kategorisi Seçiniz"></option>
							<option value="1" <cfif attributes.member_cat_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58039.Kurumsal Uye Kategorileri'></option>
							<cfoutput query="get_companycat">
								<option value="1-#COMPANYCAT_ID#" <cfif attributes.member_cat_type is '1-#COMPANYCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option>
							</cfoutput>
							<option value="2" <cfif attributes.member_cat_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'></option>
							<cfoutput query="get_consumer_cat">
								<option value="2-#CONSCAT_ID#" <cfif attributes.member_cat_type is '2-#CONSCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" item="storage">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>            
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">            
								<div class="input-group">
									<cf_wrkdepartmentlocation 
									returninputvalue="department_txt,department_id"
									returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID"
									fieldname="department_txt"
									fieldid="location_id"
									department_fldid="department_id"
									department_id="#attributes.department_id#"
									location_name="#attributes.department_txt#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									user_location = "0"
									width="140">
								</div>
							</div> 
						</div>
					</div>
					<div class="form-group" item="payment">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58516.Odeme Yontemi'></label>            
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">            
								<div class="input-group">
									<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)><cfoutput>#attributes.card_paymethod_id#</cfoutput></cfif>">
									<input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id)><cfoutput>#attributes.payment_type_id#</cfoutput></cfif>">
									<input type="text" name="payment_type" id="payment_type" value="<cfif isdefined("attributes.payment_type") and len(attributes.payment_type)><cfoutput>#attributes.payment_type#</cfoutput></cfif>" style="width:140px;" onfocus="AutoComplete_Create('payment_type','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMETHOD_ID,PAYMENT_TYPE_ID','payment_type_id,card_paymethod_id','','3','200');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=form.payment_type_id&field_name=form.payment_type&field_card_payment_id=form.card_paymethod_id&field_card_payment_name=form.payment_type');"></span>
								</div>
							</div>   
						</div>
					</div>
					<div class="form-group" item="product">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57657.Urun'></label>            
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">            
								<div class="input-group">
									<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
									<input name="product_name" type="text" id="product_name" style="width:140px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','form','3','250');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" passthrough="readonly=yes" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form.product_id&field_name=form.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+document.form.product_name.value);"></span>
								</div>
							</div>  
						</div>
					</div>
					<div class="form-group" item="project">
						<div class="input-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>            
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">            
								<div class="input-group">
									<cfif isdefined ("url.pro_id") and  len(url.pro_id)><cfset attributes.project_id=url.pro_id></cfif><!--- Proje icmal raporundan baska bir yerde kullanilmiyorsa pro_id kontrolu kaldirilabilir --->
									<cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset attributes.project_head = get_project_name(attributes.project_id)></cfif><!--- Buraya baska sayfalardan da erisiliyor, kaldirmayin --->
									<input type="hidden" name="project_id" id="project_id" value="<cfif len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
									<input type="text" name="project_head" id="project_head" style="width:140px;" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head');"></span>
								</div>
							</div>    	
						</div>
					</div>
					<div class="form-group">
						<select name="report_type" id="report_type" style="width:195px;">
							<option value="0"><cf_get_lang dictionary_id="57660.Belge Bazinda"></option>
							<option value="1" <cfif isDefined('attributes.report_type') and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id="57052.Toplu Faturalama Bazinda"></option>
						</select>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
					<div class="form-group" item="item-record_date">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57627.Kayit Tarihi'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57627.Kayit Tarihi'></cfsavecontent>
								<cfinput type="text" name="record_date" value="#dateformat(attributes.record_date,dateformat_style)#" style="width:70px" validate="#validate_style#" message="#message#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date"></span>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57627.Kayit Tarihi'></cfsavecontent>
								<cfinput type="text" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" style="width:70px" validate="#validate_style#" message="#message#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date2"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-oby">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"></label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="col col-6">
                                <div class="input-group">
									<select name="oby" id="oby">
										<option value="1" <cfif isDefined('attributes.oby') and attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
										<option value="2" <cfif isDefined('attributes.oby') and attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
										<option value="3" <cfif isDefined('attributes.oby') and attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='57215.Artan Fatura No'></option>
										<option value="4" <cfif isDefined('attributes.oby') and attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='57216.Azalan Fatura No'></option>
									</select>
                                </div>
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
									<select name="control" id="control" style="width:81px;">
										<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
										<option value="0" <cfif isDefined('attributes.control') and attributes.control eq 0>selected</cfif>><cf_get_lang dictionary_id='57314.Kontrol Edilmis'></option>
										<option value="1" <cfif isDefined('attributes.control') and attributes.control eq 1>selected</cfif>><cf_get_lang dictionary_id='57315.Kontrol Edilmemis'></option>
									</select>
                                </div>
                            </div>
                        </div>
                    </div>
					<div class="form-group" id="iptal_invoice">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"></label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="col col-6">
                                <div class="input-group">
									<select name="iptal_invoice" id="iptal_invoice">
										<option value=""><cf_get_lang dictionary_id ='57708.Tumu'></option>
										<option value="1" <cfif attributes.iptal_invoice eq 1>selected</cfif>><cf_get_lang dictionary_id='58816.Iptal Edilenler'></option>
										<option value="0" <cfif attributes.iptal_invoice eq 0>selected</cfif>><cf_get_lang dictionary_id='58817.Iptal Edilmeyenler'></option>
									</select>
                                </div>
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
									<select name="turned_to_total_inv" id="turned_to_total_inv">
										<option value="1" <cfif isDefined('attributes.turned_to_total_inv') and attributes.turned_to_total_inv eq 1>selected</cfif>><cf_get_lang dictionary_id="57050.Dönüşmüş"></option>
										<option value="0" <cfif isDefined('attributes.turned_to_total_inv') and attributes.turned_to_total_inv eq 0>selected</cfif>><cf_get_lang dictionary_id="57051.Dönüşmemiş"></option>
									</select>
                                </div>
                            </div>
                        </div>
                    </div>
					<div class="form-group" item="process">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">            
							<div class="input-group">
								<select name="cat" id="cat" multiple>
									<cfoutput query="get_process_cat" group="process_type">
										<option value="#process_type#" <cfif '#process_type#' is attributes.cat>selected</cfif>>#get_process_name(process_type)#</option>										
										<cfoutput>
											<option value="#process_type#-#process_cat_id#" <cfif ListFind(attributes.cat,'#process_type#-#process_cat_id#')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
										</cfoutput>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cf_box>
		<cf_box id="hobby_basket" title="#getLang('','Fatura Basım Dosyası Oluşturma','57048')#" uidrop="1" hide_table_column="1">
			<cf_grid_list>
			<cfif attributes.report_type eq 0>
				<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.Kayit No'></th>
					<th nowrap><cf_get_lang dictionary_id='57637.Seri No'></th>
					<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57627.Kayit Tarihi'></th>
					<th><cf_get_lang dictionary_id='57519.cari hesap'>
					<th width="100"><cf_get_lang dictionary_id='57453.Sube'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>     
					<cfif is_show_amount eq 1>
						<th width="125" style="text-align:right;"><cf_get_lang dictionary_id='57212.KDV siz Toplam'></th>
						<th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<th width="125" style="text-align:right;"><cf_get_lang dictionary_id='57642.Net Toplam'></th>
						<th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
					</cfif>
					<cfif is_other_value_show eq 1 and is_show_amount eq 1>
						<th width="125" style="text-align:right;"><cf_get_lang dictionary_id ='57386.Döviz Net Toplam'></th>
						<th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
					</cfif>
					<cfif xml_tevkifat_show eq 1>
						<th><cf_get_lang dictionary_id ='57391.Tevkifat Orani'></th>
					</cfif>
					 <cfif attributes.iptal_invoice neq 0><td width="15">@</th></cfif>   
					<!-- sil -->
					<th><input type="checkbox" name="hepsi" value="1" id="hepsi" onclick="check_all(this.checked);"></th>
					<!-- sil -->
				</tr>
				</thead>
				<cfif isdefined("attributes.form_varmi") and get_bill.recordcount>
					<cfset company_id_list=''>
					<cfset consumer_id_list=''>
					<cfset dept_id_list=''>
					<cfset process_cat_id_list=''>
					<cfset project_name_list = ""> 
					<cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif not listfind(company_id_list,company_id)>
							<cfset company_id_list=listappend(company_id_list,company_id)>
						</cfif>
						<cfif not listfind(consumer_id_list,con_id)>
							<cfset consumer_id_list=listappend(consumer_id_list,con_id)>
						</cfif>
						<cfif not listfind(dept_id_list,department_id)>
							<cfset dept_id_list=listappend(dept_id_list,department_id)>
						</cfif>
						<cfif not listfind(process_cat_id_list,process_cat)>
							<cfset process_cat_id_list=listappend(process_cat_id_list,process_cat)>
						</cfif>
						<cfif len(project_id) and not listfind(project_name_list,project_id)>
							<cfset project_name_list = Listappend(project_name_list,project_id)>
						</cfif>             
					</cfoutput>
					<cfset company_id_list=listsort(company_id_list,"numeric")>
					<cfset consumer_id_list=listsort(consumer_id_list,"numeric")>
					<cfif len(company_id_list)>
						<cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
							SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
						</cfquery>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
						</cfquery>
					</cfif>
					<cfif len(process_cat_id_list) and x_show_process_cat eq 1>					
						<cfquery name="GET_PROCESS_CAT_ROW" dbtype="query">
							SELECT PROCESS_CAT_ID,PROCESS_CAT FROM GET_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY	PROCESS_CAT_ID
						</cfquery>
						<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat_row.process_cat_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfset dept_id_list=listsort(dept_id_list,"numeric")>
					<cfif len(dept_id_list)>
						<cfquery name="GET_BRANCH_NAME" datasource="#DSN#">
							SELECT
								BRANCH_NAME 
							FROM 
								BRANCH B,
								DEPARTMENT D
							WHERE
								D.DEPARTMENT_ID IN (#dept_id_list#) AND
								B.BRANCH_ID = D.BRANCH_ID
							ORDER BY
								DEPARTMENT_ID
						</cfquery>
					<cfelse>
						<cfset get_branch_name.recordcount=0>
					</cfif>
					<cfif len(project_name_list)>
						<cfquery name="BILL_PROJECT" datasource="#DSN#">
							SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
						</cfquery>
						<cfset project_name_list = listsort(listdeleteduplicates(valuelist(bill_project.project_id,',')),"numeric","ASC",",")>
					</cfif> 
					<tbody>       
					 <cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					 <input type="hidden" name="invoice_id_#currentrow#" id="invoice_id_#currentrow#" value="#invoice_id#">
						<tr>
						  <td>
							<cfif listfind("50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,65,66,67,531,591,592,48,49,532",get_bill.invoice_cat,",")>
								<cfif get_bill.purchase_sales>
									<cfif get_bill.invoice_cat eq 65>
										<a href="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
										<cfset link_str="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_bill.invoice_id#" >
									<cfelseif get_bill.invoice_cat eq 66>
										<a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
										<cfset link_str="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_bill.invoice_id#" >
									<cfelseif get_bill.invoice_cat eq 52>
										<a href="#request.self#?fuseaction=invoice.detail_invoice_retail&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
										<cfset link_str="#request.self#?fuseaction=invoice.detail_invoice_retail&iid=#get_bill.invoice_id#">
									<cfelse>
										<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
										<cfset link_str="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_bill.invoice_id#">
									</cfif>
								<cfelseif not get_bill.purchase_sales>
									<cfif invoice_cat eq 592>
										<a href="#request.self#?fuseaction=invoice.form_upd_marketplace_bill&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
										<cfset link_str="#request.self#?fuseaction=invoice.form_upd_marketplace_bill&iid=#get_bill.invoice_id#">
									<cfelse>
										<cfif get_bill.invoice_cat eq 65>
											<a href="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
											<cfset link_str="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_bill.invoice_id#" >
										<cfelseif get_bill.invoice_cat eq 66>
											<a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
											<cfset link_str="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_bill.invoice_id#" >
										<cfelse>
											<a href="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
											<cfset link_str="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#get_bill.invoice_id#">
										</cfif>
									</cfif>
								</cfif>
							<cfelse>
								<a href="#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
								<cfset link_str="#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid=#get_bill.invoice_id#">
							</cfif>
						  </td>
						  <td><cfif len(get_bill.serial_number)>#get_bill.serial_number#<cfelseif len(INVOICE_NUMBER) and listlen(INVOICE_NUMBER,'-') eq 2>#listgetat(INVOICE_NUMBER,1,'-')#<cfelseif len(INVOICE_NUMBER)>#INVOICE_NUMBER#</cfif></td>
						  <td><a href="#link_str#" class="tableyazi"><cfif len(get_bill.serial_no)>#get_bill.serial_no#<cfelseif len(INVOICE_NUMBER) and listlen(INVOICE_NUMBER,'-') eq 2>#listgetat(INVOICE_NUMBER,2,'-')#<cfelseif len(INVOICE_NUMBER)>#INVOICE_NUMBER#</cfif></a></td>
						  <td><cfif is_iptal eq 1><font color="red"></cfif>
							  <cfif x_show_process_cat eq 1>#get_process_cat_row.process_cat[listfind(process_cat_id_list,process_cat,',')]#<cfelse>#get_process_name(invoice_cat)#</cfif>
							  <cfif is_iptal eq 1></font></cfif>
						  </td>
						  <td>#dateformat(invoice_date,dateformat_style)#</td>
						  <td>#dateformat(record_date,dateformat_style)#</td>
						  <td width="200">
						  <cfif len(get_bill.company_id)>
							  <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_bill.company_id#','medium');">#get_company_detail.fullname[listfind(company_id_list,get_bill.company_id,',')]#</a>
						  <cfelseif len(get_bill.con_id)>
							 <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_bill.con_id#','medium');">#get_consumer_detail.consumer_name[listfind(consumer_id_list,get_bill.con_id,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,con_id,',')]#</a>
						  <cfelse>
							#get_emp_info(get_bill.employee_id,0,1)#
						  </cfif>
						</td>
						<cfif session.ep.isBranchAuthorization eq 0><td><cfif len(get_bill.department_id) and get_branch_name.recordcount>#get_branch_name.branch_name[listfind(dept_id_list,get_bill.department_id,',')]#</cfif></td></cfif>
						<td>
							<cfif isdefined("get_bill.project_id") and len(get_bill.project_id)> 
								<a href="#request.self#?fuseaction=project.projects&event=det&id=#bill_project.project_id[listfind(project_name_list,project_id,',')]#" class="tableyazi">#bill_project.project_head[listfind(project_name_list,project_id,',')]#</a></td>
							<cfelse>
								<cf_get_lang dictionary_id='58459.projesiz'>
							</cfif>
						</td> 			
						<cfif is_show_amount eq 1>
							<td style="text-align:right;">#TLFormat(get_bill.nettotal - get_bill.taxtotal)#</td><!--- bu deger kdvsiz fatura tutaridir --->
							<td>&nbsp;#session.ep.money#</td>
							<td style="text-align:right;">#TLFormat(get_bill.nettotal)#</td><!--- bu deger kdv dahil fatura tutaridir --->
							<td>&nbsp;#session.ep.money#</td>
						</cfif>
						<cfif is_other_value_show eq 1 and is_show_amount eq 1>
							<td style="text-align:right;">#TLFormat(get_bill.other_money_value)#</td>
							<td style="text-align:right;">&nbsp;#other_money#</td>
						</cfif>
						<cfif xml_tevkifat_show eq 1>
							<td style="text-align:right;">#TLFormat(get_bill.tevkifat_oran)#</td>
						</cfif>
						<cfif attributes.iptal_invoice neq 0>
							<cfif is_iptal eq 1><td align="center"><img src="/images/caution_small.gif" title="<cf_get_lang dictionary_id ='58506.Iptal'>" border="0" align="absmiddle"></td><cfelse><td></td></cfif>
						</cfif>
						<!-- sil -->
						<td><input type="checkbox" name="batch_print#currentrow#" id="batch_print#currentrow#" value="1" <cfif len(get_bill.INV_MULTI_ID)>disabled</cfif>></td>
						<!-- sil -->
					  </tr>
					   </cfoutput>
					 </tbody> 
					 <tfoot>
					  <tr>
						<td colspan="17" style="text-align:right;">
							<cf_workcube_buttons is_upd='0' insert_info = 'Kaydet' add_function='input_control()' is_cancel="0">
						</td>
					</tr>
					</tfoot>
				</cfif>
			<cfelseif attributes.report_type eq 1>
				<thead>
					<tr>
						<th width="30%"><cf_get_lang dictionary_id='57287.Faturalama Tipi'></th>
						<th width="10%"><cf_get_lang dictionary_id='58759.Fatura Tarihi'></th>
						<th width="10%"><cf_get_lang dictionary_id='58082.Adet'></th>
						<th width="10%"><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th width="10%"><cf_get_lang dictionary_id='58082.Adet'></th>
						<th width="10%"><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th width="20%"><cf_get_lang dictionary_id='55812.Kayit Eden'></th>
						<th width="10%"><cf_get_lang dictionary_id='57627.Kayit Tarihi'></th>
						<th width="15" style="text-align:right;"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=invoice.popup_form_add_sale_multi</cfoutput>','medium','add_sales');"><img src="/images/plus_square.gif" align="absmiddle" title="<cf_get_lang dictionary_id='57274.Toplu Fatura'>" border="0"></a></th>
						<th width="15" style="text-align:right;"><a href="javascript://" onclick="control_function()"><img src="/images/cubexport.gif" align="absmiddle" title="<cf_get_lang dictionary_id='57302.Hobim Belgesi Olustur'>" border="0"></a></th>
					</tr>
				</thead> 
				<cfset employee_id_list = ''>
				<cfset department_id_list = ''>
				<cfset paymethod_id_list = ''>
				<cfset card_paymethod_id_list = ''>
				<cfset process_cat_id_list = ''>
				<cfif get_bill.recordcount>
					<cfoutput query="get_bill">
						<cfif len(record_emp) and not listfind(employee_id_list,record_emp)>
							<cfset employee_id_list = listappend(employee_id_list,record_emp,',')>
						</cfif>
						<cfif len(department_id) and not listfind(department_id_list,department_id)>
							<cfset department_id_list = listappend(department_id_list,department_id,',')>
						</cfif>
						<cfif len(pay_method) and not listfind(paymethod_id_list,pay_method)>
							<cfset paymethod_id_list = listappend(paymethod_id_list,pay_method,',')>
						</cfif>
						<cfif len(card_paymethod) and not listfind(card_paymethod_id_list,card_paymethod)>
							<cfset card_paymethod_id_list=listappend(card_paymethod_id_list,card_paymethod)>
						</cfif>
						<cfif len(process_cat) and not listfind(process_cat_id_list,process_cat)>
							<cfset process_cat_id_list=listappend(process_cat_id_list,process_cat)>
						</cfif>
					</cfoutput>
					<cfif listlen(employee_id_list)>
						<cfset employee_id_list = listsort(employee_id_list,"numeric","ASC",',')>
						<cfquery name="get_emp" datasource="#dsn#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfif listlen(department_id_list)>
						<cfset department_id_list = listsort(department_id_list,"numeric","ASC",',')>
						<cfquery name="get_dep" datasource="#dsn#">
							SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_id_list#) ORDER BY DEPARTMENT_ID
						</cfquery>
					</cfif>
					<cfif listlen(paymethod_id_list)>
						<cfset paymethod_id_list = listsort(paymethod_id_list,"numeric","ASC",',')>
						<cfquery name="get_paymethod" datasource="#dsn#">
							SELECT PAYMETHOD_ID,PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (#paymethod_id_list#) ORDER BY PAYMETHOD_ID
						</cfquery>
					</cfif>
					<cfif listlen(card_paymethod_id_list)>
						<cfset card_paymethod_id_list=listsort(card_paymethod_id_list,"numeric","ASC",",")>
						<cfquery name="get_card_paymethod" datasource="#dsn3#">
							SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID IN (#card_paymethod_id_list#) ORDER BY PAYMENT_TYPE_ID
						</cfquery>
					</cfif>
					<cfif listlen(process_cat_id_list)>
						<cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")> 
						<cfquery name="get_process_cat" dbtype="query">
							SELECT PROCESS_CAT_ID,PROCESS_CAT FROM GET_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
						</cfquery>
					</cfif>
					<cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tbody>
					<tr>
						<td width="30%"><cfif is_group_invoice eq 1><b><cf_get_lang dictionary_id='57295.Grup Faturalama'></b><cfelseif attributes.from_report eq 1><cf_get_lang dictionary_id="57053.Standart Faturalama"><cfelse><cf_get_lang dictionary_id="57407.Toplu Faturalama"></cfif></td>
						<td width="10%">#dateformat(invoice_date,dateformat_style)#</td>
						<td style="text-align:right;" width="10%">#get_invoice.sayi[listfind(invoice_multi_id_list,invoice_multi_id)]#</td>
						<td style="text-align:right;" width="10%">#TLFormat(get_invoice.toplam[listfind(invoice_multi_id_list,invoice_multi_id)])#</td>
						<td style="text-align:right;" width="10%">#get_invoice.sayi_2[listfind(invoice_multi_id_list,invoice_multi_id)]#</td>
						<td style="text-align:right;" width="10%">#TLFormat(get_invoice.toplam_2[listfind(invoice_multi_id_list,invoice_multi_id)])#</td>
						<td width="20%"><cfif len(record_emp)>#get_emp.employee_name[listfind(employee_id_list,record_emp,',')]# #get_emp.employee_surname[listfind(employee_id_list,record_emp,',')]#</cfif></td>
						<td width="10%">#dateformat(record_date,dateformat_style)#</td>
						<td width="15"><a href="javascript://" onclick="if (confirm('<cf_get_lang dictionary_id='57387.Iliskili Tüm Faturalar Silinecek Emin misiniz?'>')) windowopen('#request.self#?fuseaction=invoice.emptypopup_del_invoice_multi&invoice_multi_id=#get_bill.invoice_multi_id#&name=#get_process_cat.PROCESS_CAT[listfind(process_cat_id_list,PROCESS_CAT,',')]#','medium');"><img src="/images/delete_list.gif" align="absmiddle" title="<cf_get_lang dictionary_id ='57463.Sil'>" border="0"></a></td>
						<td width="15">
							<cfif (not len(hobim_id)) or  (len(hobim_id) and is_iptal eq 1)>
								<cfif listfind(invoice_multi_id_list,invoice_multi_id)>
									<cfif is_group_invoice eq 1>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.emptypopup_export_hobim&invoice_multi_id=#get_bill.invoice_multi_id#&is_group=#get_bill.IS_GROUP_INVOICE#','medium','export_hobim');"><img src="/images/cubexport.gif" align="absmiddle" title="<cf_get_lang dictionary_id='57302.Hobim Belgesi Olustur'>" border="0"></a>
									<cfelse>
										<input type="checkbox" name="invoice_multi_id" id="invoice_multi_id" value="#get_bill.invoice_multi_id#">
									</cfif>
								</cfif>
							<cfelse>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=invoice.popup_open_multi_prov_file&is_hobim_key=0&file_name=#file_name#','small');"><img src="/images/attach.gif" alt="" title="<cf_get_lang dictionary_id='39013.Hobim Dosyası'>" border="0"></a>
							</cfif>
						</td>
					  </tr>
					  </tbody>
					</cfoutput>
				</cfif>
			</cfif>
			<cf_grid_list>
		</cf_box>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
				<tr>
					  <td>
						<cfset adres="&form_varmi=#attributes.form_varmi#">
						<cfif isDefined('attributes.name') and len(attributes.name)>
							<cfset adres = "#adres#&name=#attributes.name#">
						</cfif>
						<cfif isDefined('attributes.cat') and len(attributes.cat)>
							<cfset adres = "#adres#&cat=#attributes.cat#">
						</cfif>
						<cfif len(attributes.keyword)>
							<cfset adres = "#adres#&keyword=#attributes.keyword#">
						</cfif>
						<cfif len(attributes.belge_no)>
							<cfset adres = "#adres#&belge_no=#attributes.belge_no#">
						</cfif>
						<cfif isDefined('attributes.oby') and len(attributes.oby)>
							<cfset adres = "#adres#&oby=#attributes.oby#">
						</cfif>
						<cfif isDefined('attributes.control') and len(attributes.control)>
							<cfset adres = "#adres#&control=#attributes.control#">
						</cfif>
						<cfif isdate(attributes.record_date)>
							<cfset adres = "#adres#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
						</cfif>
						<cfif isdate(attributes.start_date)>
							<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
						<cfif isdate(attributes.finish_date)>
							<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
						</cfif>
						</cfif>
						<cfif len(attributes.company_id)>
							<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#&member_type=#attributes.member_type#">
						</cfif>
						<cfif len(attributes.consumer_id)>
							<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#&member_type=#attributes.member_type#">
						</cfif>
						<cfif len(attributes.employee_id)>
							<cfset adres = "#adres#&employee_id=#attributes.employee_id#&company=#attributes.company#&member_type=#attributes.member_type#">
						</cfif>
						<cfif len(attributes.report_type)>
							<cfset adres = "#adres#&report_type=#attributes.report_type#">
						</cfif>
						<cfif len(attributes.iptal_invoice)>
							 <cfset adres = "#adres#&iptal_invoice=#attributes.iptal_invoice#">
						</cfif>
						<cfif isdefined("attributes.form_varmi")>
							<cfset adres = "#adres#&form_varmi=#attributes.form_varmi#">
						</cfif>
						<cfif isdefined("attributes.pro_id")>
							<cfset adres = "#adres#&pro_id=#attributes.pro_id#">
						</cfif>
						<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
							<cfset adres = "#adres#&department_id=#attributes.department_id#" >
						</cfif>
						<cfif isdefined("attributes.department_txt") and len(attributes.department_txt)>
							<cfset adres = "#adres#&department_txt=#attributes.department_txt#">
						</cfif>
						<cfif isdefined("attributes.product_id") and len(attributes.product_id)>
							<cfset adres = "#adres#&product_id=#attributes.product_id#">
						</cfif>
						<cfif isdefined("attributes.product_name") and len(attributes.product_name)>
							<cfset adres = "#adres#&product_name=#attributes.product_name#">
						</cfif>
						<cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id)>
							<cfset adres = "#adres#&payment_type_id=#attributes.payment_type_id#">
						</cfif>
						<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
							<cfset adres = "#adres#&card_paymethod_id=#attributes.card_paymethod_id#">
						</cfif>
						<cfif isdefined("attributes.payment_type") and len(attributes.payment_type)>
							<cfset adres = "#adres#&payment_type=#attributes.payment_type#">
						</cfif>
						<cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
							<cfset adres = "#adres#&EMPO_ID=#attributes.EMPO_ID#">
						</cfif>
						<cfif isdefined("attributes.PARTO_ID") and len(attributes.PARTO_ID)>
							<cfset adres = "#adres#&PARTO_ID=#attributes.PARTO_ID#">
						</cfif>
						<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
							<cfset adres = "#adres#&project_id=#attributes.project_id#">
						</cfif>
						<cfif isdefined("attributes.project_head") and len(attributes.project_head)>
							<cfset adres = "#adres#&project_head=#attributes.project_head#">
						</cfif>
						<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)>
							<cfset adres = "#adres#&record_emp_id=#attributes.record_emp_id#">
						</cfif>
						<cfif isdefined("attributes.record_emp_name") and len(attributes.record_emp_name)>
							<cfset adres = "#adres#&record_emp_name=#attributes.record_emp_name#">
						</cfif>
						<cfif isdefined("attributes.detail") and len(attributes.detail)>
							<cfset adres = "#adres#&detail=#attributes.detail#">
						</cfif>
						<cfif isdefined("attributes.is_tevkifat") and len(attributes.is_tevkifat)>
							<cfset adres = "#adres#&is_tevkifat=#attributes.is_tevkifat#">
						</cfif>
						<cfif isdefined("attributes.turned_to_total_inv") and len(attributes.turned_to_total_inv)>
							<cfset adres = "#adres#&turned_to_total_inv=#attributes.turned_to_total_inv#">
						</cfif>
						<cf_pages 
							page ="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="#attributes.fuseaction##adres#">
					</td>
					  <!-- sil -->
					  <td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayit'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
				   </tr>
			  </table>
		</cfif>
	</cfform>
</div>
<script type="text/javascript">
document.getElementById('belge_no').focus();
function control_function()
{
	var is_selected=0;
	var invoice_multi_id_list=0;
	if(document.form.invoice_multi_id != undefined)
	{
		if(document.form.invoice_multi_id.length>1)
		{
			for(var js=0;js < document.form.invoice_multi_id.length;js++)
			{
				if(document.form.invoice_multi_id[js].checked)
				{ 
					is_selected=1;
					invoice_multi_id_list=invoice_multi_id_list+','+document.form.invoice_multi_id[js].value;
				}
			}
		}
		else
		{
			if(document.form.invoice_multi_id.checked)
			{
				is_selected=1;
				invoice_multi_id_list=document.form.invoice_multi_id.value;
			}
		}
	}
	if(is_selected==0)
	{
		alert("<cf_get_lang dictionary_id ='57354.Hobim Dosyasi Olusturulacak Toplu Faturalama Seciniz'>");
		return false;
	}else
	{
		windowopen('<cfoutput>#request.self#?fuseaction=invoice.emptypopup_export_hobim&invoice_multi_id='+invoice_multi_id_list+'&is_group=0&from_report=1</cfoutput>','medium','export_hobim');
		return true;	
	}
}

function check_all(deger)
{
	<cfif get_bill.recordcount >
		if(deger == true)
		{
			for (var i=1; i <= <cfoutput>#get_bill.recordcount#</cfoutput>; i++)
			{	
				if(document.getElementById('batch_print'+i) != undefined)
					document.getElementById('batch_print'+i).checked = true;
			}
		}
		else
		{
			for (var i=1; i <= <cfoutput>#get_bill.recordcount#</cfoutput>; i++)
			{
				if(document.getElementById('batch_print'+i) != undefined)
					document.getElementById('batch_print'+i).checked = false;
			}				
		}
	</cfif>
}
	
function input_control()
{	
	<cfif not session.ep.our_company_info.unconditional_list and (isdefined("url.cat") and (url.cat eq 561 or url.cat eq 601 or url.cat eq 56 or url.cat eq 1 or url.cat eq 60 or url.cat eq 0))>
		if (form.start_date.value.length == 0 && form.finish_date.value.length == 0 &&form.belge_no.value.length == 0 && (form.department_id.value.length == 0 || form.department_txt.value.length == 0) && form.cat.value.length == 0 && (form.product_name.value.length == 0 || form.product_id.value.length == 0) && (form.company_id.value.length == 0 || form.company.value.length == 0) )
		{
			alert("<cf_get_lang dictionary_id='57526.En az bir alanda filtre etmelisiniz'> !");
			return false;
		}
		else 
			return true;
	<cfelse>
		document.getElementById('is_update').value = 1;
		window.location.reload();
	</cfif>
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
