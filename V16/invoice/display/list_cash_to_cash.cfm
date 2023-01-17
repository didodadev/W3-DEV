
<cfobject name="whops_cash" type="component" component="V16.invoice.cfc.cash_to_cash">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.pos_id" default="">
<cfparam name="attributes.cash_id" default="">
<cfparam name="attributes.delivery_start_date" default="">
<cfparam name="attributes.delivery_finish_date" default="">

<cfscript>
    get_pos_equipment = whops_cash.get_pos_equipment();

    get_branch = whops_cash.get_branch();
        if (isdefined('attributes.is_submitted'))
        {
            get_cash_ = whops_cash.get_cash(
            branch_id:attributes.branch_id,
            pos_id: attributes.pos_id,
            cash_id: attributes.cash_id,
            delivery_start_date: attributes.delivery_start_date,
            delivery_finish_date:attributes.delivery_finish_date,
            startrow:'#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
            maxrows: '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#');
        }
        else
        get_cash_.recordcount=0;
            
        url_str = "";
        if (IsDefined('attributes.pos_id') and len(attributes.pos_id))
            url_str="#url_str#&pos_id=#attributes.pos_id#";
        if (IsDefined('attributes.cash_id') and len(attributes.cash_id))
            url_str="#url_str#&cash_id=#attributes.cash_id#";
        if (IsDefined('attributes.delivery_start_date') and len(attributes.delivery_start_date))
            url_str="#url_str#&delivery_start_date=#attributes.delivery_start_date#";
        if (IsDefined('attributes.branch_id') and len(attributes.branch_id))
            url_str="#url_str#&branch_id=#attributes.branch_id#";
        if (IsDefined('attributes.delivery_finish_date') and len(attributes.delivery_finish_date))
            url_str="#url_str#&delivery_finish_date=#attributes.delivery_finish_date#";
        if (IsDefined('attributes.is_submitted') and len(attributes.is_submitted))
            url_str="#url_str#&is_submitted=#attributes.is_submitted#";
</cfscript>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_cash_.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <div class="col col-12 col-xs-12" id="div_search">
        <cf_box> 
            <cfform name="search_form" method="post" action="#request.self#?fuseaction=whops.cash_to_cash_register">
                <input name="is_submitted" id="is_submitted" value="1" type="hidden">
                    <cf_box_search>
                        <div class="form-group" id="item-branch_id">
                            <div class="form-group">
                                <select id="branch_id" name="branch_id">
                                    <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                    <cfoutput query="get_branch">
                                        <option value="#BRANCH_ID#" <cfif BRANCH_ID EQ attributes.BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-whops_cash">
                            <select id="pos_id" name="pos_id" onchange="load_cash('2')">
                                <option value=""><cf_get_lang dictionary_id='62481.Whops'></option>
                                <cfoutput query="get_pos_equipment">
                                    <option value="#pos_id#" <cfif pos_id EQ attributes.pos_id>selected</cfif>>#EQUIPMENT#</option>
                                </cfoutput>
                            </select>
                        </div>
                        <div class="form-group" id="item-cash_id">
                            <select id="cash_id" name="cash_id">
                                <option value=""><cf_get_lang dictionary_id='57520.Kasa'></option>
                                    <cfif isDefined('attributes.pos_id') and len(attributes.pos_id)>
                                        <cfscript>
                                            search_get_pos_cash = whops_cash.get_pos_cash(pos_id:attributes.pos_id);
                                        </cfscript>	
                                        <cfoutput query="search_get_pos_cash">
                                            <option value="#cash_id#" <cfif attributes.cash_id eq cash_id>selected</cfif>>#CASH_NAME#</option>
                                        </cfoutput>
                                    </cfif>
                            </select>
                        </div>
                        <div class="form-group" id="form_delivery_start_date">
                            <div class="input-group">
                                <cfsavecontent variable="start_date"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                <cfinput type="text" name="delivery_start_date" maxlength="10" validate="#validate_style#"  value="#dateformat(attributes.delivery_start_date,dateformat_style)#" placeholder="#start_date#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="delivery_start_date"></span>
                            </div>
                        </div>
                        <div class="form-group" id="form_delivery_finish_date">
                            <div class="input-group">
                                <cfsavecontent variable="finish_date"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                <cfinput type="text" name="delivery_finish_date"  maxlength="10" validate="#validate_style#" value="#dateformat(attributes.delivery_finish_date,dateformat_style)#"  placeholder="#finish_date#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="delivery_finish_date"></span>
                            </div>
                        </div>
                        <div class="form-group small">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
                        </div>
                        <div class="form-group">
                            <cf_wrk_search_button  button_type="4">
                        </div>
                    </cf_box_search>
            </cfform>
        </cf_box>
        <cf_box title="#getLang('','Whopstan Kasaya Para Yatırma İşlemleri',39952)#" hide_table_column="1" uidrop="1">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th colspan="3"></th>
                        <th colspan="3" class="text-center"><cf_get_lang dictionary_id='43633.Yazar Kasadaki Nakit'></th>
                        <th colspan="3" class="text-center"><cf_get_lang dictionary_id='49795.Kasaya'><cf_get_lang dictionary_id='40288.Teslim Edilen'></th>
                        <th colspan="3" class="text-center"><cf_get_lang dictionary_id='58444.Kalan'>- <cf_get_lang dictionary_id='58034.Devreden'></th>
                        <th width="30"></th>
                    </tr>
                    <tr>
                        <th></th>
                        <th class="text-center"><cf_get_lang dictionary_id='39344.Yazar Kasa'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='57453.Şube'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37345.TL'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37344.USD'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='40533.Euro'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37345.TL'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37344.USD'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='40533.Euro'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37345.TL'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37344.USD'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='40533.Euro'></th>
                        <th width="30"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=whopscash')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    </tr>
                </thead>
                <cfif get_cash_.recordcount>
                    <cfoutput query="get_cash_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tbody>
                            <tr>
                                <td>#currentrow#</td>
                                <td class="text-center">#equipment#</td>
                                <td class="text-center">#BRANCH_NAME#</td>
                                <td class="text-center">#dateformat(store_report_date,dateformat_style)#</td>
                                <td class="moneybox">#TLformat(cash_TL)#</td>
                                <td class="moneybox">#TLformat(cash_USD)#</td>
                                <td class="moneybox">#TLformat(cash_EURO)#</td>
                                <td class="moneybox">#TLformat(DELIVERED_TL)#</td>
                                <td class="moneybox">#TLformat(DELIVERED_USD)#</td>
                                <td class="moneybox">#TLformat(DELIVERED_EURO)#</td>
                                <td class="moneybox">#TLformat(REMAINING_TRANSFERRED_TL)#</td>
                                <td class="moneybox">#TLformat(REMAINING_TRANSFERRED_USD)#</td>
                                <td class="moneybox">#TLformat(REMAINING_TRANSFERRED_EURO)#</td>
                                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=whopscash&store_report_id=#store_report_id#')"><i class="fa fa-pencil"></i></a></td>
                            </tr>
                        </tbody>
                    </cfoutput>
                <cfelse>
                    <tbody>
                        <tr>
                            <td colspan="14"><cfif isdefined('attributes.is_submitted')  and get_cash_.recordcount eq 0><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                        </tr>
                    </tbody>
                </cfif>
            </cf_grid_list>
            <cfif attributes.totalrecords gt attributes.maxrows>   
                <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.cash_to_cash_register#url_str#">
                <cf_paging 
                    page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#adres#">
            </cfif>
        </cf_box>


