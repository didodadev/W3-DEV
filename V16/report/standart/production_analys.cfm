<cfsetting showdebugoutput="yes">
<!--- TolgaS:20070115 üretim raporu --->
<cf_xml_page_edit fuseact="report.production_analyse">
<!--- <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1 >
	<cfinclude template="../query/production_analyse_excel.cfm">
</cfif> --->
<cfparam name="attributes.module_id_control" default="35">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.PRODUCT_CAT_CODE" default="">
<cfparam name="attributes.MEMBER_TYPE" default="">
<cfparam name="attributes.PRODUCT_ID" default="">
<cfparam name="attributes.SARF_PRODUCT_ID" default="">
<cfparam name="attributes.report_type" default="12">
<cfparam name="attributes.report_type" default="11">
<cfparam name="attributes.FIRE_PRODUCT_ID" default="">
<cfparam name="attributes.STATION_ID_" default="">
<cfparam name="attributes.BRAND_ID" default="">
<cfparam name="attributes.spec_id" default="">
<cfparam name="attributes.spec_name" default="">
<cfparam name="attributes.sarf_spec_id" default="">
<cfparam name="attributes.sarf_spec_name" default="">
<cfparam name="attributes.fire_spec_id" default="">
<cfparam name="attributes.fire_spec_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.start_date1" default="">
<cfparam name="attributes.start_date2" default="">
<cfparam name="attributes.finish_date1" default="">
<cfparam name="attributes.finish_date2" default="">
<cfparam name="attributes.stock_fis_status" default="">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.P_ORDER_ID" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = (((attributes.page-1)*attributes.maxrows)) + 1>
<cfif isdefined('attributes.ajax')><!--- Kümüle Raporlar için Dönem ve şirket farklı gönderilebilir! --->
	<cfif isdefined('attributes.new_sirket_data_source')>
		<cfset dsn3 = attributes.new_sirket_data_source>
	</cfif>
	<cfif isdefined('attributes.new_donem_data_source')>
		<cfset dsn2 = attributes.new_donem_data_source>
	</cfif>
