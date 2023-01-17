<!--- FB 20080215 diger modullerdeki ek bilgiler kapatilip de objects e taşındı, sorun olursa lutfen bildirin. --->
<cfparam name="attributes.modal_id" default="">
<cfsetting showdebugoutput="YES">
<cfinclude template="../query/get_info_plus_detail.cfm">
<cfset list_name="">
<cfset list_no="">
<cfloop from="1" to="40" index="i">
	<cfif len(evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
        <cfset list_name=listappend(list_name,evaluate("GET_LABELS.PROPERTY#i#_NAME"),',')>
    </cfif>
    <cfif len(evaluate("GET_LABELS.PROPERTY#i#_NO"))>
        <cfset list_no=listappend(list_no,"#i#;#evaluate('GET_LABELS.PROPERTY#i#_NO')#",',')>
    <cfelse>
        <cfset list_no=listappend(list_no,"#i#;#i#",',')>
    </cfif>
</cfloop>
<cfsavecontent variable="right_images">
	<cfif get_labels.recordcount and listlen(list_name)>
		<li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_history_info&info_id=#attributes.info_id#&type_id=#attributes.type_id#<cfif isdefined("attributes.product_catid")>&product_catid=#attributes.product_catid#</cfif><cfif isdefined("attributes.sub_catid")>&sub_catid=#attributes.sub_catid#</cfif></cfoutput>','','ui-draggable-box-small');"><i class="fa fa-history" alt="<cf_get_lang dictionary_id='57473.Tarihçe'>" title="<cf_get_lang dictionary_id='57473.Tarihçe'>"></i></a></li>
	</cfif>
</cfsavecontent>
<cfsavecontent variable="title_2">
<cfswitch expression="#type_id#">
    <cfcase value="-1"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></cfcase>
    <cfcase value="-2"><cf_get_lang dictionary_id='57586.Bireysel Üye'></cfcase>
    <cfcase value="-3"><cf_get_lang dictionary_id='58612.Üye Şirket Çalışanı'></cfcase>
    <cfcase value="-4"><cf_get_lang dictionary_id='57576.Çalışan'></cfcase>
    <cfcase value="-5"><cf_get_lang dictionary_id='57657.Ürün'></cfcase>
    <cfcase value="-6"><cf_get_lang dictionary_id='42103.Urun Agaci'></cfcase>
    <cfcase value="-7"><cf_get_lang dictionary_id='58207.Satış Siparişleri'></cfcase>
    <cfcase value="-8"><cf_get_lang_main dictionary_id='50922.Alış Faturaları'></cfcase>
    <cfcase value="-32"><cf_get_lang dictionary_id='50921.Satış Faturaları'></cfcase>
    <cfcase value="-9"><cf_get_lang dictionary_id='30007.Satış Teklifleri'></cfcase>
    <cfcase value="-10"><cf_get_lang dictionary_id='57416.Proje'></cfcase>
    <cfcase value="-11"><cf_get_lang dictionary_id='58832.Abone'></cfcase>
    <cfcase value="-12"><cf_get_lang dictionary_id='33507.Satınalma Siparişleri'></cfcase>
    <cfcase value="-13"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></cfcase>
    <cfcase value="-14"><cf_get_lang dictionary_id='57773.İrsaliye'></cfcase>
    <cfcase value="-15"><cf_get_lang dictionary_id='57656.Servis'></cfcase>
    <cfcase value="-16"><cf_get_lang dictionary_id='32447.Satış Fırsatlar'></cfcase>
    <cfcase value="-18"><cf_get_lang dictionary_id='58445.İş'></cfcase>
    <cfcase value="-21"><cf_get_lang dictionary_id='29522.Sözleşme'></cfcase>
    <cfcase value="-22"><cf_get_lang dictionary_id='43214.Stok Fişleri'></cfcase>
    <cfcase value="-24"><cf_get_lang dictionary_id="57438.callcenter">-<cf_get_lang dictionary_id="58186.başvurular"></cfcase>
    <cfcase value="-28"><cf_get_lang dictionary_id="49752.Satınalma Talebi"></cfcase>
    <cfcase value="-29"><cf_get_lang dictionary_id="30782.İç Talepler"></cfcase>
    <cfcase value="-30"><cf_get_lang dictionary_id="30048.Satınalma Teklifleri"></cfcase>
</cfswitch>
</cfsavecontent>

<!--- Alan bazlı yetkilendirilmiş ögelerdeki zorunluluk kontrolü için eklendi. Burada ekranda gösterilmeyen veya kullanıcıya güncelletilmeyen alanlardaki zorunluluk kaldırılıyor. --->
<cfset no_req_inputs = ''>
<cfif isdefined("no_view_form_uls")>
	<cfloop list="#no_view_form_uls#" index="no_view">
		<cfif not listFindNoCase(no_req_inputs,no_view,',')>
			<cfset no_req_inputs = listAppend(no_req_inputs,Replace(Replace(no_view,'_#attributes.type_id#',''),'form_ul_',''),',')>
		</cfif>
	</cfloop>
</cfif>
<cfif isdefined("no_edit_form_uls")>
	<cfloop list="#no_edit_form_uls#" index="no_edit">
		<cfif not listFindNoCase(no_req_inputs,no_edit,',')>
			<cfset no_req_inputs = listAppend(no_req_inputs,Replace(Replace(no_edit,'_#attributes.type_id#',''),'form_ul_',''),',')>
		</cfif>
	</cfloop>
</cfif>
<!--- Alan bazlı yetkilendirilmiş ögeler icin zorunluluk kontrolü için eklendi --->
<cf_box title="#getLang('','Ek Bilgiler',32671)# - #title_2#" right_images="#right_images#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfif get_labels.recordcount and listlen(list_name)>
			<cfif get_values.recordcount>
				<cfset send_par="upd_info_plus_all"><!--- upd_info_plus_act --->
			<cfelse>
				<cfset send_par="add_info_plus"><!--- add_info_plus_act --->
			</cfif>
			<cfform name="form_info_plus" action="#request.self#?fuseaction=objects.#send_par#" method="post">
				<!--- frame_fuseaction bu fuseaction crm den geliyor lutfen dokunmayiniz, silmeyiniz FBS --->
				<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
                <cfif isdefined("attributes.is_nonpopup")><!--- ne olduguna bakilmali --->
                    <input type="hidden" name="is_nonpopup" id="is_nonpopup" value="<cfoutput>#attributes.is_nonpopup#</cfoutput>">
                </cfif>
                <input type="hidden" name="pro_info_id" id="pro_info_id" value="<cfif isdefined("get_labels.pro_info_id")><cfoutput>#get_labels.pro_info_id#</cfoutput><cfelseif isdefined("get_labels.info_id")><cfoutput>#get_labels.info_id#</cfoutput></cfif>">
                <input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined("attributes.product_catid")><cfoutput>#attributes.product_catid#</cfoutput></cfif>">
                <input type="hidden" name="info_id" id="info_id" value="<cfoutput>#attributes.info_id#</cfoutput>">
                <input type="hidden" name="type_id" id="type_id" value="<cfoutput>#attributes.type_id#</cfoutput>">
                <input type="hidden" name="sub_catid" id="sub_catid" value="<cfif isdefined("attributes.sub_catid")><cfoutput>#attributes.sub_catid#</cfoutput></cfif>">
                <input type="hidden" name="asset_catid" id="asset_catid" value="<cfif isdefined("attributes.asset_catid")><cfoutput>#attributes.asset_catid#</cfoutput></cfif>">
                <cfoutput>
                            <!--- BK 20080620 eger ek bilgi tanimlama ekranında kolon sayisi belli ise ona gore set edilir. --->
                            <cfif len(get_labels.column_number) and get_labels.column_number neq 0>
                                <cfset column_number =get_labels.column_number>
                            <cfelse>
                                <cfset column_number =2>
                            </cfif>	
                            <cfset row_number =ceiling(40/column_number)>
                            <cfset no=0>
                            <cfset clm_no=0>
                            <cfset width=100/column_number>
                        <cf_box_elements>
                            <cfloop from="1" to="#column_number#" index="j">
                                <cfset sortQuery = queryNew("index,sort", "varchar,integer")>
                                <cfloop from="1" to="#row_number#" index="i">
                                    <cfset no=no+1>
                                    <cfif len(Evaluate('get_labels.property#no#_no')) and isnumeric(Evaluate('get_labels.property#no#_no'))>
                                        <cfset no_ = Evaluate('get_labels.property#no#_no')>
                                    <cfelse>
                                        <cfset no_ = 999999999>
                                    </cfif>	
                                    <cfset queryAddRow(sortQuery)>
                                    <cfset querySetCell(sortQuery, "index", no)>
                                    <cfset querySetCell(sortQuery, "sort", no_)>
                                </cfloop>
                                <cfquery name="sorted" dbtype="query">
                                    SELECT index, sort FROM sortQuery WHERE sort is not null
                                    ORDER BY sort 
                                </cfquery>
                                <div class="col col-12 col-xs-12 col-sm-12 col-xs-12">
                                    <cfloop query="sorted">
                                        <cfif isdefined("get_labels.property#index#_name") and  len(Evaluate("get_labels.property#index#_name"))>
                                                <div class="form-group">
                                                    <cfif len(Evaluate('get_labels.property#index#_gdpr')) and isnumeric(Evaluate('get_labels.property#index#_gdpr'))>
                                                        <cfset gdpr_ = "#Evaluate('get_labels.property#index#_gdpr')#">
                                                    <cfelse>
                                                        <cfset gdpr_ = ''>
                                                    </cfif>
                                                    <cfif len(Evaluate('get_labels.property#index#_mask'))>
                                                        <cfset mask_ = "#Evaluate('get_labels.property#index#_mask')#">
                                                    <cfelse>
                                                        <cfset mask_ = ''>
                                                    </cfif>
                                                    <cfquery name="control_gdpr" datasource="#dsn#">
                                                        SELECT SENSITIVITY_LABEL_ID FROM GDPR_SENSITIVITY_LABEL
                                                            WHERE SENSITIVITY_LABEL_ID  IN (<cfqueryparam cfsqltype='integer' value='#session.ep.dockphone#' list="yes">)  
                                                    </cfquery>
                                                    <cfif len(gdpr_)>
                                                        <cfquery name="get_gdpr" dbtype="query">
                                                                SELECT SENSITIVITY_LABEL_ID FROM control_gdpr WHERE SENSITIVITY_LABEL_ID IN (<cfqueryparam cfsqltype='integer' value='#gdpr_#' list="yes">)
                                                        </cfquery>
                                                        <cfif get_values.recordcount>
                                                            <cfif get_gdpr.recordcount>
                                                                <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                                <cftry>
                                                                <!---<cfset value_ = contentEncryptingandDecodingAES(isEncode:0,content:value_,accountKey:session.ep.userid)>--->                                                                 
                                                                <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                                    <cfcatch>
                                                                        <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                                    </cfcatch>
                                                                </cftry>
                                                            <cfelse> 
                                                                <script>
                                                                    $(window).load(function(){ $("##property#index#").attr("readonly", true);$('##property#index#').attr('onclick','power()');})
                                                                </script>
                                                                <cfset value_="*******#mid(Evaluate('get_values.property#index#'),1,2)#">
                                                            </cfif>
                                                        <cfelse>
                                                            <cfif not get_gdpr.recordcount>
                                                                <script>
                                                                    $(window).load(function(){ $("##property#index#").attr("readonly", true);$('##property#index#').attr('onclick','power()');})
                                                                </script>
                                                            </cfif>
                                                            <cfset value_ = "">
                                                        </cfif>
                                                    <cfelse>
                                                        <cfif get_values.recordcount>
                                                                <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                                <cftry>
                                                                    <!--- <cfset value_ = contentEncryptingandDecodingAES(isEncode:0,content:value_,accountKey:session.ep.userid)> --->
                                                                    <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                                    <cfcatch>
                                                                        <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                                    </cfcatch>
                                                                </cftry>
                                                        <cfelse>
                                                            <cfset value_ = "">
                                                        </cfif>
                                                    </cfif>
                                                    <cfif len(Evaluate('get_labels.property#index#_type'))>
                                                        <cfset validate_ = "#Evaluate('get_labels.property#index#_type')#">
                                                    <cfelse>
                                                        <cfset validate_ = "">
                                                    </cfif>
                                                    <cfif len(Evaluate('get_labels.property#index#_message'))>
                                                        <cfset message_ = "#Evaluate('get_labels.property#index#_name')# : #Evaluate('get_labels.property#index#_message')# (#getLang('main',398)#)">
                                                    <cfelse>
                                                        <cfset message_ = "">
                                                    </cfif>
                                                    <cfif len(Evaluate('get_labels.property#index#_range')) and isnumeric(Evaluate('get_labels.property#index#_range'))>
                                                        <cfset max_ = "#Evaluate('get_labels.property#index#_range')#">
                                                    <cfelse>
                                                        <cfset max_ = "500">
                                                    </cfif>
                                                    <cfset clm_no=j>
                                                    <label class="col col-4">#Evaluate("get_labels.property#index#_name")#<cfif Evaluate("get_labels.property#index#_req") eq 1> *</cfif></label>
                                                    
                                                    <cfif validate_ eq "integer">
                                                        <div class="col col-8">
                                                            <cfif Evaluate("get_labels.property#index#_req") eq 1>
                                                                <cfinput type="text" name="property#index#" value="#value_#" required="yes" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                                            <cfelseif (#column_number# eq 1) and isdefined ("attributes.info_type_id") and (attributes.info_type_id eq -5)>
                                                                <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                                            <cfelse>
                                                                <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                                            </cfif>
                                                        </div>
                                                    <cfelseif validate_ eq "select">
                                                        <cfif isdefined("GET_SELECT_VALUES")>
                                                            <cfquery name="get_row_selects_" dbtype="query">
                                                                SELECT * FROM GET_SELECT_VALUES WHERE PROPERTY_NO = #index#
                                                            </cfquery>
                                                        </cfif>
                                                        <div class="col col-8">
                                                            <cfif Evaluate("get_labels.property#index#_req") eq 1>
                                                                <cfselect name="property#index#" message="#message_#" required="yes">
                                                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                                    <cfif isdefined("get_row_selects_")>
                                                                        <cfloop query="get_row_selects_">
                                                                            <option value="#get_row_selects_.select_value#" <cfif get_row_selects_.select_value eq value_>selected</cfif>>#get_row_selects_.select_value#</option>
                                                                        </cfloop>
                                                                    </cfif>
                                                                </cfselect>
                                                            <cfelse>
                                                                <cfselect name="property#index#">
                                                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                                    <cfif isdefined("get_row_selects_")>
                                                                        <cfloop query="get_row_selects_">
                                                                            <option value="#get_row_selects_.select_value#" <cfif get_row_selects_.select_value eq value_>selected</cfif>>#get_row_selects_.select_value#</option>
                                                                        </cfloop>
                                                                    </cfif>
                                                                </cfselect>
                                                            </cfif>
                                                        </div>
                                                    <cfelse>
                                                        <cfif validate_ eq 'eurodate'>
                                                            <cfif validate_style is 'date'>
                                                                <cfset validate_ = "date">
                                                            </cfif>
                                                        </cfif>
                                                        <div class="col col-8">
                                                            <cfif Evaluate("get_labels.property#index#_req") eq 1>
                                                            <cfif validate_ eq 'eurodate' or validate_ eq 'date'>
                                                                <div class="input-group">
                                                                    <cfinput type="text" name="property#index#" value="#value_#" required="yes" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="property#index#" alt="#getLang('main',330)#"></span>
                                                                </div>
                                                                <cfelse>
                                                                    <cfinput type="text" name="property#index#" value="#value_#" required="yes" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                                                </cfif> 
                                                            <cfelseif (#column_number# eq 1) and isdefined ("attributes.info_type_id") and (attributes.info_type_id eq -5)>
                                                            <div class="input-group">    
                                                                <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                                                <cfif validate_ eq 'eurodate' or validate_ eq 'date'>
                                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="property#index#" alt="#getLang('main',330)#"></span>
                                                                </cfif>
                                                            </div>    
                                                            <cfelse>
                                                                <cfif validate_ eq 'eurodate' or validate_ eq 'date'>
                                                                <div class="input-group">
                                                                    <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="property#index#" alt="#getLang('main',330)#"></span>
                                                                </div>
                                                                <cfelse>
                                                                    <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                                                </cfif>    
                                                            </cfif>
                                                        </div>
                                                    </cfif>
                                                </div>      
                                        </cfif>
                                    </cfloop> 
                                </div>  
                            </cfloop>
                        </cf_box_elements>
                        <cfloop from="1" to="#column_number#" index="j">
                            <cfif clm_no eq j>
                                <cf_box_footer>
                                    <cf_record_info query_name="GET_VALUES">
                                    <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_info_plus' , #attributes.modal_id#)"),DE(""))#">
                                </cf_box_footer>
                            </cfif>
                        </cfloop>
                </cfoutput> 
			</cfform>
	<cfelse>
        <cf_box_elements>
            <div class="form-group">
                <label><cf_get_lang dictionary_id='29717.Ayarlar Modülünden Ek Bilgi Detaylarını Doldurunuz'></label>
            </div>
        </cf_box_elements>
	</cfif>
</cf_box>
<script>
    function power() {
        alert("<cf_get_lang dictionary_id='57532.Yetkiniz yok'>!");
    }
</script>