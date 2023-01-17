<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sort_type" default="2">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.durum_emir" default="">
<cfparam name="attributes.master_plan_id" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.operation_type_id" default="">
<cfparam name="attributes.cat_id" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.department_id" default="29">
<cfparam name="attributes.PRODUCT_TYPE" default="">
<cfset kapasite_kullanim_orani = 0>
<cfset makine_sayisi = 0>
<cfquery name="get_master_plan" datasource="#dsn3#">
	SELECT        
    	MASTER_PLAN_ID, 
        MASTER_PLAN_NUMBER, 
        MASTER_PLAN_DETAIL
	FROM            
    	EZGI_IFLOW_MASTER_PLAN
  	<cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
        WHERE 
            MASTER_PLAN_CAT_ID =    
            
                    (
                        SELECT        
                            MASTER_PLAN_CAT_ID
                        FROM       
                            EZGI_IFLOW_MASTER_PLAN AS M
                        WHERE        
                            MASTER_PLAN_ID = #attributes.master_plan_id#
                    )
    </cfif>
	ORDER BY 
    	MASTER_PLAN_NUMBER
</cfquery>
<cfquery name="get_operation" datasource="#dsn3#">
	SELECT        
    	OPERATION_TYPE_ID, 
        OPERATION_TYPE
	FROM            
    	OPERATION_TYPES
	ORDER BY 
    	OPERATION_TYPE
</cfquery>
<cfquery name="get_station" datasource="#dsn3#">
   	SELECT        
    	W.STATION_ID, 
        W.STATION_NAME
	FROM            
      	WORKSTATIONS W
	WHERE        
    	W.UP_STATION IS NULL AND 
        W.STATION_ID IN 
        				(
                        	SELECT        
                            	PO.STATION_ID
							FROM            
                            	EZGI_IFLOW_MASTER_PLAN AS M INNER JOIN
                        		EZGI_IFLOW_MASTER_PLAN AS M1 ON M.MASTER_PLAN_CAT_ID = M1.MASTER_PLAN_CAT_ID INNER JOIN
                        		EZGI_IFLOW_PRODUCTION_ORDERS AS POL ON M1.MASTER_PLAN_ID = POL.MASTER_PLAN_ID INNER JOIN
                        		PRODUCTION_ORDERS AS PO ON POL.LOT_NO = PO.LOT_NO
							WHERE   
                            	(NOT (PO.STATION_ID IS NULL)) 
                                <cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
                                	AND M.MASTER_PLAN_ID = #attributes.master_plan_id#
                              	</cfif>
							GROUP BY 
                            	PO.STATION_ID
                        )
	ORDER BY 
    	W.STATION_NAME
</cfquery>
<cfoutput query="get_station">
	<cfset 'STATION_NAME_#STATION_ID#' = STATION_NAME>
</cfoutput>
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_ezgi_iflow_production_operations.cfm">
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_production_operations.recordcount = 0>
    <cfset arama_yapilmali = 1>
