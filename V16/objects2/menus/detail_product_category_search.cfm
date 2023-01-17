<cfset attributes.is_hidden_info = 1>
<cfif isdefined("attributes.is_detail_search_company") and attributes.is_detail_search_company>
   <cfinclude template="../sale/list_pro_info.cfm">
<cfelse>
	<cfset get_values.recordcount = 0>
</cfif>
<cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>
	<cfquery name="GET_WORDS" datasource="#DSN3#">
		SELECT PRODUCT_STAGE FROM PRODUCT_STAGE ORDER BY PRODUCT_STAGE
	</cfquery>
</cfif>
<cfif get_values.recordcount or (isdefined("attributes.is_detail_search_company") and attributes.is_detail_search_company eq 0)>
	<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
		SELECT 
			PC.PRODUCT_CAT,
			PC.PRODUCT_CATID,
			PC.HIERARCHY
		FROM 
			PRODUCT_CAT PC,
			PRODUCT_CAT_OUR_COMPANY PCO
		WHERE 
			PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
			PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			PC.IS_PUBLIC = 1	
		ORDER BY
			PC.HIERARCHY,
			PC.PRODUCT_CAT
	</cfquery>
	<cfquery name="GET_BRANDS" datasource="#DSN1#">
		SELECT 
			PB.BRAND_NAME,
			PB.BRAND_ID
		FROM 
			PRODUCT_BRANDS PB,
			PRODUCT_BRANDS_OUR_COMPANY PBO
			<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and isnumeric(attributes.product_catid)>
				,PRODUCT_CAT_BRANDS PCB
			</cfif>
		WHERE
			<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and isnumeric(attributes.product_catid)>
				PCB.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
				PB.BRAND_ID = PCB.BRAND_ID AND
			</cfif>
			PB.BRAND_ID = PBO.BRAND_ID AND
			PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			PB.IS_ACTIVE = 1 AND
			PB.IS_INTERNET = 1
		ORDER BY 
			PB.BRAND_NAME
	</cfquery>
	<cfquery name="GET_SEGMENTS" datasource="#DSN1#"><!--- #dsn3# fs 20090506 --->
		SELECT PRODUCT_SEGMENT_ID,PRODUCT_SEGMENT FROM PRODUCT_SEGMENT ORDER BY PRODUCT_SEGMENT
	</cfquery>
	<cfquery name="GET_DETAIL_MONEY" datasource="#DSN2#">
		SELECT MONEY FROM SETUP_MONEY
	</cfquery>
	<cfparam name="attributes.segment_id" default="">
	<cfparam name="attributes.detail_money_type" default="">
	<table align="center">
	   <tr>
			<td>
				<cfset list_variation_id = ''>
				<cfset list_property_id = ''>
                <cfif isdefined("attributes.variation_select") and listlen(attributes.variation_select)>
                    <cfloop list="#attributes.variation_select#" index="ccm">
                        <cfif not listfindnocase(list_variation_id,listgetat(ccm,2,'*'))>
                            <cfset list_variation_id = listappend(list_variation_id ,listgetat(ccm,2,'*'))>
                        </cfif>
                        <cfif not listfindnocase(list_property_id,listgetat(ccm,1,'*'))>
                            <cfset list_property_id = listappend(list_property_id,listgetat(ccm,1,'*'))>
                        </cfif>
                    </cfloop>
                </cfif> 
                <cfform name="search_product_property" action="#request.self#?fuseaction=objects2.view_product_list" method="post">
                    <input type="hidden" name="form_submitted" id="form_submitted">
					<cfif isdefined("attributes.is_detail_search_category") and attributes.is_detail_search_category>
                        <input type="hidden" name="is_detail_search_category" id="is_detail_search_category" value="1">
                    </cfif>
                    <cfif isdefined("attributes.is_detail_search_brand") and attributes.is_detail_search_brand>
                        <input type="hidden" name="is_detail_search_brand" id="is_detail_search_brand" value="1">
                    </cfif>
                    <cfif isdefined("attributes.is_detail_search_target") and attributes.is_detail_search_target>
                        <input type="hidden" name="is_detail_search_target" id="is_detail_search_target" value="1">
                    </cfif>
                    <cfif isdefined("attributes.is_detail_search_category_bound") and attributes.is_detail_search_category_bound>
                        <input type="hidden" name="is_detail_search_category_bound" id="is_detail_search_category_bound" value="1">
                    </cfif>
                    <cfif isdefined("attributes.is_detail_search_brand_bound") and attributes.is_detail_search_brand_bound>
                        <input type="hidden" name="is_detail_search_brand_bound" id="is_detail_search_brand_bound" value="1">
                    </cfif>
                    <cfif isdefined("attributes.is_detail_search_target_bound") and attributes.is_detail_search_target_bound>
                        <input type="hidden" name="is_detail_search_target_bound" id="is_detail_search_target_bound" value="1">
                    </cfif>
                    <table>
                        <tr class="txtbold">
                            <cfif isdefined("attributes.is_detail_search_category") and attributes.is_detail_search_category>
                                <td width="145"><cf_get_lang_main no='74.Kategori'></td> 
                            </cfif>
                            <cfif isdefined("attributes.is_detail_search_brand") and attributes.is_detail_search_brand>
                                <td><cf_get_lang_main no='1435.Marka'></td>
                            </cfif>
                            <cfif isdefined("attributes.is_detail_search_target") and attributes.is_detail_search_target>
                                <td><cf_get_lang no='419.Hedef Pazar'></td>
                            </cfif>
                            <cfif isdefined("attributes.is_detail_search_price") and attributes.is_detail_search_price>
                                <td colspan="2"><cf_get_lang no='420.Fiyat Aralıgı'></td>
                            </cfif> 
                            <cfif isdefined("attributes.is_detail_search_keyword") and attributes.is_detail_search_keyword>
                                <td width="110"><cf_get_lang no='1033.Anahtar Kelime'></td>
                            </cfif>
                        </tr>
						<cfif (isdefined("attributes.is_detail_search_category") and attributes.is_detail_search_category) or (isdefined("attributes.is_detail_search_keyword") and attributes.is_detail_search_keyword)>
                            <tr style="height:30px;">
                                <cfif isdefined("attributes.is_detail_search_category") and attributes.is_detail_search_category>
                                    <td style="width:145px;">
                                        <select name="product_catid" id="product_catid" style="width:145px;" onChange="showaltcategory();redirect(this.options.selectedIndex);">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_product_cat">
                                                <option value="#product_catid#" <cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and (attributes.product_catid eq product_catid)>selected</cfif>><cfloop from="2" to="#listlen(hierarchy,'.')#" index="pc">&nbsp;&nbsp;</cfloop>#product_cat#</option>
                                            </cfoutput>
                                        </select>
                                    </td> 
                                </cfif>
                                <cfif isdefined("attributes.is_detail_search_brand") and attributes.is_detail_search_brand>
                                    <td>
                                        <select name="brand_id" id="brand_id" style="width:110px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_brands">
                                                <option value="#brand_id#" <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and  (attributes.brand_id eq brand_id)>selected</cfif>>#brand_name#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                            	</cfif>
								<cfif isdefined("attributes.is_detail_search_target") and attributes.is_detail_search_target>
                                    <td>
                                        <select name="segment_id" id="segment_id" style="width:150px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_segments">
                                                <option value="#product_segment_id#" <cfif attributes.segment_id eq product_segment_id>Selected</cfif>>#product_segment#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </cfif>
                                <cfif isdefined("attributes.is_detail_search_price") and attributes.is_detail_search_price>
                                    <td colspan="2">
                                        <input type="text" name="price_first_value" id="price_first_value" value="<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value)><cfoutput>#attributes.price_first_value#</cfoutput></cfif>" style="width:60px;" onKeyUp="return(FormatCurrency(this,event,0));"> ile
                                        <input type="text" name="price_last_value" id="price_last_value" value="<cfif isdefined("attributes.price_last_value") and len(attributes.price_last_value)><cfoutput>#attributes.price_last_value#</cfoutput></cfif>" style="width:60px;" onKeyUp="return(FormatCurrency(this,event,0));">
                                        <select name="detail_money_type" id="detail_money_type" style="width:50px;">
                                            <cfoutput query="get_detail_money">
                                                <option value="#money#" <cfif attributes.detail_money_type eq get_detail_money.money>selected</cfif>>#get_detail_money.money#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
								</cfif> 
								<cfif isdefined("attributes.is_detail_search_keyword") and attributes.is_detail_search_keyword>
                                    <td style="width:110px;">
                                        <input type="text" name="detail_search_keyword" id="detail_search_keyword" style="width:110px;" <cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>onkeyup="autoComplete(riders, this, event);" autocompletion="off"</cfif> value="<cfif isdefined("attributes.detail_search_keyword") and len(attributes.detail_search_keyword)><cfoutput>#attributes.detail_search_keyword#</cfoutput></cfif>">
                                    </td>
                                </cfif>
								<td style="text-align:right;"><cf_workcube_buttons is_cancel="0" insert_info="Ara" add_function='gonder()' insert_alert=''></td>
							</tr>
						</cfif>
					</table>
				</td>
	   		</tr>
	   		<tr>
				<td colspan="2"><div id="property_place"></div></td>
	   		</tr>
			<cfif isdefined("attributes.product_catid") and len("attributes.product_catid")>
				<script type="text/javascript">
                    AjaxPageLoad("<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_property&product_catid=#attributes.product_catid#&list_variation_id=#list_variation_id#</cfoutput>",'property_place',1);
               </script>
			</cfif>
		</cfform>
	</table>
    <cfquery name="BRAND_SEC_ALL" datasource="#DSN1#">
        SELECT
            PRODUCT_BRANDS.BRAND_ID,
            PRODUCT_BRANDS.BRAND_NAME,
            PRODUCT_CAT_BRANDS.PRODUCT_CAT_ID 
        FROM
            PRODUCT_CAT_BRANDS,
            PRODUCT_BRANDS,
            PRODUCT_BRANDS_OUR_COMPANY PBO
        WHERE
            PRODUCT_BRANDS.BRAND_ID = PBO.BRAND_ID AND
            PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
            PRODUCT_CAT_BRANDS.BRAND_ID = PRODUCT_BRANDS.BRAND_ID AND
            PRODUCT_BRANDS.IS_ACTIVE = 1 AND
            PRODUCT_BRANDS.IS_INTERNET = 1
    </cfquery>
	<script type="text/javascript">
        var groups=document.search_product_property.product_catid.options.length;
        var group=new Array(groups);
        
        for (i=0; i<groups; i++)
            group[i]=new Array();
        
        <cfset prod_cat = ArrayNew(1)>
        
        <cfoutput query="get_product_cat">
            <cfset prod_cat[currentrow]=#product_catid#>
        </cfoutput>
        
        <cfloop from="1" to="#ArrayLen(prod_cat)#" index="indexer">
            <cfquery name="BRAND_SEC" dbtype="query">
                SELECT
                    *
                FROM
                    BRAND_SEC_ALL
                WHERE				
                    PRODUCT_CAT_ID =  #prod_cat[INDEXER]#
            </cfquery>
            <cfif BRAND_SEC.recordcount>
                <cfoutput query="BRAND_SEC">
                    <cfif currentrow eq 1>
                        group[#indexer#][#currentrow - 1#]=new Option("Marka","");
                    </cfif>
                    group[#indexer#][#currentrow#]=new Option("#BRAND_NAME#","#BRAND_ID#");	
                </cfoutput>
            <cfelse>
                <cfset deg = 0>
                <cfoutput>
                    group[#indexer#][#deg#]=new Option("Marka","");
                </cfoutput>
            </cfif>
        </cfloop>
        
        var temp=document.search_product_property.brand_id;
        function redirect(x)
        {
            for (m=temp.options.length-1;m>0;m--)
            temp.options[m]=null;
            for (i=0;i<group[x].length;i++)
            {
                temp.options[i]=new Option(group[x][i].text,group[x][i].value);
            }
        }
        
        function showaltcategory()
        {
            product_catid = document.search_product_property.product_catid.selectedIndex;
            product_catid = document.search_product_property.product_catid[product_catid].value;
    
            var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_get_property&list_variation_id=#list_variation_id#&product_catid="+product_catid+"";
            AjaxPageLoad(send_address,'property_place',1);
        }
        
        function gonder()
        {
            
            if ((document.search_product_property.is_detail_search_category_bound) && (document.search_product_property.is_detail_search_category) && (document.search_product_property.product_catid.value == ''))
            {
                alert("<cf_get_lang no='423.Ürün Kategorisi Seçmelisiniz'> !");
                return false;
            }
            else if ((document.search_product_property.is_detail_search_brand_bound) && (document.search_product_property.is_detail_search_brand) && (document.search_product_property.brand_id.value == ''))
            {
                alert("<cf_get_lang no='424.Hedef Pazar Seçmelisiniz'> !");
                return false;
            }
            else if ((document.search_product_property.is_detail_search_target_bound) && (document.search_product_property.is_detail_search_target) && (document.search_product_property.segment_id.value == ''))
            {
                alert("<cf_get_lang no='424.Hedef Pazar Seçmelisiniz'> !");
                return false;
            }
            return true;
        }
		<cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>
			//medyasoft autocomplate icin yazildi ajax gerekmez
			var riders = [
			  <cfoutput query="get_words">
			  "#product_stage#"<cfif currentrow neq recordcount>,</cfif>
			  </cfoutput>
			];
			function autoComplete (dataArray, input, evt) {
			  if (input.value.length == 0) {
				return;
			  }
			  var match = false;
			  for (var i = 0; i < dataArray.length; i++) {
				if ((match = dataArray[i].toLowerCase().indexOf
			(input.value.toLowerCase()) == 0)) {
				  break;
				}
			  }
			  if (match) {
				var typedText = input.value;
				if (typeof input.selectionStart != 'undefined') {
				  if (evt.keyCode == 16) {
					return;
				  }
				  input.value = dataArray[i];
				  input.setSelectionRange(typedText.length, input.value.length);
				}
				else if (input.createTextRange) {
				  if (evt.keyCode == 16) {
					return;
				  }

				  input.value = dataArray[i];
				  var range = input.createTextRange();
				  range.moveStart('character', typedText.length);
				  range.moveEnd('character', input.value.length);
				  range.select();
				}
				else {
				  if (confirm("Are you looking for '" + dataArray[i] + "'?")) {
					input.value = dataArray[i];
				  }
				}
			  }
			}
		</cfif>
	</script>
</cfif>
