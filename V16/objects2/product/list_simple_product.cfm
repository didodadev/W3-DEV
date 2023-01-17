<cfif isdefined("attributes.simple_product_maxrow") and isnumeric(attributes.simple_product_maxrow)>
	<cfset max_ = attributes.simple_product_maxrow>
<cfelse>
	<cfset max_ = 20>
</cfif>
<cfquery name="GET_SIMPLE_PRODUCT" datasource="#DSN3#" maxrows="#max_#">
	SELECT DISTINCT
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_DETAIL,
		P.PRODUCT_DETAIL2,
        P.USER_FRIENDLY_URL,
		S.STOCK_ID,
		PS.PRICE PRICE,
		PS.MONEY MONEY,
		PS.IS_KDV IS_KDV,
		PS.PRICE_KDV PRICE_KDV
	FROM
		PRODUCT P,
		STOCKS S,
		PRODUCT_CAT PC,
		#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY PCO,
		PRICE_STANDART PS,
		PRODUCT_UNIT PU
	WHERE
		PS.PRODUCT_ID = S.PRODUCT_ID AND
		PU.PRODUCT_UNIT_ID = PS.UNIT_ID AND
		PU.PRODUCT_ID = S.PRODUCT_ID AND
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID AND
		PS.PRICE > <cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
		PS.PRICESTANDART_STATUS = 1	AND
		PS.PURCHASESALES = 1 AND
		<cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		P.PRODUCT_CATID = PC.PRODUCT_CATID AND
		P.PRODUCT_STATUS = 1
		<cfif isdefined('attributes.is_product_cat_id') and len(attributes.is_product_cat_id)>
			AND PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_product_cat_id#">
		</cfif>
	ORDER BY
		P.PRODUCT_NAME ASC
</cfquery>

<cfquery name="GET_LANG_INFOS" datasource="#DSN#">
	SELECT 
    	UNIQUE_COLUMN_ID, 
        ITEM 
    FROM 
    	SETUP_LANGUAGE_INFO 
    WHERE 
    	TABLE_NAME = 'PRODUCT' AND 
        COLUMN_NAME = 'PRODUCT_NAME' AND 
        <cfif isDefined('session.pp.userid')>
        	LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
		<cfelse>
        	LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">        
        </cfif>
</cfquery>

<cfquery name="GET_SIMPLE_PRODUCT_MODUL" datasource="#DSN3#">
	SELECT
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_DETAIL,
        P.USER_FRIENDLY_URL,
		S.STOCK_ID
	FROM
		PRODUCT P,
		STOCKS S,
		PRODUCT_CAT PC,
		#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY PCO
	WHERE
		S.PRODUCT_ID = P.PRODUCT_ID AND
		<cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		P.PRODUCT_CATID = PC.PRODUCT_CATID AND
		P.PRODUCT_STATUS = 1
		<cfif isdefined('attributes.is_product_cat_id') and len(attributes.is_product_cat_id)>
			AND PC.PRODUCT_CATID = 7
		</cfif>
	ORDER BY
		P.PRODUCT_NAME ASC
</cfquery>

<cfset image_list = ''>
<cfoutput query="get_simple_product">
	<cfset image_list = listappend(image_list,get_simple_product.product_id,',')>
</cfoutput>	
<cfset image_list=listsort(image_list,"numeric","ASC",",")>

<cfif isdefined("attributes.is_simple_product_image") and attributes.is_simple_product_image eq 1 and listlen(image_list)>
	<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
		SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#image_list#) ORDER BY PRODUCT_ID
	</cfquery>
	<cfset image_list = listdeleteduplicates(valuelist(get_product_images.PRODUCT_ID,','),'numeric','ASC',',')>
	<cfset image_list = listsort(image_list,"numeric","ASC",",")>
