<cfsetting showdebugoutput="yes">
<cfif not isdefined("is_stock_based_cost")>
	<cfset is_stock_based_cost = session.ep.our_company_info.is_stock_based_cost>
</cfif>
<cfparam name="toplam_kayit" default="0">
<cfparam name="son_deger" default="0">
<cfparam name="attributes.loop_count" default="1">
<cfparam name="attributes.from_count" default="1">
<cfif not isdefined("attributes.page")>
	<cfparam name="attributes.page" default="1">
</cfif>
<cfparam name="attributes.maxrows" default="100">
<cfset attributes.startrow = (attributes.page-1)*attributes.maxrows+1 >
<cf_xml_page_edit fuseact="settings.add_new_cost">
<cfflush interval="100">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">

<cfquery name="get_periods" datasource="#dsn#">
	SELECT 
        PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        OTHER_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP,
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        PROCESS_DATE	 
    FROM 
    	SETUP_PERIOD
	WHERE
		<cfif not(isdefined("attributes.is_fifo") and attributes.is_fifo eq 1)>
			INVENTORY_CALC_TYPE = 3
		<cfelse>
			INVENTORY_CALC_TYPE = 1
		</cfif>
    ORDER BY 
	    OUR_COMPANY_ID,PERIOD_YEAR DESC
</cfquery>
<cfif len(attributes.product_id) and len(attributes.product_name)>
	<cfset last_char = right(attributes.product_name,1)>
	<cfif last_char eq '-'>
		<cfset attributes.product_name = left(attributes.product_name,len(attributes.product_name)-1)>
	</cfif>
	<cfquery name="get_product" datasource="#dsn1#">
		SELECT PRODUCT_CODE, PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.product_name#">
	</cfquery>
