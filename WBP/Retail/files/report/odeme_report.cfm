
<cfparam name="attributes.branch_ids" default="">
<cfset bugun_ = now()>
<cfset base_date_ = bugun_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="" method="post" name="search_">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_wrk_search_button button_type="1" search_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
    <form name="send_" action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>" method="post">
        <input type="hidden" name="startdate" value="<cfoutput>#dateformat(attributes.startdate,'dd.mm.yyyy')#</cfoutput>">
        <input type="hidden" name="finishdate" value="<cfoutput>#dateformat(attributes.finishdate,'dd.mm.yyyy')#</cfoutput>">
        <input type="hidden" name="branch_id" id="branch_id" value="0">
    </form>
    
        <cfquery name="get_ciro_report_cash_odemeler" datasource="#dsn_dev#" result="query_r"> 
            SELECT DISTINCT 
    B2.BRANCH_NAME as BRANCH_NAME,
        RR.KASA_NUMARASI as KASA_NUMARASI ,
        SUM(RT.TYPE_TUTAR) as TYPE_TUTAR
        FROM 
        #dsn_alias#.BRANCH B2, 
        #dsn3_alias#.POS_EQUIPMENT PE2,
        #dsn_dev_alias#.POS_CONS_BANKNOTES RT ,
        #dsn_dev_alias#.POS_CONS RR
        
         WHERE 
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        RT.CON_ID=RR.CON_ID AND 
        PE2.EQUIPMENT_CODE=RR.KASA_NUMARASI AND 
        RR.CON_DATE >= #attributes.startdate# AND
        RR.CON_DATE < #dateadd('d',1,attributes.finishdate)# 
            GROUP BY
            BRANCH_NAME,
            KASA_NUMARASI
    </cfquery>
    <cf_box title="Pos Kasa Nakit Akışı" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                 <th><cf_get_lang dictionary_id='57453.Şube'></th>
                 <th><cf_get_lang dictionary_id='54574.Kasa No'></th>
                 <th><cf_get_lang dictionary_id='57673.Tutar'></th>
             </tr>
            </thead>
            <tbody>
                <cfset odeme_toplam = 0>
                <cfoutput query="get_ciro_report_cash_odemeler">
                <cfset odeme_t_ = TYPE_TUTAR>
                
                <tr>
                    <td>#BRANCH_NAME#</td>
                    <td>#KASA_NUMARASI#</td>
                    <td style="text-align:right;">#tlformat(odeme_t_)#</td>
                </tr>
                <cfset odeme_toplam = odeme_toplam + odeme_t_>
                </cfoutput>
                <cfoutput>
                <tr>
                    <td><cf_get_lang dictionary_id='53263.Toplamlar'></td>
                    <td></td>
                    <td style="text-align:right;">#tlformat(odeme_toplam)#</td>
                </tr>	
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>

<!---<div id="cash_div">
    <cf_date tarih='attributes.startdate'>
    <cf_date tarih='attributes.finishdate'>
</div>--->


<script type="text/javascript">
	function kontrol()
	{
		return date_check(document.getElementById('startdate'),document.getElementById('finishdate'),"<cf_get_lang dictionary_id='56017.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
	}
</script>