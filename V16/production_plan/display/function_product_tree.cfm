<cfsetting showdebugoutput="NO">
<cf_xml_page_edit fuseact ="prod.add_product_tree" default_value="0">
<!--- <cfparam name="attributes.is_used_rate" default="0"> ---><!--- XML'e bağlı % kullan seçeneği --->
<cfparam name="attributes.deep_level_max" default="99">
<cfset attributes.deep_level_max = deep_level_max>
<cfset is_used_rate = ( isdefined("attributes.is_used_rate") ? attributes.is_used_rate : 0)>
<cfset _deep_level_main_stock_id_0 = attributes.stock_id>
<cfset new_tree_id_list = ''>
<cfset new_tree_id_list2 = ''>
<cfscript>
	deep_level2 = 0;
	function isIncludeSubProduct2(_deep_level_)
	{
		is_ok=1;
		for (lind = _deep_level_;lind gte 1; lind = lind-1)
		{
			if(isdefined('type2_#lind#') and Evaluate('type2_#lind#') eq 3 and is_ok eq 1)
				is_ok = 1;
			else
				is_ok = 0;
		}
		return is_ok;
	}
	function get_subs2(spect_main_id,next_stock_id,type)
	{										
		if(type eq 0) where_parameter = 'PT.STOCK_ID = #next_stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #spect_main_id#';
		SQLStr = "
				SELECT
					PRODUCT_TREE_ID RELATED_ID,
					ISNULL(PT.OPERATION_TYPE_ID,0) OPERATION_TYPE_ID,
					ISNULL(PT.RELATED_ID,0) STOCK_RELATED_ID
				FROM 
					PRODUCT_TREE PT
				WHERE
					#where_parameter#
				ORDER BY
					ISNULL(PT.RELATED_ID,0)
			";
		query2 = cfquery(SQLString : SQLStr, Datasource : dsn3);
		stock_id_ary='';
		'type2_#deep_level2#' = type;
		for (str_i=1; str_i lte query2.recordcount; str_i = str_i+1)
		{
			stock_id_ary=listappend(stock_id_ary,query2.RELATED_ID[str_i],'█');
			stock_id_ary=listappend(stock_id_ary,query2.OPERATION_TYPE_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query2.STOCK_RELATED_ID[str_i],'§');
		}
		if(deep_level2 gt 0 and isIncludeSubProduct2(deep_level2) eq 1)
		{
			new_tree_id_list2 = listdeleteduplicates(ListAppend(new_tree_id_list2,ValueList(query2.RELATED_ID,','),','));
		}
		return stock_id_ary;
	}
	function writeTree2(next_spect_main_id,next_stock_id,type)
	{
		var i2 = 1;
		var sub_products2 = get_subs2(next_spect_main_id,next_stock_id,type);
		deep_level2 = deep_level2 + 1;
		for (i2=1; i2 lte listlen(sub_products2,'█'); i2 = i2+1)
		{
			_next_spect_main_id_ = ListGetAt(ListGetAt(sub_products2,i2,'█'),1,'§');//alt+987 = █ --//alt+789 = §
			_n_operation_id_ = ListGetAt(ListGetAt(sub_products2,i2,'█'),2,'§');
			_n_stock_related_id_= ListGetAt(ListGetAt(sub_products2,i2,'█'),3,'§');
			if(_next_spect_main_id_ gt 0) new_tree_id_list = listappend(new_tree_id_list,_n_stock_related_id_);
			/* if(_n_operation_id_ gt 0) */ type_=3; /*  else type_=0 ; */
			writeTree2(_next_spect_main_id_,_n_stock_related_id_,type_);
		}
		deep_level2 = deep_level2 - 1;
	}
</cfscript>
<cfset kontrol_info = 0>
<cfif attributes.stock_id gt 0>
	<cfset kontrol_info = 1>
	<cfscript>							
		 writeTree2(0,attributes.stock_id,0);
	</cfscript>
<cfelseif isdefined("attributes.main_stock_id") and len(attributes.main_stock_id)>
	<cfset kontrol_info = 1>
	<cfscript>							
		 writeTree2(0,attributes.main_stock_id,0);
	</cfscript>
