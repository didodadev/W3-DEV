<cfparam name="attributes.process_cat_id" default="">
<cfparam name="attributes.imp_source_id" default="">
<cfparam name="attributes.start_date" default="#dateformat(dateadd('m',-1,now()),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.is_excel" default="">

<cfif len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_improper_products" datasource="#dsn3#">
		SELECT 
       		PRODUCT_NAME,
			SETUP_IMPROPRIETY_SOURCE.IMP_SOURCE_NAME,
			IMPROPER_PRODUCTS.*,
			ORDER_RESULT_QUALITY.PROCESS_CAT
		FROM
			IMPROPER_PRODUCTS JOIN ORDER_RESULT_QUALITY ON OR_Q_ID = QUALITY_CONTROL_ID <!--- Kalite sayfasında kayıtları bulamadığı için left join i join e çevirdim MT --->
            LEFT JOIN PRODUCT ON IMPROPER_PRODUCTS.PRODUCT_ID = PRODUCT.PRODUCT_ID
			LEFT JOIN SETUP_IMPROPRIETY_SOURCE ON SETUP_IMPROPRIETY_SOURCE.IMP_SOURCE_ID=IMPROPER_PRODUCTS.IMP_SOURCE_ID
		WHERE
			1 = 1 
			<cfif len(attributes.imp_source_id)>
				AND IMPROPER_PRODUCTS.IMP_SOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.imp_source_id#">
			</cfif>
			<cfif len(attributes.start_date)>
				AND IMP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			</cfif>
			<cfif len(attributes.finish_date)>
				AND IMP_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.finish_date)#">
			</cfif> 
			<cfif len(attributes.process_cat_id)>
				AND ORDER_RESULT_QUALITY.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_id#">
			</cfif> 
	</cfquery> 
<cfelse>
	<cfset get_improper_products.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_improper_products.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = ''>
<cfif isDefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
	<cfset url_str = '#url_str#&is_form_submitted=1'>
</cfif>
<cfif isdefined("attributes.process_cat_id") and len(attributes.process_cat_id)>
	<cfset url_str = '#url_str#&process_cat_id=#attributes.process_cat_id#'>
</cfif>
<cfif len(attributes.imp_source_id)>
	<cfset url_str = '#url_str#&imp_source_id=#attributes.imp_source_id#'>
</cfif>
<cfif isdate(attributes.start_date)>
	<cfset url_str = '#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = '#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
</cfif>
<cfquery name="get_imp_sources" datasource="#dsn3#">
	SELECT IMP_SOURCE_ID,IMP_SOURCE_NAME FROM SETUP_IMPROPRIETY_SOURCE ORDER BY IMP_SOURCE_NAME
