<!--- company den gelen position_code artik workgroup_emp_par tablosundan getiriliyor FB 20070529--->
<!---
Create:20070404 Ayşenur
	attributes.report_type 1 : İşlem Belge Bazında
	attributes.report_type 2 : Müşteri Kategorisi Bazında
	attributes.report_type 3 : Satış Bölgesi Bazında
	attributes.report_type 4 : Müşteri Temsilcisi Bazında
	attributes.report_type 5 : Müşteri Bazında
	attributes.report_type 6 : Bankalar Bazında
	attributes.report_type 7 : Kasalar Bazında
	attributes.report_type 8 : Müşteri Bazında Kredi Kartı Tahsilatları/Ödemeleri
	attributes.report_type : 9 Müşteri Bazında Toplu Pos Dönüşleri
	attributes.report_type : 10 Müşteri ve Tarih Bazında Toplu Pos Dönüşleri
Rapor,Cari hareketlerden yola çıkarak,yukarıdaki bazlarda toplamları getirir
8. işlem tipinde kredi kartı tahsilatlarını müşteriye göre gruplayarak getirir
9 ve 10 tiplerinde finans banka altındaki toplu pos dönüşleri işlemlerinden çıkararak getirir
--->

<!--- <cfflush interval="3000"> excel getirde sorun oldugundan kapatildi --->
<cfparam name="attributes.module_id_control" default="16">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.customer_value_id" default=""><!--- musteri degeri --->
<cfparam name="attributes.resource_id" default=""><!--- iliski tipi --->
<cfparam name="attributes.zone_id" default=""><!--- satis bolgesi --->
<cfparam name="attributes.report_type" default=""><!--- rapor tipi ---> 
<cfparam name="attributes.date1" default="#now()#">
<cfparam name="attributes.date2" default="#now()#">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.companycat_id" default=""> 
<cfparam name="attributes.consumercat_id" default="">
<cfparam name="attributes.main_report_type" default="1">
<cfparam name="attributes.member_type_info" default="1">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="devir_toplam" default="0">
<cfparam name="islem_sayfasi" default="1">
<cfparam name="islem_sayfasi_tutari" default="1">
<cfparam name="islem_sayfasi_tutari1" default="1">
<cfparam name="islem_sayfasi_tutari2" default="1">
<cfparam name="islem_sayfasi_tutari3" default="1">
<cfparam name="islem_sayfasi_tutari4" default="1">
<cfparam name="islem_sayfasi_tutari5" default="1">
<cfparam name="islem_sayfasi_tutari6" default="1">
<cfparam name="islem_sayfasi_tutari7" default="1">
<cfparam name="islem_sayfasi_tutari8" default="1">
<cfparam name="islem_sayfasi_tutari9" default="1">
<cfparam name="islem_sayfasi_tutari10" default="1">
<cfparam name="devir_toplam1" default="0">
<cfparam name="devir_toplam2" default="0">
<cfparam name="devir_toplam3" default="0">
<cfparam name="devir_toplam4" default="0">
<cfparam name="devir_toplam5" default="0">
<cfparam name="devir_toplam6" default="0">
<cfparam name="devir_toplam7" default="0">
<cfparam name="devir_toplam8" default="0">
<cfparam name="devir_toplam9" default="0">
<cfparam name="devir_toplam10" default="0">
<cfinclude template="../query/get_money_rate.cfm">
<cfset pos_types = "10,11,12,13,14">
<cfif isdefined("attributes.form_submitted")>
	<cfif isdate(attributes.date1)>
		<cf_date tarih = "attributes.date1">
	</cfif>
	<cfif isdate(attributes.date2)>
		<cf_date tarih = "attributes.date2">
	</cfif>
	<cfif attributes.member_type_info eq 1>
		<cfinclude template="../query/get_revenue_company.cfm">
	<cfelse>
		<cfinclude template="../query/get_revenue_consumer.cfm">
	</cfif>
<cfelse>
	<cfset get_cari_rows.recordcount=0>
</cfif>
<cfif isdate(attributes.date1)>
	<cfset attributes.date1 = dateformat(attributes.date1, dateformat_style)>
</cfif>
<cfif isdate(attributes.date2)>
	<cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
</cfif>
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=get_cari_rows.recordcount>
</cfif>
<cfquery name="SZ" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="COMPANY_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		CONSCAT
</cfquery>
<cfset tutar_toplam = 0>

