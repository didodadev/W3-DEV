<cfsetting showdebugoutput="yes">
<cfflush interval="3000">
<cfset xml_page_control_list = 'is_invoice_date,is_invoice_record_date,is_city_filter,is_zone_filter,is_membercat_filter,is_product_filter,is_member_filter'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="invoice.popup_collected_print">
<cfif not isdefined("is_invoice_date")><cfset is_invoice_date = 0></cfif>
<cfif not isdefined("is_invoice_record_date")><cfset is_invoice_record_date = 0></cfif>
<cfif not isdefined("is_city_filter")><cfset is_city_filter = 0></cfif>
<cfif not isdefined("is_zone_filter")><cfset is_zone_filter = 0></cfif>
<cfif not isdefined("is_membercat_filter")><cfset is_membercat_filter = 0></cfif>
<cfif not isdefined("is_product_filter")><cfset is_product_filter = 0></cfif>
<cfif not isdefined("is_member_filter")><cfset is_member_filter = 0></cfif>
<cfif not isdefined("is_cat")><cfset is_cat = 0></cfif>

<cfif is_cat eq 1>	
	<cfset islem_tipi = '48,49,50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,64,690,691,65,66,68,531,532,591'>
	<cfif session.ep.our_company_info.workcube_sector eq 'per'>
		<cfset islem_tipi = islem_tipi&',592'>
	</cfif>
	<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
		SELECT 
			PROCESS_TYPE,
			CASE
				WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
				ELSE PROCESS_CAT 
			END AS PROCESS_CAT,
				PROCESS_CAT_ID
			FROM 
				SETUP_PROCESS_CAT 
				LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_PROCESS_CAT.PROCESS_CAT_ID
				AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_CAT">
				AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_PROCESS_CAT">
				AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
			WHERE 
				PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
	</cfquery>
</cfif>
<cfquery name="GET_MEMBER_ADD_OPTIONS" datasource="#DSN#">
	SELECT
		MEMBER_ADD_OPTION_ID,
		MEMBER_ADD_OPTION_NAME
	FROM
		SETUP_MEMBER_ADD_OPTIONS
	ORDER BY
		MEMBER_ADD_OPTION_NAME
</cfquery>
<cfquery name="GET_MODULE_ID" datasource="#DSN#">
	SELECT MODULE_ID FROM MODULES WHERE MODULE_SHORT_NAME = 'invoice'
</cfquery>
<cfif is_membercat_filter eq 1>
	<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
		SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
	</cfquery>
	<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
		SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
	</cfquery>
</cfif>
<cfif is_city_filter eq 1>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
	</cfquery>
</cfif>
<cfif is_zone_filter eq 1>
	<cfquery name="SZ" datasource="#DSN#">
		SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
	</cfquery>
</cfif>
<cfquery name="GET_MODULE_ID" datasource="#DSN#">
	SELECT MODULE_ID FROM MODULES WHERE MODULE_SHORT_NAME = 'invoice'
</cfquery>
<cfquery name="GET_DET_FORM" datasource="#DSN3#">
  	SELECT 
		SPF.TEMPLATE_FILE,
		SPF.FORM_ID,
		SPF.NAME,
		SPF.PROCESS_TYPE,
		SPF.MODULE_ID,
		SPFC.PRINT_NAME,
        SPF.IS_STANDART
	FROM 
		SETUP_PRINT_FILES SPF,
		#dsn_alias#.SETUP_PRINT_FILES_CATS SPFC
	WHERE
		SPF.ACTIVE = 1 AND
		SPF.MODULE_ID = #get_module_id.module_id# AND
		SPFC.PRINT_TYPE = SPF.PROCESS_TYPE
    ORDER BY SPF.NAME
