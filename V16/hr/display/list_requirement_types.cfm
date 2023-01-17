<cfparam name="attributes.keyword" default="">
<cfquery name="get_pos_req_types" datasource="#dsn#">
  SELECT 
    #dsn#.Get_Dynamic_Language(REQ_TYPE_ID,'#session.ep.language#','POSITION_REQ_TYPE','REQ_TYPE',NULL,NULL,REQ_TYPE) AS REQ_TYPE,
    * 
  FROM 
    POSITION_REQ_TYPE
 <cfif len(attributes.keyword)>
  WHERE
    REQ_TYPE LIKE '%#attributes.keyword#%'
 </cfif>
</cfquery>
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_pos_req_types.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
  <cf_box title="#getLang('','Yeterliliklere Uygun Çalışanlar','55210')#" uidrop="1" hide_table_column="1" closable="0">
    <cfform action="#request.self#?fuseaction=hr.fit_employees" method="post" name="search1">
      <cf_box_elements>
        <cf_flat_list>
          <thead>
            <tr> 
                <th><cf_get_lang dictionary_id='57907.Yetkinlik'></th>
                <th class="header_icn_text" style="width:35px;"><cf_get_lang dictionary_id='58456.Oran' ></th>
                <th class="header_icn_text" style="width:35px;"></th>
            </tr>              
          </thead>
          <tbody>
            <cfif get_pos_req_types.recordcount>
            <cfoutput query="get_pos_req_types" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" >
                    <tr>
                        <td nowrap="nowrap">#REQ_TYPE#</td>
                        <td><input type="text" name="coefficient" id="coefficient" value="" onkeyup="isNumber(this)" style="width:35px;"></td>
                        <td style="text-align:center;"><input type="checkbox" name="type_id" id="type_id" value="#req_type_id#"></td>
                    </tr>
            </cfoutput>
            </tbody>
            <cfelse>
                <tr>
                    <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>	
        </cf_flat_list>

      </cf_box_elements>
      <cf_box_footer>
            <cf_workcube_buttons type_format='1' is_upd='0'insert_info='#getLang('','Uygun Çalışanları Getir','56585')#' is_cancel='0' insert_alert='' add_function='kontrol()'>
      </cf_box_footer>
    </cfform>
  </cf_box>
</div>
<cf_paging page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="hr.list_requirement_types&keyword=#attributes.keyword#">
<script type="text/javascript">
  function kontrol()
  {
	<cfif get_pos_req_types.recordcount eq 1>
		if (!search1.type_id.checked)
		{
		  alert("<cf_get_lang dictionary_id='56866.yeterlilik tanımı yapmadınız kontrol edin'> !");
		  return false;
		  }
		if (!search1.coefficient.value.length)
		{
		  alert("<cf_get_lang dictionary_id='56867.oran tanımı yapmadınız kontrol edin'> !");
		  return false;
		  }
	<cfelseif get_pos_req_types.recordcount gt 1>
		flag = 0;
		for(i=0;i < search1.type_id.length; i++)
		    if (search1.type_id[i].checked)
				flag = 1;

		if (!flag)
			{
			  alert("<cf_get_lang dictionary_id='56868.En az 1 oran tanımı yapmalısınız'> !");
			  return false;
			  }

		for(i=0;i < search1.type_id.length; i++)
		    if ( search1.type_id[i].checked && (!search1.coefficient[i].value.length) )
				{
				  alert((i+1) + ". <cf_get_lang dictionary_id='56867.oran tanımı yapmadınız kontrol edin'> !");
				  return false;
				  }
	</cfif>
  return true;
  }
</script>