</cfif>
<cfif not isdefined("attributes.step")>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfsavecontent  variable="head">
			<cf_get_lang dictionary_id='44088.Maliyet İşlemleri'> - <cfif not(isdefined("attributes.is_fifo") and attributes.is_fifo eq 1)><cf_get_lang dictionary_id='45380.Ağırlıklı Ortalama'><cfelse><cf_get_lang dictionary_id='40257.İlk Giren İlk Çıkar'></cfif>
		</cfsavecontent>
		<cf_box title="#head#">
			<cfform name="form_" method="post" action="">
				<cf_box_elements>							
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-kaynak-period">
							<label class="col col-5 col-md-5 col-sm-5 col-xs-12">
								<cf_get_lang dictionary_id='52925.Kaynak Dönem'>* 
							</label>
							<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
								<select name="kaynak_period_1" id="kaynak_period_1" style="width:175px">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_periods">
										<option value="#period_id#" <cfif isdefined("attributes.kaynak_period_1") and attributes.kaynak_period_1 eq period_id>selected</cfif>>#period# - (#period_year#)</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-start-date">
							<label class="col col-5 col-md-5 col-sm-5 col-xs-12">
								<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*
							</label>
							<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="date1" value="#attributes.date1#" validate="#validate_style#" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-finish-date">
							<label class="col col-5 col-md-5 col-sm-5 col-xs-12">
								<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>
							</label>
							<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="date2" value="#attributes.date2#" validate="#validate_style#" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
								</div>
							</div>
						</div>
						
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">						
						<cfif not(isdefined("attributes.is_fifo") and attributes.is_fifo eq 1)>
							<div class="form-group" id="item-product">
								<label class="col col-5 col-md-5 col-sm-5 col-xs-12">
									<cf_get_lang dictionary_id='57657.Ürün'>
								</label>
								<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
										<input type="text" name="product_name" id="product_name" style="width:175px;" value="<cfoutput>#attributes.product_name#</cfoutput>"  onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','200');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form_.product_id&field_name=form_.product_name','list');"></span>
									</div>
								</div>
							</div>
						</cfif>
						<cfif not(isdefined("attributes.is_fifo") and attributes.is_fifo eq 1)>
							<div class="form-group" id="item-belge-no">
								<label class="col col-5 col-md-5 col-sm-5 col-xs-12">
									<cf_get_lang dictionary_id='57880.Belge No'>
								</label>
								<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
									<input type="text" name="paper_no" id="paper_no" style="width:65px;" value="<cfif isdefined('attributes.paper_no') and len(attributes.paper_no)><cfoutput>#attributes.paper_no#</cfoutput></cfif>">
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-rapor-step">
							<label class="col col-5 col-md-5 col-sm-5 col-xs-12">
								<cf_get_lang dictionary_id='44109.Rapor Başlangıç Adımı'>
							</label>
							<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
								<select name="up_step" id="up_step" style="width:175px">
									<option value="1" <cfif isdefined('attributes.up_step') and attributes.up_step eq 1>selected</cfif>><cf_get_lang dictionary_id='44108.Silme İşlemi'></option>
									<cfif not(isdefined("attributes.is_fifo") and attributes.is_fifo eq 1)>
										<option value="2" <cfif isdefined('attributes.up_step') and attributes.up_step eq 2>selected</cfif>><cf_get_lang dictionary_id='44107.Belgelerden Oluşturma'></option>
										<cfif x_is_prod_cost eq 1>
											<option value="3" <cfif isdefined('attributes.up_step') and attributes.up_step eq 3>selected</cfif>><cf_get_lang dictionary_id='44106.Üretimden Oluşturma'></option>
										</cfif>
										<cfif x_is_total_cost eq 1>
											<option value="4" <cfif isdefined('attributes.up_step') and attributes.up_step eq 4>selected</cfif>><cf_get_lang dictionary_id='64231.Kümüle Maliyet Oluşturma'></option>
										</cfif>
										<cfif x_is_upd_inv eq 1>
											<option value="5" <cfif isdefined('attributes.up_step') and attributes.up_step eq 5>selected</cfif>><cf_get_lang dictionary_id='64232.Çıkış İşlemlerinin Güncellenmesi'></option>
										</cfif>
									<cfelse>
										<option value="2" <cfif isdefined('attributes.up_step') and attributes.up_step eq 2>selected</cfif>><cf_get_lang dictionary_id='64233.Stok Hareketi Kapama'></option>
										<cfif x_is_prod_cost eq 1>
											<option value="3" <cfif isdefined('attributes.up_step') and attributes.up_step eq 3>selected</cfif>><cf_get_lang dictionary_id='64234.Üretim Fişlerinin Güncellenmesi'></option>
										</cfif>
										<cfif x_is_upd_inv eq 1>
											<option value="5" <cfif isdefined('attributes.up_step') and attributes.up_step eq 5>selected</cfif>><cf_get_lang dictionary_id='64235.Satış Faturaları ve Satış İrsaliyelerin Güncellenmesi'></option>
										</cfif>
									</cfif>
								</select>
							</div>
						</div>
						
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="3" type="column" sort="true">
						<cfif not(isdefined("attributes.is_fifo") and attributes.is_fifo eq 1)>
							<div class="form-group" id="item-upd-belge">
								<label class="col col-10 col-md-10 col-sm-10 col-xs-12">
									<cf_get_lang dictionary_id='44087.Oluşmuş Belgeleri de Güncelle'>
								</label>
								<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
									<input type="checkbox" name="is_cost_again" id="is_cost_again" value="1" <cfif isdefined('attributes.is_cost_again')>checked</cfif>>
								</div>
							</div>
							<cfif x_is_inv_cost eq 1>
								<div class="form-group" id="item-demir-upd">
									<label class="col col-10 col-md-10 col-sm-10 col-xs-12">
										<cf_get_lang dictionary_id='64236.Demirbaş Fişleri Güncellensin'>
									</label>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
										<input type="checkbox" name="is_invent_again" id="is_invent_again" value="1" <cfif isdefined('attributes.is_invent_again')>checked</cfif>>
									</div>
								</div>
							</cfif>
							<input type="hidden" name="is_location_based_cost" id="is_location_based_cost" value="<cfif session.ep.our_company_info.is_cost_location><cfoutput>#session.ep.our_company_info.is_cost_location#</cfoutput><cfelse>0</cfif>">
							<cfif x_is_date_kontrol eq 1>
								<div class="form-group" id="item-date-control">
									<label class="col col-10 col-md-10 col-sm-10 col-xs-12">
										<cf_get_lang dictionary_id='64237.Sadece Seçilen Tarih Aralığındaki Maliyetler Güncellensin'>
									</label>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
										<input type="checkbox" name="is_date_kontrol" id="is_date_kontrol" value="1" <cfif isdefined('attributes.is_date_kontrol')>checked</cfif>>
									</div>
								</div>
							</cfif>
							<cfif x_del_all_cost eq 1>
								<div class="form-group" id="item-manuel-cost">
									<label class="col col-10 col-md-10 col-sm-10 col-xs-12">
										<cf_get_lang dictionary_id='64238.Silme İşleminde Manuel Girilen Maliyetler Silinsin'>
									</label>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
										<input type="checkbox" name="is_manuel_cost" id="is_manuel_cost" value="1" <cfif isdefined('attributes.is_manuel_cost')>checked</cfif>>
									</div>
								</div>
							</cfif>
						</cfif>
						<!---<cfif not(isdefined("attributes.is_fifo") and attributes.is_fifo eq 1) and x_is_date_kontrol eq 1>--->
							<div class="form-group" id="item-otomatik">
								<label class="col col-10 col-md-10 col-sm-10 col-xs-12">
									<cf_get_lang dictionary_id='64239.Otomatik Geçiş'>
								</label>
								<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
									<input type="checkbox" <cfif isdefined("attributes.is_oto")>checked</cfif> name="is_oto" id="is_oto" />
								</div>
							</div>
						<!---</cfif>--->
					</div>			
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<font color="red"><cf_get_lang no ='2122.Bu İşlem Kaynak Yıla Ait Dönemde Bulunan Maliyet İşlemlerinizi Düzenler Sayfa Görüntülendikten sonra maliyet işlemleri çalışmaya başlayacaktır Lütfen Sayfayı Yenilemeyin'></font>
							<cfif not(isdefined("attributes.is_fifo") and attributes.is_fifo eq 1) and x_is_date_kontrol eq 1>
								<br/><br/>
								<font color="red">("<b><cf_get_lang dictionary_id='64237.Sadece Seçilen Tarih Aralığındaki Maliyetler Güncellensin'></b>" <cf_get_lang dictionary_id='64240.seçeneği periyodik olarak maliyet çalıştırma işlemlerinde mükerrer güncellemeleri engellemek için eklendi , bu seçeneği seçerseniz sonraki tarihlerde de mutlaka maliyet işlemini çalıştırmalısınız.'>)</font>
							</cfif>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<input type="button" value="<cf_get_lang dictionary_id='58676.Aktar'>" onClick="basamak_1();" class="pull-right">
					</div>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>

