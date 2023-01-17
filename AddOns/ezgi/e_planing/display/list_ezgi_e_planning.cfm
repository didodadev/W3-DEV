 <cfsetting showdebugoutput="yes">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.short_code_name" default="">
<cfparam name="attributes.prod_cat" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.planer_employee" default="">
<cfparam name="attributes.planer_employee_id" default="">
<cfparam name="attributes.listing_type" default="3">
<cfparam name="attributes.sort_type" default="2">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.totalrecords" default="0">
<cfset lnk_str = ''>
<cfif len(attributes.prod_cat)>
	<cfset lnk_str = lnk_str &',#attributes.prod_cat#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif> 
<cfif len(attributes.product_id)>
	<cfset lnk_str = lnk_str &',#attributes.product_id#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.planer_employee_id)>
	<cfset lnk_str = lnk_str &',#attributes.planer_employee_id#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.finish_date)>
	<cfset lnk_str = lnk_str &',#attributes.finish_date#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.start_date)>
	<cfset lnk_str = lnk_str &',#attributes.start_date#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.listing_type)>
	<cfset lnk_str = lnk_str &',#attributes.listing_type#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.sort_type)>
	<cfset lnk_str = lnk_str &',#attributes.sort_type#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif isdefined("attributes.form_varmi")>
	<cfset lnk_str = lnk_str & ",1">
<cfelse>
    <cfset lnk_str = lnk_str & ",0">
</cfif>
<cfset son_row = 0>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = wrk_get_today()>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="GET_PLANNING" datasource="#dsn3#">
    	SELECT     
        	D.EZGI_DEMAND_ID, 
            D.DEMAND_HEAD, 
            D.PROCESS_STAGE, 
            D.DEMAND_DATE, 
            D.DEMAND_DELIVER_DATE, 
            D.RECORD_EMP, 
            D.DEMAND_NUMBER, 
           	D.DEMAND_DETAIL,
            D.DEMAND_EMP
		FROM         
        	EZGI_PRODUCTION_DEMAND AS D LEFT OUTER JOIN
         	(
            	SELECT        
                	EDR.EZGI_DEMAND_ID, 
                    SUM(EDR.QUANTITY - ISNULL(EPO.QUANTITY, 0)) AS KALAN
              	FROM    
                	EZGI_PRODUCTION_DEMAND_ROW AS EDR LEFT OUTER JOIN
                	EZGI_IFLOW_PRODUCTION_ORDERS AS EPO ON EDR.EZGI_DEMAND_ROW_ID = EPO.ACTION_ID
            	WHERE        
                	EDR.QUANTITY - ISNULL(EPO.QUANTITY, 0) > 0
             	GROUP BY 
                	EDR.EZGI_DEMAND_ID
          	) AS TBL ON D.EZGI_DEMAND_ID = TBL.EZGI_DEMAND_ID LEFT OUTER JOIN
       		EZGI_PRODUCTION_DEMAND_ROW AS DR ON D.EZGI_DEMAND_ID = DR.EZGI_DEMAND_ID
       	WHERE
        	1=1
            <cfif len(attributes.planer_employee)>
             	AND D.DEMAND_EMP = #attributes.planer_employee_id#
          	</cfif>
            <cfif attributes.listing_type eq 3>
            	AND ISNULL(TBL.KALAN, 0) > 0
           	<cfelseif attributes.listing_type eq 2>
            	AND ISNULL(TBL.KALAN, 0) = 0
            </cfif>
            <cfif len(attributes.keyword)>
            	AND
                	(
                    	D.DEMAND_HEAD LIKE '%#attributes.keyword#%' OR
                        D.DEMAND_DETAIL LIKE '%#attributes.keyword#%'
                    )
            </cfif>
		GROUP BY 
        	D.EZGI_DEMAND_ID, 
            D.DEMAND_HEAD, 
            D.PROCESS_STAGE, 
            D.DEMAND_DATE, 
            D.DEMAND_DELIVER_DATE, 
            D.RECORD_EMP, 
            D.DEMAND_NUMBER, 
           	D.DEMAND_DETAIL,
            D.DEMAND_EMP
      	ORDER BY
        	<cfif attributes.sort_type eq 2>
        		D.DEMAND_NUMBER desc
            <cfelse>
            	D.DEMAND_NUMBER
            </cfif>
	</cfquery>
    <cfset arama_yapilmali = 0>
<cfelse>
	<cfset arama_yapilmali = 1>
	<cfset GET_PLANNING.recordcount = 0>