</cfif>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_production_operations.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
   	<cf_big_list_search title="#getLang('prod',55)#" collapsed="1">
		<cf_big_list_search_area>
            <table>
                <tr height="20px">
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:120px;" value="#attributes.keyword#" maxlength="500"></td>
                    <td>
                    	<select name="sort_type" id="sort_type" style="width:160px;height:20px">
                            <option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cfoutput>#getLang('product',945)#</cfoutput></option>
                            <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cfoutput>#getLang('product',946)#</cfoutput></option>
                            <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cfoutput>#getLang('main',3268)#</cfoutput></option>
                            <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cfoutput>#getLang('main',3269)#</cfoutput></option>
                            <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cfoutput>#getLang('main',3270)#</cfoutput></option>
                            <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>><cfoutput>#getLang('main',3271)#</cfoutput></option>
                        </select>
                    </td>

                    <td>
                    	<select name="durum_emir" id="durum_emir" style="width:150px;height:20px">
                         	<option value=""><cf_get_lang_main no='296.Tümü'></option>
                            <option value="5" <cfif attributes.durum_emir eq 5>selected</cfif>><cfoutput>#getLang('worknet',216)# #getLang('main',2806)#</cfoutput></option>
                           	<option value="3" <cfif attributes.durum_emir eq 3>selected</cfif>><cfoutput>#getLang('main',3272)# #getLang('main',2806)#</cfoutput></option>
                            <option value="2" <cfif attributes.durum_emir eq 2>selected</cfif>><cfoutput>#getLang('project',230)# #getLang('main',2806)#</cfoutput></option>
                         	<option value="0" <cfif attributes.durum_emir eq 0>selected</cfif>><cfoutput>#getLang('main',1305)# #getLang('main',2806)#</cfoutput></option>
                            <option value="1" <cfif attributes.durum_emir eq 1>selected</cfif>><cfoutput>#getLang('production',12)# #getLang('main',2806)#</cfoutput></option>
                     	</select>
                    </td>
                    <td>
                    	<select name="master_plan_id" style="width:150px;height:20px">
                        	<option value="" <cfif attributes.master_plan_id eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_master_plan">
                            	<option value="#MASTER_PLAN_ID#" <cfif attributes.master_plan_id eq MASTER_PLAN_ID>selected</cfif>>#MASTER_PLAN_NUMBER# - #MASTER_PLAN_DETAIL#</option>
                            </cfoutput>
                     	</select>
                    </td>
                    <td>
                    	<select name="station_id" style="width:150px;height:20px">
                        	<option value="" <cfif attributes.station_id eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_station">
                            	<option value="#STATION_ID#" <cfif attributes.station_id eq STATION_ID>selected</cfif>>#STATION_NAME#</option>
                            </cfoutput>
                     	</select>
                    </td>
                    <td>
                    	<select name="operation_type_id" style="width:150px;height:20px">
                        	<option value="" <cfif attributes.operation_type_id eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_operation">
                            	<option value="#operation_type_id#" <cfif attributes.operation_type_id eq operation_type_id>selected</cfif>>#operation_type#</option>
                            </cfoutput>
                     	</select>
                    </td>
					<td></td>
					<td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,2500" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="4" style="width:35px;">
                    </td>
                    <td><cf_wrk_search_button search_function='input_control()'></td>
				</tr>
			</table>
        </cf_big_list_search_area>
     	
   		<cf_big_list_search_detail_area>
			<table>
				<tr valign="middle">
                	<td>
                    	
                    </td>
                	<td></td>
                	<td>
                    	
                    </td>
                	<td></td>
					<td>
						
					</td>
                    <td><cf_get_lang_main no='74.Kategori'></td>
					<td>
						<input type="hidden" name="cat_id" id="cat_id" value="<cfif len(attributes.cat_id) and len(attributes.category_name)><cfoutput>#attributes.cat_id#</cfoutput></cfif>">
						<input type="hidden" name="cat" id="cat" value="<cfif len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
						<input name="category_name" type="text" id="category_name" style="width:170px;height:20px" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
						<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search.cat_id&field_code=search.cat&field_name=search.category_name</cfoutput>','list');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
					</td>
                </tr>
			</table>
		</cf_big_list_search_detail_area>
	</cf_big_list_search>
	
	<cf_big_list id="list_product_big_list">
        <thead>
            <tr valign="middle">
                <th style="width:25px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='1165.Sıra'></th>
                <th style="width:65px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='711.Planlama'><br /><cf_get_lang_main no='1181.Tarihi'></th>
                <th style="width:50px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('objects',279)#</cfoutput><br /><cf_get_lang_main no='75.No'></th>
                <th style="width:50px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='3273.Parti'><br /><cf_get_lang_main no='75.No'></th>
                <th style="width:50px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('production',82)#</cfoutput><br /><cf_get_lang_main no='75.No'></th>
            	<th style="width:50px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('prod',343)#</cfoutput><br /><cf_get_lang_main no='75.No'></th>
                <th style="text-align:center; vertical-align:middle" ><cf_get_lang_main no='245.Ürün'></th>
                <th style="width:95px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='3274.Kesim'><br /><cf_get_lang_main no='90.Bitiş'></th>
                <th style="width:95px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='1676.İstasyonlar'></th>
                <th style="width:95px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='2806.Operasyonlar'></th>
                <th style="width:40px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='223.Miktar'></th>
                <th style="width:40px; text-align:center; vertical-align:middle" ><cfoutput>#getLang('prod',295)#</cfoutput></th>
                <th style="width:40px; text-align:center; vertical-align:middle" ><cf_get_lang_main no='1032.Kalan'></th>
             	<th style="width:20px; text-align:center; vertical-align:middle" class="header_icn_none" ></th>
                <!-- sil -->
                <th style="width:20px; text-align:center; vertical-align:middle" class="header_icn_none" ></th>
                <!-- sil -->
            </tr>
        </thead>
        
        <tbody>
            <cfif get_production_operations.recordcount>
                <cfoutput query="get_production_operations" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td style="text-align:right;">#CURRENTROW#</td>
                        <td style="text-align:center;" nowrap>#DateFormat(PLANNING_DATE, 'DD/MM/YYYY')#</td>
                        <td style="text-align:center;">#MASTER_PLAN_NUMBER#</td>
                        <td style="text-align:center;">#P_ORDER_PARTI_NUMBER#</td>
                        <td style="text-align:center;">#LOT_NO#</td>
                  		<td style="text-align:center;">
                       		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.order&event=upd&upd=#p_order_id#','longpage');" class="tableyazi">
                             	#P_ORDER_NO#
                        	</a>
                            
                   		</td> 
                        <td style="text-align:left;" nowrap="nowrap">#Left(PRODUCT_NAME,80)#<cfif len(PRODUCT_NAME) gt 80>...</cfif></td>
                        <td style="text-align:center;" nowrap>
                        	#DateFormat(START_DATE, 'DD/MM/YYYY')# - (#TimeFormat(START_DATE, 'HH:MM')#)
                       	</td>
                        <td style="text-align:center;" nowrap>#STATION_NAME#</td>
                        <td style="text-align:center;" nowrap>#OPERATION_TYPE#</td>
                       	<td style="text-align:right;">#AmountFormat(AMOUNT)#</td>
                      	<td style="text-align:right;">#AmountFormat(REAL_AMOUNT)#</td>
                       	<td style="text-align:right;"><!---#AmountFormat(AMOUNT-REAL_AMOUNT)#---></td>
                     	<td style="text-align:center;" nowrap>
                         	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_iflow_production_order_result&p_order_id=#p_order_id#','small');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
                     	</td>
                    	<!-- sil -->
                            <td style="text-align:center;">
                                <cfif STAGE eq 0>
                                    <img src="/images/yellow_glob.gif" title="#getLang('prod',270)#">
                               	<cfelseif STAGE eq 3>
                                    <img src="/images/red_glob.gif" title="#getLang('prod',271)#">
                                <cfelseif STAGE eq 1>
                                    <img src="/images/green_glob.gif" title="#getLang('prod',577)#">
                                </cfif>
                            </td>
                        	<td style="text-align:center;">
                            	
                          	</td> 
                        <!-- sil -->
                    </tr>
                </cfoutput>

            <cfelse>
                <tr> 
                    <td colspan="20" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
	</cf_big_list>