</cfquery>
<cfparam name="attributes.serial_number" default="">
<cfparam name="attributes.first_invoice" default="">
<cfparam name="attributes.last_invoice" default="">
<cfparam name="attributes.special_invoice_note" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.record_date_1" default="">
<cfparam name="attributes.record_date_2" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_add_option_id" default="">
<cfparam name="attributes.maxrows" default="">
<cfparam name="attributes.is_einvoice" default="-1">
<cfparam name="attributes.cat" default="">
<cfform name="page_print" method="post" action="#request.self#?fuseaction=invoice.popup_collected_print">
<cf_big_list_search >
	<cf_big_list_search_area>
		<div class="row">
			<div class="form-inline">
            	<input type="hidden" name="is_send_mail" id="is_send_mail" value="0" />
				<cfif session.ep.our_company_info.is_efatura>
                    <div class="form-group x-12">
						<select name="is_einvoice" id="is_einvoice" onchange="showinput(this.value)">
							<option value="-1" selected="selected"><cf_get_lang dictionary_id="57708.Tümü"></option>
							<option value="1" <cfif attributes.is_einvoice eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="38801.Kullananlar"></option>
							<option value="0" <cfif attributes.is_einvoice eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="38804.Kullanmayanlar"></option>
						</select>
					</div>
                </cfif>
				<div class="form-group x-12">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57637.Seri No"></cfsavecontent>
					<cfinput type="text" value="#attributes.serial_number#" name="serial_number" placeholder="#message#">
				</div>
				<div class="form-group x-12" id="first_inv">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57311.İlk Fatura"></cfsavecontent>
					<cfinput type="text" value="#attributes.first_invoice#" name="first_invoice" placeholder="#message#">
				</div>
				<div class="form-group x-12" id="last_inv">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57312.Son Fatura"></cfsavecontent>
					<cfinput type="text" value="#attributes.last_invoice#" name="last_invoice" placeholder="#message#">
				</div>
				<div class="form-group x-12">
					<select name="form_type" id="form_type" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='57792.Modül İçi Yazıcı Belgeleri'></option>
						<cfoutput query="get_det_form">
							<option value="#form_id#" data-name="#NAME#" <cfif isdefined("attributes.form_type") and attributes.form_type eq form_id>selected</cfif>>
								#name# - #print_name#
							</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group x-3_5">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" style="width:25px;">
				</div>
				<div class="form-group">
					<cfif is_send_mail>
						<a href="javascript://" onclick="mail_gonder();"><img src="../images/mail.gif" border="0" title="<cf_get_lang dictionary_id ='57475.Mail Gönder'>"></a> 
					</cfif>
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function='kontrol()'>
				</div>
				<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1' trail="0">
			</div>
		</div>
	</cf_big_list_search_area>
	<cf_big_list_search_detail_area>
		<style>i.icon-date-number {font-size: 10px !important;}</style>
		<div class="row">	
        	<div class="col col-3 col-md-6 col-xs-12">
				<cfif is_membercat_filter eq 1 or is_product_filter eq 1 or is_membercat_filter eq 1>
                    <cfif is_invoice_record_date neq 1>
                        <div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></cfsavecontent>
									<cfinput type="text" name="record_date_1" value="#attributes.record_date_1#" placeholder="#message#" validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="record_date_1"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">						
								<div class="input-group">
									<cfinput type="text" name="record_date_2" value="#attributes.record_date_2#" placeholder="#message#" validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="record_date_2"></span>
								</div>
							</div>
                        </div>					
                    </cfif>
                </cfif>						
                <cfif is_invoice_date eq 1 or is_product_filter eq 1 or is_city_filter eq 1 or is_membercat_filter eq 1>
                    <cfif is_invoice_date eq 1>
                        <div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
									<cfsavecontent variable="ftrbaslangic"><cf_get_lang dictionary_id="58759.Fatura Tarihi"> <cf_get_lang dictionary_id="57501.Başlangıç"></cfsavecontent>
									<cfinput type="text" name="start_date" value="#attributes.start_date#" placeholder="#ftrbaslangic#" validate="#validate_style#" required="yes" maxlength="10" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">							
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
									<cfsavecontent variable="ftrbitis"><cf_get_lang dictionary_id="58759.Fatura Tarihi"> <cf_get_lang dictionary_id="57502.Bitiş"></cfsavecontent>	
									<cfinput type="text" name="finish_date" value="#attributes.finish_date#" placeholder="#ftrbitis#" validate="#validate_style#" maxlength="10" required="yes" message="#message#">			
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
                    </cfif>
                    <cfif is_product_filter eq 1>
                        <div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57657.Ürün"></cfsavecontent>
									<input type="text" name="product_name" id="product_name" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes">
									<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=page_print.product_id&field_name=page_print.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');" align="absmiddle" border="0"></span>					
								</div>
							</div>
						</div>
                    </cfif>
                    <cfif is_city_filter eq 1>
                        <div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">
								<select name="city_id" id="city_id">
									<option value=""><cf_get_lang dictionary_id='31644.İl Seçiniz'></option>
									<cfoutput query="get_city">
										<option value="#city_id#" <cfif len(attributes.city_id) and attributes.city_id eq city_id>selected</cfif>>#city_name#</option>
									</cfoutput>
								</select>
							</div>
                        </div>
                    </cfif>	
                </cfif>
            	<cfif is_invoice_date eq 1 or is_product_filter eq 1 or is_city_filter eq 1 or is_membercat_filter eq 1>
					<cfif is_membercat_filter eq 1>
                        <div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">
								<select name="member_cat_type" id="member_cat_type" style="width:170px; height:75px;" multiple="multiple">
									<optgroup label="<cf_get_lang dictionary_id ='58039.Kurumsal Üye Kategorileri'>">
										<cfoutput query="get_company_cat">
										<option value="1-#companycat_id#" <cfif listfind(attributes.member_cat_type,'1-#companycat_id#',',')>selected</cfif>>&nbsp;&nbsp;#companycat#</option>
										</cfoutput>
									</optgroup>
									<optgroup label="<cf_get_lang dictionary_id ='58040.Bireysel Üye Kategorileri'>">
										<cfoutput query="get_consumer_cat">
										<option value="2-#conscat_id#" <cfif listfind(attributes.member_cat_type,'2-#conscat_id#',',')>selected</cfif>>&nbsp;&nbsp;#conscat#</option>
										</cfoutput>
									</optgroup>
								</select>
							</div>
						</div>
                    </cfif>
                </cfif>
				<cfif is_cat eq 1>
					<div class="form-group" id="form_ul_cat">
						<div class="col col-12 col-md-12 col-xs-12">
							<select name="cat" id="cat">
								<option value=""><cf_get_lang dictionary_id='57124.İşlem Kategorisi'></option>
								<option value="0" <cfif attributes.cat eq "0">selected</cfif>><cf_get_lang dictionary_id='57107.Alış Faturaları'></option>
								<option value="1" <cfif attributes.cat eq "1">selected</cfif>><cf_get_lang dictionary_id='57118.Satış Faturaları'></option>
								<cfoutput query="get_process_cat" group="process_type">
								<option value="#process_type#" <cfif '#process_type#' is attributes.cat>selected</cfif>>#get_process_name(process_type)#</option>										
								<cfoutput>
									<option value="#process_type#-#process_cat_id#" <cfif attributes.cat is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
								</cfoutput>
								</cfoutput>
							</select>
						</div>
					</div>
				</cfif>
			</div>
			<div class="col col-3 col-md-6 col-xs-12">
				<div class="form-group">
					<div class="col col-12 col-md-12 col-xs-12">
						<select name="member_add_option_id" id="member_add_option_id" style="width:140px;">
							<option value=""><cf_get_lang dictionary_id ='34507.Lütfen üyü özel tanımı seçiniz'></option>
							<cfoutput query="get_member_add_options">
								<option value="#member_add_option_id#" <cfif len(attributes.member_add_option_id) and attributes.member_add_option_id eq member_add_option_id>selected</cfif>>#member_add_option_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<div class="col col-12 col-md-12 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57467.Not"></cfsavecontent>
						<cfinput type="text" value="#attributes.special_invoice_note#" name="special_invoice_note" placeholder="#message#">
					</div>
				</div>
				<div class="form-group" id="item-comp_id" >
                    <label class="col col-2 col-md-2 col-sm-3 col-xs-2"><cf_get_lang dictionary_id='57574.Şirket'></label>
                    <div class="col col-10 col-md-10 col-sm-9 col-xs-10">
                        <div class="input-group">
                        <input name="company_id" id="company_id" value='<cfoutput>#attributes.company_id#</cfoutput>' type="hidden">
                        <cfinput type="text" name="company" id="company"  value="#attributes.company#"  onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0,0','COMPANY_ID','company_id','list_works','3','250',true);" autocomplete="off">
                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:gonder('page_print.company');"></span>
                        </div>
                    </div>
                </div>
                <cfif is_membercat_filter eq 1 or is_product_filter eq 1 or is_membercat_filter eq 1>
                    <cfif is_member_filter eq 1>
						<div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>"><input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
								<input type="text" name="company" id="company" placeholder="#getLang("main","107")#" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=page_print.company&field_comp_id=page_print.company_id&field_consumer=page_print.consumer_id&field_member_name=page_print.company&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');" border="0" align="absmiddle"></span>
							</div>
						</div>
                    </cfif>
                    <cfif is_zone_filter eq 1>
						<div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">
								<select name="zone_id" id="zone_id" style="width:140px;">
									<option value=""><cf_get_lang dictionary_id='30529.Lütfen Satış Bölgesi Seçiniz'></option>
									<cfoutput query="sz">
										<option value="#sz_id#" <cfif attributes.zone_id eq sz_id>selected</cfif>>#sz_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
                    </cfif>	
                </cfif>
			</div>
			<div class="col col-2 col-md-4 col-xs-12">
				<div class="form-group">
					<label class="col col-12">
						<input type="checkbox" name="pdf_aktar" id="pdf_aktar" value="0" <cfif isdefined('attributes.pdf_aktar')>checked</cfif>><cf_get_lang dictionary_id ='58667.PDF Getir'>
					</label>
				</div>
				<div class="form-group">
					<label class="col col-12">
						<input type="checkbox" name="pdf_olustur" id="pdf_olustur" value="0" <cfif isdefined('attributes.pdf_olustur')>checked</cfif>><cf_get_lang dictionary_id ='29739.PDF Üret'>
					</label>
				</div>				
			</div>
			<div class="col col-2 col-md-4 col-xs-12">
				<div class="form-group">
					<label class="col col-12">
						<!--- xml den tanimlaniyor --->
						<cfif is_print_status eq 1>
							<input type="checkbox" name="not_printed" id="not_printed" value="0" <cfif isdefined("attributes.not_printed")>checked="checked"</cfif>>
						<cfelse>
							<input type="checkbox" name="not_printed" id="not_printed" disabled="disabled" value="0" checked="checked">
						</cfif>
						<cf_get_lang dictionary_id ='57008.Print Edilmeyenler'>
					</label>
				</div>
				<div class="form-group">
					<label class="col col-12">
						<input type="checkbox" name="not_list" id="not_list" value="0" <cfif isdefined('attributes.not_list')>checked</cfif>><cf_get_lang dictionary_id ='57010.Seçili Listedekiler Hariç'>
					</label>
				</div>
				<div class="form-group">
					<cfif is_send_mail>
						<input type="button" name="send_mail" id="send_mail" onclick="mail_gonder();" value="<cf_get_lang dictionary_id ='57475.Mail Gönder'>" />
					</cfif>
				</div>
			</div>
		</div>
	</cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
