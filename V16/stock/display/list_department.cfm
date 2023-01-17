<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="stock">
<cf_xml_page_edit fuseact="stock.list_departments">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.control_number" default="1">
<cfparam name="attributes.get_department_values" default="">
<cfparam name="attributes.volume" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_pos_id" datasource="#dsn#">
	SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfif isDefined("attributes.is_filter")>
    <cfquery name="get_department" datasource="#dsn#">
    WITH CTE1 AS 
    (
		SELECT DISTINCT
			D.DEPARTMENT_STATUS,
			D.IS_STORE,
			D.DEPARTMENT_ID,
			D.DEPARTMENT_HEAD,
			D.DEPARTMENT_DETAIL,
			D.ADMIN1_POSITION_CODE,
			B.BRANCH_ID,
			B.BRANCH_NAME,
            EP.EMPLOYEE_NAME,
            EP.EMPLOYEE_SURNAME,
            EP.EMPLOYEE_ID<!---,
            SL.DEPARTMENT_LOCATION--->
		FROM 
			DEPARTMENT D
            LEFT JOIN EMPLOYEE_POSITIONS EP ON D.ADMIN1_POSITION_CODE = EP.POSITION_CODE
            LEFT JOIN STOCKS_LOCATION SL ON D.DEPARTMENT_ID = SL.DEPARTMENT_ID
			,BRANCH B
		WHERE
			B.BRANCH_ID = D.BRANCH_ID AND
			D.IS_STORE <> 2 
			<cfif len(attributes.company_id)>
				AND B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfelse>
				AND B.COMPANY_ID IN
				(
					SELECT
						O.COMP_ID
					FROM 
						SETUP_PERIOD SP, 
						EMPLOYEE_POSITION_PERIODS EP,
						OUR_COMPANY O
					WHERE 
						SP.OUR_COMPANY_ID = O.COMP_ID AND
						EP.PERIOD_ID = SP.PERIOD_ID AND 
						EP.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_id.position_id#">
				)
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
					D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                    D.DEPARTMENT_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					D.DEPARTMENT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                    (
                    	SL.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                    	SL.DEPARTMENT_LOCATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                    )
				)
			</cfif>
			<cfif isdefined("attributes.branch_id") and isdefined("attributes.branch") and len(attributes.branch)>
				AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfelseif session.ep.isBranchAuthorization>
				AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
			</cfif>
			<cfif attributes.is_active is 1>
				AND D.DEPARTMENT_STATUS = 1
			<cfelseif attributes.is_active is 0>
				AND D.DEPARTMENT_STATUS = 0
			<cfelse>
				AND D.DEPARTMENT_STATUS IS NOT NULL
			</cfif>	
            <cfif isdefined("attributes.get_department_values")  and len(attributes.get_department_values) and attributes.get_department_values neq -1>
            and D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_department_values#">
            </cfif>
	),
    CTE2 AS (
                SELECT
                     CTE1.*,
                     ROW_NUMBER() OVER (ORDER BY CTE1.DEPARTMENT_HEAD) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                     CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
            WHERE
                RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
    <cfparam name="attributes.totalrecords" default='#get_department.query_count#'>
    <cfif get_department.recordcount>
        <cfquery name="get_location" datasource="#dsn#"><!--- Lokasyonlar çekiliyor --->
            SELECT 
                D.DEPARTMENT_STATUS,
                SL.LOCATION_ID,
                SL.ID,
                SL.DEPARTMENT_ID,
                SL.DEPARTMENT_LOCATION,
                SL.COMMENT,
                SL.WIDTH AS LOCATION_WIDTH,
                SL.HEIGHT AS LOCATION_HEIGHT,
                SL.DEPTH AS LOCATION_DEPTH,
                SL.STATUS
            FROM 
                DEPARTMENT D,
                BRANCH B,
                STOCKS_LOCATION SL
            WHERE
                D.DEPARTMENT_ID IN (#valuelist(get_department.department_id)#) AND
                B.BRANCH_ID = D.BRANCH_ID AND
                D.IS_STORE <> 2 AND
                SL.DEPARTMENT_ID = D.DEPARTMENT_ID
               <!---  <cfif xml_show_product_place_info eq 1>
                    AND SL.LOCATION_ID NOT IN ( SELECT DISTINCT PP.LOCATION_ID FROM #dsn3_alias#.PRODUCT_PLACE PP WHERE PP.STORE_ID = D.DEPARTMENT_ID )
                </cfif> --->
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND(
                    D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                    D.DEPARTMENT_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					D.DEPARTMENT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                    (
                        SL.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        SL.DEPARTMENT_LOCATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                    )
                    )
                </cfif>
                <cfif attributes.is_active is 1>
                    AND (D.DEPARTMENT_STATUS = 1 OR SL.STATUS = 1)
                <cfelseif attributes.is_active is 0>
                    AND (D.DEPARTMENT_STATUS = 0 OR SL.STATUS = 0)
                <cfelse>
                    AND D.DEPARTMENT_STATUS IS NOT NULL
                </cfif>
            ORDER BY 
                D.DEPARTMENT_HEAD
        </cfquery>
    </cfif>
    <cfif xml_show_product_place_info eq 1><!--- Raf Bilgileri Gorunsun --->
    	<cfif get_department.recordcount and get_location.recordcount>
            <cfquery name="GET_PLACES" datasource="#DSN#">
             WITH CTE1 AS 
    (
                SELECT DISTINCT
                    SL.LOCATION_ID,
                    SL.DEPARTMENT_ID,
                    PP.PRODUCT_PLACE_ID,
                    PP.SHELF_TYPE,
                    PP.SHELF_CODE,
                    PP.WIDTH AS SHELF_WIDTH,
                    PP.HEIGHT AS SHELF_HEIGHT,
                    PP.DEPTH AS SHELF_DEPTH,
                    SHELF.SHELF_NAME,
                    PP.PLACE_STATUS,
                    D.DEPARTMENT_HEAD
                FROM 
                    DEPARTMENT D,
                    BRANCH B,
                    STOCKS_LOCATION SL,
                    #dsn3_alias#.PRODUCT_PLACE PP
                        LEFT JOIN SHELF ON PP.SHELF_TYPE = SHELF.SHELF_ID
                WHERE
                    B.BRANCH_ID = D.BRANCH_ID AND
                    SL.LOCATION_ID IN (#valuelist(get_location.location_id)#) AND
                    D.IS_STORE <> 2 AND
                    SL.LOCATION_ID = PP.LOCATION_ID  AND
                    SL.DEPARTMENT_ID = PP.STORE_ID AND
                    SL.DEPARTMENT_ID = D.DEPARTMENT_ID
                    <cfif attributes.is_active is 1>
                        AND D.DEPARTMENT_STATUS = 1
                        AND SL.STATUS = 1
                        AND PP.PLACE_STATUS = 1
                    <cfelseif attributes.is_active is 0>
                        AND D.DEPARTMENT_STATUS = 0
                        AND SL.STATUS = 0
                        AND PP.PLACE_STATUS = 0			
                    <cfelse>
                        AND D.DEPARTMENT_STATUS IS NOT NULL
                    </cfif>
                    ),
    CTE2 AS (
                SELECT
                     CTE1.*,
                     ROW_NUMBER() OVER (ORDER BY CTE1.DEPARTMENT_HEAD) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                     CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
            WHERE
                RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
            </cfquery>
        </cfif>
	</cfif>   
<cfelse>
	<cfset get_department.recordcount = 0>
    <cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfquery name="periods" datasource="#dsn#">
	SELECT DISTINCT
		O.COMP_ID,
		O.COMPANY_NAME
	FROM 
		SETUP_PERIOD SP, 
		EMPLOYEE_POSITION_PERIODS EP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		EP.PERIOD_ID = SP.PERIOD_ID AND 
		EP.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_id.position_id#">
	ORDER BY
		O.COMP_ID,
		O.COMPANY_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box >
        <cfform name="list_department" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_departments">
            <input type="hidden" name="is_filter" id="is_filter" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
                        <input type="text" placeholder="<cfoutput><cf_get_lang dictionary_id='57453.Şube'></cfoutput>" name="branch" id="branch" value="<cfif isdefined('attributes.branch') and len(attributes.branch)><cfoutput>#attributes.branch#</cfoutput></cfif>" style="width:80px;">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_name=list_department.branch&field_branch_id=list_department.branch_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list');"></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="company_id" id="company_id" onchange="degisim()" style="width:120px;">
                        <option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>
                        <cfoutput query="periods">
                            <option value="#COMP_ID#" <cfif COMP_ID eq attributes.company_id>selected</cfif>>#COMPANY_NAME#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group medium" >
                    <select id="get_department_values" name="get_department_values">    
                        <cfquery name="get_depo" datasource="#dsn#">
                           SELECT  DEPARTMENT_HEAD,DEPARTMENT_ID FROM  DEPARTMENT
                        </cfquery> 
                        <option value="-1"><cf_get_lang dictionary_id='58763.Depo'></option>
                        <cfoutput query="get_depo">
                            <option value="#DEPARTMENT_ID#" <cfif attributes.get_department_values eq DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small" >
                    <select id="volume" name="volume">    
                            <option value=""><cf_get_lang dictionary_id='30114.Hacim'></option>
                            <option value="1" <cfif attributes.volume is 1>selected</cfif>><cf_get_lang dictionary_id='63734.Metreküp'></option>
                            <option value="2" <cfif attributes.volume is 2>selected</cfif>><cf_get_lang dictionary_id='33088.Desi'></option>
                            <option value="3" <cfif attributes.volume is 3>selected</cfif>><cf_get_lang dictionary_id='63735.Fit Küp'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="is_active" id="is_active" style="width:50px;">
                        <option value="1" <cfif attributes.is_active is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                        <option value="0" <cfif attributes.is_active is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
                        <option value="2" <cfif attributes.is_active is 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div class="form-group" id="item-submit">    
                    <a href ="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=stock.list_departments&event=add</cfoutput>')" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(12,'Depolar',45189)#/#getLang(44,'Lokasyonlar',45221)#/#getLang(2147,'Raflar',29944)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="100"><cf_get_lang dictionary_id ='58585.Kod'></th>
                    <th><cf_get_lang dictionary_id='57982.Tür'></th>
                    <th><cf_get_lang dictionary_id='58763.Depo'>/<cf_get_lang dictionary_id='30031.Lokasyon'>/<cf_get_lang dictionary_id ='45667.Raf'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57629.Aciklama'></th>
                    <th width="20"><i class="wrk-uF0084" title="<cf_get_lang dictionary_id='34357.Harita'>"></th>
                    <th width="20"><i class="wrk-uF0082" title="<cf_get_lang dictionary_id='29944.Raflar'>"></th>
                    <th><cf_get_lang dictionary_id='57713.Boyut'></th>
                    <th><cf_get_lang dictionary_id='30114.Hacim'></th>
                    <th><cf_get_lang dictionary_id='29511.Yonetici'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                    <th width="20" class="header_icn_none"><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.list_departments&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_department.recordcount>
                    <cfoutput query="get_department">
                        <tr>
                            <td style="mso-number-format:'\@'">#get_department.department_id#</td>
                            <td><cf_get_lang dictionary_id='58763.Depo'></td>
                            <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.list_departments&event=upd&department_id=#get_department.department_id#');" class="formbold">#department_head#</a></td>
                            <td>#branch_name#</td>
                            <td>#department_detail#</td>
                            <td style="text-align:left;"><a href="javascript://" onClick="window.open('#request.self#?fuseaction=#fusebox.circuit#.location_map&get_department_values=#get_department.department_id#&is_submitted=1','list');" ><i class="wrk-uF0084" title="<cf_get_lang dictionary_id='34357.Harita'>"></i></a></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td>
                                <cfif len(get_department.ADMIN1_POSITION_CODE)>
                                    <a href="javascript://" class="tableyazi" onclick="window.open('#request.self#?fuseaction=rule.list_hr&event=det&emp_id=#EMPLOYEE_ID#','medium');">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
                                </cfif>
                            </td>
                            <td><cfif department_status><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                            <!-- sil --><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.list_departments&event=upd&department_id=#get_department.department_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                            <!-- sil --><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.list_departments&event=add_stock_location&department_id=#get_department.department_id#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td><!-- sil -->
                        </tr>
                        <cfquery name="get_location_row" dbtype="query">
                            SELECT * FROM get_location WHERE DEPARTMENT_ID = #get_department.department_id#
                        </cfquery>
                        <cfloop query="get_location_row">
                            <cfif status eq 1 or attributes.is_active neq 1>
                                <cfif len(location_width) and len(location_height) and len(location_depth)>
                                    <cfset alan_location=get_location_row.location_width*get_location_row.location_height*get_location_row.location_depth>
                                <cfelse>
                                    <cfset alan_location=0>
                                </cfif>
                                <tr>
                                    <td style="mso-number-format:'\@'">#get_location_row.department_location#</td>
                                    <td><cf_get_lang dictionary_id='30031.Lokasyon'></td>
                                    <td class="tableyazi">&nbsp;&nbsp;&nbsp;#get_location_row.comment#</td>
                                    <td></td>
                                    <td></td>
                                    <td><a href="javascript://" onClick="window.open('#request.self#?fuseaction=#fusebox.circuit#.location_map&location_id=#get_location_row.id#&is_submitted=1','list');"><i class="wrk-uF0084" title="<cf_get_lang dictionary_id='34357.Harita'>"></i></a></td>
                                    <td style="text-align:left;"><a href="javascript://" onClick="window.open('#request.self#?fuseaction=#fusebox.circuit#.location_management&event=det&location_id=#get_location_row.id#','list');"><i class="wrk-uF0082" title="<cf_get_lang dictionary_id='29944.Raflar'>"></i></a></td>
                                    <td>#location_width#*#location_height#*#location_depth#</td>
                                    <td align="right" style="text-align:right;">
                                        <cfif attributes.volume eq 1>
                                            #TLFormat(alan_location/10000,4)# m<sup><i>3</i></sup>
                                        <cfelseif attributes.volume eq 2>
                                            #TLFormat(alan_location/100,2)# dl
                                        <cfelseif attributes.volume eq 3>
                                            #TLFormat(alan_location/28316.85,5)# ft<sup><i>3</i></sup>
                                        <cfelse>
                                            #TLFormat(alan_location,0)# cm<sup><i>3</i></sup>
                                        </cfif>
                                    </td>
                                    <td></td>
                                    <td><cfif status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                                    <!-- sil -->
                                    <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.list_departments&event=upd_stock_location&id=#get_location_row.department_location#&location_id=#get_location_row.location_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                    <td>
                                        <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=stock.list_shelves&event=add&dep_in=#get_location_row.department_location#&loc_name=#URLEncodedFormat(get_location_row.comment)#&pid=');"> 
                                            <i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                        </a>
                                    </td>
                                    <!-- sil -->
                                </tr>
                                <cfif xml_show_product_place_info eq 1><!--- Raf Bilgileri Gorunsun --->
                                    <cfquery name="GET_PLACES_ROW" dbtype="query">
                                        SELECT * FROM GET_PLACES WHERE LOCATION_ID = #get_location_row.location_id# AND DEPARTMENT_ID = #get_department.department_id#
                                    </cfquery>
                                    
                                    <cfloop query="GET_PLACES_ROW">
                                        <cfif len(shelf_width) and len(shelf_height) and len(shelf_depth)>
                                            <cfset alan_shelf=shelf_width*shelf_height*shelf_depth>
                                        <cfelse>
                                            <cfset alan_shelf=0>
                                        </cfif>
                                        <tr>
                                            <td style="mso-number-format:'\@'">#get_location_row.department_location#-#shelf_code#</td>
                                            <td><cf_get_lang dictionary_id='45667.Raf'></td>
                                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#SHELF_NAME#</td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>#shelf_width#*#shelf_height#*#shelf_depth#</td>
                                            <td align="right" style="text-align:right;">
                                                <cfif attributes.volume eq 1>
                                                    #TLFormat(alan_shelf/10000,4)# m<sup><i>3</i></sup>
                                                <cfelseif attributes.volume eq 2>
                                                    #TLFormat(alan_shelf/100,2)# dl
                                                <cfelseif attributes.volume eq 3>
                                                    #TLFormat(alan_shelf/28316.85,5)# ft<sup><i>3</i></sup>
                                                <cfelse>
                                                    #TLFormat(alan_shelf,0)# cm<sup><i>3</i></sup>
                                                </cfif>
                                                
                                                </td>
                                            <td></td>
                                            <!-- sil -->
                                            <td><cfif place_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                                            <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=stock.list_shelves&event=upd&product_place_id=#product_place_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                            <!-- sil -->
                                            <td></td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </cfif>
                        </cfloop>
                    </cfoutput>

                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif not get_department.recordcount>
        <div class="ui-info-bottom"><p>
        <cfif isDefined("attributes.is_filter")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!
        </p></div>
        </cfif>
        <cfset url_str = ''>
        <cfif isdefined('attributes.is_filter') and Len(attributes.is_filter)>
            <cfset url_str = "#url_str#&is_filter=#attributes.is_filter#">
        </cfif>
        <cfif Len(attributes.is_active)><cfset url_str = "#url_str#&is_active=#attributes.is_active#"></cfif>
        <cfif Len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
        <cfif isdefined('attributes.branch') and Len(attributes.branch_id)>
            <cfset url_str = "#url_str#&branch=#attributes.branch#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif Len(attributes.company_id)>
            <cfset url_str = "#url_str#&company_id=#attributes.company_id#">
        </cfif>
        <cfif Len(attributes.get_department_values)>
            <cfset url_str = "#url_str#&get_department_values=#attributes.get_department_values#">
        </cfif>
        <cfif Len(attributes.volume)>
            <cfset url_str = "#url_str#&volume=#attributes.volume#">
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#attributes.fuseaction##url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
    <cfif len(attributes.company_id)>
    degisim();
    </cfif>
    function degisim(){
    var company = document.getElementById("company_id").value;
    if(company!=-1){
     get_department_id = wrk_query('SELECT DISTINCT * FROM  DEPARTMENT D,Branch B WHERE B.BRANCH_ID = D.BRANCH_ID AND B.COMPANY_ID ='+company,'dsn');
    var sel = document.getElementById('get_department_values');
    $("#get_department_values").empty();
    var opt = document.createElement('option');
    opt.innerHTML ="<cf_get_lang dictionary_id='58763.Depo'>";
    opt.value = "-1";
    sel.appendChild(opt);
      }
    if(get_department_id.DEPARTMENT_HEAD.length!=0){
    for(var i = 0; i < get_department_id.DEPARTMENT_HEAD.length; i++) {
    var opt = document.createElement('option');
    opt.innerHTML = get_department_id.DEPARTMENT_HEAD[i];
    opt.value = get_department_id.DEPARTMENT_ID[i];
    sel.appendChild(opt);
      }
    }
    get_department_id.DEPARTMENT_HEAD.length=0;
}
</script>
<style>
    sup {
        vertical-align: super;
        font-size: smaller;
    }
    </style>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