</cfif>
<cfif isdefined('attributes.is_special_product_view') and attributes.is_special_product_view eq 0>
	<cfset my_this_row_ = 0>
	<table align="center" cellpadding="0" cellspacing="0" style="width:100%">
		<cfoutput query="get_simple_product">
			<cfset my_this_row_ = my_this_row_ + 1>
            <cfif my_this_row_ mod attributes.is_product_mode eq 1>
                <tr>
                    <td <cfif isdefined("attributes.is_simple_product_image") and attributes.is_simple_product_image eq 1> colspan="2"</cfif>><hr style="height:0.1px; color:##E6E6E6; width:98%;"/></td>
                </tr>
            </cfif>
        	<cfset my_width_ = 100/attributes.is_product_mode>
			<td style="vertical-align:top; width:#my_width_#%;">
				<table style="width:300px;">
				     <tr>
					     <cfif isdefined("attributes.is_simple_product_image") and attributes.is_simple_product_image eq 1>
							 <td style="vertical-align:top; width:70px;">
								 <cfif listfindnocase(image_list,product_id)>
                                    <cfquery name="GET_LANG_INFO" dbtype="query">
                                        SELECT * FROM GET_LANG_INFOS WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                                    </cfquery>
                                    <cfif get_lang_info.recordcount>
                                         <a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#get_lang_info.item#" class="chap_cont">
                                             <cf_get_server_file output_file="product/#get_product_images.path[listfind(image_list,product_id,',')]#" title="#get_lang_info.item#" alt="#get_lang_info.item#" output_server="#get_product_images.path_server_id[listfind(image_list,product_id,',')]#" output_type="0" image_width="80" image_height="80" image_link=0>
                                         </a>
                                     <cfelse>
                                         <a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#product_name#" class="chap_cont">
                                             <cf_get_server_file output_file="product/#get_product_images.path[listfind(image_list,product_id,',')]#" title="#product_name#" alt="#product_name#" output_server="#get_product_images.path_server_id[listfind(image_list,product_id,',')]#" output_type="0" image_width="80" image_height="80" image_link=0>
                                         </a>                                    
                                     </cfif>
								 </cfif>
							 </td>
						</cfif>
						<td style="vertical-align:top;">
                        	<cfif get_lang_info.recordcount>
                        		<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#get_lang_info.item#" class="chap_cont">#get_lang_info.item#</a>
							<cfelse>
                        		<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#product_name#" class="chap_cont">#product_name#</a>                            
                            </cfif>
  							<br/>
							<cfif isdefined('attributes.is_simple_detail2') and attributes.is_simple_detail2 eq 1>#product_detail2#<cfelse>#product_detail#</cfif><br /><br />
							<cfif isdefined('attributes.is_simple_product_price') and attributes.is_simple_product_price eq 1>
								<cf_get_lang_main no='672.Fiyat'> : #TLFormat(price)# #money# + KDV<br /><br />
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		<cfif my_this_row_ mod attributes.is_product_mode eq 0></tr></cfif>
		</cfoutput>
	</table>
