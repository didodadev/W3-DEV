<cfparam name="attributes.cat" default="">
<cfparam name="attributes.question_id" default="">
<cfparam name="attributes.question_stock_name" default="">
<cfparam name="attributes.question_product_id" default="">
<cfparam name="attributes.question_stock_id" default="">
<cfparam name="attributes.katsayi" default="">
<cfparam name="attributes.pro_type" default="1">
<cfparam name="attributes.product_id_1" default="">
<cfparam name="attributes.product_name_1" default="">
<cfparam name="attributes.product_id_2" default="">
<cfparam name="attributes.product_name_2" default="">
<cfparam name="attributes.product_id_3" default="">
<cfparam name="attributes.product_name_3" default="">
<cfparam name="attributes.product_id_4" default="">
<cfparam name="attributes.product_name_4" default="">
<cfparam name="attributes.product_id_5" default="">
<cfparam name="attributes.product_name_5" default="">
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id# 
	ORDER BY 
		HIERARCHY
</cfquery>
<cfquery name="get_questions" datasource="#dsn#">
	SELECT * FROM SETUP_ALTERNATIVE_QUESTIONS ORDER BY QUESTION_NAME
</cfquery>
<cfset question_id_list = valuelist(get_questions.question_id)>
<cfset question_name_list = valuelist(get_questions.question_name)>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<!-- sil -->
		<td  width="135"><cfinclude template="../display/prod_plan_definition_left_menu.cfm"></td>
		<!-- sil -->
	<td valign="top" align="left">
		 <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center"  class="headbold">
			<tr>
				<td height="35"><cf_get_lang dictionary_id='34297.Alternatif Hammadde Yönetim Ekranı'></td>
			</tr>
		</table>
		<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
		<cfform name="report_special" enctype="multipart/form-data" method="post" action="">
			<input type="hidden" value="1" name="is_submit" id="is_submit">
			<tr class="color-row"> 
			<td> 
				<table border="0">
					<tr> 
						<td><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></td>
						<td width="150"><cf_get_lang dictionary_id='57657.Ürün'></td>
						<td><cf_get_lang dictionary_id='44966.Alternatif Sorusu'> *</td>
						<td><cf_get_lang dictionary_id='45516.Hammadde'> *</td>
						<td><cf_get_lang dictionary_id='50801.Kaysayı'>%</td>
						<td><cf_get_lang dictionary_id='57692.İşlem'></td>
					</tr>
					<tr valign="top">
						<td>
						<select name="cat" id="cat" style="width:300px;height:110px;" multiple="multiple">
							<cfoutput query="get_product_cat">
								<cfif listlen(HIERARCHY,".") lte 3>
									<option value="#product_catid#" <cfif listfind(attributes.cat,product_catid)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
								</cfif>
							</cfoutput>
						</select>
						</td>
						<td width="150">
							<input type="hidden" name="product_id_1" id="product_id_1" value="<cfoutput>#attributes.product_id_1#</cfoutput>">
							<cfinput type="text" name="product_name_1" id="product_name_1" style="width:125px;" value="#attributes.product_name_1#" onFocus="AutoComplete_Create('product_name_1','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_1','','3','225');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_1&field_name=report_special.product_name_1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>	
							<input type="hidden" name="product_id_2" id="product_id_2" value="<cfoutput>#attributes.product_id_2#</cfoutput>">
							<cfinput type="text" name="product_name_2" id="product_name_2" style="width:125px;" value="#attributes.product_name_2#" onFocus="AutoComplete_Create('product_name_2','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_2','','3','225');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_2&field_name=report_special.product_name_2','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>	
							<input type="hidden" name="product_id_3" id="product_id_3" value="<cfoutput>#attributes.product_id_3#</cfoutput>">
							<cfinput type="text" name="product_name_3" id="product_name_3" style="width:125px;" value="#attributes.product_name_3#" onFocus="AutoComplete_Create('product_name_3','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_3','','3','225');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_3&field_name=report_special.product_name_3','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>	
							<input type="hidden" name="product_id_4" id="product_id_4" value="<cfoutput>#attributes.product_id_4#</cfoutput>">
							<cfinput type="text" name="product_name_4" id="product_name_4" style="width:125px;" value="#attributes.product_name_4#" onFocus="AutoComplete_Create('product_name_4','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_4','','3','225');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_4&field_name=report_special.product_name_4','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>	
							<input type="hidden" name="product_id_5" id="product_id_5" value="<cfoutput>#attributes.product_id_5#</cfoutput>">
							<cfinput type="text" name="product_name_5" id="product_name_5" style="width:125px;" value="#attributes.product_name_5#" onFocus="AutoComplete_Create('product_name_5','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_5','','3','225');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_5&field_name=report_special.product_name_5','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>	
						</td>
						<td>
						<select name="question_id" id="question_id" style="width:150px;height:110px;" multiple="multiple">
							<cfoutput query="get_questions">
								<option value="#question_id#" <cfif listfind(attributes.question_id,question_id)>selected</cfif>>#question_name#</option>
							</cfoutput>
						</select>
						</td>
						<td>
							<input type="hidden" name="question_stock_id" id="question_stock_id" value="<cfoutput>#attributes.question_stock_id#</cfoutput>">
							<input type="hidden" name="question_product_id" id="question_product_id" value="<cfoutput>#attributes.question_product_id#</cfoutput>">
							<cfinput type="text" name="question_stock_name" id="question_stock_name" style="width:125px;" value="#attributes.question_stock_name#" required="yes" message="Hammadde Seçmelisiniz!" onFocus="AutoComplete_Create('question_stock_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id,question_product_id','','3','225');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id&product_id=report_special.question_product_id&field_name=report_special.question_stock_name','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>			
						</td>
						<td>
							<input name="katsayi" id="katsayi" type="text" value="<cfoutput>#attributes.katsayi#</cfoutput>" style="width:50px;">
						</td>
						<td>
							<input type="radio" name="pro_type" id="pro_type" value="1" <cfif attributes.pro_type eq 1>checked</cfif>><cf_get_lang dictionary_id='44630.Ekle'><br/>
							<input type="radio" name="pro_type" id="pro_type" value="0" <cfif attributes.pro_type eq 0>checked</cfif>><cf_get_lang dictionary_id='53354.Çıkar'>
						</td>
					</tr>
					<tr> 
						<td height="35" colspan="6" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='form_kontrol()'></td>
					</tr>
				</table>
			</td>
			</tr>
		</cfform>
		</table>
		<cfif isdefined("attributes.is_submit")>
			<br/>
			<cfscript>
				deep_level = 0;
				function get_subs(spect_main_id,next_stock_id,type)
				{										
					if(type eq 0) where_parameter = 'PT.STOCK_ID = #next_stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #spect_main_id#';
					SQLStr = "
							SELECT
								PRODUCT_TREE_ID RELATED_ID,
								ISNULL(PT.STOCK_ID,0) STOCK_ID,
								ISNULL(PT.SPECT_MAIN_ID,0) SPECT_MAIN_ROW_ID,
								ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
								ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
								ISNULL(PT.PRODUCT_ID,0) AS PRODUCT_ID,
								ISNULL(PT.OPERATION_TYPE_ID,0) OPERATION_TYPE_ID,
								ISNULL(PT.RELATED_ID,0) STOCK_RELATED_ID
							FROM 
								PRODUCT_TREE PT
							WHERE
								#where_parameter#
							ORDER BY
								LINE_NUMBER,
								STOCK_ID DESC
						";
					query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
					stock_id_ary='';
					for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
					{
						stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
						stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
						stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ROW_ID[str_i],'§');
						stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
						stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');
						stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
						stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
						stock_id_ary=listappend(stock_id_ary,query1.STOCK_RELATED_ID[str_i],'§');
					}
					return stock_id_ary;
				}
				function GetDeepLevelMaınStockId(_deeplevel){
					for (lind_ = _deeplevel-1;lind_ gte 0; lind_ = lind_-1){
						if(isdefined('_deep_level_main_stock_id_#lind_#') and len(Evaluate('_deep_level_main_stock_id_#lind_#')) and Evaluate('_deep_level_main_stock_id_#lind_#') gt 0)
							return Evaluate('_deep_level_main_stock_id_#lind_#');
					}
					return 1;
				}
				function writeTree(next_spect_main_id,next_stock_id,type,question_id)
				{
					var i = 1;
					var sub_products = get_subs(next_spect_main_id,next_stock_id,type);
					deep_level = deep_level + 1;
					for (i=1; i lte listlen(sub_products,'█'); i = i+1)
					{
						_next_spect_main_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
						_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
						_next_spect_main_row_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
						_next_question_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),4,'§');
						_next_product_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),5,'§');
						_n_operation_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),6,'§');
						_n_spec_main_id_= ListGetAt(ListGetAt(sub_products,i,'█'),7,'§');
						_n_stock_related_id_= ListGetAt(ListGetAt(sub_products,i,'█'),8,'§');
						if(_next_question_id_ gt 0 and _n_operation_id_ eq 0 and _next_question_id_ eq question_id and _n_stock_related_id_ gt 0)
						{
							if(not listfind(evaluate("question_stock_list_#listgetat(attributes.question_id,kk,',')#"),_n_stock_related_id_))
								"question_stock_list_#listgetat(attributes.question_id,kk,',')#" = listappend(evaluate("question_stock_list_#listgetat(attributes.question_id,kk,',')#"),_n_stock_related_id_);
						}
						if(_next_stock_id_ gt 0) '_deep_level_main_stock_id_#deep_level#' = _next_stock_id_; else '_deep_level_main_stock_id_#deep_level#' = '-1';
						if(_n_operation_id_ gt 0) type_=3;else type_=0;
						writeTree(_next_spect_main_id_,_n_stock_related_id_,type_,question_id);
					 }
					 deep_level = deep_level-1;
				}
			</cfscript>
			<cfquery name="get_product_trees" datasource="#dsn3#">
				SELECT DISTINCT 
					S.STOCK_ID,
					S.PRODUCT_ID,
					S.PRODUCT_NAME AS YAN_URUN
				FROM
					PRODUCT_TREE PT,
					STOCKS S
					<cfif attributes.pro_type eq 0>
					,ALTERNATIVE_PRODUCTS AP
					</cfif>
				WHERE
					(PT.RELATED_ID = S.STOCK_ID OR PT.STOCK_ID = S.STOCK_ID)
					<cfif len(attributes.cat)>
						AND	S.PRODUCT_CATID IN (#attributes.cat#)
					</cfif>
					<cfif attributes.pro_type eq 0>
						AND AP.TREE_STOCK_ID = S.STOCK_ID
					</cfif>
					<cfif (len(attributes.product_id_1) and len(attributes.product_name_1)) or (len(attributes.product_id_2) and len(attributes.product_name_2)) or (len(attributes.product_id_3) and len(attributes.product_name_3)) or (len(attributes.product_id_4) and len(attributes.product_name_4)) or (len(attributes.product_id_5) and len(attributes.product_name_5))> 
					AND
						(S.PRODUCT_ID IS NULL
						<cfif len(attributes.product_id_1) and len(attributes.product_name_1)>
							OR S.PRODUCT_ID = #attributes.product_id_1#
						</cfif>
						<cfif len(attributes.product_id_2) and len(attributes.product_name_2)>
							OR S.PRODUCT_ID = #attributes.product_id_2#
						</cfif>
						<cfif len(attributes.product_id_3) and len(attributes.product_name_3)>
							OR S.PRODUCT_ID = #attributes.product_id_3#
						</cfif>
						<cfif len(attributes.product_id_4) and len(attributes.product_name_4)>
							OR S.PRODUCT_ID = #attributes.product_id_4#
						</cfif>
						<cfif len(attributes.product_id_5) and len(attributes.product_name_5)>
							OR S.PRODUCT_ID = #attributes.product_id_5#
						</cfif>
						)
					</cfif>
			</cfquery>
			<cfset message_ = ''>
			<cfoutput query="get_product_trees">
				<cfif attributes.pro_type eq 1>
					<cfloop from="1" to="#listlen(attributes.question_id)#" index="kk">
						<cfquery name="get_alternative_pro" datasource="#dsn3#">
							SELECT 
								ALTERNATIVE_ID 
							FROM 
								ALTERNATIVE_PRODUCTS 
							WHERE 
								TREE_STOCK_ID = #get_product_trees.STOCK_ID#
								AND QUESTION_ID = #listgetat(attributes.question_id,kk,',')#
								AND ALTERNATIVE_PRODUCT_ID = #attributes.question_product_id#
						</cfquery>
						<cfif get_alternative_pro.recordcount and len(attributes.katsayi)>
							<cfquery name="upd_row" datasource="#dsn3#">
								UPDATE 
									ALTERNATIVE_PRODUCTS 
								SET 
									USAGE_RATE = #attributes.katsayi# 
								WHERE 
									TREE_STOCK_ID = #get_product_trees.STOCK_ID# 
									AND QUESTION_ID = #listgetat(attributes.question_id,kk,',')#
									AND ALTERNATIVE_PRODUCT_ID = #attributes.question_product_id#
							</cfquery>
							<cfset soru_ = listgetat(question_name_list,listfindnocase(question_id_list,listgetat(attributes.question_id,kk,',')))>
							<cfset message_ = message_ & "<li>#YAN_URUN# adlı üründen (#soru_#) sorusuna bağlı olan #attributes.question_stock_name# ürününün Fiyat Farkı Oranı Güncellendi.</li><br/>">
						<cfelseif get_alternative_pro.recordcount eq 0>
							<cfset "question_stock_list_#listgetat(attributes.question_id,kk,',')#" = ''>
							<cfscript>							
								 writeTree(0,get_product_trees.stock_id,0,listgetat(attributes.question_id,kk,','));
							</cfscript>
							<cfset new_stocks = evaluate("question_stock_list_#listgetat(attributes.question_id,kk,',')#")>
							<cfoutput>#new_stocks#</cfoutput>
							<!--- <cfif listlen(new_stocks,',')>
								<cfloop list="#new_stocks#" index="new_indx">
									<cfquery name="get_p_id" datasource="#dsn3#">
										SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #new_indx#
									</cfquery>
									<cfquery name="add_row" datasource="#dsn3#">
										INSERT INTO
											ALTERNATIVE_PRODUCTS
										(
											PRODUCT_ID,
											ALTERNATIVE_PRODUCT_ID,
											TREE_STOCK_ID,
											USAGE_RATE,
											QUESTION_ID,
											START_DATE,
											FINISH_DATE,
											RECORD_EMP,
											RECORD_DATE
										)
										VALUES
										(
											#get_p_id.PRODUCT_ID#,
											#attributes.question_product_id#,
											#get_product_trees.STOCK_ID#,
											<cfif len(attributes.katsayi)>#attributes.katsayi#<cfelse>NULL</cfif>,
											#listgetat(attributes.question_id,kk,',')#,
											#now()#,
											#now()#,
											#session.ep.userid#,
											#now()#		
										)
									</cfquery>
									<cfset soru_ = listgetat(question_name_list,listfindnocase(question_id_list,listgetat(attributes.question_id,kk,',')))>
									<cfset message_ = message_ & "<li>#YAN_URUN# adlı üründen (#soru_#) sorusuna #attributes.question_stock_name# ürünü Eklendi.</li><br/>">
								</cfloop>
							</cfif> --->
							<cfset "question_stock_list_#listgetat(attributes.question_id,kk,',')#" = ''>
						</cfif>
					</cfloop>
				<cfelse>
					<cfloop from="1" to="#listlen(attributes.question_id)#" index="kk">
						<cfquery name="del_row" datasource="#dsn3#">
							DELETE FROM 
								ALTERNATIVE_PRODUCTS 
							WHERE 
								TREE_STOCK_ID = #get_product_trees.RELATED_ID# AND 
								QUESTION_ID = #listgetat(attributes.question_id,kk,',')#
								AND ALTERNATIVE_PRODUCT_ID = #attributes.question_product_id#
						</cfquery>
						<cfset soru_ = listgetat(question_name_list,listfindnocase(question_id_list,listgetat(attributes.question_id,kk,',')))>
						<cfset message_ = message_ & "<li>#YAN_URUN# adlı üründen (#soru_#) sorusuna bağlı olan #attributes.question_stock_name# ürünü silindi.</li><br/>">
					</cfloop>
				</cfif>				
			</cfoutput>
			<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td><cfif not get_product_trees.recordcount><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!<cfelse><cfoutput>#message_#</cfoutput></cfif></td>
				</tr> 
			</table>
		</cfif>
		</td>
	</tr>
</table>
<script type="text/javascript">
	function form_kontrol()
	{
		if(document.report_special.cat.value == '' && (document.report_special.product_id_1.value == '' && document.report_special.product_name_1.value == '')  && (document.report_special.product_id_2.value == '' && document.report_special.product_name_2.value == '')  && (document.report_special.product_id_3.value == '' && document.report_special.product_name_3.value == '')  && (document.report_special.product_id_4.value == '' && document.report_special.product_name_4.value == '')  && (document.report_special.product_id_5.value == '' && document.report_special.product_name_5.value == ''))
		{
			alert("<cf_get_lang dictionary_id='36743.Ürün Kategorisi veya Ürün Seçmelisiniz'>!");
			return false;
		}
		if(document.report_special.question_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='36756.Alternatif Soru Seçmelisiniz'>!");
			return false;
		}
		if(document.report_special.question_stock_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='45516.Hammadde'> <cf_get_lang dictionary_id='57734.Seçiniz'>!");
			return false;
		}
	}
</script>