</cfif>
<cfquery name="GET_PRODUCT_CATS" datasource="#dsn1#">
	SELECT     
    	PC.HIERARCHY, 
        PC.PRODUCT_CAT
	FROM         
    	PRODUCT_CAT AS PC INNER JOIN
        PRODUCT_CAT_OUR_COMPANY AS PCOC ON PC.PRODUCT_CATID = PCOC.PRODUCT_CATID
	WHERE     
    	PCOC.OUR_COMPANY_ID = #session.ep.company_id# AND
        PC.LIST_ORDER_NO IN (1,2,5,6,7,8)
 	ORDER BY
    	PRODUCT_CAT
</cfquery>

<cfform name="planning_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cf_big_list_search title="E-Planning">
    <cf_big_list_search_area>
        <cf_object_main_table>
            <input name="form_varmi" id="form_varmi" value="1" type="hidden">
            <cf_object_table column_width_list="40,75">
                <cfsavecontent variable="header_"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                <cf_object_tr id="form_ul_keyword" title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='48.Filtre'></cf_object_td>
                    <cf_object_td>
                        <cfinput type="text" name="keyword" maxlength="50" style="width:100px;" value="#attributes.keyword#">                    
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
           <cf_object_table column_width_list="75">
                <cfsavecontent variable="header_"><cf_get_lang_main no='97.Liste'> <cf_get_lang_main no='3019.Tipi'></cfsavecontent>
                <cf_object_tr id="form_ul_listening_type" title="#header_#">
                    <cf_object_td>
                        <select name="listing_type" id="listing_type" style="width:160px;height:20px">
                            <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                            <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang_main no='3071.Planlananlar'></option>
                            <option value="3" <cfif attributes.listing_type eq 3>selected</cfif>><cf_get_lang_main no='3072.Bekleyenler'></option>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="60">
                <cfsavecontent variable="header_"><cf_get_lang_main no='1512.Sıralama'></cfsavecontent>
                <cf_object_tr id="form_ul_sort_type" title="#header_#">
                    <cf_object_td>
                        <select name="sort_type" id="sort_type" style="width:180px;height:20px">
                            <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang_main no='3073.Belge Numarasına Göre Artan'></option>
                            <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang_main no='3074.Belge Numarasına Göre Azalan'></option>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,175">
                <cfsavecontent variable="header_"><cfoutput>#getLang('project',161)#</cfoutput></cfsavecontent>
                <cf_object_tr id="form_ul_planer_employee" title="#header_#">
                    <cf_object_td type="text" td_style="text-align:right;"><cfoutput>#getLang('project',161)#</cfoutput></cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="planer_employee_id" id="planer_employee_id" value="<cfif isdefined('attributes.planer_employee_id') and len(attributes.planer_employee_id) and isdefined('attributes.planer_employee') and len(attributes.planer_employee)><cfoutput>#attributes.planer_employee_id#</cfoutput></cfif>">
                        <input name="planer_employee" type="text" id="planer_employee" style="width:160px;vertical-align:top" onfocus="AutoComplete_Create('planer_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','planer_employee_id','','3','125');" value="<cfif isdefined('attributes.planer_employee_id') and len(attributes.planer_employee_id) and isdefined('attributes.planer_employee') and len(attributes.planer_employee)><cfoutput>#attributes.planer_employee#</cfoutput></cfif>" autocomplete="off" >	
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=planning_form.planer_employee_id&field_name=planning_form.planer_employee&is_form_submitted=1&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle"></a>		   
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table> 
            <cf_object_table column_width_list="140">
                <cf_object_tr id="">
                    <cf_object_td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">

                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_production_need</cfoutput>','longpage');">
                        	<img src="../../../images/carier.gif" align="absmiddle" border="0" title="<cf_get_lang_main no='3075.Üretim Plan Hesaplama'>" />
                      	</a>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_production_demonte_need</cfoutput>','longpage');">
                        	<img src="../../../images/package.gif" align="absmiddle" border="0" title="<cf_get_lang_main no='3076.Demonte Ürün Hesaplama'>" />
                      	</a>
                        <cf_wrk_search_button search_function='input_control()'>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>  
        </cf_object_main_table>
    </cf_big_list_search_area>
