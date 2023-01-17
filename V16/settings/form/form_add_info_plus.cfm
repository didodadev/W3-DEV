<cfsetting showdebugoutput="no">
<cfif fusebox.use_period>
	<cfinclude template="../query/get_product_cat_names.cfm">
</cfif>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='42570.Ek Bilgi Ayarları Ekle'></cfsavecontent>
<cf_box title="#title#">
    <cfform name="add_pro_info" method="post" action="#request.self#?fuseaction=settings.add_info_plus_act">
        <cf_box_elements>
            <div class="col col-3 col-xs-12">
                <div class="scrollbar" style="max-height:403px;overflow:auto;">
                    <div id="cc">
                        <cfinclude template="../display/list_info_plus_names.cfm">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">	
                <div class="form-group" id="item-bank" sort="true">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58572.Kullanım'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="owner_type_id" id="owner_type_id" onchange="secilen_kontrol();">
                            <option value="-1"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></option>
                            <option value="-2"><cf_get_lang dictionary_id='57586.Bireysel Üye'></option>
                            <option value="-3"><cf_get_lang dictionary_id='58612.Üye Şirket Çalışanı'></option>
                            <option value="-4"><cf_get_lang dictionary_id='57576.Çalışan'></option>
                            <option value="-23"><cf_get_lang dictionary_id='29767.CV'></option>
                            <option value="-5"><cf_get_lang dictionary_id='57657.Ürün'></option>
                            <option value="-6"><cf_get_lang dictionary_id='42103.Ürün Ağacı'></option>			
                            <option value="-7"><cf_get_lang dictionary_id='58207.Satış Siparişleri'></option>
                            <option value="-8"><cf_get_lang dictionary_id='50922.Alış Faturaları'></option>
                            <option value="-32"><cf_get_lang dictionary_id='50921.Satış Faturaları'></option>
                            <option value="-9"><cf_get_lang dictionary_id='30007.Satış Teklifleri'></option>
                            <option value="-10"><cf_get_lang dictionary_id='57416.Proje'></option>
                            <option value="-11"><cf_get_lang dictionary_id='58832.Abone'></option>
                            <option value="-12"><cf_get_lang dictionary_id='42422.Satınalma Siparişleri'></option>
                            <option value="-13"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></option>
                            <option value="-19"><cf_get_lang dictionary_id='42789.IT Varlık'></option>
                            <option value="-20"><cf_get_lang dictionary_id='57414.Araçlar'></option>
                            <option value="-14"><cf_get_lang dictionary_id='39500.Alış İrsaliyeleri'></option>
                            <option value="-31"><cf_get_lang dictionary_id="39502.Satış İrsaliyeleri"></option>
                            <option value="-15"><cf_get_lang dictionary_id='57656.Servis'></option>
                            <option value="-16"><cf_get_lang dictionary_id='42187.Satış Fırsatlar'></option>
                            <option value="-17"><cf_get_lang dictionary_id='59003.Masraf ve gelir fişleri'></option>
                            <option value="-18"><cf_get_lang dictionary_id='58445.İş'></option>
                            <option value="-21"><cf_get_lang dictionary_id='29522.Sözleşme'></option>
                            <option value="-22"><cf_get_lang dictionary_id='43214.Stok Fişleri'></option>
                            <option value="-24"><cf_get_lang dictionary_id="57438.callcenter">-<cf_get_lang dictionary_id="58186.başvurular"></option>
                            <option value="-25"><cf_get_lang dictionary_id="57438.callcenter">-<cf_get_lang dictionary_id="58729.Etkileşim"></option>
                            <option value="-27"><cf_get_lang dictionary_id="58689.Teminat"></option>
                            <option value="-28"><cf_get_lang dictionary_id="49752.Satınalma Talebi"></option>
                            <option value="-29"><cf_get_lang dictionary_id="30782.İç Talepler"></option>
                            <option value="-30"><cf_get_lang dictionary_id="30048.Satınalma Teklifleri"></option>
                        </select>
                    </div>
                </div>
                <cfif fusebox.use_period>
                    <div class="form-group" id="pro_cat" name="pro_cat" sort="true" style="display:none">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_multiselect_check 
                            query_name="get_pro_cat"  
                            name="product_catid"
                            option_name="HIERARCHY-PRODUCT_CAT" 
                            option_value="PRODUCT_CATID"
                            data_source="#dsn3#">
                        </div>
                    </div>
                </cfif>
                <div class="form-group" id="sub_cat" sort="true" style="display:none;">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42950.Sistem Kategorileri'>*</label>
                    <div class="col col-8 col-xs-12">
                       <cf_multiselect_check 
                        table_name="SETUP_SUBSCRIPTION_TYPE"  
                        name="sub_catid"
                        option_name="SUBSCRIPTION_TYPE" 
                        option_value="SUBSCRIPTION_TYPE_ID"
                        data_source="#dsn3#">
                    </div>
                </div>
                <div class="form-group" id="physcal_cat" sort="true" style="display:none;">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44768.Varlık Tipi'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
                            SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT  WHERE MOTORIZED_VEHICLE = 0 AND IT_ASSET = 0 ORDER BY ASSETP_CAT
                        </cfquery>
                        <cf_multiselect_check 
                        query_name="GET_ASSETP_CATS"  
                        name="assetp_catid"
                        option_name="ASSETP_CAT" 
                        option_value="ASSETP_CATID"
                        data_source="#dsn#">
                    </div>
                </div>
                <div class="form-group" id="it_cat" sort="true" style="display:none;">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44768.Varlık Tipi'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
                            SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE IT_ASSET = 1 ORDER BY ASSETP_CAT
                        </cfquery>
                        <cf_multiselect_check 
                        query_name="GET_ASSETP_CATS"  
                        name="assetp_catid_it"
                        option_name="ASSETP_CAT" 
                        option_value="ASSETP_CATID"
                        data_source="#dsn#">
                    </div>
                </div>
                <div class="form-group" id="vehicles_cat" sort="true" style="display:none;">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44768.Varlık Tipi'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
                            SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
                        </cfquery>
                        <cf_multiselect_check 
                        query_name="GET_ASSETP_CATS"  
                        name="assetp_catid_vehicles"
                        option_name="ASSETP_CAT" 
                        option_value="ASSETP_CATID"
                        data_source="#dsn#">
                    </div>
                </div>
                <div class="form-group" id="work_cat" sort="true" style="display:none;">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38177.İş Kategorisi'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="GET_WORK_CAT" datasource="#DSN#">
                            SELECT WORK_CAT_ID, WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
                        </cfquery>
                        <cf_multiselect_check 
                        query_name="get_work_cat"  
                        name="work_catid"
                        option_name="WORK_CAT" 
                        option_value="WORK_CAT_ID"
                        data_source="#dsn#">
                    </div>
                </div>
                <div class="form-group" id="sales_add_options" sort="true" style="display:none;">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41142.Özel Tanım'></label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="GET_SALES_ADD_OPTIONS" datasource="#DSN3#">
                            SELECT SALES_ADD_OPTION_ID, SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
                        </cfquery>
                        <cf_multiselect_check 
                        query_name="GET_SALES_ADD_OPTIONS"  
                        name="sales_add_optionid"
                        option_name="SALES_ADD_OPTION_NAME" 
                        option_value="SALES_ADD_OPTION_ID"
                        data_source="#dsn3#">
                    </div>
                </div>
                <div class="form-group" id="process" sort="true">
                    <div class="col col-12 col-xs-12">
                        <cfloop index="i" from="1" to="40">
                            <tr>
                                <td width="150"><cf_get_lang dictionary_id='57632.Özellik'><cfoutput>#i#</cfoutput>
                                <cfswitch expression="#i#">
                                    <cfcase value="1,2,3,4,7,8,9,10">(100)<cf_get_lang dictionary_id='42569.Karakter'></cfcase>
                                    <cfcase value="5,6">(500)<cf_get_lang dictionary_id='42569.Karakter'></cfcase>
                                    <cfcase value="11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40">(250)<cf_get_lang dictionary_id='42569.Karakter'></cfcase>
                                </cfswitch>
                                </td>
                                <td><input type="text" maxlength="50" name="<cfoutput>property#i#_name</cfoutput>" id="<cfoutput>property#i#_name</cfoutput>"></td>
                            </tr>
                        </cfloop>	
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>

