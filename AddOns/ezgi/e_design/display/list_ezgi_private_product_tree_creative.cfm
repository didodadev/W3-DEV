<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.oby" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.status" default="2">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.design_type" default="">
<cfparam name="attributes.color_type" default="">
<cfparam name="attributes.stock_id" default="">
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
        	*
       	FROM
        	(
            SELECT  
                *,
                CASE
                    WHEN O.COMPANY_ID IS NOT NULL THEN
                       (
                        SELECT     
                            FULLNAME
                        FROM         
                            #dsn_alias#.COMPANY
                        WHERE     
                            COMPANY_ID = O.COMPANY_ID
                        )
                    WHEN O.CONSUMER_ID IS NOT NULL THEN      
                        (	
                        SELECT     
                            CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
                        FROM         
                            #dsn_alias#.CONSUMER
                        WHERE     
                            CONSUMER_ID = O.CONSUMER_ID
                        )
                END
                    AS UNVAN
            FROM 
                EZGI_DESIGN O
            WHERE 
                ISNULL(IS_PRIVATE,0) = 1
                <cfif len(attributes.company_id) and len(member_name)>
                    AND COMPANY_ID = #attributes.company_id#
                </cfif>
                <cfif len(attributes.consumer_id) and len(member_name)>
                    AND CONSUMER_ID = #attributes.consumer_id#
                </cfif>
                <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
                    AND PROCESS_STAGE = #attributes.process_stage#
                </cfif>
                <cfif attributes.status eq 2>
                    AND STATUS = 1
                <cfelseif attributes.status eq 3>
                    AND STATUS = 0
                </cfif>
        	) AS TBL
      	WHERE
        	1=1
        	<cfif len(attributes.keyword)>
            	AND 
                (
                	PROJECT_HEAD LIKE '%#attributes.keyword#%' OR
                    PROJECT_NUMBER LIKE '%#attributes.keyword#%' OR
                    UNVAN LIKE '%#attributes.keyword#%'
                )
            </cfif>
      	ORDER BY
        	<cfif attributes.oby eq 1>
        		UNVAN
            <cfelseif attributes.oby eq 2>
            	PROJECT_HEAD
           	<cfelseif attributes.oby eq 3>
            	PROJECT_NUMBER
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
<cfif isDefined('attributes.oby') and len(attributes.oby)>
	<cfset url_str = "#url_str#&oby=#attributes.oby#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ezgi_private_product_tree_creative%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfsavecontent variable="header_">
	<cf_get_lang_main no='2847.Özel Mobilya Tasarım'>
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
                     		<cfsavecontent variable="key_title"><cf_get_lang_main no='3048.Tasarım Adı ve Kodu Alanlarında Arama Yapabilirsiniz!'></cfsavecontent>
                            <cfinput type="text" name="keyword" id="keyword" title="#key_title#" value="#attributes.keyword#" style="width:120px; height:20px">
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
                <cf_object_table column_width_list="100">
                    <cf_object_tr id="form_ul_oby" title="#getLang('main',1512)#">
                        <cf_object_td>
                            <select name="oby" id="oby" style="width:100px;height:20px">
                            	<option value="0" <cfif attributes.oby eq 0>selected</cfif>><cf_get_lang_main no ='1512.Sıralama'></option>
                                <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no ='649.Cari'> <cf_get_lang_main no ='159.Ünvan'></option>
                                <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cfoutput>#getLang('project',124)#</cfoutput></option>
                                <option value="3" <cfif attributes.oby eq 3>selected</cfif>><cfoutput>#getLang('myhome',129)#</cfoutput></option>
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
                <cf_object_table column_width_list="80,130">
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
    </cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr>
            <th style="width:25px;"><cf_get_lang_main no='1165.Sıra'></th>
            <th style="width:100px;"><cf_get_lang_main no='800.Teklif No'></th>
            <th style="width:200px;"><cf_get_lang_main no ='107.Cari Hesap'></th>
      		<th style="width:70px;"><cf_get_lang_main no='1447.Süreç'></th>
            <th style="width:60px;"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
            <th style=""><cf_get_lang_main no='217.Açıklama'></th>
            <!-- sil -->
            <th style="text-align:center;width:10px;">
             	<cfoutput>
                    <a href="#request.self#?fuseaction=prod.add_ezgi_private_product_tree_creative">
                    	<img src="/images/plus_list.gif" style="text-align:center" title="#getLang('main',2827)#">
               		</a>
              	</cfoutput>
            </th>
            <!-- sil -->
        </tr>
    </thead>
    <tbody>
        <cfif len(attributes.is_submitted)>
            <cfif get_designs.recordcount>
            	<cfset design_id_list = ValueList(get_designs.DESIGN_ID)>
                <cfquery name="get_offer_number" datasource="#dsn3#">
                	SELECT        
                    	EDM.DESIGN_ID, 
                        O.OFFER_NUMBER,
                        O.OFFER_ID
					FROM            
                    	EZGI_DESIGN_MAIN_ROW AS EDM INNER JOIN
                     	OFFER_ROW AS OFR ON EDM.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID INNER JOIN
                     	OFFER AS O ON OFR.OFFER_ID = O.OFFER_ID
					WHERE        
                    	EDM.DESIGN_ID IN (#design_id_list#)
                </cfquery>
                <cfset process_stage_list = ''>
                <cfoutput query="get_designs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(process_stage) and not listfind(process_stage_list,process_stage)>
                        <cfset process_stage_list=listappend(process_stage_list,process_stage)>
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
                <form name="design_list" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.order">
                    <cfoutput query="get_designs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    	<cfquery name="get_design_offer_number" dbtype="query">
                        	SELECT OFFER_NUMBER,OFFER_ID FROM get_offer_number WHERE DESIGN_ID = #get_designs.DESIGN_ID# GROUP BY OFFER_NUMBER,OFFER_ID ORDER BY OFFER_NUMBER
                        </cfquery>
                        <tr>
                            <td style="text-align:right">#currentrow#</td>
                            <td style="text-align:center">
                            	<cfloop query="get_design_offer_number">
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#get_design_offer_number.OFFER_ID#','longpage');">
                                		#get_design_offer_number.OFFER_NUMBER#
                                    </a>
                                    &nbsp;
                                </cfloop>
                            </td>
                          	<td><a href="#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&design_id=#design_id#" class="tableyazi">#UNVAN#</a></td>
                            <td>#PROCESS_TYPE.STAGE[listfind(process_stage_list,process_stage,',')]#</td>
                            <td>#DateFormat(RECORD_DATE,'DD/MM/YYYY')#</td>
                            <td>#detail#</td>
                            <!-- sil -->
                            <td style="text-align:center;"><a href="#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&design_id=#design_id#"> <img src="/images/update_list.gif" title="#getLang('main',52)#"></a></td>
                            
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