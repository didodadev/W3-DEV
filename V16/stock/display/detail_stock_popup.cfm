<cfsetting showdebugoutput="yes">
<!-- sil --><cf_xml_page_edit fuseact="stock.detail_stock_popup"><!-- sil -->
<cf_get_lang_set module_name="stock">
<cfparam name="attributes.department_id_" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.location_name" default="">
<cfparam name="attributes.department_out" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.instution" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.row_project_id" default="">
<cfparam name="attributes.row_project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id_in" default="">
<cfparam name="attributes.project_head_in" default="">
<cfparam name="attributes.shelf_number" default="">
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("department_id")>
	<cfset attributes.department_id_=attributes.department_id>
</cfif>
<cfset attributes.department_id=attributes.department_id_> 
<cfif isdefined("x_show_lot_default") and x_show_lot_default eq 1>
	<cfparam name="attributes.list_type" default="3">
<cfelse>
	<cfparam name="attributes.list_type" default="1">
</cfif>
<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
    <cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate="">
</cfif>
<cfif isDefined("attributes.finishdate")  and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>    
	<cfset attributes.finishdate="">
</cfif>
<cfinclude template="../query/get_stores.cfm">
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_HEAD,
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
		SL.STATUS,
		SL.COMMENT
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.IS_STORE <>2 AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	<cfif session.ep.isBranchAuthorization>
		AND B.BRANCH_ID = #listgetat(session.ep.user_location, 2, '-')#
	</cfif>
	<cfif isDefined("get_offer_detail.deliver_place") and len(get_offer_detail.deliver_place)>
		AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_detail.deliver_place#">
	</cfif>
	<cfif isDefined("get_order_detail.ship_address") and len(get_order_detail.ship_address) and isnumeric(get_order_detail.ship_address)>
		AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.ship_address#">
	</cfif>
	ORDER BY
		D.DEPARTMENT_HEAD,
		COMMENT
</cfquery>
<cfinclude template="../query/get_detail_stock_hareket.cfm">
<cfquery name="get_total" dbtype="query">
	SELECT
		*
	FROM
		GET_TOPLAM
    WHERE
        1=1
        <cfif len(attributes.startdate)>
        AND	PROCESS_DATE >= #attributes.startdate#
        </cfif>
        <cfif len(attributes.finishdate)>
        AND	PROCESS_DATE <= #attributes.finishdate#
        </cfif>
</cfquery>
<cfset toplam_stok = 0>
<cfif len(attributes.startdate)>
	<!--- 20051229 searchte girilen baslangic tarihi ileri bir tarih olunca ekrana gelmeyenlerin toplamini aliyoruz--->
	<cfquery name="get_total2" dbtype="query">
		SELECT 
			SUM(STOCK_IN - STOCK_OUT) AS TOTAL2 
		FROM 
			GET_TOPLAM 
		WHERE 
			PROCESS_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
			<cfif not len(attributes.department_id)>
			AND PROCESS_TYPE NOT IN (81,811)
			</cfif>
	</cfquery>
	<cfif get_total2.recordcount and get_total2.total2 neq 0><!--- negatif veya pozitif olabilir kosul tmamen dogru ellenmesin --->
		<cfset toplam_stok = get_total2.total2>
	</cfif>
</cfif>
<cfif len(attributes.startdate)>
	<cfset attributes.startdate = dateformat(attributes.startdate,dateformat_style)>
</cfif>
<cfif len(attributes.finishdate)>
	<cfset attributes.finishdate = dateformat(attributes.finishdate,dateformat_style)>
</cfif>			
<cfset adres="#fusebox.circuit#.detail_stock_popup">
<cfif isDefined('attributes.pid') and len(attributes.pid)>

	<cfquery name="get_product_names" datasource="#dsn3#">
		SELECT
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
			STOCK_ID
		FROM
			STOCKS
		WHERE
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		<cfif isDefined('attributes.stock_id') and len(attributes.stock_id)>
			AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
		</cfif>
	</cfquery>
	<cfset attributes.product_name = get_product_names.product_name>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_total.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="title">
	<cfoutput>
        <cf_get_lang dictionary_id='30064.Stok Hareketleri'>
        <cfif isDefined('attributes.pid') and len(attributes.pid)>: #get_product_names.STOCK_CODE#-#get_product_names.product_name#</cfif>
        <cfif isDefined('attributes.stock_id') and len(attributes.stock_id)>&nbsp;#get_product_names.property#</cfif>
    </cfoutput>