<br/>
<script type="text/javascript">
	function secilen_kontrol()
	{
		if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -5)
			goster(pro_cat);
		else
		{
			gizle(pro_cat);
		}
		if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -11)
			goster(sub_cat);	
		else
		{
			gizle(sub_cat);
		}
		if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -13)
			goster(physcal_cat);	
		else
		{
			gizle(physcal_cat);
		}
		if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -19)
			goster(it_cat);	
		else
		{
			gizle(it_cat);
		}
		if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -20)
			goster(vehicles_cat);	
		else
		{
			gizle(vehicles_cat);
		}
		if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -18)
			goster(work_cat);	
		else
		{
			gizle(work_cat);
		}
        if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -9)
            goster(sales_add_options);    
        else
        {
            gizle(sales_add_options);
        }
	}
	
	function kontrol()
	{
		if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -5)
		{
			product_catid_selected = 0;
			for(kk=0;kk<document.add_pro_info.product_catid.length; kk++)
				if(document.add_pro_info.product_catid[kk].selected)
					product_catid_selected+=1;
					
			if(product_catid_selected == 0)
			{
				alert('<cf_get_lang dictionary_id="44680.En Az Bir Ürün Kategorisi Seçiniz">');
				return false;
			}			
		}
		else if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -11)
		{
			sub_catid_selected=0
			for(kk=0;kk<document.add_pro_info.sub_catid.length; kk++)
				if(document.add_pro_info.sub_catid[kk].selected)
					sub_catid_selected+=1;
					
			if(sub_catid_selected == 0)
			{
				alert('<cf_get_lang dictionary_id="41094.En az bir sistem kategorisi seçiniz">');
				return false;
			}
		}
		else if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -13)
		{
			assetp_catid_selected=0
			for(kk=0;kk<document.add_pro_info.assetp_catid.length; kk++)
				if(document.add_pro_info.assetp_catid[kk].selected)
					assetp_catid_selected+=1;
					
			if(assetp_catid_selected == 0)
			{
				alert('<cf_get_lang dictionary_id="42496.En Az Bir Varlık Tipi Seçiniz">');
				return false;
			}
		}
		else if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -19)
		{
			assetp_catid_it_selected=0
			for(kk=0;kk<document.add_pro_info.assetp_catid_it.length; kk++)
				if(document.add_pro_info.assetp_catid_it[kk].selected)
					assetp_catid_it_selected+=1;
					
			if(assetp_catid_it_selected == 0)
			{
				alert('<cf_get_lang dictionary_id="42496.En Az Bir Varlık Tipi Seçiniz">');
				return false;
			}
		}
		else if(document.add_pro_info.owner_type_id.options[document.add_pro_info.owner_type_id.selectedIndex].value == -20)
		{
			assetp_catid_vehicles_selected=0
			for(kk=0;kk<document.add_pro_info.assetp_catid_vehicles.length; kk++)
				if(document.add_pro_info.assetp_catid_vehicles[kk].selected)
					assetp_catid_vehicles_selected+=1;
					
			if(assetp_catid_vehicles_selected == 0)
			{
				alert('<cf_get_lang dictionary_id="42496.En Az Bir Varlık Tipi Seçiniz">');
				return false;
			}
		}
		return true;
	}
</script>