<script>
    function upload_upd(id)
    {
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=whopscash&isbox=1&store_report_id'+id)
    }
    function kontrol() {
        if($('#whops_pos_id').val() == '')
        {
            alert('<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='62481.Whops'>- <cf_get_lang dictionary_id='57520.Kasa'>');
            return false;
        }
        
    }
    function load_cash(type) {
        if (type == 1) {
            selectObj= document.getElementById("whops_pos_id");
        }
        else if (type == 2){
            selectObj= document.getElementById("pos_id");
        }
        whops_pos_id_ =   selectObj.options[selectObj.selectedIndex].value;
      
		if(whops_pos_id_ != ''){
            sql="SELECT BRANCH_ID FROM POS_EQUIPMENT WHERE POS_ID ="+whops_pos_id_;
            get_branch_=wrk_query(sql,'dsn3');
            branch_id_ = get_branch_.BRANCH_ID[0];
            sql1="SELECT CASH_ID,CASH_NAME FROM CASH WHERE IS_WHOPS = 1 AND BRANCH_ID =" + branch_id_; 
            get_pos_cash_=wrk_query(sql1,'dsn2');
            if (type == 1) {
                var w_cash_ = document.getElementById('whops_cash_id');
                $("#whops_cash_id").empty();
            }
            else if (type == 2){
                var w_cash_ = document.getElementById('cash_id');
                $("#cash_id").empty();
            }
          
            var opt = document.createElement('option');
            if (type == 1) {
                opt.innerHTML ="<cf_get_lang dictionary_id='57734.Seçiniz'>";
            }
            else if (type == 2){
                opt.innerHTML ="<cf_get_lang dictionary_id='57520.Kasa'>";
            }
         
            opt.value = "";
            w_cash_.appendChild(opt);
		  }
       
        if(get_pos_cash_.CASH_NAME.length != 0){
            for(var i = 0; i < get_pos_cash_.CASH_NAME.length; i++) {
                var opt = document.createElement('option');
                opt.innerHTML = get_pos_cash_.CASH_NAME[i];
                opt.value = get_pos_cash_.CASH_ID[i];
                w_cash_.appendChild(opt);
            }
        }
        get_pos_cash_.CASH_NAME.length=0;
    }
</script>
</div>