</cfif>
<cfif isdefined("attributes.kaynak_period_1") and isdefined("attributes.kaynak_period_1")>

	<cfif not len(attributes.kaynak_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='52931.Kaynak Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT 
            PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID, 
            OTHER_MONEY, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP,
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            PROCESS_DATE,
			INVENTORY_CALC_TYPE	 
        FROM 
	        SETUP_PERIOD 
        WHERE 
        	PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.kaynak_period_1#">
	</cfquery>
	<form action="<cfoutput>#request.self#?fuseaction=settings.popupflush_add_new_cost&isAjax=1</cfoutput>" name="form1_" method="post">
        <cfif isdefined("attributes.is_oto")>
        	<input type="hidden" name="is_oto" id="is_oto" value="1" />
        </cfif>
        <cfif isdefined("attributes.is_fifo")>
        	<input type="hidden" name="is_fifo" id="is_fifo" value="1" />
        </cfif>
        <input type="hidden" name="step" id="step" value="<cfif isdefined('attributes.up_step')><cfoutput>#attributes.up_step#</cfoutput><cfelse>1</cfif>">
		<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
		<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfoutput>#attributes.date1#</cfoutput>">
		<input type="hidden" name="aktarim_date2" id="aktarim_date2" value="<cfoutput>#attributes.date2#</cfoutput>">
		<input type="hidden" name="aktarim_product_name" id="aktarim_product_name" value="<cfoutput>#attributes.product_name#</cfoutput>">
		<input type="hidden" name="aktarim_product_id" id="aktarim_product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
		<input type="hidden" name="aktarim_paper_no" id="aktarim_paper_no" value="<cfif isdefined('attributes.paper_no') and len(attributes.paper_no)><cfoutput>#attributes.paper_no#</cfoutput></cfif>">
		<cfif isdefined('attributes.is_cost_again') and len(attributes.is_cost_again)>
        <input type="hidden" name="aktarim_is_cost_again" id="aktarim_is_cost_again" value="<cfoutput>#attributes.is_cost_again#</cfoutput>"></cfif>
		<cfif isdefined('attributes.is_invent_again') and len(attributes.is_invent_again)>
        <input type="hidden" name="aktarim_is_invent_again" id="aktarim_is_invent_again" value="<cfoutput>#attributes.is_invent_again#</cfoutput>"></cfif>
		<cfif isdefined('attributes.is_date_kontrol') and len(attributes.is_date_kontrol)>
        	<input type="hidden" name="aktarim_is_date_kontrol" id="aktarim_is_date_kontrol" value="<cfoutput>#attributes.is_date_kontrol#</cfoutput>">
		</cfif>
		<cfif isdefined('attributes.is_manuel_cost') and len(attributes.is_manuel_cost)>
        	<input type="hidden" name="aktarim_is_manuel_cost" id="aktarim_is_manuel_cost" value="<cfoutput>#attributes.is_manuel_cost#</cfoutput>">
		</cfif>
		<cfif attributes.is_location_based_cost>
        	<input type="hidden" name="aktarim_is_location_based_cost" id="aktarim_is_location_based_cost" value="<cfoutput>#attributes.is_location_based_cost#</cfoutput>">
        </cfif>
		<input type="hidden" name="session_userid" id="session_userid" value="<cfoutput>#session.ep.userid#</cfoutput>">
		<input type="hidden" name="session_period_id" id="session_period_id" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<input type="hidden" name="session_money" id="session_money" value="<cfoutput>#session.ep.money#</cfoutput>">
		<input type="hidden" name="session_money2" id="session_money2" value="<cfoutput>#session.ep.money2#</cfoutput>">
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box>
				<div class="ui-info-text">
					<p><cf_get_lang dictionary_id='52932.Kaynak Veri Tabanı'>: <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput></p>
					<p><cf_get_lang dictionary_id ='57657.Ürün'>: <cfif isdefined("get_product.recordcount")><cfoutput>#get_product.PRODUCT_CODE# - #get_product.PRODUCT_NAME#</cfoutput><cfelse><cf_get_lang dictionary_id='31053.Seçim yapmadınız'></cfif></p>
					<p><cf_get_lang dictionary_id='58690.Tarih Aralığı'>: <cfoutput>#attributes.DATE1# - #attributes.DATE2#</cfoutput></p>
					<p><cf_get_lang dictionary_id='44087.Oluşmuş Belgeleri de Güncelle'> : <cfif isDefined("attributes.is_cost_again")><cf_get_lang dictionary_id='57495.Yes'><cfelse><cf_get_lang dictionary_id='31053.Seçim yapmadınız'></cfif></p>
					<p><cfif x_is_inv_cost eq 1><cf_get_lang dictionary_id='64236.Demirbaş Fişleri Güncellensin'> : <cfif isDefined("attributes.is_invent_again")><cf_get_lang dictionary_id='57495.Yes'><cfelse><cf_get_lang dictionary_id='31053.Seçim yapmadınız'></cfif></cfif></p>
					<p><cfif x_is_date_kontrol eq 1><cf_get_lang dictionary_id='64237.Sadece Seçilen Tarih Aralığındaki Maliyetler Güncellensin'> : <cfif isDefined("attributes.is_date_kontrol")><cf_get_lang dictionary_id='57495.Yes'><cfelse><cf_get_lang dictionary_id='31053.Seçim yapmadınız'></cfif></cfif></p>
					<p><cfif x_del_all_cost eq 1><cf_get_lang dictionary_id='64238.Silme İşleminde Manuel Girilen Maliyetler Silinsin'> : <cfif isDefined("attributes.is_manuel_cost")><cf_get_lang dictionary_id='57495.Yes'><cfelse><cf_get_lang dictionary_id='31053.Seçim yapmadınız'></cfif></cfif></p>
					<p>Otomatik Geçiş : <cfif isDefined("attributes.is_oto")><cf_get_lang dictionary_id='57495.Yes'><cfelse><cf_get_lang dictionary_id='31053.Seçim yapmadınız'></cfif></p>
					<div><input type="button" value="<cf_get_lang dictionary_id='44010.Aktarımı Başlat'>" onClick="basamak_2();"></div>
				</div>
			</cf_box>
		</div>
	</form>
</cfif>
<cfif isdefined("attributes.is_fifo") and attributes.is_fifo eq 1><!--- ilk giren ilk çıkar ise --->
	<cfinclude template="add_new_cost_fifo.cfm">
<cfelse>
	<cfinclude template="add_new_cost_gpa.cfm">
</cfif>
<script type="text/javascript">
	function basamak_1()
		{
		if(document.form_.date1.value=='' && document.form_.date2.value=='')
		{
			alert("<cf_get_lang dictionary_id='44091.Tarih Koşullarından En az Birini Girmelisiniz'>!");
			return false;
		}
		if(document.form_.date2.value!='' && document.form_.date1.value=='')
		{
			alert("<cf_get_lang dictionary_id='39354.Başlangıç Tarihini Giriniz'>!");
			return false;
		}
		if(!chk_period(document.form_.date1,"İşlem")) return false;
		if(document.form_.date1.value!='' && document.form_.date2.value!='')
			if(!date_check(document.form_.date1, document.form_.date2, "<cf_get_lang dictionary_id='44090.Başlangıç Tarihi Küçük Olmalıdır'>"))
				return false;
		
		if(confirm("<cf_get_lang dictionary_id='44089.Maliyet İşlemini Çalıştıracaksınız. Emin misiniz?'>?"))
			document.form_.submit();
		else 
			return false;
		}
		
	function basamak_2()
		{
		if(confirm("<cf_get_lang dictionary_id='44089.Maliyet İşlemini Çalıştıracaksınız. Emin misiniz?'>?"))
			document.form1_.submit();
		else
			return false;
		}
		
		<cfif isdefined("attributes.step") and attributes.step eq 2>
			<cfif toplam_kayit neq son_deger>
				function submitForm() 
				{ 
					// submits form
					document.forms["step2"].submit();
				}
				if (document.getElementById("step2")) 
					{
						setTimeout("submitForm()", 5000); // set timout 
					}
			
			
			<cfelse>
				<cfif isdefined("attributes.is_oto") and attributes.is_oto eq 1 and x_is_prod_cost eq 1>
					function submitForm() 
					{ 
						// submits form
						document.forms["step2"].submit();
					}
					if (document.getElementById("step2")) 
						{
							setTimeout("submitForm()", 5000); // set timout 
						}
				</cfif>	
			</cfif>
		</cfif>
		
		<cfif isdefined("attributes.step") and attributes.step eq 3>
			<cfif toplam_kayit neq son_deger>
				function submitForm() 
				{ 
					// submits form
					document.forms["step3"].submit();
				}
				if (document.getElementById("step3")) 
					{
						setTimeout("submitForm()", 5000); // set timout 
					}
			<cfelse>
				<cfif isdefined("attributes.is_oto") and attributes.is_oto eq 1>
					function submitForm() 
						{ 
							// submits form
							document.forms["step3"].submit();
						}
						if (document.getElementById("step3")) 
							{
								setTimeout("submitForm()", 5000); // set timout 
							}
				</cfif>
			</cfif>
		</cfif>
		
	
	<cfif isdefined("attributes.step") and attributes.step eq 1>
		<cfif toplam_kayit neq son_deger>
			function submitForm() 
			{ 
				// submits form
				document.forms["step1"].submit();
			}
			if (document.getElementById("step1")) 
				{
					setTimeout("submitForm()", 5000); // set timout 
				}
		<cfelse>
				<cfif isdefined("attributes.is_oto") and attributes.is_oto eq 1>		
					function submitForm() 
						{ 
							// submits form
							document.forms["step1"].submit();
						}
						if (document.getElementById("step1")) 
							{
								setTimeout("submitForm()", 5000); // set timout 
							}
				</cfif>
		</cfif>
	</cfif>
	
	<cfif isdefined("attributes.step") and attributes.step eq 4>
		<cfif isdefined("attributes.is_oto") and attributes.is_oto eq 1>		
			function submitForm() 
				{ 
					// submits form
					document.forms["step4"].submit();
				}
				if (document.getElementById("step4")) 
					{
						setTimeout("submitForm()", 5000); // set timout
					}
		</cfif>
	</cfif>		
</script>
