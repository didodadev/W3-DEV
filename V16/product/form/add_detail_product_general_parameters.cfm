<cfparam name="attributes.our_company_id" default="#session.ep.company_id#">
<cfquery name="get_product" datasource="#dsn3#">
	SELECT * FROM PRODUCT WHERE PRODUCT_ID = #attributes.pid#
</cfquery>
<cfquery name="GET_POS_ID" datasource="#DSN#">
    SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfquery name="get_parameter" datasource="#dsn1#">
	SELECT 
    	PGR.*,
        P.COMPANY_ID,
        P.PRODUCT_MANAGER 
    FROM 
    	PRODUCT_GENERAL_PARAMETERS PGR 
    	LEFT JOIN PRODUCT P ON P.PRODUCT_ID = PGR.PRODUCT_ID
	WHERE
    	PGR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
        AND PGR.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
</cfquery>
<cf_box title="#get_product.product_name#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_add_product" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_product_general_parameters&pid=#attributes.pid#">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <input type="hidden" name="barcod" id="barcod" value="<cfoutput>#attributes.barcod#</cfoutput>" />
                <cfquery name="get_companies" datasource="#DSN#">
                    SELECT DISTINCT
                        COMP_ID,
                        COMPANY_NAME
                    FROM 
                        SETUP_PERIOD SP, 
                        EMPLOYEE_POSITION_PERIODS EP ,
                        OUR_COMPANY O
                    WHERE 
                        EP.PERIOD_ID = SP.PERIOD_ID AND 
                        EP.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_POS_ID.POSITION_ID#"> AND
                        SP.OUR_COMPANY_ID = O.COMP_ID
                    ORDER BY
                        COMPANY_NAME
                </cfquery>
                <div class="form-group">
                    <label></label>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <select name="our_company_id" id="our_company_id" onchange="javascript:window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_add_detail_product_general_parameters&pid=#attributes.pid#&barcod=#attributes.barcod#</cfoutput>&our_company_id='+form_add_product.our_company_id.options[form_add_product.our_company_id.options.selectedIndex].value;">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <cfoutput query="get_companies">
                                <option value="#COMP_ID#" <cfif attributes.our_company_id eq comp_id>selected</cfif>>#COMPANY_NAME#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="57756.Durum"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="product_status" id="product_status" value="1" <cfif get_parameter.product_status eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='57494.Pasif'></label>
                    </div>
                </div>
                <div class="form-group">         
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="32512.Envanter"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_inventory" id="is_inventory" value="1" <cfif get_parameter.is_inventory eq 1>checked</cfif>><cf_get_lang dictionary_id='37055.envantere dahil'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="57456.Üretim"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_production" id="is_production" value="1" <cfif get_parameter.is_production eq 1>checked</cfif>><cf_get_lang dictionary_id='37057.üretiliyor'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="57448.Satış"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_sales" id="is_sales" value="1" <cfif get_parameter.is_sales eq 1>checked</cfif>><cf_get_lang dictionary_id='37059.satışta'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="29745.Tedarik"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_purchase" id="is_purchase" value="1" <cfif get_parameter.is_purchase eq 1>checked</cfif>><cf_get_lang dictionary_id='37061.Tedarik ediliyor'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="32046.Prototip"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_prototype" id="is_prototype" value="1" <cfif get_parameter.is_prototype eq 1>checked</cfif>><cf_get_lang dictionary_id='37063.Ozellestirilebilir'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="49435.Internet"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif get_parameter.is_internet eq 1>checked</cfif>><cf_get_lang dictionary_id='37065.Satılıyor'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="58019.Extranet"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_extranet" id="is_extranet" value="1" <cfif get_parameter.is_extranet eq 1>checked</cfif>><cf_get_lang dictionary_id='37065.Satılıyor'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="36028.Terazi"></label>
                    </div> 
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_terazi" id="is_terazi" value="1" <cfif get_parameter.is_terazi eq 1>checked</cfif>><cf_get_lang dictionary_id='37067.Teraziye Gidiyor'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="34010.Karma Koli"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_karma" id="is_karma" value="1" <cfif get_parameter.is_karma eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="33326.Sıfır Stok"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_zero_stock" id="is_zero_stock" value="1" <cfif get_parameter.is_zero_stock eq 1>checked</cfif>><cf_get_lang dictionary_id='37352.İle Çalış'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="33055.Stoklarla Sınırlı"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_limited_stock" id="is_limited_stock" value="1" <cfif get_parameter.is_limited_stock eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="57637.Seri No"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_serial_no" id="is_serial_no" value="1" <cfif get_parameter.is_serial_no eq 1>checked</cfif>><cf_get_lang dictionary_id='37349.Takibi Yapılıyor'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="58258.Maliyet"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_cost" id="is_cost" value="1" <cfif get_parameter.is_cost eq 1>checked</cfif>><cf_get_lang dictionary_id='37175.Takip Ediliyor'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="59157.Kalite"></label>
                    </div> 
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <label><input type="checkbox" name="is_quality" id="is_quality" onchange="baslangicTarihiGoster()" value="1" <cfif get_parameter.is_quality eq 1>checked</cfif>><cf_get_lang dictionary_id='37175.Takip Ediliyor'></label>
                        </div>
                    </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="37957.Pos Komisyonu"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_commission" id="is_commission" value="1" <cfif get_parameter.is_commission eq 1>checked</cfif>><cf_get_lang dictionary_id='58998.Hesapla'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang no ='1004.XML de Gelsin'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" name="is_add_xml" id="is_add_xml" value="1" <cfif get_parameter.is_add_xml eq 1> checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang no='1010.Hediye Kartı'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="checkbox" onclick="kontrol_day();" name="is_gift_card" id="is_gift_card" value="1" <cfif get_parameter.is_gift_card eq 1>checked</cfif> onclick="kontrol_day();"></label>
                    </div>
                </div>
                <div class="form-group" id="form_ul_gift_valid_day" <cfif get_parameter.is_gift_card neq 1>style="display:none;"</cfif>>
                    <cfif get_parameter.is_gift_card neq 1>
                        <cfset style_ = "display:none">
                    <cfelse>
                        <cfset style_ = "display:'block'">
                    </cfif>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="37046.Geçerlilik Gün"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="input" name="gift_valid_day" id="gift_valid_day" value="<cfoutput>#get_parameter.gift_valid_day#</cfoutput>" maxlength="4" onkeyup="isNumber(this);" class="moneybox"></label>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="57544.Sorumlu"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <input name="product_manager_name" type="text" id="product_manager_name" onfocus="AutoComplete_Create('product_manager_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\'','POSITION_CODE','product_manager','','3','150');" value="<cfif len(get_parameter.product_manager)><cfoutput>#get_emp_info(get_parameter.product_manager,1,0)#</cfoutput></cfif>" autocomplete="off" >
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_product.product_manager&field_name=form_add_product.product_manager_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&branch_related</cfoutput>&select_list=1,7,8&keyword='+encodeURIComponent(form_add_product.product_manager_name.value));"></span>
                            <input type="hidden" name="product_manager" id="product_manager" value="<cfoutput>#get_parameter.product_manager#</cfoutput>">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="29533.Tedarikçi"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfif len(get_parameter.company_id)>
                                <cfquery name="GET_COMP" datasource="#DSN#">
                                    SELECT MEMBER_CODE, FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_parameter.company_id#">
                                </cfquery>
                            </cfif>
                            <input name="comp" type="text" id="comp" onfocus="AutoComplete_Create('comp','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,1,0','COMPANY_ID','company_id','','3','140');" value="<cfif len(get_parameter.company_id)><cfoutput>#get_comp.member_code#- #get_comp.fullname#</cfoutput></cfif>" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_add_product.company_id&field_comp_name=form_add_product.comp<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword=</cfoutput>'+form_add_product.comp.value);" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_parameter.company_id#</cfoutput>">
                        </div>
                    </div>
                </div>             
                <div class="form-group" <cfif get_parameter.is_quality neq 1>style="display:none;"</cfif> id="quality_startdate_tr">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id="45359.Kalite Kontrol"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="45359.Kalite Kontrol"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></cfsavecontent>
                            <cfif len(get_parameter.quality_start_date)>
                                <cfinput type="text" name="quality_startdate" id="quality_startdate" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(get_parameter.quality_start_date,dateformat_style)#">
                            <cfelse>
                                <cfinput type="text" name="quality_startdate" id="quality_startdate" maxlength="10" validate="#validate_style#" message="#message#"  value="">
                            </cfif>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="quality_startdate"></span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <div class="ui-form-list-btn">
            <cf_workcube_buttons add_function="#iif(isdefined("attributes.draggable"),DE("companycontrol() && loadPopupBox('form_add_product' , #attributes.modal_id#)"),DE(""))#">
        </div>
	</cfform>    
</cf_box>
<script type="text/javascript">
function baslangicTarihiGoster()
	{
		if(document.getElementById('is_quality').checked == true)
		{
			document.getElementById('quality_startdate_tr').style.display = '';
		}
		else
		{
			document.getElementById('quality_startdate_tr').style.display = 'none';
		}
	}
function kontrol_day()
	{
		if(document.form_add_product.is_gift_card.checked == true)
			form_ul_gift_valid_day.style.display = '';
		else
			form_ul_gift_valid_day.style.display = 'none';
	}
function companycontrol()
	{
		if(document.getElementById('our_company_id').value == '')
		{
			alert("<cf_get_lang dictionary_id='55700.Şirket Seçimi yapmalısınız'>!")	;
			return false;
		}
		
		if(form_add_product.is_terazi.checked==true && trim(form_add_product.barcod.value).length!=7)
		{
			alert("<cf_get_lang dictionary_id='37681.Teraziye Giden Ürünler İçin Barkod 7 Karakter Olmalıdır'>!");
			return false;
		}
	
		var msg_txt='';
		<cfif get_parameter.is_production eq 1>
		if(form_add_product.is_production.checked==false)
			msg_txt="<cf_get_lang dictionary_id='37711.Üretiliyor Seçeneğini Kaldırdınız Ürünün Ağacını Düzenlemeniz Gerekebilir'> !";
		</cfif>
		<cfif get_parameter.is_inventory eq 1>
			if(form_add_product.is_inventory.checked==false)
				msg_txt = msg_txt + '\n<cf_get_lang dictionary_id="37911.Envantere Dahil Seçeneğini Kaldırdınız"> !';
		</cfif>
		<cfif get_parameter.is_serial_no eq 1>
			if(form_add_product.is_serial_no.checked==false)
				msg_txt=msg_txt + '\n <cf_get_lang dictionary_id="37712.Seri No Takip Seçeneğini Kaldırdınız">!';
		</cfif>
		<cfif get_parameter.is_zero_stock eq 0>
			if(form_add_product.is_zero_stock.checked==true)
				msg_txt=msg_txt + '\n <cf_get_lang dictionary_id="37713.Sıfır Stok Seçeneği Seçili Ürün Artık Sıfır Stokla Çalışacaktır">!';
		</cfif>
		<cfif get_parameter.is_karma eq 1>
			if(form_add_product.is_karma.checked==false)
				msg_txt=msg_txt + '\n<cf_get_lang dictionary_id="37714.Karma Koli Seçeneğini Kaldırdınız">';
		</cfif>
		if(msg_txt!='')
		{
			alert(msg_txt+'\n\n<cf_get_lang dictionary_id="37715.Yaptığınız Düzenlemelerden Emin Olunuz">!');
		}
		return true;
		
		<cfif get_parameter.is_zero_stock eq 0>
			if(form_add_product.is_zero_stock.checked==true)
				msg_txt=msg_txt + '\n <cf_get_lang dictionary_id="37713.Sıfır Stok Seçeneği Seçili Ürün Artık Sıfır Stokla Çalışacaktır">!';
		</cfif>
		if(msg_txt!='')
		{
			alert(msg_txt+'\n\n<cf_get_lang dictionary_id="37715.Yaptığınız Düzenlemelerden Emin Olunuz">!');
		}
		
	}
	
function pageReload()
	{
		window.location.href('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_product_general_parameters&pid=#attributes.pid#&our_company_id=</cfoutput>'+$("#our_company_id").val());
	}
</script>
