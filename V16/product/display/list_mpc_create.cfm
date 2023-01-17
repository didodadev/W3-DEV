<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.product_code_2" default="">
<cfif not isdefined("attributes.product_id")>
	<cfif not len(attributes.product_catid)>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='32972.Önce Kategori Seçmelisiniz'>");
            window.close();
        </script>
        <cfabort>
    </cfif> 
</cfif>
<cfif isdefined("attributes.product_id")>
    <cfquery name="GET_PRODUCT_PROPERTIES_REC" datasource="#DSN1#">
        SELECT PRODUCT_ID FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
    </cfquery>
    <cfquery name="CATEGORY" datasource="#DSN1#">
        SELECT HIERARCHY FROM PRODUCT_CAT PC,PRODUCT P WHERE P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND PC.PRODUCT_CATID = P.PRODUCT_CATID
    </cfquery>
    <cfset attributes.hierarchy = listdeleteat(category.hierarchy,ListLen(category.hierarchy,"."),".")>
    <cfif get_product_properties_rec.recordcount><!--- daha once ozellik ile ilgili varyasyon tanımlanmıssa Guncelleme --->
        <cfquery name="GET_PROPERTY" datasource="#DSN1#">
            SELECT 
                NULL DETAIL,
                0 IS_EXIT,
                0 TOTAL_MIN,
                0 TOTAL_MAX,
                0 AMOUNT,
                NULL RECORD_DATE,
                NULL RECORD_EMP,
                NULL UPDATE_EMP,
                NULL UPDATE_DATE,
                PRODUCT_CAT_PROPERTY.IS_OPTIONAL,<!--- MIKTAR --->
                PRODUCT_CAT_PROPERTY.IS_INTERNET,<!--- WEB --->
                PRODUCT_CAT_PROPERTY.LINE_VALUE,
                PRODUCT_PROPERTY.PROPERTY_ID,
                PRODUCT_PROPERTY.PROPERTY,
                NULL VARIATION_ID
            FROM 
                PRODUCT_CAT_PROPERTY,
                PRODUCT_PROPERTY,
                PRODUCT AS PRODUCT
            WHERE 
                PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID AND
                PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID AND
                PRODUCT_CAT_PROPERTY.PROPERTY_ID NOT IN (SELECT PROPERTY_ID FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID = PRODUCT.PRODUCT_ID) AND
                PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            UNION
            SELECT 
                NULL DETAIL,
                0 IS_EXIT,
                0 TOTAL_MIN,
                0 TOTAL_MAX,
                0 AMOUNT,
                NULL RECORD_DATE,
                NULL RECORD_EMP,
                NULL UPDATE_EMP,
                NULL UPDATE_DATE,
                PRODUCT_CAT_PROPERTY.IS_OPTIONAL,<!--- MIKTAR --->
                PRODUCT_CAT_PROPERTY.IS_INTERNET,<!--- WEB --->
                PRODUCT_CAT_PROPERTY.LINE_VALUE,
                PRODUCT_PROPERTY.PROPERTY_ID,
                PRODUCT_PROPERTY.PROPERTY,
                NULL VARIATION_ID
            FROM 
                PRODUCT_CAT,
                PRODUCT_CAT_PROPERTY,
                PRODUCT_PROPERTY
            WHERE 
                PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID AND
                PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT_CAT.PRODUCT_CATID AND
                PRODUCT_CAT_PROPERTY.PROPERTY_ID NOT IN (SELECT PROPERTY_ID FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">) AND
                PRODUCT_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#">
            UNION ALL
            SELECT 
                PRODUCT_DT_PROPERTIES.DETAIL,
                PRODUCT_DT_PROPERTIES.IS_EXIT,
                PRODUCT_DT_PROPERTIES.TOTAL_MIN,
                PRODUCT_DT_PROPERTIES.TOTAL_MAX,
                PRODUCT_DT_PROPERTIES.AMOUNT,
                PRODUCT_DT_PROPERTIES.RECORD_DATE,
                PRODUCT_DT_PROPERTIES.RECORD_EMP,
                PRODUCT_DT_PROPERTIES.UPDATE_EMP,
                PRODUCT_DT_PROPERTIES.UPDATE_DATE,
                PRODUCT_DT_PROPERTIES.IS_OPTIONAL,
                PRODUCT_DT_PROPERTIES.IS_INTERNET,
                PRODUCT_DT_PROPERTIES.LINE_VALUE,
                PRODUCT_DT_PROPERTIES.PROPERTY_ID,
                PRODUCT_PROPERTY.PROPERTY,
                PRODUCT_DT_PROPERTIES.VARIATION_ID
            FROM 
                PRODUCT_DT_PROPERTIES,
                PRODUCT_PROPERTY
            WHERE
                PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
                PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
        ORDER BY 
            LINE_VALUE         
        </cfquery>
    <cfelse><!--- Ekleme --->
        <cfquery name="GET_PROPERTY" datasource="#DSN1#">
           SELECT 
                PRODUCT_CAT_PROPERTY.IS_WORTH <!--- DEGER --->,
                PRODUCT_CAT_PROPERTY.IS_OPTIONAL <!--- MIKTAR --->,
                PRODUCT_CAT_PROPERTY.IS_AMOUNT <!--- INPUT --->,
                PRODUCT_CAT_PROPERTY.IS_INTERNET <!--- WEB --->,
                PRODUCT_CAT_PROPERTY.LINE_VALUE,
                PRODUCT_PROPERTY.PROPERTY PROPERTY,
                PRODUCT_PROPERTY.PROPERTY_ID,
                PRODUCT_PROPERTY.VARIATION_ID
            FROM 
                PRODUCT_CAT_PROPERTY,
                PRODUCT_PROPERTY,
                PRODUCT AS PRODUCT
            WHERE 
                PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID AND
                PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID AND
                PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            UNION
            SELECT 
                PRODUCT_CAT_PROPERTY.IS_WORTH <!--- DEGER --->,
                PRODUCT_CAT_PROPERTY.IS_OPTIONAL <!--- MIKTAR --->,
                PRODUCT_CAT_PROPERTY.IS_AMOUNT <!--- INPUT --->,
                PRODUCT_CAT_PROPERTY.IS_INTERNET <!--- WEB --->,
                PRODUCT_CAT_PROPERTY.LINE_VALUE,
                PRODUCT_PROPERTY.PROPERTY PROPERTY,
                PRODUCT_PROPERTY.PROPERTY_ID,
                PRODUCT_PROPERTY.VARIATION_ID
            FROM 
                PRODUCT_CAT,
                PRODUCT_CAT_PROPERTY,
                PRODUCT_PROPERTY
            WHERE 
                PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID AND
                PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT_CAT.PRODUCT_CATID AND
                PRODUCT_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#">
        ORDER BY 
            LINE_VALUE         
        </cfquery>
    </cfif>
<cfelse>
    <cfquery name="GET_PROPERTY" datasource="#dsn3#">
        SELECT
            PRODUCT_CAT_PROPERTY.PROPERTY_ID,
            PRODUCT_PROPERTY.PROPERTY,
            PRODUCT_PROPERTY.PROPERTY_ID,
            PRODUCT_PROPERTY.VARIATION_ID
        FROM
            #dsn1_alias#.PRODUCT_CAT PRODUCT_CAT,
            #dsn1_alias#.PRODUCT_CAT_PROPERTY PRODUCT_CAT_PROPERTY,
            #dsn1_alias#.PRODUCT_PROPERTY PRODUCT_PROPERTY
        WHERE
            PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID AND
            PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID AND
            PRODUCT_CAT.PRODUCT_CATID = #attributes.product_catid#
    </cfquery>
</cfif>
<cfsavecontent variable="header">
	<cfif not isdefined("attributes.is_ajax")><cf_get_lang dictionary_id="37074.MPC Kodu Oluştur"></cfif>
</cfsavecontent>
<cfsavecontent variable="mpc_icerik">
	<cfif isdefined("attributes.product_id")>
		<cfset action_ = "#request.self#?fuseaction=product.emptypopup_upd_product_dt_property&product_id=#attributes.product_id#
        ">
	<cfelse>
		<cfset action_ = "#request.self#?fuseaction=product.emptypopup_upd_product_dt_property">
	</cfif>
	<cfform name="add_related_property" action="#action_#" method="post">
		<cfoutput>
		<input type="hidden" name="type" id="type" value="#attributes.type#">
		<input type="hidden" name="is_formajax" id="is_formajax" value="<cfif not isdefined("attributes.is_ajax")>1<cfelse>2</cfif>"/>
		<input type="hidden" name="auto_product_code_2" id="auto_product_code_2" value="1"/>
		<input type="hidden" name="record_num" id="record_num" value="#get_property.recordcount#">
		</cfoutput>
        <cf_ajax_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57632.Özellik'></th>
                    <th><cf_get_lang dictionary_id='37249.Varyasyon'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_property">
                    <cfquery name="GET_VARIATION" datasource="#DSN1#">
                        SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL,PROPERTY_DETAIL_CODE FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_property.property_id#">  ORDER BY PROPERTY_DETAIL
                    </cfquery>
                    <tr id="frm_row#currentrow#">
                        <td>
                            <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                            <input type="hidden" name="property#currentrow#" id="property#currentrow#" value="#get_property.property_id#">
                            <cfif isdefined("line_value")>
								<input type="hidden" name="line_value" id="line_value" value="#line_value#"/>
							</cfif>
                            <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.popup_add_property&prpt_id=#property_id#&property=#property#','medium');">#property#</a></td>
                        <td>
							<cfif not isdefined("attributes.is_ajax")> 
                                <div class="form-group">
								<select name="variation_id#currentrow#" id="variation_id#currentrow#" style="width:250px;">
									<option value="" selected="selected"><cf_get_lang dictionary_id='37249.Varyasyon'></option>
									<cfloop query="get_variation">	
										<option value="#property_detail_id#;#property_detail_code#" <cfif len(get_property.variation_id) and get_property.variation_id eq property_detail_id>selected</cfif>>#property_detail#</option>
									</cfloop>
								</select>
                            </div>
							<cfelse>
                            <div class="form-group">
								<select name="variation_id#currentrow#"  id="variation_id#currentrow#" style="width:150px;">
									<option value="" selected="selected"><cf_get_lang dictionary_id='37249.Varyasyon'></option>
									<cfif get_product_properties_rec.recordcount>
										<cfloop query="get_variation">	
											<option value="#property_detail_id#" <cfif len(get_property.variation_id) and get_property.variation_id eq property_detail_id>selected</cfif>>#property_detail#</option>
										</cfloop>
									<cfelse>
										<cfloop query="get_variation">	
											<option value="#property_detail_id#">#property_detail#</option>
										</cfloop>
									</cfif>                            
								</select>
                            </div>
							</cfif>
                        </td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_ajax_list>
        <cf_box_footer>
            <table style="width:100%;">
                <tr>
                    <td style="text-align:right;"><input type="button" value="<cf_get_lang dictionary_id='57461.Kaydet'>" onclick="<cfif not isdefined("attributes.is_ajax")>kontrol_mpc();<cfelse>varyasyon_kaydet();</cfif>"></td>
                </tr>
            </table>
        </cf_box_footer>
		</cfform>
</cfsavecontent>
<cfif not isdefined("attributes.is_ajax")>
    <cf_box title="#header#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    	<cfoutput>#mpc_icerik#</cfoutput>
    </cf_box>
<cfelse>
	<cfoutput>#mpc_icerik#</cfoutput>
</cfif>
<script type="text/javascript">
	function varyasyon_kaydet()
	{
            loadPopupBox('add_related_property' , <cfoutput>#attributes.modal_id#</cfoutput>);
	}
	function kontrol_mpc()
	{
		var mpc_code='';
		for (var r=1;r<=document.getElementById('record_num').value;r++)
		{
			if(list_getat(document.getElementById('variation_id'+r).value,2,';') == "")
			{ 
				alert (r + ". <cf_get_lang dictionary_id='37240.Özellik İçin Varyasyon Kodu Tanımlamalısınız'> ! ");
				return false;
			}				
			if(mpc_code!='')
				mpc_code = mpc_code  + '.' + list_getat(document.getElementById('variation_id'+r).value,2,';');
			else
				mpc_code = list_getat(document.getElementById('variation_id'+r).value,2,';');
		}
		<cfif isdefined("attributes.is_ajax")>
			if(add_related_property.type.value == 1)
				document.getElementById('product_code_2').value = mpc_code;
			else
				document.getElementById('product_code_2').value = mpc_code;
			
			return false;
		<cfelse>
			if(add_related_property.type.value == 1)
				<cfif not isDefined("attributes.draggable")>opener.</cfif>document.getElementById('product_code_2').value = mpc_code;
			else
            <cfif not isDefined("attributes.draggable")>opener.</cfif>document.getElementById('product_code_2').value = mpc_code;
				return varyasyon_kaydet();
                <cfif not isDefined("attributes.draggable")>window.close();</cfif>
		</cfif>	
	}
</script>
