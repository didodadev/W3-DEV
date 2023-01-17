<cfsetting showdebugoutput="no">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'><!--- Objects2 de kullanildigi icin base yapildi degistirmeyin --->
<cfparam name="attributes.updPageUrl" default="">
<cfparam name="attributes.addPageUrl" default="">
<cfparam name="attributes.addPageUrl" default="">
<cfparam name="attributes.line_info" default="">
<cfparam name="attributes.keyword" default="-1">
<cfparam name="attributes.other_parameters" default="">
<cfparam name="department_ids" default="">
<cfparam name="attributes.returnQueryValue2" default="">
<cfparam name="attributes.is_department" default="">
<cfparam name="attributes.single_line" default="">
<cfparam name="attributes.alfabetik" default="">
<cfparam name="attributes.operation_code" default="">
<cfparam name="attributes.siralama" default="">
<cfset x=0>

<cfif attributes.COMPENENT_NAME is 'get_department_location' and attributes.keyword eq 0>
	<cfset attributes.keyword = "">
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	CreateCompenent = CreateObject("component","V16/workdata/#attributes.compenent_name#");
	queryResult = CreateCompenent.getCompenentFunction(keyword:attributes.keyword,other_parameters:attributes.other_parameters,alfabetik:attributes.alfabetik,operation_code:attributes.operation_code,siralama:attributes.siralama);
	counter = 0;
</cfscript>
<cfset attributes.boxwidth=attributes.boxwidth-10>
<cfif attributes.listPage neq 1>
	<cfset scrl_ ='overflow:auto;height:#attributes.boxheight#px;width:#attributes.boxwidth#px;'>
<cfelse>
	<cfset scrl_='width=100%;height:100%;'>
</cfif>
<cfif isdefined('attributes.title')><!--- Şimdilik yazıyorum çalışanların sayfası çakmasın diye.sonrasında kaldırılacak... --->
	<cfset attributes.boxTitle = attributes.title>
