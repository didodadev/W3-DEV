<cfset toplam_ilkdeger1 = 0>
<cfset toplam_ilkdeger_doviz1 = 0>
<cfset toplam_sondeger1 = 0>
<cfset toplam_sondeger_doviz1 = 0>
<cfset toplam_deger1 = 0>
<cfset toplam_deger_doviz1 = 0>
<cfset son_toplam_deger1 = 0>
<cfset son_toplam_deger_doviz1 = 0>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.invent_no" default="">
<cfparam name="attributes.bill_no" default="">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.inventory_cat_id" default="">
<cfparam name="attributes.account_name" default="">
<cfparam name="attributes.amor_method" default="">
<cfparam name="attributes.record_date_1" default="">
<cfparam name="attributes.record_date_2" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.entry_date_1" default="">
<cfparam name="attributes.entry_date_2" default="">
<cfparam name="attributes.output_date_1" default="">
<cfparam name="attributes.output_date_2" default="">
<cfparam name="attributes.inventory_type" default="">
<cfparam name="attributes.sort_type" default="0">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdate(attributes.record_date_1)><cf_date tarih = "attributes.record_date_1"></cfif>
<cfif isdate(attributes.record_date_2)><cf_date tarih = "attributes.record_date_2"></cfif>
<cfif isdate(attributes.entry_date_1)><cf_date tarih = "attributes.entry_date_1"></cfif>
<cfif isdate(attributes.entry_date_2)><cf_date tarih = "attributes.entry_date_2"></cfif>
<cfif isdate(attributes.output_date_1)><cf_date tarih = "attributes.output_date_1"></cfif>
<cfif isdate(attributes.output_date_2)><cf_date tarih = "attributes.output_date_2"></cfif>
<cfif not isdefined("attributes.invent_status")>
	<cfset attributes.invent_status = 1>
