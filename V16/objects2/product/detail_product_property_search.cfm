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
<cfset dsn1 = '#dsn#_product'>
<cfif get_values.recordcount or (isdefined("attributes.is_detail_search_company") and attributes.is_detail_search_company eq 0)>
	<cfquery name="GET_PRODUCT_CAT" datasource="#dsn1#">
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
	<cfquery name="GET_BRANDS" datasource="#dsn1#">
		SELECT 
			PB.BRAND_NAME,
			PB.BRAND_ID
		FROM 
			PRODUCT_BRANDS PB,
			PRODUCT_BRANDS_OUR_COMPANY PBO
		WHERE
			PB.BRAND_ID = PBO.BRAND_ID AND
			PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			PB.IS_ACTIVE = 1 AND
			PB.IS_INTERNET = 1
		ORDER BY 
			PB.BRAND_NAME
	</cfquery>
	<cfquery name="GET_PROPERTY" datasource="#DSN1#">
		SELECT DISTINCT
			PP.PROPERTY,
			PP.PROPERTY_ID
		FROM 
			PRODUCT_PROPERTY PP,
			PRODUCT_PROPERTY_OUR_COMPANY PPO
		WHERE
			PP.PROPERTY_ID = PPO.PROPERTY_ID AND
			PPO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			PP.IS_INTERNET = 1 AND
			PP.IS_ACTIVE = 1
	</cfquery>
	<cfquery name="GET_ALL_PROPERTY_DETAIL" datasource="#DSN1#">
		SELECT
			PRPT_ID,
			PROPERTY_DETAIL_ID,
			PROPERTY_DETAIL
		FROM
			PRODUCT_PROPERTY_DETAIL
		WHERE
			IS_ACTIVE = 1 AND
			PRPT_ID IN (#ValueList(get_property.property_id)#)
	</cfquery>
    <cfquery name="GET_LANGUAGE_INFOS" datasource="#DSN#">
        SELECT
            ITEM,
            UNIQUE_COLUMN_ID
        FROM
            SETUP_LANGUAGE_INFO
        WHERE
            <cfif isdefined('session.pp')>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
            <cfelse>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
            </cfif>
            COLUMN_NAME = 'PROPERTY' AND
            TABLE_NAME = 'PRODUCT_PROPERTY'
    </cfquery>
    <cfquery name="GET_LANGUAGE_INFOS2" datasource="#DSN#">
        SELECT
            ITEM,
            UNIQUE_COLUMN_ID
        FROM
            SETUP_LANGUAGE_INFO
        WHERE
            <cfif isdefined('session.pp')>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
            <cfelse>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
            </cfif>
            COLUMN_NAME = 'PROPERTY_DETAIL' AND
            TABLE_NAME = 'PRODUCT_PROPERTY_DETAIL'
    </cfquery>
	<cfquery name="GET_SEGMENTS" datasource="#DSN1#"><!--- #dsn3# fs 20090506 --->
		SELECT PRODUCT_SEGMENT_ID,PRODUCT_SEGMENT FROM PRODUCT_SEGMENT ORDER BY PRODUCT_SEGMENT
	</cfquery>
	<cfquery name="GET_DETAIL_MONEY" datasource="#DSN2#">
		SELECT MONEY FROM SETUP_MONEY
	</cfquery>
	<cfparam name="attributes.segment_id" default="">
	<cfparam name="attributes.detail_money_type" default="">
    <cfif attributes.detail_product_property_search_design eq 0>
		<style>
			a.list-group-item.p-2.list-child-1 {
				font-weight: 500;
				color: #0D47A1;
			}
			a.list-group-item.p-2.list-child-2 {
				font-weight: 500;
				color: #1976D2;
				padding-left: 15px !important;
			}
			a.list-group-item.p-2.list-child-3 {
				font-weight: 500;
				color: #2196F3;
				padding-left: 30px !important;
			}

			.scroll-md::-webkit-scrollbar {
				width: 6px;
				position: absolute;
			}

			.scroll-md::-webkit-scrollbar-button {
				height: 90%;
			}

			.scroll-md::-webkit-scrollbar-thumb {
				background: #0d47a1;
				border: 0px none #ffffff;
			}

			.scroll-md::-webkit-scrollbar-thumb:hover {
				background: #043d6a;
			}

			.scroll-md::-webkit-scrollbar-thumb:active {
				background: #043d6a;
			}

			.scroll-md::-webkit-scrollbar-track {
				background: #e6e6e6;
				border: 0px none #ffffff;
			}

			.scroll-md::-webkit-scrollbar-track:hover {
				background:  #e6e6e6;
			}

			.scroll-md::-webkit-scrollbar-track:active {
				background:  #e6e6e6;
			}

			.scroll-md::-webkit-scrollbar-corner {
				background: #2196f3;
			}

			.scroll-md {
				overflow: auto;
				max-height: 400px;
				overflow-x: hidden;
			}

            .filter-selected-item {
                color: white !important;
                background: #0d47a1;
            }
		</style>
		<cfform name="search_product_property" id="search_product_property" action="" method="post">
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
			<article class="card-group-item">
				<header class="bg-transparent card-header p-2"><h6 class="title">Kategori </h6></header>
				<div class="filter-content scroll-md" >
					<div class="list-group list-group-flush">
                    <input type="hidden" name="product_catid" id="product_catid" value='<cfif isdefined("form.product_catid") and len(form.product_catid)><cfoutput>#form.product_catid#</cfoutput></cfif>'>
					<cfoutput query="get_product_cat">
						<a href="##" onClick="search_post('cat',#product_catid#);" class="list-group-item p-2 list-child-#listlen(hierarchy,'.')# #( isdefined("form.product_catid") AND form.product_catid eq product_catid)?'filter-selected-item':''#">#product_cat#</a>
					</cfoutput>
					</div>  <!-- list-group .// -->
				</div>
			</article> <!-- card-group-item.// -->
			<article class="card-group-item">
				<header class="bg-transparent card-header p-2">
					<h6 class="title">Markalar </h6>
				</header>
				<div class="filter-content">
					<div class="card-body scroll-md">
                        <input type="hidden" name="brand_id" id="brand_id" value='<cfif isdefined("form.brand_id") and len(form.product_catid)><cfoutput>#form.brand_id#</cfoutput></cfif>'>
						<cfoutput query="get_brands">
							<label class="form-check">
								<input class="form-check-input" onClick="search_post('brand',#brand_id#);" id="brands" type="checkbox" value="#brand_id#" <cfif isdefined("form.brand_id") and  form.brand_id eq brand_id >checked</cfif>>
								<span class="form-check-label">
									#brand_name#
								</span>
							</label> <!-- form-check.// -->
						</cfoutput>
		
					</div> <!-- card-body.// -->
				</div>
			</article> <!-- card-group-item.// -->
			<article class="card-group-item">
				<header class="bg-transparent card-header p-2">
					<h6 class="title">Fiyat Aralığı </h6>
				</header>
                <div class="filter-content">
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-md-4">
                                <input type="text" class="form-control" name="price_first_value" id="price_first_value" value="<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value)><cfoutput>#attributes.price_first_value#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event,0));">
                            </div>
                            <div class="form-group col-md-4"> 
                                <input type="text" class="form-control" name="price_last_value" id="price_last_value" value="<cfif isdefined("attributes.price_last_value") and len(attributes.price_last_value)><cfoutput>#attributes.price_last_value#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event,0));">
                            </div>
                            <div class="form-group col-md-4">    
                                <select name="detail_money_type" id="detail_money_type"  class="form-control">
                                    <cfoutput query="get_detail_money">
                                        <option value="#money#" <cfif attributes.detail_money_type eq get_detail_money.money>selected</cfif>>#get_detail_money.money#</option>
                                    </cfoutput>
                                </select>
                                <label><cf_get_lang dictionary_id ='35694.Arasında'></label>
                            </div>
                        </div>
                     </div> <!-- card-body.// -->
                </div>
			</article> <!-- card-group-item.// -->
			<article class="card-group-item" style="bottom: 0px; position: sticky; background: #fff; padding: 5px 19px;">
				<button type="submit" class="btn btn-primary w-100">Filtrele</button>
			</article>
		</cfform>
        <script type="text/javascript">
            function search_post(filter,v)
            {
               if(filter == "cat"){
                    $("#product_catid").val(v);
               }else if(filter == "brand"){
                    $("#brand_id").val(v);
               }
               $("#search_product_property").submit();
            }
        </script>
	<cfelse>	
        <cfform name="search_product_property" action="#request.self#?fuseaction=objects2.view_product_list" method="post">
        <table align="center" style="width:100%">
            <tr>
                <td>
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
                        <cfif (isdefined("attributes.is_detail_search_category") and attributes.is_detail_search_category) or (isdefined("attributes.is_detail_search_keyword") and attributes.is_detail_search_keyword)>
                            <tr style="height:30px;"> 
                                <cfif isdefined("attributes.is_detail_search_keyword") and attributes.is_detail_search_keyword>
                                    <td style="width:90px;"><cf_get_lang_main no='809.Ürün Adı'> / <cf_get_lang_main no='1173.Kod'></td>
                                    <td style="width:190px;">
                                        <input type="text" name="detail_search_keyword" id="detail_search_keyword" style="width:170px;" <cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>onkeyup="autoComplete(riders, this, event);" autocompletion="off"</cfif> value="<cfif isdefined("attributes.detail_search_keyword") and len(attributes.detail_search_keyword)><cfoutput>#attributes.detail_search_keyword#</cfoutput></cfif>">
                                    </td>
                                </cfif> 
                            </tr>
                            <tr>	
                            <cfif isdefined("attributes.is_detail_search_category") and attributes.is_detail_search_category>
                                    <td><cf_get_lang_main no='74.Kategori'></td>
                                    <td>
                                        <select name="product_catid" id="product_catid" style="width:170px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_product_cat">
                                                <option value="#product_catid#" <cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and (attributes.product_catid eq product_catid)>selected</cfif>><cfloop from="2" to="#listlen(hierarchy,'.')#" index="pc">&nbsp;&nbsp;</cfloop>#product_cat#</option>
                                            </cfoutput>
                                        </select>
                                    </td> 
                                </cfif>
                            </tr>
                        </cfif>
                        <cfif (isdefined("attributes.is_detail_search_target") and attributes.is_detail_search_target) or (isdefined("attributes.is_detail_search_brand") and attributes.is_detail_search_brand)>
                            <tr>
                                <cfif isdefined("attributes.is_detail_search_target") and attributes.is_detail_search_target>
                                    <td style="width:90px;"><cf_get_lang no='419.Hedef Pazar'></td>
                                    <td>
                                        <select name="segment_id" id="segment_id" style="width:170px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_segments">
                                                <option value="#product_segment_id#" <cfif attributes.segment_id eq product_segment_id>Selected</cfif>>#product_segment#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </cfif>
                                <cfif isdefined("attributes.is_detail_search_brand") and attributes.is_detail_search_brand>
                                    <td><cf_get_lang_main no='1435.Marka'></td>
                                    <td>
                                        <select name="brand_id" id="brand_id" style="width:170px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_brands">
                                                <option value="#brand_id#" <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and  (attributes.brand_id eq brand_id)>selected</cfif>>#brand_name#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </cfif>
                            </tr>
                        </cfif>
                        <cfif isdefined("attributes.is_detail_search_price") and attributes.is_detail_search_price>
                            <tr>	
                                <td><cf_get_lang dictionary_id='34741.Fiyat Aralığı'></td>
                                <td colspan="2">
                                    <input type="text" name="price_first_value" id="price_first_value" value="<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value)><cfoutput>#attributes.price_first_value#</cfoutput></cfif>" style="width:75px;" onkeyup="return(FormatCurrency(this,event,0));"> ile
                                    <input type="text" name="price_last_value" id="price_last_value" value="<cfif isdefined("attributes.price_last_value") and len(attributes.price_last_value)><cfoutput>#attributes.price_last_value#</cfoutput></cfif>" style="width:75px;" onkeyup="return(FormatCurrency(this,event,0));">
                                    <select name="detail_money_type" id="detail_money_type" style="width:50px;">
                                        <cfoutput query="get_detail_money">
                                            <option value="#money#" <cfif attributes.detail_money_type eq get_detail_money.money>selected</cfif>>#get_detail_money.money#</option>
                                        </cfoutput>
                                    </select><cf_get_lang dictionary_id ='35694.Arasında'>
                                </td>
                            </tr>
                        </cfif>  
                    </table>
                </td>
            </tr>
            <cfif get_property.recordcount>
                <tr style="height:25px;">
                    <td><a href="javascript://" onclick="gizle_goster(detail_search);">&raquo;</a><cf_get_lang_main no='220.Özellikler'></td>
                </tr>
                <tr id="detail_search">
                    <td colspan="2" style="vertical-align:top;">
                        <table>
                            <input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id)><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
                            <input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id") and len(attributes.list_variation_id)><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
                            <cfoutput query="get_property">
                                <cfquery name="GET_VARIATION" dbtype="query">
                                    SELECT
                                        PROPERTY_DETAIL_ID,
                                        PROPERTY_DETAIL
                                    FROM
                                        GET_ALL_PROPERTY_DETAIL
                                    WHERE
                                        PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
                                </cfquery>
                                <cfquery name="GET_LANGUAGE_INFO" dbtype="query">
                                    SELECT
                                        *
                                    FROM
                                        GET_LANGUAGE_INFOS
                                    WHERE
                                        UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
                                </cfquery>
                                <cfif ((currentrow mod 2 is 1)) or (currentrow eq 1)><tr id="frm_row#currentrow#"></cfif>
                                <td style="width:90px;"><cfif get_language_info.recordcount>#get_language_info.item#<cfelse>#property#</cfif></td> 
                                <td  <cfif ((currentrow mod 2 is 1)) or (currentrow eq 1)>style="width:190px;"</cfif>>
                                    <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                    <input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#property_id#">
                                    <select name="variation_id#currentrow#" id="variation_id#currentrow#" style="width:170px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="get_variation">	
                                            <cfquery name="GET_LANGUAGE_INFO2" dbtype="query">
                                                SELECT
                                                    *
                                                FROM
                                                    GET_LANGUAGE_INFOS2
                                                WHERE
                                                    UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_detail_id#">
                                            </cfquery>
                                            <option value="#property_detail_id#" <cfif isdefined("attributes.list_variation_id") and listfind(attributes.list_variation_id,get_variation.property_detail_id,',')>selected</cfif>>&nbsp;&nbsp;&nbsp;<cfif get_language_info2.recordcount>#get_language_info2.item#<cfelse>#property_detail#</cfif></option>
                                        </cfloop>
                                    </select>
                                </td>
                                <cfif ((currentrow mod 2 is 0)) or (currentrow eq recordcount)></tr></cfif>
                            </cfoutput>
                        </table>
                    </td>
                </tr>
            </cfif>
            <cfsavecontent variable="alert"><cf_get_lang_main no ='153.Ara'></cfsavecontent>
            <tr><td  style="text-align:right;"><cf_workcube_buttons is_cancel="0" insert_info="#alert#" add_function='gonder()' insert_alert=''></td></tr>
        </table>
        </cfform>
        <script type="text/javascript">
            row_count=<cfoutput>#get_property.recordcount#</cfoutput>;
            function gonder()
            {
                if ((document.getElementById('is_detail_search_category_bound')) && (document.getElementById('is_detail_search_category')) && (document.getElementById('product_catid').value == ''))
                {
                    alert("<cf_get_lang no='423.Ürün Kategorisi Seçmelisiniz'> !");
                    return false;
                }
                else if ((document.getElementById('is_detail_search_brand_bound')) && (document.getElementById('is_detail_search_brand')) && (document.getElementById('brand_id').value == ''))
                {
                    alert("<cf_get_lang_main no='1534.Marka Secmelisiniz'>");
                    return false;
                }
                else if ((document.getElementById('is_detail_search_target_bound')) && (document.getElementById('is_detail_search_target')) && (document.getElementById('segment_id').value == ''))
                {
                    alert("<cf_get_lang no='424.Hedef Pazar Seçmelisiniz'> !");
                    return false;
                }
                else
                {
                    document.getElementById('list_property_id').value= '';
                    document.getElementById('list_variation_id').value= '';
                    for(r=1;r<=row_count;r++)
                    {
                        deger_property_id = eval("document.getElementById('property_id"+r+"')");
                        deger_variation_id = eval("document.getElementById('variation_id"+r+"')");
                        if(deger_variation_id.value != "")
                        {
                            if(document.getElementById('list_property_id').value.length==0) ayirac=''; else ayirac=',';
                            document.getElementById('list_property_id').value=document.getElementById('list_property_id').value+ayirac+deger_property_id.value;
                            document.getElementById('list_variation_id').value=document.getElementById('list_variation_id').value+ayirac+deger_variation_id.value;
                        }
                    }
                    return true;
                }
            }
            <cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>
                //medyasoft autocomplate icin yazildi ajax gerekmez
                var riders = [
                <cfoutput query="get_words">
                    "#product_stage#"<cfif currentrow neq recordcount>,</cfif>
                </cfoutput>
                ];
                function autoComplete (dataArray, input, evt) 
                {
                    if (input.value.length == 0) {
                        return;
                    }
                    var match = false;
                    for (var i = 0; i < dataArray.length; i++) 
                    {
                        if ((match = dataArray[i].toLowerCase().indexOf
                (input.value.toLowerCase()) == 0)) 
                        {
                            break;
                        }
                    }
                    if (match) 
                    {
                        var typedText = input.value;
                        if (typeof input.selectionStart != 'undefined') 
                        {
                            if (evt.keyCode == 16) 
                            {
                                return;
                            }
                            input.value = dataArray[i];
                            input.setSelectionRange(typedText.length, input.value.length);
                        }
                        else if (input.createTextRange) 
                        {
                            if (evt.keyCode == 16) 
                            {
                                return;
                            }
                            input.value = dataArray[i];
                            var range = input.createTextRange();
                            range.moveStart('character', typedText.length);
                            range.moveEnd('character', input.value.length);
                            range.select();
                        }
                        else 
                        {
                            if (confirm("Are you looking for '" + dataArray[i] + "'?")) 
                            {
                                input.value = dataArray[i];
                            }
                        }
                    }
                }
            </cfif>
        </script>
    </cfif>
</cfif>
