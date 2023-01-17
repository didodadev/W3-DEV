<cfquery name="get_offtime_cat" datasource="#dsn#">
	SELECT
        OFFTIMECAT,
        OFFTIMECAT_ID
	FROM 
        SETUP_OFFTIME
	WHERE
		ISNULL(SETUP_OFFTIME.IS_PUANTAJ_OFF,0) <> 1
        AND IS_ACTIVE = 1
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)> 
            AND OFFTIMECAT LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
        </cfif>
    ORDER BY 
        OFFTIMECAT
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_offtime_cat.recordcount#">
<cfparam name="attributes.row_id_" default="">
<cfparam name="attributes.type" default="1">
<cfparam name="attributes.field_name" default="">
<cfparam name="attributes.field_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.from_xml")>
	<cfset url_str = "#url_str#&from_xml=#attributes.from_xml#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cf_box title="#getLang('','İzin ve Mazeret Kategorileri','42119')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=ehesap.popup_list_offtime_cat#url_str#" method="post" name="filter_offtime_cat">
		<cf_box_search>
			<div class="form-group">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre','57460')#">
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('filter_offtime_cat' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>	
	</cfform>
	<cf_grid_list>
		<thead>		
			<tr>
				<th><cf_get_lang dictionary_id='57897.Adı'></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_offtime_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>						
                    <td><a href="javascript://" onClick="add_offtime_cat('#OFFTIMECAT_ID#');">#OFFTIMECAT#</a></td>
				</tr>
			</cfoutput>
			<cfif not get_offtime_cat.recordcount>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="ehesap.popup_list_kesinti#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>


<script>
	<cfif isdefined("attributes.from_xml")>
		function add_offtime_cat(offtimecat_id)
		{
			opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = offtimecat_id;
            window.close();	
		}
	</cfif>
</script>