</cfif>
<cfif kontrol_info eq 1>
	<cfquery name="control_stock" datasource="#dsn3#">
		SELECT
            PT.AMOUNT,
            SR.AMOUNT,
            SPECT_MAIN_ROW_ID
        FROM
            PRODUCT_TREE PT
            JOIN SPECT_MAIN_ROW SR ON PT.PRODUCT_TREE_ID = SR.RELATED_TREE_ID
        WHERE
            SR.SPECT_MAIN_ID =  (SELECT MAX(SM.SPECT_MAIN_ID) FROM SPECT_MAIN SM WHERE SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND SM.IS_TREE = 1)
            AND 
            	(
                    ROUND(PT.AMOUNT,2)<>ROUND(SR.AMOUNT,2)
                	OR
                    CAST(ISNULL(PT.IS_FREE_AMOUNT,0) AS INTEGER) <> CAST(ISNULL(SR.IS_FREE_AMOUNT,0) AS INTEGER)
                	OR
                    CAST(ISNULL(PT.FIRE_AMOUNT,0) AS INTEGER) <> CAST(ISNULL(SR.FIRE_AMOUNT,0) AS INTEGER)
                	OR
                    CAST(ISNULL(PT.FIRE_RATE,0) AS INTEGER) <> CAST(ISNULL(SR.FIRE_RATE,0) AS INTEGER)
                	OR
                    CAST(ISNULL(PT.IS_PHANTOM,0) AS INTEGER) <> CAST(ISNULL(SR.IS_PHANTOM,0) AS INTEGER)
                    OR
					(ISNULL(PT.RELATED_ID,PT.OPERATION_TYPE_ID) <> ISNULL(SR.STOCK_ID,SR.OPERATION_TYPE_ID))
                )
             AND
             (PT.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> <cfif listlen(new_tree_id_list2)>OR PT.PRODUCT_TREE_ID IN(#new_tree_id_list2#)</cfif>)
    </cfquery>
	<cfif len(new_tree_id_list)>
		<cfquery name="control_stock_2" datasource="#dsn3#"><!--- Spect ile ağaç arasındaki ürün ağacı farklılıklarına bakıyoruz --->
			SELECT
				COUNT(PRODUCT_TREE_ID) AS  COUNT
			FROM
				PRODUCT_TREE
			WHERE
            	STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                <cfif listlen(new_tree_id_list2)>OR PRODUCT_TREE_ID IN(#new_tree_id_list2#)</cfif>
		</cfquery>
        <cfquery name="control_stock_3" datasource="#dsn3#"><!--- Spect ile ağaç arasındaki ürün ağacı farklılıklarına bakıyoruz --->
			SELECT
				COUNT(SPECT_MAIN_ROW_ID) AS COUNT
			FROM
				SPECT_MAIN_ROW
			WHERE
				SPECT_MAIN_ID = (SELECT MAX(SM.SPECT_MAIN_ID) FROM SPECT_MAIN SM WHERE SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND SM.IS_TREE = 1)
		</cfquery>
	<cfelse>
		<cfset control_stock_2.recordcount = 0>	
        <cfset control_stock_3.recordcount = 0>
	</cfif>
	<cfif isdefined("control_stock.recordcount")>
		<cfset kontrol_value_1 = control_stock.recordcount>
	<cfelse>
		<cfset kontrol_value_1 = 0>	
	</cfif>
    <cfif control_stock_2.recordcount and control_stock_3.recordcount and control_stock_2.count neq control_stock_3.count>
		<cfset kontrol_value_2 = 1>
    <cfelse>
    	<cfset kontrol_value_2 = 0>
    </cfif>
<cfelse>
	<cfset kontrol_value_1 = 0>	
	<cfset kontrol_value_2 = 0>	
</cfif>
<cfquery name="get_tree_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id# AND
		FUSEACTION_NAME = 'product.popup_add_anative_product' AND
		PROPERTY_NAME = 'x_is_product_tree'
</cfquery>
<cfif get_tree_xml.recordcount>
	<cfset x_is_product_tree = get_tree_xml.PROPERTY_VALUE>
<cfelse>
	<cfset x_is_product_tree = 1>
</cfif>
<cfset colspan_1 = 3>
<cfset colspan_2 = 10>
<cffunction name="process_name">
	<cfargument name="id" type="numeric" default="0" required="yes" hint="Kampanya ID">
	<cfquery name="get_process" datasource="#dsn#">
		select stage from PROCESS_TYPE_ROWS where PROCESS_ROW_ID=#id#
		</cfquery>
<cfreturn get_process.stage>
  </cffunction>
<cf_flat_list id="product_tree_main">
	<thead>
		<tr>
			<th  width="35"></th>
			<cfset colspan_2 = colspan_2 + 1>
			<cfif isdefined('is_show_line_number') and is_show_line_number eq 1>
			<th  width="35">
				<cf_get_lang dictionary_id='58577.Sıra'>
				<!-- sil -->
				<cfif is_show_oby eq 1 and not isdefined('attributes.is_excel')>
					<cfif isdefined("attributes.oby") and attributes.oby eq 0>
						<a href="javascript://" onclick="open_tree(5);" class="form-title" title="<cf_get_lang dictionary_id='36405.Sıra Numarasına Göre Azalan'>"><img src="/images/open_close_3.gif" border="0" align="absmiddle" alt="<cf_get_lang dictionary_id='36405.Sıra Numarasına Göre Azalan'>"></a>
					<cfelse>
						<a href="javascript://" onclick="open_tree(0);" class="form-title" title="<cf_get_lang dictionary_id='36410.Sıra Numarasına Göre Artan'>"><img src="/images/open_close_2.gif" border="0" align="absmiddle" alt="<cf_get_lang dictionary_id='36410.Sıra Numarasına Göre Artan'>"></a>
					</cfif>
				</cfif>
				<!-- sil -->
			</th>
			<cfset colspan_1 = colspan_1 + 1>
			</cfif>
			<th >
				<cf_get_lang dictionary_id='57518.Stok Kodu'>
				<!-- sil -->
				<cfif is_show_oby eq 1 and not isdefined('attributes.is_excel')>
					<cfif isdefined("attributes.oby") and attributes.oby eq 3>
						<a href="javascript://" onclick="open_tree(4);" class="form-title" title="<cf_get_lang dictionary_id='36419.Koda Göre Azalan'>"><img src="/images/open_close_3.gif" border="0" align="absmiddle" alt="<cf_get_lang dictionary_id='36419.Koda Göre Azalan'>"></a>
					<cfelse>
						<a href="javascript://" onclick="open_tree(3);" class="form-title" title="<cf_get_lang dictionary_id='36421.Koda Göre Artan'>"><img src="/images/open_close_2.gif" border="0" align="absmiddle" alt="<cf_get_lang dictionary_id='36421.Koda Göre Artan'>"></a>
					</cfif>
				</cfif>
				<!-- sil -->
			</th>
			<th >
				<cf_get_lang dictionary_id='54291.Açıklama'>
				<!-- sil -->
				<cfif is_show_oby eq 1 and not isdefined('attributes.is_excel')>
					<cfif isdefined("attributes.oby") and attributes.oby eq 1>
						<a href="javascript://" onclick="open_tree(2);" class="form-title" title="<cf_get_lang dictionary_id='36425.Adına Göre Azalan'>"><img src="/images/open_close_3.gif" border="0" align="absmiddle" alt="<cf_get_lang dictionary_id='36425.Adına Göre Azalan'>"></a>
					<cfelse>
						<a href="javascript://" onclick="open_tree(1);" class="form-title" title="<cf_get_lang dictionary_id='36433.Adına Göre Artan'>"><img src="/images/open_close_2.gif" border="0" align="absmiddle" alt="<cf_get_lang dictionary_id='36433.Adına Göre Artan'>"></a>
					</cfif>
				</cfif>
				<!-- sil -->
			</th>
			<th   width="60"><cf_get_lang dictionary_id='57647.Spec'></th>
			<cfif x_related_alternative_question_product eq 1>
			   <cfset colspan_1 = colspan_1 + 1>
			   <cfset colspan_2 = colspan_2 + 1>
			   <th  title="<cf_get_lang dictionary_id='36625.Alternatif Soru'>"><cf_get_lang dictionary_id='64465.AS'></th>
			</cfif>  
			<cfif is_show_detail eq 1>
				<cfset colspan_1 = colspan_1 + 1>
				<cfset colspan_2 = colspan_2 + 1>
				<th   width="1%"><cf_get_lang dictionary_id='57629.Açıklama'></th>
			</cfif>      
			<cfif is_show_sb eq 1>
				<cfset colspan_1 = colspan_1 + 1>
				<cfset colspan_2 = colspan_2 + 1>
				<th   width="1%" title="<cf_get_lang dictionary_id ='36615.Sevkte Birleştir'>"><cf_get_lang dictionary_id='45712.SB'></th>
			</cfif>      
			<cfif x_is_phantom_tree eq 1>
				 <cfset colspan_1 = colspan_1 + 1>
				<cfset colspan_2 = colspan_2 + 1>
				<th  align="center"  width="1%" title="<cf_get_lang dictionary_id ='44969.Fantom'>"><cf_get_lang dictionary_id ='64466.F'></th>
			</cfif>
			<cfif is_show_fire_rate eq 1>
				   <cfset colspan_1 = colspan_1 + 1>
				 <cfset colspan_2 = colspan_2 + 1>
				<th  align="center"  width="1%"><cf_get_lang dictionary_id='36357.Fire Oranı'></th>
			</cfif>
			<cfif is_show_fire_amount eq 1>
				<cfset colspan_1 = colspan_1 + 1>
				<cfset colspan_2 = colspan_2 + 1>
				<th  align="center" width="1%"><cf_get_lang dictionary_id='36356.Fire Miktarı'></th>
			</cfif>
			<cfif is_show_reject_rate eq 1>
				<cfset colspan_1 = colspan_1 + 1>
				<cfset colspan_2 = colspan_2 + 1>
				<th  align="center"  width="1%"><cf_get_lang dictionary_id='36435.Red Oranı'></th>
			</cfif>
			<th <cfif is_show_amount_total eq 0 and is_used_rate eq 0>width="50"<cfelse>width="100"</cfif>  class="text-right"><cfif is_used_rate eq 0><cf_get_lang dictionary_id='57635.Miktar'><cfset _show_amount_ = ''><cfelse>%<cfset _show_amount_ = '%'></cfif></th>
			<cfif is_show_amount_total eq 0 and is_used_rate eq 0>
				<cfset colspan_2 = colspan_2 + 1>
				<th width="50"  class="text-right"><cf_get_lang dictionary_id='32823.Toplam Miktar'></th>
			</cfif>
			<cfif is_used_rate eq 0>
				<cfset colspan_2 = colspan_2 + 1>
				<th width="50" ><cf_get_lang dictionary_id ='57636.Birim'></th>
			</cfif>
			<th width="1%"></th>
			<cfset colspan_2 = colspan_2 + 1>
			<th  width="1%"></th>
			<cfif is_used_abh eq 1>
			<th >
				<cfset colspan_2 = colspan_2 + 1>
				<cf_get_lang dictionary_id='57713.Boyut'>
			</th>
			</cfif>
			<cfset colspan_2 = colspan_2 + 1>
			<th   width="1%" title="<cf_get_lang dictionary_id ='58859.Süreç Aşama'>"><cf_get_lang dictionary_id ='58859.Süreç Aşama'></th>
			<th  width="1%"></th>
			<th  width="1%"></th>
			<th  width="1%"></th>
			<th  width="1%"></th>
		</tr>
	</thead>
	<cfsavecontent variable="station"><cf_get_lang dictionary_id='58834.İstasyon'></cfsavecontent>
	<cfsavecontent variable="Guncel"><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
	<cfsavecontent variable="uyari"><cf_get_lang dictionary_id='36628.Satırı Silmek İstediğinizden Emin misiniz'>?</cfsavecontent>
	<cfsavecontent variable="uyari1"><cf_get_lang dictionary_id='36629.Bu Ürün İçin Üretim Emri Oluşturulmaz'>!</cfsavecontent>
	<cfsavecontent variable="uyari2"><cf_get_lang dictionary_id='36630.Ürün Ağacına Yeni Ürün veya Operasyon Eklenmiş, Eklentilerin Geçerli Olması İçin Ağacı Kaydetmelisiniz '>!</cfsavecontent>
    <cfscript>
		sayac = 0;
		operation_tree_id_list='';
		if(isdefined("attributes.pro_tree_id") and attributes.pro_tree_id gt 0) related_tree_link = '&related_tree_id=#attributes.pro_tree_id#'; else {related_tree_link='';attributes.pro_tree_id=0;}
		color1="##8950FC";color2="##00bcd4";color3="";
		color4="##ff9800";color5="##C9F7F5";color6="##C9F7F5";
		color7="##f44336";color8="##187DE4";color9="##795548";
		color10="##795548";color11="##795548";color12="##795548";
		color13="##795548";color14="##795548";color15="##795548";
		color16="##795548";color17="##795548";color18="##795548";
		color19="##795548";color20="##795548";color21="##795548";
		color22="##795548";color23="##795548";color24="##795548";
		color25="##795548";color26="##795548";color27="##795548";
		color28="##795548";color29="##795548";color30="##795548";
		color31="##795548";color32="##795548";color33="##795548";
		color34="##795548";color35="##795548";color36="##795548";
		color37="##795548";color38="##795548";color39="##795548";
		color40="##795548";color41="##795548";color42="##795548";
		color43="##795548";color44="##795548";color45="##795548";
		color46="##795548";color47="##795548";color48="##795548";
		level_one_sum = 0;
		level_one_count = 0;
		deep_level = 0;
		old_deep_level =1;
		/* Simdi sub toplamlari alt element sayisi hesaplaniyor */
		SQLStr_stock = 'SELECT RELATED_ID,AMOUNT FROM PRODUCT_TREE WHERE STOCK_ID = #attributes.stock_id# ORDER BY LINE_NUMBER ASC';
		query_stock = cfquery(SQLString : SQLStr_stock, Datasource : dsn3);
		/* hesaplandi...  */
		function GetDeepLevelMaınStockId(_deeplevel){
			for (lind_ = _deeplevel-1;lind_ gte 0; lind_ = lind_-1){
				if(isdefined('_deep_level_main_stock_id_#lind_#') and len(Evaluate('_deep_level_main_stock_id_#lind_#')) and Evaluate('_deep_level_main_stock_id_#lind_#') gt 0)
					return Evaluate('_deep_level_main_stock_id_#lind_#');
			}
			return 1;
		}
		function isIncludeSubProduct(_deep_level_){
			is_ok=1;
			for (lind = _deep_level_;lind gte 1; lind = lind-1){
				if(isdefined('type_#lind#') and Evaluate('type_#lind#') eq 3 and is_ok eq 1)
					is_ok = 1;
				else
					is_ok = 0;
			}
			return is_ok;
		}
		function get_subs(stock_id,spec_id,product_tree_id,type)//type 0 ise sarf 3 ise operasyon
		{//gelen stok id veya spec idye göre alt urunler ve speclerden olusan bir liste yollar
			if(type eq 0) where_parameter = 'PT.STOCK_ID = #stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #product_tree_id#';
			if(isdefined("attributes.oby") and attributes.oby eq 0)
				order_parameter = 'LINE_NUMBER ASC';
			else if(isdefined("attributes.oby") and attributes.oby eq 1)
				order_parameter = 'PRODUCT_NAME ASC';
			else if(isdefined("attributes.oby") and attributes.oby eq 2)
				order_parameter = 'PRODUCT_NAME DESC';
			else if(isdefined("attributes.oby") and attributes.oby eq 3)
				order_parameter = 'STOCK_CODE ASC';
			else if(isdefined("attributes.oby") and attributes.oby eq 4)
				order_parameter = 'STOCK_CODE DESC';
			else if(isdefined("attributes.oby") and attributes.oby eq 5)
				order_parameter = 'LINE_NUMBER DESC';
			else
				order_parameter = 'LINE_NUMBER ASC';
			
				if(spec_id neq 0){
				SQLStr="
						SELECT
							0 AS SPECT_MAIN_ID,
							0 AS STOCK_ID,
							'<font color=purple>'+#dsn#.Get_Dynamic_Language(OP.OPERATION_TYPE_ID,'#session.ep.language#', 'OPERATION_TYPES', 'OPERATION_TYPE', NULL, NULL, OPERATION_TYPE)+'</font>' AS STOCK_CODE,
							'-' AS PRODUCT_NAME,
							'-' AS PROPERTY,
							'-' AS MAIN_UNIT,
							1 AS IS_PRODUCTION,
							0 AS IS_CONFIGURE,
							ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
							0 AS PRODUCT_ID,
							ISNULL(PT.AMOUNT,0) AS AMOUNT,
							PT.PRODUCT_TREE_ID,
							ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
							0 AS IS_PHANTOM,
							ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
							OP.OPERATION_TYPE_ID,
							0 FIRE_RATE,
							0 FIRE_AMOUNT,
							0 REJECT_RATE,
							PT.DETAIL,
							PT.PRODUCT_WIDTH,
							PT.PRODUCT_LENGTH,
							PT.PRODUCT_HEIGHT,
							PT.PROCESS_STAGE
						FROM 
							OPERATION_TYPES OP,
							PRODUCT_TREE PT
						WHERE 
							OP.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID AND
							#where_parameter#
				UNION ALL
							SELECT 
							ISNULL(SR.RELATED_MAIN_SPECT_ID,0) AS SPECT_MAIN_ID,
							STOCKS.STOCK_ID,
							STOCKS.STOCK_CODE,
							STOCKS.PRODUCT_NAME,
							STOCKS.PROPERTY,
							PRODUCT_UNIT.MAIN_UNIT,
							STOCKS.IS_PRODUCTION,
							ISNULL(SR.IS_CONFIGURE,0) AS IS_CONFIGURE,
							ISNULL(SR.QUESTION_ID,0) AS QUESTION_ID,
							STOCKS.PRODUCT_ID,
							ISNULL(SR.AMOUNT,0) AS AMOUNT,
							0 AS PRODUCT_TREE_ID,
							ISNULL(SR.IS_SEVK,0) AS IS_SEVK,
							ISNULL(SR.IS_PHANTOM,0) AS IS_PHANTOM,
							ISNULL(SR.LINE_NUMBER,0) AS LINE_NUMBER,
							0 AS OPERATION_TYPE_ID,
							ISNULL(FIRE_RATE,0) FIRE_RATE,
							ISNULL(FIRE_AMOUNT,0) FIRE_AMOUNT,
							ISNULL((SELECT TOP 1 REJECT_RATE FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = STOCKS.PRODUCT_ID),0) REJECT_RATE,
							SR.DETAIL,
							0 PRODUCT_WIDTH,
							0 PRODUCT_LENGTH,
							0 PRODUCT_HEIGHT,
							0 PROCESS_STAGE
						FROM
							PRODUCT_UNIT,
							STOCKS,
							SPECT_MAIN_ROW SR
						WHERE
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
							SR.STOCK_ID = STOCKS.STOCK_ID AND
							SR.SPECT_MAIN_ID = #spec_id#
					 ORDER BY  #order_parameter#		
				";
			}
			else
			{
				SQLStr="
					SELECT
						0 AS SPECT_MAIN_ID,
						0 AS STOCK_ID,
						'<font color=purple>'+#dsn#.Get_Dynamic_Language(OP.OPERATION_TYPE_ID,'#session.ep.language#', 'OPERATION_TYPES', 'OPERATION_TYPE', NULL, NULL, OPERATION_TYPE) +'</font>' AS STOCK_CODE,
						'-' AS PRODUCT_NAME,
						'-' AS PROPERTY,
						'-' AS MAIN_UNIT,
						1 AS IS_PRODUCTION,
						ISNULL(PT.IS_CONFIGURE,0) AS IS_CONFIGURE,
						ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
						0 AS PRODUCT_ID,
						ISNULL(PT.AMOUNT,0) AS AMOUNT,
						PT.PRODUCT_TREE_ID,
						ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
						0 AS IS_PHANTOM,
						ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
						OP.OPERATION_TYPE_ID,
						0 FIRE_RATE,
						0 FIRE_AMOUNT,
						0 REJECT_RATE,
						PT.DETAIL,
						PT.PRODUCT_WIDTH,
						PT.PRODUCT_LENGTH,
						PT.PRODUCT_HEIGHT,
						PT.PROCESS_STAGE
					FROM 
						OPERATION_TYPES OP,
						PRODUCT_TREE PT
					WHERE 
						OP.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID AND
						#where_parameter#
					UNION ALL
					SELECT 
						ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
						STOCKS.STOCK_ID,
						STOCKS.STOCK_CODE,
						STOCKS.PRODUCT_NAME,
						STOCKS.PROPERTY,
						PRODUCT_UNIT.MAIN_UNIT,
						STOCKS.IS_PRODUCTION,
						ISNULL(PT.IS_CONFIGURE,0) AS IS_CONFIGURE,
						ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
						STOCKS.PRODUCT_ID,
						ISNULL(PT.AMOUNT,0) AS AMOUNT,
						PT.PRODUCT_TREE_ID,
						ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
						ISNULL(PT.IS_PHANTOM,0) AS IS_PHANTOM,
						ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
						0 AS OPERATION_TYPE_ID,
						ISNULL(FIRE_RATE,0) FIRE_RATE,
						ISNULL(FIRE_AMOUNT,0) FIRE_AMOUNT,
						ISNULL((SELECT TOP 1 REJECT_RATE FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = STOCKS.PRODUCT_ID),0) REJECT_RATE,
						PT.DETAIL,
						PT.PRODUCT_WIDTH,
						PT.PRODUCT_LENGTH,
						PT.PRODUCT_HEIGHT,
						PT.PROCESS_STAGE
					FROM
						STOCKS,
						PRODUCT_TREE PT,
						PRODUCT_UNIT
					WHERE
						PRODUCT_UNIT.PRODUCT_UNIT_ID = PT.UNIT_ID AND
						PT.RELATED_ID = STOCKS.STOCK_ID AND
						#where_parameter#
					ORDER BY  #order_parameter#		
				";
			}

		/*	if(spec_id is 97){

				writeOutput(SQLStr)
			}*/
			query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
			//writeoutput('#SQLStr#<br/>');
			stock_id_ary='';
			'type_#deep_level#' = type;
			for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
			{
				stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'█');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.STOCK_CODE[str_i],'§');
				if(len(query1.PROPERTY[str_i]))
					stock_id_ary=listappend(stock_id_ary,query1.PROPERTY[str_i],'§');
				else
					stock_id_ary=listappend(stock_id_ary,'-','§');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_NAME[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_TREE_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_CONFIGURE[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_SEVK[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_PHANTOM[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_PRODUCTION[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.LINE_NUMBER[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
				if(len(query1.MAIN_UNIT[str_i]))
					stock_id_ary=listappend(stock_id_ary,query1.MAIN_UNIT[str_i],'§');
				else
					stock_id_ary=listappend(stock_id_ary,'-','§');
				stock_id_ary=listappend(stock_id_ary,query1.FIRE_RATE[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.FIRE_AMOUNT[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.REJECT_RATE[str_i],'§');
				if(len(query1.DETAIL[str_i]))
					{stock_id_ary=listappend(stock_id_ary,query1.DETAIL[str_i],'§');}
				else
					{stock_id_ary=listappend(stock_id_ary,' ','§');}
				if(len(query1.PRODUCT_WIDTH[str_i]))
					{stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_WIDTH[str_i],'§');}
				else
					{stock_id_ary=listappend(stock_id_ary,' ','§');}
				if(len(query1.PRODUCT_LENGTH[str_i]))
					{stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_LENGTH[str_i],'§');}
				else
					{stock_id_ary=listappend(stock_id_ary,' ','§');}
				if(len(query1.PRODUCT_HEIGHT[str_i]))
					{stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_HEIGHT[str_i],'§');}
				else
					{stock_id_ary=listappend(stock_id_ary,' ','§');}
					if(len(query1.PROCESS_STAGE[str_i]))
					{stock_id_ary=listappend(stock_id_ary,query1.PROCESS_STAGE[str_i],'§');}
				else{stock_id_ary=listappend(stock_id_ary,0,'§');}
			}
			if(deep_level gt 0 and isIncludeSubProduct(deep_level) eq 1){
				operation_tree_id_list = listdeleteduplicates(ListAppend(operation_tree_id_list,ValueList(query1.PRODUCT_TREE_ID,','),','));
			}
			return stock_id_ary;
		}
		last_product_id="";
		hideable="";
		function writeRow(RELATED_ID_,SPEC_ID,DEEP_LEVEL_,PRODUCT_TREE_ID,OPERATION_TYPE_ID,PRODUCT_ID,STOCK_CODE,PROPERTY,PRODUCT_NAME,AMOUNT,IS_CONFIGURE,IS_SEVK,IS_PHANTOM,IS_PRODUCTION,LINE_NUMBER,QUESTION_ID,MAIN_UNIT,FIRE_RATE,FIRE_AMOUNT,REJECT_RATE,DETAIL,style_,PRODUCT_WIDTH,PRODUCT_LENGTH,PRODUCT_HEIGHT,PROCESS_STAGE)
		{	
	
			if(deep_level-1 gt 0)
				leftSpace = RepeatString('&nbsp;', (deep_level-1)*5);
			else
				leftSpace = '';
			if(len(leftSpace))leftSpace="<!-- sil --><td>#leftSpace#</td><!-- sil -->";
			if( len(IS_CONFIGURE)  and IS_CONFIGURE) ozel="E"; else ozel="";
			if( len(IS_SEVK)  and IS_SEVK) sevk='<img src="/images/icons_valid.gif" alt="SB" border="0" align="absmiddle">'; else sevk="";
			if(x_is_phantom_tree eq 1){
				phantom_tree='<td width="1%">&nbsp;&nbsp;&nbsp;&nbsp;</td>';
				if(x_change_phantom_tree eq 1 and operation_type_id eq 0 and deep_level eq 1)
				{
					if(IS_PHANTOM)
						phantom_tree='<td width="1%" title="#uyari1#"><input type="checkbox" name="is_phantom_#PRODUCT_TREE_ID#" id="is_phantom_#PRODUCT_TREE_ID#" checked onClick="upd_phantom(#PRODUCT_TREE_ID#);"></td>' ; 
					else
						phantom_tree='<td width="1%"><input type="checkbox" name="is_phantom_#PRODUCT_TREE_ID#" id="is_phantom_#PRODUCT_TREE_ID#" onClick="upd_phantom(#PRODUCT_TREE_ID#);"></td>' ; 
				}
				else
				{
					if(IS_PHANTOM)
						phantom_tree='<td width="1%"><img src="/images/icons_invalid.gif" alt="#uyari2#" border="0" align="absmiddle"></td>' ; 
				}
			}
			
			else phantom_tree='';
			if(is_show_fire_rate eq 1){
				fire_rate='<td width="1%" class="text-right">#tlformat(fire_rate)#</td>' ; 
			}
			else fire_rate='';
			if(is_show_fire_amount eq 1){
				fire_amount='<td width="1%" style="text-align:right;mso-number-format:0\.00;">#tlformat(fire_amount)#</td>' ; 
			}
			else fire_amount='';
			if(is_show_reject_rate eq 1){
				reject_rate='<td width="1%" class="text-right">#tlformat(reject_rate)#</td>' ; 
			}
			else reject_rate='';
			if(is_show_sb eq 1){
				sevk='<td width="1%">#sevk#</td>' ; 
			}
			else sevk='';
			if (is_used_abh){measure='<td>#PRODUCT_WIDTH#*#PRODUCT_LENGTH#*#PRODUCT_HEIGHT#</td>';}
			else{measure='';}
			
			if(is_show_detail eq 1){
				if(len(detail))
				detail = replace( detail, "|",',', "all");
				if(len(detail) gt 30)
					detail='<td width="1%" title="#detail#">#left(detail,30)#...</td>' ;
				else
					detail='<td width="1%" title="#detail#">#left(detail,30)#</td>' ;
			}
			else detail='';
			if (is_used_rate eq 0)
				unit_ = "<td>#MAIN_UNIT#</td>";
			else
				unit_ = "";
			amount = wrk_round(amount,8,1);
			'operation_type_id#deep_level#' = operation_type_id;
			if(deep_level eq 1)
			{
				'product_amount#deep_level#' = amount;// satır bazında malzeme ihtiyaçları
			}
			else
			{
				if(is_show_amount_total eq 0 and is_used_rate eq 0)
					'product_amount#deep_level#' = wrk_round(Evaluate('product_amount#deep_level-1#')*amount,8,1);
				else if(Evaluate('operation_type_id#deep_level-1#') eq 0)
					'product_amount#deep_level#' = '#Evaluate('product_amount#deep_level-1#')#*#amount#';
				else
					'product_amount#deep_level#' = '#amount#';
			}
		
			if(len(SPEC_ID) or operation_type_id gt 0)
			{	
				if(SPEC_ID gt 0 and is_production eq 1)spect_link = '<a href="javascript://"  class="tableyazi" onClick="windowopen(''#request.self#?fuseaction=objects.popup_upd_spect&upd_main_spect=1&spect_main_id=#SPEC_ID#'',''list'');">#SPEC_ID#</a>';
				else if(SPEC_ID gt 0 and is_production eq 0)spect_link = '<a href="javascript://"  style="color:##F00" title="Ürün Üretilmiyor!" onClick="windowopen(''#request.self#?fuseaction=objects.popup_upd_spect&upd_main_spect=1&spect_main_id=#SPEC_ID#'',''list'');">#SPEC_ID#</a>';
				else if((not len(SPEC_ID) or SPEC_ID EQ 0) and is_production eq 1 and operation_type_id eq 0)spect_link = '<a style="color:##F00;" title="Spect Seçmelisiniz!">!</a>';
				else spect_link ='';
				_main_stock_id_ = GetDeepLevelMaınStockId(deep_level);
				if(operation_type_id gt 0 and _main_stock_id_ gt 0)
					stock_station_link ='<!-- sil --><a href="javascript://" onClick="openBoxDraggable(''#request.self#?fuseaction=prod.popup_add_ws_product&is_add_workstation=1&main_stock_id=#_main_stock_id_#&operation_type_id=#operation_type_id#'');"><i style="color:grey!important" class="icon-settings" title="#station#"></i></a><!-- sil -->';	
				else if(IS_PRODUCTION eq 1 and not isdefined('attributes.is_excel') and _main_stock_id_ gt 0)
					stock_station_link ='<!-- sil --><a href="javascript://" onClick="openBoxDraggable(''#request.self#?fuseaction=prod.popup_add_ws_product&is_add_workstation=1&main_stock_id=#_main_stock_id_#&stock_id=#related_id_#'');"><i style="color:grey!important" class="icon-settings" title="#station#"></i></a><!-- sil -->';
				else
					stock_station_link ='';	
			}
			else
				{spect_link = ''; stock_station_link =''; }
			// yazma islemleri
			if( len(IS_CONFIGURE)  and IS_CONFIGURE) config_icon='<i style="color:##c780e5" class="fa fa-cutlery"></i>'; else config_icon='';
			str_line_number="";
			if(deep_level eq 1)
			str_line_number ='<td><i class="icn-md catalyst-arrow-down" onclick="hide_show(#PRODUCT_TREE_ID#);"></td>';
			else
			str_line_number ='<td></td>';
			if(isdefined('IS_SHOW_LINE_NUMBER') and IS_SHOW_LINE_NUMBER eq 1 and deep_level eq 1)//sıra numarası gösterilsin seçili ise
				str_line_number =str_line_number&'<td>#LINE_NUMBER#</td>';
			else if(isdefined('IS_SHOW_LINE_NUMBER') and IS_SHOW_LINE_NUMBER eq 1)
				str_line_number =str_line_number&'<td></td>';
			sayac = sayac + 1;
			//#tr_style#
			QUESTION_NAME = '';
			IS_PROTOTYPE1 ='';	
			PRODUCT_ID2='';
			IS_PROTOTYPE3='';				
			PRODUCT_TREE_ID1='';			
			if(len(question_id)){
				ques_query_str = 'SELECT QUESTION_NAME FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID = #question_id#';
				ques_query = cfquery(SQLString : ques_query_str, Datasource : dsn);
				QUESTION_NAME = listappend(QUESTION_NAME,ques_query.QUESTION_NAME,",");
				
				ques_query_str1 = 'SELECT QUESTION_ID,P.PRODUCT_ID,P.IS_PROTOTYPE IS_PROTOTYPE,PRODUCT_TREE_ID FROM PRODUCT_TREE,PRODUCT P WHERE P.PRODUCT_ID=PRODUCT_TREE.PRODUCT_ID AND PRODUCT_TREE.PRODUCT_ID = #PRODUCT_ID# AND RELATED_ID=#RELATED_ID_# AND PRODUCT_TREE_ID=#PRODUCT_TREE_ID# AND QUESTION_ID=#QUESTION_ID#';				
				ques_query1 = cfquery(SQLString : ques_query_str1, Datasource : dsn3);				
				IS_PROTOTYPE1 = listappend(ques_query1.IS_PROTOTYPE,",");
				PRODUCT_TREE_ID1=listappend(PRODUCT_TREE_ID1,ques_query1.PRODUCT_TREE_ID,",");		
				
				if(PRODUCT_TREE_ID1 neq ''){
					ques_query_str2 = 'SELECT DISTINCT PRODUCT_ID FROM PRODUCT_TREE WHERE RELATED_ID IN (SELECT STOCK_ID FROM PRODUCT_TREE WHERE PRODUCT_TREE_ID = #PRODUCT_TREE_ID1# )';
					ques_query2= cfquery(SQLString : ques_query_str2, Datasource : dsn3);
					PRODUCT_ID2 = ques_query2.PRODUCT_ID;	
				}	
				if(PRODUCT_ID2 neq ''){
					ques_query_str3 = 'SELECT IS_PROTOTYPE FROM PRODUCT WHERE PRODUCT_ID = #PRODUCT_ID2#';
					ques_query3 = cfquery(SQLString : ques_query_str3, Datasource : dsn3);
					IS_PROTOTYPE3 = ques_query3.IS_PROTOTYPE;
				}			
			IS_PROTOTYPE1 = listappend(IS_PROTOTYPE1,IS_PROTOTYPE3,",");			
				if(IS_PROTOTYPE1 contains 0)
				{					
					question_link = '<a style="color:##0000FF;" title="Ürün Özelleştirilebilir Olmalıdır.!"> !</a>';
				}				
				else
					question_link = '';	
				if(IS_PROTOTYPE3 eq 0)
				{					
					question_link1 = '<a style="color:##800080;" title="Üst Kırılımdaki Ürün Özelleştirilebilir Olmalı.!"> ?</a>';
				}				
				else
					question_link1 = '';			
			}
			
			
			if(x_related_alternative_question_product eq 1){
				question_td = 	"<td width='50'>#QUESTION_NAME##question_link##question_link1#</td>";
			}		
			else
			question_td ="";
			
			if(product_id gt 0){
				location_link='<a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#&sid=#RELATED_ID_#"  class="tableyazi" target="_blank">';	
					
			}
			else
				location_link='<a href="javascript://"  class="tableyazi" onClick="windowopen(''#request.self#?fuseaction=prod.list_operationtype&event=upd&operation_type_id=#operation_type_id#'',''list'');">';
			if(is_show_amount_total eq 0 and is_used_rate eq 0)
			{
				amount_td_1 = '<td style="text-align:right;">#amount# </td>';
				amount_td_2 = '<td style="text-align:right;">#Evaluate("product_amount#deep_level#")# </td>';
			}
			else
			{
				amount_td_1 = '<td style="text-align:right;mso-number-format:0\.00;">#_show_amount_# #Evaluate("product_amount#deep_level#")# </td>';
				amount_td_2 = '';
			}
			if(deep_level != 1){
				hideable=last_product_id;
			} 
			else {last_product_id="#PRODUCT_TREE_ID#";hideable="";}
			writeoutput('
			<tr id="my_tr_#sayac#" height="20" class="color-row id#hideable#"  #style_#>
				#str_line_number#
				<td>
					<table>
						<tr>
							#leftSpace#
							<!-- sil -->
							<td onclick="rowShowHide(#sayac#,#deep_level#);" style="background-color:burlywood;">
								<input type="hidden" name="tr_value_#sayac#" id="tr_value_#sayac#" value="#deep_level#,1">
								#deep_level#
							</td>
							<!-- sil -->
							<td>#location_link##STOCK_CODE#</a></td>
						</tr>
					</table>
				</td>			
				<td>#product_name# #property#</td>
				<td style="text-align:center;">#spect_link#</td>
				#question_td#
				#detail#
				#sevk#
				#phantom_tree#
				#fire_rate#
				#fire_amount#
				#reject_rate#
				#amount_td_1#
				#amount_td_2#
				#unit_#
				<td>#config_icon#</td>
				<td>#stock_station_link#</td>
				#measure#
				<td>#process_name(PROCESS_STAGE)#</td>
			');
			
			if(x_related_alternative_question_product eq 1){//alternatif soru alternatif ürün ilişkisi kullan denilmiş ise alternatif soru seçilmeden alternatif tanımı yapılamayacak...
				if(not isdefined('attributes.is_excel') and operation_type_id eq 0 and IS_PRODUCTION eq 0 and QUESTION_ID GT 0)
				{
					if(x_is_product_tree eq 1)
						tree_stock_ = 'AND TREE_STOCK_ID = #GetDeepLevelMaınStockId(deep_level)# AND AP.QUESTION_ID = #QUESTION_ID#';
					else
						tree_stock_ = '';
						product_tree_id1 = 'AND PRODUCT_TREE_ID = #product_tree_id#';
					SQLStr="
						SELECT 
							*
						FROM 
							ALTERNATIVE_PRODUCTS AP
						WHERE 
						   AP.PRODUCT_ID = #product_id# 
						   #tree_stock_#
						   #product_tree_id1#
					";
					get_alternative_prod = cfquery(SQLString : SQLStr, Datasource : dsn3);
					if(len(QUESTION_ID)){
					if(get_alternative_prod.recordcount) bg_color = 'red'; else bg_color = '';
					writeoutput('<td width="20" align="center"><!-- sil --><a href="javascript://" onClick="openBoxDraggable(''#request.self#?fuseaction=product.popup_add_anative_product&product_tree_id=#PRODUCT_TREE_ID#&pid=#product_id#&tree_stock_id=#GetDeepLevelMaınStockId(deep_level)#&question_id=#QUESTION_ID#'');"><i style="color:orange!important;" class="fa fa-tags" title="#getLang("prod",526)#"></i></a><!-- sil --></td>');
					}
					else
						writeoutput('<td></td>');	
				}
				else
					writeoutput('<td></td>');
			}
			else
				{
				if(not isdefined('attributes.is_excel') and operation_type_id eq 0 and IS_PRODUCTION EQ 0)
				{
					if(x_is_product_tree eq 1)
						tree_stock_ = 'AND TREE_STOCK_ID = #GetDeepLevelMaınStockId(deep_level)# AND AP.QUESTION_ID = #QUESTION_ID#';
					else
						tree_stock_ = '';
						product_tree_id1 = 'AND PRODUCT_TREE_ID = #product_tree_id#';
					SQLStr="
							SELECT 
								*
							FROM 
								ALTERNATIVE_PRODUCTS AP
							WHERE 
							   AP.PRODUCT_ID = #product_id# 
							   #tree_stock_#
							   #product_tree_id1#
					";	
					get_alternative_prod = cfquery(SQLString : SQLStr, Datasource : dsn3);
					if(len(QUESTION_ID)){
						if(get_alternative_prod.recordcount) bg_color = 'red'; else bg_color = '';
						writeoutput('<td width="20" align="center"><!-- sil --><a href="javascript://" onClick="openBoxDraggable(''#request.self#?fuseaction=product.popup_add_anative_product&product_tree_id=#PRODUCT_TREE_ID#&pid=#product_id#&tree_stock_id=#GetDeepLevelMaınStockId(deep_level)#&question_id=#QUESTION_ID#'');"><i style="color:orange!important;" class="fa fa-tags" title="#getLang("prod",526)#"></i></a><!-- sil --></td>');
						}
					else
					writeoutput('<td></td>');
					
				}
				else
					writeoutput('<td></td>');
				}
			if(IS_PRODUCTION eq 1)
			{
				if(related_id_ gt 0)//ürün ise.
					writeoutput('<td width="1%"><!-- sil --><a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#related_id_#&history_stock=#GetDeepLevelMaınStockId(deep_level)#" target="_blank"><i style="color:green!important;" class="icon-branch" title="#Guncel#"></i></a><!-- sil --></td>');		
				else if(operation_type_id gt 0)//operasyon ise
					writeoutput('<td width="1%"><!-- sil --><a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&main_stock_id=#GetDeepLevelMaınStockId(deep_level)#&product_tree_id=#PRODUCT_TREE_ID#&history_stock=#GetDeepLevelMaınStockId(deep_level)#" target="_blank"><i style="color:green!important;" class="icon-branch" title="#getLang('','Alt Ağaç',36323)#"></i></a><!-- sil --></td>');
			}			
			else
				writeoutput('<td width="1%"></td>');	
			// yazma islemleri 	
				
			if (deep_level eq 1 and not isdefined('attributes.is_excel'))
				{
				level_one_sum = level_one_sum + amount;
				level_one_count = level_one_count + 1;
				writeoutput('<td width="1%"><!-- sil --><a href="javascript://" onclick="if (confirm(''#uyari#'')) window.location.href=''#request.self#?fuseaction=prod.emptypopup_del_sub_product#related_tree_link#&PRODUCT_TREE_ID=#PRODUCT_TREE_ID#&main_stock_id=#attributes.stock_id#''"><i style="color:red!important;" class="fa fa-remove " title="#getLang("prod",176)#"></i></a><!-- sil --></td>');
				}
			else
				writeoutput('<td></td>');
			if ((deep_level eq 1 and not isdefined('attributes.is_excel')) or (operation_type_id gt 0 ) or (Evaluate('type_#deep_level-1#') eq 3))
				writeoutput('<td width="1%"><!-- sil --><a href="javascript://" onClick="pencere(#PRODUCT_TREE_ID#);"><i style="color:##217ebd!important;" class="fa fa-pencil" title="#getLang("prod",52)#"></i></a><!-- sil --></td>');
			else
				writeoutput('<td width="1%"></td>');
					
		}
		writeoutput('</tr>');
		function writeTree(next_stock_id,next_spec_id,next_production_tree_id,type)
		{
			var i = 1;
			var sub_products = get_subs(next_stock_id,next_spec_id,next_production_tree_id,type);
			//alt+987 = █ --//alt+789 = §
			deep_level = deep_level + 1;
			for (i=1; i lte listlen(sub_products,'█'); i = i+1)
			{
				product_values_list = ListGetAt(sub_products,i,'█');
				leftSpace = RepeatString('&nbsp;', deep_level*5);
				_n_stock_id_ = ListGetAt(product_values_list,1,'§');
				_n_product_id_ = ListGetAt(product_values_list,2,'§');
				_n_stock_code_ = ListGetAt(product_values_list,3,'§');
				_n_property_ = ListGetAt(product_values_list,4,'§');
				_n_product_name_ = ListGetAt(product_values_list,5,'§');
				_n_spec_main_id_ = ListGetAt(product_values_list,6,'§');
				_n_product_tree_id_ = ListGetAt(product_values_list,7,'§');
				_n_operation_type_id_ = ListGetAt(product_values_list,8,'§');
				_n_amount_ = ListGetAt(product_values_list,9,'§');
				_n_is_confg_ = ListGetAt(product_values_list,10,'§');
				_n_is_sevk_ = ListGetAt(product_values_list,11,'§');
				_n_is_phantom_ = ListGetAt(product_values_list,12,'§');
				_n_is_production_ = ListGetAt(product_values_list,13,'§');
				_n_line_number_ = ListGetAt(product_values_list,14,'§');
				_n_question_id_ = ListGetAt(product_values_list,15,'§');
				_n_main_unit_ = ListGetAt(product_values_list,16,'§');
				_n_main_unit_ = ListGetAt(product_values_list,16,'§');
				_n_fire_rate_ = ListGetAt(product_values_list,17,'§');
				_n_fire_amount_ = ListGetAt(product_values_list,18,'§');
				_n_reject_rate_ = ListGetAt(product_values_list,19,'§');
				_n_detail_ = ListGetAt(product_values_list,20,'§');
				_n_width_ = ListGetAt(product_values_list,21,'§');
				_n_height_ = ListGetAt(product_values_list,22,'§');
				_n_length_ = ListGetAt(product_values_list,23,'§');
				_n_process_ = ListGetAt(product_values_list,24,'§');
				if(deep_level gt attributes.deep_level_max)//kaç kırılım gideceğni belirliyoruz.
					style_='style="display:none"';
				else
					style_='';
				writeRow(_n_stock_id_,_n_spec_main_id_,deep_level,_n_product_tree_id_,_n_operation_type_id_,_n_product_id_,_n_stock_code_,_n_property_,_n_product_name_,_n_amount_,_n_is_confg_,_n_is_sevk_,_n_is_phantom_,_n_is_production_,_n_line_number_,_n_question_id_,_n_main_unit_,_n_fire_rate_,_n_fire_amount_,_n_reject_rate_,_n_detail_,style_,_n_width_,_n_height_,_n_length_,_n_process_);
				if(_n_spec_main_id_ gt 0) '_deep_level_main_stock_id_#deep_level#' = _n_stock_id_; else '_deep_level_main_stock_id_#deep_level#' = -1;
				/* if(_n_operation_type_id_ gt 0) */ type_=3;/*  else type_=0;  */
				if(deep_level lt 40)
					writeTree(_n_stock_id_,_n_spec_main_id_,_n_product_tree_id_,type_);
			}
			deep_level = deep_level-1;
		}
		if(url.stock_id gt 0) _type_=0; else _type_ = 3;
			writeTree(url.stock_id,0,attributes.pro_tree_id,_type_);//fonksiyon ilk olarak burada çağırılıyor type 0 ise stok 2 ise operasyon demektr.	
		if(len(_show_amount_)){//eğer Yüzde kullan denilmiş ise bu değişken dolu oluyor..
			level_one_sum = level_one_sum*100;
			writeoutput('<input type="hidden" name="genel_toplam" id="genel_toplam" value="#level_one_sum#">');
		}	
		
		if(isdefined('is_show_main_sum_product') and is_show_main_sum_product eq 1)
		{
			writeoutput('<tr class="color-list id="">
				<td colspan="#colspan_1#" style="text-align:right;" >#getLang("prod",102)#</td>
				<td  style="text-align:right;">#_show_amount_##TlFormat(level_one_sum,4)#</td>
				<td colspan="#colspan_2-colspan_1-1#"></td>
				</tr>');
		} 
		if(isdefined('is_show_main_count_product') and is_show_main_count_product eq 1)
		{
			writeoutput('<tr class="color-list id="">
				<td colspan="#colspan_1#" style="text-align:right;" >#getLang("prod",137)#</td>
				<td  style="text-align:right;">#level_one_count#</td>
				<td colspan="#colspan_2-colspan_1-1#"></td>
				</tr>');
		}
		if(kontrol_value_1 gt 0 or kontrol_value_2 gt 0){
			writeoutput('<!-- sil --><tr class="color-list id="">
				<td colspan="#colspan_2#"><font color="FF0000"><b>#uyari2#</b></font></td>
				</tr><!-- sil -->');
		}
    </cfscript>
    <script type="text/javascript">
    	document.getElementById('operation_tree_id_list').value = <cfoutput>'#operation_tree_id_list#'</cfoutput>;
    </script>
</cf_flat_list>
<!-- sil -->
<input type="hidden" name="form_complete_all" id="form_complete_all">
<script type="text/javascript">
	function upd_phantom(tree_id)
	{
		if(confirm("<cf_get_lang dictionary_id='36440.Ürün Ağacı İçin Phantom Bilgisi Değiştirilecektir'>. <cf_get_lang dictionary_id='58588.Emin misiniz'>?"))
		{
			if(document.getElementById('is_phantom_'+tree_id).checked == true)
				is_phantom = 1;
			else
				is_phantom = 0;
			var send_address = '<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_prod_tree_phantom&stock_id=#attributes.stock_id#&pro_tree_id=#attributes.pro_tree_id#<cfif isdefined("attributes.main_stock_id")>&main_stock_id=#attributes.main_stock_id#</cfif>&tree_id='+ tree_id +'&is_phantom='+is_phantom</cfoutput>;
			AjaxPageLoad(send_address,'SHOW_PRODUCT_TREE',1);
		}
	}
	function rowShowHide(counter,deepLevel,type)
	{
		self_ = 'my_tr_' + (counter + 1);
		for(ind_=counter;ind_<= '<cfoutput>#sayac#</cfoutput>'; ind_++)
			{
			var deepLevel_= list_getat(document.getElementById('tr_value_'+ind_).value,1,',');
			var status_= list_getat(document.getElementById('tr_value_'+ind_).value,2,',');
			if(list_getat(document.getElementById('tr_value_'+ind_).value,1,',') > deepLevel)
				{
				document.getElementById('tr_value_'+ind_).value = (status_==0)?''+deepLevel_+',1':''+deepLevel_+',0';
					this_ = 'my_tr_'+ind_;
						if(this_ == self_)
							{
							if(document.getElementById('my_tr_'+ind_).style.display == '')
								document.getElementById('my_tr_'+ind_).style.display='none';
							else
								document.getElementById('my_tr_'+ind_).style.display='';
							}
						else
							{
								if(document.getElementById(self_).style.display == '')
									document.getElementById('my_tr_'+ind_).style.display='';
								else
									document.getElementById('my_tr_'+ind_).style.display='none';
							}
				}
			else if(list_getat(document.getElementById('tr_value_'+ind_).value,1,',') < deepLevel)
				break;
			}
	}
				function hide_show(hide_tree_id){
					if($('.id'+hide_tree_id).css('display') == 'none')
                	$('.id'+hide_tree_id).show();
					else
					$('.id'+hide_tree_id).hide();
            }
	function open_tree(oby)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.emptypopupajax_function_product_tree&oby='+oby+'#xml_str#<cfif isdefined("url.stock_id")>&stock_id=#attributes.stock_id#<cfelse>&stock_id=0</cfif><cfif isdefined("attributes.main_stock_id")>&main_stock_id=#attributes.main_stock_id#</cfif><cfif isdefined("attributes.pro_tree_id")>&pro_tree_id=#attributes.pro_tree_id#&product_tree_id=#attributes.pro_tree_id#</cfif></cfoutput>','SHOW_PRODUCT_TREE',1);
	}
</script>