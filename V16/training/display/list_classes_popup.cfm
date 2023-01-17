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
<cfquery name="get_trains" datasource="#dsn#">
	SELECT 
		*
	FROM
		TRAINING_CLASS TC
	WHERE
		<cfif isdefined('attributes.list_type') and attributes.list_type eq 1 or len(attributes.pos_req_type_id) and len(attributes.pos_req_type)>
			TC.CLASS_ID IN 
			(
				SELECT DISTINCT 
					TCS.CLASS_ID
				FROM 
					RELATION_SEGMENT_TRAINING RST,
					TRAINING_CLASS_SECTIONS TCS
				WHERE
					RST.RELATION_FIELD_ID=TCS.TRAIN_ID
					AND RST.RELATION_ACTION=9
				<cfif len(attributes.pos_req_type_id) and len(attributes.pos_req_type)>
					AND RST.RELATION_ACTION_ID = #attributes.pos_req_type_id#
				</cfif>
			)
		<cfelse>
			1=1
		</cfif>
		<cfif len(attributes.date1)>
			AND TC.START_DATE >= #attributes.date1#
		</cfif>
		<cfif len(attributes.KEYWORD)>
		AND
		(
			CLASS_NAME LIKE '%#attributes.KEYWORD#%'
		OR
			CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
		)
		</cfif>
		<cfif len(attributes.class_style)>
			AND TC.CLASS_ID IN (SELECT
								TC.CLASS_ID
							FROM
								TRAINING_CLASS_SECTIONS TC,
								TRAINING TT
							WHERE
								TT.TRAIN_ID = TC.TRAIN_ID AND
								TT.TRAINING_TYPE=#attributes.class_style#
							)
		</cfif>
		<cfif len(attributes.class_type)>
			AND TC.CLASS_ID IN (SELECT
								TC.CLASS_ID
							FROM
								TRAINING_CLASS_SECTIONS TC,
								TRAINING TT
							WHERE
								TT.TRAIN_ID = TC.TRAIN_ID AND
								TT.TRAINING_TYPE=#attributes.class_type#
							)
		</cfif>
</cfquery>
<cfquery name="GET_TRAINING_STYLE" datasource="#dsn#">
	SELECT 
    	* 
    FROM 
    	SETUP_TRAINING_STYLE
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_trains.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_medium_list_search title="#getLang('main',2115)#">
	<cfform action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_classes" method="post" name="search_form">
		<cfif isdefined("attributes.list_type")><input type="hidden" name="list_type" id="list_type" value="<cfoutput>#attributes.list_type#</cfoutput>"></cfif>
        <cfif isdefined("attributes.field_id")><input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>"></cfif>
        <cfif isdefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>"></cfif>
        <cf_medium_list_search_area>
			<table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'>:</td>
                    <td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255"></td>
                    <td>
                        <cfinput name="date1" type="text" value="#dateformat(attributes.date1,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="Tarih Girmelisiniz !" required="yes">
                        <cf_wrk_date_image date_field="date1">
                        <cf_get_lang no ='119. tarihinden itibaren'>
                    </td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>          
               </tr>
		   </table>
       </cf_medium_list_search_area>
       <cf_medium_list_search_detail_area>
		 <table>
				<tr>
					<td>
						<input type="hidden" name="pos_req_type_id" id="pos_req_type_id" value="<cfoutput>#attributes.pos_req_type_id#</cfoutput>">
						<input type="text" name="pos_req_type" id="pos_req_type" value="<cfoutput>#attributes.pos_req_type#</cfoutput>" style="width:200px">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_req&field_id=search_form.pos_req_type_id&field_name=search_form.pos_req_type','list');"><img src="../images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
					<td>
						<select name="class_type" id="class_type" style="width:200px">
							<option value=""><cf_get_lang no ='120.Eğitim Tipi'></option>
							<option value="1" <cfif attributes.class_type eq 1>selected</cfif>><cf_get_lang no ='105.Standart Eğitim'></option>
							<option value="2" <cfif attributes.class_type eq 2>selected</cfif>><cf_get_lang no ='121.Teknik Gelişim Eğitimi'></option>
							<option value="3" <cfif attributes.class_type eq 3>selected</cfif>><cf_get_lang no ='108.Zorunlu Eğitim'></option>
							<option value="4" <cfif attributes.class_type eq 4>selected</cfif>><cf_get_lang no ='138.Yetkinlik Gelişim Eğitimi'></option>
						</select>
					</td>
					<td>
						<select name="class_style" id="class_style" style="width:200px">
							<option value=""><cf_get_lang no ='122.Eğitim Şekli'></option>
							<cfoutput query="GET_TRAINING_STYLE">
								<option value="#TRAINING_STYLE_ID#" <cfif attributes.class_style eq TRAINING_STYLE_ID>selected</cfif>>#TRAINING_STYLE#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
			</table>
	   </cf_medium_list_search_detail_area>
	</cfform>
</cf_medium_list_search>
<cf_big_list>
	<thead>
        <tr>
            <th width="25"><cf_get_lang_main no ='75.No'></th>
            <th width="200"><cf_get_lang_main no ='7.Eğitim'></th>
            <th width="250"><cf_get_lang no='7.Amaç'></th>
            <th width="100"><cf_get_lang_main no='330.Tarih'></th>
        </tr>
   </thead>
   <tbody>
		<cfif get_trains.recordcount>
            <cfoutput query="get_trains" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td>
                        <cfset class_ = URLEncodedFormat(CLASS_NAME)>
                        <a href="javascript://" class="tableyazi"  onClick="add_class('#CLASS_ID#','#class_#')">#CLASS_NAME#</a></td>
                    <td>
                    <td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfif get_trains.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<!-- sil -->
		<table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
			<tr> 
				<td>
					<cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="training.popup_list_classes#url_str#"> 
				</td>
				<!-- sil --><td align="right" style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
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
		window.opener.get_class_name(class_id);
		window.close();
	}
</script>