<cfif isdefined("attributes.form_type")>
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
	<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>	
	<cfif isdefined("attributes.record_date_1") and isdate(attributes.record_date_1)><cf_date tarih = "attributes.record_date_1"></cfif>
	<cfif isdefined("attributes.record_date_2") and isdate(attributes.record_date_2)><cf_date tarih = "attributes.record_date_2"></cfif>	
	<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type)>
		<cfset kurumsal = ''>
		<cfset bireysel = ''>
		<cfset uzunluk=listlen(attributes.member_cat_type)>
		<cfloop from="1" to="#uzunluk#" index="catyp">
			<cfset eleman = listgetat(attributes.member_cat_type,catyp,',')>
			<cfif listlen(eleman) and listfirst(eleman,'-') eq 1>
				<cfset kurumsal = listappend(kurumsal,eleman)>
			<cfelseif listlen(eleman) and listfirst(eleman,'-') eq 2>
				<cfset bireysel = listappend(bireysel,eleman)>
			</cfif>
		</cfloop>
	</cfif>
	<cfquery name="GET_FORM" datasource="#DSN3#">
		SELECT
			IS_STANDART,
			TEMPLATE_FILE,
			FORM_ID,
			NAME,
			PROCESS_TYPE,
			MODULE_ID
		FROM 
			SETUP_PRINT_FILES	
		WHERE
			FORM_ID = #attributes.form_type#
	</cfquery>
	<cfset ilk_fatura_numeric = 0>
	<cfset son_fatura_numeric = 0>
	<cfloop from="#len(attributes.first_invoice)#" to="1" step="-1" index="i">
		<cfset karakter = mid(attributes.first_invoice,i,1)>
		<cfif not isnumeric(karakter)>	
			<cfset ilk_fatura_no = listlast(attributes.first_invoice,karakter)>
			<cfset ilk_fatura = listdeleteat(attributes.first_invoice,listlen(attributes.first_invoice,karakter),karakter) & karakter>
			<cfbreak>
		<cfelse>
			<cfset ilk_fatura_numeric = ilk_fatura_numeric + 1>
		</cfif>
	</cfloop>
	<cfloop from="#len(attributes.last_invoice)#" to="1" step="-1" index="i">
		<cfset karakter2 = mid(attributes.last_invoice,i,1)>
		<cfif not isnumeric(karakter2)>			
			<cfset son_fatura_no = listlast(attributes.last_invoice,karakter2)>
			<cfset son_fatura = listdeleteat(attributes.last_invoice,listlen(attributes.last_invoice,karakter2),karakter2) & karakter2>
			<cfbreak>
		<cfelse>
			<cfset son_fatura_numeric = son_fatura_numeric + 1>
		</cfif>
	</cfloop>
	<cfif ilk_fatura_numeric eq len(attributes.first_invoice)>
		<cfset ilk_fatura = "">
		<cfset ilk_fatura_no = attributes.first_invoice>
	</cfif>
	<cfif son_fatura_numeric eq len(attributes.last_invoice)>
		<cfset son_fatura = "">
		<cfset son_fatura_no = attributes.last_invoice>
	</cfif>
    
	<cfif son_fatura neq ilk_fatura>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='47501.Girilen Aralık Geçerli Değil'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset invoice_number=",">
	<cfquery name="GET_INVOICE" datasource="#DSN2#">
		<cfif isdefined("attributes.not_list")>
			SELECT DISTINCT
				<cfif isdefined("attributes.maxrows") and len(attributes.maxrows)>
					TOP #attributes.maxrows#
				</cfif>
				I.INVOICE_ID ,
				I.INVOICE_NUMBER
			FROM
				INVOICE I
			WHERE
				I.PURCHASE_SALES = 1 AND
				ISNULL(I.IS_IPTAL,0) = 0
				AND I.INVOICE_ID NOT IN(
		</cfif>
			SELECT DISTINCT
				<cfif isdefined("attributes.maxrows") and len(attributes.maxrows)>
					TOP #attributes.maxrows#
				</cfif>
				I.INVOICE_ID 
				<cfif not isdefined("attributes.not_list")>
				,I.INVOICE_NUMBER
				</cfif>
			FROM 
				INVOICE I
				LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = I.COMPANY_ID 
                LEFT JOIN #dsn_alias#.CONSUMER CONS ON CONS.CONSUMER_ID = I.CONSUMER_ID
				,
				INVOICE_ROW IR,
				#dsn3_alias#.PRODUCT P
			WHERE 
				I.PURCHASE_SALES = 1 AND
				IR.INVOICE_ID = I.INVOICE_ID AND
				IR.PRODUCT_ID = P.PRODUCT_ID AND
				ISNULL(I.IS_IPTAL,0) = 0
				<cfif len(attributes.serial_number)>
					AND I.SERIAL_NUMBER LIKE '%#attributes.serial_number#%'
				</cfif>
				<cfif len(attributes.first_invoice)>
					AND LEN(I.SERIAL_NO) = #len('#ilk_fatura##ilk_fatura_no#')#
					AND I.SERIAL_NO BETWEEN <cfif len(ilk_fatura)>#ilk_fatura#+</cfif>#ilk_fatura_no# AND <cfif len(son_fatura)>#son_fatura#+</cfif>#son_fatura_no#
				</cfif>
				<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND I.INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# 
				</cfif>
				<cfif isdefined("attributes.record_date_1") and isdate(attributes.record_date_1) and isdate(attributes.record_date_2)>
					AND I.RECORD_DATE BETWEEN #attributes.record_date_1# AND #attributes.record_date_2#
				<cfelseif isdefined("attributes.record_date_1") and isdate(attributes.record_date_1)>
					AND I.RECORD_DATE >= #attributes.record_date_1#
				<cfelseif isdefined("attributes.record_date_2") and isdate(attributes.record_date_2)>
					AND I.RECORD_DATE <= #attributes.record_date_2#
				</cfif>
				<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
					AND 
					(
						I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.CITY = #attributes.city_id#) OR
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_CITY_ID = #attributes.city_id#)
					)
				</cfif>

				<cfif isdefined("attributes.member_add_option_id") and len(attributes.member_add_option_id)>
					AND 
					(
						I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.MEMBER_ADD_OPTION_ID = #attributes.member_add_option_id#) OR
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CU WHERE CU.MEMBER_ADD_OPTION_ID = #attributes.member_add_option_id#)
					)
				</cfif>

				<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
					AND I.ZONE_ID = #attributes.zone_id#
				</cfif>
				<cfif isdefined("attributes.product_id") and len(trim(attributes.product_name)) and len(attributes.product_id)>
					AND P.PRODUCT_ID = #attributes.product_id# 
				</cfif>
				<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND I.CONSUMER_ID = #attributes.consumer_id# 
				<cfelseif isdefined('attributes.company_id') and len(trim(attributes.company)) and len(attributes.company_id)>	
					AND I.COMPANY_ID = #attributes.company_id# 
				</cfif>
				<cfif session.ep.our_company_info.is_efatura  and attributes.is_einvoice neq -1>
					<cfif isdefined("attributes.is_einvoice") and attributes.is_einvoice eq 1 >
						AND
						( 
							(C.USE_EFATURA = 1 AND C.EFATURA_DATE <= I.INVOICE_DATE) OR (CONS.USE_EFATURA = 1 AND CONS.EFATURA_DATE <= I.INVOICE_DATE)
						)
					<cfelseif isdefined("attributes.is_einvoice") and attributes.is_einvoice eq 0 >
						AND
						( 
							(C.USE_EFATURA = 0 OR CONS.USE_EFATURA = 0 OR C.EFATURA_DATE > I.INVOICE_DATE OR CONS.EFATURA_DATE > I.INVOICE_DATE)
						)
					</cfif>
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>I.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C
						WHERE 
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(C.COMPANYCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> I.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C
						WHERE 
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(C.CONSUMER_CAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
					<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
				</cfif>
				<cfif Len(attributes.cat)>
					<cfif ListLen(attributes.cat,'-') eq 1 and attributes.cat eq 0><!--- Sadece Alislar --->
						AND I.PURCHASE_SALES = 0
					<cfelseif ListLen(attributes.cat,'-') eq 1 and attributes.cat eq 1><!--- Sadece Satislar --->
						AND I.PURCHASE_SALES = 1 
						AND I.INVOICE_CAT NOT IN(67,69)
					<cfelseif ListLen(attributes.cat,'-') eq 1><!--- Ana Islem Tipleri --->
						AND I.INVOICE_CAT IN (#ListFirst(attributes.cat,'-')#)
					<cfelseif ListLen(attributes.cat,'-') gt 1><!--- Alt Islem Tipleri --->
						AND(<cfloop list="#attributes.cat#" index="indx">
							I.PROCESS_CAT IN (#ListLast(indx,'-')#) <cfif indx neq listlast(attributes.cat)>OR</cfif>
						</cfloop>)
					<cfelse>
						AND I.INVOICE_CAT NOT IN(67,69)
					</cfif>
				<cfelse>
					AND I.INVOICE_CAT NOT IN(67,69)
				</cfif>
				<cfif isdefined('attributes.not_printed')>AND I.PRINT_COUNT IS NULL</cfif>
		<cfif isdefined("attributes.not_list")>)</cfif>
		ORDER BY
			I.INVOICE_NUMBER
	</cfquery>
	<cfset fatura_list = valuelist(get_invoice.invoice_id,',')>
    <cfif isdefined("attributes.is_send_mail") and attributes.is_send_mail eq 1>
    	<cfif len(fatura_list)>
            <cfloop list="#fatura_list#" index="i">
                <cfquery name="fatura_" datasource="#DSN2#">
                    SELECT 
                        INVOICE_ID
                        ,COMPANY_ID
                    FROM 
                        INVOICE
                    WHERE  
                        INVOICE_ID = #i#
                        <cfif isdefined('attributes.not_printed')>AND PRINT_COUNT IS NULL</cfif>
                </cfquery>
                <cfif len(fatura_.COMPANY_ID)>
                    <cfquery name="get_partner" datasource="#dsn#">
                        SELECT 
                            COMPANY_PARTNER_EMAIL AS EMAIL
                        FROM 
                            COMPANY_PARTNER
                        WHERE  
                            COMPANY_ID = #fatura_.company_id#
                            AND IS_SEND_FINANCE_MAIL = 1 
                            AND COMPANY_PARTNER_EMAIL IS NOT NULL
                    </cfquery>
                <cfelse>
                	<cfset get_partner.recordcount = 0>
                </cfif>
                <cfif get_partner.recordcount>
					<cfset filename = 'fatura_#i#_'& dateformat(now(),'DDMMYYYY')&'_'&round(rand()*100)>                   
					<cfdocument format="pdf" filename="#upload_folder#reserve_files\#filename#.pdf" orientation="portrait" backgroundvisible="false" pagetype="custom" unit="cm" pageheight="28" pagewidth="21" >
                    <style type="text/css">table{font-size:7px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}</style>
                            <cfset attributes.iid = fatura_.INVOICE_ID>
                            <cfset url.iid = fatura_.INVOICE_ID>
                            <cfquery name="GET_PRINT_COUNT" datasource="#DSN2#">
                                SELECT PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = #ATTRIBUTES.IID#
                            </cfquery>
                            <cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
                                <cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
                            <cfelse>
                                <cfset PRINT_COUNT = 1>
                            </cfif>	
                            <cfquery name="UPD_PRINT_COUNT" datasource="#DSN2#">
                                UPDATE INVOICE SET PRINT_COUNT = #PRINT_COUNT# WHERE INVOICE_ID = #ATTRIBUTES.IID#
                            </cfquery>
                            <cfif get_det_form.is_standart eq 1>
                                <cfinclude template="/#get_det_form.template_file#">
                            <cfelse>
                                <cfinclude template="#file_web_path#settings/#get_det_form.template_file#">
                            </cfif>
                    </cfdocument>
                    <cfset comp_name = session.ep.company_nick>
					<cfset my_subj = comp_name&" Fatura Bildirim Servisi">
                    <cfloop query="get_partner"><!--- #EMAIL# --->
                    	<cfmail to="#EMAIL#" from="#session.ep.company_email#" subject="#my_subj#" type="html" mimeattach="#upload_folder#reserve_files\#filename#.pdf">
                    		<!---<cfinclude template="../../documents/templates/toplu_fatura/toplu_fatura_sablon.cfm">--->
                            <cfinclude template="#file_web_path#templates/toplu_fatura/toplu_fatura_sablon.cfm">
                    	</cfmail>
                    </cfloop>
                </cfif>
        </cfloop>
            <table width="100%">
                <tr height="500">
                    <td class="formbold" style="text-align:center"><cf_get_lang dictionary_id='57513.Mail Başarıyla Gönderildi'></td>
                </tr>
            </table>
            <script type="text/javascript">
                function waitfor()
                {
                    window.close();
                }
                setTimeout("waitfor()",500); 
            </script>	
        </cfif>
    </cfif>
    <cfif isdefined('attributes.pdf_aktar')><!--- pdf getir secilmis ise --->
		<cfif len(fatura_list)>
			<cfdocument format="pdf" orientation="portrait" backgroundvisible="false" pagetype="custom" unit="cm" pageheight="28" pagewidth="21" >
				<style type="text/css">table{font-size:7px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}</style>
					<cfset _row_count_c = 0>					
					<cfloop list="#fatura_list#" index="i">
						<cfset _row_count_c = _row_count_c+1>
						<cfquery name="fatura_" datasource="#DSN2#">
							SELECT 
								INVOICE_ID 
							FROM 
								INVOICE 
							WHERE
								INVOICE_ID = #i#
								<cfif isdefined('attributes.not_printed')>AND PRINT_COUNT IS NULL</cfif>
						</cfquery>
						<cfif fatura_.recordcount>
							<cfset attributes.iid = fatura_.INVOICE_ID>
							<cfset url.iid = fatura_.INVOICE_ID>
							<cfquery name="GET_PRINT_COUNT" datasource="#DSN2#">
								SELECT PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = #ATTRIBUTES.IID#
							</cfquery>
							<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
								<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
							<cfelse>
								<cfset PRINT_COUNT = 1>
							</cfif>	
							<cfquery name="UPD_PRINT_COUNT" datasource="#DSN2#">
								UPDATE INVOICE SET PRINT_COUNT = #PRINT_COUNT# WHERE INVOICE_ID = #ATTRIBUTES.IID#
							</cfquery>
							<cfif get_det_form.is_standart eq 1>
								<cfinclude template="/#get_det_form.template_file#">
							<cfelse>
								<cfinclude template="#file_web_path#settings/#get_det_form.template_file#">
							</cfif>
								<!--- Son sayfa ise boş bir sayfa daha açmasın! --->
							   <cfif ListLen(fatura_list,',') neq _row_count_c><cfdocumentitem type="pagebreak"/></cfif>
						</cfif>
					</cfloop>				
			</cfdocument>
		</cfif>
	<cfelseif isdefined('attributes.pdf_olustur')><!--- pdf oluştur secilmis ise --->
		<link rel="stylesheet" href="/css/assets/template/w3-bootstrap/bootstrap-catalyst.css" type="text/css">
		<script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
 		<script src="/JS/assets/plugins/menuDesigner/axios.min.js"></script>
		<style>
			iframe.template-preview-zoom {
				transform: unset !important;
				position: fixed;
				top: 5px;
				height: 700px !important;
				width: 700px !important;
				left: calc(50% - 350px);
				background: white;
				border: 3px solid #c1c1c1 !important;
				box-shadow: -1px 0px 5px 0px #00000082;
				z-index: 999;
			}
			table.big_list_head {
				display: none;
			}
			.sticky-bar-priview {
				position: sticky;
				top: 0px;
			}
			table.fixed_headers thead tr th {
				background:white;
				border-bottom: none !important;
				position: sticky;
				top: 0px;
				box-shadow: inset 0px -2px 0 #dee2e6;
			}
			#preview_load{
				position: absolute;font-size: 50px;top: 200px;left: 114px;
			}

		</style>
		<section class="row bootstrap-catalyst ml-2" id="create_pdf_app">
			<div class="rw justify-content-center">
				<div class="cl-8">
					<div class="card">
						<div class="card-header text-white bg-info ">
							<cf_get_lang dictionary_id="29739.Pdf Üret">
						</div>
						<div class="card-body pt-0">
							<table class="table table-hover fixed_headers">
								<thead>
									<tr>
									<th scope="col">#</th>
									<th scope="col"><cf_get_lang dictionary_id="44592.Name"></th>
									<th scope="col"><cf_get_lang dictionary_id="32820.Detail"></th>
									<th scope="col"><cf_get_lang dictionary_id="30111.Status"></th>
									</tr>
								</thead>
								<tbody>
									<cfset row_num = 0> 
									<cfloop list="#fatura_list#" index="i">
										<cfset row_num++> 
										<cfquery name="fatura_" datasource="#DSN2#">
											SELECT 
												I.INVOICE_ID,
												I.INVOICE_NUMBER,
												ISNULL(ISNULL(FORMAT (I.INVOICE_DATE,'ddMMyyyy') + '_' + right ('00000000'+ltrim(str( convert(varchar,SERIAL_NO) )),8 ) + '_' + ISNULL(right ('000000'+ltrim( convert(varchar,SC.SUBSCRIPTION_NO) ),6 ) ,'000000'),convert(varchar,INVOICE_NUMBER)+ '_INVOICE'),convert(varchar,INVOICE_ID) + '_INVOICE') FILE_NAME
											FROM  
												INVOICE I
                    							LEFT JOIN #DSN3#.SUBSCRIPTION_CONTRACT SC ON SC. SUBSCRIPTION_ID = I.SUBSCRIPTION_ID
											WHERE 
												I.INVOICE_ID = #i#
												<cfif isdefined('attributes.not_printed')>AND I.PRINT_COUNT IS NULL</cfif>
										</cfquery>
										<cfoutput>
											<tr :data-id="invoice_list[#row_num-1#]=#fatura_.INVOICE_ID#" data-row="#row_num#" data-status="0">
												<th scope="row">#row_num#</th>
												<td>{{pdf_prefix}}_#fatura_.FILE_NAME#.pdf</td>
												<td>
												inovice number : #fatura_.INVOICE_NUMBER# <br>
												invoice Id : #fatura_.INVOICE_ID#
												</td>
												<td data-icon @click="preview_id = #fatura_.INVOICE_ID#"><i class="fa fa-file-pdf-o text-info btnPointer" style="font-size: 18px;"></i></td>
											</tr>
										</cfoutput>
									</cfloop>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="cl-4">
					<div class="sticky-bar-priview">
						<div class="card">
							<div class="card-header">
								<cf_get_lang dictionary_id="59807.Önizleme">
								<i class="catalyst-size-fullscreen float-right btnPointer" onClick="$('iframe#template-preview').toggleClass('template-preview-zoom')"></i>
							</div>
							<div class="card-body pt-0" style="height: 360px; overflow: hidden; ">
								<i class="fa fa-spinner fa-spin text-info" id="preview_load" style="display: none;"></i>
								<iframe v-if="preview_id != null" id="template-preview" style="overflow-x: hidden; transform: scale(0.3); margin: 0 !important; width: 211mm; height: 298mm; transform-origin: top left; border: 1px solid black; "  frameborder="0" :src="'index.cfm?fuseaction=objects.emptypopup_print_files_inner&amp;iid=' + preview_id + '&amp;action_type=59&amp;print_type=10&amp;form_type=<cfoutput>#attributes.form_type#</cfoutput>&amp;iframe=1'" ></iframe>
							</div>
						</div>
						<div class="card no-bg no-border">
							<button type="button" class="btn btn-danger" @click="createPdf()"><cf_get_lang dictionary_id="59808.Pdf Oluştur"></button>
							<button type="button" class="btn btn-success mt-2" id="downloadPdfArchive" @click="downloadPdfArchive()" v-if="download_archive"><cf_get_lang dictionary_id="59809.Arşivi İndir"></button>
							<div class="rw mx-0">
								<div class="cl-12 px-0 mt-2">
									<div class="frn-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id="59810.Pdf İsim Ön Eki"></cfsavecontent>
										<label><cfoutput>#message#</cfoutput></label>
										<input type="text" class="frm-control" name="pdf_prefix" v-model="pdf_prefix" placeholder="<cfoutput>#message#</cfoutput>">
									</div>
								</div>
							</div>
							<div class="frm-check pl-0 mt-2">
								<input v-show="false" class="form-check-input" type="checkbox" id="send_mail" value="" v-model="send_pdf">
								<label v-show="false" class="form-check-label mr-2 mt-0" for="send_mail">
									<cf_get_lang dictionary_id="34514.E-Posta Gönder">
								</label>
								<input v-show="false" class="form-check-input" type="checkbox" id="send_kep" value="" v-model="send_kep">
								<label v-show="false" class="form-check-label mr-2 mt-0" for="send_kep">
									<cf_get_lang dictionary_id="59812.KEP Gönder">
								</label>
								<div class="clearfix"></div>
								<input class="form-check-input" type="checkbox" id="copy_two" value="" v-model="copy_two">
								<label class="form-check-label mr-2 mt-0" for="copy_two">
									2 <cf_get_lang dictionary_id="59813.Nüsha Oluştur"> 
								</label>
							</div>
						</div>
					</div>
				</div>
			</div>  
		</section>
		<script>
			var wcp = new Vue({
				el: '#create_pdf_app',
				data: {   
				invoice_list:[],
				preview_id : <cfoutput>#ListGetAt(fatura_list,1)#</cfoutput>, 
				sequence : 0,
				send_pdf : false,
				send_kep : false,
				copy_two : false,
				pdf_prefix : '',
				folder_prefix : '',
				download_archive: false,
				error: []
				},
				mounted () {
					var random_prefix = "";
					var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
					
					for (var i = 0; i < 6; i++){
						random_prefix += possible.charAt(Math.floor(Math.random() * possible.length));
					}
						
					this.pdf_prefix = $('#form_type option:selected').data('name'); 
					this.folder_prefix =  '<cfoutput>#DateFormat(NOW(),'ddmmyyyy')#</cfoutput>_' + random_prefix;
				},
				methods: {
					createPdf: function(value){
						if (!value) value = wcp.invoice_list[0];
						if (wcp.sequence <= wcp.$data.invoice_list.length){
												
							var status_content = $('[data-id="'+value+'"] [data-icon]');
							var status = $('[data-id="'+value+'"]').data('status');
							if(status == 0 || status == -1 ){
								$(status_content).empty().append('<i class="fa fa-spinner fa-spin text-warning btnPointer" style="font-size: 18px; z-index:-1;"></i>');
								axios
									.get("/WDO/workdev/cfc/createPdf.cfc",{
										params:{
											method		: 'invoice_pdf',
											id			: value,
											form_type	: $('#form_type').val(),
											send_pdf	: wcp.send_pdf,
											send_kep	: wcp.send_kep,
											copy_two	: wcp.copy_two,
											pdf_prefix  : wcp.pdf_prefix,
											source		: wcp.folder_prefix,
										}
									})
									.then(
										response => {
											if(response.data.STATUS == true){
												$(status_content).empty().append('<i class="fa fa-file-pdf-o text-success btnPointer" style="font-size: 18px;"></i>');
												$('[data-id="'+value+'"]').data('status',1).attr('data-status',1);
											}else{
												wcp.error.push({ecode: 1000, message:response.data.error}) 
												$(status_content).empty().append('<i class="fa fa-file-pdf-o text-danger btnPointer" style="font-size: 18px;" title="'+response.data.ERROR+'"></i>');
												$('[data-id="'+value+'"]').data('status',-1).attr('data-status',-1);
											}
											wcp.sequence = wcp.sequence + 1;
											wcp.createPdf(wcp.invoice_list[wcp.sequence]);											
										}
									)
									.catch(
										e => {
												wcp.error.push({ecode: 2000, message:response.data.ERROR}) 
												$(status_content).empty().append('<i class="fa fa-file-pdf-o text-danger btnPointer" style="font-size: 18px;"></i>');
												$('[data-id="'+value+'"]').data('status',-1).attr('data-status',-1);
												wcp.sequence = wcp.sequence + 1;
												wcp.createPdf(wcp.invoice_list[wcp.sequence]);
										}
									);								
							}else{
								wcp.sequence = wcp.sequence + 1;
								wcp.createPdf(wcp.invoice_list[wcp.sequence]);
							}
						
						}else{
							wcp.download_archive = true;
							wcp.sequence = 0;
						}
					},
					downloadPdfArchive: function(){
						console.info('download pdf archive fn');
						$('#downloadPdfArchive').attr('disabled',true);
						$('#downloadPdfArchive').html('<i class="fa fa-spinner fa-spin text-white"></i> Paketleniyor');
						
						axios
							.get("/WDO/workdev/cfc/createPdf.cfc",{
								params:{
									method		: 'zip_pdf',
									copy_two	: wcp.copy_two,
									source		: wcp.folder_prefix
								}
							})
							.then(
								response => {
									console.log(response.data.INVOICE);
									if(response.data.STATUS == true){
										$('#downloadPdfArchive').html('<i class="fa fa-spinner fa-spin text-white"></i> İndiriliyor');
										console.log(response.data);
										window.open(response.data.ZIP,"_self",'zip');
										console.log(response.data.ZIP_COPY.length);
										if(response.data.ZIP_COPY.length){	
											setTimeout(function(){
												window.open(response.data.ZIP_COPY,"_self",'zip_copy');
											 }, 500);										
											
										}
										$('#downloadPdfArchive').html('Arşivi İndir');
										$('#downloadPdfArchive').attr('disabled',false);								
										wcp.error.push({ecode: 4000, message:response.data.error}) 
									}
								}
							)
							.catch(
								e => {
									$('#downloadPdfArchive').html('Arşivi İndir');
									$('#downloadPdfArchive').attr('disabled',false);
									wcp.error.push({ecode: 3000, message:response.data.ERROR}) 
								}
							);

					},
					folder_prefix: function generateRandomString(length) {
						var text = "";
						var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
						
						for (var i = 0; i < length; i++)
							text += possible.charAt(Math.floor(Math.random() * possible.length));
						
						return text;
					}
				},
				watch:{
					 preview_id: function () {
						$('#preview_load').show();
						setTimeout(function(){
							$('#preview_load').hide();
						}, 1200);
					 }
				}   
			})		
		</script>
    <cfelse>	
		<cfif len(fatura_list)>
			<cfloop list="#fatura_list#" index="i">
				<cfquery name="fatura_" datasource="#DSN2#">
					SELECT 
						INVOICE_ID 
					FROM 
						INVOICE 
					WHERE 
						INVOICE_ID = #i#
						<cfif isdefined('attributes.not_printed')>AND PRINT_COUNT IS NULL</cfif>
				</cfquery>
				<cfif fatura_.recordcount>
					<cfset attributes.iid = fatura_.INVOICE_ID>
					<cfset url.iid = fatura_.INVOICE_ID>
					<cfquery name="GET_PRINT_COUNT" datasource="#DSN2#">
						SELECT PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = #ATTRIBUTES.IID#
					</cfquery>
					<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
						<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
					<cfelse>
						<cfset PRINT_COUNT = 1>
					</cfif>	
					<cfquery name="UPD_PRINT_COUNT" datasource="#DSN2#">
						UPDATE INVOICE SET PRINT_COUNT = #PRINT_COUNT# WHERE INVOICE_ID = #ATTRIBUTES.IID#
					</cfquery>
					<!-- sil -->
					<table class="collectedPrint" style="page-break-after: always"><tr><td>
					<cfif get_form.is_standart eq 1>
						<cfinclude template="/#get_form.template_file#">
					<cfelse>
						<cfinclude template="#file_web_path#settings/#get_form.template_file#">
					</cfif>
				</td></tr></table>
					<!-- sil -->
				</cfif>
			</cfloop>	
		</cfif>			
    </cfif>
</cfif>
<script type="text/javascript">
function kontrol()
{
	<cfif isdefined("is_invoice_date")>
		var is_invoice_date = '<cfoutput>#is_invoice_date#</cfoutput>';
	<cfelse>
		var is_invoice_date = 0;
	</cfif>
	<cfif session.ep.our_company_info.is_efatura>
		if(document.getElementById('is_einvoice').value == '')
		{
			alert("<cf_get_lang dictionary_id='59814.E-Fatura Tipi Seçiniz'>!");
			return false;
		}
		else if(document.getElementById('is_einvoice').value == 1)
		{
			if(confirm("<cf_get_lang dictionary_id='34675.E-Fatura Olan Bir Belgeleri Bastırmak İstiyorsunuz'> !") == true); else return false;
		}
	</cfif>
	var invVal = $("#is_einvoice").val();
	if(invVal == 0 && is_invoice_date != 1)
	{
		if(document.page_print.first_invoice.value == "")
		{
			alert("<cf_get_lang dictionary_id ='57012.İlk Fatura No Girmelisiniz'>!");
			return false;
		}
		if(document.page_print.last_invoice.value == "")
		{
			alert("<cf_get_lang dictionary_id ='57018.Son Fatura No Girmelisiniz'> !");
			return false;
		}
	}
	else
	{
		if(document.page_print.first_invoice.value != "" && document.page_print.last_invoice.value == "")
		{
			alert("<cf_get_lang dictionary_id ='57018.Son Fatura No Girmelisiniz'> !");
			return false;
		}
		if(document.page_print.first_invoice.value == "" && document.page_print.last_invoice.value != "")
		{
			alert("<cf_get_lang dictionary_id ='57012.İlk Fatura No Girmelisiniz'> !");
			return false;
		}
	}
	
	x = document.page_print.form_type.selectedIndex;
	if (document.page_print.form_type[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id ='57804.Baskı Formu Seçiniz'> !");
		return false;
	}
	document.getElementById('not_printed').disabled=false;
	return true;
}
function mail_gonder()
{
	<cfif isdefined("attributes.form_type")>
		document.getElementById('is_send_mail').value = 1;	
		document.page_print.submit();
		get_wrk_message_div("<cf_get_lang dictionary_id='29729.İşlem Durumu'>, <cf_get_lang dictionary_id='57704.İşlem Yapılıyor'>");
	<cfelse>
		alert('Önce listeleme yapınız');
		return false;
	</cfif>
}
<cfif attributes.is_einvoice eq 1 or not len(attributes.is_einvoice)>
	$("#first_inv, #last_inv").hide();
</cfif>
function showinput(val){
	if(val == 1 || val == ''){
		$("#first_inv, #last_inv").hide();
	}else{
		$("#first_inv, #last_inv").show();
	}
}
function gonder(str_alan_1)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=page_print.company_id&field_comp_name=page_print.company&select_list=2&keyword='+encodeURIComponent(page_print.company.value),'list');
}

$( "#pdf_olustur" ).click(function() {
  $('#maxrows').val('');
});
</script>

