<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.submitted")>
	<cfinclude template="../query/get_address.cfm">
<cfelse>
	<cfset get_address.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_address.recordcount#">
<cfparam name="attributes.modal_id" default="">
<cf_box  title="#getLang('','Etiket Şablonları','42153')#" scroll="1" collapsable="1" resize="1"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#" uidrop="1">
	<cfif not isdefined("attributes.print")>
		<br />
		<cfquery name="GET_STICKER" datasource="#dsn#">
			SELECT STICKER_ID, STICKER_NAME FROM SETUP_STICKER
		</cfquery>
		<!--- FBS 20120905 kaldirildi, yerine custom tag eklenecek <cfinclude template="../display/list_labels.cfm"> --->
		<cfsavecontent variable="etiket"><cf_get_lang dictionary_id='34683.Etiket'></cfsavecontent>
		<cfform name="formetiket" method="post" action="#request.self#?fuseaction=correspondence.popup_label">
			<input type="hidden" name="submitted" id="submitted" value="">
			<!-- sil --><cf_box_search more="0" >
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','filtre','57460')#">
				</div>
				<div class="form-group" id="item-member_type">
					<select name="member_type" id="member_type">
						<option value="2" <cfif isDefined('attributes.member_type') and attributes.member_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif isDefined('attributes.member_type') and attributes.member_type eq 1>selected</cfif>><cf_get_lang dictionary_id='30370.Çalışanlar'></option>
						<option value="0" <cfif isDefined('attributes.member_type') and attributes.member_type eq 0>selected</cfif>><cf_get_lang dictionary_id='29531.Şirketler'></option>
					</select>
				</div>
				<div class="form-group" id="item-sticker">
					<select name="sticker" id="sticker" onChange="formetiket.submit();loadPopupBox('formetiket' , #attributes.modal_id#)" >
						<option value="" selected><cf_get_lang dictionary_id='51246.Etiket Şablonu Seçiniz'></option>
						<cfoutput query="GET_STICKER">
							<option value="#sticker_id#" <cfif isDefined("attributes.sticker") AND attributes.sticker EQ sticker_id>SELECTED</cfif>>#sticker_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('formetiket' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<!--- <div class="form-group">
					<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=correspondence.popup_label&print=true#page_code#','page')" class="ui-btn ui-btn-gray2"><i class="fa fa-print"></i></a></cfoutput>
				</div> --->
			</cf_box_search><!-- sil -->
		</cfform>
		<cfelse>
			<script type="text/javascript">
				function waitfor()
				{
					<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
				}	
					setTimeout("waitfor()",5000);
					window.print();
			</script>
		</cfif>
		<cfif isDefined("attributes.sticker") and len(attributes.sticker)>
			<cfquery name="get_sticker_detail" datasource="#dsn#">
				SELECT * FROM SETUP_STICKER WHERE STICKER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sticker#">
			</cfquery>
		</cfif>
		<cfif get_address.recordcount>
			<cfset cont=0>
			<cfset cont1=0>
			<cfif isDefined("attributes.sticker") and len(attributes.sticker)>
				<cfif not isdefined("attributes.print")>
					<cfparam name="attributes.maxrows" default="#get_sticker_detail.row_number*get_sticker_detail.column_number#">
					<cfparam name="attributes.mode" default="#attributes.maxrows#">
				<cfelse>
					<cfparam name="attributes.maxrows" default="#get_address.recordcount#">
					<cfparam name="attributes.mode" default="#get_sticker_detail.row_number*get_sticker_detail.column_number#">
				</cfif>
				<cf_flat_list >  
					<thead>
						<th><cf_get_lang dictionary_id='57574.Şirket'>/<cf_get_lang dictionary_id='30368.Çalışan'></th>
					
					</thead>
					<tbody>

						<cfparam name="attributes.page" default="1">		
						<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
						<cfoutput query="get_address" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						
						<cfif (get_sticker_detail.row_number*get_sticker_detail.column_number) neq currentrow>
							<td >
							<cfif len(AB_COMPANY)>
								<STRONG>#AB_COMPANY#</STRONG><br/>
							</cfif>
							<cfif (len(get_address.partner_id) and (get_sticker_detail.partner eq 1 )) or not len(get_address.partner_id)>#AB_NAME# #AB_SURNAME#<br/></cfif>
							#AB_ADDRESS# #AB_POSTCODE# #AB_COUNTY# #AB_CITY# #AB_COUNTRY# </td>
						<cfelse>
							<td >
							<cfif len(AB_COMPANY)>
								<STRONG>#AB_COMPANY#</STRONG><br/>
							</cfif>
							<cfif (len(get_address.partner_id) and get_sticker_detail.partner eq 1) or not len(get_address.partner_id)>#AB_NAME# #AB_SURNAME#<br/></cfif>
							#AB_ADDRESS# #AB_POSTCODE# #AB_COUNTY# #AB_CITY# #AB_COUNTRY#
							</td>
							<cfset cont=cont+1>
						</cfif>
						<cfif (currentrow mod GET_STICKER_DETAIL.COLUMN_NUMBER) EQ 0>
							<cfset cont1=cont1+1>
							<cfset cont=cont+1>
						</cfif>
					</tbody>
					</cfoutput>
				</cf_flat_list>
			<cfelse>
				<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
				<cfparam name="attributes.page" default=1>
				<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
				<cf_flat_list >  
					<thead>
						<th><cf_get_lang dictionary_id='57574.Şirket'>/<cf_get_lang dictionary_id='30368.Çalışan'></th> 
						<th><cf_get_lang dictionary_id='57574.Şirket'>/<cf_get_lang dictionary_id='30368.Çalışan'></th>
					
					</thead>
					<tbody>
						<cfoutput query="get_address" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<cfif (currentrow mod 2)>
								<td><strong>#AB_COMPANY#</strong><br/>
									#AB_NAME# #AB_SURNAME#<br/>
									#AB_ADDRESS# #AB_POSTCODE# #AB_COUNTY# #AB_CITY# #AB_COUNTRY# </td>
								<td>
									<cfif get_address.recordcount neq currentrow>
										<strong>#AB_COMPANY[currentrow+1]#</strong><br/>
										#AB_NAME[currentrow+1]# #AB_SURNAME[currentrow+1]#<br/>
										#AB_ADDRESS[currentrow+1]# #AB_POSTCODE[currentrow+1]# #AB_COUNTY[currentrow+1]# #AB_CITY[currentrow+1]# #AB_COUNTRY[currentrow+1]#
									</cfif>
								</td>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
				</cf_flat_list>
			</cfif>
		</cfif>
		<cfset url_str=''>
		<cfif not isdefined("attributes.print")>
			<cfif attributes.totalrecords>

				<cfset url_str = "&submitted=1">
				<cfparam name="attributes.adres" default="correspondence.label">
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
					<cfset url_str="#url_str#&keyword=#attributes.keyword#">
				</cfif>
				<cfif isdefined("attributes.sticker") and len(attributes.sticker)>
					<cfset url_str="#url_str#&sticker=#attributes.sticker#">
				</cfif>
				<cfif isdefined("attributes.member_type")>
					<cfset url_str="#url_str#&member_type=#attributes.member_type#">
				</cfif>
				<cf_paging  page="#attributes.page#"
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="correspondence.popup_label#url_str#"
						isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
				
			</cfif>
	</cfif>
</cf_box>