</cfif>
<cfsavecontent variable="head"><cf_get_lang dictionary_id ='40164.Üretim Analizi'></cfsavecontent>
<cfform name="production_report" method="post" action="#request.self#?fuseaction=report.production_analyse">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='57486.Kategori'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif isdefined('attributes.product_cat_code') and len(attributes.product_cat_code) and len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                                            <input type="text" name="product_cat" id="product_cat" value="<cfif isdefined('attributes.product_cat') and len(attributes.product_cat) and len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" style="width:130px;" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','productcat_id','form','3','200');">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=production_report.product_cat_code&field_name=production_report.product_cat');"></span>
                                        </div>
                                    </div>     
                                </div>    
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label> 
                                        <cf_wrk_list_items table_name ='PRODUCT_BRANDS' wrk_list_object_id='BRAND_ID' wrk_list_object_name='brand_NAME' sub_header_name="#getLang('main',1435)#" header_name="#getLang('report',1435)#" datasource ="#dsn1#">
                                        <!---<input type="hidden" name="product_brand_id" id="product_brand_id" value="<cfif isdefined('attributes.product_brand_id') and len(attributes.product_brand_id) and len(attributes.product_brand)><cfoutput>#attributes.product_brand_id#</cfoutput></cfif>">
                                            <input type="text" name="product_brand" id="product_brand" style="width:130px;" value="<cfif isdefined('attributes.product_brand_id') and len(attributes.product_brand_id) and len(attributes.product_brand)><cfoutput>#attributes.product_brand#</cfoutput></cfif>">
                                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=production_report.product_brand_id&brand_name=production_report.product_brand&keyword='+encodeURIComponent(document.production_report.product_brand.value)</cfoutput>,'small');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                                        --->				   
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='29467.Üretilen Ürün'></label>
                                    <div class="col col-12 col-xs-12"> 
                                        <div class="input-group">
                                            <input type="hidden" name="product_id" id="product_id" value="<cfif isdefined('attributes.product_id') and len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
                                            <input type="text" name="product_name" id="product_name" style="width:130px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','150');" value="<cfif isdefined('attributes.product_name') and len(attributes.product_name) and len(attributes.product_id)><cfoutput>#attributes.product_name#</cfoutput></cfif>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=production_report.product_id&field_name=production_report.product_name&keyword='+encodeURIComponent(document.production_report.product_name.value),'list');"></span>
                                        </div>
                                    </div>    
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='29468.Sarf Ürün'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="sarf_product_id" id="sarf_product_id" value="<cfif isdefined('attributes.sarf_product_id') and len(attributes.sarf_product_id) and len(attributes.sarf_product_name)><cfoutput>#attributes.sarf_product_id#</cfoutput></cfif>">
                                            <input type="text" name="sarf_product_name" id="sarf_product_name" style="width:130px;" onfocus="AutoComplete_Create('sarf_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','sarf_product_id','','3','130');"  value="<cfif isdefined('attributes.sarf_product_name') and len(attributes.sarf_product_name) and len(attributes.sarf_product_id)><cfoutput>#attributes.sarf_product_name#</cfoutput></cfif>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=production_report.sarf_product_id&field_name=production_report.sarf_product_name&keyword='+encodeURIComponent(document.production_report.sarf_product_name.value),'list');"></span>
                                        </div>
                                    </div>    
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='29469.Fire Ürün'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="fire_product_id" id="fire_product_id" value="<cfif isdefined('attributes.fire_product_id') and len(attributes.fire_product_id) and len(attributes.fire_product_name)><cfoutput>#attributes.fire_product_id#</cfoutput></cfif>">
                                            <input type="text" name="fire_product_name" id="fire_product_name" style="width:130px;" onfocus="AutoComplete_Create('fire_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','fire_product_id','','3','150');" value="<cfif isdefined('attributes.fire_product_name') and len(attributes.fire_product_name) and len(attributes.fire_product_id)><cfoutput>#attributes.fire_product_name#</cfoutput></cfif>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=production_report.fire_product_id&field_name=production_report.fire_product_name&keyword='+encodeURIComponent(document.production_report.fire_product_name.value),'list');"></span>
                                        </div>
                                    </div>    
                                </div>   
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
                                    <div class="col col-12 col-xs-12">    
                                        <div class="input-group">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and attributes.member_type eq 'consumer' and len(attributes.member_name)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                            <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id) and attributes.member_type eq 'partner' and len(attributes.member_name)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                            <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined('attributes.member_type') and len(attributes.member_type) and len(attributes.member_name)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                            <input type="text" name="member_name" id="member_name" style="width:130px;" value="<cfif isdefined('attributes.member_name') and len(attributes.member_name) and len(attributes.member_type)><cfoutput>#attributes.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=production_report.consumer_id&field_comp_id=production_report.company_id&field_member_name=production_report.member_name&field_type=production_report.member_type&select_list=7,8&keyword='+encodeURIComponent(document.production_report.member_name.value),'list');"></span>
                                        </div>
                                    </div>    
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                    <div class="col col-12 col-xs-12">    
                                        <div class="input-group">
                                            <input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                            <input name="project_head" type="text" id="project_head" style="width:130px;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','120');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=production_report.project_head&project_id=production_report.project_id</cfoutput>');"></span>
                                        </div>
                                    </div>    
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='29467.Üretilen Ürün'> <cf_get_lang dictionary_id ='57647.Spekt'></label>
                                    <div class="col col-12 col-xs-12">    
                                        <div class="input-group">
                                            <input type="hidden" name="spec_id" id="spec_id" value="<cfif isdefined('attributes.spec_id') and len(attributes.spec_id) and len(attributes.spec_name)><cfoutput>#attributes.spec_id#</cfoutput></cfif>">
                                            <input type="text" name="spec_name" id="spec_name" style="width:130px;" value="<cfif isdefined('attributes.spec_name') and len(attributes.spec_name) and len(attributes.spec_id)><cfoutput>#attributes.spec_name#</cfoutput></cfif>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_main&product_id='+document.production_report.product_id.value+'&field_main_id=production_report.spec_id&field_name=production_report.spec_name</cfoutput>','page');"></span>
                                        </div>
                                    </div>    
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='29468.Sarf Ürün'> <cf_get_lang dictionary_id ='57647.Spekt'></label>
                                    <div class="col col-12 col-xs-12">     
                                        <div class="input-group">
                                            <input type="hidden" name="sarf_spec_id" id="sarf_spec_id" value="<cfif isdefined('attributes.sarf_spec_id') and len(attributes.sarf_spec_id) and len(attributes.sarf_spec_name)><cfoutput>#attributes.sarf_spec_id#</cfoutput></cfif>">
                                            <input type="text" name="sarf_spec_name" id="sarf_spec_name" style="width:130px;" value="<cfif isdefined('attributes.sarf_spec_name') and len(attributes.sarf_spec_name) and len(attributes.sarf_spec_id)><cfoutput>#attributes.sarf_spec_name#</cfoutput></cfif>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&product_id='+document.production_report.sarf_product_id.value+'&field_main_id=production_report.sarf_spec_id&field_name=production_report.sarf_spec_name','page');"></span>
                                        </div>
                                    </div>    
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='29469.Fire Ürün'> <cf_get_lang dictionary_id ='57647.Spekt'></label>
                                    <div class="col col-12 col-xs-12"> 
                                        <div class="input-group">
                                            <input type="hidden" name="fire_spec_id" id="fire_spec_id" value="<cfif isdefined('attributes.fire_spec_id') and len(attributes.fire_spec_id) and len(attributes.fire_spec_name)><cfoutput>#attributes.fire_spec_id#</cfoutput></cfif>">
                                            <input type="text" name="fire_spec_name" id="fire_spec_name" style="width:130px;" value="<cfif isdefined('attributes.fire_spec_name') and len(attributes.fire_spec_name) and len(attributes.fire_spec_id)><cfoutput>#attributes.fire_spec_name#</cfoutput></cfif>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&product_id='+document.production_report.fire_product_id.value+'&field_main_id=production_report.fire_spec_id&field_name=production_report.fire_spec_name','page');"></span>
                                        </div>
                                    </div>    
                                </div>   
							</div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='57800.İşlem Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfquery name="GET_PROCESS" datasource="#DSN#">
                                            SELECT
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
                                                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.upd_prod_order_result%">
                                            ORDER BY
                                                PTR.PROCESS_ROW_ID
                                        </cfquery>
                                        <cfif GET_PROCESS.RECORDCOUNT>
                                            <cfset process_list=listsort(valuelist(GET_PROCESS.PROCESS_ROW_ID),'NUMERIC','ASC')>
                                        <cfelse>
                                            <cfset process_list=''>
                                        </cfif>
                                        <select name="process" id="process" style="height:93px;" multiple="multiple">
                                            <cfoutput query="GET_PROCESS">
                                                <option value="#PROCESS_ROW_ID#" <cfif isdefined('attributes.process') and listfind(attributes.process,PROCESS_ROW_ID,',')>selected</cfif>>#STAGE#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58834.İstasyon'></label>
                                    <div class="col col-12 col-xs-12">    
                                        <cfquery name="GET_W" datasource="#dsn3#">
                                            SELECT STATION_ID,STATION_NAME FROM	WORKSTATIONS ORDER BY STATION_NAME
                                        </cfquery>
                                        <select name="station_id_" id="station_id_" style="height:94px;" multiple="multiple">
                                            <cfoutput query="GET_W">
                                                <option value="#STATION_ID#" <cfif isdefined('attributes.station_id_') and listfind(attributes.station_id_,STATION_ID,',')>selected</cfif>>#STATION_NAME#</option>
                                            </cfoutput>
                                        </select>
                                    </div>    
                                </div> 
							</div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-6 col-md-6">
                                        <div class="input-group">
                                            <cfsavecontent variable="message1"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                            <cfif isdefined('attributes.start_date1') and len(attributes.start_date1)><cfset startdate1=attributes.start_date1><cfelse><cfset startdate1=''></cfif>
                                            <cfinput type="text" name="start_date1" value="#startdate1#" validate="#validate_style#" message="#message1#" style="width:65px;">
                                            <cfif not isdefined('attributes.ajax')>
                                            <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="start_date1">
                                            </span>
                                            </cfif>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6">
                                        <div class="input-group">
                                            <cfif isdefined('attributes.start_date2') and len(attributes.start_date2)><cfset startdate2=attributes.start_date2><cfelse><cfset startdate2=''></cfif>
                                            <cfinput type="text" name="start_date2" value="#startdate2#"  validate="#validate_style#" message="#message1#" style="width:65px;">
                                            <cfif not isdefined('attributes.ajax')>
                                            <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="start_date2">
                                            </span>
                                            </cfif>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></label>
                                    <div class="col col-6 col-md-6">
                                        <div class="input-group">
                                            <cfsavecontent variable="message1"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                            <cfif isdefined('attributes.finish_date1') and len(attributes.finish_date1)><cfset finishdate1=attributes.finish_date1><cfelse><cfset finishdate1=''></cfif>
                                            <cfinput type="text" name="finish_date1" id="finish_date1" value="#finishdate1#" validate="#validate_style#" message="#message1#" style="width:65px;">
                                            <cfif not isdefined('attributes.ajax')>
                                            <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="finish_date1">
                                            </span>
                                            </cfif>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6">
                                        <div class="input-group">
                                            <cfif isdefined('attributes.finish_date2') and len(attributes.finish_date2)><cfset finishdate2=attributes.finish_date2><cfelse><cfset finishdate2=''></cfif>
                                            <cfinput type="text" name="finish_date2" id="finish_date2" value="#finishdate2#"  validate="#validate_style#" message="#message1#" style="width:65px;">
                                            <cfif not isdefined('attributes.ajax')>
                                            <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="finish_date2">
                                            </span>
                                            </cfif>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                    <div class="col col-12 col-xs-12">  
                                        <select name="report_type" id="report_type" onchange="detay_gizle();">
                                            <option value="1" <cfif isdefined('attributes.report_type') and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='39053.Ürün Bazinda'></option>
                                            <option value="2" <cfif isdefined('attributes.report_type') and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='39054.Stok Baznda'></option>
                                            <option value="3" <cfif isdefined('attributes.report_type') and attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='39052.Kategori Bazında'></option>
                                            <option value="4" <cfif isdefined('attributes.report_type') and attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='39765.Spec Bazında'></option>
                                            <option value="6" <cfif isdefined('attributes.report_type') and attributes.report_type eq 6>selected</cfif>><cf_get_lang dictionary_id ='40401.İş Istasyonu Bazinda'></option>
                                            <option value="7" <cfif isdefined('attributes.report_type') and attributes.report_type eq 7>selected</cfif>><cf_get_lang dictionary_id ='40402.Sarf Edilen Stok Bazında'></option>
                                            <option value="8" <cfif isdefined('attributes.report_type') and attributes.report_type eq 8>selected</cfif>><cf_get_lang dictionary_id ='40403.Üretim Sonuç Bazında'></option>
                                            <option value="9" <cfif isdefined('attributes.report_type') and attributes.report_type eq 9>selected</cfif>><cf_get_lang dictionary_id ='40404.Demontaj Sonuç Bazında'></option>
                                            <option value="10" <cfif isdefined('attributes.report_type') and attributes.report_type eq 10>selected</cfif>><cf_get_lang dictionary_id ='40405.Üretim Yapan Bazında'></option>
                                            <option value="11" <cfif isdefined('attributes.report_type') and attributes.report_type eq 11>selected</cfif>><cf_get_lang dictionary_id ='40311.İş İstasyonu ve Ürün Bazında'></option>
                                            <option value="12" <cfif isdefined('attributes.report_type') and attributes.report_type eq 12>selected</cfif>><cf_get_lang dictionary_id ='59263.İşlemi Yapan ve Ürün Bazında'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='39056.Stok Fisi'></label>
                                    <div class="col col-12 col-xs-12">  
                                        <select name="stock_fis_status" id="stock_fis_status" style="width:153px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="1" <cfif attributes.stock_fis_status eq 1>selected</cfif>><cf_get_lang dictionary_id="39830.Oluşturulmuş"></option>
                                            <option value="0" <cfif attributes.stock_fis_status eq 0>selected</cfif>><cf_get_lang dictionary_id="39837.Oluşturulmamış"></option>
                                        </select>
                                    </div> 
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12"> 
                                        <label class="col col-12 col-xs-12"> <cf_get_lang dictionary_id ='40195.Gösterim'></label> 
                                        <label>
                                            <input name="is_view" id="is_view" type="checkbox" value="0" <cfif isdefined('attributes.is_view') and listfind(attributes.is_view,0,',')>checked</cfif>><cf_get_lang dictionary_id ='57456.Üretim'>
                                        </label> 
                                        <label>
                                            <input name="is_view" id="is_view" type="checkbox" value="1" <cfif isdefined('attributes.is_view') and listfind(attributes.is_view,1,',')>checked</cfif>><cf_get_lang dictionary_id ='40196.Sarf'>
                                        </label> 
                                        <label>
                                            <input name="is_view" id="is_view" type="checkbox" value="3" <cfif isdefined('attributes.is_view') and listfind(attributes.is_view,3,',')>checked</cfif>><cf_get_lang dictionary_id ='29471.Fire'></label> 
                                        <label>
                                            <input name="is_view" id="is_view" type="checkbox" value="2" <cfif isdefined('attributes.is_view') and listfind(attributes.is_view,2,',')>checked<cfelseif attributes.report_type eq 12 or attributes.report_type eq 11>disabled</cfif>><cf_get_lang dictionary_id ='57771.Detay'>
                                        </label> 
                                    </div>      
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58924.Sıralama'></label>
                                        <label>
                                            <input type="radio" name="order_type" id="order_type" value="1" <cfif isdefined('attributes.order_type') and listfind(attributes.order_type,1,',')>checked</cfif>><cf_get_lang dictionary_id ='39362.Miktara Göre'> 
                                        </label>
                                        <label><input type="radio" name="order_type" id="order_type" value="2" <cfif isdefined('attributes.order_type') and listfind(attributes.order_type,2,',')>checked</cfif>><cf_get_lang dictionary_id ='40047.Maliyete Göre'> 
                                        </label>
                                        <label>
                                            <input type="radio" name="order_type" id="order_type" value="3" <cfif isdefined('attributes.order_type') and listfind(attributes.order_type,3,',')>checked</cfif>><cf_get_lang dictionary_id ='40199.Bitiş Tarihine Göre'>
                                        </label>
                                        <label>
                                            <input name="is_order_amount" id="is_order_amount" type="checkbox" value="3" <cfif isdefined('attributes.is_order_amount')>checked</cfif>><cf_get_lang dictionary_id='40708.Emir Miktarı Göster'>
                                        </label>
                                    </div>     
                                </div>
                            </div> 
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
                            <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                            <input type="hidden" name="submitted" id="submitted" value="1"/>
                            <cf_wrk_report_search_button button_type='1' search_function="control()" is_excel='1'>
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isDefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>	
<cfif isDefined("attributes.submitted")>
    <cf_report_list>
        <cfquery name="get_product_units" datasource="#dsn#">
            SELECT UNIT FROM SETUP_UNIT 
        </cfquery>
        <cfoutput query="get_product_units">
            <cfset unit_ = filterSpecialChars(get_product_units.unit)>
            <cfset 'toplam_sonuc_#unit_#' = 0>
            <cfset 'toplam_sonuc_miktar#unit_#' = 0>
            <cfset 'toplam_emir_#unit_#' = 0>
        </cfoutput>
        <cfif isdefined('attributes.is_view')>
            <cfif len(attributes.start_date1)><cf_date tarih='attributes.start_date1'></cfif>
            <cfif len(attributes.start_date2)><cf_date tarih='attributes.start_date2'></cfif>
            <cfif len(attributes.finish_date1)><cf_date tarih='attributes.finish_date1'></cfif>
            <cfif len(attributes.finish_date2)><cf_date tarih='attributes.finish_date2'></cfif>
            
            <cfif listfind(attributes.is_view,2,',')>
                    <cfquery name="get_period" datasource="#dsn#">
                        SELECT  PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
                    </cfquery>
                    <cfset list_year = valuelist(get_period.PERIOD_YEAR)>
                    <cfquery name="check_list" datasource="#dsn3#">
                        IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_FIS')
                        BEGIN
                            DROP TABLE ####GET_FIS
                        END
                    </cfquery>
                    <cfquery name="GET_FIS" datasource="#DSN3#">
                        SELECT * 
                            INTO ####GET_FIS
                        FROM
                        (
                        <cfloop list="#list_year#" index="ind_year" delimiters=",">
                            <cfset donem_dsn_alias='#dsn#_#ind_year#_#session.ep.company_id#'>
                            SELECT 
                                FIS_ID PAPER_ID,
                                FIS_NUMBER PAPER_NUMBER,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                FIS_TYPE PAPER_TYPE
                            FROM
                                #donem_dsn_alias#.STOCK_FIS STOCK_FIS
                            WHERE
                                FIS_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="110,111,112,113,119" list="yes">) AND
                                PROD_ORDER_NUMBER IS NOT NULL
                        UNION ALL
                            SELECT 
                                SHIP_ID,
                                SHIP_NUMBER,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                SHIP_TYPE
                            FROM
                                #donem_dsn_alias#.SHIP SHIP
                            WHERE
                                SHIP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="81">  AND
                                PROD_ORDER_NUMBER IS NOT NULL
                        <cfif listlast(list_year,',') neq ind_year>UNION ALL</cfif>
                        </cfloop>
                        ) as xxx
                    </cfquery>
                </cfif>
            <cfquery name="check_list_tmp" datasource="#dsn3#">
                IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####TEMP_PROD_ORDER')
                BEGIN
                    DROP TABLE ####TEMP_PROD_ORDER
                END
            </cfquery>
            <cfquery name="temp_table" datasource="#dsn3#">
                CREATE TABLE ####TEMP_PROD_ORDER 
                ( 
                    P_ORDER_ID int,
                    STOCK_ID int
                )
            </cfquery>
            <cfquery name="GET_PRODUCTION" datasource="#DSN3#" ><!--- KOSULLARA UYAN TUM URETİM SATIRLARI ILE ALINIYOR --->
                SELECT
                    PO.P_ORDER_ID,
                    -- GET_ORDER.ORDER_NUMBER ORDER_NUMBER,
                    -- GET_ORDER.MEMBER_NAME MEMBER_NAME,
                    PO.QUANTITY,
                    PO.STATUS_ID,
                    PO.STATUS,
                    PO.PROJECT_ID,
                    PO.P_ORDER_NO,
                    PO.SPEC_MAIN_ID SPECT_MAIN_ID,
                    PO.SPECT_VAR_NAME,
                    POR.PR_ORDER_ID,
                    POR.RESULT_NO,
                    POR.START_DATE,
                    POR.FINISH_DATE,
                    YEAR(POR.FINISH_DATE) PR_YEAR,
                    POR.STATION_ID,
                    POR.PROD_ORD_RESULT_STAGE,
                    POR.POSITION_ID,
                    PORR.TYPE,
                    PORR.STOCK_ID,
                    PORR.PRODUCT_ID,
                    PORR.AMOUNT,
                    datediff(minute,POR.START_DATE,POR.FINISH_DATE) AS PR_MINUTE,
                    1 AS SONUC,
                    PORR.UNIT_NAME,
                    PORR.UNIT_ID,
                    PORR.IS_SEVKIYAT,
                    PORR.PURCHASE_NET_SYSTEM,
                    PORR.PURCHASE_NET_SYSTEM_MONEY,
                    PORR.PURCHASE_EXTRA_COST_SYSTEM,
                    ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0) AS  STATION_REFLECTION_COST_SYSTEM,
                    S.PRODUCT_CATID,
                    S.PRODUCT_NAME,
                    S.PROPERTY,
                    S.STOCK_CODE,
                    S.PRODUCT_UNIT_ID,
                    PC.PRODUCT_CAT,
                    W.STATION_NAME,
                    SETUP_UNIT.UNIT,
                    EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME AS EMPLOYEE_NAME,
                        <cfif xml_show_manufact_code>
                        S.MANUFACT_CODE,
                    </cfif>
                    (SELECT AVG_COST/60 FROM WORKSTATIONS WHERE STATION_ID = POR.STATION_ID)*datediff(minute,POR.START_DATE,POR.FINISH_DATE) STATION_COST_VALUE
                    <cfif listfind(attributes.is_view,2,',')>
                        ,XXX.PAPER_ID_110,
                        XXX.PAPER_NUMBER_110,
                        YYY.PAPER_ID_111,
                        YYY.PAPER_NUMBER_111,
                        ZZZ.PAPER_ID_112,
                        ZZZ.PAPER_NUMBER_112,
                        MMM.PAPER_ID_113,
                        MMM.PAPER_NUMBER_113,
                        NNN.PAPER_ID_81,
                        NNN.PAPER_NUMBER_81
                    </cfif>
                FROM 
                    STOCKS S
                    LEFT JOIN #dsn_alias#.SETUP_UNIT ON SETUP_UNIT.UNIT_ID = (SELECT TOP 1 MAIN_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID)
                    LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = S.PRODUCT_CATID,
                    PRODUCTION_ORDERS PO
                    LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON PO.P_ORDER_ID=POR.P_ORDER_ID
                    LEFT JOIN WORKSTATIONS W ON W.STATION_ID = POR.STATION_ID
                    LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = POR.POSITION_ID
                    <cfif listfind(attributes.is_view,2,',')>
                        LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_110, 
                                PAPER_NUMBER AS PAPER_NUMBER_110,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 110 OR  PAPER_TYPE = 119    
                        ) AS XXX ON XXX.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND XXX.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                            LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_111, 
                                PAPER_NUMBER AS PAPER_NUMBER_111,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 111   
                        ) AS YYY ON YYY.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND YYY.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                        LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_112, 
                                PAPER_NUMBER AS PAPER_NUMBER_112,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 112   
                        ) AS ZZZ ON ZZZ.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND ZZZ.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                            LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_113, 
                                PAPER_NUMBER AS PAPER_NUMBER_113,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 113   
                        ) AS MMM ON MMM.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND MMM.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                        
                            LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_81, 
                                PAPER_NUMBER AS PAPER_NUMBER_81,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 81   
                        ) AS NNN ON NNN.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND NNN.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                                <!--- LEFT JOIN 
                                (
                                    SELECT 
                                                ORDERS.ORDER_ID,
                                                ORDER_NUMBER,
                                                COMPANY.NICKNAME MEMBER_NAME,
                                                PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                                            FROM 
                                                ORDERS,
                                                #dsn_alias#.COMPANY COMPANY,
                                                PRODUCTION_ORDERS_ROW
                                            WHERE 
                                                ORDERS.COMPANY_ID=COMPANY.COMPANY_ID
                                                AND ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                                AND ORDERS.COMPANY_ID IS NOT NULL
                                        UNION
                                            SELECT 
                                                ORDERS.ORDER_ID,
                                                ORDER_NUMBER,
                                                CONSUMER.CONSUMER_NAME+' '+CONSUMER.CONSUMER_SURNAME MEMBER_NAME,
                                                PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                                            FROM 
                                                ORDERS,
                                                #dsn_alias#.CONSUMER CONSUMER,
                                                PRODUCTION_ORDERS_ROW
                                            WHERE 
                                                ORDERS.CONSUMER_ID=CONSUMER.CONSUMER_ID
                                                AND ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                                AND ORDERS.CONSUMER_ID IS NOT NULL
                                ) AS GET_ORDER  ON  Po.P_ORDER_ID = GET_ORDER.PRODUCTION_ORDER_ID--->
                    </cfif>
                    ,PRODUCTION_ORDER_RESULTS_ROW PORR
                WHERE
                    S.PRODUCT_ID=PORR.PRODUCT_ID
                    AND S.STOCK_ID=PORR.STOCK_ID
                    AND POR.PR_ORDER_ID=PORR.PR_ORDER_ID
                    AND PORR.SPECT_ID IS NULL
                    <cfif listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,1,',') and not listfind(attributes.is_view,3,',')>
                        AND PORR.TYPE=1
                        <cfif len(attributes.product_id) and len(attributes.product_name)>
                            AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
                            <cfif len(attributes.spec_id) and len(attributes.spec_name)>
                                AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_id#">
                            </cfif>
                        </cfif>	
                    <cfelseif listfind(attributes.is_view,1,',') and not listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,3,',')>
                        AND PORR.TYPE=2
                        <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
                            AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#">
                            <cfif len(attributes.sarf_spec_id) and len(attributes.sarf_spec_name)>
                                AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_spec_id#">
                            </cfif>
                        </cfif>	
                    <cfelseif listfind(attributes.is_view,3,',') and not listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,1,',')>
                        AND PORR.TYPE=3
                        <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
                            AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#">
                            <cfif len(attributes.fire_spec_id) and len(attributes.fire_spec_name)>
                                AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_spec_id#">
                            </cfif>
                        </cfif>	
                    </cfif>
                    <cfif len(attributes.product_id) and len(attributes.product_name)>
                        AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
                        <cfif len(attributes.spec_id) and len(attributes.spec_name)>
                            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
                        </cfif>
                    </cfif>	
                    <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
                        AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">)
                        <cfif len(attributes.sarf_spec_id) and len(attributes.sarf_spec_name)>
                            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">)
                        </cfif>
                        <cfif listfind(attributes.is_view,1,',')>
                            AND 
                            (
                            (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#">)
                            <cfif listfind(attributes.is_view,0,',')>
                                <cfif len(attributes.product_id) and len(attributes.product_name)>
                                    OR (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">)
                                </cfif>
                            </cfif>
                            <cfif listfind(attributes.is_view,3,',')>
                                <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
                                    OR (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#">)
                                </cfif>
                            </cfif>
                            )
                        </cfif>
                    </cfif>	
                    <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
                        AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">)
                        <cfif len(attributes.fire_spec_id) and len(attributes.fire_spec_name)>
                            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">)
                        </cfif>
                        <cfif listfind(attributes.is_view,3,',')>
                            AND 
                            (
                            (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#">)
                            <cfif listfind(attributes.is_view,0,',')>
                                <cfif len(attributes.product_id) and len(attributes.product_name)>
                                    OR (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">)
                                </cfif>
                            </cfif>
                            <cfif listfind(attributes.is_view,1,',')>
                                <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
                                    OR (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#">)
                                </cfif>
                            </cfif>
                            )
                        </cfif>
                    </cfif>	
                    <cfif len(attributes.product_cat_code) and len(attributes.product_cat)>   
                        AND PORR.PR_ORDER_ID IN 
                            (
                            SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW JOIN STOCKS ON STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE = 1 AND STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_cat_code#.%"> AND PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = PORR.PR_ORDER_ID
                            )
                    </cfif>
                    <cfif len(attributes.project_id) and len(attributes.project_head)>
                        AND PO.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                    </cfif>
                    <cfif isdefined('attributes.process') and len(attributes.process)>
                        AND POR.PROD_ORD_RESULT_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process#" list="yes">)
                    </cfif>
                    <cfif len(attributes.start_date1)>
                        AND POR.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date1#">
                    </cfif>
                    <cfif len(attributes.start_date2)>
                        AND POR.START_DATE < #DATE_ADD('d',1,attributes.start_date2)#
                    </cfif>
                    <cfif len(attributes.finish_date1)>
                        AND POR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date1#">
                    </cfif>
                    <cfif len(attributes.finish_date2)>
                        AND POR.FINISH_DATE < #DATE_ADD('d',1,attributes.finish_date2)#
                    </cfif>
                    <cfif attributes.member_type eq 'partner' and len(attributes.member_name)>
                        AND 
                        PO.P_ORDER_ID IN (SELECT 
                                                PRODUCTION_ORDER_ID
                                            FROM 
                                                ORDERS, 
                                                PRODUCTION_ORDERS_ROW 
                                            WHERE 
                                                ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                                AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                                            )
                    <cfelseif attributes.member_type eq 'consumer' and len(attributes.member_name)>
                        AND 
                        PO.P_ORDER_ID IN (SELECT 
                                                PRODUCTION_ORDER_ID
                                            FROM 
                                                ORDERS, 
                                                PRODUCTION_ORDERS_ROW 
                                            WHERE 
                                                ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                                AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                                            )
                    </cfif>
                    <cfif len(attributes.station_id_)>
                        AND POR.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id_#" list="yes">)
                    </cfif>
                    <cfif len(attributes.brand_id) and len(attributes.brand_name)>
                        AND S.BRAND_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#" list="yes">)
                    </cfif>
                    <cfif attributes.report_type eq 6 or attributes.report_type eq 11>
                        AND POR.STATION_ID IS NOT NULL
                    <cfelseif attributes.report_type eq 9>
                        AND PO.IS_DEMONTAJ = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                    </cfif>
                    <cfif len(attributes.stock_fis_status)>
                        <cfif attributes.stock_fis_status eq 1>
                            AND POR.IS_STOCK_FIS = 1
                        <cfelse>
                            AND POR.IS_STOCK_FIS = 0
                        </cfif>
                    </cfif>
                UNION ALL
                SELECT
                    PO.P_ORDER_ID,
                    -- GET_ORDER.ORDER_NUMBER ORDER_NUMBER,
                    -- GET_ORDER.MEMBER_NAME MEMBER_NAME,
                    PO.QUANTITY,
                    PO.STATUS_ID,
                    PO.STATUS,
                    PO.PROJECT_ID,
                    PO.P_ORDER_NO,
                    SM.SPECT_MAIN_ID,
                    SM.SPECT_VAR_NAME,
                    POR.PR_ORDER_ID,
                    POR.RESULT_NO,
                    POR.START_DATE,
                    POR.FINISH_DATE,
                    YEAR(POR.FINISH_DATE) PR_YEAR,
                    POR.STATION_ID,
                    POR.PROD_ORD_RESULT_STAGE,
                    POR.POSITION_ID,
                    PORR.TYPE,
                    PORR.STOCK_ID,
                    PORR.PRODUCT_ID,
                    PORR.AMOUNT,
                    datediff(minute,POR.START_DATE,POR.FINISH_DATE) AS PR_MINUTE,
                    1 AS SONUC,
                    PORR.UNIT_NAME,
                    PORR.UNIT_ID,
                    PORR.IS_SEVKIYAT,
                    PORR.PURCHASE_NET_SYSTEM,
                    PORR.PURCHASE_NET_SYSTEM_MONEY,
                    PORR.PURCHASE_EXTRA_COST_SYSTEM,
                    ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0) AS  STATION_REFLECTION_COST_SYSTEM,
                    S.PRODUCT_CATID,
                    S.PRODUCT_NAME,
                    S.PROPERTY,
                    S.STOCK_CODE,
                    S.PRODUCT_UNIT_ID,
                    PC.PRODUCT_CAT,
                    W.STATION_NAME,
                    SETUP_UNIT.UNIT,
                    EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME AS EMPLOYEE_NAME,
                    <cfif xml_show_manufact_code>
                        S.MANUFACT_CODE,
                    </cfif>
                    (SELECT AVG_COST/60 FROM WORKSTATIONS WHERE STATION_ID = POR.STATION_ID)*datediff(minute,POR.START_DATE,POR.FINISH_DATE) STATION_COST_VALUE
                    <cfif listfind(attributes.is_view,2,',')>
                        ,XXX.PAPER_ID_110,
                        XXX.PAPER_NUMBER_110,
                        YYY.PAPER_ID_111,
                        YYY.PAPER_NUMBER_111,
                        ZZZ.PAPER_ID_112,
                        ZZZ.PAPER_NUMBER_112,
                        MMM.PAPER_ID_113,
                        MMM.PAPER_NUMBER_113,
                        NNN.PAPER_ID_81,
                        NNN.PAPER_NUMBER_81
                    </cfif>
                FROM 
                    STOCKS S
                    LEFT JOIN #dsn_alias#.SETUP_UNIT ON SETUP_UNIT.UNIT_ID = (SELECT TOP 1 MAIN_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID)
                    LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = S.PRODUCT_CATID,
                    PRODUCTION_ORDERS PO 
                    LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON PO.P_ORDER_ID=POR.P_ORDER_ID
                    LEFT JOIN WORKSTATIONS W ON W.STATION_ID = POR.STATION_ID
                    LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = POR.POSITION_ID
                    <cfif listfind(attributes.is_view,2,',')>
                        LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_110, 
                                PAPER_NUMBER AS PAPER_NUMBER_110,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 110 OR  PAPER_TYPE = 119    
                        ) AS XXX ON XXX.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND XXX.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                            LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_111, 
                                PAPER_NUMBER AS PAPER_NUMBER_111,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 111   
                        ) AS YYY ON YYY.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND YYY.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                        LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_112, 
                                PAPER_NUMBER AS PAPER_NUMBER_112,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 112   
                        ) AS ZZZ ON ZZZ.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND ZZZ.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                            LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_113, 
                                PAPER_NUMBER AS PAPER_NUMBER_113,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 113   
                        ) AS MMM ON MMM.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND MMM.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                        
                            LEFT JOIN
                        (
                            SELECT 
                                PAPER_ID AS PAPER_ID_81, 
                                PAPER_NUMBER AS PAPER_NUMBER_81,
                                PROD_ORDER_NUMBER,
                                PROD_ORDER_RESULT_NUMBER,
                                PAPER_TYPE
                            FROM 
                                ####GET_FIS
                            WHERE
                                PAPER_TYPE = 81   
                        ) AS NNN ON NNN.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND NNN.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
                <!---          LEFT JOIN 
                (
                    SELECT 
                                ORDERS.ORDER_ID,
                                ORDER_NUMBER,
                                COMPANY.NICKNAME MEMBER_NAME,
                                PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                            FROM 
                                ORDERS,
                                #dsn_alias#.COMPANY COMPANY,
                                PRODUCTION_ORDERS_ROW
                            WHERE 
                                ORDERS.COMPANY_ID=COMPANY.COMPANY_ID
                                AND ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                AND ORDERS.COMPANY_ID IS NOT NULL
                        UNION
                            SELECT 
                                ORDERS.ORDER_ID,
                                ORDER_NUMBER,
                                CONSUMER.CONSUMER_NAME+' '+CONSUMER.CONSUMER_SURNAME MEMBER_NAME,
                                PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                            FROM 
                                ORDERS,
                                #dsn_alias#.CONSUMER CONSUMER,
                                PRODUCTION_ORDERS_ROW
                            WHERE 
                                ORDERS.CONSUMER_ID=CONSUMER.CONSUMER_ID
                                AND ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                AND ORDERS.CONSUMER_ID IS NOT NULL
                ) AS GET_ORDER  ON  Po.P_ORDER_ID = GET_ORDER.PRODUCTION_ORDER_ID--->
                    </cfif>
                    ,PRODUCTION_ORDER_RESULTS_ROW PORR,
                    SPECTS SM
                WHERE
                    S.PRODUCT_ID=PORR.PRODUCT_ID
                    AND S.STOCK_ID=PORR.STOCK_ID
                    AND POR.PR_ORDER_ID=PORR.PR_ORDER_ID
                    AND SM.SPECT_VAR_ID=PORR.SPECT_ID
                    AND PORR.SPECT_ID IS NOT NULL
                    <cfif listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,1,',') and not listfind(attributes.is_view,3,',')>
                        AND PORR.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        <cfif len(attributes.product_id) and len(attributes.product_name)>
                            AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
                            <cfif len(attributes.spec_id) and len(attributes.spec_name)>
                                AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_id#">
                            </cfif>
                        </cfif>	
                    <cfelseif listfind(attributes.is_view,1,',') and not listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,3,',')>
                        AND PORR.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                        <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
                            AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#">
                            <cfif len(attributes.sarf_spec_id) and len(attributes.sarf_spec_name)>
                                AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_spec_id#">
                            </cfif>
                        </cfif>	
                    <cfelseif listfind(attributes.is_view,3,',') and not listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,1,',')>
                        AND PORR.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                        <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
                            AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#">
                            <cfif len(attributes.fire_spec_id) and len(attributes.fire_spec_name)>
                                AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_spec_id#">
                            </cfif>
                        </cfif>	
                    </cfif>
                    <cfif len(attributes.product_id) and len(attributes.product_name)>
                        AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
                        <cfif len(attributes.spec_id) and len(attributes.spec_name)>
                            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
                        </cfif>
                    </cfif>	
                    <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
                        AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">)
                        <cfif len(attributes.sarf_spec_id) and len(attributes.sarf_spec_name)>
                            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">)
                        </cfif>
                    </cfif>	
                    <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
                        AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">)
                        <cfif len(attributes.fire_spec_id) and len(attributes.fire_spec_name)>
                            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">)
                        </cfif>
                    </cfif>	
                    <cfif len(attributes.project_id) and len(attributes.project_head)>
                        AND PO.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                    </cfif>
                    <cfif len(attributes.product_cat_code) and len(attributes.product_cat)>
                        AND PORR.PR_ORDER_ID IN 
                            (
                            SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW JOIN STOCKS ON STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE = 1 AND STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_cat_code#.%"> AND PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = PORR.PR_ORDER_ID
                            )
                    </cfif>
                    <cfif isdefined('attributes.process') and len(attributes.process)>
                        AND POR.PROD_ORD_RESULT_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process#" list="yes">)
                    </cfif>
                    <cfif len(attributes.start_date1)>
                        AND POR.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date1#">
                    </cfif>
                    <cfif len(attributes.start_date2)>
                        AND POR.START_DATE < #DATE_ADD('d',1,attributes.start_date2)#
                    </cfif>
                    <cfif len(attributes.finish_date1)>
                        AND POR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date1#">
                    </cfif>
                    <cfif len(attributes.finish_date2)>
                        AND POR.FINISH_DATE < #DATE_ADD('d',1,attributes.finish_date2)#
                    </cfif>
                    <cfif attributes.member_type eq 'partner' and len(attributes.member_name)>
                        AND 
                        PO.P_ORDER_ID IN (SELECT 
                                                PRODUCTION_ORDER_ID
                                            FROM 
                                                ORDERS, 
                                                PRODUCTION_ORDERS_ROW 
                                            WHERE 
                                                ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                                AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                                            )
                    <cfelseif attributes.member_type eq 'consumer' and len(attributes.member_name)>
                        AND 
                        PO.P_ORDER_ID IN (SELECT 
                                                PRODUCTION_ORDER_ID
                                            FROM 
                                                ORDERS, 
                                                PRODUCTION_ORDERS_ROW 
                                            WHERE 
                                                ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                                AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                                            )
                    </cfif>
                    <cfif len(attributes.station_id_)>
                        AND POR.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id_#" list="yes">)
                    </cfif>
                    <cfif len(attributes.brand_id) and len(attributes.brand_name)>
                        AND S.BRAND_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#" list="yes">)
                    </cfif>
                    <cfif attributes.report_type eq 6 or attributes.report_type eq 11>
                        AND POR.STATION_ID IS NOT NULL
                    <cfelseif attributes.report_type eq 9>
                        AND PO.IS_DEMONTAJ = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                    </cfif>
                    <cfif len(attributes.stock_fis_status)>
                        <cfif attributes.stock_fis_status eq 1>
                            AND POR.IS_STOCK_FIS = 1
                        <cfelse>
                            AND POR.IS_STOCK_FIS = 0
                        </cfif>
                    </cfif>
                <cfif isdefined('attributes.order_type')>
                    ORDER BY
                        <cfif attributes.order_type eq 1>
                            PO.QUANTITY,
                            AMOUNT
                        <cfelseif attributes.order_type eq 2>
                            PURCHASE_NET_SYSTEM
                        <cfelse>
                            POR.FINISH_DATE
                        </cfif>
                <cfelseif attributes.report_type eq 11>
                    ORDER BY
                        POR.STATION_ID
                <cfelseif attributes.report_type eq 12>
                    ORDER BY
                        POR.POSITION_ID
                <CFELSE>
                ORDER BY --GET_ORDER.ORDER_NUMBER,
                P_ORDER_ID DESC
                </cfif>
                    ,PORR.TYPE 
            </cfquery>
            <!--- <cfif GET_PRODUCTION.recordcount> --->
                <cfset attributes.totalrecords='#GET_PRODUCTION.recordcount#'>
            <!--- </cfif> --->
            <!--- URETIMLERDE KULLANILAN RECETE ROTA VS IDLARI LISTEYE ALINIYOR VE LISTE YONTEMI ILE QUERY DONERKEN DEGERLERI ALINACAK --->
            <cfoutput query="GET_PRODUCTION">
                <cfquery name="ins_p_order_id" datasource="#dsn3#">
                    INSERT INTO
                        ####TEMP_PROD_ORDER
                    (
                        P_ORDER_ID,
                        STOCK_ID
                    )
                    VALUES
                    (
                        #P_ORDER_ID#,
                        #STOCK_ID#
                    )
                </cfquery>
            </cfoutput>
            <cfscript>
                list_p_order_id=listsort(ListDeleteDuplicates(valuelist(GET_PRODUCTION.P_ORDER_ID)),'numeric','desc',',');
            </cfscript>
            <cfif listlen(list_p_order_id)>
                <cfquery name="get_prod_amounts" datasource="#dsn3#">
                    SELECT 
                        SUM(PRODUCTION_ORDERS.QUANTITY) QUANTITY,
                        PRODUCTION_ORDERS.STOCK_ID 
                    FROM 
                        PRODUCTION_ORDERS,
                        ####TEMP_PROD_ORDER TEMP
                    WHERE 
                        PRODUCTION_ORDERS.STOCK_ID = TEMP.STOCK_ID AND 
                        PRODUCTION_ORDERS.IS_STAGE <> -1 
                    GROUP BY 
                        PRODUCTION_ORDERS.STOCK_ID
                </cfquery>
                <cfoutput query="get_prod_amounts">
                    <cfset "new_amount_#STOCK_ID#" = QUANTITY>
                </cfoutput>
                <cfquery name="GET_ORDER" datasource="#DSN3#">
                    SELECT 
                        ORDERS.ORDER_ID,
                        ORDER_NUMBER,
                        COMPANY.NICKNAME MEMBER_NAME,
                        PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                    FROM 
                        ORDERS,
                        #dsn_alias#.COMPANY COMPANY,
                        PRODUCTION_ORDERS_ROW,
                        ####TEMP_PROD_ORDER TEMP
                    WHERE 
                        ORDERS.COMPANY_ID=COMPANY.COMPANY_ID
                        AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = TEMP.P_ORDER_ID
                        AND ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                        AND ORDERS.COMPANY_ID IS NOT NULL
                UNION
                    SELECT 
                        ORDERS.ORDER_ID,
                        ORDER_NUMBER,
                        CONSUMER.CONSUMER_NAME+' '+CONSUMER.CONSUMER_SURNAME MEMBER_NAME,
                        PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                    FROM 
                        ORDERS,
                        #dsn_alias#.CONSUMER CONSUMER,
                        PRODUCTION_ORDERS_ROW,
                        ####TEMP_PROD_ORDER TEMP
                    WHERE 
                        ORDERS.CONSUMER_ID=CONSUMER.CONSUMER_ID
                        AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = TEMP.P_ORDER_ID
                        AND ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                        AND ORDERS.CONSUMER_ID IS NOT NULL
                    ORDER BY 
                        PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID DESC
                </cfquery>
                <cfloop query="GET_ORDER">
                    <cfif not isdefined('order_list_#PRODUCTION_ORDER_ID#')>
                        <cfset 'order_list_#PRODUCTION_ORDER_ID#' = ORDER_NUMBER>
                    <cfelse>
                        <cfset 'order_list_#PRODUCTION_ORDER_ID#' = listdeleteduplicates(ListAppend(Evaluate('order_list_#PRODUCTION_ORDER_ID#'),ORDER_NUMBER,','))>
                    </cfif>
                    <cfif not isdefined('order_member_#PRODUCTION_ORDER_ID#')>
                        <cfset 'order_member_#PRODUCTION_ORDER_ID#' = MEMBER_NAME>
                    <cfelse>
                        <cfset 'order_member_#PRODUCTION_ORDER_ID#' = listdeleteduplicates(ListAppend(Evaluate('order_member_#PRODUCTION_ORDER_ID#'),MEMBER_NAME,','))>
                    </cfif>
                </cfloop>
            </cfif>
            <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                <cfset type_ = 1>
            <cfelse>
                <cfset type_ = 0>
            </cfif>
            <cfif isdefined('attributes.report_type') and attributes.report_type eq 11>
                <cfquery name="get_production_station" dbtype="query">
                    SELECT DISTINCT STATION_ID FROM GET_PRODUCTION
                </cfquery>
                <cfoutput query="get_production_station">
                    <cfset "total_prod_amount_#station_id#" = 0>
                    <cfset "total_prod_purchase_net_#station_id#" = 0>
                    <cfset "total_prod_purchase_extra_system_#station_id#" = 0>
                    <cfset "total_prod_station_reflection_cost_system_#station_id#" = 0>
                    <cfset "total_station_cost_#station_id#" = 0>
                    <cfset "total_sarf_amount_#station_id#" = 0>
                    <cfset "total_sarf_purchase_net_system_#station_id#" = 0>
                    <cfset "total_sarf_purchase_extra_system_#station_id#" = 0>
                    <cfset "total_sarf_amount_sb_#station_id#" = 0>
                    <cfset "total_sarf_purchase_net_system_sb_#station_id#" = 0>
                    <cfset "total_sarf_purchase_extra_system_sb_#station_id#" = 0>
                    <cfset "total_sarf_amount_with_sb_#station_id#" = 0>
                    <cfset "total_sarf_cost_#station_id#" = 0>
                    <cfset "total_fire_amount_#station_id#" = 0>
                    <cfset "total_fire_purchase_net_system_#station_id#" = 0>
                    <cfset "total_fire_purchase_extra_system_#station_id#" = 0>
                    <cfset "total_fire_amount_sb_#station_id#" = 0>
                    <cfset "total_fire_purchase_net_system_sb_#station_id#" = 0>
                    <cfset "total_fire_purchase_extra_system_sb_#station_id#" = 0>
                    <cfset "total_fire_amount_with_sb_#station_id#" = 0>
                    <cfset "total_fire_cost_#station_id#" = 0>
                    <cfset "total_production_result_count_#station_id#" = 0>
                    <cfset "total_production_result_minute_#station_id#" = 0>
                    <cfset "total_cost_all_#station_id#" = 0>
                    <cfloop query="get_product_units">
                        <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                        <cfset 'toplam_sonuc_#get_production_station.station_id#_#unit_#' = 0>
                        <cfset 'toplam_sonuc_miktar#get_production_station.station_id#_#unit_#' = 0>
                        <cfset 'toplam_emir_#get_production_station.station_id#_#unit_#' = 0>
                    </cfloop>
                </cfoutput>
            </cfif>
            <cfif isdefined('attributes.report_type') and attributes.report_type eq 12>
                <cfquery name="get_production_position" dbtype="query">
                    SELECT DISTINCT POSITION_ID FROM GET_PRODUCTION
                </cfquery>
                <cfoutput query="get_production_position">
                    <cfset "total_prod_amount_#position_id#" = 0>
                    <cfset "total_prod_purchase_net_#position_id#" = 0>
                    <cfset "total_prod_purchase_extra_system_#position_id#" = 0>
                    <cfset "total_prod_station_reflection_cost_system_#position_id#" = 0>
                    <cfset "total_station_cost_#position_id#" = 0>
                    <cfset "total_sarf_amount_#position_id#" = 0>
                    <cfset "total_sarf_purchase_net_system_#position_id#" = 0>
                    <cfset "total_sarf_purchase_extra_system_#position_id#" = 0>
                    <cfset "total_sarf_amount_sb_#position_id#" = 0>
                    <cfset "total_sarf_purchase_net_system_sb_#position_id#" = 0>
                    <cfset "total_sarf_purchase_extra_system_sb_#position_id#" = 0>
                    <cfset "total_sarf_amount_with_sb_#position_id#" = 0>
                    <cfset "total_sarf_cost_#position_id#" = 0>
                    <cfset "total_fire_amount_#position_id#" = 0>
                    <cfset "total_fire_purchase_net_system_#position_id#" = 0>
                    <cfset "total_fire_purchase_extra_system_#position_id#" = 0>
                    <cfset "total_fire_amount_sb_#position_id#" = 0>
                    <cfset "total_fire_purchase_net_system_sb_#position_id#" = 0>
                    <cfset "total_fire_purchase_extra_system_sb_#position_id#" = 0>
                    <cfset "total_fire_amount_with_sb_#position_id#" = 0>
                    <cfset "total_fire_cost_#position_id#" = 0>
                    <cfset "total_production_result_count_#position_id#" = 0>
                    <cfset "total_production_result_minute_#position_id#" = 0>
                    <cfset "total_cost_all_#position_id#" = 0>
                    <cfloop query="get_product_units">
                        <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                        <cfset 'toplam_sonuc_#get_production_position.position_id#_#unit_#' = 0>
                        <cfset 'toplam_sonuc_miktar#get_production_position.position_id#_#unit_#' = 0>
                        <cfset 'toplam_emir_#get_production_position.position_id#_#unit_#' = 0>
                    </cfloop>
                </cfoutput>
            </cfif>
            
            <cfif isdefined('attributes.ajax')>
                <cfset style_="display:none;">
            <cfelse>
                <cfset style_="">
            </cfif>	

                <cfif not listfind(attributes.is_view,2,',')><!--- detay checkbox i secili oldugunda gruplama tablosu gelmesin. --->
                    <thead>
                        <tr> 
                            <cfset colspan__ = 2>
                            <th><cf_get_lang dictionary_id ='57487.No'></th>
                            <cfif attributes.report_type eq 11>
                                <th><cf_get_lang dictionary_id ='58834.İstasyon'></th>
                                <cfset colspan__ = colspan__ + 1>
                            </cfif>
                            <cfif attributes.report_type eq 12>
                                 <th><cf_get_lang dictionary_id='36765.İşlemi Yapan'></th>
                                <cfset colspan__ = colspan__ + 1>
                            </cfif> 
                            <cfif listfind('1,2,4,7,9,11,12',attributes.report_type)>
                                <th><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
                                <cfset colspan__ = colspan__ + 1>
                            </cfif>
                            <th>
                                <cfif listfind('1,2,4,7,9,11,12',attributes.report_type)>
                                <cf_get_lang dictionary_id ='57657.Ürün'>
                                <cfelseif attributes.report_type eq 3>
                                <cf_get_lang dictionary_id ='57486.Kategori'>
                                <cfelseif attributes.report_type eq 10 >
                                <cf_get_lang dictionary_id ='57576.Çalışan'>
                                <cfelse>
                                <cf_get_lang dictionary_id='58960.Rapor Tipi'>
                                </cfif>
                            </th>
                            <cfif attributes.report_type eq 8>
                                <th>
                                    <cf_get_lang dictionary_id="29651.Üretim Sonucu"> <cf_get_lang dictionary_id="58593.Tarihi">
                                </th>
                                <cfset colspan__ = colspan__ + 1>
                            </cfif>
                            <cfif (attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 4 or attributes.report_type eq 9) and xml_show_manufact_code>
                                <th>
                                    <cf_get_lang dictionary_id="57634.Üretici Kodu">
                                </th>
                                <cfset colspan__ = colspan__ + 1>
                            </cfif>
                            <cfif  listfind('1,2,4,7,9,11,12',attributes.report_type)>
                                <th><cf_get_lang dictionary_id ='57636.Birim'></th>
                                <cfset colspan__ = colspan__ + 1>
                            </cfif>
                            <cfif listfind(attributes.is_view,0,',')>
                                <cfset colspan__ = colspan__ + 9>
                                <th width="1"></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57684.Sonuç'></th>
                                <cfif isdefined("attributes.is_order_amount")>
                                    <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40407.Emir'></th>
                                    <cfset colspan__ = colspan__ + 1>
                                </cfif>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='58127.Dakika'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40200.Alış Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40201.Alış Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40202.İstasyon Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='39168.Yansıyan Maliyet'></th>   
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40203.Toplam Maliyet'></th>
                            </cfif>
                            <cfif listfind(attributes.is_view,1,',')>
                                <cfset colspan__ = colspan__ + 9>
                                <th></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40186.Üretim Sarf Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40187.Üretim Sarf Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40023.Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40412.SB Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40413.SB Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40414.SB Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam '><cf_get_lang dictionary_id ='39140.Sarf Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam '><cf_get_lang dictionary_id ='39142.Sarf Maliyet'> </th>
                            </cfif>
                            <cfif listfind(attributes.is_view,3,',')>
                                <cfset colspan__ = colspan__ + 9>
                                <th></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40709.Üretim Fire Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40710.Üretim Fire Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40023.Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40412.SB Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40413.SB Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40414.SB Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam '><cf_get_lang dictionary_id ='39141.Fire Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam '><cf_get_lang dictionary_id ='39143.Fire Maliyet'></th>
                            </cfif>
                        </tr>
                    </thead>
                    <cfif not listfind('11,12',attributes.report_type)>
                        <cfscript>
                        //FORM TIPINE GORE QUERY GROUP LARINDA KULLANILACAK
                            if(attributes.report_type eq 1)
                                rep_type_col="PRODUCT_ID";
                            else if(attributes.report_type eq 2)
                                rep_type_col="STOCK_ID";
                            else if(attributes.report_type eq 3)
                                rep_type_col="PRODUCT_CATID,PRODUCT_CAT";
                            else if(attributes.report_type eq 4)
                                rep_type_col="PRODUCT_ID,SPECT_MAIN_ID";
                            else if(attributes.report_type eq 6)
                                rep_type_col="STATION_ID";
                            else if(attributes.report_type eq 7)
                                rep_type_col="PRODUCT_ID";
                            else if(attributes.report_type eq 8)
                                rep_type_col="PR_ORDER_ID";
                            else if(attributes.report_type eq 10)
                                rep_type_col="POSITION_ID";
                            else
                                rep_type_col="PRODUCT_ID";
                                
                        //FORM TIPINE GORE SATIRLARDA YAZILACAK VERILER
                            if(attributes.report_type eq 1)
                                //rep_type_col2="PRODUCT_ID,STOCK_ID,PRODUCT_NAME,STOCK_CODE,UNIT_NAME,UNIT";
                                rep_type_col2="PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,UNIT_NAME,UNIT";
                            else if(attributes.report_type eq 2)
                                //rep_type_col2="STOCK_ID,PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,PROPERTY,UNIT_NAME,UNIT";
                                rep_type_col2="STOCK_ID,PRODUCT_NAME,STOCK_CODE,PROPERTY,UNIT";
                            else if(attributes.report_type eq 3)
                                rep_type_col2="PRODUCT_CATID,PRODUCT_CAT";
                            else if(attributes.report_type eq 4)
                                //rep_type_col2="PRODUCT_ID,SPECT_MAIN_ID,SPECT_VAR_NAME,STOCK_CODE,UNIT_NAME,UNIT";
                                rep_type_col2="PRODUCT_ID,SPECT_MAIN_ID,SPECT_VAR_NAME,STOCK_CODE,UNIT";
                            else if(attributes.report_type eq 6)
                                rep_type_col2="STATION_ID,STATION_NAME";
                            else if(attributes.report_type eq 7)
                                //  rep_type_col2="PRODUCT_ID,STOCK_ID,PRODUCT_NAME,STOCK_CODE,UNIT_NAME,UNIT";
                                    rep_type_col2="PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,UNIT_NAME,UNIT";
                            else if(attributes.report_type eq 8)
                                rep_type_col2="P_ORDER_ID,PR_ORDER_ID,RESULT_NO,FINISH_DATE";
                            else if(attributes.report_type eq 9)
                                //rep_type_col2="PRODUCT_ID,STOCK_ID,PRODUCT_NAME,STOCK_CODE,UNIT_NAME,UNIT";
                                rep_type_col2="PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,UNIT_NAME,UNIT";
                            else if(attributes.report_type eq 10)                          
                                rep_type_col2="POSITION_ID,EMPLOYEE_NAME";	
                            else
                                rep_type_col2="PRODUCT_ID";
                        
                            total_prod_amount=0;
                            total_prod_purchase_net=0;
                            total_prod_purchase_extra_system=0;
                            total_prod_station_reflection_cost_system=0;
                            total_station_cost=0;
                            total_sarf_amount=0;
                            total_sarf_purchase_net_system=0;
                            total_sarf_purchase_extra_system=0;
                            total_sarf_amount_sb=0;
                            total_sarf_purchase_net_system_sb=0;
                            total_sarf_purchase_extra_system_sb=0;
                            total_sarf_amount_with_sb=0;
                            total_sarf_cost=0;
                            total_fire_amount=0;
                            total_fire_purchase_net_system=0;
                            total_fire_purchase_extra_system=0;
                            total_fire_amount_sb=0;
                            total_fire_purchase_net_system_sb=0;
                            total_fire_purchase_extra_system_sb=0;
                            total_fire_amount_with_sb=0;
                            total_fire_cost=0;
                            total_production_result_count = 0;
                            total_production_result_minute = 0;
                            total_cost_all = 0;
                            row_=(attributes.page-1)*attributes.maxrows;
                        </cfscript>
                        <tbody>
                            <cfif GET_PRODUCTION.recordcount>
                                <cfquery name="get_production__" dbtype="query">
                                    SELECT
                                        SUM(PR_MINUTE) AS TOTAL_MINUTE,
                                        SUM(SONUC) AS TOTAL_RESULT_COUNT,
                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                        SUM(QUANTITY) TOTAL_QUANTITY,
                                        SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                        SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                        SUM(STATION_REFLECTION_COST_SYSTEM*AMOUNT) STATION_REFLECTION_COST_SYSTEM,
                                        SUM(STATION_COST_VALUE*AMOUNT) STATION_COST_VALUE,
                                        #rep_type_col2#
                                        <cfif (attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 4 or attributes.report_type eq 9) and xml_show_manufact_code>,MANUFACT_CODE</cfif>
                                    FROM
                                        GET_PRODUCTION
                                    GROUP BY
                                        #rep_type_col2#
                                        <cfif (attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 4 or attributes.report_type eq 9) and xml_show_manufact_code>,MANUFACT_CODE</cfif>
                                    ORDER BY P_ORDER_ID DESC,TYPE
                                </cfquery>
                                <cfset count = 1>
                                <cfset attributes.totalrecords = get_production__.recordcount>
                                
                                <cfoutput query="get_production__" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <cfset count++> 
                                    <cfset row_=row_+1>
                                    <cfif listfind(attributes.is_view,0,',')>
                                        <cfquery name="GET_K_PROD_ORDER" dbtype="query">
                                            SELECT
                                                DISTINCT STOCK_ID
                                            FROM
                                                GET_PRODUCTION
                                            WHERE
                                                TYPE=1
                                                <cfif attributes.report_type eq 1>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 2>
                                                    AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
                                                <cfelseif attributes.report_type eq 3>
                                                    AND PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#">
                                                <cfelseif attributes.report_type eq 4>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    <cfif len(SPECT_MAIN_ID)>
                                                        AND SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ID#">
                                                    <cfelse>
                                                        AND SPECT_MAIN_ID IS NULL
                                                    </cfif>
                                                <cfelseif attributes.report_type eq 6>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                <cfelseif attributes.report_type eq 7>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 8>
                                                    AND PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PR_ORDER_ID#">
                                                <cfelseif attributes.report_type eq 9>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 10>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                <cfelseif attributes.report_type eq 11>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 12>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                </cfif>
                                        </cfquery>
                                        <cfset prod_quantity=0>
                                        <cfloop query="GET_K_PROD_ORDER">
                                            <cfif isdefined("new_amount_#STOCK_ID#")>
                                                <cfset prod_quantity = prod_quantity + evaluate("new_amount_#STOCK_ID#")>
                                            </cfif>
                                        </cfloop>
                                        <cfquery name="GET_K_PROD" dbtype="query">
                                            SELECT
                                                SUM(PR_MINUTE) AS TOTAL_MINUTE,
                                                SUM(SONUC) AS TOTAL_RESULT_COUNT,
                                                SUM(AMOUNT) TOTAL_AMOUNT,
                                                SUM(QUANTITY) TOTAL_QUANTITY,
                                                SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                SUM(STATION_REFLECTION_COST_SYSTEM*AMOUNT) STATION_REFLECTION_COST_SYSTEM,
                                                SUM(STATION_COST_VALUE*AMOUNT) STATION_COST_VALUE
                                                ,#rep_type_col#
                                            FROM
                                                GET_PRODUCTION
                                            WHERE
                                                TYPE=1
                                                <cfif attributes.report_type eq 1>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 2>
                                                    AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
                                                <cfelseif attributes.report_type eq 3>
                                                    AND PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#">
                                                <cfelseif attributes.report_type eq 4>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    <cfif len(SPECT_MAIN_ID)>
                                                        AND SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ID#">
                                                    <cfelse>
                                                        AND SPECT_MAIN_ID IS NULL
                                                    </cfif>
                                                <cfelseif attributes.report_type eq 6>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                <cfelseif attributes.report_type eq 7>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 8>
                                                    AND PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PR_ORDER_ID#">
                                                <cfelseif attributes.report_type eq 9>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 10>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                <cfelseif attributes.report_type eq 11>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 12>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                </cfif>
                                            GROUP BY
                                                #rep_type_col#,
                                                PR_ORDER_ID
                                        </cfquery>
                                        <cfscript>
                                            prod_amount=0;
                                            prod_purchase_net_system=0;
                                            prod_purchase_extra_system=0;
                                            prod_station_cost=0;
                                            prod_reflection_cost=0;
                                            prod_station_minute=0;
                                            prod_station_result=0;
                                            if(GET_K_PROD.RECORDCOUNT)
                                            {
                                                for(prod_rw=1;prod_rw lte GET_K_PROD.RECORDCOUNT;prod_rw=prod_rw+1)
                                                {
                                                    if(len(GET_K_PROD.TOTAL_AMOUNT[prod_rw])) prod_amount=prod_amount+GET_K_PROD.TOTAL_AMOUNT[prod_rw]; else GET_K_PROD.TOTAL_AMOUNT[prod_rw]=0;
                                                    if(len(GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw])) prod_purchase_net_system=prod_purchase_net_system+GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw];
                                                    if(len(GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw])) prod_purchase_net_system=prod_purchase_net_system+GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw];
                                                    if(len(GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw])) prod_reflection_cost=prod_reflection_cost+GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw];
                                                    if(len(GET_K_PROD.STATION_COST_VALUE[prod_rw])) prod_station_cost=prod_station_cost+GET_K_PROD.STATION_COST_VALUE[prod_rw];
                                                    if(len(GET_K_PROD.TOTAL_MINUTE[prod_rw])) prod_station_minute=prod_station_minute+GET_K_PROD.TOTAL_MINUTE[prod_rw]; else GET_K_PROD.TOTAL_MINUTE[prod_rw]=0;
                                                    if(len(GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw])) prod_station_result=prod_station_result+GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]; else GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]=0;
                                                }
                                            }
                                        </cfscript>
                                    </cfif>
                                    <cfif listfind(attributes.is_view,1,',')>
                                        <cfquery name="GET_K_SARF" dbtype="query">
                                            SELECT 
                                                SUM(AMOUNT) TOTAL_AMOUNT,
                                                SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM
                                                ,#rep_type_col#
                                            FROM
                                                GET_PRODUCTION
                                            WHERE
                                                TYPE=2
                                                AND IS_SEVKIYAT=0
                                                <cfif attributes.report_type eq 1>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif report_type eq 2>
                                                    AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
                                                <cfelseif report_type eq 3>
                                                    AND PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#">
                                                <cfelseif report_type eq 4>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    <cfif len(SPECT_MAIN_ID)>
                                                        AND SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ID#">
                                                    <cfelse>
                                                        AND SPECT_MAIN_ID IS NULL
                                                    </cfif>
                                                <cfelseif report_type eq 6>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                <cfelseif attributes.report_type eq 7>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 8>
                                                    AND PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PR_ORDER_ID#">
                                                <cfelseif attributes.report_type eq 9>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 10>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                <cfelseif report_type eq 11>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif report_type eq 12>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                </cfif>
                                            GROUP BY
                                                #rep_type_col#,
                                                P_ORDER_ID
                                        </cfquery>
                                        <cfscript>
                                            sarf_amount=0;
                                            sarf_purchase_net_system=0;
                                            sarf_purchase_extra_system=0;
                                            if(GET_K_SARF.RECORDCOUNT)
                                            {
                                                for(sarf_rw=1;sarf_rw lte GET_K_SARF.RECORDCOUNT;sarf_rw=sarf_rw+1)
                                                {
                                                    if(len(GET_K_SARF.TOTAL_AMOUNT[sarf_rw])) sarf_amount=sarf_amount+GET_K_SARF.TOTAL_AMOUNT[sarf_rw]; else GET_K_SARF.TOTAL_AMOUNT[sarf_rw]=0;
                                                    if(len(GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw])) sarf_purchase_net_system=sarf_purchase_net_system+GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw];
                                                    if(len(GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw])) sarf_purchase_extra_system=sarf_purchase_extra_system+GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw];
                                                }
                                            }
                                        </cfscript>
                                        <cfquery name="GET_K_SARF_SB" dbtype="query">
                                            SELECT 
                                                SUM(AMOUNT) TOTAL_AMOUNT,
                                                SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM
                                                ,#rep_type_col#
                                            FROM
                                                GET_PRODUCTION
                                            WHERE
                                                TYPE=2
                                                AND IS_SEVKIYAT=1
                                                <cfif attributes.report_type eq 1>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif report_type eq 2>
                                                    AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
                                                <cfelseif report_type eq 3>
                                                    AND PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#">
                                                <cfelseif report_type eq 4>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    <cfif len(SPECT_MAIN_ID)>
                                                        AND SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ID#">
                                                    <cfelse>
                                                        AND SPECT_MAIN_ID IS NULL
                                                    </cfif>
                                                <cfelseif report_type eq 6>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                <cfelseif attributes.report_type eq 7>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 8>
                                                    AND PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PR_ORDER_ID#">
                                                <cfelseif attributes.report_type eq 9>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 10>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                <cfelseif report_type eq 11>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif report_type eq 12>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                </cfif>
                                            GROUP BY
                                                #rep_type_col#,
                                                P_ORDER_ID
                                        </cfquery>
                                        <cfscript>
                                            sarf_amount_sb=0;
                                            sarf_purchase_net_system_sb=0;
                                            sarf_purchase_extra_system_sb=0;
                                            if(GET_K_SARF_SB.RECORDCOUNT)
                                            {
                                                for(sarf_sb_rw=1;sarf_sb_rw lte GET_K_SARF_SB.RECORDCOUNT;sarf_sb_rw=sarf_sb_rw+1)
                                                {
                                                    if(len(GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw])) sarf_amount_sb=sarf_amount_sb+GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]; else GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]=0;
                                                    if(len(GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw])) sarf_purchase_net_system_sb=sarf_purchase_net_system_sb+GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                    if(len(GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw])) sarf_purchase_extra_system_sb=sarf_purchase_extra_system_sb+GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                }
                                            }
                                        </cfscript>
                                    </cfif>
                                    <cfif listfind(attributes.is_view,3,',')>
                                        <cfquery name="GET_K_FIRE" dbtype="query">
                                            SELECT 
                                                SUM(AMOUNT) TOTAL_AMOUNT,
                                                SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM
                                                ,#rep_type_col#
                                            FROM
                                                GET_PRODUCTION
                                            WHERE
                                                TYPE=3
                                                AND IS_SEVKIYAT=0
                                                <cfif attributes.report_type eq 1>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif report_type eq 2>
                                                    AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
                                                <cfelseif report_type eq 3>
                                                    AND PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#">
                                                <cfelseif report_type eq 4>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    <cfif len(SPECT_MAIN_ID)>
                                                        AND SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ID#">
                                                    <cfelse>
                                                        AND SPECT_MAIN_ID IS NULL
                                                    </cfif>
                                                <cfelseif report_type eq 6>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                <cfelseif attributes.report_type eq 7>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 8>
                                                    AND PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PR_ORDER_ID#">
                                                <cfelseif attributes.report_type eq 9>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 10>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                <cfelseif report_type eq 11>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif report_type eq 12>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                </cfif>
                                            GROUP BY
                                                #rep_type_col#,
                                                P_ORDER_ID
                                        </cfquery>
                                        <cfscript>
                                            fire_amount=0;
                                            fire_purchase_net_system=0;
                                            fire_purchase_extra_system=0;
                                            if(GET_K_FIRE.RECORDCOUNT)
                                            {
                                                for(fire_rw=1;fire_rw lte GET_K_FIRE.RECORDCOUNT;fire_rw=fire_rw+1)
                                                {
                                                    if(len(GET_K_FIRE.TOTAL_AMOUNT[fire_rw])) fire_amount=fire_amount+GET_K_FIRE.TOTAL_AMOUNT[fire_rw]; else GET_K_FIRE.TOTAL_AMOUNT[fire_rw]=0;
                                                    if(len(GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw])) fire_purchase_net_system=fire_purchase_net_system+GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                    if(len(GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw])) fire_purchase_extra_system=fire_purchase_extra_system+GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                }
                                            }
                                        </cfscript>
                                        <cfquery name="GET_K_FIRE_SB" dbtype="query">
                                            SELECT 
                                                SUM(AMOUNT) TOTAL_AMOUNT,
                                                SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM
                                                ,#rep_type_col#
                                            FROM
                                                GET_PRODUCTION
                                            WHERE
                                                TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                                                AND IS_SEVKIYAT = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                                                <cfif attributes.report_type eq 1>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif report_type eq 2>
                                                    AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
                                                <cfelseif report_type eq 3>
                                                    AND PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#">
                                                <cfelseif report_type eq 4>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    <cfif len(SPECT_MAIN_ID)>
                                                        AND SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ID#">
                                                    <cfelse>
                                                        AND SPECT_MAIN_ID IS NULL
                                                    </cfif>
                                                <cfelseif report_type eq 6>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                <cfelseif attributes.report_type eq 7>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 8>
                                                    AND PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PR_ORDER_ID#">
                                                <cfelseif attributes.report_type eq 9>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif attributes.report_type eq 10>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                <cfelseif report_type eq 11>
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                <cfelseif report_type eq 12>
                                                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                </cfif>
                                            GROUP BY
                                                #rep_type_col#,
                                                P_ORDER_ID
                                        </cfquery>
                                        <cfscript>
                                            fire_amount_sb=0;
                                            fire_purchase_net_system_sb=0;
                                            fire_purchase_extra_system_sb=0;
                                            if(GET_K_FIRE_SB.RECORDCOUNT)
                                            {
                                                for(fire_sb_rw=1;fire_sb_rw lte GET_K_FIRE_SB.RECORDCOUNT;fire_sb_rw=fire_sb_rw+1)
                                                {
                                                    if(len(GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw])) fire_amount_sb=fire_amount_sb+GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]; else GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]=0;
                                                    if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw])) fire_purchase_net_system_sb=fire_purchase_net_system_sb+GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                    if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw])) fire_purchase_extra_system_sb=fire_purchase_extra_system_sb+GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                }
                                            }
                                        </cfscript>
                                    </cfif>
                                    <cfif isdefined('attributes.ajax')><!--- Kümülatif raporlar oluşturuluyorsa! --->
                                        <cfinclude template="../../settings/cumulative/cumulative_production_analyse_inc.cfm">
                                    <cfelse>
                                        <tr>
                                            <td>#row_#</td>
                                            <cfif attributes.report_type eq 1 or  attributes.report_type eq 2 or  attributes.report_type eq 4 or  attributes.report_type eq 7 or  attributes.report_type eq 9>
                                                <td>#STOCK_CODE#</td>
                                            </cfif>
                                            <td>
                                                <cfif attributes.report_type eq 1>
                                                    #PRODUCT_NAME#
                                                <cfelseif attributes.report_type eq 2>
                                                    #PRODUCT_NAME# #PROPERTY# 
                                                <cfelseif attributes.report_type eq 3>
                                                    #PRODUCT_CAT#
                                                <cfelseif attributes.report_type eq 4>
                                                    #PRODUCT_NAME# - #SPECT_VAR_NAME# 
                                                <cfelseif attributes.report_type eq 6>
                                                    <cfif len(STATION_ID)>#STATION_NAME#</cfif>
                                                <cfelseif attributes.report_type eq 7>
                                                    #PRODUCT_NAME#
                                                <cfelseif attributes.report_type eq 8>
                                                    <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                                        <a href="#request.self#?fuseaction=prod.upd_prod_order_result&p_order_id=#p_order_id#&pr_order_id=#pr_order_id#" >#RESULT_NO#</a> 
                                                    <cfelse>
                                                        #RESULT_NO#
                                                    </cfif>
                                                <cfelseif attributes.report_type eq 9>
                                                    #PRODUCT_NAME#
                                                <cfelseif attributes.report_type eq 10>
                                                    #EMPLOYEE_NAME#
                                                </cfif>
                                            </td>
                                            <cfif attributes.report_type eq 8>
                                                <td>
                                                    #DateFormat(finish_date,dateformat_style)#
                                                </td>
                                            </cfif>
                                            <cfif (attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 4 or attributes.report_type eq 9) and xml_show_manufact_code>
                                                <td style="mso-number-format:\@;">
                                                    #manufact_code#
                                                </td>
                                            </cfif>
                                            <cfif attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 4 or attributes.report_type eq 7 or attributes.report_type eq 9>
                                                <td>
                                                    <cfif len(UNIT)>
                                                        #UNIT#
                                                        <cfset row_unit_ = filterSpecialChars(UNIT)>
                                                    <cfelse>
                                                        <cfset row_unit_ = "">
                                                    </cfif>
                                                </td>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,0,',')>
                                            <td></td>
                                            <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(prod_station_result,8,1),8)#
                                                <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_sonuc_#row_unit_#" = wrk_round(prod_station_result,8,1) + evaluate("toplam_sonuc_#row_unit_#")></cfif>
                                            </td>
                                            <cfif isdefined("attributes.is_order_amount")>
                                                <td align="right" style="text-align:right;" format="numeric">#tlformat(prod_quantity)#
                                                    <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_emir_#row_unit_#" = prod_quantity + evaluate("toplam_emir_#row_unit_#")></cfif>
                                                </td>
                                            </cfif>
                                            <td align="right" style="text-align:right;" format="numeric">#tlformat(prod_station_minute)#<cfset total_production_result_minute=total_production_result_minute+prod_station_minute></td>
                                            <td align="right" style="text-align:right;" format="numeric">#TLFormat(prod_amount)# <cfset total_prod_amount=total_prod_amount+prod_amount>
                                            <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_sonuc_miktar#row_unit_#" = prod_amount + evaluate("toplam_sonuc_miktar#row_unit_#")></cfif>
                                            </td>
                                            <td align="right" style="text-align:right;" format="numeric">#TLFormat(prod_purchase_net_system)# <cfset total_prod_purchase_net=total_prod_purchase_net+prod_purchase_net_system></td>
                                            <td align="right" style="text-align:right;" format="numeric">#TLFormat(prod_purchase_extra_system)# <cfset total_prod_purchase_extra_system=total_prod_purchase_extra_system+prod_purchase_extra_system></td>
                                            <td align="right" style="text-align:right;" format="numeric">#TLFormat(prod_station_cost)# <cfset total_station_cost=total_station_cost+prod_station_cost></td>
                                            <td align="right" style="text-align:right;" format="numeric">#TLFormat(prod_reflection_cost)#</td><cfset total_prod_station_reflection_cost_system=total_prod_station_reflection_cost_system+prod_reflection_cost>
                                            <td align="right" style="text-align:right;" format="numeric">
                                                #TLFormat((prod_reflection_cost+prod_purchase_net_system+prod_purchase_extra_system+prod_station_cost))#
                                                <cfset total_cost_all = total_cost_all + ((prod_reflection_cost+prod_purchase_net_system+prod_purchase_extra_system+prod_station_cost))>
                                            </td>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,1,',')>
                                                <td></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(sarf_amount,8,1),8)# <cfset total_sarf_amount=total_sarf_amount+wrk_round(sarf_amount,8,1)></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(sarf_purchase_net_system)# <cfset total_sarf_purchase_net_system=total_sarf_purchase_net_system+sarf_purchase_net_system></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(sarf_purchase_extra_system)# <cfset total_sarf_purchase_extra_system=total_sarf_purchase_extra_system+sarf_purchase_extra_system></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(sarf_amount_sb)# <cfset total_sarf_amount_sb=total_sarf_amount_sb+sarf_amount_sb></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(sarf_purchase_net_system_sb)# <cfset total_sarf_purchase_net_system_sb=total_sarf_purchase_net_system_sb+sarf_purchase_net_system_sb></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(sarf_purchase_extra_system_sb)# <cfset total_sarf_purchase_extra_system_sb=total_sarf_purchase_extra_system_sb+sarf_purchase_extra_system_sb></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(sarf_amount+sarf_amount_sb)# <cfset total_sarf_amount_with_sb=total_sarf_amount_with_sb+sarf_amount+sarf_amount_sb></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(sarf_purchase_net_system+sarf_purchase_net_system_sb+sarf_purchase_extra_system+sarf_purchase_extra_system_sb)#</td>
                                                <cfset total_sarf_cost=total_sarf_cost+sarf_purchase_net_system+sarf_purchase_net_system_sb+sarf_purchase_extra_system+sarf_purchase_extra_system_sb>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,3,',')>
                                                <td></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(fire_amount,8,1),8)# <cfset total_fire_amount=total_fire_amount+wrk_round(fire_amount,8,1)></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(fire_purchase_net_system)# <cfset total_fire_purchase_net_system=total_fire_purchase_net_system+fire_purchase_net_system></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(fire_purchase_extra_system)# <cfset total_fire_purchase_extra_system=total_fire_purchase_extra_system+fire_purchase_extra_system></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(fire_amount_sb)# <cfset total_fire_amount_sb=total_fire_amount_sb+fire_amount_sb></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(fire_purchase_net_system_sb)# <cfset total_fire_purchase_net_system_sb=total_fire_purchase_net_system_sb+fire_purchase_net_system_sb></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(fire_purchase_extra_system_sb)# <cfset total_fire_purchase_extra_system_sb=total_fire_purchase_extra_system_sb+fire_purchase_extra_system_sb></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(fire_amount+fire_amount_sb)# <cfset total_fire_amount_with_sb=total_fire_amount_with_sb+fire_amount+fire_amount_sb></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(fire_purchase_net_system+fire_purchase_net_system_sb+fire_purchase_extra_system+fire_purchase_extra_system_sb)#</td>
                                                <cfset total_fire_cost=total_fire_cost+fire_purchase_net_system+fire_purchase_net_system_sb+fire_purchase_extra_system+fire_purchase_extra_system_sb>
                                            </cfif>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            <cfelse>
                                <tr>
                                    <td colspan="40"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                                </tr>
                            </cfif>
                        </tbody>
                        <cfif isdefined('attributes.ajax')><!--- Kümülatif raporlar oluşturuluyorsa! --->
                            <script type="text/javascript">
                                user_info_show_div(1,1,1);
                            </script>
                            <cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
                                UPDATE 
                                    REPORT_SYSTEM 
                                SET 
                                    PROCESS_FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                    PROCESS_ROW_COUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#row#">
                                WHERE 
                                    REPORT_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCTION_MONTH"> AND
                                    PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#"> AND 
                                    PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_month#"> AND 
                                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_our_company_id#">
                            </cfquery>
                            <cfabort>
                        </cfif>    
                        <cfif not isdefined('attributes.ajax')><!--- Kümülatif raporsa alt toplamlarla işimiz yok... --->
                            <tfoot>
                                <cfoutput>
                                    <cfif GET_PRODUCTION.recordcount>
                                        <tr>
                                            <cfif attributes.report_type eq 11>
                                                <td></td>
                                            </cfif>
                                            <cfif attributes.report_type eq 12>
                                                <td></td>
                                            </cfif>
                                            <cfif listfind('1,2,4,7,9,11,12',attributes.report_type)>
                                                <td></td>
                                            </cfif>
                                            <cfif  listfind('1,2,4,7,9,11,12',attributes.report_type)>
                                                <td></td>
                                            </cfif>
                                            <td></td>
                                            <cfif attributes.report_type eq 8>
                                                <cfset colspan_= 2>  
                                                <cfset align_="right">
                                            <cfelse>
                                                <cfset colspan_= 1>
                                                <cfset align_="left">
                                            </cfif>
                                            <cfif ( listfind('1,2,4,7,9,11,12',attributes.report_type)) and xml_show_manufact_code>
                                                <td></td>
                                            </cfif>
                                            <td colspan="#colspan_#" align="#align_#" class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam '></td>
                                            <cfif listfind(attributes.is_view,0,',')>
                                                <td></td>
                                                <td align="right" style="text-align:right;" format="numeric">
                                                    <cfloop query="get_product_units">
                                                        <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                        <cfif evaluate('toplam_sonuc_#unit_#') gt 0>#TLFormat(wrk_round(evaluate('toplam_sonuc_#unit_#'),8,1),8)# #get_product_units.unit#<br/></cfif>
                                                    </cfloop>
                                                </td>
                                                <cfif isdefined("attributes.is_order_amount")>
                                                    <td align="right" style="text-align:right;" format="numeric">
                                                        <cfloop query="get_product_units">
                                                            <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                            <cfif evaluate('toplam_emir_#unit_#') gt 0>
                                                                #Tlformat(evaluate('toplam_emir_#unit_#'))# #get_product_units.unit#<br/>
                                                            </cfif>
                                                        </cfloop>
                                                    </td>
                                                </cfif>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_production_result_minute)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">
                                                <cfloop query="get_product_units">
                                                    <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                    <cfif evaluate('toplam_sonuc_miktar#unit_#') gt 0>#TLFormat(wrk_round(evaluate('toplam_sonuc_miktar#unit_#'),8,1),8)# #get_product_units.unit#<br/></cfif>
                                                </cfloop>
                                                </td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_prod_purchase_net)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_prod_purchase_extra_system)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_station_cost)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_prod_station_reflection_cost_system)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_cost_all)#</td>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,1,',')>
                                                <td></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(total_sarf_amount,8,1),8)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_sarf_purchase_net_system)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_sarf_purchase_extra_system)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_sarf_amount_sb)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_sarf_purchase_net_system_sb)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_sarf_purchase_extra_system_sb)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_sarf_amount+total_sarf_amount_sb)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_sarf_cost)#</td>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,3,',')>
                                                <td></td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(total_fire_amount,8,1),8)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_fire_purchase_net_system)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_fire_purchase_extra_system)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_fire_amount_sb)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_fire_purchase_net_system_sb)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_fire_purchase_extra_system_sb)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_fire_amount+total_fire_amount_sb)#</td>
                                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_sarf_cost)#</td>
                                            </cfif>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </tfoot>
                        </cfif>
                    <cfelse>
                        <tbody>
                            <cfif attributes.report_type eq 11>
                                <cfif GET_PRODUCTION.recordcount>
                                    <cfquery name="get_production__" dbtype="query">
                                        SELECT
                                            SUM(PR_MINUTE) AS TOTAL_MINUTE,
                                            SUM(SONUC) AS TOTAL_RESULT_COUNT,
                                            SUM(AMOUNT) TOTAL_AMOUNT,
                                            SUM(QUANTITY) TOTAL_QUANTITY,
                                            SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                            SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                            SUM(STATION_REFLECTION_COST_SYSTEM*AMOUNT) STATION_REFLECTION_COST_SYSTEM,
                                            SUM(STATION_COST_VALUE*AMOUNT) STATION_COST_VALUE,
                                            STATION_ID,
                                            STATION_NAME,
                                            STOCK_ID,
                                            PRODUCT_ID,
                                            PRODUCT_NAME,
                                            STOCK_CODE,
                                            <cfif xml_show_manufact_code>MANUFACT_CODE,</cfif>
                                            UNIT_NAME,
                                            UNIT_ID,
                                            UNIT
                                        FROM
                                            GET_PRODUCTION
                                        GROUP BY
                                            STATION_ID,
                                            STATION_NAME,
                                            STOCK_ID,
                                            PRODUCT_ID,
                                            PRODUCT_NAME,
                                            STOCK_CODE,
                                            <cfif xml_show_manufact_code>MANUFACT_CODE,</cfif>
                                            UNIT_NAME,
                                            UNIT_ID,
                                            UNIT
                                        ORDER BY 
                                            STATION_ID,
                                            PRODUCT_ID
                                    </cfquery>
                                    <cfset count = 1>
                                    <cfset attributes.totalrecords = get_production__.recordcount>
                                    <cfif attributes.page neq 1>
                                        <cfloop query="get_production__" startrow="1" endrow="#attributes.startrow-1#">
                                            <cfif len(UNIT)>
                                                <cfset row_unit_ = filterSpecialChars(UNIT)>
                                            <cfelse>
                                                <cfset row_unit_ = "">
                                            </cfif>
                                            <cfif listfind(attributes.is_view,0,',')>
                                                <cfquery name="GET_K_PROD_ORDER" dbtype="query">
                                                    SELECT
                                                        DISTINCT STOCK_ID,
                                                        STATION_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=1
                                                        AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                </cfquery>
                                                    <cfset 'prod_quantity_#STATION_ID#'=0>
                                                <cfloop query="GET_K_PROD_ORDER">
                                                    <cfif isdefined("new_amount_#STOCK_ID#")>
                                                        <cfset 'prod_quantity_#station_id#' = evaluate('prod_quantity_#station_id#') + evaluate("new_amount_#STOCK_ID#")>
                                                    </cfif>
                                                </cfloop>
                                                <cfquery name="GET_K_PROD" dbtype="query">
                                                    SELECT
                                                        SUM(PR_MINUTE) AS TOTAL_MINUTE,
                                                        SUM(SONUC) AS TOTAL_RESULT_COUNT,
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(QUANTITY) TOTAL_QUANTITY,
                                                        SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        SUM(STATION_REFLECTION_COST_SYSTEM*AMOUNT) STATION_REFLECTION_COST_SYSTEM,
                                                        SUM(STATION_COST_VALUE*AMOUNT) STATION_COST_VALUE,
                                                        STATION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=1
                                                        AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        STATION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    "prod_amount_#station_id#"=0;
                                                    "prod_purchase_net_system_#station_id#"=0;
                                                    "prod_purchase_extra_system_#station_id#"=0;
                                                    "prod_station_cost_#station_id#"=0;
                                                    "prod_reflection_cost_#station_id#"=0;
                                                    "prod_station_minute_#station_id#"=0;
                                                    "prod_station_result_#station_id#"=0;
                                                    if(GET_K_PROD.RECORDCOUNT)
                                                    {
                                                        for(prod_rw=1;prod_rw lte GET_K_PROD.RECORDCOUNT;prod_rw=prod_rw+1)
                                                        {
                                                            if(len(GET_K_PROD.TOTAL_AMOUNT[prod_rw])) 'prod_amount_#GET_K_PROD.STATION_ID#' = evaluate('prod_amount_#GET_K_PROD.STATION_ID#')+GET_K_PROD.TOTAL_AMOUNT[prod_rw]; else GET_K_PROD.TOTAL_AMOUNT[prod_rw]=0;
                                                            if(len(GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw])) 'prod_purchase_net_system_#GET_K_PROD.STATION_ID#'=evaluate('prod_purchase_net_system_#GET_K_PROD.STATION_ID#')+GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw];
                                                            if(len(GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw])) 'prod_purchase_net_system_#GET_K_PROD.STATION_ID#'=evaluate('prod_purchase_net_system_#GET_K_PROD.STATION_ID#')+GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw];
                                                            if(len(GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw])) 'prod_reflection_cost_#GET_K_PROD.STATION_ID#'=evaluate('prod_reflection_cost_#GET_K_PROD.STATION_ID#')+GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw];
                                                            if(len(GET_K_PROD.STATION_COST_VALUE[prod_rw])) 'prod_station_cost_#GET_K_PROD.STATION_ID#'=evaluate('prod_station_cost_#GET_K_PROD.STATION_ID#')+GET_K_PROD.STATION_COST_VALUE[prod_rw];
                                                            if(len(GET_K_PROD.TOTAL_MINUTE[prod_rw])) 'prod_station_minute_#GET_K_PROD.STATION_ID#'=evaluate('prod_station_minute_#GET_K_PROD.STATION_ID#')+GET_K_PROD.TOTAL_MINUTE[prod_rw]; else GET_K_PROD.TOTAL_MINUTE[prod_rw]=0;
                                                            if(len(GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw])) 'prod_station_result_#GET_K_PROD.STATION_ID#'=evaluate('prod_station_result_#GET_K_PROD.STATION_ID#')+GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]; else GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]=0;
                                                        }
                                                    }
                                                </cfscript>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,1,',')>
                                                <cfquery name="GET_K_SARF" dbtype="query">
                                                    SELECT 
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        STATION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=2
                                                        AND IS_SEVKIYAT=0
                                                        AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        STATION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    "sarf_amount_#station_id#"=0;
                                                    "sarf_purchase_net_system_#station_id#"=0;
                                                    "sarf_purchase_extra_system_#station_id#"=0;
                                                    if(GET_K_SARF.RECORDCOUNT)
                                                    {
                                                        for(sarf_rw=1;sarf_rw lte GET_K_SARF.RECORDCOUNT;sarf_rw=sarf_rw+1)
                                                        {
                                                            if(len(GET_K_SARF.TOTAL_AMOUNT[sarf_rw])) "sarf_amount_#GET_K_SARF.station_id#"=evaluate("sarf_amount_#GET_K_SARF.station_id#")+GET_K_SARF.TOTAL_AMOUNT[sarf_rw]; else GET_K_SARF.TOTAL_AMOUNT[sarf_rw]=0;
                                                            if(len(GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw])) "sarf_purchase_net_system_#GET_K_SARF.station_id#"=evaluate("sarf_purchase_net_system_#GET_K_SARF.station_id#")+GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw];
                                                            if(len(GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw])) "sarf_purchase_extra_system_#GET_K_SARF.station_id#"=evaluate("sarf_purchase_extra_system_#GET_K_SARF.station_id#")+GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw];
                                                        }
                                                    }
                                                </cfscript>
                                                <cfquery name="GET_K_SARF_SB" dbtype="query">
                                                    SELECT 
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        STATION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=2
                                                        AND IS_SEVKIYAT=1
                                                        AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        STATION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    "sarf_amount_sb_#station_id#"=0;
                                                    "sarf_purchase_net_system_sb_#station_id#"=0;
                                                    "sarf_purchase_extra_system_sb_#station_id#"=0;
                                                    if(GET_K_SARF_SB.RECORDCOUNT)
                                                    {
                                                        for(sarf_sb_rw=1;sarf_sb_rw lte GET_K_SARF_SB.RECORDCOUNT;sarf_sb_rw=sarf_sb_rw+1)
                                                        {
                                                            if(len(GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw])) "sarf_amount_sb_#GET_K_SARF_SB.STATION_ID#"=evaluate("sarf_amount_sb_#GET_K_SARF_SB.STATION_ID#")+GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]; else GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]=0;
                                                            if(len(GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw])) "sarf_purchase_net_system_sb_#GET_K_SARF_SB.STATION_ID#"=evaluate("sarf_purchase_net_system_sb_#GET_K_SARF_SB.STATION_ID#")+GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                            if(len(GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw])) "sarf_purchase_extra_system_sb_#GET_K_SARF_SB.STATION_ID#"=evaluate("sarf_purchase_extra_system_sb_#GET_K_SARF_SB.STATION_ID#")+GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                        }
                                                    }
                                                </cfscript>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,3,',')>
                                                <cfquery name="GET_K_FIRE" dbtype="query">
                                                    SELECT 
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        STATION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=3
                                                        AND IS_SEVKIYAT=0
                                                        AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        STATION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    'fire_amount_#station_id#'=0;
                                                    'fire_purchase_net_system_#station_id#'=0;
                                                    'fire_purchase_extra_system_#station_id#'=0;
                                                    if(GET_K_FIRE.RECORDCOUNT)
                                                    {
                                                        for(fire_rw=1;fire_rw lte GET_K_FIRE.RECORDCOUNT;fire_rw=fire_rw+1)
                                                        {
                                                            if(len(GET_K_FIRE.TOTAL_AMOUNT[fire_rw])) 'fire_amount_#GET_K_FIRE.station_id#'=evaluate('fire_amount_#GET_K_FIRE.station_id#')+GET_K_FIRE.TOTAL_AMOUNT[fire_rw]; else GET_K_FIRE.TOTAL_AMOUNT[fire_rw]=0;
                                                            if(len(GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw])) 'fire_purchase_net_system_#GET_K_FIRE.station_id#'=evaluate('fire_purchase_net_system_#GET_K_FIRE.station_id#')+GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                            if(len(GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw])) 'fire_purchase_extra_system_#GET_K_FIRE.station_id#'=evaluate('fire_purchase_extra_system_#GET_K_FIRE.station_id#')+GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                        }
                                                    }
                                                </cfscript>
                                                <cfquery name="GET_K_FIRE_SB" dbtype="query">
                                                    SELECT 
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        STATION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                                                        AND IS_SEVKIYAT = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                                                        AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        STATION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    'fire_amount_sb_#station_id#'=0;
                                                    'fire_purchase_net_system_sb_#station_id#'=0;
                                                    'fire_purchase_extra_system_sb_#station_id#'=0;
                                                    if(GET_K_FIRE_SB.RECORDCOUNT)
                                                    {
                                                        for(fire_sb_rw=1;fire_sb_rw lte GET_K_FIRE_SB.RECORDCOUNT;fire_sb_rw=fire_sb_rw+1)
                                                        {
                                                            if(len(GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw])) 'fire_amount_sb_#GET_K_FIRE_SB.station_id#'=evaluate('fire_amount_sb_#GET_K_FIRE_SB.station_id#')+GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]; else GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]=0;
                                                            if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw])) 'fire_purchase_net_system_sb_#GET_K_FIRE_SB.station_id#'=evaluate('fire_purchase_net_system_sb_#GET_K_FIRE_SB.station_id#')+GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                            if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw])) 'fire_purchase_extra_system_sb_#GET_K_FIRE_SB.station_id#'=evaluate('fire_purchase_extra_system_sb_#GET_K_FIRE_SB.station_id#')+GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                        }
                                                    }
                                                </cfscript>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,0,',')>
                                                <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_sonuc_#station_id#_#row_unit_#" = wrk_round(evaluate('prod_station_result_#station_id#'),8,1) + evaluate("toplam_sonuc_#station_id#_#row_unit_#")></cfif>
                                                <cfif isdefined("attributes.is_order_amount")>
                                                    <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_emir_#station_id#_#row_unit_#" = evaluate('prod_quantity_#station_id#') + evaluate("toplam_emir_#station_id#_#row_unit_#")></cfif>
                                                </cfif>
                                                <cfset 'total_production_result_minute_#station_id#'=evaluate('total_production_result_minute_#station_id#')+evaluate('prod_station_minute_#station_id#')>
                                                <cfset 'total_prod_amount_#station_id#'=evaluate('total_prod_amount_#station_id#')+evaluate('prod_amount_#station_id#')>
                                                <cfset 'total_prod_purchase_net_#station_id#'=evaluate('total_prod_purchase_net_#station_id#')+evaluate('prod_purchase_net_system_#station_id#')>
                                                <cfset 'total_prod_purchase_extra_system_#station_id#'=evaluate('total_prod_purchase_extra_system_#station_id#')+evaluate('prod_purchase_extra_system_#station_id#')>
                                                <cfset 'total_station_cost_#station_id#'=evaluate('total_station_cost_#station_id#')+evaluate('prod_station_cost_#station_id#')>
                                                <cfset 'total_prod_station_reflection_cost_system_#station_id#'=evaluate('total_prod_station_reflection_cost_system_#station_id#')+evaluate('prod_reflection_cost_#station_id#')>
                                                <cfset 'total_cost_all_#station_id#' = evaluate('total_cost_all_#station_id#') + ((evaluate('prod_reflection_cost_#station_id#')+evaluate('prod_purchase_net_system_#station_id#')+evaluate('prod_purchase_extra_system_#station_id#')+evaluate('prod_station_cost_#station_id#')))>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,1,',')>
                                                <cfset 'total_sarf_amount_#station_id#'=evaluate('total_sarf_amount_#station_id#')+wrk_round(evaluate('sarf_amount_#station_id#'),8,1)>
                                                <cfset 'total_sarf_purchase_net_system_#station_id#'=evaluate('total_sarf_purchase_net_system_#station_id#')+evaluate('sarf_purchase_net_system_#station_id#')>
                                                <cfset 'total_sarf_purchase_extra_system_#station_id#'=evaluate('total_sarf_purchase_extra_system_#station_id#')+evaluate('sarf_purchase_extra_system_#station_id#')>
                                                <cfset 'total_sarf_amount_sb_#station_id#'=evaluate('total_sarf_amount_sb_#station_id#')+evaluate('sarf_amount_sb_#station_id#')>
                                                <cfset 'total_sarf_purchase_net_system_sb_#station_id#'=evaluate('total_sarf_purchase_net_system_sb_#station_id#')+evaluate('sarf_purchase_net_system_sb_#station_id#')>
                                                <cfset 'total_sarf_purchase_extra_system_sb_#station_id#'=evaluate('total_sarf_purchase_extra_system_sb_#station_id#')+evaluate('sarf_purchase_extra_system_sb_#station_id#')>
                                                <cfset 'total_sarf_amount_with_sb_#station_id#'=evaluate('total_sarf_amount_with_sb_#station_id#')+evaluate('sarf_amount_#station_id#')+evaluate('sarf_amount_sb_#station_id#')>
                                                <cfset 'total_sarf_cost_#station_id#'=evaluate('total_sarf_cost_#station_id#')+evaluate('sarf_purchase_net_system_#station_id#')+evaluate('sarf_purchase_net_system_sb_#station_id#')+evaluate('sarf_purchase_extra_system_#station_id#')+evaluate('sarf_purchase_extra_system_sb_#station_id#')>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,3,',')>
                                                <cfset 'total_fire_amount_#station_id#'=evaluate('total_fire_amount_#station_id#')+wrk_round(evaluate('fire_amount_#station_id#'),8,1)>
                                                <cfset 'total_fire_purchase_net_system_#station_id#'=evaluate('total_fire_purchase_net_system_#station_id#')+evaluate('fire_purchase_net_system_#station_id#')>
                                                <cfset 'total_fire_purchase_extra_system_#station_id#'=evaluate('total_fire_purchase_extra_system_#station_id#')+evaluate('fire_purchase_extra_system_#station_id#')>
                                                <cfset 'total_fire_amount_sb_#station_id#'=evaluate('total_fire_amount_sb_#station_id#')+evaluate('fire_amount_sb_#station_id#')>
                                                <cfset 'total_fire_purchase_net_system_sb_#station_id#'=evaluate('total_fire_purchase_net_system_sb_#station_id#')+evaluate('fire_purchase_net_system_sb_#station_id#')>
                                                <cfset 'total_fire_purchase_extra_system_sb_#station_id#'=evaluate('total_fire_purchase_extra_system_sb_#station_id#')+evaluate('fire_purchase_extra_system_sb_#station_id#')>
                                                <cfset 'total_fire_amount_with_sb_#station_id#'=evaluate('total_fire_amount_with_sb_#station_id#')+evaluate('fire_amount_#station_id#')+evaluate('fire_amount_sb_#station_id#')>
                                                <cfset 'total_fire_cost_#station_id#'=evaluate('total_fire_cost_#station_id#')+evaluate('fire_purchase_net_system_#station_id#')+evaluate('fire_purchase_net_system_sb_#station_id#')+evaluate('fire_purchase_extra_system_#station_id#')+evaluate('fire_purchase_extra_system_sb_#station_id#')>
                                            </cfif>
                                        </cfloop>
                                    </cfif>	
                                    <cfoutput query="get_production__" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                        <cfset count++> 
                                        <cfif listfind(attributes.is_view,0,',')>
                                            <cfquery name="GET_K_PROD_ORDER" dbtype="query">
                                                SELECT
                                                    DISTINCT STOCK_ID,
                                                    STATION_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=1
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                            </cfquery>
                                            <cfset 'prod_quantity_#STATION_ID#' = 0>
                                            <cfloop query="GET_K_PROD_ORDER">
                                                <cfif isdefined("new_amount_#STOCK_ID#")>
                                                    <cfset 'prod_quantity_#STATION_ID#' = evaluate('prod_quantity_#station_id#') + evaluate("new_amount_#STOCK_ID#")>
                                                </cfif>
                                            </cfloop>
                                            <cfquery name="GET_K_PROD" dbtype="query">
                                                SELECT
                                                    SUM(PR_MINUTE) AS TOTAL_MINUTE,
                                                    SUM(SONUC) AS TOTAL_RESULT_COUNT,
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(QUANTITY) TOTAL_QUANTITY,
                                                    SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    SUM(STATION_REFLECTION_COST_SYSTEM*AMOUNT) STATION_REFLECTION_COST_SYSTEM,
                                                    SUM(STATION_COST_VALUE*AMOUNT) STATION_COST_VALUE,
                                                    STATION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=1
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    STATION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                'prod_amount_#station_id#'=0;
                                                'prod_purchase_net_system_#station_id#'=0;
                                                'prod_purchase_extra_system_#station_id#'=0;
                                                'prod_station_cost_#station_id#'=0;
                                                'prod_reflection_cost_#station_id#'=0;
                                                'prod_station_minute_#station_id#'=0;
                                                'prod_station_result_#station_id#'=0;
                                                if(GET_K_PROD.RECORDCOUNT)
                                                {
                                                    for(prod_rw=1;prod_rw lte GET_K_PROD.RECORDCOUNT;prod_rw=prod_rw+1)
                                                    {
                                                        if(len(GET_K_PROD.TOTAL_AMOUNT[prod_rw])) 'prod_amount_#GET_K_PROD.station_id#'=evaluate('prod_amount_#GET_K_PROD.station_id#')+GET_K_PROD.TOTAL_AMOUNT[prod_rw]; else GET_K_PROD.TOTAL_AMOUNT[prod_rw]=0;
                                                        if(len(GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw])) 'prod_purchase_net_system_#GET_K_PROD.station_id#'=evaluate('prod_purchase_net_system_#GET_K_PROD.station_id#')+GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw];
                                                        if(len(GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw])) 'prod_purchase_net_system_#GET_K_PROD.station_id#'=evaluate('prod_purchase_net_system_#GET_K_PROD.station_id#')+GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw];
                                                        if(len(GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw])) 'prod_reflection_cost_#GET_K_PROD.station_id#'=evaluate('prod_reflection_cost_#GET_K_PROD.station_id#')+GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw];
                                                        if(len(GET_K_PROD.STATION_COST_VALUE[prod_rw])) 'prod_station_cost_#GET_K_PROD.station_id#'=evaluate('prod_station_cost_#GET_K_PROD.station_id#')+GET_K_PROD.STATION_COST_VALUE[prod_rw];
                                                        if(len(GET_K_PROD.TOTAL_MINUTE[prod_rw])) 'prod_station_minute_#GET_K_PROD.station_id#'=evaluate('prod_station_minute_#GET_K_PROD.station_id#')+GET_K_PROD.TOTAL_MINUTE[prod_rw]; else GET_K_PROD.TOTAL_MINUTE[prod_rw]=0;
                                                        if(len(GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw])) 'prod_station_result_#GET_K_PROD.station_id#'=evaluate('prod_station_result_#GET_K_PROD.station_id#')+GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]; else GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]=0;
                                                    }
                                                }
                                            </cfscript>
                                        </cfif>
                                        <cfif listfind(attributes.is_view,1,',')>
                                            <cfquery name="GET_K_SARF" dbtype="query">
                                                SELECT 
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    STATION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=2
                                                    AND IS_SEVKIYAT=0
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    STATION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                "sarf_amount_#station_id#"=0;
                                                "sarf_purchase_net_system_#station_id#"=0;
                                                "sarf_purchase_extra_system_#station_id#"=0;
                                                if(GET_K_SARF.RECORDCOUNT)
                                                {
                                                    for(sarf_rw=1;sarf_rw lte GET_K_SARF.RECORDCOUNT;sarf_rw=sarf_rw+1)
                                                    {
                                                        if(len(GET_K_SARF.TOTAL_AMOUNT[sarf_rw])) "sarf_amount_#GET_K_SARF.station_id#"=evaluate("sarf_amount_#GET_K_SARF.station_id#")+GET_K_SARF.TOTAL_AMOUNT[sarf_rw]; else GET_K_SARF.TOTAL_AMOUNT[sarf_rw]=0;
                                                        if(len(GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw])) "sarf_purchase_net_system_#GET_K_SARF.station_id#"=evaluate("sarf_purchase_net_system_#GET_K_SARF.station_id#")+GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw];
                                                        if(len(GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw])) "sarf_purchase_extra_system_#GET_K_SARF.station_id#"=evaluate("sarf_purchase_extra_system_#GET_K_SARF.station_id#")+GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw];
                                                    }
                                                }
                                            </cfscript>
                                            <cfquery name="GET_K_SARF_SB" dbtype="query">
                                                SELECT 
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    STATION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=2
                                                    AND IS_SEVKIYAT=1
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    STATION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                "sarf_amount_sb_#STATION_ID#"=0;
                                                "sarf_purchase_net_system_sb_#STATION_ID#"=0;
                                                "sarf_purchase_extra_system_sb_#STATION_ID#"=0;
                                                if(GET_K_SARF_SB.RECORDCOUNT)
                                                {
                                                    for(sarf_sb_rw=1;sarf_sb_rw lte GET_K_SARF_SB.RECORDCOUNT;sarf_sb_rw=sarf_sb_rw+1)
                                                    {
                                                        if(len(GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw])) "sarf_amount_sb_#GET_K_SARF_SB.STATION_ID#"=evaluate("sarf_amount_sb_#GET_K_SARF_SB.STATION_ID#")+GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]; else GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]=0;
                                                        if(len(GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw])) "sarf_purchase_net_system_sb_#GET_K_SARF_SB.STATION_ID#"=evaluate("sarf_purchase_net_system_sb_#GET_K_SARF_SB.STATION_ID#")+GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                        if(len(GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw])) "sarf_purchase_extra_system_sb_#GET_K_SARF_SB.STATION_ID#"=evaluate("sarf_purchase_extra_system_sb_#GET_K_SARF_SB.STATION_ID#")+GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                    }
                                                }
                                            </cfscript>
                                        </cfif>
                                        <cfif listfind(attributes.is_view,3,',')>
                                            <cfquery name="GET_K_FIRE" dbtype="query">
                                                SELECT 
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    STATION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=3
                                                    AND IS_SEVKIYAT=0
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    STATION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                'fire_amount_#station_id#'=0;
                                                'fire_purchase_net_system_#station_id#'=0;
                                                'fire_purchase_extra_system_#station_id#'=0;
                                                if(GET_K_FIRE.RECORDCOUNT)
                                                {
                                                    for(fire_rw=1;fire_rw lte GET_K_FIRE.RECORDCOUNT;fire_rw=fire_rw+1)
                                                    {
                                                        if(len(GET_K_FIRE.TOTAL_AMOUNT[fire_rw])) 'fire_amount_#GET_K_FIRE.station_id#'=evaluate('fire_amount_#GET_K_FIRE.station_id#')+GET_K_FIRE.TOTAL_AMOUNT[fire_rw]; else GET_K_FIRE.TOTAL_AMOUNT[fire_rw]=0;
                                                        if(len(GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw])) 'fire_purchase_net_system_#GET_K_FIRE.station_id#'=evaluate('fire_purchase_net_system_#GET_K_FIRE.station_id#')+GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                        if(len(GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw])) 'fire_purchase_extra_system_#GET_K_FIRE.station_id#'=evaluate('fire_purchase_extra_system_#GET_K_FIRE.station_id#')+GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                    }
                                                }
                                            </cfscript>
                                            <cfquery name="GET_K_FIRE_SB" dbtype="query">
                                                SELECT 
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    STATION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                                                    AND IS_SEVKIYAT = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                                                    AND STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STATION_ID#">
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    STATION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                'fire_amount_sb_#station_id#'=0;
                                                'fire_purchase_net_system_sb_#station_id#'=0;
                                                'fire_purchase_extra_system_sb_#station_id#'=0;
                                                if(GET_K_FIRE_SB.RECORDCOUNT)
                                                {
                                                    for(fire_sb_rw=1;fire_sb_rw lte GET_K_FIRE_SB.RECORDCOUNT;fire_sb_rw=fire_sb_rw+1)
                                                    {
                                                        if(len(GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw])) 'fire_amount_sb_#GET_K_FIRE_SB.station_id#'=evaluate('fire_amount_sb_#GET_K_FIRE_SB.station_id#')+GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]; else GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]=0;
                                                        if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw])) 'fire_purchase_net_system_sb_#GET_K_FIRE_SB.station_id#'=evaluate('fire_purchase_net_system_sb_#GET_K_FIRE_SB.station_id#')+GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                        if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw])) 'fire_purchase_extra_system_sb_#GET_K_FIRE_SB.station_id#'=evaluate('fire_purchase_extra_system_sb_#GET_K_FIRE_SB.station_id#')+GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                    }
                                                }
                                            </cfscript>
                                        </cfif>
                                        <cfif isdefined('attributes.ajax')><!--- Kümülatif raporlar oluşturuluyorsa! --->
                                            <cfinclude template="../../settings/cumulative/cumulative_production_analyse_inc.cfm">
                                        <cfelse>
                                            <tr>
                                                <td>#currentrow#</td>
                                                <td><cfif len(STATION_ID)>#STATION_NAME#</cfif></td>
                                                <td>#STOCK_CODE#</td>
                                                <td>#PRODUCT_NAME#</td>
                                                <cfif xml_show_manufact_code>
                                                    <td style="mso-number-format:\@;">
                                                        #manufact_code#
                                                    </td>
                                                </cfif>
                                                <td>
                                                    <cfif len(UNIT)>
                                                        #UNIT#
                                                        <cfset row_unit_ = filterSpecialChars(UNIT)>
                                                    <cfelse>
                                                        <cfset row_unit_ = "">
                                                    </cfif>
                                                </td>
                                                <cfif listfind(attributes.is_view,0,',')>
                                                    <td></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('prod_station_result_#station_id#'),8,1),8)#
                                                        <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_sonuc_#station_id#_#row_unit_#" = wrk_round(evaluate('prod_station_result_#station_id#'),8,1) + evaluate("toplam_sonuc_#station_id#_#row_unit_#")></cfif>
                                                    </td>
                                                    <cfif isdefined("attributes.is_order_amount")>
                                                        <td align="right" style="text-align:right;" format="numeric">#tlformat(evaluate('prod_quantity_#station_id#'))#
                                                            <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_emir_#station_id#_#row_unit_#" = evaluate('prod_quantity_#station_id#') + evaluate("toplam_emir_#station_id#_#row_unit_#")></cfif>
                                                        </td>
                                                    </cfif>
                                                    <td align="right" style="text-align:right;" format="numeric">#tlformat(evaluate('prod_station_minute_#station_id#'))#<cfset 'total_production_result_minute_#station_id#'=evaluate('total_production_result_minute_#station_id#')+evaluate('prod_station_minute_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_amount_#station_id#'))# <cfset 'total_prod_amount_#station_id#'=evaluate('total_prod_amount_#station_id#')+evaluate('prod_amount_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_purchase_net_system_#station_id#'))# <cfset 'total_prod_purchase_net_#station_id#'=evaluate('total_prod_purchase_net_#station_id#')+ evaluate('prod_purchase_net_system_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_purchase_extra_system_#station_id#'))# <cfset 'total_prod_purchase_extra_system_#station_id#'=evaluate('total_prod_purchase_extra_system_#station_id#')+ evaluate('prod_purchase_extra_system_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_station_cost_#station_id#'))# <cfset 'total_station_cost_#station_id#'=evaluate('total_station_cost_#station_id#')+ evaluate('prod_station_cost_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_reflection_cost_#station_id#'))#</td><cfset 'total_prod_station_reflection_cost_system_#station_id#'=evaluate('total_prod_station_reflection_cost_system_#station_id#')+ evaluate('prod_reflection_cost_#station_id#')>
                                                    <td align="right" style="text-align:right;" format="numeric">
                                                        #TLFormat((evaluate('prod_reflection_cost_#station_id#')+evaluate('prod_purchase_net_system_#station_id#')+evaluate('prod_purchase_extra_system_#station_id#')+evaluate('prod_station_cost_#station_id#')))#
                                                        <cfset 'total_cost_all_#station_id#' = evaluate('total_cost_all_#station_id#') + ((evaluate('prod_reflection_cost_#station_id#')+evaluate('prod_purchase_net_system_#station_id#')+evaluate('prod_purchase_extra_system_#station_id#')+evaluate('prod_station_cost_#station_id#')))>
                                                    </td>
                                                </cfif>
                                                <cfif listfind(attributes.is_view,1,',')>
                                                    <td></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('sarf_amount_#station_id#'),8,1),8)# <cfset 'total_sarf_amount_#station_id#'=evaluate('total_sarf_amount_#station_id#')+wrk_round(evaluate('sarf_amount_#station_id#'),8,1)></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_net_system_#station_id#'))# <cfset 'total_sarf_purchase_net_system_#station_id#'=evaluate('total_sarf_purchase_net_system_#station_id#')+evaluate('sarf_purchase_net_system_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_extra_system_#station_id#'))# <cfset 'total_sarf_purchase_extra_system_#station_id#'=evaluate('total_sarf_purchase_extra_system_#station_id#')+evaluate('sarf_purchase_extra_system_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_amount_sb_#station_id#'))# <cfset 'total_sarf_amount_sb_#station_id#'=evaluate('total_sarf_amount_sb_#station_id#')+evaluate('sarf_amount_sb_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_net_system_sb_#station_id#'))# <cfset 'total_sarf_purchase_net_system_sb_#station_id#'=evaluate('total_sarf_purchase_net_system_sb_#station_id#')+evaluate('sarf_purchase_net_system_sb_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_extra_system_sb_#station_id#'))# <cfset 'total_sarf_purchase_extra_system_sb_#station_id#'=evaluate('total_sarf_purchase_extra_system_sb_#station_id#')+evaluate('sarf_purchase_extra_system_sb_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_amount_#station_id#')+evaluate('sarf_amount_sb_#station_id#'))# <cfset 'total_sarf_amount_with_sb_#station_id#'=evaluate('total_sarf_amount_with_sb_#station_id#')+evaluate('sarf_amount_#station_id#')+evaluate('sarf_amount_sb_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_net_system_#station_id#')+evaluate('sarf_purchase_net_system_sb_#station_id#')+evaluate('sarf_purchase_extra_system_#station_id#')+evaluate('sarf_purchase_extra_system_sb_#station_id#'))#</td>
                                                    <cfset 'total_sarf_cost_#station_id#' = evaluate('total_sarf_cost_#station_id#')+evaluate('sarf_purchase_net_system_#station_id#')+evaluate('sarf_purchase_net_system_sb_#station_id#')+evaluate('sarf_purchase_extra_system_#station_id#')+evaluate('sarf_purchase_extra_system_sb_#station_id#')>
                                                </cfif>
                                                <cfif listfind(attributes.is_view,3,',')>
                                                    <td></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('fire_amount_#station_id#'),8,1),8)# <cfset 'total_fire_amount_#station_id#'=evaluate('total_fire_amount_#station_id#')+wrk_round(evaluate('fire_amount_#station_id#'),8,1)></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_net_system_#station_id#'))# <cfset 'total_fire_purchase_net_system_#station_id#'=evaluate('total_fire_purchase_net_system_#station_id#')+evaluate('fire_purchase_net_system_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_extra_system_#station_id#'))# <cfset 'total_fire_purchase_extra_system_#station_id#'=evaluate('total_fire_purchase_extra_system_#station_id#')+evaluate('fire_purchase_extra_system_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_amount_sb_#station_id#'))# <cfset 'total_fire_amount_sb_#station_id#'=evaluate('total_fire_amount_sb_#station_id#')+evaluate('fire_amount_sb_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_net_system_sb_#station_id#'))# <cfset 'total_fire_purchase_net_system_sb_#station_id#'=evaluate('total_fire_purchase_net_system_sb_#station_id#')+evaluate('fire_purchase_net_system_sb_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_extra_system_sb_#station_id#'))# <cfset 'total_fire_purchase_extra_system_sb_#station_id#'=evaluate('total_fire_purchase_extra_system_sb_#station_id#')+evaluate('fire_purchase_extra_system_sb_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_amount_#station_id#')+evaluate('fire_amount_sb_#station_id#'))# <cfset 'total_fire_amount_with_sb_#station_id#'=evaluate('total_fire_amount_with_sb_#station_id#')+evaluate('fire_amount_#station_id#')+evaluate('fire_amount_sb_#station_id#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_net_system_#station_id#')+evaluate('fire_purchase_net_system_sb_#station_id#')+evaluate('fire_purchase_extra_system_#station_id#')+evaluate('fire_purchase_extra_system_sb_#station_id#'))#</td>
                                                    <cfset 'total_fire_cost_#station_id#'=evaluate('total_fire_cost_#station_id#')+evaluate('fire_purchase_net_system_#station_id#')+evaluate('fire_purchase_net_system_sb_#station_id#')+evaluate('fire_purchase_extra_system_#station_id#')+evaluate('fire_purchase_extra_system_sb_#station_id#')>
                                                </cfif>
                                            </tr>
                                            <cfif attributes.report_type eq 11 and station_id[currentrow] neq station_id[currentrow+1]><!--- istasyon bazında toplam --->
                                                <tr>
                                                    <td></td>
                                                    <td></td>
                                                    <td></td>
                                                    <td></td>
                                                    <cfset colspan_= 1>
                                                    <cfset align_="left">
                                                    <cfif xml_show_manufact_code>
                                                        <td></td>
                                                    </cfif>
                                                    <td colspan="#colspan_#" align="#align_#" class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam '></td>
                                                    <cfif listfind(attributes.is_view,0,',')>
                                                        <td></td>
                                                        <td align="right" style="text-align:right;" format="numeric">
                                                            <cfloop query="get_product_units">
                                                                <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                                <cfif evaluate('toplam_sonuc_#get_production__.station_id#_#unit_#') gt 0>#TLFormat(wrk_round(evaluate('toplam_sonuc_#get_production__.station_id#_#unit_#'),8,1),8)# #get_product_units.unit#<br/></cfif>
                                                            </cfloop>
                                                        </td>
                                                        <cfif isdefined("attributes.is_order_amount")>
                                                            <td align="right" style="text-align:right;" format="numeric">
                                                                <cfloop query="get_product_units">
                                                                    <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                                    <cfif evaluate('toplam_emir_#get_production__.station_id#_#unit_#') gt 0>
                                                                        #Tlformat(evaluate('toplam_emir_#get_production__.station_id#_#unit_#'))# #get_product_units.unit#<br/>
                                                                    </cfif>
                                                                </cfloop>
                                                            </td>
                                                        </cfif>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_production_result_minute_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_prod_amount_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_prod_purchase_net_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_prod_purchase_extra_system_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_station_cost_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_prod_station_reflection_cost_system_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_cost_all_#station_id#'))#</td>
                                                    </cfif>
                                                    <cfif listfind(attributes.is_view,1,',')>
                                                        <td></td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('total_sarf_amount_#station_id#'),8,1),8)#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_purchase_net_system_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_purchase_extra_system_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_amount_sb_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_purchase_net_system_sb_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_purchase_extra_system_sb_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_amount_#station_id#')+evaluate('total_sarf_amount_sb_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_cost_#station_id#'))#</td>
                                                    </cfif>
                                                    <cfif listfind(attributes.is_view,3,',')>
                                                        <td></td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('total_fire_amount_#station_id#'),8,1),8)#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_purchase_net_system_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_purchase_extra_system_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_amount_sb_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_purchase_net_system_sb_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_purchase_extra_system_sb_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_amount_#station_id#')+evaluate('total_fire_amount_sb_#station_id#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_cost_#station_id#'))#</td>
                                                    </cfif>
                                                </tr>
                                                <cfscript>
                                                    "total_prod_amount_#station_id#" = 0;
                                                    "total_prod_purchase_net_#station_id#" = 0;
                                                    "total_prod_purchase_extra_system_#station_id#" = 0;
                                                    "total_prod_station_reflection_cost_system_#station_id#" = 0;
                                                    "total_station_cost_#station_id#" = 0;
                                                    "total_sarf_amount_#station_id#" = 0;
                                                    "total_sarf_purchase_net_system_#station_id#" = 0;
                                                    "total_sarf_purchase_extra_system_#station_id#" = 0;
                                                    "total_sarf_amount_sb_#station_id#" = 0;
                                                    "total_sarf_purchase_net_system_sb_#station_id#" = 0;
                                                    "total_sarf_purchase_extra_system_sb_#station_id#" = 0;
                                                    "total_sarf_amount_with_sb_#station_id#" = 0;
                                                    "total_sarf_cost_#station_id#" = 0;
                                                    "total_fire_amount_#station_id#" = 0;
                                                    "total_fire_purchase_net_system_#station_id#" = 0;
                                                    "total_fire_purchase_extra_system_#station_id#" = 0;
                                                    "total_fire_amount_sb_#station_id#" = 0;
                                                    "total_fire_purchase_net_system_sb_#station_id#" = 0;
                                                    "total_fire_purchase_extra_system_sb_#station_id#" = 0;
                                                    "total_fire_amount_with_sb_#station_id#" = 0;
                                                    "total_fire_cost_#station_id#" = 0;
                                                    "total_production_result_count_#station_id#" = 0;
                                                    "total_production_result_minute_#station_id#" = 0;
                                                    "total_cost_all_#station_id#" = 0;
                                                    //"toplam_sonuc_#row_unit_#" = 0;****
                                                </cfscript>
                                                <cfloop query="get_product_units">
                                                    <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                    <cfset 'toplam_sonuc_#get_production__.station_id#_#unit_#' = 0>
                                                    <cfset 'toplam_emir_#get_production__.station_id#_#unit_#' = 0>
                                                </cfloop>
                                            </cfif>
                                        </cfif>
                                    </cfoutput>
                                <cfelse>
                                    <tr>
                                        <td colspan="40"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                                    </tr>
                                </cfif>
                            <cfelseif attributes.report_type eq 12><!---İşlemi Yapan ve Ürün Bazında--->
                                <cfif GET_PRODUCTION.recordcount>
                                    <cfquery name="get_production__" dbtype="query">
                                        SELECT
                                            SUM(PR_MINUTE) AS TOTAL_MINUTE,
                                            SUM(SONUC) AS TOTAL_RESULT_COUNT,
                                            SUM(AMOUNT) TOTAL_AMOUNT,
                                            SUM(QUANTITY) TOTAL_QUANTITY,
                                            SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                            SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                            SUM(STATION_REFLECTION_COST_SYSTEM*AMOUNT) STATION_REFLECTION_COST_SYSTEM,
                                            SUM(STATION_COST_VALUE*AMOUNT) STATION_COST_VALUE,
                                            POSITION_ID,
                                            EMPLOYEE_NAME,
                                            STOCK_ID,
                                            PRODUCT_ID,
                                            PRODUCT_NAME,
                                            STOCK_CODE,
                                            <cfif xml_show_manufact_code>MANUFACT_CODE,</cfif>
                                            UNIT_NAME,
                                            UNIT_ID,
                                            UNIT
                                        FROM
                                            GET_PRODUCTION
                                        GROUP BY
                                            POSITION_ID,
                                            EMPLOYEE_NAME,
                                            STOCK_ID,
                                            PRODUCT_ID,
                                            PRODUCT_NAME,
                                            STOCK_CODE,
                                            <cfif xml_show_manufact_code>MANUFACT_CODE,</cfif>
                                            UNIT_NAME,
                                            UNIT_ID,
                                            UNIT
                                        ORDER BY 
                                            POSITION_ID,
                                            PRODUCT_ID
                                    </cfquery>
                                    <cfset count = 1>
                                    <cfset attributes.totalrecords = get_production__.recordcount>
                                    <cfif attributes.page neq 1>
                                        <cfloop query="get_production__" startrow="1" endrow="#attributes.startrow-1#">
                                            <cfif len(UNIT)>
                                                <cfset row_unit_ = filterSpecialChars(UNIT)>
                                            <cfelse>
                                                <cfset row_unit_ = "">
                                            </cfif>
                                            <cfif listfind(attributes.is_view,0,',')>
                                                <cfquery name="GET_K_PROD_ORDER" dbtype="query">
                                                    SELECT
                                                        DISTINCT STOCK_ID,
                                                        STATION_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=1
                                                        <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                </cfquery>
                                                    <cfset 'prod_quantity_#POSITION_ID#'=0>
                                                <cfloop query="GET_K_PROD_ORDER">
                                                    <cfif isdefined("new_amount_#STOCK_ID#")>
                                                        <cfset 'prod_quantity_#POSITION_ID#' = evaluate('prod_quantity_#POSITION_ID#') + evaluate("new_amount_#STOCK_ID#")>
                                                    </cfif>
                                                </cfloop>
                                                <cfquery name="GET_K_PROD" dbtype="query">
                                                    SELECT
                                                        SUM(PR_MINUTE) AS TOTAL_MINUTE,
                                                        SUM(SONUC) AS TOTAL_RESULT_COUNT,
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(QUANTITY) TOTAL_QUANTITY,
                                                        SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        SUM(STATION_REFLECTION_COST_SYSTEM*AMOUNT) STATION_REFLECTION_COST_SYSTEM,
                                                        SUM(STATION_COST_VALUE*AMOUNT) STATION_COST_VALUE,
                                                        POSITION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=1
                                                        <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        POSITION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    "prod_amount_#POSITION_ID#"=0;
                                                    "prod_purchase_net_system_#POSITION_ID#"=0;
                                                    "prod_purchase_extra_system_#POSITION_ID#"=0;
                                                    "prod_station_cost_#POSITION_ID#"=0;
                                                    "prod_reflection_cost_#POSITION_ID#"=0;
                                                    "prod_station_minute_#POSITION_ID#"=0;
                                                    "prod_station_result_#POSITION_ID#"=0;
                                                    if(GET_K_PROD.RECORDCOUNT)
                                                    {
                                                        for(prod_rw=1;prod_rw lte GET_K_PROD.RECORDCOUNT;prod_rw=prod_rw+1)
                                                        {
                                                            if(len(GET_K_PROD.TOTAL_AMOUNT[prod_rw])) 'prod_amount_#GET_K_PROD.POSITION_ID#' = evaluate('prod_amount_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_AMOUNT[prod_rw]; else GET_K_PROD.TOTAL_AMOUNT[prod_rw]=0;
                                                            if(len(GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw])) 'prod_purchase_net_system_#GET_K_PROD.POSITION_ID#'=evaluate('prod_purchase_net_system_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw];
                                                            if(len(GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw])) 'prod_purchase_net_system_#GET_K_PROD.POSITION_ID#'=evaluate('prod_purchase_net_system_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw];
                                                            if(len(GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw])) 'prod_reflection_cost_#GET_K_PROD.POSITION_ID#'=evaluate('prod_reflection_cost_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw];
                                                            if(len(GET_K_PROD.STATION_COST_VALUE[prod_rw])) 'prod_station_cost_#GET_K_PROD.POSITION_ID#'=evaluate('prod_station_cost_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.STATION_COST_VALUE[prod_rw];
                                                            if(len(GET_K_PROD.TOTAL_MINUTE[prod_rw])) 'prod_station_minute_#GET_K_PROD.POSITION_ID#'=evaluate('prod_station_minute_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_MINUTE[prod_rw]; else GET_K_PROD.TOTAL_MINUTE[prod_rw]=0;
                                                            if(len(GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw])) 'prod_station_result_#GET_K_PROD.POSITION_ID#'=evaluate('prod_station_result_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]; else GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]=0;
                                                        }
                                                    }
                                                </cfscript>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,1,',')>
                                                <cfquery name="GET_K_SARF" dbtype="query">
                                                    SELECT 
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        POSITION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=2
                                                        AND IS_SEVKIYAT=0
                                                            <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        POSITION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    "sarf_amount_#POSITION_ID#"=0;
                                                    "sarf_purchase_net_system_#POSITION_ID#"=0;
                                                    "sarf_purchase_extra_system_#POSITION_ID#"=0;
                                                    if(GET_K_SARF.RECORDCOUNT)
                                                    {
                                                        for(sarf_rw=1;sarf_rw lte GET_K_SARF.RECORDCOUNT;sarf_rw=sarf_rw+1)
                                                        {
                                                            if(len(GET_K_SARF.TOTAL_AMOUNT[sarf_rw])) "sarf_amount_#GET_K_SARF.POSITION_ID#"=evaluate("sarf_amount_#GET_K_SARF.POSITION_ID#")+GET_K_SARF.TOTAL_AMOUNT[sarf_rw]; else GET_K_SARF.TOTAL_AMOUNT[sarf_rw]=0;
                                                            if(len(GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw])) "sarf_purchase_net_system_#GET_K_SARF.POSITION_ID#"=evaluate("sarf_purchase_net_system_#GET_K_SARF.POSITION_ID#")+GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw];
                                                            if(len(GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw])) "sarf_purchase_extra_system_#GET_K_SARF.POSITION_ID#"=evaluate("sarf_purchase_extra_system_#GET_K_SARF.POSITION_ID#")+GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw];
                                                        }
                                                    }
                                                </cfscript>
                                                <cfquery name="GET_K_SARF_SB" dbtype="query">
                                                    SELECT 
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        POSITION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=2
                                                        AND IS_SEVKIYAT=1
                                                            <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        POSITION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    "sarf_amount_sb_#POSITION_ID#"=0;
                                                    "sarf_purchase_net_system_sb_#POSITION_ID#"=0;
                                                    "sarf_purchase_extra_system_sb_#POSITION_ID#"=0;
                                                    if(GET_K_SARF_SB.RECORDCOUNT)
                                                    {
                                                        for(sarf_sb_rw=1;sarf_sb_rw lte GET_K_SARF_SB.RECORDCOUNT;sarf_sb_rw=sarf_sb_rw+1)
                                                        {
                                                            if(len(GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw])) "sarf_amount_sb_#GET_K_SARF_SB.POSITION_ID#"=evaluate("sarf_amount_sb_#GET_K_SARF_SB.POSITION_ID#")+GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]; else GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]=0;
                                                            if(len(GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw])) "sarf_purchase_net_system_sb_#GET_K_SARF_SB.POSITION_ID#"=evaluate("sarf_purchase_net_system_sb_#GET_K_SARF_SB.POSITION_ID#")+GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                            if(len(GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw])) "sarf_purchase_extra_system_sb_#GET_K_SARF_SB.POSITION_ID#"=evaluate("sarf_purchase_extra_system_sb_#GET_K_SARF_SB.POSITION_ID#")+GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                        }
                                                    }
                                                </cfscript>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,3,',')>
                                                <cfquery name="GET_K_FIRE" dbtype="query">
                                                    SELECT 
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        POSITION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE=3
                                                        AND IS_SEVKIYAT=0
                                                            <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        POSITION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    'fire_amount_#POSITION_ID#'=0;
                                                    'fire_purchase_net_system_#POSITION_ID#'=0;
                                                    'fire_purchase_extra_system_#POSITION_ID#'=0;
                                                    if(GET_K_FIRE.RECORDCOUNT)
                                                    {
                                                        for(fire_rw=1;fire_rw lte GET_K_FIRE.RECORDCOUNT;fire_rw=fire_rw+1)
                                                        {
                                                            if(len(GET_K_FIRE.TOTAL_AMOUNT[fire_rw])) 'fire_amount_#GET_K_FIRE.POSITION_ID#'=evaluate('fire_amount_#GET_K_FIRE.POSITION_ID#')+GET_K_FIRE.TOTAL_AMOUNT[fire_rw]; else GET_K_FIRE.TOTAL_AMOUNT[fire_rw]=0;
                                                            if(len(GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw])) 'fire_purchase_net_system_#GET_K_FIRE.POSITION_ID#'=evaluate('fire_purchase_net_system_#GET_K_FIRE.POSITION_ID#')+GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                            if(len(GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw])) 'fire_purchase_extra_system_#GET_K_FIRE.POSITION_ID#'=evaluate('fire_purchase_extra_system_#GET_K_FIRE.POSITION_ID#')+GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                        }
                                                    }
                                                </cfscript>
                                                <cfquery name="GET_K_FIRE_SB" dbtype="query">
                                                    SELECT 
                                                        SUM(AMOUNT) TOTAL_AMOUNT,
                                                        SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                        SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                        POSITION_ID,
                                                        STOCK_ID
                                                    FROM
                                                        GET_PRODUCTION
                                                    WHERE
                                                        TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                                                        AND IS_SEVKIYAT = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                                                            <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                        AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                    GROUP BY
                                                        POSITION_ID,
                                                        STOCK_ID
                                                </cfquery>
                                                <cfscript>
                                                    'fire_amount_sb_#POSITION_ID#'=0;
                                                    'fire_purchase_net_system_sb_#POSITION_ID#'=0;
                                                    'fire_purchase_extra_system_sb_#POSITION_ID#'=0;
                                                    if(GET_K_FIRE_SB.RECORDCOUNT)
                                                    {
                                                        for(fire_sb_rw=1;fire_sb_rw lte GET_K_FIRE_SB.RECORDCOUNT;fire_sb_rw=fire_sb_rw+1)
                                                        {
                                                            if(len(GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw])) 'fire_amount_sb_#GET_K_FIRE_SB.POSITION_ID#'=evaluate('fire_amount_sb_#GET_K_FIRE_SB.POSITION_ID#')+GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]; else GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]=0;
                                                            if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw])) 'fire_purchase_net_system_sb_#GET_K_FIRE_SB.POSITION_ID#'=evaluate('fire_purchase_net_system_sb_#GET_K_FIRE_SB.POSITION_ID#')+GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                            if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw])) 'fire_purchase_extra_system_sb_#GET_K_FIRE_SB.POSITION_ID#'=evaluate('fire_purchase_extra_system_sb_#GET_K_FIRE_SB.POSITION_ID#')+GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                        }
                                                    }
                                                </cfscript>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,0,',')>
                                                <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_sonuc_#POSITION_ID#_#row_unit_#" = wrk_round(evaluate('prod_station_result_#POSITION_ID#'),8,1) + evaluate("toplam_sonuc_#POSITION_ID#_#row_unit_#")></cfif>
                                                <cfif isdefined("attributes.is_order_amount")>
                                                    <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_emir_#POSITION_ID#_#row_unit_#" = evaluate('prod_quantity_#POSITION_ID#') + evaluate("toplam_emir_#POSITION_ID#_#row_unit_#")></cfif>
                                                </cfif>
                                                <cfset 'total_production_result_minute_#POSITION_ID#'=evaluate('total_production_result_minute_#POSITION_ID#')+evaluate('prod_station_minute_#POSITION_ID#')>
                                                <cfset 'total_prod_amount_#POSITION_ID#'=evaluate('total_prod_amount_#POSITION_ID#')+evaluate('prod_amount_#POSITION_ID#')>
                                                <cfset 'total_prod_purchase_net_#POSITION_ID#'=evaluate('total_prod_purchase_net_#POSITION_ID#')+evaluate('prod_purchase_net_system_#POSITION_ID#')>
                                                <cfset 'total_prod_purchase_extra_system_#POSITION_ID#'=evaluate('total_prod_purchase_extra_system_#POSITION_ID#')+evaluate('prod_purchase_extra_system_#POSITION_ID#')>
                                                <cfset 'total_station_cost_#POSITION_ID#'=evaluate('total_station_cost_#POSITION_ID#')+evaluate('prod_station_cost_#POSITION_ID#')>
                                                <cfset 'total_prod_station_reflection_cost_system_#POSITION_ID#'=evaluate('total_prod_station_reflection_cost_system_#POSITION_ID#')+evaluate('prod_reflection_cost_#POSITION_ID#')>
                                                <cfset 'total_cost_all_#POSITION_ID#' = evaluate('total_cost_all_#POSITION_ID#') + ((evaluate('prod_reflection_cost_#POSITION_ID#')+evaluate('prod_purchase_net_system_#POSITION_ID#')+evaluate('prod_purchase_extra_system_#POSITION_ID#')+evaluate('prod_station_cost_#POSITION_ID#')))>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,1,',')>
                                                <cfset 'total_sarf_amount_#POSITION_ID#'=evaluate('total_sarf_amount_#POSITION_ID#')+wrk_round(evaluate('sarf_amount_#POSITION_ID#'),8,1)>
                                                <cfset 'total_sarf_purchase_net_system_#POSITION_ID#'=evaluate('total_sarf_purchase_net_system_#POSITION_ID#')+evaluate('sarf_purchase_net_system_#POSITION_ID#')>
                                                <cfset 'total_sarf_purchase_extra_system_#POSITION_ID#'=evaluate('total_sarf_purchase_extra_system_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_#POSITION_ID#')>
                                                <cfset 'total_sarf_amount_sb_#POSITION_ID#'=evaluate('total_sarf_amount_sb_#POSITION_ID#')+evaluate('sarf_amount_sb_#POSITION_ID#')>
                                                <cfset 'total_sarf_purchase_net_system_sb_#POSITION_ID#'=evaluate('total_sarf_purchase_net_system_sb_#POSITION_ID#')+evaluate('sarf_purchase_net_system_sb_#POSITION_ID#')>
                                                <cfset 'total_sarf_purchase_extra_system_sb_#POSITION_ID#'=evaluate('total_sarf_purchase_extra_system_sb_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_sb_#POSITION_ID#')>
                                                <cfset 'total_sarf_amount_with_sb_#POSITION_ID#'=evaluate('total_sarf_amount_with_sb_#POSITION_ID#')+evaluate('sarf_amount_#POSITION_ID#')+evaluate('sarf_amount_sb_#POSITION_ID#')>
                                                <cfset 'total_sarf_cost_#POSITION_ID#'=evaluate('total_sarf_cost_#POSITION_ID#')+evaluate('sarf_purchase_net_system_#POSITION_ID#')+evaluate('sarf_purchase_net_system_sb_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_sb_#POSITION_ID#')>
                                            </cfif>
                                            <cfif listfind(attributes.is_view,3,',')>
                                                <cfset 'total_fire_amount_#POSITION_ID#'=evaluate('total_fire_amount_#POSITION_ID#')+wrk_round(evaluate('fire_amount_#POSITION_ID#'),8,1)>
                                                <cfset 'total_fire_purchase_net_system_#POSITION_ID#'=evaluate('total_fire_purchase_net_system_#POSITION_ID#')+evaluate('fire_purchase_net_system_#POSITION_ID#')>
                                                <cfset 'total_fire_purchase_extra_system_#POSITION_ID#'=evaluate('total_fire_purchase_extra_system_#POSITION_ID#')+evaluate('fire_purchase_extra_system_#POSITION_ID#')>
                                                <cfset 'total_fire_amount_sb_#POSITION_ID#'=evaluate('total_fire_amount_sb_#POSITION_ID#')+evaluate('fire_amount_sb_#POSITION_ID#')>
                                                <cfset 'total_fire_purchase_net_system_sb_#POSITION_ID#'=evaluate('total_fire_purchase_net_system_sb_#POSITION_ID#')+evaluate('fire_purchase_net_system_sb_#POSITION_ID#')>
                                                <cfset 'total_fire_purchase_extra_system_sb_#POSITION_ID#'=evaluate('total_fire_purchase_extra_system_sb_#POSITION_ID#')+evaluate('fire_purchase_extra_system_sb_#POSITION_ID#')>
                                                <cfset 'total_fire_amount_with_sb_#POSITION_ID#'=evaluate('total_fire_amount_with_sb_#POSITION_ID#')+evaluate('fire_amount_#POSITION_ID#')+evaluate('fire_amount_sb_#POSITION_ID#')>
                                                <cfset 'total_fire_cost_#POSITION_ID#'=evaluate('total_fire_cost_#POSITION_ID#')+evaluate('fire_purchase_net_system_#POSITION_ID#')+evaluate('fire_purchase_net_system_sb_#POSITION_ID#')+evaluate('fire_purchase_extra_system_#POSITION_ID#')+evaluate('fire_purchase_extra_system_sb_#POSITION_ID#')>
                                            </cfif>
                                        </cfloop>
                                    </cfif>	
                                    <cfoutput query="get_production__" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                        <cfset count++> 
                                        <cfif listfind(attributes.is_view,0,',')>
                                            <cfquery name="GET_K_PROD_ORDER" dbtype="query">
                                                SELECT
                                                    DISTINCT STOCK_ID,
                                                    POSITION_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=1
                                                    <cfif len(POSITION_ID)>
                                                        AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                    <cfelse>
                                                        AND POSITION_ID IS NULL
                                                    </cfif>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                            </cfquery>
                                            <cfset 'prod_quantity_#POSITION_ID#' = 0>
                                            <cfloop query="GET_K_PROD_ORDER">
                                                <cfif isdefined("new_amount_#STOCK_ID#")>
                                                    <cfset 'prod_quantity_#POSITION_ID#' = evaluate('prod_quantity_#POSITION_ID#') + evaluate("new_amount_#STOCK_ID#")>
                                                </cfif>
                                            </cfloop>
                                            <cfquery name="GET_K_PROD" dbtype="query">
                                                SELECT
                                                    SUM(PR_MINUTE) AS TOTAL_MINUTE,
                                                    SUM(SONUC) AS TOTAL_RESULT_COUNT,
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(QUANTITY) TOTAL_QUANTITY,
                                                    SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    SUM(STATION_REFLECTION_COST_SYSTEM*AMOUNT) STATION_REFLECTION_COST_SYSTEM,
                                                    SUM(STATION_COST_VALUE*AMOUNT) STATION_COST_VALUE,
                                                    POSITION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=1
                                                    <cfif len(POSITION_ID)>
                                                        AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                    <cfelse>
                                                        AND POSITION_ID IS NULL
                                                    </cfif>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    POSITION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                'prod_amount_#POSITION_ID#'=0;
                                                'prod_purchase_net_system_#POSITION_ID#'=0;
                                                'prod_purchase_extra_system_#POSITION_ID#'=0;
                                                'prod_station_cost_#POSITION_ID#'=0;
                                                'prod_reflection_cost_#POSITION_ID#'=0;
                                                'prod_station_minute_#POSITION_ID#'=0;
                                                'prod_station_result_#POSITION_ID#'=0;
                                                if(GET_K_PROD.RECORDCOUNT)
                                                {
                                                    for(prod_rw=1;prod_rw lte GET_K_PROD.RECORDCOUNT;prod_rw=prod_rw+1)
                                                    {
                                                        if(len(GET_K_PROD.TOTAL_AMOUNT[prod_rw])) 'prod_amount_#GET_K_PROD.POSITION_ID#'=evaluate('prod_amount_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_AMOUNT[prod_rw]; else GET_K_PROD.TOTAL_AMOUNT[prod_rw]=0;
                                                        if(len(GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw])) 'prod_purchase_net_system_#GET_K_PROD.POSITION_ID#'=evaluate('prod_purchase_net_system_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_PURCHASE_NET_SYSTEM[prod_rw];
                                                        if(len(GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw])) 'prod_purchase_net_system_#GET_K_PROD.POSITION_ID#'=evaluate('prod_purchase_net_system_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[prod_rw];
                                                        if(len(GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw])) 'prod_reflection_cost_#GET_K_PROD.POSITION_ID#'=evaluate('prod_reflection_cost_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.STATION_REFLECTION_COST_SYSTEM[prod_rw];
                                                        if(len(GET_K_PROD.STATION_COST_VALUE[prod_rw])) 'prod_station_cost_#GET_K_PROD.POSITION_ID#'=evaluate('prod_station_cost_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.STATION_COST_VALUE[prod_rw];
                                                        if(len(GET_K_PROD.TOTAL_MINUTE[prod_rw])) 'prod_station_minute_#GET_K_PROD.POSITION_ID#'=evaluate('prod_station_minute_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_MINUTE[prod_rw]; else GET_K_PROD.TOTAL_MINUTE[prod_rw]=0;
                                                        if(len(GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw])) 'prod_station_result_#GET_K_PROD.POSITION_ID#'=evaluate('prod_station_result_#GET_K_PROD.POSITION_ID#')+GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]; else GET_K_PROD.TOTAL_RESULT_COUNT[prod_rw]=0;
                                                    }
                                                }
                                            </cfscript>
                                        </cfif>
                                        <cfif listfind(attributes.is_view,1,',')>
                                            <cfquery name="GET_K_SARF" dbtype="query">
                                                SELECT 
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(PURCHASE_NET_SYSTEM*AMOUNT) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    POSITION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=2
                                                    AND IS_SEVKIYAT=0
                                                        <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    POSITION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                "sarf_amount_#POSITION_ID#"=0;
                                                "sarf_purchase_net_system_#POSITION_ID#"=0;
                                                "sarf_purchase_extra_system_#POSITION_ID#"=0;
                                                if(GET_K_SARF.RECORDCOUNT)
                                                {
                                                    for(sarf_rw=1;sarf_rw lte GET_K_SARF.RECORDCOUNT;sarf_rw=sarf_rw+1)
                                                    {
                                                        if(len(GET_K_SARF.TOTAL_AMOUNT[sarf_rw])) "sarf_amount_#GET_K_SARF.POSITION_ID#"=evaluate("sarf_amount_#GET_K_SARF.POSITION_ID#")+GET_K_SARF.TOTAL_AMOUNT[sarf_rw]; else GET_K_SARF.TOTAL_AMOUNT[sarf_rw]=0;
                                                        if(len(GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw])) "sarf_purchase_net_system_#GET_K_SARF.POSITION_ID#"=evaluate("sarf_purchase_net_system_#GET_K_SARF.POSITION_ID#")+GET_K_SARF.TOTAL_PURCHASE_NET_SYSTEM[sarf_rw];
                                                        if(len(GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw])) "sarf_purchase_extra_system_#GET_K_SARF.POSITION_ID#"=evaluate("sarf_purchase_extra_system_#GET_K_SARF.POSITION_ID#")+GET_K_SARF.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_rw];
                                                    }
                                                }
                                            </cfscript>
                                            <cfquery name="GET_K_SARF_SB" dbtype="query">
                                                SELECT 
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    POSITION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=2
                                                    AND IS_SEVKIYAT=1
                                                        <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    POSITION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                "sarf_amount_sb_#POSITION_ID#"=0;
                                                "sarf_purchase_net_system_sb_#POSITION_ID#"=0;
                                                "sarf_purchase_extra_system_sb_#POSITION_ID#"=0;
                                                if(GET_K_SARF_SB.RECORDCOUNT)
                                                {
                                                    for(sarf_sb_rw=1;sarf_sb_rw lte GET_K_SARF_SB.RECORDCOUNT;sarf_sb_rw=sarf_sb_rw+1)
                                                    {
                                                        if(len(GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw])) "sarf_amount_sb_#GET_K_SARF_SB.POSITION_ID#"=evaluate("sarf_amount_sb_#GET_K_SARF_SB.POSITION_ID#")+GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]; else GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw]=0;
                                                        if(len(GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw])) "sarf_purchase_net_system_sb_#GET_K_SARF_SB.POSITION_ID#"=evaluate("sarf_purchase_net_system_sb_#GET_K_SARF_SB.POSITION_ID#")+GET_K_SARF_SB.TOTAL_PURCHASE_NET_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                        if(len(GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw])) "sarf_purchase_extra_system_sb_#GET_K_SARF_SB.POSITION_ID#"=evaluate("sarf_purchase_extra_system_sb_#GET_K_SARF_SB.POSITION_ID#")+GET_K_SARF_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[sarf_sb_rw]*GET_K_SARF_SB.TOTAL_AMOUNT[sarf_sb_rw];
                                                    }
                                                }
                                            </cfscript>
                                        </cfif>
                                        <cfif listfind(attributes.is_view,3,',')>
                                            <cfquery name="GET_K_FIRE" dbtype="query">
                                                SELECT 
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    POSITION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE=3
                                                    AND IS_SEVKIYAT=0
                                                    <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    POSITION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                'fire_amount_#POSITION_ID#'=0;
                                                'fire_purchase_net_system_#POSITION_ID#'=0;
                                                'fire_purchase_extra_system_#POSITION_ID#'=0;
                                                if(GET_K_FIRE.RECORDCOUNT)
                                                {
                                                    for(fire_rw=1;fire_rw lte GET_K_FIRE.RECORDCOUNT;fire_rw=fire_rw+1)
                                                    {
                                                        if(len(GET_K_FIRE.TOTAL_AMOUNT[fire_rw])) 'fire_amount_#GET_K_FIRE.POSITION_ID#'=evaluate('fire_amount_#GET_K_FIRE.POSITION_ID#')+GET_K_FIRE.TOTAL_AMOUNT[fire_rw]; else GET_K_FIRE.TOTAL_AMOUNT[fire_rw]=0;
                                                        if(len(GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw])) 'fire_purchase_net_system_#GET_K_FIRE.POSITION_ID#'=evaluate('fire_purchase_net_system_#GET_K_FIRE.POSITION_ID#')+GET_K_FIRE.TOTAL_PURCHASE_NET_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                        if(len(GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw])) 'fire_purchase_extra_system_#GET_K_FIRE.POSITION_ID#'=evaluate('fire_purchase_extra_system_#GET_K_FIRE.POSITION_ID#')+GET_K_FIRE.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_rw]*GET_K_FIRE.TOTAL_AMOUNT[fire_rw];
                                                    }
                                                }
                                            </cfscript>
                                            <cfquery name="GET_K_FIRE_SB" dbtype="query">
                                                SELECT 
                                                    SUM(AMOUNT) TOTAL_AMOUNT,
                                                    SUM(PURCHASE_NET_SYSTEM) TOTAL_PURCHASE_NET_SYSTEM,
                                                    SUM(PURCHASE_EXTRA_COST_SYSTEM) TOTAL_PURCHASE_EXTRA_COST_SYSTEM,
                                                    POSITION_ID,
                                                    STOCK_ID
                                                FROM
                                                    GET_PRODUCTION
                                                WHERE
                                                    TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                                                    AND IS_SEVKIYAT = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                                                        <cfif len(POSITION_ID)>
                                                            AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
                                                        <cfelse>
                                                            AND POSITION_ID IS NULL
                                                        </cfif>
                                                    AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                                GROUP BY
                                                    POSITION_ID,
                                                    STOCK_ID
                                            </cfquery>
                                            <cfscript>
                                                'fire_amount_sb_#POSITION_ID#'=0;
                                                'fire_purchase_net_system_sb_#POSITION_ID#'=0;
                                                'fire_purchase_extra_system_sb_#POSITION_ID#'=0;
                                                if(GET_K_FIRE_SB.RECORDCOUNT)
                                                {
                                                    for(fire_sb_rw=1;fire_sb_rw lte GET_K_FIRE_SB.RECORDCOUNT;fire_sb_rw=fire_sb_rw+1)
                                                    {
                                                        if(len(GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw])) 'fire_amount_sb_#GET_K_FIRE_SB.POSITION_ID#'=evaluate('fire_amount_sb_#GET_K_FIRE_SB.POSITION_ID#')+GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]; else GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw]=0;
                                                        if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw])) 'fire_purchase_net_system_sb_#GET_K_FIRE_SB.POSITION_ID#'=evaluate('fire_purchase_net_system_sb_#GET_K_FIRE_SB.POSITION_ID#')+GET_K_FIRE_SB.TOTAL_PURCHASE_NET_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                        if(len(GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw])) 'fire_purchase_extra_system_sb_#GET_K_FIRE_SB.POSITION_ID#'=evaluate('fire_purchase_extra_system_sb_#GET_K_FIRE_SB.POSITION_ID#')+GET_K_FIRE_SB.TOTAL_PURCHASE_EXTRA_COST_SYSTEM[fire_sb_rw]*GET_K_FIRE_SB.TOTAL_AMOUNT[fire_sb_rw];
                                                    }
                                                }
                                            </cfscript>
                                        </cfif>
                                        <cfif isdefined('attributes.ajax')><!--- Kümülatif raporlar oluşturuluyorsa! --->
                                            <cfinclude template="../../settings/cumulative/cumulative_production_analyse_inc.cfm">
                                        <cfelse>
                                            <tr>
                                                <td>#currentrow#</td>
                                                <td><cfif len(POSITION_ID)>#employee_name#</cfif></td>
                                                <td>#STOCK_CODE#</td>
                                                <td>#PRODUCT_NAME#</td>
                                                <cfif xml_show_manufact_code>
                                                    <td style="mso-number-format:\@;">
                                                        #manufact_code#
                                                    </td>
                                                </cfif>
                                                <td>
                                                    <cfif len(UNIT)>
                                                        #UNIT#
                                                        <cfset row_unit_ = filterSpecialChars(UNIT)>
                                                    <cfelse>
                                                        <cfset row_unit_ = "">
                                                    </cfif>
                                                </td>
                                                <cfif listfind(attributes.is_view,0,',')>
                                                    <td></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('prod_station_result_#POSITION_ID#'),8,1),8)#
                                                        <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_sonuc_#POSITION_ID#_#row_unit_#" = wrk_round(evaluate('prod_station_result_#POSITION_ID#'),8,1) + evaluate("toplam_sonuc_#POSITION_ID#_#row_unit_#")></cfif>
                                                    </td>
                                                    <cfif isdefined("attributes.is_order_amount")>
                                                        <td align="right" style="text-align:right;" format="numeric">#tlformat(evaluate('prod_quantity_#POSITION_ID#'))#
                                                            <cfif isdefined("row_unit_") and Len(row_unit_)><cfset "toplam_emir_#POSITION_ID#_#row_unit_#" = evaluate('prod_quantity_#POSITION_ID#') + evaluate("toplam_emir_#POSITION_ID#_#row_unit_#")></cfif>
                                                        </td>
                                                    </cfif>
                                                    <td align="right" style="text-align:right;" format="numeric">#tlformat(evaluate('prod_station_minute_#POSITION_ID#'))#<cfset 'total_production_result_minute_#POSITION_ID#'=evaluate('total_production_result_minute_#POSITION_ID#')+evaluate('prod_station_minute_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_amount_#POSITION_ID#'))# <cfset 'total_prod_amount_#POSITION_ID#'=evaluate('total_prod_amount_#POSITION_ID#')+evaluate('prod_amount_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_purchase_net_system_#POSITION_ID#'))# <cfset 'total_prod_purchase_net_#POSITION_ID#'=evaluate('total_prod_purchase_net_#POSITION_ID#')+ evaluate('prod_purchase_net_system_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_purchase_extra_system_#POSITION_ID#'))# <cfset 'total_prod_purchase_extra_system_#POSITION_ID#'=evaluate('total_prod_purchase_extra_system_#POSITION_ID#')+ evaluate('prod_purchase_extra_system_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_station_cost_#POSITION_ID#'))# <cfset 'total_station_cost_#POSITION_ID#'=evaluate('total_station_cost_#POSITION_ID#')+ evaluate('prod_station_cost_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('prod_reflection_cost_#POSITION_ID#'))#</td><cfset 'total_prod_station_reflection_cost_system_#POSITION_ID#'=evaluate('total_prod_station_reflection_cost_system_#POSITION_ID#')+ evaluate('prod_reflection_cost_#POSITION_ID#')>
                                                    <td align="right" style="text-align:right;" format="numeric">
                                                        #TLFormat((evaluate('prod_reflection_cost_#POSITION_ID#')+evaluate('prod_purchase_net_system_#POSITION_ID#')+evaluate('prod_purchase_extra_system_#POSITION_ID#')+evaluate('prod_station_cost_#POSITION_ID#')))#
                                                        <cfset 'total_cost_all_#POSITION_ID#' = evaluate('total_cost_all_#POSITION_ID#') + ((evaluate('prod_reflection_cost_#POSITION_ID#')+evaluate('prod_purchase_net_system_#POSITION_ID#')+evaluate('prod_purchase_extra_system_#POSITION_ID#')+evaluate('prod_station_cost_#POSITION_ID#')))>
                                                    </td>
                                                </cfif>
                                                <cfif listfind(attributes.is_view,1,',')>
                                                    <td></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('sarf_amount_#POSITION_ID#'),8,1),8)# <cfset 'total_sarf_amount_#POSITION_ID#'=evaluate('total_sarf_amount_#POSITION_ID#')+wrk_round(evaluate('sarf_amount_#POSITION_ID#'),8,1)></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_net_system_#POSITION_ID#'))# <cfset 'total_sarf_purchase_net_system_#POSITION_ID#'=evaluate('total_sarf_purchase_net_system_#POSITION_ID#')+evaluate('sarf_purchase_net_system_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_extra_system_#POSITION_ID#'))# <cfset 'total_sarf_purchase_extra_system_#POSITION_ID#'=evaluate('total_sarf_purchase_extra_system_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_amount_sb_#POSITION_ID#'))# <cfset 'total_sarf_amount_sb_#POSITION_ID#'=evaluate('total_sarf_amount_sb_#POSITION_ID#')+evaluate('sarf_amount_sb_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_net_system_sb_#POSITION_ID#'))# <cfset 'total_sarf_purchase_net_system_sb_#POSITION_ID#'=evaluate('total_sarf_purchase_net_system_sb_#POSITION_ID#')+evaluate('sarf_purchase_net_system_sb_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_extra_system_sb_#POSITION_ID#'))# <cfset 'total_sarf_purchase_extra_system_sb_#POSITION_ID#'=evaluate('total_sarf_purchase_extra_system_sb_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_sb_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_amount_#POSITION_ID#')+evaluate('sarf_amount_sb_#POSITION_ID#'))# <cfset 'total_sarf_amount_with_sb_#POSITION_ID#'=evaluate('total_sarf_amount_with_sb_#POSITION_ID#')+evaluate('sarf_amount_#POSITION_ID#')+evaluate('sarf_amount_sb_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('sarf_purchase_net_system_#POSITION_ID#')+evaluate('sarf_purchase_net_system_sb_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_sb_#POSITION_ID#'))#</td>
                                                    <cfset 'total_sarf_cost_#POSITION_ID#' = evaluate('total_sarf_cost_#POSITION_ID#')+evaluate('sarf_purchase_net_system_#POSITION_ID#')+evaluate('sarf_purchase_net_system_sb_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_#POSITION_ID#')+evaluate('sarf_purchase_extra_system_sb_#POSITION_ID#')>
                                                </cfif>
                                                <cfif listfind(attributes.is_view,3,',')>
                                                    <td></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('fire_amount_#POSITION_ID#'),8,1),8)# <cfset 'total_fire_amount_#POSITION_ID#'=evaluate('total_fire_amount_#POSITION_ID#')+wrk_round(evaluate('fire_amount_#POSITION_ID#'),8,1)></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_net_system_#POSITION_ID#'))# <cfset 'total_fire_purchase_net_system_#POSITION_ID#'=evaluate('total_fire_purchase_net_system_#POSITION_ID#')+evaluate('fire_purchase_net_system_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_extra_system_#POSITION_ID#'))# <cfset 'total_fire_purchase_extra_system_#POSITION_ID#'=evaluate('total_fire_purchase_extra_system_#POSITION_ID#')+evaluate('fire_purchase_extra_system_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_amount_sb_#POSITION_ID#'))# <cfset 'total_fire_amount_sb_#POSITION_ID#'=evaluate('total_fire_amount_sb_#POSITION_ID#')+evaluate('fire_amount_sb_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_net_system_sb_#POSITION_ID#'))# <cfset 'total_fire_purchase_net_system_sb_#POSITION_ID#'=evaluate('total_fire_purchase_net_system_sb_#POSITION_ID#')+evaluate('fire_purchase_net_system_sb_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_extra_system_sb_#POSITION_ID#'))# <cfset 'total_fire_purchase_extra_system_sb_#POSITION_ID#'=evaluate('total_fire_purchase_extra_system_sb_#POSITION_ID#')+evaluate('fire_purchase_extra_system_sb_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_amount_#POSITION_ID#')+evaluate('fire_amount_sb_#POSITION_ID#'))# <cfset 'total_fire_amount_with_sb_#POSITION_ID#'=evaluate('total_fire_amount_with_sb_#POSITION_ID#')+evaluate('fire_amount_#POSITION_ID#')+evaluate('fire_amount_sb_#POSITION_ID#')></td>
                                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('fire_purchase_net_system_#POSITION_ID#')+evaluate('fire_purchase_net_system_sb_#POSITION_ID#')+evaluate('fire_purchase_extra_system_#POSITION_ID#')+evaluate('fire_purchase_extra_system_sb_#POSITION_ID#'))#</td>
                                                    <cfset 'total_fire_cost_#POSITION_ID#'=evaluate('total_fire_cost_#POSITION_ID#')+evaluate('fire_purchase_net_system_#POSITION_ID#')+evaluate('fire_purchase_net_system_sb_#POSITION_ID#')+evaluate('fire_purchase_extra_system_#POSITION_ID#')+evaluate('fire_purchase_extra_system_sb_#POSITION_ID#')>
                                                </cfif>
                                            </tr>
                                            <cfif attributes.report_type eq 12 and POSITION_ID[currentrow] neq POSITION_ID[currentrow+1]><!--- istasyon bazında toplam --->
                                                <tr>
                                                    <td></td>
                                                    <td></td>
                                                    <td></td>
                                                    <td></td>
                                                    <cfset colspan_= 1>
                                                    <cfset align_="left">
                                                    <cfif xml_show_manufact_code>
                                                        <td></td>
                                                    </cfif>
                                                    <td colspan="#colspan_#" align="#align_#" class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam '></td>
                                                    <cfif listfind(attributes.is_view,0,',')>
                                                        <td></td>
                                                        <td align="right" style="text-align:right;" format="numeric">
                                                            <cfloop query="get_product_units">
                                                                <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                                <cfif evaluate('toplam_sonuc_#get_production__.POSITION_ID#_#unit_#') gt 0>#TLFormat(wrk_round(evaluate('toplam_sonuc_#get_production__.POSITION_ID#_#unit_#'),8,1),8)# #get_product_units.unit#<br/></cfif>
                                                            </cfloop>
                                                        </td>
                                                        <cfif isdefined("attributes.is_order_amount")>
                                                            <td align="right" style="text-align:right;" format="numeric">
                                                                <cfloop query="get_product_units">
                                                                    <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                                    <cfif evaluate('toplam_emir_#get_production__.POSITION_ID#_#unit_#') gt 0>
                                                                        #Tlformat(evaluate('toplam_emir_#get_production__.POSITION_ID#_#unit_#'))# #get_product_units.unit#<br/>
                                                                    </cfif>
                                                                </cfloop>
                                                            </td>
                                                        </cfif>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_production_result_minute_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_prod_amount_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_prod_purchase_net_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_prod_purchase_extra_system_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_station_cost_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_prod_station_reflection_cost_system_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_cost_all_#POSITION_ID#'))#</td>
                                                    </cfif>
                                                    <cfif listfind(attributes.is_view,1,',')>
                                                        <td></td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('total_sarf_amount_#POSITION_ID#'),8,1),8)#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_purchase_net_system_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_purchase_extra_system_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_amount_sb_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_purchase_net_system_sb_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_purchase_extra_system_sb_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_amount_#POSITION_ID#')+evaluate('total_sarf_amount_sb_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_cost_#POSITION_ID#'))#</td>
                                                    </cfif>
                                                    <cfif listfind(attributes.is_view,3,',')>
                                                        <td></td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(wrk_round(evaluate('total_fire_amount_#POSITION_ID#'),8,1),8)#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_purchase_net_system_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_purchase_extra_system_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_amount_sb_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_purchase_net_system_sb_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_purchase_extra_system_sb_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_fire_amount_#POSITION_ID#')+evaluate('total_fire_amount_sb_#POSITION_ID#'))#</td>
                                                        <td align="right" style="text-align:right;" format="numeric">#TLFormat(evaluate('total_sarf_cost_#POSITION_ID#'))#</td>
                                                    </cfif>
                                                </tr>
                                                <cfscript>
                                                    "total_prod_amount_#POSITION_ID#" = 0;
                                                    "total_prod_purchase_net_#POSITION_ID#" = 0;
                                                    "total_prod_purchase_extra_system_#POSITION_ID#" = 0;
                                                    "total_prod_station_reflection_cost_system_#POSITION_ID#" = 0;
                                                    "total_station_cost_#POSITION_ID#" = 0;
                                                    "total_sarf_amount_#POSITION_ID#" = 0;
                                                    "total_sarf_purchase_net_system_#POSITION_ID#" = 0;
                                                    "total_sarf_purchase_extra_system_#POSITION_ID#" = 0;
                                                    "total_sarf_amount_sb_#POSITION_ID#" = 0;
                                                    "total_sarf_purchase_net_system_sb_#POSITION_ID#" = 0;
                                                    "total_sarf_purchase_extra_system_sb_#POSITION_ID#" = 0;
                                                    "total_sarf_amount_with_sb_#POSITION_ID#" = 0;
                                                    "total_sarf_cost_#POSITION_ID#" = 0;
                                                    "total_fire_amount_#POSITION_ID#" = 0;
                                                    "total_fire_purchase_net_system_#POSITION_ID#" = 0;
                                                    "total_fire_purchase_extra_system_#POSITION_ID#" = 0;
                                                    "total_fire_amount_sb_#POSITION_ID#" = 0;
                                                    "total_fire_purchase_net_system_sb_#POSITION_ID#" = 0;
                                                    "total_fire_purchase_extra_system_sb_#POSITION_ID#" = 0;
                                                    "total_fire_amount_with_sb_#POSITION_ID#" = 0;
                                                    "total_fire_cost_#POSITION_ID#" = 0;
                                                    "total_production_result_count_#POSITION_ID#" = 0;
                                                    "total_production_result_minute_#POSITION_ID#" = 0;
                                                    "total_cost_all_#POSITION_ID#" = 0;
                                                    //"toplam_sonuc_#row_unit_#" = 0;****
                                                </cfscript>
                                                <cfloop query="get_product_units">
                                                    <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                    <cfset 'toplam_sonuc_#get_production__.POSITION_ID#_#unit_#' = 0>
                                                    <cfset 'toplam_emir_#get_production__.POSITION_ID#_#unit_#' = 0>
                                                </cfloop>
                                            </cfif>
                                        </cfif>
                                    </cfoutput>
                                <cfelse>
                                    <tr>
                                        <td colspan="40"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                                    </tr>
                                </cfif>
                            </cfif>
                        </tbody>
                    </cfif>
                    <cfif type_ neq 1>
                        </table>
                    </cfif>
                </cfif>
                <cfif listfind(attributes.is_view,2,',') and not isdefined('attributes.ajax') and not listfind('11,12',attributes.report_type)><!--- detay secili ise ve kümülatif rapor değil ise...--->
                    <cfoutput>
                        <thead>
                            <tr height="20" align="center">
                                <cfset colspan_ = 13>
                                <cfif listfind(attributes.is_view,0,',')>
                                    <cfset colspan_ = colspan_ + 5>
                                </cfif>
                                <cfif listfind(attributes.is_view,1,',')>
                                    <cfset colspan_ = colspan_ + 9>
                                </cfif>
                                <cfif listfind(attributes.is_view,3,',')>
                                    <cfset colspan_ = colspan_ + 9>
                                </cfif>
                                <th colspan="#colspan_#"></th>
                            </tr>
                        </thead>
                    <thead>
                        <tr align="center">
                            <th></th>
                            <th colspan="9"><cf_get_lang dictionary_id ='36656.Emir'> <cf_get_lang dictionary_id='57989.ve '><cf_get_lang dictionary_id ='57684.Sonuç'></th>
                            <th colspan="3"><cf_get_lang dictionary_id ='43214.Stok Fişleri'></th>
                            <cfif listfind(attributes.is_view,0,',')>
                                <th></th>
                                <th colspan="4"><cf_get_lang dictionary_id ='57456.Üretim'></th>
                            </cfif>
                            <cfif listfind(attributes.is_view,1,',')>
                                <th></th>
                                <th colspan="8"><cf_get_lang dictionary_id ='40196.Sarf'></th>
                            </cfif>
                            <cfif listfind(attributes.is_view,3,',')>
                                <th></th>
                                <th colspan="8"><cf_get_lang dictionary_id ='29471.Fire'></th>
                            </cfif>
                        </tr>
                        <tr>
                            <th><cf_get_lang dictionary_id ='57487.No'></th>
                            <th><cf_get_lang dictionary_id ='58211.Sip No'></th>
                            <th><cf_get_lang dictionary_id ='29474.Emir No'></th>
                            <th><cf_get_lang dictionary_id ='40731.Sonuç No'></th>
                            <th><cf_get_lang dictionary_id ='57457.Müşteri'></th>
                            <th><cf_get_lang dictionary_id ='57518.Stok Kod'></th>
                            <th><cf_get_lang dictionary_id ='57452.Stok'></th>
                            <th><cf_get_lang dictionary_id ='57647.Spec'></th>
                            <th><cf_get_lang dictionary_id ='36305.İşlem Kategorisi'></th>
                            <th><cf_get_lang dictionary_id ='40408.Üretim Çıkış Fişi'></th>
                            <th><cf_get_lang dictionary_id ='29628.Sarf Fişi'></th>
                            <th><cf_get_lang dictionary_id ='29629.Fire Fişi'></th>
                            <th><cf_get_lang dictionary_id ='40227.Depolararası Sevk'></th>
                            <cfif listfind(attributes.is_view,0,',')>
                                <th></th>
                                <th><cf_get_lang dictionary_id ='40732.Sonuç Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40204.Br Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40023.Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40203.Toplam Maliyet'></th>
                            </cfif>
                            <cfif listfind(attributes.is_view,1,',')>
                                <th></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='39140.Sarf Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='39142.Sarf Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40196.Sarf'><cf_get_lang dictionary_id ='40023.Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40412.SB Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40413.SB Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40414.SB Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam '><cf_get_lang dictionary_id ='39140.Sarf Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam '><cf_get_lang dictionary_id ='39142.Sarf Maliyet'></th>
                            </cfif>
                            <cfif listfind(attributes.is_view,3,',')>
                                <th></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='39141.Fire Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='39143.Fire Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='29471.Fire'><cf_get_lang dictionary_id ='40023.Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40412.SB Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40413.SB Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40414.SB Ek Maliyet'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam '> <cf_get_lang dictionary_id ='39141.Fire Miktar'></th>
                                <th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam '> <cf_get_lang dictionary_id ='39143.Fire Maliyet'></th>
                            </cfif>
                        </tr>
                    </thead>
                </cfoutput>
                    <tbody>
                        <cfif GET_PRODUCTION.recordcount>
                            
                            <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                <cfset attributes.startrow=1>
                                <cfset attributes.maxrows=GET_PRODUCTION.recordcount>
                            </cfif>
                        </cfif>
                        <cfif GET_PRODUCTION.RECORDCOUNT>
                            <cfoutput query="GET_PRODUCTION" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#CURRENTROW#</td>
                                    <td><cfif isdefined("order_list_#p_order_id#")>#evaluate("order_list_#p_order_id#")#</cfif></td>
                                    <td>#P_ORDER_NO#</td>
                                    <td>#RESULT_NO#</td>
                                    <td><cfif isdefined("order_member_#p_order_id#")>#evaluate("order_member_#p_order_id#")#</cfif></td>
                                    <td>#STOCK_CODE#</td>
                                    <td>#PRODUCT_NAME# #PROPERTY#</td>
                                    <td><cfif TYPE eq 1>#SPECT_MAIN_ID#<cfelse></cfif></td>
                                    <td>#GET_PROCESS.STAGE[listfind(process_list,PROD_ORD_RESULT_STAGE,',')]#</td>
                                    <td>
                                        <cfif isdefined('PAPER_NUMBER_110') and len (PAPER_NUMBER_110)>
                                            <cfif type_ eq 1>
                                                #PAPER_NUMBER_110#
                                            <cfelse>	
                                                <cfif dateformat(FINISH_DATE,'yyyy') eq session.ep.period_year>
                                                    <a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#PAPER_ID_110#" target="_blank">#PAPER_NUMBER_110#</a>
                                                <cfelse>
                                                    #PAPER_NUMBER_110#
                                                </cfif>
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <td>
                                        <cfif isdefined('PAPER_NUMBER_111')>
                                            <cfif type_ eq 1>
                                                #PAPER_NUMBER_111#
                                            <cfelse>
                                                <cfif dateformat(FINISH_DATE,'yyyy') eq session.ep.period_year>
                                                    <a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#PAPER_ID_111#" target="_blank">#PAPER_NUMBER_111#</a>
                                                <cfelse>
                                                    #PAPER_NUMBER_111#
                                                </cfif>
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <td>
                                        <cfif isdefined('PAPER_NUMBER_112')>
                                            <cfif type_ eq 1>
                                                #PAPER_NUMBER_112#
                                            <cfelse>
                                                <cfif dateformat(FINISH_DATE,'yyyy') eq session.ep.period_year>
                                                    <a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#PAPER_ID_112#" target="_blank">#PAPER_NUMBER_112#</a>
                                                <cfelse>
                                                    #PAPER_NUMBER_112#
                                                </cfif>
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <td>
                                        <cfif isdefined('PAPER_NUMBER_81')>
                                            <cfif type_ eq 1>
                                                #PAPER_NUMBER_81#
                                            <cfelse>
                                                <cfif dateformat(FINISH_DATE,'yyyy') eq session.ep.period_year>
                                                    <a href="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#PAPER_ID_81#" target="_blank">#PAPER_NUMBER_81#</a>
                                                <cfelse>
                                                    #PAPER_NUMBER_81#
                                                </cfif>
                                            </cfif>
                                        <cfelseif isdefined('PAPER_NUMBER_113') and len(PAPER_NUMBER_113)>
                                            <cfif type_ eq 1>
                                                #PAPER_ID_113#
                                            <cfelse>
                                                <cfif dateformat(FINISH_DATE,'yyyy') eq session.ep.period_year>
                                                    <a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#PAPER_ID_113#" target="_blank">#PAPER_ID_113#</a>
                                                <cfelse>
                                                    #PAPER_ID_113#
                                                </cfif>
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <cfif listfind(attributes.is_view,0,',')>
                                        <cfif TYPE eq 1>
                                            <td></td>
                                            <td align="right" style="text-align:right;" format="numeric">#TLFormat(AMOUNT)#</td>
                                            <td align="right" style="text-align:right;" format="numeric">#TLFormat(PURCHASE_NET_SYSTEM)#</td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif len(PURCHASE_EXTRA_COST_SYSTEM)>#TLFormat(PURCHASE_EXTRA_COST_SYSTEM)#</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric">
                                                <cfset row_total_net=0>
                                                <cfset row_total_extra=0>
                                                <cfif len(PURCHASE_NET_SYSTEM)>
                                                    <cfset row_total_net=PURCHASE_NET_SYSTEM*AMOUNT>
                                                </cfif>
                                                <cfif len(PURCHASE_EXTRA_COST_SYSTEM)>
                                                    <cfset row_total_extra=PURCHASE_EXTRA_COST_SYSTEM*AMOUNT>
                                                </cfif>
                                                #TLFormat(row_total_net+row_total_extra)#
                                            </td>
                                        <cfelse>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                        </cfif>
                                    </cfif>
                                    <cfif listfind(attributes.is_view,1,',')>
                                        <cfif type eq 2>
                                            <td></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 0>#TLFormat(AMOUNT)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 0>#TLFormat(PURCHASE_NET_SYSTEM)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 0>#TLFormat(PURCHASE_EXTRA_COST_SYSTEM)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 1>#TLFormat(AMOUNT)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 1>#TLFormat(PURCHASE_NET_SYSTEM)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 1>#TLFormat(PURCHASE_EXTRA_COST_SYSTEM)#<cfelse>0</cfif></td>
                                            <td format="numeric">#TLFormat(AMOUNT)#</td>
                                            <td format="numeric">
                                                <cfset row_total_net_sf=0>
                                                <cfset row_total_extra_sf=0>
                                                <cfif len(PURCHASE_NET_SYSTEM)>
                                                    <cfset row_total_net_sf=PURCHASE_NET_SYSTEM*AMOUNT>
                                                </cfif>
                                                <cfif len(PURCHASE_EXTRA_COST_SYSTEM)>
                                                    <cfset row_total_extra_sf=PURCHASE_EXTRA_COST_SYSTEM*AMOUNT>
                                                </cfif>
                                                #TLFormat(row_total_net_sf+row_total_extra_sf)#
                                            </td>
                                        <cfelse>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>			
                                        </cfif>
                                    </cfif>
                                    <cfif listfind(attributes.is_view,3,',')>
                                        <cfif type eq 3>
                                            <td></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 0>#TLFormat(AMOUNT)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 0>#TLFormat(PURCHASE_NET_SYSTEM)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 0>#TLFormat(PURCHASE_EXTRA_COST_SYSTEM)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 1>#TLFormat(AMOUNT)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 1>#TLFormat(PURCHASE_NET_SYSTEM)#<cfelse>0</cfif></td>
                                            <td align="right" style="text-align:right;" format="numeric"><cfif IS_SEVKIYAT eq 1>#TLFormat(PURCHASE_EXTRA_COST_SYSTEM)#<cfelse>0</cfif></td>
                                            <td format="numeric">#TLFormat(AMOUNT)#</td>
                                            <td format="numeric">
                                                <cfset row_total_net_fr=0>
                                                <cfset row_total_extra_fr=0>
                                                <cfif len(PURCHASE_NET_SYSTEM)>
                                                    <cfset row_total_net_fr=PURCHASE_NET_SYSTEM*AMOUNT>
                                                </cfif>
                                                <cfif len(PURCHASE_EXTRA_COST_SYSTEM)>
                                                    <cfset row_total_extra_fr=PURCHASE_EXTRA_COST_SYSTEM*AMOUNT>
                                                </cfif>
                                                #TLFormat(row_total_net_fr+row_total_extra_fr)#
                                            </td>
                                        <cfelse>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>			
                                        </cfif>
                                    </cfif>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr height="20">
                                <cfset colspan_ = 13>
                                <cfif listfind(attributes.is_view,0,',')>
                                    <cfset colspan_ = colspan_ + 5>
                                    <cfif isdefined("attributes.is_order_amount")>
                                        <cfset colspan_ = colspan_ + 1>
                                    </cfif>
                                </cfif>
                                <cfif listfind(attributes.is_view,1,',')>
                                    <cfset colspan_ = colspan_ + 9>
                                </cfif>
                                <cfif listfind(attributes.is_view,3,',')>
                                    <cfset colspan_ = colspan_ + 9>
                                </cfif>
                                <cfif xml_show_manufact_code>
                                    <cfset colspan_ = colspan_ + 1>
                                </cfif>
                                <td colspan="40"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif>
                    </tbody>

                </cfif>
            <!--- </table> --->
        </cfif>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset url_str = "report.production_analyse">
    <cfif isdefined("attributes.submitted") and len(attributes.submitted)>
		<cfset url_str = "#url_str#&submitted=#attributes.submitted#">
	</cfif>
	<cfif isdefined("attributes.module_id_control") and len(attributes.module_id_control)>
		<cfset url_str = "#url_str#&module_id_control=#attributes.module_id_control#">
	</cfif>
	<cfif isDefined('attributes.PRODUCT_CAT_CODE') and len(attributes.PRODUCT_CAT_CODE)>
		<cfset url_str = '#url_str#&PRODUCT_CAT_CODE=#attributes.PRODUCT_CAT_CODE#'>
	</cfif>
	<cfif isDefined('attributes.MEMBER_TYPE') and len(attributes.MEMBER_TYPE)>
		<cfset url_str = '#url_str#&MEMBER_TYPE=#attributes.MEMBER_TYPE#'>
	</cfif>
	<cfif isDefined('attributes.PRODUCT_ID') and len(attributes.PRODUCT_ID)>
		<cfset url_str = '#url_str#&PRODUCT_ID=#attributes.PRODUCT_ID#'>
	</cfif>
    <cfif isDefined('attributes.PRODUCT_NAME') and len(attributes.PRODUCT_NAME)>
		<cfset url_str = '#url_str#&PRODUCT_NAME=#attributes.PRODUCT_NAME#'>
	</cfif>
	<cfif isDefined('attributes.SARF_PRODUCT_ID') and len(attributes.SARF_PRODUCT_ID)>
		<cfset url_str = '#url_str#&SARF_PRODUCT_ID=#attributes.SARF_PRODUCT_ID#'>
	</cfif>
	<cfif isDefined('attributes.FIRE_PRODUCT_ID') and len(attributes.FIRE_PRODUCT_ID)>
		<cfset url_str = '#url_str#&FIRE_PRODUCT_ID=#attributes.FIRE_PRODUCT_ID#'>
	</cfif>
	<cfif isDefined('attributes.start_date1') and len(attributes.start_date1)>
		<cfset url_str = '#url_str#&start_date1=#dateformat(attributes.start_date1,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.finish_date1') and len(attributes.finish_date1)>
		<cfset url_str = '#url_str#&finish_date1=#dateformat(attributes.finish_date1,dateformat_style)#'>
	</cfif>
    <cfif isDefined('attributes.start_date2') and len(attributes.start_date2)>
		<cfset url_str = '#url_str#&start_date2=#dateformat(attributes.start_date2,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.finish_date2') and len(attributes.finish_date2)>
		<cfset url_str = '#url_str#&finish_date2=#dateformat(attributes.finish_date2,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.station_id_') and len(attributes.station_id_)>
		<cfset url_str = '#url_str#&station_id_=#attributes.station_id_#'>
	</cfif>
	<cfif isDefined('attributes.BRAND_ID') and len(attributes.BRAND_ID)>
		<cfset url_str = '#url_str#&BRAND_ID=#attributes.BRAND_ID#'>
	</cfif>
	<cfif isDefined('attributes.spec_id') and len(attributes.spec_id)>
		<cfset url_str = '#url_str#&spec_id=#attributes.spec_id#'>
	</cfif>
	<cfif isDefined('attributes.spec_name') and len(attributes.spec_name)>
		<cfset url_str = '#url_str#&spec_name=#attributes.spec_name#'>
	</cfif>
	<cfif isDefined('attributes.sarf_spec_id') and len(attributes.sarf_spec_id)>
		<cfset url_str = '#url_str#&sarf_spec_id=#attributes.sarf_spec_id#'>
	</cfif>
	<cfif isDefined('attributes.sarf_spec_name') and len(attributes.sarf_spec_name)>
		<cfset url_str = '#url_str#&sarf_spec_name=#attributes.sarf_spec_name#'>
	</cfif>
	<cfif isDefined('attributes.fire_spec_id') and len(attributes.fire_spec_id)>
		<cfset url_str = '#url_str#&fire_spec_id=#attributes.fire_spec_id#'>
	</cfif>
	<cfif isDefined('attributes.fire_spec_name') and len(attributes.fire_spec_name)>
		<cfset url_str = '#url_str#&fire_spec_name=#attributes.fire_spec_name#'>
	</cfif>
	<cfif isDefined('attributes.project_head') and len(attributes.project_head)>
		<cfset url_str = '#url_str#&project_head=#attributes.project_head#'>
	</cfif>
	<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
		<cfset url_str = '#url_str#&project_id=#attributes.project_id#'>
	</cfif>
	<cfif isDefined('attributes.stock_fis_status') and len(attributes.stock_fis_status)>
		<cfset url_str = '#url_str#&stock_fis_status=#attributes.stock_fis_status#'>
	</cfif>
    <cfif isDefined('attributes.totalrecords') and len(attributes.totalrecords)>
		<cfset url_str = '#url_str#&totalrecords=#attributes.totalrecords#'>
	</cfif>
    <cfif isDefined('attributes.is_view') and len(attributes.is_view)>
		<cfset url_str = '#url_str#&is_view=#attributes.is_view#'>
	</cfif>
    <cfif isDefined('attributes.REPORT_TYPE') and len(attributes.REPORT_TYPE)>
		<cfset url_str = '#url_str#&REPORT_TYPE=#attributes.REPORT_TYPE#'>
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
            if(!date_check(production_report.start_date1,production_report.start_date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
			return false;
           
            if(!date_check(production_report.finish_date1,production_report.finish_date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
			return false;       
            if(document.production_report.is_view[0].checked==false && document.production_report.is_view[1].checked==false && document.production_report.is_view[2].checked==false && document.production_report.is_view[3].checked==false)
            {
                alert("<cf_get_lang dictionary_id ='40406.En az bir tane gösterilecek kriter seçiniz'>!");
                return false;
            }
        if(document.production_report.is_excel.checked==false)
			{
                document.production_report.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			    return true;
			}
			else
				document.production_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_production_analyse</cfoutput>"
	
		if(document.production_report.product_cat.value=='')document.production_report.product_cat_code.value='';
		if(document.production_report.member_name.value=='')document.production_report.member_type.value='';
	   // if(document.production_report.product_brand.value=='')document.production_report.product_brand_id.value='';
		if(document.production_report.product_name.value=='')document.production_report.product_id.value='';
		if(document.production_report.spec_name.value=='')document.production_report.spec_id.value='';
		if(document.production_report.sarf_product_name.value=='')document.production_report.sarf_product_id.value='';
		if(document.production_report.sarf_spec_name.value=='')document.production_report.sarf_spec_id.value='';
		if(document.production_report.fire_product_name.value=='')document.production_report.fire_product_id.value='';
		if(document.production_report.fire_spec_name.value=='')document.production_report.fire_spec_id.value='';
		/*if(date_check(document.getElementById('start_date1'), document.getElementById('start_date2'),'Birinci Tarih Alanı İkinci Tarih Alanından Büyük Olamaz!')==false)
			return false;
		if(date_check(document.getElementById('start_date1'), document.getElementById('finish_date1'),'Birinci Tarih Alanı İkinci Tarih Alanından Büyük Olamaz!')==false)
			return false;
		if(date_check(document.getElementById('start_date1'), document.getElementById('finish_date2'),'Birinci Tarih Alanı İkinci Tarih Alanından Büyük Olamaz!')==false)
			return false;
		if(date_check(document.getElementById('finish_date1'), document.getElementById('finish_date2'),'Birinci Tarih Alanı İkinci Tarih Alanından Büyük Olamaz!')==false)
			return false;
		if(date_check(document.getElementById('start_date2'), document.getElementById('finish_date1'),'Birinci Tarih Alanı İkinci Tarih Alanından Büyük Olamaz!')==false)
			return false;
		if(date_check(document.getElementById('start_date2'), document.getElementById('finish_date2'),'Birinci Tarih Alanı İkinci Tarih Alanından Büyük Olamaz!')==false)
			return false;*/
		
		if(document.production_report.report_type.value == 11)
		{
			document.production_report.is_view[3].value = 0;
			document.production_report.is_view[3].checked = false;
			document.production_report.is_order_amount.value = 0;	
			document.production_report.is_order_amount.checked = false;				
        }
        
    }
      function detay_gizle()
    {
        if(document.getElementById('report_type').value == 12 || document.getElementById('report_type').value == 11)
        document.production_report.is_view[3].disabled = true;
        else 
        document.production_report.is_view[3].disabled = false;
       
    } 
</script>