</cfsavecontent>
<cf_box title="#title#" uidrop="1" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search" action="#request.self#?fuseaction=#adres#" method="post">
		  <cf_box_search>
			<div class="form-group" id="item-cat">
				<select name="cat" id="cat">
					<option selected value=""><cf_get_lang dictionary_id='57734.Seçiniz'> </option>
					<option value="78" <cfif isDefined('attributes.cat') and attributes.cat eq 78>selected</cfif>><cf_get_lang dictionary_id='29584.Alım İade İrsaliyesi'></option>
					<option value="122" <cfif isDefined('attributes.cat') and attributes.cat eq 122>selected</cfif>><cf_get_lang dictionary_id ='29644.Bakım fişi'></option>	
					<option value="114" <cfif isDefined('attributes.cat') and attributes.cat eq 114>selected</cfif>><cf_get_lang dictionary_id='29631.Devir Fişi'></option>
					<option value="82" <cfif isDefined('attributes.cat') and attributes.cat eq 82>selected</cfif>><cf_get_lang dictionary_id='29589.Demirbaş Alım İrsaliyesi'> </option>
					<option value="83" <cfif isDefined('attributes.cat') and attributes.cat eq 83>selected</cfif>><cf_get_lang dictionary_id='29590.Demirbaş Satış İrsaliyesi'> </option>
					<option value="118" <cfif isDefined('attributes.cat') and attributes.cat eq 118>selected</cfif>><cf_get_lang dictionary_id='29635.Demirbaş Stok Fişi'> </option>
					<option value="1182" <cfif isDefined('attributes.cat') and attributes.cat eq 1182>selected</cfif>><cf_get_lang dictionary_id='29637.Demirbaş Stok İade Fişi'> </option>
					<option value="113" <cfif isDefined('attributes.cat') and attributes.cat eq 113>selected</cfif>><cf_get_lang dictionary_id='45957.Depo Fişi'></option>
					<option value="81" <cfif isDefined('attributes.cat') and attributes.cat eq 81>selected</cfif>><cf_get_lang dictionary_id='45391.Depolararası Sevk İrsaliyesi'></option>
					<option value="112" <cfif isDefined('attributes.cat') and attributes.cat eq 112>selected</cfif>><cf_get_lang dictionary_id='29629.Fire Fişi'></option>
					<option value="84" <cfif isDefined('attributes.cat') and attributes.cat eq 84>selected</cfif>><cf_get_lang dictionary_id='45394.Gider Pusulası(Mal) İrsaliyesi'></option> 
					<option value="761" <cfif isDefined('attributes.cat') and attributes.cat eq 761>selected</cfif>><cf_get_lang dictionary_id='45398.Hal İrsaliyesi'></option>
					<option value="87" <cfif isDefined('attributes.cat') and attributes.cat eq 87>selected</cfif>><cf_get_lang dictionary_id='29593.ithalat irsaliyesi'></option>
					<option value="811" <cfif isDefined('attributes.cat') and attributes.cat eq 811>selected</cfif>><cf_get_lang dictionary_id='29588.İthal Mal Girişi'></option>
					<option value="88" <cfif isDefined('attributes.cat') and attributes.cat eq 88>selected</cfif>><cf_get_lang dictionary_id='29594.İhracat İrsaliyesi'></option>
					<option value="77" <cfif isDefined('attributes.cat') and attributes.cat eq 77>selected</cfif>><cf_get_lang dictionary_id='45256.Konsinye Giriş'></option>
					<option value="79" <cfif isDefined('attributes.cat') and attributes.cat eq 79>selected</cfif>><cf_get_lang dictionary_id='45257.Konsinye Giriş İade'></option>
					<option value="72" <cfif isDefined('attributes.cat') and attributes.cat eq 72>selected</cfif>><cf_get_lang dictionary_id='58753.Konsinye Çıkış İrsaliyesi'></option>
					<option value="75" <cfif isDefined('attributes.cat') and attributes.cat eq 75>selected</cfif>><cf_get_lang dictionary_id='58755.Konsinye Çıkış İade İrsaliyesi'></option>
					<option value="76" <cfif isDefined('attributes.cat') and attributes.cat eq 76>selected</cfif>><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></option>
					<option value="80" <cfif isDefined('attributes.cat') and attributes.cat eq 80>selected</cfif>><cf_get_lang dictionary_id='45258.Müstahsil Makbuz'></option> 
					<option value="120" <cfif isDefined('attributes.cat') and attributes.cat eq 120>selected</cfif>><cf_get_lang dictionary_id ='58064.masraf fişi'></option>	
					<option value="67" <cfif isDefined('attributes.cat') and attributes.cat eq 67>selected</cfif>><cf_get_lang dictionary_id ='45532.Perakende Satış'></option>
					<option value="70" <cfif isDefined('attributes.cat') and attributes.cat eq 70>selected</cfif>><cf_get_lang dictionary_id='29579.Parekande Satış İrsaliyesi'></option>
					<option value="73" <cfif isDefined('attributes.cat') and attributes.cat eq 73>selected</cfif>><cf_get_lang dictionary_id='58754.Parekande Satış İade İrsaliyesi'></option>
					<option value="111" <cfif isDefined('attributes.cat') and attributes.cat eq 111>selected</cfif>><cf_get_lang dictionary_id='29628.Sarf Fişi'></option>
					<option value="115" <cfif isDefined('attributes.cat') and attributes.cat eq 115>selected</cfif>><cf_get_lang dictionary_id='29632.Sayım Fişi'></option>
					<option value="116" <cfif isDefined('attributes.cat') and attributes.cat eq 116>selected</cfif>><cf_get_lang dictionary_id='58824.Stok Virman'></option>	
					<option value="117" <cfif isDefined('attributes.cat') and attributes.cat eq 117>selected</cfif>><cf_get_lang dictionary_id='29634.Sayım Sıfırlama'></option>
					<option value="140" <cfif isDefined('attributes.cat') and attributes.cat eq 140>selected</cfif>><cf_get_lang dictionary_id='45440.Servis Giriş'></option>
					<option value="141" <cfif isDefined('attributes.cat') and attributes.cat eq 141>selected</cfif>><cf_get_lang dictionary_id='45441.Servis Çıkış'></option>
					<option value="71" <cfif isDefined('attributes.cat') and attributes.cat eq 71>selected</cfif>><cf_get_lang dictionary_id='58752.Toptan Satış İrsaliyesi'></option>
					<option value="74" <cfif isDefined('attributes.cat') and attributes.cat eq 74>selected</cfif>><cf_get_lang dictionary_id='29580.Toptan Satış İade İrsaliyesi'></option>
					<option value="110" <cfif isDefined('attributes.cat') and attributes.cat eq 110>selected</cfif>><cf_get_lang dictionary_id='29627.Üretimden çıkış Fişi'></option>
					<option value="119" <cfif isDefined('attributes.cat') and attributes.cat eq 119>selected</cfif>><cf_get_lang dictionary_id='45537.Üretimden Giriş Fisi(Demontaj)'></option> 
					<option value="85" <cfif isDefined('attributes.cat') and attributes.cat eq 85>selected</cfif>><cf_get_lang dictionary_id='45438.Üreticiye Çıkış İrsaliyesi'></option>
					<option value="86" <cfif isDefined('attributes.cat') and attributes.cat eq 86>selected</cfif>><cf_get_lang dictionary_id='45439.Üreticiden Giriş İrsaliyesi'></option>
					<option value="69" <cfif isDefined('attributes.cat') and attributes.cat eq 69>selected</cfif>><cf_get_lang dictionary_id ='58438.Z Raporu'></option>		
				</select>
			</div>	
			<div class="form-group" id="item-list_type">
				<select name="list_type" id="list_type">
					<option value="0" <cfif isdefined('attributes.list_type') and attributes.list_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='34094.Ürün Bazında'></option>
					<option value="1" <cfif isdefined('attributes.list_type') and attributes.list_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='45555.Stok Bazında'></option>
					<option value="2" <cfif isdefined('attributes.list_type') and attributes.list_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='60170.Spec Bazında'></option>
					<option value="3" <cfif isdefined('attributes.list_type') and attributes.list_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='59323.Lot Bazında'></option>
				</select>
			</div>	
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='45531.Listeleme Sayısı Hatalı'> !</cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="input_control()">
			</div>
			</cf_box_search>
			<cf_box_search_detail search_function="input_control()">
				<div class="ui-form-list ui-form-block">
					<cfif isdefined("is_all_depts") and is_all_depts eq 1>
						<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-location_id">
							<cf_wrkdepartmentlocation 
									returninputvalue="location_id,location_name,department_id_"
									returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
									fieldname="location_name"
									fieldid="location_id"
									status="0"
									is_department="1"
									line_info="2"
									department_fldid="department_id_"
									department_id="#attributes.department_id_#"
									location_id="#attributes.location_id#"
									location_name="#attributes.location_name#"
									user_level_control="0"
									user_location = "0"
									width="175"
								>
						</div>
					<cfelse>
						<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-department_id">
								<select name="department_id" id="department_id">
									<option value=""><cf_get_lang dictionary_id="56969.Giriş Depo"></option>
									<cfoutput query="get_all_location" group="department_id">
										<option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
										<cfoutput>
										<option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang dictionary_id='57494.Pasif'></cfif></option>
										</cfoutput>
									</cfoutput>
								</select>
						</div>	
						<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-department_out">
							<select name="department_out" id="department_out">
								<option value=""><cf_get_lang dictionary_id="29428.Çıkış Depo"></option>
								<cfoutput query="get_all_location" group="department_id">
									<option value="#department_id#"<cfif attributes.department_out eq department_id> selected</cfif>>#department_head#</option>
									<cfoutput>
									<option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_out eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang dictionary_id='57494.Pasif'></cfif></option>
									</cfoutput>
								</cfoutput>
							</select>
						</div>		
						</cfif>   
							<cfif is_show_project eq 1>			
						<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-row_project_id">
							<div class="input-group">
								<input type="hidden" name="row_project_id" id="row_project_id" value="<cfif len(attributes.row_project_head)><cfoutput>#attributes.row_project_id#</cfoutput></cfif>">
								<input type="text" placeholder="<cf_get_lang dictionary_id="57416.Proje">" name="row_project_head" id="row_project_head" onfocus="AutoComplete_Create('row_project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','row_project_id','','3','125');" value="<cfoutput>#attributes.row_project_head#</cfoutput>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='58797.Proje Seçiniz'>"  onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.row_project_head&project_id=frm_search.row_project_id</cfoutput>');"><i class="fa fa-ellipsis"></i></span>
							</div>
						</div>	
								</cfif>                 
						<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-product_name">
							<div class="input-group">
								<input type="hidden" name="pid" id="pid" <cfif len(attributes.pid) and len(attributes.product_name)> value="<cfoutput>#attributes.pid#</cfoutput>"</cfif>>
								<input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_id) and len(attributes.product_name)> value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
								<input name="product_name" type="text" placeholder="<cf_get_lang dictionary_id='57452.Stok'>" id="product_name"  onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','pid,stock_id','','3','130');" value="<cfif len(attributes.stock_id)><cfoutput>#get_product_name(product_id:attributes.pid,stock_id:attributes.stock_id,with_property:1)#</cfoutput><cfelse><cfoutput>#get_product_name(product_id:attributes.pid,with_property:1)#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search.stock_id&product_id=search.pid&field_name=search.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.search.product_name.value),'list');"></span>
							</div>
						</div>	
					<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-product_name">
						<div class="input-group">
							<input type="hidden" name="spec_main_id" id="spec_main_id" value="<cfif isdefined('attributes.spec_main_id') and len(attributes.spec_name)><cfoutput>#attributes.spec_main_id#</cfoutput></cfif>">
							<input type="text" placeholder="<cf_get_lang dictionary_id='45182.Main Spec'>" name="spec_name" id="spec_name" value="<cfif isdefined('attributes.spec_name') and len(attributes.spec_name)><cfoutput>#attributes.spec_name#</cfoutput></cfif>">
							<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_main&field_main_id=search.spec_main_id&field_name=search.spec_name&is_display=1&product_id=#attributes.pid#</cfoutput>','list')"></span>
						</div>
					</div>
				
						<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-startdate">
							<div class="input-group">             
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
								<cfinput type="text" validate="#validate_style#" name="startdate" placeholder="#getLang('main',330)#" message="#message#" value="#attributes.startdate#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>		
						<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-finishdate">
							<div class="input-group">        
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
								<cfinput type="text" name="finishdate"  message="#message#" placeholder="#getLang('main',330)#" validate="#validate_style#" value="#attributes.finishdate#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>	
						<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-instution">
							<input type="checkbox" name="instution" id="instution" value="1"<cfif attributes.instution eq 1>checked</cfif>><label><cf_get_lang dictionary_id='45534.3Parti Kuruluşlara Ait Lokasyonlardaki Hareketleri Gösterme'></label>
						</div>	
						<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" id="item-shelf_number">
							<input type="checkbox" name="shelf_number" id="shelf_number" value="1"<cfif attributes.shelf_number eq 1>checked</cfif>><label><cf_get_lang dictionary_id='45254.Raf No'></label>
						</div>
				</div>
			</cf_box_search_detail>
			<cf_grid_list>
				<thead>
					<tr>
						<th width="75"><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th width="75"><cf_get_lang dictionary_id='57880.Belge No'></th>
						<cfif isdefined('attributes.list_type') and attributes.list_type eq 3>
							<th width="90"><cf_get_lang dictionary_id='57456.Üretim'> & <cf_get_lang dictionary_id='37155.Lot No'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='58578.Belge Türü'></th>
						<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
						<cfif isdefined("is_dept_show") and is_dept_show eq 1>
							<th><cf_get_lang dictionary_id='45978.Giriş Depo'></th>
							<th><cf_get_lang dictionary_id='29428.Çıkış Depo'></th>
						</cfif>
						<cfif is_show_project eq 1>
						<th><cf_get_lang dictionary_id='29757.Giriş Proje'></th>
						<th><cf_get_lang dictionary_id='29523.Çıkış Proje'></th>
						</cfif>
						<cfif isdefined('attributes.list_type') and attributes.list_type eq 2><th><cf_get_lang dictionary_id='57647.Spec'></th></cfif>
						<cfif attributes.shelf_number eq 1><th width="75"><cf_get_lang dictionary_id='45254.Raf No'></th></cfif>
						<th class="text-right" nowrap="nowrap"><cf_get_lang dictionary_id='57468.Belge'><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th class="text-right" nowrap="nowrap"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th><cf_get_lang dictionary_id='57636.Birim'></th>
					</tr>
				</thead>
				<cfset colspan_ = 6>
				<cfif isdefined('attributes.list_type') and attributes.list_type eq 2>
					<cfset colspan_ = colspan_ + 1>
				</cfif>
				<cfif isdefined('attributes.list_type') and attributes.list_type eq 3>
					<cfset colspan_ = colspan_ + 1>
				</cfif>
				<cfif isdefined("is_dept_show") and is_dept_show eq 1>
					<cfset colspan_ = colspan_ + 2>
				</cfif>
				<cfif is_show_project eq 1>
				<cfset colspan_ = colspan_ + 2>
				</cfif>
				<cfif attributes.shelf_number eq 1>
					<cfset colspan_ = colspan_ + 1>
				</cfif>
				<tbody>
					<cfif get_total.recordcount>
						<cfif attributes.totalrecords gt attributes.maxrows>
							<cfif attributes.page neq 1>
								<cfset max_ = (attributes.page-1)*attributes.maxrows>
								<cfoutput query="GET_TOTAL" startrow="1" maxrows="#max_#">
									<cfif STOCK_OUT gt 0>
										<cfif (not listfind("81,811,113",PROCESS_TYPE,",")) or len(attributes.department_id)>
											<cfset toplam_stok = toplam_stok - STOCK_OUT>
										</cfif>
									</cfif>
									<cfif STOCK_IN gt 0>
										<cfif (not listfind("81,811,113",PROCESS_TYPE,",")) or len(attributes.department_id)>
											<cfset toplam_stok = toplam_stok + STOCK_IN>
										</cfif>
									</cfif>
								</cfoutput>
							</cfif>
						</cfif>		
						<tr>
							<td colspan="<cfoutput>#colspan_-1#</cfoutput>" class="txtboldblue"><cf_get_lang dictionary_id='58034.Devreden'></td>
							<cfoutput><td class="text-right">               
							#TlFormat(toplam_stok,x_round_number)#               
							</td>
							<td>#get_u.main_unit#</td></cfoutput>
						</tr>
						<cfset irsaliye_tipleri = '70,71,72,73,74,75,76,77,78,79,80,81,87,811,761,84,85,86,88,140,141'>
						<cfset upd_id_list=''>
						<cfset upd_id_list2=''>
						<cfset upd_id_list3=''>
						<cfset upd_id_list4=''>
						<cfset upd_id_list5=''>
						<cfset comp_id_list=''>
						<cfset cons_id_list=''>
						<cfset emp_id_list=''>
						<cfset shelf_number_list=''>
						<cfif is_show_project eq 1>
						<cfset project_id_list =''>
						<cfset project_id_in_list =''>
						</cfif>
						<cfif isdefined("is_dept_show") and is_dept_show eq 1>
							<cfset dept_id_list=''>
							<cfset loc_id_list=''>
						</cfif>
						<cfoutput query="get_total" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif listfind(irsaliye_tipleri,get_total.process_type,",")>
								<cfif not listfind(upd_id_list,get_total.upd_id)>
									<cfset upd_id_list = listappend(upd_id_list,get_total.upd_id)>
								</cfif>
							<cfelseif listfind("110,111,112,113,114,115,119,118,1182",get_total.process_type,",")><!--- Üretim,Ambar Fisi(Depolar arasi),Devir Fisi(Dönemler arasi),Sayim Fisi,Üretimden Giriş Fişi(Demontaj)  --->
								<cfif not listfind(upd_id_list2,get_total.upd_id)>
									<cfset upd_id_list2 = listappend(upd_id_list2,get_total.upd_id)>
								</cfif>						
							<cfelseif listfind("67,68,691,69",get_total.process_type,",")>
								<cfif not listfind(upd_id_list3,get_total.upd_id)>
									<cfset upd_id_list3 = listappend(upd_id_list3,get_total.upd_id)>
								</cfif>
							<cfelseif listfind("116",get_total.process_type,",")>
								<cfif not listfind(upd_id_list4,get_total.upd_id)>
									<cfset upd_id_list4 = listappend(upd_id_list4,get_total.upd_id)>
								</cfif>		
							<cfelseif listfind("120,122",get_total.process_type,",")>
								<cfif not listfind(upd_id_list5,get_total.upd_id)>
									<cfset upd_id_list5 = listappend(upd_id_list5,get_total.upd_id)>
								</cfif>		
							</cfif>
							<cfif isdefined("is_dept_show") and is_dept_show eq 1>
								<cfif len(store) and not listfind(dept_id_list,store)>
									<cfset dept_id_list=listappend(dept_id_list,store)>
								</cfif>
								<cfif len("#store#-#store_location#") and not listfind(loc_id_list,"#store#-#store_location#")>
									<cfset loc_id_list=listappend(loc_id_list,"#store#-#store_location#")>
								</cfif>
							</cfif>
							<cfif attributes.shelf_number eq 1 and len(shelf_number) and not listfind(shelf_number_list,shelf_number)>
								<cfset shelf_number_list=listappend(shelf_number_list,shelf_number)>
							</cfif>
							<cfif is_show_project eq 1>
							<cfif len(PROJECT_ID) and not listfind(project_id_list,PROJECT_ID) AND (PROJECT_ID NEQ 0 and PROJECT_ID NEQ -1)>
								<cfset project_id_list=listappend(project_id_list,PROJECT_ID)>
							</cfif>
							<cfif len(PROJECT_ID_IN) and not listfind(project_id_in_list,PROJECT_ID_IN) AND (PROJECT_ID_IN NEQ 0 and PROJECT_ID_IN NEQ -1)>
								<cfset project_id_in_list=listappend(project_id_in_list,PROJECT_ID_IN)>                  
							</cfif>
							</cfif>
						</cfoutput>
						<cfif len(upd_id_list)>
							<cfquery name="get_ship" datasource="#dsn2#">
								SELECT SHIP_NUMBER,SHIP_ID,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,DELIVER_EMP_ID,SHIP_TYPE FROM SHIP WHERE SHIP_ID IN (#upd_id_list#) ORDER BY SHIP_ID
							</cfquery>
							<cfset upd_id_list = ListSort(ListDeleteDuplicates(valuelist(get_ship.SHIP_ID)),"numeric","asc",",")>
							<cfif get_ship.recordcount>
								<cfoutput query="get_ship">
									<cfif len(get_ship.company_id) and not listfind(comp_id_list,get_ship.company_id)>
										<cfset comp_id_list=listappend(comp_id_list,get_ship.company_id)>
									</cfif>
									<cfif len(get_ship.consumer_id) and not listfind(cons_id_list,get_ship.consumer_id)>
										<cfset cons_id_list=listappend(cons_id_list,get_ship.consumer_id)>
									</cfif>
									<cfif len(get_ship.employee_id) and not listfind(emp_id_list,get_ship.employee_id)>
										<cfset emp_id_list=listappend(emp_id_list,get_ship.employee_id)>
									</cfif>
									<cfif get_ship.ship_type eq 81 and len(get_ship.deliver_emp_id) and (get_ship.deliver_emp_id neq 0) and not listfind(emp_id_list,get_ship.deliver_emp_id) and isnumeric(get_ship.deliver_emp_id)>
										<cfset emp_id_list=listappend(emp_id_list,get_ship.deliver_emp_id)>
									</cfif>
								</cfoutput>
							</cfif>
						</cfif>
						<cfif len(upd_id_list2)>
							<cfquery name="get_fis" datasource="#dsn2#">
								SELECT
									SF.FIS_NUMBER,
									SF.FIS_ID,
									PO.P_ORDER_NO,
									POR.LOT_NO,
									SF.COMPANY_ID,
									SF.CONSUMER_ID,
									SF.EMPLOYEE_ID
								FROM 
									STOCK_FIS SF
									LEFT JOIN #dsn3_alias#.PRODUCTION_ORDERS PO
									ON SF.PROD_ORDER_NUMBER=PO.P_ORDER_ID
									LEFT JOIN #dsn3_alias#.PRODUCTION_ORDER_RESULTS POR
									ON SF.PROD_ORDER_RESULT_NUMBER=POR.PR_ORDER_ID
								WHERE SF.FIS_ID IN (#upd_id_list2#) ORDER BY SF.FIS_ID
							</cfquery>
							<cfset upd_id_list2 = ListSort(ListDeleteDuplicates(valuelist(get_fis.FIS_ID)),"numeric","asc",",")>
							<cfoutput query="get_fis">
								<cfif len(get_fis.company_id) and not listfind(comp_id_list,get_fis.company_id)>
									<cfset comp_id_list=listappend(comp_id_list,get_fis.company_id)>
								</cfif>
								<cfif len(get_fis.consumer_id) and not listfind(cons_id_list,get_fis.consumer_id)>
									<cfset cons_id_list=listappend(cons_id_list,get_fis.consumer_id)>
								</cfif>
								<cfif len(get_fis.employee_id) and not listfind(emp_id_list,get_fis.employee_id)>
									<cfset emp_id_list=listappend(emp_id_list,get_fis.employee_id)>
								</cfif>
							</cfoutput>
						</cfif>
						<cfif len(upd_id_list3)>
							<cfquery name="get_invoice" datasource="#dsn2#">
								SELECT INVOICE_NUMBER,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,INVOICE_ID FROM INVOICE WHERE INVOICE_ID IN (#upd_id_list3#) ORDER BY INVOICE_ID
							</cfquery>
							<cfset upd_id_list3 = ListSort(ListDeleteDuplicates(valuelist(get_invoice.INVOICE_ID)),"numeric","asc",",")>
							<cfoutput query="get_invoice">
								<cfif len(get_invoice.company_id) and not listfind(comp_id_list,get_invoice.company_id)>
									<cfset comp_id_list = listappend(comp_id_list,get_invoice.company_id)>
								</cfif>
								<cfif len(get_invoice.consumer_id) and not listfind(cons_id_list,get_invoice.consumer_id)>
									<cfset cons_id_list = listappend(cons_id_list,get_invoice.consumer_id)>
								</cfif>
								<cfif len(get_invoice.employee_id) and not listfind(emp_id_list,get_invoice.employee_id)>
									<cfset emp_id_list=listappend(emp_id_list,get_invoice.employee_id)>
								</cfif>
							</cfoutput>
						</cfif>
						<cfif len(upd_id_list4)>
							<cfquery name="get_exchange" datasource="#dsn2#">
								SELECT LOT_NO,EXCHANGE_NUMBER,STOCK_EXCHANGE_ID FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID IN (#upd_id_list4#) ORDER BY STOCK_EXCHANGE_ID
							</cfquery>
							<cfset upd_id_list4 = ListSort(ListDeleteDuplicates(valuelist(get_exchange.STOCK_EXCHANGE_ID)),"numeric","asc",",")>
						</cfif>
						<cfif len(upd_id_list5)>
							<cfquery name="get_expense" datasource="#dsn2#">
								SELECT PAPER_NO,EXPENSE_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID IN (#upd_id_list5#) ORDER BY EXPENSE_ID
							</cfquery>
							<cfset upd_id_list5 = ListSort(ListDeleteDuplicates(valuelist(get_expense.EXPENSE_ID)),"numeric","asc",",")>
						</cfif>
						<cfif len(comp_id_list)>
							<cfset comp_id_list=listsort(comp_id_list,"numeric","ASC",",")>
							<cfquery name="get_comp_name" datasource="#dsn#">
								SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#comp_id_list#) ORDER BY COMPANY_ID
							</cfquery>
						</cfif>
						<cfif len(cons_id_list)>
							<cfset cons_id_list=listsort(cons_id_list,"numeric","ASC",",")>
							<cfquery name="get_cons_name" datasource="#dsn#">
								SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#cons_id_list#) ORDER BY CONSUMER_ID
							</cfquery>
						</cfif>
						<cfif len(emp_id_list)>
							<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
							<cfquery name="get_emp_name" datasource="#dsn#">
								SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS FULLNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#) ORDER BY EMPLOYEE_ID
							</cfquery>
						</cfif>
						<cfif is_show_project eq 1>  
							<cfif len(project_id_list)>
								<cfset project_id_list = ListSort(ListDeleteDuplicates(project_id_list),"numeric","ASC",",")>              	
								<cfquery name="GET_PRO_DETAIL" datasource="#DSN#">
									SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
								</cfquery>                                   
							</cfif>
							<cfif len(project_id_in_list)>
								<cfset project_id_in_list = ListSort(ListDeleteDuplicates(project_id_in_list),"numeric","ASC",",")>
								<cfquery name="GET_PRO_DETAIL2" datasource="#DSN#">
									SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_in_list#) ORDER BY PROJECT_ID
								</cfquery>                               
							</cfif>
						</cfif>
						<cfif isdefined("is_dept_show") and is_dept_show eq 1>
							<cfif listlen(dept_id_list)>
								<cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
								<cfquery name="GET_DEP_DETAIL" datasource="#DSN#">
									SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY DEPARTMENT_ID
								</cfquery>
								<cfset dept_id_list = listsort(listdeleteduplicates(valuelist(get_dep_detail.department_id,',')),'numeric','ASC',',')>
							</cfif>
							<cfif ListLen(loc_id_list)>
								<cfset loc_id_list=listsort(loc_id_list,'text','asc',',')>
								<cfquery name="get_location_" datasource="#dsn#">
									SELECT
										SL.COMMENT,
										CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) DEPARTMENT_LOCATIONS_
									FROM
										DEPARTMENT D,
										STOCKS_LOCATION SL
									WHERE
										D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
										CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) IN (#ListQualify(loc_id_list,"'",",")#)
									ORDER BY
										CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10))
								</cfquery>
								<cfset loc_id_list = ListSort(ListDeleteDuplicates(ValueList(get_location_.department_locations_,',')),"text","asc",",")>
							</cfif>
						</cfif>
						<cfif len(shelf_number_list) and attributes.shelf_number eq 1>
							<cfset shelf_number_list=listsort(shelf_number_list,'text','asc',',')>
							<cfquery name="GET_SHELF_NAME" datasource="#dsn3#">
								SELECT 
									SHELF_CODE,
									SHELF_NAME,
									PRODUCT_PLACE_ID
								FROM 
									PRODUCT_PLACE,
									#dsn_alias#.SHELF
								WHERE 
									SHELF_ID = SHELF_TYPE AND 
									PLACE_STATUS=1 AND 
									PRODUCT_PLACE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#shelf_number_list#">) 
								ORDER BY 
									PRODUCT_PLACE_ID
							</cfquery>
							<cfset shelf_number_list = ListSort(ListDeleteDuplicates(valuelist(GET_SHELF_NAME.PRODUCT_PLACE_ID)),"numeric","asc",",")>
						</cfif>
						<cfoutput query="get_total" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td height="20">#dateformat(process_date,dateformat_style)#</td>
								<td>
									<cfif listfind(irsaliye_tipleri,process_type,",") and len(upd_id_list)>
										#get_ship.ship_number[listfind(upd_id_list,upd_id,',')]#
									<cfelseif listfind("110,111,112,113,114,115,118,1182",process_type,",") and len(upd_id_list2)>
										#get_fis.fis_number[listfind(upd_id_list2,upd_id,',')]#
									<cfelseif listfind("67,691,69",process_type,",") and len(upd_id_list3)>
										#get_invoice.invoice_number[listfind(upd_id_list3,upd_id,',')]#
									<cfelseif listfind("116",process_type,",") and len(upd_id_list4)>
										#get_exchange.EXCHANGE_NUMBER[listfind(upd_id_list4,upd_id,',')]#
									<cfelseif listfind("120,122",process_type,",") and len(upd_id_list5)>
										#get_expense.PAPER_NO[listfind(upd_id_list5,upd_id,',')]#
									</cfif>
								</td>
								<cfif isdefined('attributes.list_type') and attributes.list_type eq 3>
								<td>
									<cfif listfind(irsaliye_tipleri,process_type,",") and len(upd_id_list)>
										#LOT_NO#
									<cfelseif listfind("110,113,114,115",process_type,",") and len(upd_id_list2)>
										#get_fis.P_ORDER_NO[listfind(upd_id_list2,upd_id,',')]#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LOT_NO#
									<cfelseif listfind("111,112",process_type,",") and len(upd_id_list2)> <!---ana query den lot no bazlı çekmek istemedim.PY 0116--->
										#get_fis.P_ORDER_NO[listfind(upd_id_list2,upd_id,',')]#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LOT_NO#
									<cfelseif listfind("67,691,69",process_type,",") and len(upd_id_list3)>
										#LOT_NO#
									<cfelseif listfind("116",process_type,",") and len(upd_id_list4)>
										#LOT_NO#
									</cfif>
								</td>
								</cfif>
								<td>
									<cfif get_module_user(13)>
										<cfif listfind(irsaliye_tipleri,process_type,",") and len(upd_id_list) and not listfind("70,71,72,78,79,85,88,141",process_type,",")>
											<cfswitch expression="#process_type#">
												<cfcase value="761">
													<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_marketplace_ship&ship_id=">
												</cfcase>
												<cfcase value="82">
													<cfset url_param = "#request.self#?fuseaction=invent.add_purchase_invent&event=upd&ship_id=">
												</cfcase>
												<cfcase value="81">
													<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
												</cfcase>
												<cfcase value="811">
													<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_stock_in_from_customs&event=upd&ship_id=">
												</cfcase>
												<cfdefaultcase>
													<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_purchase&event=upd&ship_id=">
												</cfdefaultcase>
											</cfswitch>
										<cfelseif stock_out gt 0 and not listfind("110,111,112,113,114,115,116,117,118,1182",process_type,",")>
											<cfswitch expression="#process_type#">
												<cfcase value="81">
													<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=">
												</cfcase>
												<cfcase value="811">
													<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_stock_in_from_customs&event=upd&ship_id=">
												</cfcase>
												<cfcase value="83">
													<cfset url_param = "#request.self#?fuseaction=invent.add_invent_sale&event=upd&ship_id=">
												</cfcase>
												<cfcase value="120">
													<cfset url_param = "#request.self#?fuseaction=objects.popup_list_cost_expense&id=">
												</cfcase>
												<cfcase value="122">
													<cfset url_param = "#request.self#?fuseaction=cost.popup_list_cost_expense&id=">
												</cfcase>
												<cfcase value="69">
													<cfset url_param = "#request.self#?fuseaction=finance.list_daily_zreport&event=upd&iid=">
												</cfcase>
												<cfdefaultcase>
													<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=upd&ship_id=">
												</cfdefaultcase>
											</cfswitch>				
										<cfelse>
											<cfswitch expression="#process_type#">
												<cfcase value="114">
													<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_ship_open_fis&event=upd&upd_id=">
												</cfcase>
												<cfcase value="118">
													<cfset url_param="#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=">
												</cfcase>
												<cfcase value="1182">
													<cfset url_param="#request.self#?fuseaction=invent.add_invent_stock_fis_return&event=upd&fis_id=">
												</cfcase>
												<cfcase value="116">
													<cfset url_param="#request.self#?fuseaction=stock.form_add_stock_exchange&event=upd&exchange_id=">
												</cfcase>
												<cfcase value="117">
													<cfset url_param="#request.self#?fuseaction=pos.list_fileimports_total_sayim&start_date=#dateformat(process_date,dateformat_style)#">
												</cfcase>
												<cfcase value="811">
													<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_stock_in_from_customs&event=upd&ship_id=">
												</cfcase>
												<cfdefaultcase>
													<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_fis&event=upd&upd_id=">
												</cfdefaultcase>
											</cfswitch>
										</cfif>
										<cfif process_type eq 117>
											<a href="#url_param#" class="tableyazi" target="_blank">#get_process_name(process_type)#</a>
										<cfelse>
											<a href="#url_param##get_total.upd_id#" class="tableyazi" target="_blank">#get_process_name(process_type)#</a>
										</cfif>
									<cfelse>
										<cfif listfind(irsaliye_tipleri,process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&ship_id=#get_total.upd_id#','list','popup_detail_ship');" class="tableyazi">#get_process_name(process_type)#</a>
										<cfelseif listfind("87",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&ship_id=#get_total.upd_id#','list','popup_detail_ship');" class="tableyazi">#get_process_name(process_type)#</a>
										<cfelseif listfind("116",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_stock_virman&exchange_id=#get_total.upd_id#','list','popup_detail_stock_virman');" class="tableyazi">#get_process_name(process_type)#</a>
										<cfelseif listfind("122",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cost.popup_list_cost_expense&id=#get_total.upd_id#','page','popup_list_cost_expense');" class="tableyazi">#get_process_name(process_type)#</a>
										<cfelseif listfind("69",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.upd_daily_zreport&iid=#get_total.upd_id#','wide');" class="tableyazi">#get_process_name(process_type)#</a>
										<cfelseif listfind("110,118,1182",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_total.upd_id#','list');" class="tableyazi">#get_process_name(process_type)#</a>
										<cfelseif listfind("111",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_total.upd_id#','list');" class="tableyazi">#get_process_name(process_type)#</a>
										<cfelseif listfind("112",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_total.upd_id#','list');" class="tableyazi">#get_process_name(process_type)#</a>							
										<cfelseif listfind("113",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_total.upd_id#','list');" class="tableyazi">#get_process_name(process_type)#</a>							
										<cfelseif listfind("114",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_total.upd_id#','list');" class="tableyazi">#get_process_name(process_type)#</a>
										<cfelseif listfind("115",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_total.upd_id#','list');" class="tableyazi">#get_process_name(process_type)#</a>
										<cfelseif listfind("119",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_total.upd_id#','list');" class="tableyazi">#get_process_name(process_type)#</a>							
										<cfelseif listfind("120",process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_cost_expense&id=#get_total.upd_id#','list');" class="tableyazi">#get_process_name(process_type)#</a>														
										<cfelse>
											#get_process_name(process_type)#
										</cfif>
									</cfif>
								</td>
								<td><cfif len(upd_id_list) and (len(comp_id_list) or len(cons_id_list) or len(emp_id_list))>
										<cfif get_ship.recordcount>
											<cfif listfind(irsaliye_tipleri,process_type,",")>
												<cfif len(comp_id_list)>
													#get_comp_name.fullname[listfind(comp_id_list,get_ship.company_id[listfind(upd_id_list,upd_id,',')],',')]#
												</cfif>
												<cfif len(cons_id_list)>
													#get_cons_name.fullname[listfind(cons_id_list,get_ship.consumer_id[listfind(upd_id_list,upd_id,',')],',')]#
												</cfif>
												<cfif len(emp_id_list) and process_type neq 81>
													#get_emp_name.fullname[listfind(emp_id_list,get_ship.employee_id[listfind(upd_id_list,upd_id,',')],',')]#
												<cfelseif len(emp_id_list) and process_type eq 81>
													#get_emp_name.fullname[listfind(emp_id_list,get_ship.deliver_emp_id[listfind(upd_id_list,upd_id,',')],',')]#
												</cfif>
											</cfif>
										</cfif>
									</cfif>
									<cfif len(upd_id_list3) and (len(comp_id_list) or len(cons_id_list) or len(emp_id_list))>
										<cfif get_invoice.recordcount>
											<cfif len(comp_id_list)>
												#get_comp_name.fullname[listfind(comp_id_list,get_invoice.company_id[listfind(upd_id_list3,upd_id,',')],',')]#
											</cfif>
											<cfif len(cons_id_list)>
												#get_cons_name.fullname[listfind(cons_id_list,get_invoice.consumer_id[listfind(upd_id_list3,upd_id,',')],',')]#
											</cfif>
											<cfif len(emp_id_list)>
												#get_emp_name.fullname[listfind(emp_id_list,get_invoice.employee_id[listfind(upd_id_list3,upd_id,',')],',')]#
											</cfif>
										</cfif>
									</cfif> 
									<cfif len(upd_id_list2) and (len(comp_id_list) or len(cons_id_list) or len(emp_id_list))>
										<cfif get_fis.recordcount>
											<cfif len(comp_id_list)>
												#get_comp_name.fullname[listfind(comp_id_list,get_fis.company_id[listfind(upd_id_list2,upd_id,',')],',')]#
											</cfif>
											<cfif len(cons_id_list)>
												#get_cons_name.fullname[listfind(cons_id_list,get_fis.consumer_id[listfind(upd_id_list2,upd_id,',')],',')]#
											</cfif>
											<cfif len(emp_id_list)>
												#get_emp_name.fullname[listfind(emp_id_list,get_fis.employee_id[listfind(upd_id_list2,upd_id,',')],',')]#
											</cfif>
										</cfif>
									</cfif> 
								</td>
								<cfif isdefined("is_dept_show") and is_dept_show eq 1>
									<td nowrap="nowrap">
										<cfif stock_in gt 0 and len(dept_id_list)>
											#get_dep_detail.department_head[listfind(dept_id_list,STORE,',')]# - #get_location_.comment[ListFind(loc_id_list,"#STORE#-#STORE_LOCATION#",',')]#
										</cfif>
									</td>
									<td nowrap="nowrap">
										<cfif stock_out gt 0 and len(dept_id_list)>
											#get_dep_detail.department_head[listfind(dept_id_list,STORE,',')]# - #get_location_.comment[ListFind(loc_id_list,"#STORE#-#STORE_LOCATION#",',')]#
										</cfif>
									</td>
								</cfif>
								<cfif isdefined("is_show_project") and is_show_project eq 1>
									<td nowrap="nowrap">
										<cfif stock_in gt 0>
											<cfif not listfind('81,113',process_type)>
													<cfif len(project_id_list)>
													#GET_PRO_DETAIL.PROJECT_HEAD[listfind(project_id_list,project_id,',')]# 
													<cfelseif len(project_id_in_list)>
													#GET_PRO_DETAIL2.PROJECT_HEAD[listfind(project_id_in_list,project_id_in,',')]#  
													</cfif>                           	                        	
											<cfelse>
													<cfif len(project_id_in_list)>
													#GET_PRO_DETAIL2.PROJECT_HEAD[listfind(project_id_in_list,project_id_in,',')]#  
													</cfif>  
											</cfif>
										</cfif>
									</td>
									<td nowrap="nowrap">
										<cfif stock_out gt 0 >
												<cfif not listfind('81,113',process_type)>
													<cfif len(project_id_list)>
													#GET_PRO_DETAIL.PROJECT_HEAD[listfind(project_id_list,project_id,',')]# 
													<cfelseif len(project_id_in_list)>
													#GET_PRO_DETAIL2.PROJECT_HEAD[listfind(project_id_in_list,project_id_in,',')]#  
													</cfif>                           	                        	
												<cfelse>
													<cfif len(project_id_list)>
													#GET_PRO_DETAIL.PROJECT_HEAD[listfind(project_id_list,project_id,',')]#  
													</cfif>  
												</cfif>
										</cfif>
									</td>                    
								</cfif>
								<cfif isdefined('attributes.list_type') and attributes.list_type eq 2>
									<td>#spect_var_id#</td>
								</cfif>
								<cfif attributes.shelf_number eq 1>
									<td>
										<cfif len(shelf_number)>
											<cfif isdefined('is_shelf_code') and is_shelf_code eq 1>#GET_SHELF_NAME.SHELF_CODE[listfind(shelf_number_list,shelf_number,',')]# -</cfif> 
											#GET_SHELF_NAME.SHELF_NAME[listfind(shelf_number_list,shelf_number,',')]#
										</cfif>
									</td>
								</cfif>
								<td class="text-right">
									<!--- toplam_stok : sadece depolararasi sevk ve ambar fisi degilse veya depo secilmisse stok saymali--->
									<cfset is_stock_text = true>
									<cfif stock_in gt 0>
										<cfif (not listfind("81,811,113",process_type,",")) or len(attributes.department_id)>
											<cfset toplam_stok = toplam_stok+stock_in>
										</cfif>
										<cfset is_stock_text = false> 
									#TlFormat(stock_in,x_round_number)#
									</cfif>
									<cfif stock_out gt 0>
										<cfif (not listfind("81,811,113",process_type,",")) or len(attributes.department_id)>
											<cfset toplam_stok = toplam_stok-stock_out>
										</cfif>
										<cfif is_stock_text>
										-#TlFormat(stock_out,x_round_number)#
										</cfif>
									</cfif>
								</td>
								<td style="text-align:right;">
								#TlFormat(toplam_stok,x_round_number)#
								</td>
								<td>#get_u.main_unit#</td>
							</tr>
						</cfoutput>
						</tbody>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="<cfoutput>#colspan_+2#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
							</tr>
						</tbody>
					</cfif>
			</cf_grid_list>
			<div class="ui-info-bottom">
				<p><b><cf_get_lang dictionary_id='57492.Toplam'> : </b> <cfoutput>#TlFormat(toplam_stok,x_round_number)# #get_u.main_unit#</cfoutput></p>
			</div>
		
	</cfform>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.startdate)>
			<cfset adres = "#adres#&startdate=#attributes.startdate#">
		</cfif>
		<cfif len(attributes.finishdate)>
			<cfset adres = "#adres#&finishdate=#attributes.finishdate#">
		</cfif>
		<cfif len(attributes.instution)>
			<cfset adres = "#adres#&instution=#attributes.instution#">
		</cfif>
		<cfif len(attributes.department_id)>
			<cfset adres = "#adres#&department_id=#attributes.department_id#">
		</cfif>
		<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
			<cfset adres = "#adres#&location_id=#attributes.location_id#">
		</cfif>
		<cfif isdefined("attributes.location_name") and len(attributes.location_name)>
			<cfset adres = "#adres#&location_name=#attributes.location_name#">
		</cfif>
		<cfif len(attributes.department_out)>
			<cfset adres = "#adres#&department_out=#attributes.department_out#">
		</cfif>
		<cfif len(attributes.cat)>
			<cfset adres = "#adres#&cat=#attributes.cat#">
		</cfif>
		<cfif isdefined('attributes.list_type') and len(attributes.list_type)>
			<cfset adres = "#adres#&list_type=#attributes.list_type#">
		</cfif>
		<cfif isdefined('attributes.spec_main_id') and len(attributes.spec_name)>
			<cfset adres = "#adres#&spec_main_id=#attributes.spec_main_id#">
			<cfset adres = "#adres#&spec_name=#attributes.spec_name#">
		</cfif>
		<cfif isdefined('attributes.pid') and len(attributes.product_name)>
			<cfset attributes.product_name = replace(attributes.product_name,'=','')>
			<cfset adres = "#adres#&product_name=#attributes.product_name#">
			<cfset adres = "#adres#&pid=#attributes.pid#">
			<cfset adres = "#adres#&stock_id=#attributes.stock_id#">
		</cfif>
		<cfif isdefined('attributes.row_project_id') and len(attributes.row_project_id)>
		<cfset adres = "#adres#&row_project_id=#attributes.row_project_id#">
		</cfif>
		<cfif isdefined('x_round_number') and len(x_round_number)>
		<cfset adres = "#adres#&x_round_number=#x_round_number#">
		</cfif>
		<cfif len(attributes.shelf_number)>
			<cfset adres = "#adres#&shelf_number=#attributes.shelf_number#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
</cf_box>

<script type="text/javascript">

	function input_control()
	{
		if($("#row_project_head").val() == '')
			$("#row_project_id").val('');
		<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#);"),DE(""))#</cfoutput>
		return false;
	}
</script>
