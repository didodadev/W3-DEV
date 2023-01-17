<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date1" default="#dateformat(Now(),dateformat_style)#">
<cfparam name="attributes.class_style" default="">
<cfparam name="attributes.class_type" default="">
<cfparam name="attributes.pos_req_type_id" default="">
<cfparam name="attributes.pos_req_type" default="">
<cf_date tarih='attributes.date1'>
<cfset url_str = "">
<cfif isdefined("attributes.list_type") and len(attributes.list_type)>
	<cfset url_str = "#url_str#&list_type=#attributes.list_type#">
</cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif len("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len("attributes.date1")>
	<cfset url_str = "#url_str#&date1=#dateformat(attributes.date1,dateformat_style)#">
</cfif>
<cfif len("attributes.pos_req_type_id")>
	<cfset url_str = "#url_str#&pos_req_type_id=#attributes.pos_req_type_id#">
</cfif>
<cfif len("attributes.pos_req_type")>
	<cfset url_str = "#url_str#&pos_req_type=#attributes.pos_req_type#">
</cfif>
<cfif len("attributes.class_type")>
	<cfset url_str = "#url_str#&class_type=#attributes.class_type#">
</cfif>
<cfif len("attributes.class_style")>
	<cfset url_str = "#url_str#&class_style=#attributes.class_style#">
</cfif>

<cfset get_trains=cfc.GetTrains(pos_req_type_id:attributes.pos_req_type_id,date1:attributes.date1,KEYWORD:attributes.KEYWORD,pos_req_type:attributes.pos_req_type)>   
<cfset get_training_style=cfc.GetTrainingStyle()>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_trains.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.date1)><cfset attributes.date1 = dateformat(attributes.date1, dateformat_style)></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_classes" method="post" name="search_form">
			<cfif isdefined("attributes.list_type")><input type="hidden" name="list_type" id="list_type" value="<cfoutput>#attributes.list_type#</cfoutput>"></cfif>
			<cfif isdefined("attributes.field_id")><input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>"></cfif>
			<cfif isdefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>"></cfif>
			<cf_box_search>
					<div class="form-group" id="keyword">
						<div class="input-group x-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
							<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="255">
						</div>
					</div>	
					<div class="form-group">
						<div class="input-group x-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfsavecontent>
							<cfinput name="date1" type="text" value="#dateformat(attributes.date1,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#" required="yes">
							<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
						</div>
					</div>
					<div class="form-group x-3_5">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>          
			</cf_box_search>
			
			<cf_box_search_detail>
				<div class="form-group" id="pos_req_type">
					<div class="input-group x-16">
						<input type="hidden" name="pos_req_type_id" id="pos_req_type_id" value="<cfoutput>#attributes.pos_req_type_id#</cfoutput>">
						<input type="text" name="pos_req_type" id="pos_req_type" value="<cfoutput>#attributes.pos_req_type#</cfoutput>" style="width:200px">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_req&field_id=search_form.pos_req_type_id&field_name=search_form.pos_req_type','list');"></span>
					</div>
				</div>	
				<!---<td>
					<select name="class_type" style="width:200px">
						<option value=""><cf_get_lang no ='1755.Eğitim Tipi'></option>
						<option value="1" <cfif attributes.class_type eq 1>selected</cfif>><cf_get_lang no ='105.Standart Eğitim'></option>
						<option value="2" <cfif attributes.class_type eq 2>selected</cfif>><cf_get_lang no ='121.Teknik Gelişim Eğitimi'></option>
						<option value="3" <cfif attributes.class_type eq 3>selected</cfif>><cf_get_lang no ='108.Zorunlu Eğitim'></option>
						<option value="4" <cfif attributes.class_type eq 4>selected</cfif>><cf_get_lang no ='138.Yetkinlik Gelişim Eğitimi'></option>
					</select>
				</td>
				<td>
					<select name="class_style" style="width:200px">
						<option value=""><cf_get_lang no ='122.Eğitim Şekli'></option>
						<cfoutput query="GET_TRAINING_STYLE">
							<option value="#TRAINING_STYLE_ID#" <cfif attributes.class_style eq TRAINING_STYLE_ID>selected</cfif>>#TRAINING_STYLE#</option>
						</cfoutput>
					</select>
				</td>--->
			</cf_box_search_detail>
		</cfform>
	</cf_box>
</div>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='29912.Eğitimler'></cfsavecontent>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" uidrop="1" hide_table_column="1" resize="0" collapsable="0">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="200"><cf_get_lang dictionary_id='57419.Eğitim'></th>
					<th width="250"><cf_get_lang dictionary_id='33081.Amaç'></th>
					<th width="100"><cf_get_lang dictionary_id='57742.Tarih'></th>
				</tr>
		</thead>
		<tbody>
				<cfif get_trains.recordcount>
					<cfoutput query="get_trains" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>
								<!---<cfset class_ = URLEncodedFormat(CLASS_NAME)>--->
								<a href="javascript://" class="tableyazi"  onClick="add_class('#CLASS_ID#','#CLASS_NAME#')">#CLASS_NAME#</a></td>
							<td>
							<td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<cfif get_trains.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<!-- sil -->
		<table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
			<tr> 
				<td>
					<cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="#listgetat(attributes.fuseaction,1,'.')#.popup_list_classes#url_str#"> 
				</td>
				<!-- sil --><td style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
			</tr>
		</table>
	<!-- sil -->
</cfif>
<script type="text/javascript">
	function add_class(class_id,class_name)
	{
		<cfif isdefined("attributes.field_id")>
		opener.<cfoutput>#field_id#</cfoutput>.value = class_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#field_name#</cfoutput>.value = class_name;
		</cfif>
		window.close();
	}
</script>