</cfif>
<cfset kontrol = 1>
<cfset url_string = "">
<cfparam name="attributes.id" default="wrkdepartmentlocation_#round(rand()*10000000)#">
<cfparam name="attributes.totalrecords" default="#queryResult.recordcount#">
<!--- body_style="<cfif attributes.listPage neq 1>#scrl_#</cfif>"--->
<cf_box title="#attributes.boxTitle#" popup_box="1">
	<cfform name="search_brand" action="#request.self#?fuseaction=objects.popup_wrk_list_comp#url_string#" method="post">
		<cf_box_search more="0">
			<div class="form-group" id="form_submitted">
				<cfinput type="hidden" name="form_submitted" value="1">
				<cfinput type="hidden" name="compenent_name" value="#attributes.compenent_name#">
				<cfinput type="hidden" name="BOXWIDTH" value="#attributes.BOXWIDTH#">
				<cfinput type="hidden" name="updPageUrl" value="#attributes.updPageUrl#">
				<cfinput type="hidden" name="addPageUrl" value="#attributes.addPageUrl#">
				<cfinput type="hidden" name="single_line" value="#attributes.single_line#">
				<cfinput type="hidden" name="listPage" value="#attributes.listPage#">
				<cfinput type="hidden" name="returnQueryValue" value="#attributes.returnQueryValue#">
				<cfinput type="hidden" name="returnQueryValue2" value="#attributes.returnQueryValue2#">
				<cfinput type="hidden" name="BOXHEIGHT" value="#attributes.BOXHEIGHT#">
				<cfinput type="hidden" name="COLUMNLIST" value="#attributes.COLUMNLIST#">
				<cfinput type="hidden" name="FIELDID" value="#attributes.FIELDID#">
				<cfinput type="hidden" name="FIELDNAME" value="#attributes.FIELDNAME#">
				<cfinput type="hidden" name="title" value="#attributes.title#">
				<cfinput type="hidden" name="other_parameters" value="#attributes.other_parameters#">
				<cfinput type="hidden" name="is_department" value="#attributes.is_department#">
				<cfinput type="hidden" name="line_info" value="#attributes.line_info#">
				<cfinput type="hidden" name="returnInputValue" value="#attributes.returnInputValue#">
				<cfinput type="Text" maxlength="50" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" name="keyword">
			</div>
			<div class="form-group medium" id="siralama">
				<select name="siralama" id="siralama">
					<option value=""><cf_get_lang dictionary_id='58924.Sıralama'></option>
					<option value="alfabetik" <cfif isdefined("attributes.alfabetik") and attributes.siralama eq "alfabetik">selected</cfif>><cf_get_lang dictionary_id='35295.Alfabetik'></option>
					<option value="operation_code" <cfif isdefined("attributes.operation_code") and attributes.siralama eq "operation_code">selected</cfif>><cf_get_lang dictionary_id='48886.İşlem Kodu'></option>
				</select>
			</div>
			<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı!',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_brand' , #attributes.modal_id#)"),DE(""))#">
				<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			</div>			
		</cf_box_search>
	</cfform>
	<cf_flat_list>
		<cfif queryResult.recordcount>
			<cfset lastPage_ = (attributes.totalrecords \ attributes.maxrows) + iif(attributes.totalrecords mod attributes.maxrows,1,0) >		
			<div id="<cfoutput>#attributes.id#</cfoutput>">
	
				<!--- <cfif not (isdefined("attributes.is_parameter") and len(attributes.is_parameter))>
					<h1>
						<cfloop list="#attributes.COLUMNLIST#" index="column_and_head">
							<cfoutput>#ListGetAt(column_and_head,2,'@')#</cfoutput>
						</cfloop>
					</h1>
				</cfif>
				<cfif attributes.listPage eq 1><!--- Liste sayfası ise --->
					<a href="<cfoutput>#request.self#?fuseaction=#attributes.addPageUrl#</cfoutput>"><img src="../images/plus_square.gif" border="0"></a>
				</cfif> --->
	
				<ul class="ui-list">
				<cfoutput query="queryResult" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif attributes.listPage neq 1>
							<cfset returnParameter = ''>
							<cfloop list="#attributes.returnQueryValue#" index="qrv">
								<cfset returnParameter = ListAppend(returnParameter,Evaluate("#qrv#"),'█')>
							</cfloop>
							<cfscript>
								returnParameter = replace(returnParameter,"'"," ","all");
								returnParameter = replace(returnParameter,";"," ","all");
								returnParameter = replace(returnParameter,'"','','all');
							</cfscript>
							<cfset returnParameter2 = ''>
							<cfif isdefined("attributes.returnQueryValue2") and len(attributes.returnQueryValue2)>
								<cfloop list="#attributes.returnQueryValue2#" index="qrv">
									<cfset returnParameter2 = ListAppend(returnParameter2,Evaluate("#qrv#"),',')>
								</cfloop>
								<cfscript>
									returnParameter2 = replace(returnParameter2,"'"," ","all");
									returnParameter2 = replace(returnParameter2,";"," ","all");
									returnParameter2 = replace(returnParameter2,'"','','all');
								</cfscript>
							</cfif>
						</cfif>
						<cfset counter = counter +1>
						<cfif isdefined("attributes.is_department") and attributes.is_department eq 1>
							<cfif not listfind(department_ids,department_id)>
								<li <cfif attributes.listPage neq 1> onClick="send_value2_#attributes.line_info#('#returnParameter2#');"</cfif>>
									<a href="javascript://">
										<div class="ui-list-left">
											<cfset department_ids = listappend(department_ids,department_id)>
											<span <cfif DEPARTMENT_STATUS eq 0> class=""</cfif>>#department_head#</span>
										</div>
									</a>
								</li>
							</cfif>
						</cfif>
						<li <cfif attributes.listPage neq 1> onClick="send_value_#attributes.line_info#('#returnParameter#');"</cfif>>
							<a href="javascript://">
								<div class="ui-list-left">
									<cfloop list="#attributes.COLUMNLIST#" index="column_and_head">
										<cfscript>
											columnValue = replace(wrk_eval('#ListGetAt(column_and_head,1,'@')#'),"'"," ","all");
											columnValue = replace(columnValue,";"," ","all");
											columnValue = replace(columnValue,'"','','all');
										</cfscript>
										<!--- <span class="<cfif isdefined("STATUS") and STATUS eq 0></cfif> <cfif not isdefined("attributes.single_line")>department_area_cl<cfelse>department_area</cfif>">
											#currentrow# - #columnValue#
										</span> --->
										#currentrow# - #columnValue#
									</cfloop>
								</div>
							</a>
							<cfif attributes.listPage eq 1>
								<div class="ui-list-right">
									<a href="#request.self#?fuseaction=#ListGetAt(attributes.updPageUrl,1,'█')#&#ListGetAt(attributes.updPageUrl,2,'█')#=5"><i class="fa fa-pencil"></i></a><!---sayfa no ve kayıt adı--->
								</div>	
							</cfif>	
						</li>    
				</cfoutput>
			</ul>
			</div>
			<cfif queryResult.recordcount gt attributes.maxrows>
				<cfif isDefined("attributes.updPageUrl") and len(attributes.updPageUrl)>
					<cfset url_string = '#url_string#&updPageUrl=#attributes.updPageUrl#'>
				</cfif>	
				<cfif isDefined("attributes.addPageUrl") and len(attributes.addPageUrl)>
					<cfset url_string = '#url_string#&addPageUrl=#attributes.addPageUrl#'>
				</cfif>	
				<cfif isDefined("attributes.single_line") and len(attributes.single_line)>
					<cfset url_string = '#url_string#&single_line=#attributes.single_line#'>
				</cfif>	
				<cfif isDefined("attributes.listPage") and len(attributes.listPage)>
					<cfset url_string = '#url_string#&listPage=#attributes.listPage#'>
				</cfif>	
				<cfif isDefined("attributes.returnQueryValue") and len(attributes.returnQueryValue)>
					<cfset url_string = '#url_string#&returnQueryValue=#attributes.returnQueryValue#'>
				</cfif>	
				<cfif isDefined("attributes.returnQueryValue2") and len(attributes.returnQueryValue2)>
					<cfset url_string = '#url_string#&returnQueryValue2=#attributes.returnQueryValue2#'>
				</cfif>	
				<cfif isDefined("attributes.BOXWIDTH") and len(attributes.BOXWIDTH)>
					<cfset url_string = '#url_string#&BOXWIDTH=#attributes.BOXWIDTH#'>
				</cfif>
				<cfif isDefined("attributes.BOXHEIGHT") and len(attributes.BOXHEIGHT)>
					<cfset url_string = '#url_string#&BOXHEIGHT=#attributes.BOXHEIGHT#'>
				</cfif>	
				<cfif isDefined("attributes.COLUMNLIST") and len(attributes.COLUMNLIST)>
					<cfset url_string = '#url_string#&COLUMNLIST=#attributes.COLUMNLIST#'>
				</cfif>	
				<cfif isDefined("attributes.compenent_name") and len(attributes.compenent_name)>
					<cfset url_string = '#url_string#&compenent_name=#attributes.COMPENENT_NAME#'>
				</cfif>	
				<cfif isDefined("attributes.FIELDID") and len(attributes.FIELDID)>
					<cfset url_string = '#url_string#&FIELDID=#attributes.FIELDID#'>
				</cfif>
				<cfif isDefined("attributes.FIELDNAME") and len(attributes.FIELDNAME)>
					<cfset url_string = '#url_string#&FIELDNAME=#attributes.FIELDNAME#'>
				</cfif>	
				<cfif isDefined("attributes.title") and len(attributes.title)>
					<cfset url_string = '#url_string#&title=#attributes.title#'>
				</cfif>
				<cfif isDefined("attributes.keyword")>
					<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
				</cfif>	
				<cfif isDefined("attributes.other_parameters") and len(attributes.other_parameters)>
					<cfset url_string = '#url_string#&other_parameters=#attributes.other_parameters#'>
				</cfif>	
				<cfif isDefined("attributes.is_department") and len(attributes.is_department)>
					<cfset url_string = '#url_string#&is_department=#attributes.is_department#'>
				</cfif>	
				<cfif isDefined("attributes.line_info") and len(attributes.line_info)>
					<cfset url_string = '#url_string#&line_info=#attributes.line_info#'>
				</cfif>	
				<cfif isDefined("attributes.returnInputValue") and len(attributes.returnInputValue)>
					<cfset url_string = '#url_string#&returnInputValue=#attributes.returnInputValue#'>
				</cfif>	
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="objects.popup_wrk_list_comp#url_string#" 
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfelseif isdefined("attributes.control_field_id")>
				<table>
					<tr>
						<td><cf_get_lang dictionary_id='29948.Bu modele ait marka bulunamadi.'></td>
					</tr>
				</table>
			</cfif>
		</cfif>
	</cf_flat_list>
	