</cfquery>
<cfform name="form_imp_source" action="" method="post">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='39185.Uygun Olmayan Ürün Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
										<div class="col col-12"> 
                                            <select name="process_cat_id" id="process_cat_id" style="width:110px;">
                                                <option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
                                                <option value="76" <cfif attributes.process_cat_id eq 76>selected</cfif>><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></option>
                                                <option value="171" <cfif attributes.process_cat_id eq 171>selected</cfif>><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
                                                <option value="811" <cfif attributes.process_cat_id eq 811>selected</cfif>><cf_get_lang dictionary_id='29588.İthal Mal Girişi'></option>
                                            <!---  <option value="-1" <cfif attributes.process_cat_id eq -1>selected</cfif>>Operasyonlar</option>
                                                    <option value="-1" <cfif attributes.process_cat_id eq -1>selected</cfif>>Servis</option> islem kategorilerinde karsiligi olmadıgi icin kapatildi MA 17072013--->
                                            </select>
										</div>
									</div>
								</div>
							</div>
                            <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40586.Uygunsuzluk Kaynağı'></label>
										<div class="col col-12 col-xs-12">		
                                            <select name="imp_source_id" id="imp_source_id" style="width:140px;">
                                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                <cfoutput query="get_imp_sources">
                                                    <option value="#imp_source_id#"<cfif imp_source_id eq attributes.imp_source_id>selected</cfif>>#imp_source_name#</option>
                                                </cfoutput> 
                                            </select>
										</div>						
									</div>  									            
								</div>
							</div>
                            <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58690.Tarih Aralığı'></label>
										<div class="col col-6">
											<div class="input-group">
											    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                                <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" required="yes" style="width:62px;">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="start_date">
												</span>	
										    </div>	
										</div>
										<div class="col col-6">
											<div class="input-group">
											    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
												<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#"  message="#message#" maxlength="10" style="width:62px;" required="yes">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="finish_date">
												</span>
										    </div>		
                                        </div>	
									</div>																	
                                </div>
							</div> 
						</div>
					</div>
					<div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
							<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
							<cf_wrk_report_search_button button_type='1' search_function='control()' is_excel='1'>					
					    </div>	  
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search> 
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
    <cf_report_list>
        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset type_ = 1>
            <cfset attributes.startrow=1>
            <cfset attributes.maxrows = get_improper_products.recordcount>
        <cfelse>
            <cfset type_ = 0>
        </cfif>
        <cfset total_imp_quantity = 0>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                    <th width="160"><cf_get_lang dictionary_id='57657.Ürün'>/<cf_get_lang dictionary_id='40582.Malzeme Adı'></th>
                    <th width="160"><cf_get_lang dictionary_id='40584.Oluştuğu Birim'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='40585.Uygunsuzluk Tanımı'></th>
                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th width="200"><cf_get_lang dictionary_id='40586.Uygunsuzluk Kaynağı'></th>
                    <th width="150"><cf_get_lang dictionary_id='45264.Yapılan İşlem'></th>
                </tr>
            </thead>
            <cfif get_improper_products.recordcount>           
                <tbody>
                    <cfoutput query="get_improper_products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>
                                <cfif type_ neq 1>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.popup_upd_quality_control_report_rows&or_q_id=#QUALITY_CONTROL_ID#&PROCESS_CAT=#process_cat#','wide');">#PRODUCT_NAME#</a>
                                <cfelse>
                                    #PRODUCT_NAME#
                                </cfif>
                            </td>
                            <td>#create_unit#</td>
                            <td>#imp_definition#</td>
                            <td width="200" format="numeric">#imp_quantity#</td>
                            <cfif len(imp_quantity)><cfset total_imp_quantity = total_imp_quantity + imp_quantity></cfif>
                            <td style="text-align:right;">#IMP_SOURCE_NAME#</td>
                            <td style="text-align:right;">#process#</td>
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                <tr>
                    <td colspan="4" class="txtbold" style="text-align:left;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                    <td class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#total_imp_quantity#</cfoutput></td>
                    <td colspan="2"></td>
                </tr>
                </tfoot>
            <cfelse>
                <tbody>
                    <tr>
                        <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </tbody>
            </cfif> 
    </cf_report_list>
</cfif> 
<cfif isdefined('attributes.totalrecords') and attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = attributes.fuseaction >
			<cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
				<cfset url_str ="#url_str#&is_form_submitted=#attributes.is_form_submitted#">
			</cfif>
			<cfif isdefined('attributes.process_cat_id') and len(attributes.process_cat_id)>
				<cfset url_str ="#url_str#&process_cat_id=#attributes.process_cat_id#">
			</cfif>
			<cfif isdefined('attributes.imp_source_id') and len(attributes.imp_source_id)>
				<cfset url_str ="#url_str#&imp_source_id=#attributes.imp_source_id#">
			</cfif>
			<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
				<cfset url_str ="#url_str#&start_date=#attributes.start_date#">
			</cfif>
			<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
				<cfset url_str ="#url_str#&finish_date=#attributes.finish_date#">
			</cfif>
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#url_str#">	
</cfif>   
<script>
    function control()
    {
		if ((document.form_imp_source.start_date.value != '') && (document.form_imp_source.finish_date.value != '') &&
	    !date_check(form_imp_source.start_date,form_imp_source.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
        if(document.form_imp_source.is_excel.checked==false)
                {
                    document.form_imp_source.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                    return true;
                }
                else
					document.form_imp_source.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_improper_product_report</cfoutput>"  
    }
   
</script>