</cfif>
<cfset output_type = '1182,66,83'>
<cfset input_type = '118,65,82,1181'>
<cfset value = '0'>
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="get_invent" datasource="#dsn3#">
        WITH CTE1 AS (
            SELECT
                I.INVENTORY_ID,
                I.ACCOUNT_ID,
                I.INVENTORY_CATID,
                I.AMOUNT,
                ISNULL(I.AMOUNT_2,0) AS AMOUNT_2,
                I.LAST_INVENTORY_VALUE,
                ISNULL(I.LAST_INVENTORY_VALUE_2,0) AS LAST_INVENTORY_VALUE_2,
                I.INVENTORY_NAME,
                I.RECORD_DATE,
                I.ENTRY_DATE,
                I.INVENTORY_NUMBER,
                I.AMORTIZATON_METHOD,
                ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) MIKTAR
            FROM
                INVENTORY I
            WHERE
                I.INVENTORY_ID IS NOT NULL	
                <cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
                    AND I.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                </cfif>
                <cfif isdate(attributes.record_date_1)>
                    AND I.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date_1#">
                </cfif>
                <cfif isdate(attributes.record_date_2)>
                    AND I.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.record_date_2)#">
                </cfif>
                <cfif len(attributes.entry_date_1)>
                    AND I.ENTRY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.entry_date_1#">
                </cfif>
                <cfif isdate(attributes.entry_date_2)>
                    AND I.ENTRY_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD("d",1,attributes.entry_date_2)#">
                </cfif>
                <cfif isdate(attributes.output_date_1)>
                    AND INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.output_date_1#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" value="#output_type#">))
                </cfif>
                <cfif isdate(attributes.output_date_2)>
                    AND INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.output_date_2)#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" value="#output_type#">))
                </cfif>
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND I.INVENTORY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <cfif isDefined("attributes.invent_no") and len(attributes.invent_no)>
                    AND I.INVENTORY_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.invent_no#%">
                </cfif>  
                <cfif isDefined("attributes.bill_no") and len(attributes.bill_no)>
                    AND INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.bill_no#%">)
                </cfif>  
                <cfif isDefined("attributes.amor_method") and len(attributes.amor_method)>
                    AND I.AMORTIZATON_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.amor_method#">
                </cfif>
                <cfif isDefined("attributes.inventory_type") and len(attributes.inventory_type)>
                    AND I.INVENTORY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_type#">
                </cfif> 
                <cfif isDefined("attributes.account_id") and len(attributes.account_id)>
                    AND I.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_id#">
                </cfif>
                <cfif isDefined("attributes.inventory_cat_id") and len(attributes.inventory_cat_id) and isDefined("attributes.inventory_cat") and len(attributes.inventory_cat)>
                    AND I.INVENTORY_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_cat_id#">
                </cfif>
                <cfif isDefined("attributes.invent_status") and len(attributes.invent_status)>
                    <cfif attributes.invent_status eq 1>
                        AND I.LAST_INVENTORY_VALUE > <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                        AND ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) > <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                    <cfelse>
                        AND 
                        (
                            I.LAST_INVENTORY_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                            OR 
                            ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY)  = <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                        )
                    </cfif>
                </cfif>
           )
           ,
           CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (   ORDER BY 
                                                    <cfif Len(attributes.sort_type) and attributes.sort_type eq 1>
                                                        INVENTORY_NAME DESC
                                                    <cfelseif  Len(attributes.sort_type) and attributes.sort_type eq 2>
                                                        INVENTORY_NUMBER
                                                    <cfelseif  Len(attributes.sort_type) and attributes.sort_type eq 3>
                                                        INVENTORY_NUMBER DESC
                                                    <cfelseif  Len(attributes.sort_type) and attributes.sort_type eq 4>
                                                        ENTRY_DATE 
                                                    <cfelseif  Len(attributes.sort_type) and attributes.sort_type eq 5>
                                                        ENTRY_DATE DESC
                                                    <cfelse>
                                                        INVENTORY_NAME
                                                    </cfif>
                                        ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
						)
			SELECT
				CTE2.*
                <cfif attributes.page neq 1>
                	,xxx.toplam_ilkdeger
                    ,xxx.toplam_ilkdeger_doviz 
                    ,xxx.toplam_sondeger 
					,xxx.toplam_sondeger_doviz 
 					,xxx.toplam_deger 
					,xxx.toplam_deger_doviz
					,xxx.son_toplam_deger
					,xxx.son_toplam_deger_doviz 
                </cfif>
			FROM
				CTE2
                <cfif attributes.page neq 1>
                    OUTER APPLY
                    (
                        SELECT 
                            SUM(AMOUNT) AS toplam_ilkdeger ,
                            SUM(amount_2) AS toplam_ilkdeger_doviz ,
                            SUM(LAST_INVENTORY_VALUE) AS toplam_sondeger ,
                            SUM( LAST_INVENTORY_VALUE_2) AS toplam_sondeger_doviz ,
                            SUM((MIKTAR * amount)) AS toplam_deger ,
                            SUM((MIKTAR * amount_2)) AS toplam_deger_doviz ,
                            SUM((MIKTAR * LAST_INVENTORY_VALUE)) AS son_toplam_deger ,
                            SUM((MIKTAR * LAST_INVENTORY_VALUE_2)) AS son_toplam_deger_doviz 
                        FROM 
                            CTE2 
                        WHERE 
                            RowNum BETWEEN 1 and #attributes.startrow-attributes.maxrows#+(#attributes.maxrows#-1)
                    )  as xxx
                </cfif>
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_invent.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<cfif len(attributes.record_date_1)><cfset attributes.record_date_1 = dateformat(attributes.record_date_1,dateformat_style)></cfif>
<cfif len(attributes.record_date_2)><cfset attributes.record_date_2 = dateformat(attributes.record_date_2,dateformat_style)></cfif>
<cfif len(attributes.entry_date_1)><cfset attributes.entry_date_1 = dateformat(attributes.entry_date_1,dateformat_style)></cfif>
<cfif len(attributes.entry_date_2)><cfset attributes.entry_date_2 = dateformat(attributes.entry_date_2,dateformat_style)></cfif>
<cfif len(attributes.output_date_1)><cfset attributes.output_date_1 = dateformat(attributes.output_date_1,dateformat_style)></cfif>
<cfif len(attributes.output_date_2)><cfset attributes.output_date_2 = dateformat(attributes.output_date_2,dateformat_style)></cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" action="#request.self#?fuseaction=invent.list_inventory" method="post">
            <input type="hidden" name="form_varmi" id="form_varmi" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58878.Demirbaş No"></cfsavecontent>
                    <cfinput type="text" name="invent_no" placeholder="#message#"  value="#attributes.invent_no#" maxlength="50">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58133.Fatura No"></cfsavecontent>
                    <cfinput type="text" name="bill_no" placeholder="#message#" value="#attributes.bill_no#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="invent_status" id="invent_status" style="width:50px;">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="0"<cfif isdefined('attributes.invent_status') and (attributes.invent_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        <option value="1"<cfif isdefined('attributes.invent_status') and (attributes.invent_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='43958.Sayı Hatası Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-amor_method">
                            <label class="col col-12"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></label>
                            <div class="col col-12">
                                <select name="amor_method" id="amor_method" style="width:150px;">
                                    <option value=""><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></option>
                                    <option value="0" <cfif attributes.amor_method eq "0">selected</cfif>><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></option>
                                    <option value="1" <cfif attributes.amor_method eq "1">selected</cfif>><cf_get_lang dictionary_id='29422.Sabit Miktar Üzerinden'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-account_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="text" name="account_id" id="account_id" value="<cfif len(attributes.account_id)><cfoutput>#attributes.account_id#</cfoutput></cfif>" onfocus="AutoComplete_Create('account_id','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_id','','3','200');"  style="width:130px;">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form.account_id','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-inventory_cat">
                            <label class="col col-12"><cf_get_lang dictionary_id='56904.Sabit Kıymet Kategorisi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                <input type="hidden" id="inventory_cat_id" name="inventory_cat_id" value="">
                                <input type="text" id="inventory_cat" name="inventory_cat" value="<cfif len(attributes.inventory_cat_id)><cfoutput>#attributes.inventory_cat#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=inventory_cat_id&field_name=inventory_cat','list');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-inventory_type">
                            <label class="col col-12"><cf_get_lang dictionary_id='56900.Demirbaş Tipi'></label>
                            <div class="col col-12">
                                <select name="inventory_type" id="inventory_type" style="width:160px;">
                                    <option value=""><cf_get_lang dictionary_id='56900.Demirbaş Tipi'></option>
                                    <option value="1" <cfif attributes.inventory_type eq "1">selected</cfif>><cf_get_lang dictionary_id='56899.Devirden Gelen'></option>
                                    <option value="2" <cfif attributes.inventory_type eq "2">selected</cfif>><cf_get_lang dictionary_id='56898.Faturadan Kaydedilen'></option>
                                    <option value="3" <cfif attributes.inventory_type eq "3">selected</cfif>><cf_get_lang dictionary_id='56897.Stok Fişinden Kaydedilen'></option>
                                    <option value="4" <cfif attributes.inventory_type eq "4">selected</cfif>><cf_get_lang dictionary_id='56894.İrsaliyeden Kaydedilen'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-sort_type">
                            <label class="col col-12"><cf_get_lang dictionary_id='58924.Sıralama'></label>
                            <div class="col col-12">
                                <select name="sort_type" id="sort_type" style="width:160px;">
                                    <option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id='56945.Demirbaş Adına Göre Artan'></option>
                                    <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='56965.Demirbaş Adına Göre Azalan'></option>
                                    <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='56976.Demirbaş No ya Göre Artan'></option>
                                    <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang dictionary_id='56977.Demirbaş No ya Göre Azalan'></option>
                                    <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cf_get_lang dictionary_id='56978.Giriş Tarihine Göre Artan'></option>
                                    <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>><cf_get_lang dictionary_id='56979.Giriş Tarihine Göre Azalan'></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-entry_date">
                            <label class="col col-12"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfinput type="text" name="entry_date_1" value="#attributes.entry_date_1#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="entry_date_1"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="entry_date_2" value="#attributes.entry_date_2#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="entry_date_2"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-record_date">
                            <label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfinput type="text" name="record_date_1" value="#attributes.record_date_1#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date_1"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="record_date_2" value="#attributes.record_date_2#" validate="#validate_style#" maxlength="10">				
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date_2"></span>
                                </div>
                            </div>
                        </div>
                        <cfquery name="get_our_comp_info" datasource="#dsn#">
                            SELECT IS_SUBSCRIPTION_CONTRACT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                        </cfquery>
                        <cfif get_our_comp_info.recordcount and get_our_comp_info.is_subscription_contract eq 1>
                            <div class="form-group" id="item-subscription_id">
                                <label class="col col-12"><cf_get_lang dictionary_id='59774.Sistem No'></label>
                                <div class="col col-12">
                                    <cf_wrk_subscriptions subscription_id='#attributes.subscription_id#' subscription_no='#attributes.subscription_no#' width_info='130' form_name='form' img_info='plus_thin' align="absbottom">
                                </div>
                            </div>
                        </cfif> 
                    </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57531.Sabit Kıymetler"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1"  woc_setting = "#{ checkbox_name : 'print_invent_id',  print_type : 350 }#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='58602.Demirbaş'><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='56905.Demirbaş Adı'></th>
                    <th><cf_get_lang dictionary_id='57628.Giriş Tarihi'></th>
                    <th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktarı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='56908.Alındığı Andaki Değeri'></th>
                    <cfif len(session.ep.money2)>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='56908.Alındığı Andaki Değeri'> 
                            <cfoutput>#session.ep.money2#</cfoutput>
                        </th>
                    </cfif>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='56909.Şu Andaki Değeri'></th>
                    <cfif len(session.ep.money2)>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='56909.Şu Andaki Değeri'>
                            <cfoutput>#session.ep.money2#</cfoutput>
                        </th>
                    </cfif>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='58603.Toplam Değer'></th>
                    <cfif len(session.ep.money2)>
                        <th style="text-align:right;"><cf_get_lang dictionary_id ='58603.Toplam Değer'>
                            <cfoutput>#session.ep.money2#</cfoutput>
                        </th>
                    </cfif>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='58604.Toplam Son Değer'></th>
                    <cfif len(session.ep.money2)>
                        <th style="text-align:right;"><cf_get_lang dictionary_id ='58604.Toplam Son Değer'>
                            <cfoutput>#session.ep.money2#</cfoutput>
                        </th>
                    </cfif>
                    <th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                    <th width="20"  class="header_icn_none text-center">
                        <cfif isdefined("attributes.form_varmi") and GET_INVENT.recordcount>
                            <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_invent_id');">
                        </cfif>
                    </th>
                </tr>
            </thead>
                <cfif isdefined("attributes.form_varmi") and GET_INVENT.RECORDCOUNT>
                    <tbody>	
                        <cfif attributes.page neq 1>
                                <cfset toplam_ilkdeger1 = GET_INVENT.toplam_ilkdeger>
                                <cfset toplam_ilkdeger_doviz1 = GET_INVENT.toplam_ilkdeger_doviz>
                                <cfset toplam_sondeger1 = GET_INVENT.toplam_sondeger>
                                <cfset toplam_sondeger_doviz1 = GET_INVENT.toplam_sondeger_doviz>
                                <cfset toplam_deger1 = GET_INVENT.toplam_deger>
                                <cfset toplam_deger_doviz1 = GET_INVENT.toplam_deger_doviz>
                                <cfset son_toplam_deger1 = GET_INVENT.son_toplam_deger>
                                <cfset son_toplam_deger_doviz1 = GET_INVENT.son_toplam_deger_doviz>
                            <cfoutput>
                            <tr>
                                <td colspan="6" class="txtboldblue"><cf_get_lang dictionary_id ='58034.Devreden'></td>
                                <td class="txtboldblue" style="text-align:right;">#TLFormat(toplam_ilkdeger1)#</td>
                                <cfif len(session.ep.money2)><td class="txtboldblue" style="text-align:right;">#TLFormat(toplam_ilkdeger_doviz1)#</td></cfif>
                                <td class="txtboldblue" style="text-align:right;">#TLFormat(toplam_sondeger1)#</td>
                                <cfif len(session.ep.money2)><td class="txtboldblue" style="text-align:right;">#TLFormat(toplam_sondeger_doviz1)#</td></cfif>
                                <td class="txtboldblue" style="text-align:right;">#TLFormat(toplam_deger1)#</td>
                                <cfif len(session.ep.money2)><td class="txtboldblue" style="text-align:right;">#TLFormat(toplam_deger_doviz1)#</td></cfif>
                                <td class="txtboldblue" style="text-align:right;">#TLFormat(son_toplam_deger1)#</td>
                                <cfif len(session.ep.money2)><td class="txtboldblue" style="text-align:right;">#TLFormat(son_toplam_deger_doviz1)#</td></cfif>
                                <td colspan="3">&nbsp;</td>
                            </tr>
                            </cfoutput>
                        </cfif>
                        <cfoutput query="get_invent">
                            <tr>
                                <td>#ROWNUM#</td>
                                <td>#inventory_number#</td>	
                                <td><a href="#request.self#?fuseaction=invent.list_inventory&event=det&inventory_id=#inventory_id#" class="tableyazi">#INVENTORY_NAME#</a></td>
                                <td>#dateformat(entry_date,dateformat_style)#</td>
                                <td>#account_id#</td>
                                <td style="text-align:right;">#miktar#</td>
                                <td style="text-align:right;">#TLFormat(amount)#</td>
                                <cfif len(session.ep.money2)><td style="text-align:right;">#TLFormat(amount_2)#</td></cfif>
                                <td style="text-align:right;">#TLFormat(last_inventory_value)#</td>
                                <cfif len(session.ep.money2)><td style="text-align:right;">#TLFormat(last_inventory_value_2)#</td></cfif>
                                <td style="text-align:right;">#TLFormat(miktar * amount)#</td>
                                <cfif len(session.ep.money2)><td style="text-align:right;">#TLFormat(miktar * amount_2)#</td></cfif>
                                <td style="text-align:right;">#TLFormat(miktar * last_inventory_value)#</td>
                                <cfif len(session.ep.money2)><td style="text-align:right;">#TLFormat(miktar * last_inventory_value_2)#</td></cfif>
                                <!-- sil -->
                                    <td align="center">
                                        <a href="#request.self#?fuseaction=invent.list_inventory&event=det&inventory_id=#inventory_id#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                    </td>
                                    <td class="text-center"><input type="checkbox" name="print_invent_id" id="print_invent_id"  value="#inventory_id#"></td>
                                <!-- sil -->
                            </tr>
                            <cfset toplam_ilkdeger1 = toplam_ilkdeger1 + amount>
                            <cfset toplam_ilkdeger_doviz1 = toplam_ilkdeger_doviz1 + amount_2>
                            <cfset toplam_sondeger1 = toplam_sondeger1 + last_inventory_value>
                            <cfset toplam_sondeger_doviz1 = toplam_sondeger_doviz1 + last_inventory_value_2>
                            <cfset toplam_deger1 = toplam_deger1 + (miktar * amount)>
                            <cfset toplam_deger_doviz1 = toplam_deger_doviz1 + (miktar * amount_2)>
                            <cfset son_toplam_deger1 = son_toplam_deger1 + (miktar * last_inventory_value)>
                            <cfset son_toplam_deger_doviz1 = son_toplam_deger_doviz1 + (miktar * last_inventory_value_2)>
                        </cfoutput>
                    </tbody>
                        <cfoutput>
                            <tfoot>
                                <tr>
                                    <td colspan="6" align="left" class="txtbold"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
                                    <td class="txtbold" style="text-align:right;">#TLFormat(toplam_ilkdeger1)#</td>
                                    <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(toplam_ilkdeger_doviz1)#</td></cfif>
                                    <td class="txtbold" style="text-align:right;">#TLFormat(toplam_sondeger1)#</td>
                                    <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(toplam_sondeger_doviz1)#</td></cfif>
                                    <td class="txtbold" style="text-align:right;">#TLFormat(toplam_deger1)#</td>
                                    <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(toplam_deger_doviz1)#</td></cfif>
                                    <td class="txtbold" style="text-align:right;">#TLFormat(son_toplam_deger1)#</td>
                                    <cfif len(session.ep.money2)><td class="txtbold" style="text-align:right;">#TLFormat(son_toplam_deger_doviz1)#</td></cfif>
                                    <td colspan="3">&nbsp;</td>
                                </tr>
                            </tfoot>
                        </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="16"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
        </cf_grid_list>

        <cfset adres="invent.list_inventory&form_varmi=1">
        <cfif isdefined("attributes.record_date_1")>
            <cfset adres=adres&'&record_date_1=#attributes.record_date_1#'>
        </cfif>
        <cfif isdefined("attributes.record_date_2")>
            <cfset adres=adres&'&record_date_2=#attributes.record_date_2#'>
        </cfif>
        <cfif isdefined("attributes.entry_date_1")>
            <cfset adres=adres&'&entry_date_1=#attributes.entry_date_1#'>
        </cfif>
        <cfif isdefined("attributes.entry_date_2")>
            <cfset adres=adres&'&entry_date_2=#attributes.entry_date_2#'>
        </cfif>
        <cfif isdefined("attributes.keyword")>
            <cfset adres=adres&'&keyword=#attributes.keyword#'>
        </cfif>
        <cfif isdefined("attributes.bill_no")>
            <cfset adres=adres&'&bill_no=#attributes.bill_no#'>
        </cfif>
        <cfif isdefined("attributes.amor_method")>
            <cfset adres=adres&'&amor_method=#attributes.amor_method#'>
        </cfif>
        <cfif isdefined("attributes.account_id")>
            <cfset adres=adres&'&account_id=#attributes.account_id#'>
        </cfif>
        <cfif isdefined("attributes.inventory_cat_id") and isdefined("attributes.inventory_cat")>
            <cfset adres=adres&'&inventory_cat_id=#attributes.inventory_cat_id#'>
        </cfif>
        <cfif isdefined("attributes.invent_no")>
            <cfset adres=adres&'&invent_no=#attributes.invent_no#'>
        </cfif>
        <cfif isdefined("attributes.invent_status")>
            <cfset adres=adres&'&invent_status=#attributes.invent_status#'>
        </cfif>
        <cfif isdefined("attributes.inventory_type")>
            <cfset adres=adres&'&inventory_type=#attributes.inventory_type#'>
        </cfif>
        <cfif isdefined("attributes.sort_type")>
            <cfset adres=adres&'&sort_type=#attributes.sort_type#'>
        </cfif>
        <cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
            <cfset adres=adres&'&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#'>
        </cfif>
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