<cfset other_tutar_toplam = 0>
<cfset cash_actions_toplam = 0>
<cfset cash_actions_toplam2 = 0>
<cfset bank_actions_toplam = 0>
<cfset bank_actions_toplam2 = 0>
<cfset cheque_actions_toplam = 0>
<cfset cheque_actions_toplam2 = 0>
<cfset voucher_actions_toplam = 0>
<cfset voucher_actions_toplam2 = 0>
<cfset cc_rev_toplam = 0>
<cfset cc_rev_toplam2 = 0>
<cfset comm_total=0>
<cfset money_list = ''>
<cfset money_list_com = ''>
<cfset kdv_toplam = 0>
 <cfset last_page_ = 0>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_cari_rows.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="rapor" action="#request.self#?fuseaction=report.revenue_analysis" method="post">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='39589.Tahsilat ve Ödeme Analizi'></cfsavecontent>
    <cf_report_list_search title="#title#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='39242.Müşteri Kategorisi'></label>	
                                    <div class="col col-12">			
                                        <div id="company_cat" <cfif isdefined("attributes.member_type_info") and attributes.member_type_info eq 2> style="display:none"</cfif>>
                                            <select name="companycat_id" id="companycat_id" style="width:150px;height:69px;" multiple>
                                                <cfoutput query="company_cat">					    
                                                    <option value="#companycat_id#" <cfif listfind(attributes.companycat_id,companycat_id)> selected</cfif>>#companycat#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                        <div id="consumer_cat" <cfif not(isdefined("attributes.member_type_info") and attributes.member_type_info eq 2)>style="display:none"</cfif>>
                                            <select name="consumercat_id" id="consumercat_id" style="width:150px;height:69px;" multiple>
                                            <cfoutput query="consumer_cat">					    
                                                <option value="#conscat_id#" <cfif listfind(attributes.consumercat_id,conscat_id)> selected</cfif>>#conscat#</option>
                                            </cfoutput>
                                            </select>
                                        </div>
                                    </div>	
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>	
                                    <div class="col col-12">
                                        <div class="input-group">	
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                            <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                            <input type="text" name="company" id="company" style="width:150px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_member_name=rapor.company&select_list=2,3','list');">
                                            </span>
                                        </div>	
                                    </div>									
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></label>	
                                    <div class="col col-12">
                                        <div class="input-group">
                                            <input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
                                            <input type="text" name="pos_code_text" id="pos_code_text" style="width:110px;" value="<cfif len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.pos_code&field_name=rapor.pos_code_text&select_list=1,9','list')"></span>
                                        </div>
                                    </div>									
                                </div>	
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>	
                                    <div class="col col-12">
                                        <select name="customer_value_id" id="customer_value_id" style="width:150px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_customer_value">
                                                <option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value_id>selected</cfif>>#customer_value#</option>
                                            </cfoutput>
                                        </select>
                                    </div>									
                                </div>
                                    <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39224.İlişki Tipi'></label>	
                                    <div class="col col-12">
                                    <cf_wrk_combo
                                            name="resource_id"
                                            query_name="GET_PARTNER_RESOURCE"
                                            option_name="resource"
                                            option_value="resource_id"
                                            value="#attributes.resource_id#"
                                            width="150">
                                    </div>									
                                </div>	
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39080.Mikro Bölge'></label>
                                    <div class="col col-12">
                                        <div class="input-group">     
                                            <cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
                                                <cfquery name="GET_IMS" datasource="#dsn#">
                                                    SELECT * FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #attributes.ims_code_id#
                                                </cfquery>
                                                <input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
                                                <cfinput type="text" name="ims_code_name" style="width:150px;" value="#get_ims.ims_code# #get_ims.ims_code_name#" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');" autocomplete="off">
                                            <cfelse>
                                                <input type="hidden" name="ims_code_id" id="ims_code_id">
                                                <cfinput type="text" name="ims_code_name" style="width:180px;" value="" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');" autocomplete="off">
                                            </cfif>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=rapor.ims_code_name&field_id=rapor.ims_code_id','list');"></span>
                                        </div>
                                    </div>	
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                    <div class="col col-12">
                                        <div class="input-group">
                                            <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                                            <input name="project_head" type="text" id="project_head" style="width:180px;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','rapor','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=rapor.project_head&project_id=rapor.project_id</cfoutput>');"></span>
                                        </div>					
                                    </div>
                                </div>		
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57659.Satis Bölgesi'></label>
                                    <div class="col col-12">         
                                        <select name="zone_id" id="zone_id" style="width:180px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="sz">
                                                <option value="#sz_id#" <cfif attributes.zone_id eq sz_id>selected</cfif>>#sz_name#</option>
                                            </cfoutput>
                                        </select>				
                                    </div>
                                </div>	 			 
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">	
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
                                    <div class="col col-6">
                                        <div class="input-group">        
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                            <cfinput value="#attributes.date1#" type="text" name="date1" maxlength="10" style="width:65px;" required="yes" message="#message#" validate="#validate_style#">
                                            <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="date1"> 
                                            </span>           
                                        </div>					
                                    </div>
                                    <div class="col col-6">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                            <cfinput value="#attributes.date2#"  type="text" name="date2" maxlength="10" style="width:65px;" required="yes" message="#message#" validate="#validate_style#">
                                            <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="date2">	
                                            </span>
                                        </div>
                                    </div> 
                                </div>				
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>	
                                    <div class="col col-12">			
                                        <select name="report_type" id="report_type" style="width:250px;" onchange="kontrol_report_type();">
                                            <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='57692.İşlem'><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                                            <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='40312.Müşteri Kategorisi Bazında'></option>
                                            <option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='39262.Satış Bölgesi Bazında'></option>
                                            <option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='39737.Müşteri Temsilcisi Bazında'></option>
                                            <option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang dictionary_id ='39257.Müşteri Bazında'></option>
                                            <option value="6" <cfif attributes.report_type eq 6>selected</cfif>><cf_get_lang dictionary_id ='57987.Bankalar'><cf_get_lang dictionary_id ='58601.Bazında'> </option>
                                            <option value="7" <cfif attributes.report_type eq 7>selected</cfif>><cf_get_lang dictionary_id ='58657.Kasalar'><cf_get_lang dictionary_id ='58601.Bazında'></option>
                                            <option value="11" <cfif attributes.report_type eq 11>selected</cfif>><cf_get_lang dictionary_id ='29819.Proje Bazında'></option>
                                            <option value="8" <cfif attributes.report_type eq 8>selected</cfif>><cf_get_lang dictionary_id ='40317.Müşteri Bazında Kredi Kartı Tahsilatları'>/<cf_get_lang dictionary_id ='58658.Ödemeleri'></option>
                                            <option value="9" <cfif attributes.report_type eq 9>selected</cfif>><cf_get_lang dictionary_id ='40318.Müşteri Bazında Toplu Pos Dönüşleri'></option>
                                            <option value="10" <cfif attributes.report_type eq 10>selected</cfif>><cf_get_lang dictionary_id ='40319.Müşteri ve Tarih Bazında Toplu Pos Dönüşleri'></option>
                                        </select>                              
                                    </div>	
                                    <div class="form-group">
                                        <div>&nbsp;</div>		
                                        <label><input type="radio" name="main_report_type" id="main_report_type" value="1"  <cfif attributes.main_report_type eq 1>checked</cfif>><cf_get_lang dictionary_id ='57845.Tahsilat'><cf_get_lang dictionary_id ='39666.Analizi'></label> 
                                        <label> <input type="radio" name="main_report_type" id="main_report_type" value="2"  <cfif attributes.main_report_type eq 2>checked</cfif>><cf_get_lang dictionary_id ='57847.Ödeme'><cf_get_lang dictionary_id ='39666.Analizi'></label>              
                                    </div>
                                    <div class="form-group">
                                        <label> <input type="radio" name="member_type_info" id="member_type_info" value="1" onclick="change_cat_type(1);" <cfif attributes.member_type_info eq 1>checked</cfif>><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></label> 
                                        <label> <input type="radio" name="member_type_info" id="member_type_info" value="2" onclick="change_cat_type(2);" <cfif attributes.member_type_info eq 2>checked</cfif>><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></label>                                  
                                    </div>
                                    <div class="form-group">
                                        <label><input type="checkbox" name="is_group_date" id="is_group_date" <cfif isdefined("attributes.is_group_date")>checked<cfelseif listfind('2,3,4,5',attributes.report_type,',')>disabled</cfif>><cf_get_lang dictionary_id="29816.Vade"></label>
                                    </div>    	
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>checked</cfif>></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                        <input type="hidden" name="form_submitted" id="form_submitted" value="">	  
                        <cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
                    </div>
                </div>
            </div>
        </cf_report_list_search_area>		
    </cf_report_list_search> 
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
    <cf_report_list>
    
                
                <!---	<cfparam name="attributes.page" default=1>
                    <cfparam name="attributes.totalrecords" default="#get_cari_rows.recordcount#">
                    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>--->
                    <cfset genel_toplam = 0>
                    <cfif not isdefined("attributes.is_group_date")>
                        <thead>
                            <tr>
                                <cfif attributes.report_type eq 1>
                                    <th style="width:10mm;"><cf_get_lang dictionary_id='57487.No'></th>
                                    <th style="width:20mm;"><cf_get_lang dictionary_id ='30707.Uye Kodu'></th>
                                    <th style="width:100mm;"><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>
                                    <th style="width:100mm;"><cf_get_lang dictionary_id ='57416.Proje'></th>
                                    <th style="width:100mm;"><cfif attributes.main_report_type eq 1><cf_get_lang dictionary_id ='40370.Tahsilat Yeri'><cfelse><cf_get_lang dictionary_id ='58181.Ödeme Yeri'></cfif></th>
                                    <th style="width:30mm;"><cf_get_lang dictionary_id ='57880.Belge No'></th>
                                    <th style="width:80mm;"><cf_get_lang dictionary_id ='57800.İşlem Tipi'></th>
                                    <th style="width:80mm;"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
                                    <th style="width:20mm;"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></th>
                                    <th style="width:20mm;"><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                                    <th style="width:20mm; text-align:right;"><cf_get_lang dictionary_id ='57673.Tutar'></th>
                                    <th style="width:20mm; text-align:right;"><cf_get_lang dictionary_id ='58056.Dövizli Tutar'></th>
                                    <th style="width:20mm; text-align:right;"><cf_get_lang dictionary_id='58474.Birim'></th>
                                <cfelseif listfind("2,3,4,5,6,7,11",attributes.report_type)>
                                    <th style="width:5mm;"><cf_get_lang dictionary_id='57487.No'></th>
                                    <cfif listfind("5",attributes.report_type)>
                                        <th style="width:20mm;"><cf_get_lang dictionary_id ='30707.Uye Kodu'></th>
                                    </cfif>
                                    <th style="width:50mm;">
                                        <cfif attributes.report_type eq 2><cf_get_lang dictionary_id ='39242.Müşteri Kategorisi'>
                                        <cfelseif attributes.report_type eq 3><cf_get_lang dictionary_id='57659.Satis Bölgesi'>
                                        <cfelseif attributes.report_type eq 4><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'>
                                        <cfelseif attributes.report_type eq 5><cf_get_lang dictionary_id='57457.Müşteri'>
                                        <cfelseif attributes.report_type eq 6><cf_get_lang dictionary_id ='57521.Banka'>
                                        <cfelseif attributes.report_type eq 7><cf_get_lang dictionary_id ='57520.Kasa'>
                                        <cfelseif attributes.report_type eq 11><cf_get_lang dictionary_id ='57416.Proje'>
                                        </cfif>
                                    </th>
                                    <cfoutput>
                                        <cfif listfind("2,3,4,5",attributes.report_type)>
                                            <th><cf_get_lang dictionary_id ='57589.Bakiye'></th>
                                            <cfif len(session.ep.money2)><th >#session.ep.money2#<cf_get_lang dictionary_id ='57589.Bakiye'></th></cfif>
                                            <th><cf_get_lang dictionary_id ='40321.Vade Performansı'></th>
                                        </cfif>
                                        <th style="width:50mm;"><cf_get_lang dictionary_id ='40320.Kasa Hareketleri'> #session.ep.money#<cf_get_lang dictionary_id ='57492.Toplam'></th>
                                        <cfif len(session.ep.money2)><th style="width:50mm;"><cf_get_lang dictionary_id ='40320.Kasa Hareketleri'> #session.ep.money2#<cf_get_lang dictionary_id ='57492.Toplam'></th></cfif>
                                        <th style="width:50mm;"><cf_get_lang dictionary_id ='40322.Banka Hareketleri'> #session.ep.money# <cf_get_lang dictionary_id ='57492.Toplam'></th>
                                        <cfif len(session.ep.money2)><th style="width:50mm;"><cf_get_lang dictionary_id ='40322.Banka Hareketleri'> #session.ep.money2#<cf_get_lang dictionary_id ='57492.Toplam'></th></cfif>
                                        <th style="width:50mm;"><cf_get_lang dictionary_id ='58007.Çek'> #session.ep.money#<cf_get_lang dictionary_id ='57492.Toplam'></th>
                                        <cfif len(session.ep.money2)><th style="width:50mm;"><cf_get_lang dictionary_id ='58007.Çek'> #session.ep.money2#<cf_get_lang dictionary_id ='57492.Toplam'></th></cfif>
                                        <th style="width:50mm;"><cf_get_lang dictionary_id ='58008.Senet'> #session.ep.money#<cf_get_lang dictionary_id ='57492.Toplam'></th>
                                        <cfif len(session.ep.money2)><th style="width:50mm;"><cf_get_lang dictionary_id ='58008.Senet'> #session.ep.money2#<cf_get_lang dictionary_id ='57492.Toplam'></th></cfif>
                                        <th style="width:50mm;"><cfif attributes.main_report_type eq 1><cf_get_lang dictionary_id ='57836.Kredi Kartı Tahsilat'> #session.ep.money#<cf_get_lang dictionary_id ='57492.Toplam'><cfelse><cf_get_lang dictionary_id='29553.Kredi Kartıyla Ödeme'> #session.ep.money#<cf_get_lang dictionary_id ='57492.Toplam'></cfif></th>
                                        <cfif len(session.ep.money2)><th style="width:50mm;"><cfif attributes.main_report_type eq 1><cf_get_lang dictionary_id ='57836.Kredi Kartı Tahsilat'> #session.ep.money2#<cf_get_lang dictionary_id ='57492.Toplam'><cfelse><cf_get_lang dictionary_id='29553.Kredi Kartıyla Ödeme'> #session.ep.money2# <cf_get_lang dictionary_id ='57492.Toplam'></cfif></th></cfif>
                                        <cfif attributes.report_type eq 11>
                                            <th style="width:50mm;"><cf_get_lang dictionary_id ='57492.Toplam'><cfif attributes.main_report_type eq 1><cf_get_lang dictionary_id="57845.Tahsilat"><cfelse><cf_get_lang dictionary_id="57847.Odeme"></cfif> #session.ep.money#</th>
                                            <cfif len(session.ep.money2)><th style="width:50mm;"><cf_get_lang dictionary_id ='57492.Toplam'><cfif attributes.main_report_type eq 1><cf_get_lang dictionary_id="57845.Tahsilat"><cfelse><cf_get_lang dictionary_id="57847.Odeme"></cfif> #session.ep.money2#</th></cfif>
                                        </cfif>
                                    </cfoutput>
                                <cfelseif attributes.report_type eq 8>
                                    <th style="width:5mm;"><cf_get_lang dictionary_id='57487.No'></th>
                                    <th style="width:20mm;"><cf_get_lang dictionary_id='30707.Uye Kodu'></th>
                                    <th style="width:50mm;"><cf_get_lang dictionary_id='57457.Musteri'></th>
                                    <th style="width:50mm;"><cf_get_lang dictionary_id='57882.İşlem Tutarı'></th>
                                    <th style="width:50mm;"><cf_get_lang dictionary_id='40324.Döviz Tutarı'></th>
                                    <th style="width:50mm;"><cf_get_lang dictionary_id='40325.Komisyon Tutarı'></th>
                                <cfelseif listfind("9,10",attributes.report_type)>
                                    <cfquery name="GET_COMP" dbtype="query">
                                        SELECT DISTINCT
                                            NICKNAME,
                                            <cfif attributes.report_type eq 10>
                                                PROCESS_DATE,
                                            </cfif>
                                            MEMBER_CODE,
                                            <cfif attributes.member_type_info eq 1>
                                                COMPANY_ID
                                            <cfelse>
                                                CONSUMER_ID
                                            </cfif>
                                        FROM
                                            GET_CARI_ROWS
                                        ORDER BY
                                        <cfif attributes.report_type eq 9>
                                            NICKNAME
                                        <cfelse>
                                            NICKNAME,PROCESS_DATE
                                        </cfif> 
                                    </cfquery>
                                    <cfif attributes.report_type eq 10>
                                    <th style="width:50mm;"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></th>
                                    </cfif>
                                    <th style="width:50mm;"><cf_get_lang dictionary_id ='40326.Müşteri Kodu'></th>
                                    <th style="width:50mm;"><cf_get_lang dictionary_id ='57457.Müşteri'></th>
                                    <cfoutput>
                                        <cfloop from="10" to="14" index="k">
                                        <th style="width:50mm;">
                                            <cfif k eq "10"><cf_get_lang dictionary_id="39541.Akbank"> #session.ep.money# <cf_get_lang dictionary_id ='57492.Toplam'>
                                            <cfelseif k eq "11"><cf_get_lang dictionary_id="39562.İş Bankası"> #session.ep.money# <cf_get_lang dictionary_id ='57492.Toplam'>
                                            <cfelseif k eq "12"><cf_get_lang dictionary_id="39564.HSBC"> #session.ep.money#<cf_get_lang dictionary_id ='57492.Toplam'>
                                            <cfelseif k eq "13"><cf_get_lang dictionary_id="57717.Garanti"> #session.ep.money#<cf_get_lang dictionary_id ='57492.Toplam'>
                                            <cfelseif k eq "14"><cf_get_lang dictionary_id="39567.Yapı Kredi"> #session.ep.money#<cf_get_lang dictionary_id ='57492.Toplam'>
                                            </cfif>
                                        </th>
                                        <cfif len(session.ep.money2)>
                                            <th style="width:50mm;">
                                                <cfif k eq "10"><cf_get_lang dictionary_id="39541.Akbank"> #session.ep.money2#<cf_get_lang dictionary_id ='57492.Toplam'>
                                                <cfelseif k eq "11"><cf_get_lang dictionary_id="39562.İş Bankası"> #session.ep.money2#<cf_get_lang dictionary_id ='57492.Toplam'>
                                                <cfelseif k eq "12"><cf_get_lang dictionary_id="39564.HSBC"> #session.ep.money2# <cf_get_lang dictionary_id ='57492.Toplam'>
                                                <cfelseif k eq "13"><cf_get_lang dictionary_id="57717.Garanti"> #session.ep.money2#<cf_get_lang dictionary_id ='57492.Toplam'>
                                                <cfelseif k eq "14"><cf_get_lang dictionary_id="39567.Yapı Kredi"> #session.ep.money2# <cf_get_lang dictionary_id ='57492.Toplam'>
                                                </cfif>
                                            </th>
                                        </cfif>
                                            <cfquery name="get_inv_#k#" dbtype="query">
                                                SELECT
                                                    *
                                                FROM
                                                    GET_CARI_ROWS WHERE BANK_TYPE = #k#
                                                ORDER BY
                                                <cfif attributes.report_type eq 9>
                                                    <cfif attributes.member_type_info eq 1>COMPANY_ID<cfelse>CONSUMER_ID</cfif>
                                                <cfelse>
                                                    PROCESS_DATE ASC
                                                </cfif>
                                            </cfquery>
                                            <cfset 'ay_cat_list_#k#' = ''>
                                            <cfset 'toplam_ay_#k#' = 0>
                                            <cfset ay_que = evaluate('get_inv_#k#')>
                                            <cfif ay_que.recordcount>
                                                <cfif attributes.report_type eq 9>
                                                    <cfif attributes.member_type_info eq 1>
                                                        <cfset 'ay_cat_list_#k#' = listsort(valuelist(ay_que.COMPANY_ID,','),'numeric','ASC',',')>
                                                    <cfelse>
                                                        <cfset 'ay_cat_list_#k#' = listsort(valuelist(ay_que.CONSUMER_ID,','),'numeric','ASC',',')>
                                                    </cfif>
                                                <cfelse>
                                                    <cfloop query="ay_que">
                                                        <cfif attributes.member_type_info eq 1>
                                                            <cfset 'ay_cat_list_#k#' = listappend(evaluate('ay_cat_list_#k#'),'#company_id#*#process_date#')>
                                                        <cfelse>
                                                            <cfset 'ay_cat_list_#k#' = listappend(evaluate('ay_cat_list_#k#'),'#consumer_id#*#process_date#')>
                                                        </cfif>
                                                    </cfloop>
                                                </cfif>
                                            </cfif>
                                        </cfloop>
                                    <th style="width:50mm;">#session.ep.money#<cf_get_lang dictionary_id ='57492.Toplam'></th>
                                    <cfif len(session.ep.money2)><th style="width:50mm;">#session.ep.money2#<cf_get_lang dictionary_id ='57492.Toplam'></th></cfif>
                                    </cfoutput>
                                </cfif>
                            </tr>
                        </thead>
                        <cfif listfind("9,10",attributes.report_type)>
                        <cfif GET_COMP.recordcount>   
                            <cfoutput query="GET_COMP">
                                <cfset cat_toplam = 0>
                                <cfset cat_toplam2 = 0>
                                    <tbody>
                                        <tr>
                                            <cfif attributes.report_type eq 10>
                                                <td nowrap>#Dateformat(PROCESS_DATE,dateformat_style)#</td>
                                            </cfif>
                                            <td nowrap="nowrap">#GET_COMP.MEMBER_CODE#</td>
                                            <td nowrap="nowrap">#GET_COMP.NICKNAME#</td>
                                            <cfloop from="10" to="14" index="ay_ind">
                                                <cfset ay_que = evaluate('get_inv_#ay_ind#')>
                                                <cfif attributes.report_type eq 9>
                                                    <cfif attributes.member_type_info eq 1>
                                                        <cfset cat_yeri = listfind(evaluate('ay_cat_list_#ay_ind#'),COMPANY_ID,',')>
                                                    <cfelse>
                                                        <cfset cat_yeri = listfind(evaluate('ay_cat_list_#ay_ind#'),CONSUMER_ID,',')>
                                                    </cfif>
                                                <cfelse>
                                                    <cfif attributes.member_type_info eq 1>
                                                        <cfset my_deg_ = '#company_id#*#PROCESS_DATE#'>
                                                    <cfelse>
                                                        <cfset my_deg_ = '#consumer_id#*#PROCESS_DATE#'>
                                                    </cfif>
                                                    <cfset cat_yeri = listfind(evaluate('ay_cat_list_#ay_ind#'),my_deg_,',')>
                                                </cfif>
                                                <td align="right" style="text-align:right;">
                                                    <cfif cat_yeri gt 0>
                                                        <cfset cat_toplam = cat_toplam + ay_que.ACTION_VALUE[cat_yeri]>
                                                        <cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + ay_que.ACTION_VALUE[cat_yeri]>
                                                        <cfif len(ay_que.ACTION_VALUE[cat_yeri])>
                                                            #TLFormat(ay_que.ACTION_VALUE[cat_yeri])#
                                                        </cfif>
                                                    <cfelse>
                                                        -
                                                    </cfif>
                                                </td>
                                                <cfif len(session.ep.money2)>
                                                    <td align="right" style="text-align:right;">
                                                        <cfif cat_yeri gt 0>
                                                            <cfset cat_toplam2 = cat_toplam2 + ay_que.ACTION_VALUE2[cat_yeri]>
                                                            <cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + ay_que.ACTION_VALUE2[cat_yeri]>
                                                            <cfif len(ay_que.ACTION_VALUE2[cat_yeri])>
                                                                #TLFormat(ay_que.ACTION_VALUE2[cat_yeri])#
                                                            </cfif>
                                                        <cfelse>
                                                            -
                                                        </cfif>
                                                    </td>
                                                </cfif>
                                            </cfloop>
                                            <td align="right" style="text-align:right;">#TLFormat(cat_toplam)#</td>
                                            <cfif len(session.ep.money2)><td align="right" style="text-align:right;">#TLFormat(cat_toplam2)#</td></cfif>
                                        </tr>
                                    </tbody>
                                <cfset genel_toplam = genel_toplam + cat_toplam>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="20">
                                    <cf_get_lang dictionary_id='57484.Kayıt Yok'>!
                                </td>
                            </tr>    
                        </cfif>
                        <cfelse>
                            <cfif listfind("2,3,4,5",attributes.report_type)>
                                <cfset process_id_list=''>
                                <cfoutput query="GET_CARI_ROWS" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                                    <cfif len(PROCESS_ID) and not listfind(process_id_list,PROCESS_ID)>
                                        <cfset process_id_list=listappend(process_id_list,PROCESS_ID)>
                                    </cfif>
                                </cfoutput>
                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                    <cfset type_ = 1>
                                    <cfset attributes.startrow=1>
                                    <cfset attributes.maxrows=GET_CARI_ROWS.recordcount>		
                                <cfelse>
                                    <cfset type_ = 0>		
                                </cfif>
                                <cfif len(process_id_list)>
                                    <cfset process_id_list=listsort(process_id_list,"numeric","ASC",",")>
                                    <cfquery name="get_comp_bakiye" datasource="#dsn2#">
                                        SELECT
                                            SUM(BAKIYE) BAKIYE,
                                            SUM(BAKIYE2) BAKIYE2,
                                            SUM(VADE_BORC-VADE_ALACAK) VADE_PERF
                                        FROM
                                            <cfif attributes.member_type_info eq 1>
                                                COMPANY_REMAINDER,
                                                #dsn_alias#.COMPANY COMPANY
                                            <cfelse>
                                                CONSUMER_REMAINDER,
                                                #dsn_alias#.CONSUMER CONSUMER
                                            </cfif>
                                            <cfif attributes.report_type eq 4>
                                            ,#dsn_alias#.WORKGROUP_EMP_PAR WEP
                                            </cfif>
                                        WHERE
                                        <cfif attributes.member_type_info eq 1>
                                            COMPANY_REMAINDER.COMPANY_ID = COMPANY.COMPANY_ID
                                            <cfif attributes.report_type eq 2>
                                                AND COMPANY.COMPANYCAT_ID IN (#process_id_list#)
                                            <cfelseif attributes.report_type eq 3>
                                                AND COMPANY.SALES_COUNTY IN (#process_id_list#)
                                            <cfelseif attributes.report_type eq 4>
                                                AND WEP.POSITION_CODE IN (#process_id_list#) AND
                                                WEP.IS_MASTER = 1 AND
                                                WEP.OUR_COMPANY_ID = #session.ep.company_id# AND
                                                COMPANY_REMAINDER.COMPANY_ID = WEP.COMPANY_ID   
                                            <cfelseif attributes.report_type eq 5>
                                                AND COMPANY.COMPANY_ID IN (#process_id_list#)
                                            </cfif>
                                            <cfif len(trim(attributes.company)) and len(attributes.company_id)>
                                                AND COMPANY.COMPANY_ID = #attributes.company_id#
                                            </cfif>
                                            <cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
                                                AND	COMPANY.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id#)
                                            </cfif>
                                            <cfif len(attributes.customer_value_id)>
                                                AND COMPANY.COMPANY_VALUE_ID = #attributes.customer_value_id#
                                            </cfif>
                                            <cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
                                                AND COMPANY.COMPANYCAT_ID IN (#attributes.companycat_id#)
                                            </cfif>
                                            <cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
                                                AND COMPANY.IMS_CODE_ID = #attributes.ims_code_id#
                                            </cfif>
                                            <cfif len(attributes.zone_id)>
                                                AND COMPANY.SALES_COUNTY = #attributes.zone_id#
                                            </cfif>
                                            <cfif len(attributes.resource_id)>
                                                AND COMPANY.RESOURCE_ID = #attributes.resource_id#
                                            </cfif>
                                        <cfelse>
                                            CONSUMER_REMAINDER.CONSUMER_ID = CONSUMER.CONSUMER_ID
                                            <cfif attributes.report_type eq 2>
                                                AND CONSUMER.CONSUMER_CAT_ID IN (#process_id_list#)
                                            <cfelseif attributes.report_type eq 3>
                                                AND CONSUMER.SALES_COUNTY IN (#process_id_list#)
                                            <cfelseif attributes.report_type eq 4>
                                                AND WEP.POSITION_CODE IN (#process_id_list#) AND
                                                WEP.IS_MASTER = 1 AND
                                                WEP.OUR_COMPANY_ID = #session.ep.company_id# AND
                                                CONSUMER_REMAINDER.CONSUMER_ID = WEP.CONSUMER_ID   
                                            <cfelseif attributes.report_type eq 5>
                                                AND CONSUMER.CONSUMER_ID IN (#process_id_list#)
                                            </cfif>
                                            <cfif len(trim(attributes.company)) and len(attributes.company_id)>
                                                AND CONSUMER.CONSUMER_ID = #attributes.company_id#
                                            </cfif>
                                            <cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
                                                AND	CONSUMER.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND CONSUMER_ID IS NOT NULL)
                                            </cfif>
                                            <cfif len(attributes.customer_value_id)>
                                                AND CONSUMER.CUSTOMER_VALUE_ID = #attributes.customer_value_id#
                                            </cfif>
                                            <cfif isdefined ('attributes.consumercat_id') and len(attributes.consumercat_id)>
                                                AND CONSUMER.CONSUMER_CAT_ID IN (#attributes.consumercat_id#)
                                            </cfif>
                                            <cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
                                                AND CONSUMER.IMS_CODE_ID = #attributes.ims_code_id#
                                            </cfif>
                                            <cfif len(attributes.zone_id)>
                                                AND CONSUMER.SALES_COUNTY = #attributes.zone_id#
                                            </cfif>
                                            <cfif len(attributes.resource_id)>
                                                AND CONSUMER.RESOURCE_ID = #attributes.resource_id#
                                            </cfif>
                                        </cfif>
                                        GROUP BY
                                            <cfif attributes.member_type_info eq 1>
                                                <cfif attributes.report_type eq 2>	
                                                    COMPANY.COMPANYCAT_ID
                                                <cfelseif attributes.report_type eq 3>
                                                    COMPANY.SALES_COUNTY
                                                <cfelseif attributes.report_type eq 4>
                                                    WEP.POSITION_CODE
                                                <cfelseif attributes.report_type eq 5>
                                                    COMPANY.COMPANY_ID
                                                </cfif>
                                                ORDER BY 
                                                <cfif attributes.report_type eq 2>	
                                                    COMPANY.COMPANYCAT_ID
                                                <cfelseif attributes.report_type eq 3>
                                                    COMPANY.SALES_COUNTY
                                                <cfelseif attributes.report_type eq 4>
                                                    WEP.POSITION_CODE
                                                <cfelseif attributes.report_type eq 5>
                                                    COMPANY.COMPANY_ID
                                                </cfif>
                                            <cfelse>
                                                <cfif attributes.report_type eq 2>	
                                                    CONSUMER.CONSUMER_CAT_ID
                                                <cfelseif attributes.report_type eq 3>
                                                    CONSUMER.SALES_COUNTY
                                                <cfelseif attributes.report_type eq 4>
                                                    WEP.POSITION_CODE
                                                <cfelseif attributes.report_type eq 5>
                                                    CONSUMER.CONSUMER_ID
                                                </cfif>
                                                ORDER BY 
                                                <cfif attributes.report_type eq 2>	
                                                    CONSUMER.CONSUMER_CAT_ID
                                                <cfelseif attributes.report_type eq 3>
                                                    CONSUMER.SALES_COUNTY
                                                <cfelseif attributes.report_type eq 4>
                                                    WEP.POSITION_CODE
                                                <cfelseif attributes.report_type eq 5>
                                                    CONSUMER.CONSUMER_ID
                                                </cfif>
                                            </cfif>
                                    </cfquery>
                                </cfif>
                            </cfif>
                            <!--- islem belge bazında company ve consumer bilgileri --->
                            <cfif attributes.report_type eq 1>
                                <cfset company_name_list = "">
                                <cfset consumer_name_list = "">
                                <cfoutput query="get_cari_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <cfif attributes.member_type_info eq 1>
                                        <cfif len(evaluate("#FROM_TO_CMP_ID#")) and not listfind(company_name_list,evaluate("#FROM_TO_CMP_ID#"))>
                                            <cfset company_name_list=listappend(company_name_list,evaluate("#FROM_TO_CMP_ID#"))>
                                        </cfif>
                                    <cfelse>
                                        <cfif len(evaluate("#FROM_TO_CONSUMER_ID#")) and not listfind(consumer_name_list,evaluate("#FROM_TO_CONSUMER_ID#"))>
                                            <cfset consumer_name_list=listappend(consumer_name_list,evaluate("#FROM_TO_CONSUMER_ID#"))>
                                        </cfif>
                                    </cfif>
                                </cfoutput>
                                <cfif len(company_name_list)>
                                    <cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
                                        SELECT COMPANY_ID,NICKNAME,MEMBER_CODE FROM COMPANY WHERE COMPANY_ID IN (#company_name_list#) ORDER BY COMPANY_ID
                                    </cfquery>
                                    <cfset company_name_list = listsort(listdeleteduplicates(valuelist(get_company_name.company_id,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfif len(consumer_name_list)>
                                    <cfquery name="GET_CONS_NAME" datasource="#DSN#">
                                        SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_name_list#) ORDER BY CONSUMER_ID
                                    </cfquery>
                                    <cfset consumer_name_list = listsort(listdeleteduplicates(valuelist(get_cons_name.CONSUMER_ID,',')),'numeric','ASC',',')>
                                </cfif>
                            <!--- musteri bazında company ve consumer bilgileri --->
                            <cfelseif attributes.report_type eq 5>
                                <cfset company_name_list = "">
                                <cfset consumer_name_list = "">
                                <cfoutput query="get_cari_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <cfif attributes.member_type_info eq 1>
                                        <cfif len(process_id) and not listfind(company_name_list,process_id)>
                                            <cfset company_name_list=listappend(company_name_list,process_id)>
                                        </cfif>
                                    <cfelse>
                                        <cfif len(process_id) and not listfind(consumer_name_list,process_id)>
                                            <cfset consumer_name_list=listappend(consumer_name_list,process_id)>
                                        </cfif>
                                    </cfif>
                                </cfoutput>
                                <cfif len(company_name_list)>
                                    <cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
                                        SELECT COMPANY_ID,NICKNAME,MEMBER_CODE FROM COMPANY WHERE COMPANY_ID IN (#company_name_list#) ORDER BY COMPANY_ID
                                    </cfquery>
                                    <cfset company_name_list = listsort(listdeleteduplicates(valuelist(get_company_name.company_id,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfif len(consumer_name_list)>
                                    <cfquery name="GET_CONS_NAME" datasource="#DSN#">
                                        SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_name_list#) ORDER BY CONSUMER_ID
                                    </cfquery>
                                    <cfset consumer_name_list = listsort(listdeleteduplicates(valuelist(get_cons_name.CONSUMER_ID,',')),'numeric','ASC',',')>
                                </cfif>
                            </cfif>
                            <cfif get_cari_rows.recordcount>
                                <tbody>
                                    <cfoutput query="get_cari_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                        <cfset row_total = 0>
                                        <cfset row_total2 = 0>
                                        <tr>
                                            <cfif attributes.report_type eq 1>
                                                <td>#currentrow#</td>
                                                <td>
                                                    <cfif len(company_name_list)>
                                                        #get_company_name.member_code[listfind(company_name_list,evaluate("#FROM_TO_CMP_ID#"),',')]#
                                                    <cfelseif len(consumer_name_list)>
                                                        #get_cons_name.member_code[listfind(consumer_name_list,evaluate("#FROM_TO_CONSUMER_ID#"),',')]#
                                                    </cfif>                               
                                                </td>
                                                <td>
                                                    <cfif len(company_name_list)>
                                                        <cfif type_ eq 1>
                                                        #get_company_name.nickname[listfind(company_name_list,evaluate("#FROM_TO_CMP_ID#"),',')]#
                                                        <cfelse>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_company_name.company_id[listfind(company_name_list,evaluate("#FROM_TO_CMP_ID#"),',')]#','medium');" class="tableyazi">#get_company_name.nickname[listfind(company_name_list,evaluate("#FROM_TO_CMP_ID#"),',')]#</a>
                                                        </cfif>										
                                                    <cfelseif len(consumer_name_list)>
                                                        <cfif type_ eq 1>
                                                        #get_cons_name.consumer_name[listfind(consumer_name_list,evaluate("#FROM_TO_CONSUMER_ID#"),',')]# #get_cons_name.consumer_surname[listfind(consumer_name_list,evaluate("#FROM_TO_CONSUMER_ID#"),',')]#
                                                        <cfelse>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_cons_name.consumer_id[listfind(consumer_name_list,evaluate("#FROM_TO_CONSUMER_ID#"),',')]#','medium');" class="tableyazi">#get_cons_name.consumer_name[listfind(consumer_name_list,evaluate("#FROM_TO_CONSUMER_ID#"),',')]# #get_cons_name.consumer_surname[listfind(consumer_name_list,evaluate("#FROM_TO_CONSUMER_ID#"),',')]#</a>
                                                        </cfif>										
                                                    </cfif>
                                                </td>
                                                <td>#project_head#</td>
                                                <td>#collection_location#</td>
                                                <td>#paper_no#</td>
                                                <td>#action_name#</td>
                                                <td>#action_detail#</td>
                                                <td>#Dateformat(action_date,dateformat_style)#</td>
                                                <td>#Dateformat(due_date,dateformat_style)#</td>
                                                <td align="right">#TLFormat(action_value)#</td>
                                                <td align="right">#TLFormat(other_cash_act_value)# </td>
                                                <td align="right">#OTHER_MONEY#</td>
                                                <cfset tutar_toplam = tutar_toplam + action_value>
                                                <cfif len(other_cash_act_value)>
                                                    <cfset other_tutar_toplam = other_tutar_toplam + other_cash_act_value>
                                                </cfif>
                                            <cfelseif listfind("2,3,4,5,6,7,11",attributes.report_type)>
                                                <td>#currentrow#</td>
                                                <cfif listfind("5",attributes.report_type)>
                                                    <td>
                                                        <cfif len(company_name_list)>
                                                            #get_company_name.member_code[listfind(company_name_list,process_id,',')]#
                                                        <cfelseif len(consumer_name_list)>
                                                            #get_cons_name.member_code[listfind(consumer_name_list,process_id,',')]#
                                                        </cfif>
                                                    </td>
                                                </cfif>
                                                <td>
                                                <cfif report_type eq 4>
                                                    <cfif type_ eq 1>
                                                        #DSP_REPORT_TYPE#
                                                    <cfelse>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#process_id#','medium');" class="tableyazi">#DSP_REPORT_TYPE#</a>
                                                    </cfif>
                                                <cfelseif report_type eq 5>
                                                    <cfif type_ eq 1>
                                                        <cfif attributes.member_type_info eq 1>
                                                            #DSP_REPORT_TYPE#
                                                        </cfif>								
                                                    <cfelse>
                                                        <cfif attributes.member_type_info eq 1>
                                                            <cfif type_ eq 1>
                                                                #DSP_REPORT_TYPE#
                                                            <cfelse>
                                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#process_id#','medium');" class="tableyazi">#DSP_REPORT_TYPE#</a>
                                                            </cfif>																				
                                                        <cfelse>
                                                            <cfif type_ eq 1>
                                                                #DSP_REPORT_TYPE#
                                                            <cfelse>
                                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#process_id#','medium');" class="tableyazi">#DSP_REPORT_TYPE#</a>
                                                            </cfif>											
                                                        </cfif>
                                                    </cfif>
                                                <cfelse>
                                                    #DSP_REPORT_TYPE#
                                                </cfif>
                                                </td>
                                                <cfif listfind("2,3,4,5",attributes.report_type)>
                                                    <td align="right" nowrap="nowrap">#TLFormat(get_comp_bakiye.BAKIYE[listfind(process_id_list,PROCESS_ID,',')])#</td>
                                                    <cfif len(session.ep.money2)><td align="right" nowrap="nowrap">#TLFormat(get_comp_bakiye.BAKIYE2[listfind(process_id_list,PROCESS_ID,',')])#</td></cfif>
                                                    <td align="right" nowrap="nowrap">#TLFormat(get_comp_bakiye.VADE_PERF[listfind(process_id_list,PROCESS_ID,',')])#</td>
                                                </cfif>
                                                <td align="right" style="text-align:right;">#TLFormat(GET_CASH_ACTIONS)#</td>
                                                <cfif len(session.ep.money2)><td align="right" style="text-align:right;">#TLFormat(GET_CASH_ACTIONS2)#</td></cfif>
                                                <td align="right" style="text-align:right;">#TLFormat(GET_BANK_ACTIONS)#</td>
                                                <cfif len(session.ep.money2)><td align="right" style="text-align:right;">#TLFormat(GET_BANK_ACTIONS2)#</td></cfif>
                                                <td align="right" style="text-align:right;">#TLFormat(GET_CHEQUE_ACTIONS)#</td>
                                                <cfif len(session.ep.money2)><td align="right" style="text-align:right;">#TLFormat(GET_CHEQUE_ACTIONS2)#</td></cfif>
                                                <td align="right" style="text-align:right;">#TLFormat(GET_VOUCHER_ACTIONS)#</td>
                                                <cfif len(session.ep.money2)><td align="right" style="text-align:right;">#TLFormat(GET_VOUCHER_ACTIONS2)#</td></cfif>
                                                <td align="right" style="text-align:right;">#TLFormat(GET_CC_REVENUE)#</td>
                                                <cfif len(session.ep.money2)><td align="right" style="text-align:right;">#TLFormat(GET_CC_REVENUE2)#</td></cfif>
                                                <cfset cash_actions_toplam = cash_actions_toplam + GET_CASH_ACTIONS>
                                                <cfset row_total = row_total + GET_CASH_ACTIONS>
                                                <cfif len(session.ep.money2) and len(GET_CASH_ACTIONS2)>
                                                    <cfset cash_actions_toplam2 = cash_actions_toplam2 + GET_CASH_ACTIONS2>
                                                    <cfset row_total2 = row_total2 + GET_CASH_ACTIONS2>
                                                </cfif>
                                                <cfset bank_actions_toplam = bank_actions_toplam + GET_BANK_ACTIONS>
                                                <cfset row_total = row_total + GET_BANK_ACTIONS>
                                                <cfif len(session.ep.money2) and len(GET_BANK_ACTIONS2)>
                                                    <cfset bank_actions_toplam2 = bank_actions_toplam2 + GET_BANK_ACTIONS2>
                                                    <cfset row_total2 = row_total2 + GET_BANK_ACTIONS2>
                                                </cfif>
                                                <cfset cheque_actions_toplam = cheque_actions_toplam + GET_CHEQUE_ACTIONS>
                                                <cfset row_total = row_total + GET_CHEQUE_ACTIONS>
                                                <cfif len(session.ep.money2) and len(GET_CHEQUE_ACTIONS2)>
                                                    <cfset cheque_actions_toplam2 = cheque_actions_toplam2 + GET_CHEQUE_ACTIONS2>
                                                    <cfset row_total2 = row_total2 + GET_CHEQUE_ACTIONS2>
                                                </cfif>
                                                <cfset voucher_actions_toplam = voucher_actions_toplam + GET_VOUCHER_ACTIONS>
                                                <cfset row_total = row_total + GET_VOUCHER_ACTIONS>
                                                <cfif len(session.ep.money2) and len(GET_VOUCHER_ACTIONS2)>
                                                    <cfset voucher_actions_toplam2 = voucher_actions_toplam2 + GET_VOUCHER_ACTIONS2>
                                                    <cfset row_total2 = row_total2 + GET_VOUCHER_ACTIONS2>
                                                </cfif>
                                                <cfset cc_rev_toplam = cc_rev_toplam + GET_CC_REVENUE>
                                                <cfset row_total = row_total + GET_CC_REVENUE>
                                                <cfif len(session.ep.money2) and len(GET_CC_REVENUE2)>
                                                    <cfset cc_rev_toplam2 = cc_rev_toplam2 + GET_CC_REVENUE2>
                                                    <cfset row_total2 = row_total2 + GET_CC_REVENUE2>
                                                </cfif>
                                            <cfelseif attributes.report_type eq 8>
                                                <td>#currentrow#</td>
                                                <td>#MEMBER_CODE#</td>
                                                <td>#NICKNAME#</td>
                                                <td align="right" style="text-align:right;">#TLFormat(ACTION_VALUE)# #ACTION_CURRENCY_ID#</td>
                                                <td align="right" style="text-align:right;">#TLFormat(OTHER_CASH_ACT_VALUE)# #OTHER_MONEY#</td>
                                                <td align="right" style="text-align:right;">#TLFormat(COMMISSION_AMOUNT)#</td>
                                                <!--- Alt toplam alanları için eklendi.Created By MCP 20131806 --->
                                                <cfset tutar_toplam = tutar_toplam + ACTION_VALUE>
                                                <cfif len(COMMISSION_AMOUNT)>
                                                    <cfset comm_total=comm_total + COMMISSION_AMOUNT>
                                                </cfif>
                                                
                                            <!--- Komisyon Oranı İçin --->	
                                                <cfif len(COMMISSION_AMOUNT)><cfset bakiye_com = COMMISSION_AMOUNT><cfelse><cfset bakiye_com = 0></cfif>
                                                    <cfset money_com = get_cari_rows.OTHER_MONEY>
                                                <cfif bakiye_com gt 0>
                                                    <cfset money_list_com = listappend(money_list_com,'#bakiye_com#*#money_com#',',')>
                                                <cfelse>
                                                    <cfset money_list_com = listappend(money_list_com,'#bakiye_com#*#money_com#',',')>
                                                </cfif>
                                                <!--- Dovizli tutar için --->	
                                                <cfif len(OTHER_CASH_ACT_VALUE)><cfset bakiye_ = OTHER_CASH_ACT_VALUE><cfelse><cfset bakiye_ = 0></cfif>
                                                    <cfset money = get_cari_rows.OTHER_MONEY>
                                                <cfif bakiye_ gt 0>
                                                    <cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
                                                <cfelse>
                                                    <cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
                                                </cfif>	
                                            </cfif>
                                            <cfif attributes.report_type eq 11>
                                                <td  style="text-align:right;">#TLFormat(row_total)#</td>
                                                <cfif len(session.ep.money2)><td style="text-align:right;">#TLFormat(row_total2)#</td></cfif>
                                            </cfif>
                                        </tr>
                                        <cfif currentrow eq get_cari_rows.recordcount><!--- Kümülatif toplamlarda Son sayfayı iki kez toplamasını önlemek için eklendi. --->
                                        <cfset last_page_ = 1>
                                    </cfif>
                                    </cfoutput>
                                </tbody>
                            <!--- Sayafalamada Kümülatif Toplamları Getirmek İçin MCP tarafından oluşturuldu.20130920 --->
                        <cfif attributes.report_type eq 8 or attributes.report_type eq 1 > 
                            <cfif ((attributes.startrow -1) + (attributes.maxrows) gte get_cari_rows.recordcount) >
                                    <cfquery name="GET_SUB_TOTAL" dbtype="query">
                                        SELECT SUM(ACTION_VALUE) TOTAL_ACTION_VALUE FROM GET_CARI_ROWS
                                    </cfquery>
                                    <cfset devir_toplam = GET_SUB_TOTAL.TOTAL_ACTION_VALUE>
                                    <cfset islem_sayfasi_tutari = tutar_toplam>
                            </cfif>
                                <cfif attributes.page gt islem_sayfasi and last_page_ neq 1>
                                    <cfset devir_toplam = devir_toplam + tutar_toplam>
                                    <cfset islem_sayfasi_tutari = tutar_toplam>
                            </cfif>
                                <cfif attributes.page lt islem_sayfasi>
                                    <cfset devir_toplam = devir_toplam-islem_sayfasi_tutari>
                                    <cfset islem_sayfasi_tutari = tutar_toplam>
                                </cfif>
                                <cfif attributes.page eq 1>
                                    <cfset devir_toplam = tutar_toplam>
                                    <cfset islem_sayfasi=attributes.page>
                                </cfif>
                                <cfset islem_sayfasi=attributes.page>     
                        <cfelseif listfind("2,3,4,5,6,7,11",attributes.report_type)>
                                <cfif ((attributes.startrow - 1) + (attributes.maxrows) gt get_cari_rows.recordcount) >
                                    <cfquery name="GET_SUB_TOTAL" dbtype="query">
                                        SELECT 
                                            SUM(GET_CASH_ACTIONS) TOTAL_GET_CASH_ACTIONS,<!--- KASA HAREKETLERİ --->
                                            SUM(GET_CASH_ACTIONS2) TOTAL_GET_CASH_ACTIONS2,<!--- KASA HAREKETLERİ --->
                                            SUM(GET_BANK_ACTIONS) TOTAL_GET_BANK_ACTIONS,<!--- BANKA HAREKETLERİ --->
                                            SUM(GET_BANK_ACTIONS2) TOTAL_GET_BANK_ACTIONS2,<!--- BANKA HAREKETLERİ --->
                                            SUM(GET_CHEQUE_ACTIONS) TOTAL_GET_CHEQUE_ACTIONS,<!--- ÇEK HAREKETLERİ --->
                                            SUM(GET_CHEQUE_ACTIONS2) TOTAL_GET_CHEQUE_ACTIONS2,<!--- ÇEK HAREKETLERİ --->
                                            SUM(GET_VOUCHER_ACTIONS) TOTAL_GET_VOUCHER_ACTIONS,<!--- SENET HAREKETLERİ --->
                                            SUM(GET_VOUCHER_ACTIONS2) TOTAL_GET_VOUCHER_ACTIONS2,<!--- SENET HAREKETLERİ --->
                                            SUM(GET_CC_REVENUE) TOTAL_GET_CC_REVENUE,<!--- KREDI KARTI TAHSİLATLARI --->
                                            SUM(GET_CC_REVENUE2) TOTAL_GET_CC_REVENUE2<!--- KREDI KARTI TAHSİLATLARI --->
                                        FROM 
                                            GET_CARI_ROWS
                                    </cfquery>
                                    <cfset devir_toplam1 = GET_SUB_TOTAL.TOTAL_GET_CASH_ACTIONS>
                                    <cfset devir_toplam2 = GET_SUB_TOTAL.TOTAL_GET_CASH_ACTIONS2>
                                    <cfset devir_toplam3 = GET_SUB_TOTAL.TOTAL_GET_BANK_ACTIONS>
                                    <cfset devir_toplam4 = GET_SUB_TOTAL.TOTAL_GET_BANK_ACTIONS2>
                                    <cfset devir_toplam5 = GET_SUB_TOTAL.TOTAL_GET_CHEQUE_ACTIONS>
                                    <cfset devir_toplam6 = GET_SUB_TOTAL.TOTAL_GET_CHEQUE_ACTIONS2>
                                    <cfset devir_toplam7 = GET_SUB_TOTAL.TOTAL_GET_VOUCHER_ACTIONS>
                                    <cfset devir_toplam8 = GET_SUB_TOTAL.TOTAL_GET_VOUCHER_ACTIONS2>
                                    <cfset devir_toplam9 = GET_SUB_TOTAL.TOTAL_GET_CC_REVENUE>
                                    <cfset devir_toplam10 = GET_SUB_TOTAL.TOTAL_GET_CC_REVENUE2>
                                </cfif>
                                
                                <cfif attributes.page gt islem_sayfasi > 
                                    <cfset devir_toplam1 = devir_toplam1 + cash_actions_toplam>
                                    <cfset devir_toplam2 = devir_toplam2 + cash_actions_toplam2>
                                    <cfset devir_toplam3 = devir_toplam3 + bank_actions_toplam>
                                    <cfset devir_toplam4 = devir_toplam4 + bank_actions_toplam2>
                                    <cfset devir_toplam5 = devir_toplam5 + cheque_actions_toplam>
                                    <cfset devir_toplam6 = devir_toplam6 + cheque_actions_toplam2>
                                    <cfset devir_toplam7 = devir_toplam7 + voucher_actions_toplam>
                                    <cfset devir_toplam8 = devir_toplam8 + voucher_actions_toplam2>
                                    <cfset devir_toplam9 = devir_toplam9 + cc_rev_toplam>
                                    <cfset devir_toplam10 = devir_toplam10 + cc_rev_toplam2>  
                                    <cfset islem_sayfasi_tutari1 = cash_actions_toplam>
                                    <cfset islem_sayfasi_tutari2 = cash_actions_toplam2>
                                    <cfset islem_sayfasi_tutari3 = bank_actions_toplam>
                                    <cfset islem_sayfasi_tutari4 = bank_actions_toplam2>
                                    <cfset islem_sayfasi_tutari5 = cheque_actions_toplam>
                                    <cfset islem_sayfasi_tutari6 = cheque_actions_toplam2>
                                    <cfset islem_sayfasi_tutari7 = voucher_actions_toplam>
                                    <cfset islem_sayfasi_tutari8 = voucher_actions_toplam2>
                                    <cfset islem_sayfasi_tutari9 = cc_rev_toplam>
                                    <cfset islem_sayfasi_tutari10 = cc_rev_toplam2>    
                                </cfif>
                                <cfif attributes.page lt islem_sayfasi>
                                    <cfset devir_toplam1 = devir_toplam1 - islem_sayfasi_tutari1>
                                    <cfset devir_toplam2 = devir_toplam2 - islem_sayfasi_tutari2>
                                    <cfset devir_toplam3 = devir_toplam3 - islem_sayfasi_tutari3>
                                    <cfset devir_toplam4 = devir_toplam4 - islem_sayfasi_tutari4>
                                    <cfset devir_toplam5 = devir_toplam5 - islem_sayfasi_tutari5>
                                    <cfset devir_toplam6 = devir_toplam6 - islem_sayfasi_tutari6>
                                    <cfset devir_toplam7 = devir_toplam7 - islem_sayfasi_tutari7>
                                    <cfset devir_toplam8 = devir_toplam8 - islem_sayfasi_tutari8>
                                    <cfset devir_toplam9 = devir_toplam9 - islem_sayfasi_tutari9>
                                    <cfset devir_toplam10 = devir_toplam10 - islem_sayfasi_tutari10>
                                    <cfset islem_sayfasi_tutari1 = cash_actions_toplam>
                                    <cfset islem_sayfasi_tutari2 = cash_actions_toplam2>
                                    <cfset islem_sayfasi_tutari3 = bank_actions_toplam>
                                    <cfset islem_sayfasi_tutari4 = bank_actions_toplam2>
                                    <cfset islem_sayfasi_tutari5 = cheque_actions_toplam>
                                    <cfset islem_sayfasi_tutari6 = cheque_actions_toplam2>
                                    <cfset islem_sayfasi_tutari7 = voucher_actions_toplam>
                                    <cfset islem_sayfasi_tutari8 = voucher_actions_toplam2>
                                    <cfset islem_sayfasi_tutari9 = cc_rev_toplam>
                                    <cfset islem_sayfasi_tutari10 = cc_rev_toplam2> 
                                </cfif>
                                <cfif attributes.page eq 1>
                                    <cfset devir_toplam1 =0>
                                    <cfset devir_toplam2 =0>
                                    <cfset devir_toplam3 =0>
                                    <cfset devir_toplam4 =0>
                                    <cfset devir_toplam5 =0>
                                    <cfset devir_toplam6 =0>
                                    <cfset devir_toplam7 =0>
                                    <cfset devir_toplam8 =0>
                                    <cfset devir_toplam9 =0>
                                    <cfset devir_toplam10 =0>
                                    <cfset devir_toplam1 = devir_toplam1 + cash_actions_toplam>
                                    <cfset devir_toplam2 = devir_toplam2 + cash_actions_toplam2>
                                    <cfset devir_toplam3 = devir_toplam3 + bank_actions_toplam>
                                    <cfset devir_toplam4 = devir_toplam4 + bank_actions_toplam2>
                                    <cfset devir_toplam5 = devir_toplam5 + cheque_actions_toplam>
                                    <cfset devir_toplam6 = devir_toplam6 + cheque_actions_toplam2>
                                    <cfset devir_toplam7 = devir_toplam7 + voucher_actions_toplam>
                                    <cfset devir_toplam8 = devir_toplam8 + voucher_actions_toplam2>
                                    <cfset devir_toplam9 = devir_toplam9 + cc_rev_toplam>
                                    <cfset devir_toplam10 = devir_toplam10 + cc_rev_toplam2>      
                                </cfif> 
                                    <cfset islem_sayfasi=attributes.page>  
                        </cfif>   
                            <tfoot>
                                <cfif attributes.report_type eq 1>
                                    <tr>
                                    <cfoutput>
                                        <td colspan="10" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam '></td>
                                        <td class="txtbold" align="right">#TLFormat(tutar_toplam)#</td>
                                        <td></td>
                                        <td></td>
                                        </cfoutput>
                                    </tr>
                                    <tr>
                                    <cfoutput>
                                        <td colspan="10" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></td>
                                        <td class="txtbold" align="right">#TLFormat(devir_toplam)#</td>
                                        <td></td>
                                        <td></td>
                                    </cfoutput>
                                    </tr>
                                <cfelseif listfind("2,3,4,5,6,7,11",attributes.report_type)>
                                    <cfoutput>
                                        <tr>
                                            <cfif listfind("2,3,4,5",attributes.report_type) and len(session.ep.money2)>
                                                <cfset colspan_ = 5>
                                                <cfif listfind("5",attributes.report_type)>
                                                    <cfset colspan_ = 6>	
                                                </cfif>
                                            <cfelseif listfind("2,3,4,5",attributes.report_type) and not len(session.ep.money2)>
                                                <cfset colspan_ = 4>
                                                <cfif listfind("5",attributes.report_type)>
                                                    <cfset colspan_ = 5>	
                                                </cfif>
                                            <cfelse>
                                                <cfset colspan_ = 2>
                                            </cfif>
                                            <td colspan="#colspan_#" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam '></td>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(cash_actions_toplam)# </td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(cash_actions_toplam2)# </td></cfif>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(bank_actions_toplam)#</td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(bank_actions_toplam2)#</td></cfif>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(cheque_actions_toplam)#</td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(cheque_actions_toplam2)#</td></cfif>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(voucher_actions_toplam)#</td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(voucher_actions_toplam2)#</td></cfif>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(cc_rev_toplam)#</td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(cc_rev_toplam2)#</td></cfif>
                                            <cfif attributes.report_type eq 11>
                                                <td class="txtbold" style="text-align:right;">#TLFormat(cash_actions_toplam+bank_actions_toplam+cheque_actions_toplam+voucher_actions_toplam+cc_rev_toplam)#</td>
                                                <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(cash_actions_toplam2+bank_actions_toplam2+cheque_actions_toplam2+voucher_actions_toplam2+cc_rev_toplam2)#</td></cfif>
                                            </cfif>
                                        </tr>
                                        <tr>
                                            <cfif listfind("2,3,4,5",attributes.report_type) and len(session.ep.money2)>
                                                <cfset colspan_ = 5>
                                                <cfif listfind("5",attributes.report_type)>
                                                    <cfset colspan_ = 6>	
                                                </cfif>
                                            <cfelseif listfind("2,3,4,5",attributes.report_type) and not len(session.ep.money2)>
                                                <cfset colspan_ = 4>
                                                <cfif listfind("5",attributes.report_type)>
                                                    <cfset colspan_ = 5>	
                                                </cfif>
                                            <cfelse>
                                                <cfset colspan_ = 2>
                                            </cfif>
                                            <td colspan="#colspan_#" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></td>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam1)#</td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam2)#</td></cfif>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam3)#</td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam4)#</td></cfif>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam5)#</td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam6)#</td></cfif>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam7)#</td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam8)#</td></cfif>
                                            <td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam9)#</td>
                                            <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(devir_toplam10)#</td></cfif>
                                            <cfif attributes.report_type eq 11>
                                                <td class="txtbold" style="text-align:right;">#TLFormat(cash_actions_toplam+bank_actions_toplam+cheque_actions_toplam+voucher_actions_toplam+cc_rev_toplam)#</td>
                                                <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(cash_actions_toplam2+bank_actions_toplam2+cheque_actions_toplam2+voucher_actions_toplam2+cc_rev_toplam2)#</td></cfif>
                                            </cfif>
                                        </tr>
                                    </cfoutput>
                                    
                                </cfif>
                                <cfif attributes.report_type eq 8>
                                    <tr> 
                                        <cfoutput>
                                            <td class="txtbold" colspan="3" style="text-align:right;">
                                                <cf_get_lang dictionary_id='57492.Toplam '>
                                            </td>
                                            <td class="txtbold" style="text-align:right;">
                                                #TLFormat(tutar_toplam)# #session.ep.money# -- #TLFormat(devir_toplam)#
                                            </td>
                                        </cfoutput>
                                        <td class="txtbold" style="text-align:right;">
                                        <!--- Dovizli Tutar İçin --->	
                                            <cfoutput query="get_money_rate">
                                                <cfset toplam_ara = 0>
                                                    <cfloop list="#money_list#" index="i">
                                                        <cfset tutar_ = listfirst(i,'*')>
                                                        <cfset money_ = listlast(i,'*')>
                                                            <cfif money_ eq money>
                                                                <cfset toplam_ara = toplam_ara + tutar_>
                                                            </cfif>
                                                    </cfloop>
                                                <cfif toplam_ara neq 0>
                                                    #TLFormat(ABS(toplam_ara))# #money# 
                                                </cfif>
                                            </cfoutput>
                                        </td>
                                        <td class="txtbold" style="text-align:right;">
                                            <cfoutput>#comm_total# #session.ep.money#</cfoutput>
                                        </td>
                                    </tr>
                                </cfif>
                            </tfoot>
                            <cfelse>
                                <tr>
                                    <td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                                </tr>
                            </cfif>	    
                        </cfif>
                    <cfelse>
                        <thead>
                            <tr>
                                <th></th>
                                <th><cf_get_lang dictionary_id="39539.Önceki Yıllar"></th>
                                <th><cf_get_lang dictionary_id="57592.Ocak"></th>
                                <th><cf_get_lang dictionary_id="57593.Şubat"></th>
                                <th><cf_get_lang dictionary_id="57594.Mart"></th>
                                <th><cf_get_lang dictionary_id="57595.Nisan"></th>
                                <th><cf_get_lang dictionary_id="57596.Mayıs"></th>
                                <th><cf_get_lang dictionary_id="57597.Haziran"></th>
                                <th><cf_get_lang dictionary_id="57598.Temmuz"></th>
                                <th><cf_get_lang dictionary_id="57599.Ağustos"></th>
                                <th><cf_get_lang dictionary_id="57600.Eylül"></th>
                                <th><cf_get_lang dictionary_id="57601.Ekim"></th>
                                <th><cf_get_lang dictionary_id="57602.Kasım"></th>
                                <th><cf_get_lang dictionary_id="57603.Aralık"></th>
                                <th><cf_get_lang dictionary_id="39527.Sonraki Yıllar"></th>
                                <th><cf_get_lang dictionary_id="57492.Toplam"></th>
                            </tr>
                        </thead>
                        <cfset total_ = 0>
                        <cfset toplam_total = 0>
                        <cfset new_tutar_toplam = 0>
                        <cfset old_tutar_toplam = 0>
                        <cfset toplam_hepsi = 0>
                        <cfloop from="1" to="12" index="jj">
                            <cfset "toplam_tutar_#jj#" = 0>
                        </cfloop>
                        <cfoutput query="get_cari_rows_due">
                            <cfif year_due lt session.ep.period_year>
                                <cfif isdefined("old_tutar_#process_id#")>
                                    <cfset "old_tutar_#process_id#" = evaluate("old_tutar_#process_id#")+tutar>
                                <cfelse>
                                    <cfset "old_tutar_#process_id#" = tutar>
                                </cfif>
                            <cfelseif year_due gt session.ep.period_year>
                                <cfif isdefined("new_tutar_#process_id#")>
                                    <cfset "new_tutar_#process_id#" = evaluate("new_tutar_#process_id#")+tutar>
                                <cfelse>
                                    <cfset "new_tutar_#process_id#" = tutar>
                                </cfif>
                            <cfelse>
                                <cfif not isdefined("due_tutar_#month_due#_#process_id#")>
                                    <cfset "due_tutar_#month_due#_#process_id#" = tutar>
                                <cfelse>
                                    <cfset "due_tutar_#month_due#_#process_id#" = evaluate("due_tutar_#month_due#_#process_id#") + tutar>
                                </cfif>
                            </cfif>
                        </cfoutput>
                        <cfif get_cari_rows.recordcount>    
                            <cfoutput query="get_cari_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <cfif isdefined("old_tutar_#process_id#")>
                                    <cfset old_tutar_ = evaluate("old_tutar_#process_id#")>
                                <cfelse>
                                    <cfset old_tutar_ = 0>
                                </cfif>
                                <cfif isdefined("new_tutar_#process_id#")>
                                    <cfset new_tutar_ = evaluate("new_tutar_#process_id#")>
                                <cfelse>
                                    <cfset new_tutar_ = 0>
                                </cfif>
                                <cfset old_tutar_toplam = old_tutar_toplam + old_tutar_>
                                <cfset new_tutar_toplam = new_tutar_toplam + new_tutar_>
                                
                                    <tbody>
                                        <tr>
                                            <td>
                                                <cfif report_type eq 4>
                                                <cfif type_ eq 1>
                                                #DSP_REPORT_TYPE#
                                                <cfelse>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#process_id#','medium');" class="tableyazi">#DSP_REPORT_TYPE#</a>
                                                </cfif>	
                                                <cfelseif report_type eq 5>
                                                    <cfif attributes.member_type_info eq 1>
                                                        <cfif type_ eq 1>
                                                        #DSP_REPORT_TYPE#
                                                        <cfelse>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#process_id#','medium');" class="tableyazi">#DSP_REPORT_TYPE#</a>
                                                        </cfif>																			
                                                    <cfelse>
                                                        <cfif type_ eq 1>
                                                        #DSP_REPORT_TYPE#
                                                        <cfelse>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#process_id#','medium');" class="tableyazi">#DSP_REPORT_TYPE#</a>
                                                        </cfif>									
                                                    </cfif>
                                                <cfelse>
                                                    #DSP_REPORT_TYPE#
                                                </cfif>
                                            </td>
                                            <td align="right" style="text-align:right;">#tlformat(old_tutar_)#</td>
                                            <cfloop from="1" to="12" index="i">
                                                <cfif isdefined("due_tutar_#i#_#process_id#") and len(evaluate("due_tutar_#i#_#process_id#"))>
                                                    <cfset due_tutar = evaluate("due_tutar_#i#_#process_id#")>
                                                <cfelse>
                                                    <cfset due_tutar = 0>
                                                </cfif>	 
                                                <cfset total_ = total_ + due_tutar >								
                                            <td align="right" style="text-align:right;">#tlformat(due_tutar)#</td>
                                                <cfset "toplam_tutar_#i#" = evaluate("toplam_tutar_#i#") + due_tutar>
                                            </cfloop>
                                            <td align="right" style="text-align:right;">#tlformat(new_tutar_)#</td>
                                            <cfset toplam_hepsi = toplam_hepsi + total_ + (old_tutar_ + new_tutar_)>
                                            <cfset toplam_total = toplam_total + toplam_hepsi>
                                            <td align="right" nowrap class="txtbold" style="text-align:right;">#tlformat(toplam_hepsi)#</td>
                                        </tr>
                                    </tbody>
                                    <cfset total_ = 0>
                                    <cfset toplam_hepsi = 0>
                            </cfoutput>         
                                <tfoot>			
                                    <tr>
                                        <td align="right" nowrap class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id="57680.Genel Toplam"></td>
                                        <td  align="right" nowrap class="txtbold" style="text-align:right;"><cfoutput>#tlformat(old_tutar_toplam)#</cfoutput></td>
                                        <cfloop from="1" to="12" index="i">
                                            <td  align="right" nowrap class="txtbold" style="text-align:right;"><cfoutput>#tlformat(evaluate("toplam_tutar_#i#"))#</cfoutput></td>
                                        </cfloop>
                                        <td  align="right" nowrap class="txtbold" style="text-align:right;"><cfoutput>#tlformat(new_tutar_toplam)#</cfoutput></td>
                                        <td  align="right" nowrap class="txtbold" style="text-align:right;"><cfoutput>#tlformat(toplam_total)#</cfoutput></td>
                                    </tr>
                                </tfoot>
                        <cfelse>
                            <tr>
                                <td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<td>
                            </tr>
                        </cfif>  
                    </cfif>
               
    </cf_report_list>
</cfif>
<!---<cfif not attributes.report_type eq 9>--->
	<cfif isdefined("form_submitted") and GET_CARI_ROWS.recordcount and (attributes.totalrecords gt attributes.maxrows)>
		<cfset adres = "report.revenue_analysis&form_submitted=1">	
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
		</cfif>
		<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
			<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
		</cfif>
		<cfif len(attributes.pos_code_text) and len(attributes.pos_code)>
			<cfset adres = "#adres#&pos_code=#attributes.pos_code#&pos_code_text=#attributes.pos_code_text#">
		</cfif>
		<cfif len(attributes.date1)>
			<cfset adres = "#adres#&date1=#attributes.date1#">
		</cfif>
		<cfif len(attributes.date2)>
			<cfset adres = "#adres#&date2=#attributes.date2#">
		</cfif>
		<cfif len(attributes.report_type)>
			<cfset adres = "#adres#&report_type=#attributes.report_type#">
		</cfif>
		<cfif len(attributes.zone_id)>
			<cfset adres = "#adres#&zone_id=#attributes.zone_id#">
		</cfif>
		<cfif len(attributes.resource_id)>
			<cfset adres = "#adres#&resource_id=#attributes.resource_id#">
		</cfif>
		<cfif len(attributes.ims_code_id)>
			<cfset adres = "#adres#&ims_code_id=#attributes.ims_code_id#">
		</cfif>
		<cfif len(attributes.ims_code_name)>
			<cfset adres = "#adres#&ims_code_name=#attributes.ims_code_name#">
		</cfif>
		<cfif len(attributes.customer_value_id)>
			<cfset adres = "#adres#&customer_value_id=#attributes.customer_value_id#">
		</cfif>
		<cfif len(attributes.companycat_id)>
			<cfset adres = "#adres#&companycat_id=#attributes.companycat_id#">
		</cfif>
		<cfif len(attributes.consumercat_id)>
			<cfset adres = "#adres#&consumercat_id=#attributes.consumercat_id#">
		</cfif>
		<cfif len(attributes.member_type_info)>
			<cfset adres = "#adres#&member_type_info=#attributes.member_type_info#">
		</cfif>
		<cfif len(attributes.main_report_type)>
			<cfset adres = "#adres#&main_report_type=#attributes.main_report_type#">
		</cfif>
		<cfif isDefined("attributes.is_group_date") and len(attributes.is_group_date)>
			<cfset adres = "#adres#&is_group_date=#attributes.is_group_date#">
		</cfif>
		<cfif len(attributes.project_id)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#">
		</cfif>
		<cfif len(attributes.project_head)>
			<cfset adres = "#adres#&project_head=#attributes.project_head#">
		</cfif>
        <cfif len(devir_toplam)>
			<cfset adres = "#adres#&devir_toplam=#devir_toplam#">
		</cfif>
        <cfif listfind("2,3,4,5,6,7,11",attributes.report_type)>
			   <cfif len(devir_toplam1)>
                    <cfset adres = "#adres#&devir_toplam1=#devir_toplam1#">
               </cfif>
               <cfif len(devir_toplam2)>
                    <cfset adres = "#adres#&devir_toplam2=#devir_toplam2#">
               </cfif>
               <cfif len(devir_toplam3)>
                    <cfset adres = "#adres#&devir_toplam3=#devir_toplam3#">
               </cfif>
               <cfif len(devir_toplam4)>
                    <cfset adres = "#adres#&devir_toplam4=#devir_toplam4#">
               </cfif>
               <cfif len(devir_toplam5)>
                    <cfset adres = "#adres#&devir_toplam5=#devir_toplam5#">
               </cfif>
               <cfif len(devir_toplam6)>
                   <cfset adres = "#adres#&devir_toplam6=#devir_toplam6#">
               </cfif>
               <cfif len(devir_toplam7)>
                    <cfset adres = "#adres#&devir_toplam7=#devir_toplam7#">
               </cfif>
              	<cfif len(devir_toplam8)>
                    <cfset adres = "#adres#&devir_toplam8=#devir_toplam8#">
              	</cfif>
              	<cfif len(devir_toplam9)>
                    <cfset adres = "#adres#&devir_toplam9=#devir_toplam9#">
              	</cfif>
              	<cfif len(devir_toplam10)>
                     <cfset adres = "#adres#&devir_toplam10=#devir_toplam10#">
              	</cfif>
                <cfif len(islem_sayfasi_tutari1)>
						<cfset adres = "#adres#&islem_sayfasi_tutari1=#islem_sayfasi_tutari1#">
				</cfif>
                 <cfif len(islem_sayfasi_tutari2)>
						<cfset adres = "#adres#&islem_sayfasi_tutari2=#islem_sayfasi_tutari2#">
				</cfif>
                 <cfif len(islem_sayfasi_tutari3)>
						<cfset adres = "#adres#&islem_sayfasi_tutari3=#islem_sayfasi_tutari3#">
				</cfif>
                 <cfif len(islem_sayfasi_tutari4)>
						<cfset adres = "#adres#&islem_sayfasi_tutari4=#islem_sayfasi_tutari4#">
				</cfif>
                 <cfif len(islem_sayfasi_tutari5)>
						<cfset adres = "#adres#&islem_sayfasi_tutari5=#islem_sayfasi_tutari5#">
				</cfif>
                 <cfif len(islem_sayfasi_tutari6)>
						<cfset adres = "#adres#&islem_sayfasi_tutari6=#islem_sayfasi_tutari6#">
				</cfif>
                 <cfif len(islem_sayfasi_tutari7)>
						<cfset adres = "#adres#&islem_sayfasi_tutari7=#islem_sayfasi_tutari7#">
				</cfif>
                 <cfif len(islem_sayfasi_tutari8)>
						<cfset adres = "#adres#&islem_sayfasi_tutari8=#islem_sayfasi_tutari8#">
				</cfif>
                 <cfif len(islem_sayfasi_tutari9)>
						<cfset adres = "#adres#&islem_sayfasi_tutari9=#islem_sayfasi_tutari9#">
				</cfif>
                 <cfif len(islem_sayfasi_tutari10)>
						<cfset adres = "#adres#&islem_sayfasi_tutari10=#islem_sayfasi_tutari10#">
				</cfif>
        </cfif>
        <cfif len(islem_sayfasi)>
			<cfset adres = "#adres#&islem_sayfasi=#islem_sayfasi#">
		</cfif>
        <cfif len(islem_sayfasi_tutari)>
			<cfset adres = "#adres#&islem_sayfasi_tutari=#islem_sayfasi_tutari#">
		</cfif>	
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#">
			
	<!---</cfif>--->
</cfif>

<script type="text/javascript">
	function change_cat_type(type_info)
	{
		if(type_info == 1)
		{
			document.getElementById('company_cat').style.display='';
			document.getElementById('consumer_cat').style.display='none';
		}
		else
		{
			document.getElementById('company_cat').style.display='none';
			document.getElementById('consumer_cat').style.display='';
		}	
	}
	function kontrol_report_type()
	{
		if(document.rapor.report_type.value == 2 || document.rapor.report_type.value == 3 || document.rapor.report_type.value == 4 || document.rapor.report_type.value == 5)
			document.rapor.is_group_date.disabled = false;
		else
			document.rapor.is_group_date.disabled = true;
	}
    kontrol_report_type();
    
    function control(){   
        if ((document.rapor.date1.value != '') && (document.rapor.date2.value != '') &&
	    !date_check(rapor.date1,rapor.date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.rapor.is_excel.checked==false)
			{
				document.rapor.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
				return true;
			}
			else
				document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_revenue_analysis</cfoutput>"
                    }
</script>
