<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.offer_stage" default="">
<cfparam name="attributes.offer_type" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url1_str = "">
<cfif isdefined("attributes.order_id")>
	<cfset url1_str = '#url1_str#&order_id=#attributes.order_id#'>
</cfif>
<cfif isdefined("attributes.order_name")>
	<cfset url1_str='#url1_str#&order_name=#attributes.order_name#'>
</cfif>
<cffunction name="total_price">
	<cfargument name="id_" type="numeric">
	<cfargument name="total_" type="numeric" default="1">
	<cfargument name="type_" type="numeric" default="1">
	<cfquery name="get_total_sum" datasource="#dsn3#">
		SELECT
			<cfif total_ eq 1>
				<cfif type_ eq 1>SUM(PRICE)<cfelse>PRICE</cfif> TOTAL_PRICE
			<cfelse>
				<cfif type_ eq 1>SUM(OTHER_MONEY_VALUE)<cfelse>PRICE_OTHER</cfif> TOTAL_PRICE
			</cfif>
		FROM
			<cfif type_ eq 1>OFFER<cfelse>OFFER_ROW</cfif>
		WHERE
			<cfif type_ eq 1>OFFER_ID<cfelse>OFFER_ROW_ID</cfif> = #id_#
	</cfquery>
	<cfif get_total_sum.recordcount>
		<cfreturn get_total_sum.total_price>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>
<cfif isdefined("form_varmi")>
	<cfquery name="get_offers" datasource="#dsn3#">
        SELECT
            OFFER.OFFER_ID,
            OFFER_NUMBER,
            FOR_OFFER_ID,
            OFFER_DATE,
            DELIVERDATE,
            OFFER_HEAD,
            OFFER_STAGE,
            DELIVERDATE
        FROM
            OFFER
            <cfif len(attributes.product_id) and len(attributes.product_name)>
           		,OFFER_ROW
            </cfif>
        WHERE
        	1=1
		<cfif len(attributes.product_id) and len(attributes.product_name)>
        	AND OFFER.OFFER_ID = OFFER_ROW.OFFER_ID
            AND OFFER_ROW.PRODUCT_ID =#attributes.product_id#
        </cfif> 
        <cfif len(attributes.keyword)>
        	AND (OFFER.OFFER_NUMBER LIKE '%#attributes.keyword#%' OR OFFER.OFFER_HEAD LIKE '%#attributes.keyword#%') 
        </cfif>
        <cfif len(attributes.employee_id) and len(attributes.employee)>
        	 AND OFFER.SALES_EMP_ID = #attributes.employee_id#
        </cfif>
        <cfif len(attributes.project_id) and len(attributes.project_head)>
			AND OFFER.PROJECT_ID = #attributes.project_id#
		</cfif>
        <cfif len(attributes.company_id) and len(attributes.company)>
			AND OFFER.COMPANY_ID=#attributes.company_id#
		</cfif>
		<cfif len(attributes.offer_stage)>
			AND OFFER.OFFER_STAGE = #attributes.offer_stage# 
		</cfif>
		<cfif len(attributes.offer_type)>
			AND OFFER.OFFER_STATUS = #attributes.offer_type# 
		</cfif>
    </cfquery>
    <cfparam name="attributes.totalrecords" default="#get_offers.recordcount#">