</cfform>  
<cfset adres = url.fuseaction>
<cfif len(attributes.cat) and len(attributes.category_name)>
  <cfset adres = '#adres#&cat=#attributes.cat#&category_name=#attributes.category_name#'>
</cfif>
<cfif isDefined('attributes.company_id') and len(attributes.company_id) and isDefined('attributes.company') and len(attributes.company)>
  <cfset adres = '#adres#&company_id=#attributes.company_id#&company=#attributes.company#'>
</cfif>		
<cfif len(attributes.keyword)>
  <cfset adres = '#adres#&keyword=#URLEncodedFormat(attributes.keyword)#'>
</cfif>
<cfif len(attributes.sort_type)>
	<cfset adres = '#adres#&sort_type=#attributes.sort_type#'>
</cfif>
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#&is_form_submitted=1">
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function input_control()
	{
		return true;	
	}
	function change_list_type()
	{
		if(document.getElementById('list_type').value == 2)
		{
			document.getElementById('product_type').style.display = 'none';
			document.getElementById('sort_type').style.display = '';
		}
		else if(document.getElementById('list_type').value == 3 || document.getElementById('list_type').value == 4 || document.getElementById('list_type').value == 5)
		{
			document.getElementById('product_type').style.display = 'none';
			document.getElementById('sort_type').style.display = 'none';
		}
		else if(document.getElementById('list_type').value == 1)
		{
			document.getElementById('product_type').style.display = '';
			document.getElementById('sort_type').style.display = '';
		}
	}	
	function secim(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
		p_order_id_list = '';
		chck_leng = document.getElementsByName('select_sub_plan').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_sub_plan[ci];
			if(chck_leng == 1)
				var my_objets =document.all.select_sub_plan;
			if(type == -1){//hepsini seç denilmişse	
				if(my_objets.checked == true)
					my_objets.checked = false;
				else
					my_objets.checked = true;
			}
			else
			{
				if(my_objets.checked == true)
					p_order_id_list +=my_objets.value+',';
			}
		}
		p_order_id_list = p_order_id_list.substr(0,p_order_id_list.length-1);//sondaki virgülden kurtarıyoruz.
		if(list_len(p_order_id_list,','))
		{
			if(type == -2)
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=286</cfoutput>&action_id='+p_order_id_list,'wide');	
			else if(type == -3)
				windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_ezgi_iflow_production_order_group&gurupla=1&master_plan_id=#attributes.master_plan_id#&list_type=#attributes.list_type#</cfoutput>&p_order_id_list='+p_order_id_list,'small');
			else if(type == -4)
				windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_ezgi_iflow_production_order_group&gurupla=0&master_plan_id=#attributes.master_plan_id#&list_type=#attributes.list_type#</cfoutput>&p_order_id_list='+p_order_id_list,'small');
		}
	}
</script>