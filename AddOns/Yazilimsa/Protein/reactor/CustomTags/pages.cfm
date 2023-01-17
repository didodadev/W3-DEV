<!--- 
Düzenleme:2 ve 3 numaralı sayfalama tiplerinin konulması ve URL'Den değer gönderimin kaldırıp form üzerinden çalışması sağlandı.
20071031 M.ER
 --->
<!--- arama formunda kaçli olacagina dair "maxrows" isimli select konulursa seçilen sayida listeler --->
<div class="ui-pagination">
    <!-- sil -->
        <div class="pagi-left">
	<cfif attributes.totalrecords>
		<cfparam name="attributes.name" default="paging">
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.adres" default="home.welcome">
		<cfparam name="attributes.maxrows" default=20>
		<cfparam name="attributes.totalrecords" default=1>
		<cfparam name="attributes.page_type" default="1">
		<cfparam name="attributes.button_type" default="0">
		<cfparam name="attributes.isAjax" default=false>
        <cfparam name="attributes.target" default="">
        <cfparam name="attributes.modal_id" default="#caller.attributes.modal_id?:''#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfset caller.lastpage = (attributes.totalrecords \ attributes.maxrows) + iif(attributes.totalrecords mod attributes.maxrows,1,0) >
		<!-- sil -->
		<cfif attributes.adres contains 'objects2.user_friendly'>
			<cfset attributes.adres = replace(attributes.adres,'objects2.user_friendly','objects2.user_friendly&USER_FRIENDLY_URL=#caller.attributes.USER_FRIENDLY_URL#','all')>
		</cfif>
        <cfoutput>       
		<!--- Tüm linklerin oncliklerine go_pages fonksiyonu ekledik,ilk değer eklenecek olan form adını,2.ci değer ise sayfa numarasını tutuyor. --->
			<cfif not listlen(attributes.page_type) or listfind(attributes.page_type,1)>
				<cfif attributes.button_type eq 0>
                    <ul>
                        <li <cfif attributes.page neq 1> onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name1','1');" class="" <cfelse> class="pagesButtonPassive" </cfif>><a href="javascript://"><i class="fa fa-angle-double-left" style="margin-top:-1.6px;"></i></a></li>
                        <li <cfif attributes.page neq 1> onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name1','#Evaluate(attributes.page-1)#');" class="" <cfelse> class="pagesButtonPassive" </cfif>><a href="javascript://"><i class="fa fa-angle-left" style="margin-top:-1.6px;"></i></a></li>        
                        <li <cfif attributes.page neq caller.lastpage> onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name1','#Evaluate(attributes.page+1)#');" class="pagesButtonActive" <cfelse> class="pagesButtonPassive" </cfif> ><a href="javascript://"><i class="fa fa-angle-right" style="margin-top:-1.6px;"></i></a></li>
                        <li <cfif attributes.page neq caller.lastpage> onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name1','#caller.lastpage#');" class="" <cfelse> class="pagesButtonPassive" </cfif>><a href="javascript://"><i class="fa fa-angle-double-right" style="margin-top:-1.6px;"></i></a></li>
                        <!--- <li><a onclick="font_inc(+1)" href="javascript://">A+</a></li>
                        <li><a onclick="font_inc(-1)" href="javascript://">A-</a></li>  --->
                    </ul>
				<cfelse>
					<cfif attributes.page neq 1>
						<a href="javascript://" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name1','1');" class="first_page_button"></a>
					<cfelse>
						<a href="javascript://" class="first_page_button_passive"></a>
					</cfif>
					<cfif attributes.page neq 1>
						<a href="javascript://" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name1','#Evaluate(attributes.page-1)#');" class="pre_page_button"></a>
					<cfelse>
						<a href="javascript://" class="pre_page_button_passive"></a>
					</cfif>
					<cfif attributes.page neq caller.lastpage>
						<a href="javascript://" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name1','#Evaluate(attributes.page+1)#');" class="next_page_button"></a>
					<cfelse>
						<a href="javascript://"  class="next_page_button_passive"></a><!--- onClick="_go_page_('cf_pages_form_name1','#Evaluate(attributes.page+1)#');" --->
					</cfif>
					<cfif attributes.page neq caller.lastpage>
						<a href="javascript://" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name1','#caller.lastpage#');" class="last_page_button"></a>
					<cfelse>
						<a href="javascript://" class="last_page_button_passive"></a><!--- onClick="_go_page_('cf_pages_form_name1','#caller.lastpage#');" --->
					</cfif>
				</cfif>
			</cfif>
            <ul cLass="justify-content-center">
                <cfif listlen(attributes.page_type) and listfind(attributes.page_type,2)>
                    <cfif attributes.page neq 1>
                        <li>
                            <a href="##" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name2','1');"></cfif><cfif attributes.page neq 1>...</a>
                        </li>
                    </cfif>
                    <cfif attributes.page-2 gt 0>
                        <li>
                            <a href="##" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name2','#attributes.page-2#');">#attributes.page-2#</a>
                        </li>
                    </cfif>
                    <cfif attributes.page-1 gt 0>
                        <li>
                            <a href="##" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name2','#attributes.page-1#');">#attributes.page-1#</a>
                        </li>
                    </cfif>			
                    <li>
                        <a href="##">#attributes.page#</a>
                    </li>
                    <cfif attributes.page+1 lte caller.lastpage>
                        <li>
                            <a href="##" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name2','#attributes.page+1#');">#attributes.page+1#</a>
                        </li>
                    </cfif>
                    <cfif attributes.page+2 lte caller.lastpage>
                        <li>
                            <a href="##" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name2','#attributes.page+2#');">#attributes.page+2#</a>
                        </li>
                    </cfif>
                    <cfif attributes.page neq caller.lastpage>
                        <li>
                            <a href="##" onclick="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name2','#caller.lastpage#');"></cfif><cfif attributes.page neq caller.lastpage>...</a>
                        </li>
                    </cfif>
                </cfif>
                <!--- <cfif listlen(attributes.page_type) and listfind(attributes.page_type,3)>
                    <select name="select_pages" id="select_pages" onchange="#attributes.name#_go_page_('#attributes.name#_cf_pages_form_name3',+' '+ this.value +' ');">
                        <cfloop from="1" to="#caller.lastpage#" index="pp">
                            <option value="#pp#"<cfif attributes.page eq pp >selected</cfif>>#pp#</option>
                        </cfloop>	
                    </select>
                </cfif> --->
             </cfoutput>
            <!-- sil -->
            </ul>
	</cfif>
	<cfoutput>
        <cfset site_url = (cgi.https eq 'on' ? 'https://' : 'http://') & cgi.server_name & "/#caller.attributes.param_lang#" />
		<cfif isdefined("caller.attributes.event")>
            <cfset actionAdress = '#site_url##attributes.adres#&event=#caller.attributes.event#'>
        <cfelse>
            <cfset actionAdress = '#site_url##attributes.adres#'>
        </cfif>
    	<cfif attributes.adres contains '&'>
			<cfset list_ands = ''>
            <cfset list_equals = ''>
            <cfset toplam = 0>
            <cfset toplam2 = 0>
            <cfset adres_for_ands = attributes.adres>
            <cfset adres_for_equals = attributes.adres>
            <cfset adres_ilk = attributes.adres>
            <cfset son_liste = ''>
            <cfloop from="1" to="#len(attributes.adres)#" index="adr">
                <cfif findNocase('&',adres_for_ands)>
                    <cfif not len(list_ands)>
                        <cfset list_ands = listAppend(list_ands,findNocase('&',attributes.adres),',')>
                        <cfset toplam = findNocase('&',adres_for_ands)>
                    <cfelse>
                        <cfset toplam = toplam + findNocase('&',adres_for_ands)>
                        <cfset list_ands = listAppend(list_ands,toplam)>
                    </cfif>
                    <cfset adres_for_ands = Replace(adres_for_ands,left(adres_for_ands,findNocase('&',adres_for_ands)),'')>
                </cfif>
                <cfif findNocase('=',adres_for_equals)>
                    <cfif not len(list_equals)>
                        <cfset list_equals = listAppend(list_equals,findNocase('=',adres_for_equals),',')>
                        <cfset toplam2 = findNocase('=',adres_for_equals)>
                    <cfelse>
                        <cfset toplam2 = toplam2 + findNocase('=',adres_for_equals)>
                        <cfset list_equals = listAppend(list_equals,toplam2)>
                    </cfif>
                    <cfset adres_for_equals = Replace(adres_for_equals,left(adres_for_equals,findNocase('=',adres_for_equals)),'')>
                </cfif>
            </cfloop>
            
            <cfset sira = 0>
            <cfloop list="#list_ands#" index="ilk_andler">
                <cfset sira = sira + 1>
                <cfloop list="#list_equals#" index="ilk_esittirler">
                    <cfif ilk_andler lt ilk_esittirler and sira lt listlen(list_ands)>
                        <cfset sonraki_ = listgetat(list_ands,sira+1)>
                        <cfif sonraki_ gt ilk_esittirler>
                            <cfset son_liste = listappend(son_liste,ilk_andler)>
                        </cfif>
                    <cfelseif ilk_andler lt ilk_esittirler and sira eq listlen(list_ands)>
                        <cfset son_liste = listappend(son_liste,ilk_andler)>
                    </cfif>
                </cfloop>
            </cfloop>
            
            <cfset adres_tek = ''>
            <cfset adres_ilk = Replace(adres_ilk,'&',chr(65533),'all')>
            <cfset sira = 0>
            <cfset start_count = 1>
            <cfloop list="#son_liste#" index="bbb">
                <cfset sira = sira + 1>
                <cfif not len(adres_tek)>
                    <cfset adres_tek = mid(adres_ilk,start_count,listGetAt(son_liste,sira) - start_count) & '&'>
                    <cfset start_count = listGetAt(son_liste,sira)+1>
                <cfelse>
                    <cfset adres_tek = adres_tek & mid(adres_ilk,start_count,listGetAt(son_liste,sira) - start_count) & '&'>
                    <cfset start_count = listGetAt(son_liste,sira)+1>
                </cfif>
            </cfloop>
            <cfif listGetAt(son_liste,sira) lt len(adres_ilk)>
                <cfset adres_tek = adres_tek & mid(adres_ilk,listGetAt(son_liste,sira)+1,len(adres_ilk)-listGetAt(son_liste,sira)+1)>
            </cfif>
            <cfloop from="1" to="#listlen(adres_tek,'&')#" index="adr">
                <cfif listlen(ListGetAt(adres_tek,adr,'&'),'=') eq 2>
                    <cfif ListGetAt(ListGetAt(adres_tek,adr,'&'),2,'=') contains '�'>
                        <cfset kontrol2 = ListGetAt(ListGetAt(adres_tek,adr,'&'),2,'=')>
                        <cfset kontrol2 = Replace(kontrol2,'�','&','all')>
                        <cfset adres_tek = Replace(adres_tek,ListGetAt(ListGetAt(adres_tek,adr,'&'),2,'='),URLEncodedFormat(kontrol2))>
                    </cfif>
                </cfif>
            </cfloop>
            <cfset adres_tek = Replace(adres_tek,'�','&','all')>
            <form id="#attributes.name#_fav_xpage_" name="#attributes.name#_cf_pages_form_name#attributes.page_type#" method="post" action="<cfoutput>#actionAdress#</cfoutput>">
                <input type="hidden" name="maxrows" id="maxrows"  value="#attributes.maxrows#">
                <input type="hidden" name="page" id="page"  value="#attributes.page#">
                <cfloop from="1" to="#listlen(adres_tek,'&')#" index="adr">
                    <input type="hidden" name="#ListGetAt(ListGetAt(adres_tek,adr,'&'),1,'=')#" id="#ListGetAt(ListGetAt(adres_tek,adr,'&'),1,'=')#" value="<cfif listlen(ListGetAt(adres_tek,adr,'&'),'=') eq 2>#URLDecode(ListGetAt(ListGetAt(adres_tek,adr,'&'),2,'='))#</cfif>">
                </cfloop>
                <input type="hidden" name="js_sort_order" id="js_sort_order" value="<cfif isdefined("caller.attributes.js_sort_order")><cfoutput>#caller.attributes.js_sort_order#</cfoutput></cfif>"  />
                <input type="hidden" name="js_show_hide_order" id="js_show_hide_order" <cfif isdefined("caller.attributes.js_show_hide_order")>value="#caller.attributes.js_show_hide_order#"</cfif>/>
				<input type="hidden" name="js_column_order" id="js_column_order" value='<cfif isdefined("caller.attributes.js_column_order")><cfoutput>#caller.attributes.js_column_order#</cfoutput></cfif>'>                
            </form>
         <cfelse>
            <form id="#attributes.name#_fav_xpage_" name="#attributes.name#_cf_pages_form_name#attributes.page_type#" method="post" action="<cfoutput>#actionAdress#</cfoutput>">
                <input type="hidden" name="maxrows" id="maxrows"  value="#attributes.maxrows#">
                <input type="hidden" name="page" id="page"  value="#attributes.page#">
                <input type="hidden" name="js_sort_order" id="js_sort_order" value="<cfif isdefined("caller.attributes.js_sort_order")><cfoutput>#caller.attributes.js_sort_order#</cfoutput></cfif>" />
                <input type="hidden" name="js_show_hide_order" id="js_show_hide_order" <cfif isdefined("caller.attributes.js_show_hide_order")>value="#caller.attributes.js_show_hide_order#"</cfif>/>
				<input type="hidden" name="js_column_order" id='js_column_order' value='<cfif isdefined("caller.attributes.js_column_order")><cfoutput>#caller.attributes.js_column_order#</cfoutput></cfif>'>                
                <!--- url_str'de tanımlanmış tüm alanlar hidden olarak forma ekleniyor. --->
                <cfloop from="1" to="#listlen(attributes.adres,'&')#" index="adr">
                    <!--- <input type="hidden" name="#ListGetAt(ListGetAt(attributes.adres,adr,'&'),1,'=')#" value="<cfif listlen(ListGetAt(attributes.adres,adr,'&'),'=') eq 2>#ListGetAt(ListGetAt(attributes.adres,adr,'&'),2,'=')#</cfif>"> --->
                    <input type="hidden" name="#ListGetAt(ListGetAt(attributes.adres,adr,'&'),1,'=')#" id="#ListGetAt(ListGetAt(attributes.adres,adr,'&'),1,'=')#" value="<cfif listlen(ListGetAt(attributes.adres,adr,'&'),'=') eq 2>#URLDecode(ListGetAt(ListGetAt(attributes.adres,adr,'&'),2,'='))#</cfif>">
                </cfloop>
            </form>       
         </cfif>
    <!---
		<!--- seçilen page_type göre form adı oluşuyor, action kısmıda gelen adres bilgisinin ilk elemanı olarak alınıyor. --->
        <form id="#attributes.name#_fav_xpage_" name="#attributes.name#_cf_pages_form_name#attributes.page_type#" method="post" action="<cfoutput>#request.self#?fuseaction=#ListGetAt(ListGetAt(attributes.adres,1,'&'),1,'=')#</cfoutput>">
            <input type="hidden" name="maxrows"  value="#attributes.maxrows#">
            <input type="hidden" name="page" id="page"  value="#attributes.page#">
            <!--- url_str'de tanımlanmış tüm alanlar hidden olarak forma ekleniyor. --->
            <cfloop from="1" to="#listlen(attributes.adres,'&')#" index="adr">
                <!--- <input type="hidden" name="#ListGetAt(ListGetAt(attributes.adres,adr,'&'),1,'=')#" value="<cfif listlen(ListGetAt(attributes.adres,adr,'&'),'=') eq 2>#ListGetAt(ListGetAt(attributes.adres,adr,'&'),2,'=')#</cfif>"> --->
                <input type="hidden" name="#ListGetAt(ListGetAt(attributes.adres,adr,'&'),1,'=')#" value="<cfif listlen(ListGetAt(attributes.adres,adr,'&'),'=') eq 2>#URLDecode(ListGetAt(ListGetAt(attributes.adres,adr,'&'),2,'='))#</cfif>">
            </cfloop>
        </form>--->
   </cfoutput>
</div>
</div>
<script type="text/javascript">
    function <cfoutput>#attributes.name#</cfoutput>_go_page_(form_name,page_number)
    {
        <cfif attributes.isAjax is 1>
            openBoxDraggable( "<cfoutput>#attributes.adres#&maxrows=#attributes.maxrows#&page=</cfoutput>"+page_number, <cfoutput>#attributes.modal_id#</cfoutput> );
        <cfelse>
            eval("document."+ form_name).page.value = filterNum(page_number);
            eval("document."+ form_name).submit();
        </cfif>
    }
    function font_inc(inc){
        var elem = $('table');
        var def = parseInt(elem.find('td').css('font-size'));
        
        if(inc == 0){
            def = 12;
        }
        else{
            if(inc > 0){
                def = def+inc;
            }
        
            if(inc < 0){
                def = def + (inc);
            }
        }
        
        elem.find('*').css('font-size',def);
    }
</script>