</cfif>
<cfquery name="get_process_type" datasource="#dsn#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_offer%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cf_box title="#getLang('','Teklifler',33905)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_filter" action="#request.self#?fuseaction=objects.popup_list_offers#url1_str#" method="post">
        <cfoutput>
            <cf_box_search>	
                <input type="hidden" name="form_varmi" id="form_varmi" value="1">
                <div class="form-group" id="item-keyword">
                    <input type="text" name="keyword" id="keyword" placeholder="<cfoutput>#getLang('','Filtre',57460)#</cfoutput>" value="#attributes.keyword#">
                </div>
                <div class="form-group" id="item-employee_id">
                    <div class="input-group">                         
                        <input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.employee_id)>value="#attributes.employee_id#"</cfif>>
                        <input type="text" name="employee" id="employee" placeholder="<cfoutput>#getLang('','Çalışan',57576)#</cfoutput>" onchange="txt_clear('employee_id',this.value)" value="<cfif len(attributes.employee_id) and len(attributes.employee)>#attributes.employee#</cfif>" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','200');" autocomplete="off">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_filter.employee_id&field_name=form_filter.employee&select_list=1&branch_related')"></span> 
                    </div> 
                </div>   
                <div class="form-group" id="item-company_id">
                    <div class="input-group">
                        <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)>#attributes.company_id#</cfif>">
                        <input type="text" name="company" id="company" placeholder="<cfoutput>#getLang('','Cari Hesap',57519)#</cfoutput>"  onchange="txt_clear('company_id',this.value)" value="<cfif len(attributes.company_id) and len(attributes.company)>#attributes.company#</cfif>" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','200');" autocomplete="off">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=form_filter.company&field_comp_id=form_filter.company_id&select_list=2&keyword='+encodeURIComponent(document.form_filter.company.value));"></span>
                    </div>
                </div>    
                <div class="form-group" id="item-offer_stage">
                    <select name="offer_stage" id="offer_stage">
                        <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                        <cfloop query="get_process_type">
                            <option value="#process_row_id#"<cfif attributes.offer_stage eq process_row_id>selected</cfif>>#stage#</option>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">            
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_filter' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
            <cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_filter' , #attributes.modal_id#)"),DE(""))#">   
                <div class="col col-6 col-xs-12">
                    <div class="form-group" id="item-product_id">
                        <div class="input-group">
                            <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="#attributes.product_id#"</cfif>>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
                            <input type="text" name="product_name"  id="product_name"  placeholder="<cfoutput>#message#</cfoutput>" onchange="txt_clear('product_id',this.value)" value="#attributes.product_name#" readonly="yes" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=form_filter.product_id&field_name=form_filter.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.form_filter.product_name.value),'list');"></span>
                        </div>
                    </div>
                    <div class="form-group" id="item-project_id">
                        <div class="input-group">        
                            <input type="hidden" name="project_id" id="project_id" value="<cfif  len (attributes.project_id)>#attributes.project_id#</cfif>">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
                            <input type="text" name="project_head"  id="project_head" placeholder="#message#" onchange="txt_clear('project_id',this.value)" value="<cfif len(attributes.project_head)>#attributes.project_head#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_filter.project_id&project_head=form_filter.project_head');"></span>
                        </div>
                    </div>    
                    <div class="form-group" id="item-offer_type">
                        <select name="offer_type" id="offer_type">
                            <option value="" <cfif attributes.offer_type eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                            <option value="1" <cfif attributes.offer_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58490.Verilen'></option>
                            <option value="0" <cfif attributes.offer_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58488.Alınan'></option>
                        </select>
                    </div>
                </div> 
            </cf_box_search_detail>    
        </cfoutput>
    </cfform>
    <cf_grid_list> 
        <thead>
            <th width="35"><cf_get_lang dictionary_id='58577.Sira'></th>
            <th width="35"><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id ='58680.İlişki'><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
            <th><cf_get_lang dictionary_id='57480.Konu'></th>
            <th><cf_get_lang dictionary_id='58859.Süreç'></th>
            <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
            <th width="80"><cf_get_lang dictionary_id='57673.Tutar'></th>
            <th width="50"><cf_get_lang dictionary_id='58474.Para Br'></th>
        </thead>
        <tbody>
            <cfset for_offer_list = "">
            <cfset process_list="">
            <cfif isdefined("attributes.form_varmi") and  get_offers.recordcount neq 0>
                <cfoutput query="get_offers" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <cfif len(for_offer_id) and not listfind(for_offer_list,for_offer_id)>
                        <cfset for_offer_list=listappend(for_offer_list,for_offer_id)>
                    </cfif>
                    <cfif len(offer_stage) and not listfind(process_list,offer_stage)>
                        <cfset process_list=listappend(process_list,offer_stage)>
                    </cfif>
                    <cfif len(for_offer_list)>
                        <cfquery name="get_for_offer_name" datasource="#dsn3#">
                            SELECT OFFER_ID, OFFER_NUMBER FROM OFFER WHERE OFFER_ID IN (#for_offer_list#) ORDER BY OFFER_ID
                        </cfquery>
                        <cfset for_offer_list = listsort(listdeleteduplicates(valuelist(get_for_offer_name.offer_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif len(process_list)>
                        <cfquery name="get_process_name" datasource="#dsn#">
                            SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#) ORDER BY PROCESS_ROW_ID
                        </cfquery>
                        <cfset process_list = listsort(listdeleteduplicates(valuelist(get_process_name.process_row_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                        <td>#currentrow#</td>
                        <td><a href="javascript:add_pos('#offer_id#','#offer_head#')" class="tableyazi">#offer_number#</a></td>
                        <td align="center"><cfif len(for_offer_id)><a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#for_offer_id#" class="tableyazi">#get_for_offer_name.offer_number[listfind(for_offer_list,for_offer_id,',')]#</a></cfif></td>
                        <td>#dateformat(offer_date,dateformat_style)#</td>
                        <td>#offer_head#</td>
                        <td><cfif len(offer_stage)>#get_process_name.stage[listfind(process_list,offer_stage,',')]#</cfif></td>
                        <td>#dateformat(deliverdate,dateformat_style)#</td>
                        <td class="text-right">#TLFormat(total_price(offer_id,1,1))#</td>
                        <td class="text-right">#session.ep.money#</td>
                    </tr>    
                </cfoutput> 
            <cfelse>
                <tr>
                    <td colspan="9">
                        <cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!
                    </td>
                </tr>    	 
            </cfif>	
        </tbody>
    </cf_grid_list>
    <cfset url_str = "">
    <cfif isdefined("attributes.form_varmi")>
        <cfif isdefined("attributes.order_id")>
            <cfset url_str = '#url_str#&order_id=#attributes.order_id#'>
        </cfif>
        <cfif isdefined("attributes.order_name")>
            <cfset url_str='#url_str#&order_name=#attributes.order_name#'>
        </cfif>
        <cfif len(attributes.product_id) and len(attributes.product_name)>
            <cfset url_str='#url_str#&product_id=#attributes.product_id#&product_name=#attributes.product_name#'>
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset url_str='#url_str#&keyword=#attributes.keyword#'>
        </cfif> 
        <cfif len(attributes.employee_id) and len(attributes.employee)>
            <cfset url_str='#url_str#&employee_id=#attributes.employee_id#&employee=#attributes.employee#'>
        </cfif>
        <cfif len(attributes.project_id) and len(attributes.project_head)>
            <cfset url_str='#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#'>
        </cfif>
        <cfif len(attributes.company_id) and len(attributes.company)>
            <cfset url_str='#url_str#&company_id=#attributes.company_id#&company=#attributes.company#'>
        </cfif>
        <cfif len(attributes.offer_stage)>
            <cfset url_str='#url_str#&offer_stage=#attributes.offer_stage#'>
        </cfif>
        <cfif len(attributes.offer_type)>
            <cfset url_str='#url_str#&offer_type=#attributes.offer_type#'>
        </cfif>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging 
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="objects.popup_list_offers&form_varmi=1#url_str#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').select();
	function txt_clear(deger,value)
	{
		if(value=='')
		{
			document.getElementById(deger).value='';
		}
	}
	function add_pos(id,head)
	{
		var i=0;
		<cfif isdefined("attributes.order_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_id#</cfoutput>.value=id;
			i=1
		</cfif>
		<cfif isdefined("attributes.order_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_name#</cfoutput>.value=head;
			if(i==1)
			{
				<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
			}
		</cfif>
	}
</script>