</cf_box>
<script type="text/javascript">
	<cfoutput>
		<cfif attributes.listPage neq 1><!---Liste Sayfası Değil ise.. ---->
			function send_value_#attributes.line_info#(values){
				var value_length = list_len(values,'█');
				for(vli=1;vli<=value_length;vli++){
					var value=list_getat(values,vli,'█');
					var inputObject = list_getat('#attributes.returnInputValue#',vli,',');
					if(document.getElementById(inputObject))
						document.getElementById(inputObject).value = value;
				}
				closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
			}
			function send_value2_#attributes.line_info#(values)
			{
					var value2=list_getat(values,2,',');
					var value1=list_getat(values,1,',');
					var inputObject = list_getat('#attributes.returnInputValue#',2,',');
					var inputObject2 = list_getat('#attributes.returnInputValue#',3,',');
					var inputObject3 = list_getat('#attributes.returnInputValue#',1,',');
					if(document.getElementById(inputObject))
						document.getElementById(inputObject).value = value2;
					if(document.getElementById(inputObject2))
						document.getElementById(inputObject2).value = value1;
					if(document.getElementById(inputObject3))
						document.getElementById(inputObject3).value = '';
				
			}
		</cfif>
	</cfoutput>
	<!---(function($){
			$(document).ready(function(){
				$("#<cfoutput>#attributes.id#</cfoutput>").mCustomScrollbar({
					autoHideScrollbar:true,
					theme:"light-thin"});
			});
		})(); bu kod hata veriyordu gereksiz bulduğum için kapattım.Gerekli gören varsa açabilir. --glshtan--->
</script>