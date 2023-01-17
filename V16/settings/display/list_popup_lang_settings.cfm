<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.lang" default="eng">
<cfparam name="attributes.lang_2" default="#session.ep.language#">
<cfparam name="attributes.module_name" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.invoke" default=0>
<cfparam name="attributes.moreWord" default="0"><!---inputa birden fazla kelime düşürülecekse 1 gelir --->
<cfparam name="attributes.call_function" default="">
<cfparam name="attributes.is_equal" default="0">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.update_date_" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.alfabetik" default="">
<cfparam name="attributes.siralama" default="">

<cfinclude template="../query/get_language.cfm">
<!--- TR disinde dil tablosu olmayan sistemlerin kontrolu --->
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT 
	  	M.MODULE_ID, 
		M.MODULE_SHORT_NAME,
		ISNULL(Replace(SLT.ITEM_#UCASE(session.ep.language)#,'''',''),M.MODULE) AS MODULE
	FROM MODULES M
	JOIN SETUP_LANGUAGE_TR AS SLT ON M.MODULE_DICTIONARY_ID = SLT.DICTIONARY_ID
	WHERE 
		M.MODULE_SHORT_NAME <> '' 
	ORDER BY 
		MODULE
</cfquery>
<cfif isdefined("form_submit")>
	<cfset item_other = "ITEM_#UCASE(attributes.lang_2)#">
    <cfset item_lang = "ITEM_#UCASE(attributes.lang)#">	
	<cfquery name="GET_VAL" datasource="#DSN#">
		SELECT
			0 AS TYPE,
			SRC.*
		FROM
        	SETUP_LANGUAGE_TR SRC
		WHERE
			1=1
		<cfif isdefined("attributes.module_name") and len(attributes.module_name)>
			AND SRC.MODULE_ID = '#attributes.module_name#'
		</cfif>
		<cfif len(attributes.keyword)>
			<cfif isnumeric(attributes.keyword)>
				AND (SRC.ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#"> OR SRC.DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#"> )
			<cfelse>
				AND (SRC.#item_lang# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">)
			</cfif>
		</cfif>
		<cfif not isnumeric(attributes.keyword) and len(attributes.keyword) and attributes.is_equal eq 0>
			UNION
			SELECT
				1 AS TYPE,
				SRC.*
			FROM
				SETUP_LANGUAGE_TR SRC             
			WHERE
				1=1
			<cfif isdefined("attributes.module_name") and len(attributes.module_name)>
				AND SRC.MODULE_ID = '#attributes.module_name#'
			</cfif>
			<cfif len(attributes.keyword)>
				AND (SRC.#item_lang# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">)
				AND (SRC.#item_lang# != <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">)
			</cfif>
				
			<cfif len(attributes.keyword) gt 3>
				UNION 
				SELECT
					2 AS TYPE,
					SRC.*
				FROM
					SETUP_LANGUAGE_TR SRC
				WHERE
					1=1
				<cfif isdefined("attributes.module_name") and len(attributes.module_name)>
					AND SRC.MODULE_ID = '#attributes.module_name#'
				</cfif>
				<cfif len(attributes.keyword)>
					AND (SRC.#item_lang# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> )
					AND (SRC.#item_lang# NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">)
				</cfif>
			</cfif>
		</cfif>
			ORDER BY 
				<cfif isdefined("attributes.alfabetik") and attributes.siralama eq "alfabetik">
					SRC.#item_lang#
					<cfelseif isdefined("attributes.update_date_") and attributes.siralama eq "update_date_">
						UPDATE_DATE DESC
					<cfelse>
						RECORD_DATE DESC
					</cfif>
	</cfquery>
	<cfif get_val.recordcount eq 0 and attributes.is_equal eq 0>
		<cfquery name="GET_VAL" datasource="#DSN#">
			SELECT
				0 AS TYPE,
				SRC.*
			FROM
				SETUP_LANGUAGE_TR SRC
			WHERE
				1=1
			<cfif isdefined("attributes.module_name") and len(attributes.module_name)>
				AND SRC.MODULE_ID = '#attributes.module_name#'
			</cfif>
			<cfif len(attributes.keyword)>
				<cfif isnumeric(attributes.keyword)>
					AND (SRC.ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#"> OR SRC.DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#"> )
				<cfelse>
					AND (SRC.#item_other# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">)
				</cfif>
			</cfif>
			<cfif not isnumeric(attributes.keyword) and len(attributes.keyword)>
				UNION
				SELECT
					1 AS TYPE,
					SRC.*
				FROM
					SETUP_LANGUAGE_TR SRC             
				WHERE
					1=1
				<cfif isdefined("attributes.module_name") and len(attributes.module_name)>
					AND SRC.MODULE_ID = '#attributes.module_name#'
				</cfif>
				<cfif len(attributes.keyword)>
					AND (SRC.#item_other# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">)
					AND (SRC.#item_other# != <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">)
				</cfif>
					
				<cfif len(attributes.keyword) gt 3>
					UNION 
					SELECT
						2 AS TYPE,
						SRC.*
					FROM
						SETUP_LANGUAGE_TR SRC
					WHERE
						1=1
					<cfif isdefined("attributes.module_name") and len(attributes.module_name)>
						AND SRC.MODULE_ID = '#attributes.module_name#'
					</cfif>
					<cfif len(attributes.keyword)>
						AND (SRC.#item_other# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
						AND (SRC.#item_other# NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">)
					</cfif>
				</cfif>
			</cfif>
				ORDER BY
				    UPDATE_DATE DESC,
					DICTIONARY_ID DESC,
					TYPE,
					SRC.MODULE_ID,
					SRC.ITEM_ID,
					SRC.#item_other#
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_val.recordcount = 0>
</cfif>

<cfparam name="attributes.totalrecords" default="#get_val.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="dictionary" title="#getLang('','Sözlük',57932)#" scroll="1" collapsable="1" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form_search_dictionary" action="#request.self#?fuseaction=settings.popup_list_lang_settings" method="post">
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<cfoutput>
				<cfif isdefined('attributes.is_use_send')><input type="hidden" name="is_use_send" id="is_use_send" value="1"></cfif>
				<cfif isdefined("attributes.lang_item_id")><input type="hidden" name="lang_item_id" id="lang_item_id" value="#attributes.lang_item_id#"></cfif>
				<cfif isdefined("attributes.lang_item_name")><input type="hidden" name="lang_item_name" id="lang_item_name" value="#attributes.lang_item_name#"></cfif>
				<cfif isdefined("attributes.lang_dictionary_id")><input type="hidden" name="lang_dictionary_id" id="lang_dictionary_id" value="#attributes.lang_dictionary_id#"></cfif>
				<input type="hidden" name="invoke" value="<cfoutput>#attributes.invoke#</cfoutput>">
				<input type="hidden" name="moreWord" value="<cfoutput>#attributes.moreWord#</cfoutput>">
				<input type="hidden" name="call_function" value="<cfoutput>#attributes.call_function#</cfoutput>">
			</cfoutput>
			<cf_box_search more="0">
				<div class="form-group" id="keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group" id="module_name">
					<select name="module_name" id="module_name">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<option value="main"<cfif isdefined("attributes.module_name") and attributes.module_name eq "main">selected</cfif>>Main</option>
						<cfoutput query="get_modules">
							<cfif len(module_short_name)>
								<option value="#module_short_name#">#MODULE#</option>
							</cfif>
						</cfoutput>
						<option value="home">Home</option>				
						<option value="myhome">Myhome</option>
						<option value="objects2">Objects2</option>					   
					</select>
				</div>
				<div class="form-group medium" id="siralama">
					<select name="siralama" id="siralama">
						<option value=""><cf_get_lang dictionary_id='63721.En Son Eklenen'></option>
						<option value="alfabetik" <cfif isdefined("attributes.alfabetik") and attributes.siralama eq "alfabetik">selected</cfif>><cf_get_lang dictionary_id='35295.Alfabetik'></option>
						<option value="update_date_" <cfif isdefined("attributes.update_date_") and attributes.siralama eq "update_date_">selected</cfif>><cf_get_lang dictionary_id='63720.En Son Güncellenen'></option>
					
					</select>
				</div>
				<div class="form-group" id="lang">
					<select name="lang" id="lang">
						<cfoutput query="get_language">
							<option value="#language_short#" <cfif attributes.lang eq language_short> selected</cfif>>#language_set#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="lang">
					<select name="lang_2" id="lang_2">
						<cfoutput query="get_language">
							<option value="#language_short#" <cfif attributes.lang_2 eq language_short> selected</cfif>>#language_set#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group" id="equal">
					<label><input type="checkbox" name="is_equal" id="is_equal" <cfoutput>#attributes.is_equal eq 1 ? 'checked' : ''#</cfoutput> value="1"><cf_get_lang dictionary_id='62782.Sadece birebir eşleşenleri getir'></label>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_search_dictionary' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<div class="form-group">
					<cfif not listfindnocase(denied_pages,'settings.popup_add_new_text')>
						<a href="javascript://" class="ui-btn ui-btn-gray" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_add_new_text&popup_page=1');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</cfif>
				</div>	
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="70" nowrap="nowrap">Dictionary Id</th>
					<th width="300"><cf_get_lang dictionary_id='42302.Kelime'><cfoutput>(#ucase(attributes.lang)#)</cfoutput></th>
					<th width="300"><cf_get_lang dictionary_id ='42004.Karşılığı'><cfoutput>(#ucase(attributes.lang_2)#)</cfoutput></th>
					<th width="20" nowrap="nowrap" style="text-align:left;"><i class="icn-md fa fa-check-square-o" title="<cfoutput><cf_get_lang dictionary_id='54815.Özelleştirilmiş mi?'></cfoutput>"></i></th>
					<th width="120" class="text-center"><cf_get_lang dictionary_id='47990.Güncelleme Tarihi'></th> 
					<th width="20" class="text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
					<th width="20"><a href="javascript://"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='57476.Kopyala'>" alt="<cf_get_lang dictionary_id='57476.Kopyala'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_submit") or len(attributes.keyword)>	
					<cfif get_val.recordcount>
						<cfoutput query="get_val" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td>
									<a class="tableyazi" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_upd_lang_item&popup_page=1&strmodule=#module_id#&item_id=#item_id#&dictionary_id=#dictionary_id#&lang=TR');">
										#dictionary_id#
									</a>
								</td>
								<td>
									<cfif isdefined("attributes.is_use_send") and len(attributes.is_use_send)>
										<cfset name=getlang('','İsim',dictionary_id)>
										<a href="javascript:send_no('#module_id#','#item_id#','#name#','#dictionary_id#');">#evaluate("#item_lang#")#</a>
										<cfset item_=item>
									<cfelse>
										#evaluate("#item_lang#")#
										<cfset item_=evaluate("#item_lang#")>
									</cfif>
								</td>
								<td>#evaluate("#item_other#")#</td>
								<td style="text-align:left;"><cfif is_special eq 1><i class="icn-md fa fa-check-square-o"></i></cfif></td>
								<td class="text-center"><cfif len(UPDATE_DATE)>#dateformat(UPDATE_DATE,dateformat_style)#</cfif></td>
								<td class="text-center">
									<a class="tableyazi" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_upd_lang_item&popup_page=1&strmodule=#module_id#&item_id=#item_id#&dictionary_id=#dictionary_id#&lang=TR');">
										<i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
									</a>
								</td>
								<td><a href="javascript://" onclick="copy_language(#dictionary_id#,'#item_#')"><i class="fa fa-copy"></i></a></td>
							</tr>
						</cfoutput>
					<cfelse>
					<tr>
						<td height="20" colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
					</cfif>
				<cfelse>
					<tr>
						<td colspan="7"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "#attributes.fuseaction#">
			<cfif isdefined('attributes.form_submit')>
				<cfset adres = "#adres#&form_submit=1">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#"> 
			</cfif>
			<cfset adres = "#adres#&lang=#attributes.lang#&lang_2=#attributes.lang_2#">
			
			<cfif isdefined("attributes.module_name") and len(attributes.module_name)>
				<cfset adres = "#adres#&module_name=#attributes.module_name#">
			</cfif>
			<cfif isdefined("attributes.siralama") and len(attributes.siralama)>
				<cfset adres = "#adres#&siralama=#attributes.siralama#">
			</cfif>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$( "#keyword" ).focus();
	});
	<cfif isdefined('attributes.is_use_send')>
		function send_no(module,id,name,dictId)
		{
			<cfif attributes.invoke eq 1>
				<cfif not isdefined("attributes.draggable")>window.opener.</cfif>setLang(module, id, name, dictId);
			<cfelse>
				<cfif isdefined("attributes.lang_module")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#lang_module#</cfoutput>.value = module;
				</cfif>
				<cfif isdefined("attributes.lang_item_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#lang_item_id#</cfoutput>.value = id; 
				</cfif>
				<cfif attributes.moreWord eq 0 >
					<cfif isdefined("attributes.lang_dictionary_id")>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#lang_dictionary_id#</cfoutput>.value = dictId; 
					</cfif>
					<cfif isdefined("attributes.lang_item_name")>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#lang_item_name#</cfoutput>.value = name; 
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.lang_dictionary_id")>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#lang_dictionary_id#</cfoutput>.value += ',' + dictId;
					</cfif>
					<cfif isdefined("attributes.lang_item_name")>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#lang_item_name#</cfoutput>.value += ',' + name;
					</cfif>
				</cfif>
			</cfif>
			<cfif len(attributes.call_function)>
				<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.call_function#</cfoutput>;
			</cfif>
			<cfif attributes.moreWord eq 0 >
				<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
			</cfif>
			
		}
	
	</cfif>
	function copy_language(id,item){
		var copytext="<"+"cf_get_lang dictionary_id='"+id+"."+item+"'>";
		var $temp = $("<input>");
		$("body").append($temp);
		$temp.val(copytext).select();
		document.execCommand("copy");
		$temp.remove();
	}
	
</script>