<cfelse>
	<cfif isdefined("attributes.is_simple_product_image") and attributes.is_simple_product_image eq 1>
		<style type="text/css">
			#motioncontainer a img{ /*image border color*/
			border: 0px solid #ccc;
			}
			
			#motioncontainer a:hover img{ /*image border hover color*/
			border: 0px solid navy;
			}
			
			#motioncontainer a:hover{
			color: red; /* Dummy definition to overcome IE bug */
			}
		
		</style>
		<script type="text/javascript">
			var restarea=6 //1) width of the "neutral" area in the center of the gallery in px
			var maxspeed=3 //2) top scroll speed in pixels. Script auto creates a range from 0 to top speed.
		
			function enlargeimage(path, optWidth, optHeight){ //function to enlarge image. Change as desired.
				var actualWidth=typeof optWidth!="undefined" ? optWidth : "600px" //set 600px to default width
				var actualHeight=typeof optHeight!="undefined" ? optHeight : "75px" //set 500px to  default height
				var winattributes="width="+actualWidth+",height="+actualHeight+",resizable=yes"
				window.open(path,"", winattributes)
			}
		
			var iedom=document.all||document.getElementById
			var scrollspeed=0
			var movestate=""
			
			var actualwidth=''
			var cross_scroll_0, cross_scroll_1, ns_scroll
			var loadedyes=0
		
			function ietruebody(){
				return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
			}
		
		
			function getposOffset(what, offsettype){
				var totaloffset=(offsettype=="left")? what.offsetLeft: what.offsetTop;
				var parentEl=what.offsetParent;
				while (parentEl!=null){
				totaloffset=(offsettype=="left")? totaloffset+parentEl.offsetLeft : totaloffset+parentEl.offsetTop;
				parentEl=parentEl.offsetParent;
				}
				return totaloffset;
			}
		
			function moveleft(){
				if (iedom&&loadedyes){
				movestate="left"
				if (parseInt(cross_scroll_0.style.left)<(-actualwidth))
				cross_scroll_0.style.left=parseInt(cross_scroll_1.style.left)+actualwidth+"px"
				if (parseInt(cross_scroll_1.style.left)<(-actualwidth))
				cross_scroll_1.style.left=parseInt(cross_scroll_0.style.left)+actualwidth+"px"
				cross_scroll_0.style.left=parseInt(cross_scroll_0.style.left)-scrollspeed+"px"
				cross_scroll_1.style.left=parseInt(cross_scroll_1.style.left)-scrollspeed+"px"
				//showhidediv("visible")
				}
				lefttime=setTimeout("moveleft()",10)
			}
		
			function moveright(){
				if (iedom&&loadedyes){
				movestate="right"
				if (parseInt(cross_scroll_0.style.left)>0)
				cross_scroll_1.style.left=parseInt(cross_scroll_0.style.left)-actualwidth+"px"
				if (parseInt(cross_scroll_1.style.left)>0)
				cross_scroll_0.style.left=parseInt(cross_scroll_1.style.left)-actualwidth+"px"
				cross_scroll_0.style.left=parseInt(cross_scroll_0.style.left)+scrollspeed+"px"
				cross_scroll_1.style.left=parseInt(cross_scroll_1.style.left)+scrollspeed+"px"
				}
				righttime=setTimeout("moveright()",10)
			}
		
			function motionengine(e){
				var dsocx=(window.pageXOffset)? pageXOffset: ietruebody().scrollLeft;
				var dsocy=(window.pageYOffset)? pageYOffset : ietruebody().scrollTop;
				var curposy=window.event? event.clientX : e.clientX? e.clientX: ""
				curposy-=mainobjoffset-dsocx
				var leftbound=(menuwidth-restarea)/2
				var rightbound=(menuwidth+restarea)/2
				if (curposy>rightbound){
				scrollspeed=Math.floor((curposy-rightbound)/((menuwidth-restarea)/2) * maxspeed)
				if (window.righttime) clearTimeout(righttime)
				if (movestate!="left") moveleft()
				}
				else if (curposy<leftbound){
				scrollspeed=(leftbound-curposy)/((menuwidth-restarea)/2) * maxspeed
				if (window.lefttime) clearTimeout(lefttime)
				if (movestate!="right") moveright()
				}
				else
				scrollspeed=0
			}
		
			function contains_ns6(a, b) {
				while (b.parentNode)
				if ((b = b.parentNode) == a)
				return true;
				return false;
			}
			
			function stopmotion(e){
				if ((window.event&&!crossmain.contains(event.toElement)) || (e && e.currentTarget && e.currentTarget!= e.relatedTarget && !contains_ns6(e.currentTarget, e.relatedTarget))){
				if (window.lefttime) clearTimeout(lefttime)
				if (window.righttime) clearTimeout(righttime)
				movestate=""
				}
			}
		
			function fillup(){
				if (iedom){
				crossmain=document.getElementById? document.getElementById("motioncontainer") : document.all.motioncontainer
				menuwidth=parseInt(crossmain.style.width)
				mainobjoffset=getposOffset(crossmain, "left")
				cross_scroll_0=document.getElementById? document.getElementById("motiongallery_0") : document.all.motiongallery_0
				cross_scroll_1=document.createElement('div')
				cross_scroll_1.style.position='absolute'
				cross_scroll_1.style.whiteSpace='nowrap'
				extra=document.createElement('nobr')
				extra.innerHTML=document.all? document.all['trueContainer'].innerHTML : document.getElementById("trueContainer").innerHTML
				cross_scroll_1.appendChild(extra)
				crossmain.appendChild(cross_scroll_1)
				actualwidth=document.all? cross_scroll_0.offsetWidth : document.getElementById("trueContainer").offsetWidth
				cross_scroll_1.style.left=actualwidth+'px'
				crossmain.onmousemove=function(e){
				motionengine(e)
				}
				
				crossmain.onmouseout=function(e){
				stopmotion(e)
				}
				}
				loadedyes=1
			}
			window.onload=fillup
		</script>
		<table cellspacing="2" cellpadding="1" align="center" border="0" style="width:98%">
			<tr>
				<td style="width:10px; vertical-align:middle;"><strong>&laquo;</strong></td>
                <td valign="top">
				<br/>
					<div id="motioncontainer" style="position:relative;width:600px;height:75px;overflow:hidden;">
						<div id="motiongallery_0" style="position:absolute;left:5;top:0;width:600px;z-index:2;white-space: nowrap;">
							<nobr id="trueContainer">
								<cfoutput query="get_simple_product">
									<cfif listfindnocase(image_list,product_id)>
										&nbsp;&nbsp;
                                        <cfquery name="GET_LANG_INFO" dbtype="query">
                                            SELECT * FROM GET_LANG_INFOS WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                                        </cfquery>
                                        <cfif get_lang_info.recordcount>
                                        	<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#get_lang_info.item#" class="chap_cont">
                                                <cf_get_server_file output_file="product/#get_product_images.path[listfind(image_list,product_id,',')]#" title="#get_lang_info.item#" alt="#get_lang_info.item#" output_server="#get_product_images.path_server_id[listfind(image_list,product_id,',')]#" output_type="0" image_width="80" image_height="80" image_link=0>
                                            </a>
                                        <cfelse>
                                            <a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#product_name#" class="chap_cont">
                                                <cf_get_server_file output_file="product/#get_product_images.path[listfind(image_list,product_id,',')]#" title="#product_name#" alt="#product_name#" output_server="#get_product_images.path_server_id[listfind(image_list,product_id,',')]#" output_type="0" image_width="80" image_height="80" image_link=0>
                                            </a>
                                        </cfif>
									</cfif>
								</cfoutput>
							</nobr>
						</div>
					</div>
				</td>
				<td style="width:10px; vertical-align:middle;"><strong>&raquo;</strong></td>
			</tr>
		</table>
	</cfif>
	<table align="center" style="width:96%">
		<tr>
			<td class="headbold"><cf_get_lang no ='1537.Workcube Çözümler'></td>
		</tr>
		<tr>
			<td>
				<cfoutput query="get_simple_product">
                	<cfquery name="GET_LANG_INFO" dbtype="query">
                    	SELECT * FROM GET_LANG_INFOS WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                    </cfquery>
                    <cfif get_lang_info.recordcount>
						<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#get_lang_info.item#" class="chap_cont">#get_lang_info.item#</a> / 
					<cfelse>
						<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#product_name#" class="chap_cont">#product_name#</a> / 
					</cfif>
				</cfoutput>
			</td>
	    </tr>
	</table>
	<br/>
	<cfif attributes.is_show_product_modul eq 1>
		<table align="center" style="width:96%">
			<tr>
				<td class="headbold"><cf_get_lang no ='1376.Workcube Modüller'></td>
			</tr>
			<tr>
				<td>
					<cfoutput query="get_simple_product_modul">
                        <cfquery name="GET_LANG_INFO" dbtype="query">
                            SELECT * FROM GET_LANG_INFOS WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                        </cfquery>
                        <cfif get_lang_info.recordcount>
							<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#get_lang_info.item#" class="chap_cont">#get_lang_info.item#</a> /                         
                        <cfelse>                        
							<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" title="#product_name#" class="chap_cont">#product_name#</a> / 
						</cfif>
					</cfoutput>
				</td>
			</tr>
		</table>
		<br/>
	</cfif>
</cfif>

