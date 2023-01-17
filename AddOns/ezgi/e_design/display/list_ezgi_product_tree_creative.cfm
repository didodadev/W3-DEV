<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.oby" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.status" default="2">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.design_type" default="">
<cfparam name="attributes.color_type" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.is_prototip" default="2">
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date=''>
</cfif>	
<cfif isdefined('attributes.start_date_2') and isdate(attributes.start_date_2)>
	<cf_date tarih='attributes.start_date_2'>
<cfelse>
	<cfset attributes.start_date_2=''>
</cfif>
<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfquery name="get_designs" datasource="#dsn3#">
    	SELECT  
        	*,
            ISNULL(IS_PROTOTIP,0) PROTOTIP
       	FROM 
        	EZGI_DESIGN 
      	WHERE 
        	ISNULL(IS_PRIVATE,0) = 0
            <cfif len(attributes.keyword)>
            	AND 
                (
                	DESIGN_NAME LIKE '%#attributes.keyword#%' OR
                    DESIGN_CODE LIKE '%#attributes.keyword#%'
                )
            </cfif>
            <cfif len(attributes.company_id) and len(member_name)>
            	AND COMPANY_ID = #attributes.company_id#
            </cfif>
            <cfif len(attributes.consumer_id) and len(member_name)>
            	AND CONSUMER_ID = #attributes.consumer_id#
            </cfif>
            <cfif len(attributes.project_id) and len(attributes.project_head)>
            	AND PROJECT_ID = #attributes.project_id#
            </cfif>
            <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
            	AND PROCESS_STAGE = #attributes.process_stage#
            </cfif>
            <cfif attributes.status eq 2>
            	AND STATUS = 1
            <cfelseif attributes.status eq 3>
            	AND STATUS = 0
            </cfif>
            <cfif attributes.is_prototip eq 2>
            	AND ISNULL(IS_PROTOTIP,0) = 0
            <cfelseif attributes.is_prototip eq 1>
            	AND ISNULL(IS_PROTOTIP,0) = 1
            </cfif>
            <cfif len(attributes.product_cat)>
            	AND PRODUCT_CATID = #attributes.product_catid#
            </cfif> 
            <cfif attributes.design_type gt 0>
            	AND PROCESS_ID = #attributes.design_type#
            </cfif>	
            <cfif attributes.color_type gt 0>
            	AND COLOR_ID = #attributes.color_type#
            </cfif>	
      	ORDER BY
        	<cfif attributes.oby eq 1>
        		PRODUCT_CAT
            <cfelseif attributes.oby eq 2>
            	DESIGN_NAME
            <cfelse>
            	DESIGN_ID desc
            </cfif>
    </cfquery>
	<cfparam name="attributes.totalrecords" default='#get_designs.recordcount#'>
<cfelse>
	<cfset get_designs.recordcount = 0>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>wrkUrlStrings('url_str','status','production_stage','is_submitted','keyword','consumer_id','company_id','member_type','member_name','order_employee_id','order_employee','process_stage');</cfscript>
<cfif isdate(attributes.start_date)>
	<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdate(attributes.start_date_2)>
	<cfset url_str = url_str & "&start_date_2=#dateformat(attributes.start_date_2,'dd/mm/yyyy')#">
</cfif>
<cfif isDefined('attributes.oby') and len(attributes.oby)>
	<cfset url_str = "#url_str#&oby=#attributes.oby#">
</cfif>
<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
	<cfset url_str = '#url_str#&project_id=#attributes.project_id#'>
</cfif>
<cfif isDefined('attributes.project_head') and len(attributes.project_head)>
	<cfset url_str = '#url_str#&project_head=#attributes.project_head#'>
</cfif>
<cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
	<cfset url_str = '#url_str#&product_cat=#attributes.product_cat#'>
</cfif>
<cfif isDefined('attributes.product_catid') and len(attributes.product_catid)>
	<cfset url_str = '#url_str#&product_catid=#attributes.product_catid#'>
</cfif>
<cfif isDefined('attributes.design_type') and len(attributes.design_type)>
	<cfset url_str = '#url_str#&design_type=#attributes.design_type#'>
</cfif>
<cfif isDefined('attributes.color_type') and len(attributes.color_type)>
	<cfset url_str = '#url_str#&color_type=#attributes.color_type#'>
</cfif>
<cfif isDefined('attributes.attributes.is_prototip') and len(attributes.is_prototip)>
	<cfset url_str = '#url_str#&is_prototip=#attributes.is_prototip#'>
</cfif>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ezgi_product_tree_creative%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfsavecontent variable="header_">
	<cf_get_lang_main no='2826.Mobilya Tasarım'>
