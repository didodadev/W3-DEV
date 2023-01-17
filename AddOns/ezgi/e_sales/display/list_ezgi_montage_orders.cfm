<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.montage_stock_ids" default="">
<cfparam name="attributes.sort_type" default="3">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.durum_uretim" default="">
<cfparam name="attributes.durum_montaj" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.sales_type" default="">
<cfparam name="attributes.status" default="1">
<CFSET t_amount = 0>
<cfif isdefined('attributes.update_status')>
	<cfif ListLen(attributes.convert_list)>
        <cfloop list="#attributes.convert_list#" index="i">
        	<cfset ezgiid = ListGetAt(i,1,'_')>
            <cfset stockid = ListGetAt(i,2,'_')>
        	<cfquery name="update_row" datasource="#dsn3#">
            	UPDATE
                	EZGI_MONTAGE_ROW
               	SET
                	STATUS = #attributes.update_status#
             	WHERE
                	EZGI_ID = #ezgiid# AND
                    STOCK_ID = #stockid#   
           	</cfquery>    
        </cfloop>
    </cfif>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_montage" datasource="#dsn3#">
    	SELECT   
        	CASE
         		WHEN EVO.COMPANY_ID IS NOT NULL THEN
                   (
                    SELECT     
                      	NICKNAME
					FROM         
                    	#dsn_alias#.COMPANY
					WHERE     
                   		COMPANY_ID = EVO.COMPANY_ID
                  	)
          		WHEN EVO.CONSUMER_ID IS NOT NULL THEN      
                   	(	
                  	SELECT     
                     	CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
					FROM         
                      	#dsn_alias#.CONSUMER
					WHERE     
                		CONSUMER_ID = EVO.CONSUMER_ID
               		)
          	END AS UNVAN ,
            (SELECT MASTER_PLAN_DETAIL FROM EZGI_IFLOW_MASTER_PLAN WHERE MASTER_PLAN_ID = ofr.MASTER_PLAN_ID) MASTER_PLAN_DETAIL,
         	EVOR.PRODUCT_NAME2,
           	EVO.VIRTUAL_OFFER_HEAD,
            EVO.BRANCH_ID,
            OFR.IS_STAGE,
        	EMR.MONTAGE_ROW_ID, 
            EMR.MONTAGE_ID, 
            EMR.STOCK_ID, 
            EMR.PRODUCT_NAME, 
            EMR.AMOUNT, 
            EMR.MAIN_UNIT, 
            EMR.PRODUCT_UNIT_ID, 
            EMR.IS_HZM, 
            EVO.REVISION_NO,
            EVOR.PRODUCT_NAME AS NAME_PRODUCT, 
            EVO.VIRTUAL_OFFER_DATE,
            EVO.VIRTUAL_OFFER_STAGE, 
            EVO.SALES_COMPANY_ID, 
     		EVO.VIRTUAL_OFFER_NUMBER, 
            EVO.COMPANY_ID, 
            EVO.CONSUMER_ID, 
            EVOR.QUANTITY, 
            OFR.MASTER_PLAN_NAME, 
            OFR.MASTER_PLAN_NUMBER, 
            OFR.P_ORDER_ID, 
            EVO.VIRTUAL_OFFER_ID, 
            OFR.LOT_NO,
            EVOR.EZGI_ID,
            EVO.RECORD_DATE, 
            EVO.RECORD_EMP,
            O.ORDER_NUMBER, 
        	O1.ORDER_NUMBER AS SV_ORDER_NUMER,
            ISNULL((
            	SELECT     
                	SUM(PREDICTED_AMOUNT) AS AMOUNT
				FROM     
                	SERVICE_OPERATION
				WHERE     
                	WRK_ROW_ID = EMR.WRK_ROW_RELATION_ID
            ),0) AS MONTAGE_AMOUNT
		FROM        
        	ORDER_ROW AS ORR1 INNER JOIN
         	ORDERS AS O1 ON ORR1.ORDER_ID = O1.ORDER_ID RIGHT OUTER JOIN
          	EZGI_MONTAGE_ROW AS EMR INNER JOIN
          	EZGI_VIRTUAL_OFFER_ROW AS EVOR ON EMR.EZGI_ID = EVOR.EZGI_ID INNER JOIN
        	EZGI_VIRTUAL_OFFER AS EVO ON EVOR.VIRTUAL_OFFER_ID = EVO.VIRTUAL_OFFER_ID INNER JOIN
          	ORDER_ROW AS ORR ON EVOR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_RELATION_ID INNER JOIN
          	ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID ON ORR1.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID LEFT OUTER JOIN
        	EZGI_ORGE_RELATIONS AS OFR ON EMR.EZGI_ID = OFR.EZGI_ID
		WHERE     
        	EMR.IS_HZM = 1
         	<cfif len(attributes.member_name)>
            	<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                    AND EVO.COMPANY_ID =#attributes.company_id#
                </cfif>
                <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
                    AND EVO.CONSUMER_ID =#attributes.consumer_id# 
                </cfif>
           	</cfif>
            <cfif len(attributes.keyword)>
            	AND 
                (
                	EVO.VIRTUAL_OFFER_NUMBER LIKE '%#attributes.keyword#%' OR
                    EVO.VIRTUAL_OFFER_DETAIL LIKE '%#attributes.keyword#%' OR
                    EVO.VIRTUAL_OFFER_HEAD LIKE '%#attributes.keyword#%' 
              	)
            </cfif>
            <cfif len(attributes.record_emp_name) and len(attributes.record_emp_id)>
            	AND EVO.RECORD_EMP = #attributes.record_emp_id#
            </cfif>

            <cfif session.ep.ISBRANCHAUTHORIZATION eq 1>
            	AND EVO.BRANCH_ID IN 
                				(
                                SELECT        
                                	BRANCH_ID
								FROM   
                                	#dsn_alias#.EMPLOYEE_POSITION_BRANCHES
								WHERE        
                                	POSITION_CODE = #session.ep.POSITION_CODE# AND 
                                    DEPARTMENT_ID IS NULL
                                
                                )
            </cfif>
            <cfif len(attributes.branch_id)>
            	AND EVO.BRANCH_ID = #attributes.branch_id#
            </cfif>
			<cfif len(attributes.montage_stock_ids)>
            	AND EMR.STOCK_ID IN (#attributes.montage_stock_ids#)
            </cfif>
            <cfif attributes.sales_type eq 1>
            	AND EVO.SALES_COMPANY_ID IS NOT NULL
           	<cfelseif attributes.sales_type eq 2>
            	AND EVO.BRANCH_ID IS NOT NULL
            </cfif>
            <cfif len(attributes.durum_uretim)>
				<cfif attributes.durum_uretim eq 1>
                    AND OFR.IS_STAGE = 1
                <cfelseif attributes.durum_uretim eq 2>
                    AND OFR.IS_STAGE = 2
                <cfelse>
                    AND OFR.IS_STAGE NOT IN (1,2)
                </cfif>
            </cfif>
            <cfif len(attributes.status)>
            	AND EMR.STATUS = #attributes.status#
            </cfif>
      	ORDER BY
        	<cfif attributes.sort_type eq 2>
            	EVO.VIRTUAL_OFFER_NUMBER
            <cfelseif attributes.sort_type eq 3>
            	EVO.RECORD_DATE DESC
            <cfelseif attributes.sort_type eq 4>
            	EVO.VIRTUAL_OFFER_DATE
            <cfelseif attributes.sort_type eq 5>
            	EVO.VIRTUAL_OFFER_DATE desc
            </cfif>
    </cfquery>
    <cfquery name="get_montage" dbtype="query">
    	SELECT
        	*
       	FROM
        	get_montage
        WHERE
        	1=1
            <cfif attributes.durum_montaj eq 1>
            	AND MONTAGE_AMOUNT = QUANTITY
            <cfelseif attributes.durum_montaj eq 2>
            	AND MONTAGE_AMOUNT < QUANTITY
            </cfif>
    </cfquery>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_montage.recordcount = 0>
    <cfset arama_yapilmali = 1>
</cfif>

<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT        
    	BRANCH_ID, BRANCH_NAME
	FROM            
    	BRANCH
	WHERE        
    	BRANCH_ID IN
                  	(
                    	SELECT        
                        	BRANCH_ID
                    	FROM            
                        	EMPLOYEE_POSITION_BRANCHES
                    	WHERE        
                        	POSITION_CODE = #session.ep.POSITION_CODE# AND 
                            DEPARTMENT_ID IS NULL
                   	)
      	AND COMPANY_ID = #session.ep.company_id# 
        AND BRANCH_STATUS = 1
</cfquery>
<cfoutput query="get_branch">
	<cfset 'BRANCH_NAME_#BRANCH_ID#' = BRANCH_NAME>
</cfoutput>

<cfquery name="MONTAGE_DEFAULTS" datasource="#DSN3#">
	SELECT     
    	E.STOCK_ID MONTAGE_STOCK_ID, 
        E.SORT_NO, 
        S.PRODUCT_NAME MONTAGE_PRODUCT_NAME,
        E.IS_ACTIVE
	FROM        
    	EZGI_VIRTUAL_OFFER_COST_DEFAULT AS E INNER JOIN
      	STOCKS AS S ON E.STOCK_ID = S.STOCK_ID
	ORDER BY 
    	E.SORT_NO
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_montage.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=prod.list_ezgi_montage">
<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
   <cf_big_list_search title="Montaj Emirleri" collapsed="1">
		<cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:175px; height:20px" value="#attributes.keyword#" maxlength="500"></td>
                    <td><cf_get_lang_main no='487.Kaydeden'></td>
					<td nowrap="nowrap">
						<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
						<input name="record_emp_name" type="text" id="record_emp_name" style="width:175px;" onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off">
						<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.record_emp_id&field_name=search_form.record_emp_name<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_form.record_emp_name.value),'list','popup_list_positions');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
					</td>
                    <td rowspan="2">
                    	<select name="montage_stock_ids" id="montage_stock_ids" style="height:60px;width:200px" multiple="multiple">
							<cfoutput query="MONTAGE_DEFAULTS">
								<option value="#montage_stock_id#"<cfif Listfind(attributes.montage_stock_ids, montage_stock_id)>selected</cfif>>#MONTAGE_PRODUCT_NAME#</option>
							</cfoutput>
						</select>
                    </td>
                    <td>
                    	<select name="branch_id" id="branch_id" style="width:180px; height:20px">
                        	<option value=""><cf_get_lang_main no='41.Şube'></option>
                        	<cfoutput query="get_branch">
                        		<option value="#get_branch.branch_id#" <cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#get_branch.branch_name#</option>
                            </cfoutput>
                       	</select>
                    </td>
                    <td>
                    	<select name="durum_uretim" id="durum_uretim" style="width:180px; height:20px">
                         	<option value="" <cfif attributes.durum_uretim eq "">selected</cfif>>Üretim Aşama</option>
                           	<option value="0" <cfif attributes.durum_uretim eq 0>selected</cfif>>Başlamayanlar</option>
                         	<option value="1" <cfif attributes.durum_uretim eq 1>selected</cfif>>Başlayanlar</option>
                            <option value="2" <cfif attributes.durum_uretim eq 2>selected</cfif>>Bitenler</option>
                     	</select>
                    </td>
					<td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>
				</tr>

				<tr valign="middle">
                	<td>Sıralama</td>
                    <td><select name="sort_type" id="sort_type" style="width:175px; height:20px">
                        <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>>Teklif Nosuna Göre Artan</option>
                        <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>>Teklif Nosuna Göre Azalan</option>
                        <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>>Teklif Tarihine Göre Artan</option>
                        <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>>Teklif Tarihine Göre Azalan</option>
                        </select>
                    </td>
                	<td><cf_get_lang_main no='107.Cari Hesap'></td>
                	<td>
                    	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                   		<input type="hidden" name="company_id"  id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                       	<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                      	<input type="text"   name="member_name" id="member_name" style="width:175px;"  value="<cfoutput>#attributes.member_name#</cfoutput>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','company_id,consumer_id,member_type','','3','250');" autocomplete="off">
                      	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search_form.consumer_id&field_comp_id=search_form.company_id&field_member_name=search_form.member_name&field_type=search_form.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search_form.member_name.value),'list');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
                    </td>
                	<td>
                    	<select name="durum_montaj" id="durum_montaj" style="width:180px; height:20px">
                         	<option value="" <cfif attributes.durum_montaj eq "">selected</cfif>>Montaj Emri</option>
                           	<option value="1" <cfif attributes.durum_montaj eq 1>selected</cfif>>Tamamlananlar</option>
                         	<option value="2" <cfif attributes.durum_montaj eq 2>selected</cfif>>Eksik Olanlar</option>
                     	</select>
                    </td>
                    <td>
                    	<select name="status" id="status" style="width:180px; height:20px">
                         	<option value="" <cfif attributes.STATUS eq "">selected</cfif>>Durum</option>
                           	<option value="1" <cfif attributes.STATUS eq 1>selected</cfif>>Aktif</option>
                         	<option value="0" <cfif attributes.STATUS eq 0>selected</cfif>>Pasif</option>
                     	</select>
                    </td>
                </tr>
			</table>
		</cf_big_list_search_area>
	</cf_big_list_search>
	
	<cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th style="width:25px"><cf_get_lang_main no='1165.Sıra'></th>
                <th style="width:70px">Teklif No</th>
                <th style="width:60px">Sipariş No</th>
                <th style="width:60px">Teslim Tarihi</th>
                <th style="width:150px">Müşteri</th>
                <th style="width:90px">Bayi / Şube</th>
              	<th style="width:200px">Ürün Cinsi</th>
              	<th style="width:50px">Miktar</th>
                <th >Açıklama</th>
  				<th style="width:120px">Hizmet Cinsi</th>
                <th style="width:100px">Üretim Programı</th>
                <th style="width:60px">Lot No</th>
                <th style="width:40px">Montaj<br>Miktarı</th>
                <th style="width:30px">Birim</th>
                <th style="width:40px">Verilen<br>Miktar</th>
                <th style="width:40px">Kalan<br>Miktar</th>
                <!-- sil -->
                <th class="header_icn_none" style="text-align:center">
                	<input type="checkbox" name="all_conv_product" id="all_conv_product" onClick="javascript: wrk_select_all2('all_conv_product','_select_product_',<cfoutput>#get_montage.recordcount#</cfoutput>);">
                </th>
                <!-- sil -->
            </tr>
        </thead>
        <tbody>
            <cfif get_montage.recordcount>
                <cfoutput query="get_montage" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr> 
                        <td style="text-align:right;">#CURRENTROW#</td>
                   		<td style="text-align:left;"><a href="#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#get_montage.virtual_offer_id#" class="tableyazi">#VIRTUAL_OFFER_NUMBER#<cfif len(REVISION_NO)> <span style="font-weight:bold; color:red">Rev:#REVISION_NO#</span></cfif></a></td>
                        <td style="text-align:center;">#ORDER_NUMBER#</td>
                        <td style="text-align:center;">#DateFormat(VIRTUAL_OFFER_DATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:LEFT;">#UNVAN#</td>
                        <td nowrap="nowrap">
                        	<cfif len(get_montage.SALES_COMPANY_ID)>
                            	#get_par_info(get_montage.SALES_COMPANY_ID,1,1,0)#
                            <cfelse>
                            	<cfif isdefined('BRANCH_NAME_#BRANCH_ID#')>
                                	#Evaluate('BRANCH_NAME_#BRANCH_ID#')#
                                </cfif>
                            </cfif>
                        </td>
                     	<td nowrap="nowrap">#Left(NAME_PRODUCT,80)#<cfif len(NAME_PRODUCT) gt 80>...</cfif></td>
                       	<td style="text-align:right;">#AmountFormat(QUANTITY)#</td>
                        <td title="#VIRTUAL_OFFER_HEAD#">
                         	#Left(product_name2,40)#<cfif len(PRODUCT_NAME2) gt 40>...</cfif>
                        </td>
                        <td nowrap="nowrap">#Left(PRODUCT_NAME,50)#<cfif len(PRODUCT_NAME) gt 50>...</cfif></td>
                        <td nowrap="nowrap">#Left(MASTER_PLAN_DETAIL,40)#<cfif len(MASTER_PLAN_DETAIL) gt 40>...</cfif></td>
                        <td style="text-align:center; font-weight:bold; color:<cfif IS_STAGE eq 2>red<cfelseif IS_STAGE eq 1>green<cfelse>orange</cfif>">
                        	<cfif len(SV_ORDER_NUMER)>
                            	#SV_ORDER_NUMER#
                            <cfelse>
                        		#LOT_NO#
                            </cfif>
                        </td>
						<td style="text-align:right;">#AmountFormat(QUANTITY*AMOUNT,2)#</td>
                        <td>#MAIN_UNIT#</td>
                        <cfset kalan = QUANTITY-MONTAGE_AMOUNT>
                        <td style="text-align:right;">#AmountFormat(MONTAGE_AMOUNT,2)#</td>
                        <td style="text-align:right;">
                        	<input name="montage_amount_#EZGI_ID#_#STOCK_ID#" id="montage_amount_#EZGI_ID#_#STOCK_ID#" value="#AmountFormat(kalan,2)#" class="box" style="width:50px">
                        </td>

                       	<CFSET t_amount = t_amount + (QUANTITY*AMOUNT)>
                        <!-- sil -->
                        <td style="text-align:center;">
                        	<input type="checkbox" name="select_product_#EZGI_ID#_#STOCK_ID#" value="#stock_id#" id="_select_product_#currentrow#">
                        </td>
                        <!-- sil -->
                    </tr>
                </cfoutput>
            	<tr>
                	<td></td>
                	<td colspan="9" style="vertical-align:top">
                    	<cfif attributes.durum_montaj eq 2>
                        	<cfif attributes.status eq 1>
                            	<input type="button" value="Seçileni Pasif Yap" name="pasif" id="pasif" onClick="basvuru_kontrol(2);" style="width:150px;">
                            <cfelseif attributes.status eq 0>
                            	<input type="button" value="Seçileni Aktif Yap" name="aktif" id="aktif" onClick="basvuru_kontrol(3);" style="width:150px;">
                            </cfif>
                        </cfif>	
                    </td>
                	<td colspan="2"><strong>Toplam</strong></td>
                 	<td style="text-align:right;"><strong><cfoutput>#AmountFormat(t_amount,2)#</cfoutput></strong></td>
                    <td></td>
                	<TD colspan="3" style="text-align:right; padding-right:2px">
                    	<input type="button" value="<cfoutput>#getLang('call',96)#</cfoutput>" name="basvuru" id="basvuru" onClick="basvuru_kontrol(1);" style="width:100%;">
                    </TD>
           		</tr>
            <cfelse>
                <tr> 
                    <td colspan="17" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
	</cf_big_list>