</cf_big_list_search>
</cfform>
	<table class="big_list">
		<thead>
			<tr height="15">
				<th style="width:30px;text-align:center" class="header_icn_txt"><cf_get_lang_main no='1165.Sira'></th>
				<th style="width:55px;text-align:center"><cf_get_lang_main no='75.no'></th>
                <th style="width:200px;text-align:center"><cf_get_lang_main no='1408.Başlık'></th>
				<th style="width:100px;text-align:center"><cf_get_lang_main no='330.tarih'></th>
                <th style="width:100px;text-align:center"><cfoutput>#getLang('prod',485)#</cfoutput></th>
                <th style="width:120px;text-align:center"><cf_get_lang_main no='1447.Süreç'></th>
				<th style="width:100px;text-align:center"><cfoutput>#getLang('project',161)#</cfoutput></th>
                <th style="width:55px;text-align:center"><cf_get_lang_main no='344.Durum'></th>
				<th style="text-align:center"><cf_get_lang_main no='217.Açıklama'></th>
				<!-- sil -->
                <th style="width:20px;text-align:center">
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.add_ezgi_production_demand"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
                </th>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
        	<cfif isdefined("attributes.form_varmi") and GET_PLANNING.recordcount>
            	<cfset stage_list=''>
                <cfoutput query="GET_PLANNING">
                    <cfif len(PROCESS_STAGE) and not listfind(stage_list,PROCESS_STAGE)>
                        <cfset stage_list=listappend(stage_list,PROCESS_STAGE)>
                    </cfif>
                </cfoutput>
            	<cfif len(stage_list)>
                    <cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
                    <cfquery name="PROCESS_TYPE_ALL" datasource="#DSN#">
                        SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#stage_list#) ORDER BY PROCESS_ROW_ID
                    </cfquery>
                    <cfset stage_list = listsort(listdeleteduplicates(valuelist(process_type_all.process_row_id,',')),"numeric","ASC",",")>
                </cfif>
				<cfoutput query="GET_PLANNING" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
               		<tr>
                    	<td style="text-align:right">#currentrow#</td>
                    	<td style="text-align:center">
                            <a href="#request.self#?fuseaction=prod.upd_ezgi_production_demand&upd_id=#EZGI_DEMAND_ID#" class="tableyazi" title="#getLang('main',3077)#">
	                                #DEMAND_NUMBER#
                          	</a>
						</td>
                        <td>#DEMAND_HEAD#</td>
                        <td style="text-align:center">#DateFormat(DEMAND_DATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:center">#DateFormat(DEMAND_DELIVER_DATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:center"><cfif len(PROCESS_STAGE)>#process_type_all.stage[listfind(stage_list,PROCESS_STAGE,',')]#</cfif></td>
                       	<td>#get_emp_info(DEMAND_EMP,0,0)#</td>
                       	<td style="text-align:center"></td>
                       	<td style="text-align:left">#DEMAND_DETAIL#</td>
                        <td style="text-align:center">
                        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.upd_ezgi_production_demand&upd_id=#EZGI_DEMAND_ID#','page');"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>" border="0"></a>
                        </td>
                  	</tr>
               	</cfoutput>
            <cfelse>
			<tr>
				<td colspan="16"><cfif arama_yapilmali neq 1><cf_get_lang_main no='72.Kayit Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
			</tr>
            </cfif>	
		</tbody>
        <cfif isdefined("attributes.form_varmi")>
            <tfoot>
                <tr><td colspan="16"></td></tr>
            </tfoot>
        </cfif>
	</table>
<cfset url_str = '#request.self#?fuseaction=#attributes.fuseaction#'>
<cfif isdefined("attributes.product_id") and len(attributes.product_id) and isdefined("attributes.product_name") and len(attributes.product_name)>
	<cfset url_str = url_str & "&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
</cfif>
<cfif isdefined("attributes.prod_cat") and len(attributes.prod_cat)>
	<cfset url_str = url_str & "&prod_cat=#attributes.prod_cat#">
</cfif>
<cfif isdefined("attributes.planer_employee_id") and len(attributes.planer_employee_id)> 
	<cfset url_str = url_str & "&planer_employee_id=#attributes.planer_employee_id#&planer_employee=#attributes.planer_employee#">
</cfif>
<cfif isdefined("attributes.listing_type") and len(attributes.listing_type)>
	<cfset url_str = "#url_str#&listing_type=#attributes.listing_type#">
</cfif>
<cfif isdate(attributes.start_date)>
	<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfset url_str = url_str & "&sort_type=#attributes.sort_type#">
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#attributes.fuseaction#&#url_str#&form_varmi=1">
<script language="javascript">
	function input_control()
	{
		return true;
	}
</script>