</cfsavecontent>
<cfform name="search_list" action="#request.self#?fuseaction=prod.#fuseaction_#" method="post">
    <input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <input type="hidden" name="is_excel" id="is_excel" value="0">
    <cf_big_list_search title="#header_#">
        <cf_big_list_search_area>
            <cf_object_main_table>
                <cf_object_table column_width_list="60,80">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                    <cf_object_tr id="form_ul_keyword" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no='48.Filtre'></cf_object_td>
                        <cf_object_td>
                     		<cfsavecontent variable="key_title"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                            <cfinput type="text" name="keyword" id="keyword" title="#key_title#" value="#attributes.keyword#" style="width:80px; height:20px">
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="100">
                    <cf_object_tr id="form_ul_process_stage" title="#getLang('main',1447)#">
                        <cf_object_td>
                            <select name="process_stage" id="process_stage" style="width:100px;height:20px">
                                <option value=""><cf_get_lang_main no='1447.Süreç'></option>
                                <cfoutput query="get_process_type">
                                    <option value="#process_row_id#"<cfif isdefined('attributes.process_stage') and attributes.process_stage eq process_row_id>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="160">
                    <cf_object_tr id="form_ul_design_type" title="#getLang('main',1239)#">
                        <cf_object_td>
                            <select name="design_type" id="design_type" style="width:160px;height:20px">
                                <option value="0" <cfif attributes.design_type eq 0>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1" <cfif attributes.design_type eq 1>selected</cfif>><cfoutput>#getLang('prod',429)#+#getLang('stock',371)#+#getLang('main',2848)#</cfoutput></option>
                                <option value="2" <cfif attributes.design_type eq 2>selected</cfif>><cfoutput>#getLang('prod',429)#+#getLang('stock',371)#</cfoutput></option>
                                <option value="3" <cfif attributes.design_type eq 3>selected</cfif>><cfoutput>#getLang('prod',429)#</cfoutput></option>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="65">
                    <cf_object_tr id="form_ul_color_type" title="#getLang('product',314)#">
                        <cf_object_td>
                            <select name="color_type" id="color_type" style="width:65px;height:20px">
                                <option value="0" <cfif attributes.color_type eq 0>selected</cfif>><cfoutput>#getLang('product',314)#</cfoutput></option>
                                 <cfoutput query="get_colors">
                                    <option <cfif attributes.color_type eq COLOR_ID>selected</cfif> value="#COLOR_ID#">#COLOR_NAME#</option>
                                </cfoutput>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="100">
                    <cf_object_tr id="form_ul_oby" title="#getLang('main',1512)#">
                        <cf_object_td>
                            <select name="oby" id="oby" style="width:100px;height:20px">
                            	<option value="0" <cfif attributes.oby eq 0>selected</cfif>><cf_get_lang_main no ='1512.Sıralama'></option>
                                <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no ='1995.Tasarım'> <cf_get_lang_main no ='1173.Kod'></option>
                                <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang_main no ='1995.Tasarım'> <cf_get_lang_main no ='485.Adı'></option>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="100">
                    <cf_object_tr id="form_ul_oby" title="#getLang('main',2549)#">
                        <cf_object_td>
                            <select name="is_prototip" id="is_prototip" style="width:100px;height:20px">
                            	<option value="0" <cfif attributes.is_prototip eq 0>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                <option value="1" <cfif attributes.is_prototip eq 1>selected</cfif>><cfoutput>#getLang('stock',250)#</cfoutput></option>
                                <option value="2" <cfif attributes.is_prototip eq 2>selected</cfif>><cfoutput>#getLang('product',216)#</cfoutput></option>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="65">
                    <cf_object_tr id="form_ul_status" title="#getLang('main',344)#">
                        <cf_object_td>
                            <select name="status" id="status" style="width:65px;height:20px">
                                <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                <option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                                <option value="3" <cfif attributes.status eq 3>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="80">
                    <cf_object_tr id="">
                        <cf_object_td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3" style="width:25px;height:20px">
                            <cf_wrk_search_button>
                            <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
            </cf_object_main_table>
        </cf_big_list_search_area>
        <cf_big_list_search_detail_area>
            <cf_object_main_table>
                <cf_object_table column_width_list="60,160">
                	<cfsavecontent variable="header_"><cf_get_lang_main no ='74.Kategori'></cfsavecontent>
                    <cf_object_tr id="form_ul_product_cat" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no ='74.Kategori'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                            <input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
                            <cfinput type="text" name="product_cat" id="product_cat" style="width:140px;height:20px" value="#attributes.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');">
                            <a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_code=search_list.product_cat_code&is_sub_category=1&field_id=search_list.product_catid&field_name=search_list.product_cat','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no ='1684.Kategori Ekle'>" style="vertical-align:bottom"></a>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <!---<cf_object_table column_width_list="80,130">
                	<cfsavecontent variable="header_"><cf_get_lang_main no ='107.Cari Hesap'></cfsavecontent>
                    <cf_object_tr id="form_ul_member_name" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no ='107.Cari Hesap'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                            <input type="hidden" name="company_id"  id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                            <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                            <input type="text" name="member_name"   id="member_name" style="width:110px;height:20px"  value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" autocomplete="off">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search_list.consumer_id&field_comp_id=search_list.company_id&field_member_name=search_list.member_name&field_type=search_list.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search_list.member_name.value),'list');"><img src="/images/plus_thin.gif" style="vertical-align:bottom"></a>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table> 
                <cf_object_table column_width_list="60,130">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='4.Proje'></cfsavecontent>
                    <cf_object_tr id="form_ul_project_head" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no='4.Proje'></cf_object_td>
                        <cf_object_td>
                            <cfif isdefined('attributes.project_head') and len(attributes.project_head)>
                                <cfset project_id_ = #attributes.project_id#>
                            <cfelse>
                                <cfset project_id_ = ''>
                            </cfif>
                            <cf_wrkproject
                                project_id="#project_id_#"
                                width="110"
                                agreementno="1" customer="2" employee="3" priority="4" stage="5"
                                boxwidth="600"
                                boxheight="400">
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>--->
            </cf_object_main_table>
        </cf_big_list_search_detail_area>
    </cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr>
            <th style="width:25px;"><cf_get_lang_main no ='1165.Sıra'></th>
           	<th style="width:150px;"><cf_get_lang_main no ='74.Kategori'></th>
            <th style="width:100px;"><cf_get_lang_main no ='1995.Tasarım'> <cf_get_lang_main no ='485.Adı'></th>
            <th style="width:80px;"><cfoutput>#getLang('product',314)#</cfoutput></th>
            <th style="width:100px;"><cf_get_lang_main no ='1525.Transfer İşlemi'></th>
            <th style="width:100px;"><cf_get_lang_main no ='1239.Türü'></th>
            <!---<th style="width:200px;"><cf_get_lang_main no ='107.Cari Hesap'></th>
       		<th style="width:150px;"><cf_get_lang_main no='4.Proje'></th>--->
      		<th style="width:70px;"><cf_get_lang_main no='1447.Süreç'></th>
            <th style="width:60px;"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
            <th><cf_get_lang_main no='217.Açıklama'></th>
            <!-- sil -->
            <th style="text-align:center;width:10px;">
             	<cfoutput>
                    <a href="#request.self#?fuseaction=prod.add_ezgi_product_tree_creative">
                    	<img src="/images/plus_list.gif" style="text-align:center" title="#getLang('settings',1929)#">
               		</a>
              	</cfoutput>
            </th>
            <!-- sil -->
        </tr>
    </thead>
    <tbody>
        <cfif len(attributes.is_submitted)>
            <cfif get_designs.recordcount>
                <cfset process_stage_list = ''>
                <cfset project_id_list =''>
                <cfset company_id_list =''>
                <cfset consumer_id_list =''>
                <cfset color_id_list =''>
                <cfoutput query="get_designs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(process_stage) and not listfind(process_stage_list,process_stage)>
                        <cfset process_stage_list=listappend(process_stage_list,process_stage)>
                    </cfif>
                    <cfif len(project_id) and not listfind(project_id_list,project_id)>
                        <cfset project_id_list=listappend(project_id_list,project_id)>
                    </cfif>
                    <cfif len(company_id) and not listfind(company_id_list,company_id)>
                        <cfset company_id_list=listappend(company_id_list,company_id)>
                    </cfif>
                    <cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
                        <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
                    </cfif>
                    <cfif len(color_id) and not listfind(color_id_list,color_id)>
                        <cfset color_id_list=listappend(color_id_list,color_id)>
                    </cfif>
                </cfoutput>
                <cfif len(process_stage_list)>
                    <cfset process_stage_list=listsort(process_stage_list,"numeric","ASC",",")>
                    <cfquery name="PROCESS_TYPE" datasource="#DSN#">
                        SELECT
                            STAGE,
                            PROCESS_ROW_ID
                        FROM
                            PROCESS_TYPE_ROWS
                        WHERE
                            PROCESS_ROW_ID IN(#process_stage_list#)
                        ORDER BY
                            PROCESS_ROW_ID
                    </cfquery>
                </cfif>
                <cfif len(project_id_list)>
                    <cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
                    <cfquery name="get_project" datasource="#DSN#">
                        SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN(#project_id_list#) ORDER BY PROJECT_ID
                    </cfquery>
                    <cfset project_id_list = listsort(valuelist(get_project.PROJECT_ID),"numeric","asc",",")>
                </cfif>
                
                <cfif len(color_id_list)>
                    <cfset color_id_list=listsort(color_id_list,"numeric","ASC",",")>
                    <cfquery name="get_color" datasource="#DSN3#">
                    	SELECT  COLOR_ID, COLOR_NAME FROM EZGI_COLORS WHERE COLOR_ID IN(#color_id_list#) ORDER BY COLOR_ID
                    </cfquery>
                </cfif>
                <cfif len(project_id_list)>
                    <cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
                    <cfquery name="get_project" datasource="#DSN#">
                        SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN(#project_id_list#) ORDER BY PROJECT_ID
                    </cfquery>
                    <cfset project_id_list = listsort(valuelist(get_project.PROJECT_ID),"numeric","asc",",")>
                </cfif>
                
             	<cfif len(company_id_list)>
                	<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
                 	<cfquery name="get_company" datasource="#dsn#">
                    	SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
                	</cfquery>
                	<cfset company_id_list = listsort(valuelist(get_company.COMPANY_ID),"numeric","asc",",")>
              	</cfif>
           		<cfif len(consumer_id_list)>
                 	<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
                  	<cfquery name="get_consumer" datasource="#dsn#">
                    	SELECT CONSUMER_ID,CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
                 	</cfquery>
                 	<cfset consumer_id_list = listsort(valuelist(get_consumer.CONSUMER_ID),"numeric","asc",",")>
             	</cfif>
                <form name="design_list" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.order">
                    <cfoutput query="get_designs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                        	<td style="text-align:right">#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&design_id=#design_id#" class="tableyazi">#PRODUCT_CAT#</a></td>
                            <td>#design_name#</td>
                            <td>#get_color.color_name[listfind(color_id_list,color_id,',')]#</td>
                            <td>
                            	<cfif process_id eq 1>
                                	#getLang('prod',429)#+#getLang('stock',371)#+#getLang('main',2848)#
                                <cfelseif process_id eq 2>
                                	#getLang('prod',429)#+#getLang('stock',371)#
                               	<cfelseif process_id eq 3>
                                	#getLang('prod',429)#
                                </cfif>
                            </td>
                            <td>
                            	<cfif PROTOTIP eq 0>
                                	#getLang('product',216)#
                                <cfelseif PROTOTIP eq 1>
                                	#getLang('stock',250)#
                                </cfif>
                            
                            </td>
                            <!---<td>
                             	<cfif listlen(company_id)>
                                  	#get_company.FULLNAME[listfind(company_id_list,company_id,',')]#
                              	<cfelseif listlen(consumer_id)>
                                 	#get_consumer.FULLNAME[listfind(consumer_id_list,consumer_id,',')]#
                             	</cfif>
                            </td>
                            <td><cfif len(project_id_list)>#get_project.PROJECT_HEAD[listfind(project_id_list,project_id,',')]#</cfif></td>--->
                            <td>#PROCESS_TYPE.STAGE[listfind(process_stage_list,process_stage,',')]#</td>
                            <td>#DateFormat(RECORD_DATE,'DD/MM/YYYY')#</td>
                            <td>#detail#</td>
                            <!-- sil -->
                            <td style="text-align:center;"><a href="#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&design_id=#design_id#"> <img src="/images/update_list.gif" title="#getLang('main',52)#"></a></td>
                            
                            <!-- sil -->
                        </tr>
                    </cfoutput>
            </tbody>
            <!-- sil -->
        	<tfoot>
                <tr height="40" class="nohover">
                    <td colspan="14" align="right" style="text-align:right;">
                       
                    </td>
                </tr>
                <!-- sil -->
            </tfoot>
    		<tbody>
        </form>
        <cfelse>
            <tr>
                <td colspan="15"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    <cfelse>
        <tr>
            <td colspan="15"><cf_get_lang_main no ='289.Filtre Ediniz'> !</td>
        </tr>
    </cfif>
    </tbody>
</cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
<!-- sil -->
	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
		<tr>
			<td>
				<cf_pages 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#get_designs.recordcount#" 
					startrow="#attributes.startrow#" 
					adres="prod.#fuseaction_##url_str#">
			</td>
			<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
<!-- sil -->
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>