</cfform>
<cfset adres = url.fuseaction>
<cfif isdefined("attributes.is_form_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfif len(attributes.member_name)>
      <cfset adres = '#adres#&company_id=#attributes.company_id#'>
      <cfset adres = '#adres#&member_name=#attributes.member_name#'>
    </cfif>		
    <cfif len(attributes.keyword)>
      <cfset adres = '#adres#&keyword=#URLEncodedFormat(attributes.keyword)#'>
    </cfif>
    <cfif len(attributes.sales_type)>
        <cfset adres = '#adres#&sales_type=#attributes.sales_type#'>
    </cfif>
    <cfif len(attributes.sort_type)>
        <cfset adres = '#adres#&sort_type=#attributes.sort_type#'>
    </cfif>
    <cfif len(attributes.list_type)>
        <cfset adres = '#adres#&list_type=#attributes.list_type#'>
    </cfif>
        <cfif len(attributes.durum_montaj)>
        <cfset adres = '#adres#&durum_montaj=#attributes.durum_montaj#'>
    </cfif>
    <cfif len(attributes.durum_uretim)>
        <cfset adres = '#adres#&durum_uretim=#attributes.durum_uretim#'>
    </cfif>
    <cfif len(attributes.montage_stock_ids)>
        <cfset adres = '#adres#&montage_stock_ids=#attributes.montage_stock_ids#'>
    </cfif>
    <cfif len(attributes.record_emp_name)>
        <cfset adres = '#adres#&record_emp_name=#attributes.record_emp_name#'>
        <cfset adres = '#adres#&record_emp_id=#attributes.record_emp_id#'>
    </cfif>
    <cfif len(attributes.currency_id)>
        <cfset adres = '#adres#&currency_id=#attributes.currency_id#'>
    </cfif>
    <cfif isdefined('attributes.currency_type')>
        <cfset adres = '#adres#&currency_type=#attributes.currency_type#'>
    </cfif>
    <cf_paging 
        page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#adres#&is_form_submitted=1">
</cfif>
<form name="aktar_form" method="post">
    <input type="hidden" name="convert_ezgi_stocks_id" id="convert_ezgi_stocks_id" value="">
	<input type="hidden" name="convert_amount_ezgi_stocks_id" id="convert_amount_ezgi_stocks_id" value="">
</form>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function basvuru_kontrol(type)
	{
		var convert_list ="";
		var convert_list_amount ="";

		<cfif isdefined("attributes.is_form_submitted")>
			 <cfoutput query="get_montage" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			 	 if(document.all.select_product_#EZGI_ID#_#STOCK_ID#.checked && filterNum(document.getElementById('montage_amount_#EZGI_ID#_#STOCK_ID#').value) > 0)
				 {
					 convert_list += "#EZGI_ID#_#STOCK_ID#,";
					 convert_list_amount += filterNum(document.getElementById('montage_amount_#EZGI_ID#_#STOCK_ID#').value,2)+',';
				 }
			 </cfoutput>
		</cfif>
		document.getElementById('convert_ezgi_stocks_id').value=convert_list;
		document.getElementById('convert_amount_ezgi_stocks_id').value=convert_list_amount;
		if(convert_list)//Ürün Seçili ise
		{
			 
			 if(type==1)
			 {
				windowopen('','longpage','cc_paym');
				aktar_form.action="<cfoutput>#request.self#?fuseaction=service.popup_add_ezgi_montage_service</cfoutput>";
				document.getElementById('basvuru').disabled=true;
				aktar_form.target='cc_paym';
				aktar_form.submit();
			 }
			  if(type==2)
			 {
				sor_pasif=confirm('Seçilen Kayıtlar Pasif Edilecektir.');
				if(sor_pasif==true)
				{
					search_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_ezgi_montage&update_status=0&convert_list="+convert_list; 
					search_form.submit();
				}
				else
					return false;
			 }
			  if(type==3)
			 {
				sor_aktif=confirm('Seçilen Kayıtlar Aktif Edilecektir.');
				if(sor_aktif==true)
				{
					search_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_ezgi_montage&update_status=1&convert_list="+convert_list; 
					search_form.submit();
				}
				else
					return false;
			 }
			 
		}
		else
		 	alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
	}
	function wrk_select_all2(all_conv_product,_select_product_,number)
	{
		for(var cl_ind=1; cl_ind <= number; cl_ind++)
		{
			if(document.getElementById(all_conv_product).checked == true)
			{
				if(document.getElementById('_select_product_'+cl_ind).checked == false)
					document.getElementById('_select_product_'+cl_ind).checked = true;
			}
			else
			{
				if(document.getElementById('_select_product_'+cl_ind).checked == true)
					document.getElementById('_select_product_'+cl_ind).checked = false;
			}
		}
	}

</script>
